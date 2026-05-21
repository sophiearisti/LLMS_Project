"""
LLM Internal Consistency — Krippendorff's alpha treating temperatures as raters

For each (LLM, paper, strategy) combination, each temperature run is treated
as an independent "expert/rater". Predictions are binarized (> 0.5 → 1, else 0)
and Krippendorff's alpha is computed across temperature raters per label.

High alpha: LLM produces consistent classifications regardless of temperature.
Low alpha:  temperature setting substantially changes the LLM's decisions.

Output: irr_results/llm_irr_alpha.csv
        irr_results/llm_irr_summary.txt
"""

import re
import numpy as np
import pandas as pd
import krippendorff
from pathlib import Path

# ── paths ─────────────────────────────────────────────────────────────────────
RESULTS = Path(__file__).parent.parent / "Results"
OUT = Path(__file__).parent / "irr_results"
OUT.mkdir(exist_ok=True)

# ── label sets per paper ───────────────────────────────────────────────────────
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


def interpretation(alpha: float) -> str:
    if pd.isna(alpha):
        return "No variance / insufficient data"
    if alpha >= 0.80:
        return "Strong (>=0.80)"
    elif alpha >= 0.67:
        return "Tentative (0.67-0.80)"
    else:
        return "Unreliable (<0.67)"


def binarize(series: pd.Series) -> pd.Series:
    """Binarize: > 0.5 → 1, else 0. NaN stays NaN."""
    return series.map(lambda v: np.nan if pd.isna(v) else (1.0 if v > 0.5 else 0.0))


def load_temp_files(llm: str, paper: str, strategy: str) -> dict[str, pd.DataFrame]:
    """
    Returns {temp_str: df} for all temperature result files found.
    Uses results_line_batch_* files (produced by batch API), falling back
    to results_line_* (regular line-by-line).
    """
    folder = RESULTS / llm / paper / strategy
    if not folder.exists():
        return {}

    # Accept: results_line_batch_temp*, results_line_temp*, results_temp*
    # Prefer batch files when multiple files share the same temp.
    found: dict[str, Path] = {}
    for f in sorted(folder.iterdir()):
        if not f.name.endswith(".csv"):
            continue
        if not re.match(r"results_(line_)?(batch_)?temp", f.name):
            continue
        m = re.search(r"temp([\d.]+)", f.name)
        if not m:
            continue
        temp = m.group(1)
        if temp not in found or "batch" in f.name:
            found[temp] = f

    dfs = {}
    for temp, path in found.items():
        df = pd.read_csv(path)
        if "row_id" not in df.columns:
            # Some older exports (notably GPT trust-promises) omit row_id.
            # Fall back to positional index to preserve temperature alignment.
            df = df.copy()
            df["row_id"] = np.arange(len(df))
        # deduplicate row_ids if any (keep first occurrence)
        df = df.drop_duplicates(subset="row_id", keep="first")
        dfs[temp] = df.set_index("row_id")
    return dfs


def compute_alpha_across_temps(
    temp_dfs: dict[str, pd.DataFrame],
    labels: list[str],
) -> pd.DataFrame:
    """
    Build a (n_temps × n_items) reliability matrix per label and compute alpha.
    Temperatures with < 2 items in common are skipped.
    """
    temps = sorted(temp_dfs.keys(), key=lambda x: float(x))
    if len(temps) < 2:
        return pd.DataFrame()

    # common row_ids across all temperatures
    common_ids = set(temp_dfs[temps[0]].index)
    for t in temps[1:]:
        common_ids &= set(temp_dfs[t].index)
    common_ids = sorted(common_ids)

    if len(common_ids) < 2:
        return pd.DataFrame()

    rows = []
    for label in labels:
        # build reliability matrix: shape (n_temps, n_items)
        mat = []
        for t in temps:
            df = temp_dfs[t]
            if label not in df.columns:
                continue
            col = binarize(df.loc[common_ids, label])
            mat.append(col.values)

        if len(mat) < 2:
            rows.append({
                "label": label, "n_raters": 0,
                "krippendorff_alpha": np.nan,
                "n_items": len(common_ids),
                "interpretation": "Insufficient raters",
            })
            continue

        mat = np.array(mat, dtype=float)  # (n_temps, n_items)

        flat_valid = mat[~np.isnan(mat)]
        if len(np.unique(flat_valid)) < 2:
            alpha = np.nan
            note = "No variance"
        else:
            alpha = krippendorff.alpha(mat, level_of_measurement="nominal")
            note = interpretation(alpha)

        rows.append({
            "label": label,
            "n_raters": len(mat),
            "krippendorff_alpha": round(float(alpha), 4) if not np.isnan(alpha) else np.nan,
            "n_items": len(common_ids),
            "interpretation": note,
        })
    return pd.DataFrame(rows)


def run_all() -> pd.DataFrame:
    all_rows = []
    for llm in LLMS:
        for paper, labels in PAPER_LABELS.items():
            for strategy in STRATEGIES:
                temp_dfs = load_temp_files(llm, paper, strategy)
                if len(temp_dfs) < 2:
                    continue
                alpha_df = compute_alpha_across_temps(temp_dfs, labels)
                if alpha_df.empty:
                    continue
                temps_used = sorted(temp_dfs.keys(), key=float)
                alpha_df.insert(0, "llm", llm)
                alpha_df.insert(1, "paper", paper)
                alpha_df.insert(2, "strategy", strategy)
                alpha_df.insert(3, "temps", str(temps_used))
                all_rows.append(alpha_df)
                print(
                    f"  {llm}/{paper}/{strategy}: "
                    f"{len(temp_dfs)} temps, "
                    f"mean alpha = {alpha_df['krippendorff_alpha'].mean():.4f}"
                )

    if not all_rows:
        print("No data found.")
        return pd.DataFrame()
    return pd.concat(all_rows, ignore_index=True)


def write_summary(df: pd.DataFrame, path: Path) -> None:
    lines = [
        "=" * 80,
        "LLM INTERNAL CONSISTENCY — Krippendorff's Alpha (temperatures as raters)",
        "=" * 80,
        "",
        "Each temperature setting is treated as an independent rater.",
        "Predictions are binarized: > 0.5 → 1, else 0.",
        "High alpha → LLM is temperature-insensitive (consistent across runs).",
        "Low alpha  → temperature substantially changes classification decisions.",
        "",
        "Thresholds (Krippendorff 2004):",
        "  >= 0.80 : strong agreement",
        "  0.67-0.80: tentative conclusions",
        "  < 0.67  : unreliable",
        "",
    ]

    for (llm, paper, strategy), grp in df.groupby(["llm", "paper", "strategy"]):
        temps = grp["temps"].iloc[0]
        n_raters = grp["n_raters"].iloc[0]
        n_items = grp["n_items"].iloc[0]
        mean_a = grp["krippendorff_alpha"].mean()
        median_a = grp["krippendorff_alpha"].median()

        lines += [
            f"LLM: {llm.upper()}  |  Paper: {paper}  |  Strategy: {strategy}",
            f"  Temperatures (raters): {temps}   N_raters={n_raters}   N_items={n_items}",
            f"  Mean alpha across labels : {mean_a:.4f}",
            f"  Median alpha across labels: {median_a:.4f}",
            "-" * 80,
            f"  {'Label':<30} {'Alpha':>8}  {'Interpretation'}",
            "-" * 80,
        ]
        for _, row in grp.sort_values("krippendorff_alpha", ascending=False).iterrows():
            a = row["krippendorff_alpha"]
            a_str = f"{a:>8.4f}" if not pd.isna(a) else "     NaN"
            lines.append(f"  {row['label']:<30} {a_str}  {row['interpretation']}")
        lines.append("")

    # Cross-LLM summary per paper
    lines += [
        "=" * 80,
        "CROSS-LLM SUMMARY — mean alpha by (LLM, strategy) per paper",
        "=" * 80,
    ]
    pivot = df.groupby(["paper", "llm", "strategy"])["krippendorff_alpha"].mean().round(4).unstack("strategy")
    lines.append(pivot.to_string())

    path.write_text("\n".join(lines), encoding="utf-8")


def main():
    print("Computing Krippendorff's alpha treating LLM temperatures as raters...\n")
    df = run_all()
    if df.empty:
        return

    df.to_csv(OUT / "llm_irr_alpha.csv", index=False)
    write_summary(df, OUT / "llm_irr_summary.txt")

    print(f"\nResults saved to {OUT}/")
    print("\nOverall mean alpha by LLM and strategy:")
    summary = df.groupby(["llm", "strategy"])["krippendorff_alpha"].agg(["mean", "median", "count"])
    summary.columns = ["mean_alpha", "median_alpha", "n_labels"]
    print(summary.to_string())

    print("\nMean alpha by paper (all strategies):")
    paper_summary = df.groupby(["llm", "paper"])["krippendorff_alpha"].mean().round(4)
    print(paper_summary.to_string())


if __name__ == "__main__":
    main()
