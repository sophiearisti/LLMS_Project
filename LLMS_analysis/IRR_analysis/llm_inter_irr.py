"""
Inter-LLM Reliability — Krippendorff's alpha comparing LLMs as raters

For each (paper, strategy), each LLM at temperature=0 is treated as an
independent rater. Predictions are binarized (> 0.5 → 1, else 0) and
Krippendorff's alpha is computed per label across the available LLMs.

High alpha: LLMs agree on classifications → categories are well-defined
Low alpha:  LLMs disagree → categories are interpretively ambiguous

Output: irr_results/inter_llm_alpha.csv
        irr_results/inter_llm_summary.txt
"""

import re
import unicodedata
import numpy as np
import pandas as pd
import krippendorff
from pathlib import Path

# ── paths ─────────────────────────────────────────────────────────────────────
RESULTS = Path(__file__).parent.parent / "Results"
OUT = Path(__file__).parent / "irr_results"
OUT.mkdir(exist_ok=True)

PAPER_LABELS = {
    "managerial_leadership_Jordi_Cooper": [
        "any_suggestion", "suggest_safe", "suggest_efficient", "agree_proposal",
        "discuss_fairness", "discuss_efficient", "discuss_rules", "explanation",
        "discuss_howtoplay", "ask_game", "receive_report",
        "truthful", "falsehood", "contradict", "neither_report",
    ],
    "trust_promises_Ederer_Schneider": [
        "is_promise", "is_efficiency", "is_ethics",
    ],
    "under_reporting_Ling_Kale_Imas": [
        "uninformative", "SDB", "overest_others", "underest_own",
        "academic_integrity", "info_asymmetry", "AI_discussion_priming",
        "privacy_concerns", "self_esteem", "self_report_bias",
        "network_effect", "truthful",
    ],
}

LLMS = ["claude", "gpt", "gemini"]
STRATEGIES = ["0shot", "fewshot"]
REPRESENTATIVE_TEMP = "0"


def normalize_msg(s: str) -> str:
    s = str(s).strip()
    s = unicodedata.normalize("NFKC", s)
    return re.sub(r"\s+", " ", s).lower()


def binarize(series: pd.Series) -> pd.Series:
    return series.map(lambda v: np.nan if pd.isna(v) else (1.0 if v > 0.5 else 0.0))


def load_representative(llm: str, paper: str, strategy: str) -> pd.DataFrame | None:
    """
    Load temperature=0 prediction file for (llm, paper, strategy).
    Returns the raw DataFrame (before indexing) with a '_key_rowid' flag
    indicating whether row_id is present.
    Returns None if no matching file is found.
    """
    folder = RESULTS / llm / paper / strategy
    if not folder.exists():
        return None

    candidates = []
    for f in folder.iterdir():
        if not f.name.endswith(".csv"):
            continue
        if not re.match(r"results_(line_)?(batch_)?temp", f.name):
            continue
        m = re.search(r"temp([\d.]+)", f.name)
        if m and m.group(1) == REPRESENTATIVE_TEMP:
            candidates.append(f)

    if not candidates:
        return None

    candidates.sort(key=lambda f: (0 if "batch" in f.name else 1))
    df = pd.read_csv(candidates[0])

    # deduplicate on best available key
    if "row_id" in df.columns:
        df = df.drop_duplicates(subset="row_id", keep="first")
    elif "original_message" in df.columns:
        df = df.drop_duplicates(subset="original_message", keep="first")

    return df


def _set_index(df: pd.DataFrame, use_message: bool) -> pd.DataFrame | None:
    """Index df by row_id or normalized original_message; dedup the index."""
    if use_message:
        if "original_message" not in df.columns:
            return None
        df = df.copy()
        df.index = df["original_message"].map(normalize_msg)
    else:
        if "row_id" not in df.columns:
            return None
        df = df.copy()
        df.index = df["row_id"].astype(str)
    # remove any residual duplicate keys after normalization
    df = df[~df.index.duplicated(keep="first")]
    return df


def compute_inter_llm_alpha(
    paper: str,
    strategy: str,
    labels: list[str],
) -> pd.DataFrame | None:
    """
    Load temp=0 for each LLM, align on common items, compute alpha per label.
    Uses row_id alignment if ALL LLMs have it; falls back to original_message.
    Returns a DataFrame with one row per label, or None if < 2 LLMs available.
    """
    raw: dict[str, pd.DataFrame] = {}
    for llm in LLMS:
        df = load_representative(llm, paper, strategy)
        if df is not None:
            raw[llm] = df

    if len(raw) < 2:
        return None

    available_llms = list(raw.keys())

    # decide alignment key: row_id if all have it, else original_message
    all_have_rowid = all("row_id" in raw[llm].columns for llm in available_llms)
    use_message = not all_have_rowid

    llm_dfs: dict[str, pd.DataFrame] = {}
    for llm in available_llms:
        indexed = _set_index(raw[llm], use_message=use_message)
        if indexed is not None:
            llm_dfs[llm] = indexed

    if len(llm_dfs) < 2:
        return None

    available_llms = list(llm_dfs.keys())

    # common items across all loaded LLMs
    common_keys = set(llm_dfs[available_llms[0]].index)
    for llm in available_llms[1:]:
        common_keys &= set(llm_dfs[llm].index)
    common_keys = sorted(common_keys)

    if len(common_keys) < 2:
        return None

    rows = []
    for label in labels:
        mat = []
        for llm in available_llms:
            df = llm_dfs[llm]
            if label not in df.columns:
                continue
            col = binarize(df.loc[common_keys, label])
            mat.append(col.values)

        if len(mat) < 2:
            rows.append({
                "label": label, "raters": str(available_llms),
                "n_raters": 0, "n_items": len(common_keys),
                "krippendorff_alpha": np.nan,
                "interpretation": "Insufficient raters",
            })
            continue

        mat_arr = np.array(mat, dtype=float)
        flat_valid = mat_arr[~np.isnan(mat_arr)]

        if len(np.unique(flat_valid)) < 2:
            alpha = np.nan
            note = "No variance"
        else:
            alpha = krippendorff.alpha(mat_arr, level_of_measurement="nominal")
            note = interpretation(float(alpha))

        rows.append({
            "label": label,
            "raters": str(available_llms),
            "n_raters": len(mat),
            "n_items": len(common_keys),
            "krippendorff_alpha": round(float(alpha), 4) if not np.isnan(alpha) else np.nan,
            "interpretation": note,
        })

    return pd.DataFrame(rows)


def interpretation(alpha: float) -> str:
    if pd.isna(alpha):
        return "No variance / insufficient data"
    if alpha >= 0.80:
        return "Strong (>=0.80)"
    elif alpha >= 0.67:
        return "Tentative (0.67-0.80)"
    else:
        return "Unreliable (<0.67)"


def run_all() -> pd.DataFrame:
    all_rows = []
    for paper, labels in PAPER_LABELS.items():
        for strategy in STRATEGIES:
            result = compute_inter_llm_alpha(paper, strategy, labels)
            if result is None or result.empty:
                continue
            raters = result["raters"].iloc[0]
            n = result["n_raters"].iloc[0]
            n_items = result["n_items"].iloc[0]
            mean_a = result["krippendorff_alpha"].mean()
            print(
                f"  {paper}/{strategy}: "
                f"raters={raters}  n_items={n_items}  "
                f"mean alpha={mean_a:.4f}"
            )
            result.insert(0, "paper", paper)
            result.insert(1, "strategy", strategy)
            all_rows.append(result)

    if not all_rows:
        print("No data found.")
        return pd.DataFrame()
    return pd.concat(all_rows, ignore_index=True)


def write_summary(df: pd.DataFrame, path: Path) -> None:
    lines = [
        "=" * 80,
        "INTER-LLM RELIABILITY — Krippendorff's Alpha (LLMs as raters, temp=0)",
        "=" * 80,
        "",
        "Each LLM at temperature=0 is treated as an independent rater.",
        "Predictions are binarized: > 0.5 → 1, else 0.",
        "High alpha → LLMs agree on classifications (well-defined categories).",
        "Low alpha  → LLMs disagree (interpretively ambiguous categories).",
        "",
        "Thresholds (Krippendorff 2004):",
        "  >= 0.80 : strong agreement",
        "  0.67-0.80: tentative",
        "  < 0.67  : unreliable",
        "",
    ]

    for (paper, strategy), grp in df.groupby(["paper", "strategy"]):
        raters = grp["raters"].iloc[0]
        n_items = grp["n_items"].iloc[0]
        mean_a = grp["krippendorff_alpha"].mean()
        median_a = grp["krippendorff_alpha"].median()

        lines += [
            f"Paper: {paper}  |  Strategy: {strategy}",
            f"  Raters (LLMs): {raters}   N_items={n_items}",
            f"  Mean alpha  : {mean_a:.4f}",
            f"  Median alpha: {median_a:.4f}",
            "-" * 80,
            f"  {'Label':<30} {'Alpha':>8}  {'Interpretation'}",
            "-" * 80,
        ]
        for _, row in grp.sort_values("krippendorff_alpha", ascending=False).iterrows():
            a = row["krippendorff_alpha"]
            a_str = f"{a:>8.4f}" if not pd.isna(a) else "     NaN"
            lines.append(f"  {row['label']:<30} {a_str}  {row['interpretation']}")
        lines.append("")

    # Summary pivot
    lines += [
        "=" * 80,
        "SUMMARY — mean inter-LLM alpha by (paper, strategy)",
        "=" * 80,
    ]
    pivot = (
        df.groupby(["paper", "strategy"])["krippendorff_alpha"]
        .mean()
        .round(4)
        .unstack("strategy")
    )
    lines.append(pivot.to_string())

    path.write_text("\n".join(lines), encoding="utf-8")


def main():
    print("Computing inter-LLM Krippendorff's alpha (LLMs as raters, temp=0)...\n")
    df = run_all()
    if df.empty:
        return

    df.to_csv(OUT / "inter_llm_alpha.csv", index=False)
    write_summary(df, OUT / "inter_llm_summary.txt")

    print(f"\nResults saved to {OUT}/")
    print("\nMean inter-LLM alpha by (paper, strategy):")
    pivot = (
        df.groupby(["paper", "strategy"])["krippendorff_alpha"]
        .mean()
        .round(4)
        .unstack("strategy")
    )
    print(pivot.to_string())


if __name__ == "__main__":
    main()
