"""
Human Inter-Rater Reliability — Krippendorff's alpha + pairwise Cohen's kappa

Context
-------
The label columns in the source data store the **average** of 3 human coders'
binary annotations (e.g., 0.33 = 1 of 3 coders said "1"). Individual coder
vectors are not stored separately, so we reconstruct them from the fractions:
  avg × 3  → integer sum k ∈ {0,1,2,3}
  coder 1 = 1 if k >= 1 else 0
  coder 2 = 1 if k >= 2 else 0
  coder 3 = 1 if k >= 3 else 0
This yields the most conservative distribution (coders agree as much as possible
before disagreeing), which is the standard approach for reconstructing binary
reliability matrices from aggregated fractions.

Binarization of the aggregate (for majority-vote ground truth)
--------------------------------------------------------------
  avg > 0.5  → 1  (strict majority: at least 2 of 3 coders said "1")
  avg <= 0.5 → 0

Input:  ../Data/managerial_leadership_Jordi_Cooper/tags.csv
        (conversation-level, 1458 obs, labels are coder averages)
Output: irr_results/krippendorff_alpha.csv
        irr_results/pairwise_kappa.csv
        irr_results/irr_summary.txt
"""

import numpy as np
import pandas as pd
import krippendorff
from sklearn.metrics import cohen_kappa_score
from pathlib import Path

# ── paths ────────────────────────────────────────────────────────────────────
DATA = (
    Path(__file__).parent.parent
    / "Data"
    / "managerial_leadership_Jordi_Cooper"
    / "tags.csv"
)
OUT = Path(__file__).parent / "irr_results"
OUT.mkdir(exist_ok=True)

# ── label columns ─────────────────────────────────────────────────────────────
LABEL_COLS = [
    "any_suggestion", "suggest_safe", "suggest_efficient", "agree_proposal",
    "discuss_fairness", "discuss_efficient", "discuss_rules", "explanation",
    "discuss_howtoplay", "ask_game", "receive_report",
    "truthful", "falsehood", "contradict", "neither_report",
]
N_CODERS = 3


def reconstruct_coders(avg_series: pd.Series) -> np.ndarray:
    """
    Reconstruct 3 binary coder vectors from a column of averages.
    Returns shape (3, n_items).  NaN propagated where avg is NaN.
    """
    n = len(avg_series)
    coders = np.full((N_CODERS, n), np.nan)
    for i, val in enumerate(avg_series):
        if pd.isna(val):
            continue
        k = int(round(val * N_CODERS))   # number of coders who said "1"
        k = max(0, min(N_CODERS, k))
        for c in range(N_CODERS):
            coders[c, i] = 1.0 if (N_CODERS - c) <= k else 0.0
    return coders


def compute_krippendorff(df: pd.DataFrame) -> pd.DataFrame:
    rows = []
    for label in LABEL_COLS:
        mat = reconstruct_coders(df[label])
        flat = mat[~np.isnan(mat)]
        n_rated = int(np.sum(~np.isnan(mat)))

        if len(np.unique(flat)) < 2:
            alpha = np.nan
            note = "No variance"
        else:
            alpha = krippendorff.alpha(mat, level_of_measurement="nominal")
            note = interpretation(alpha)

        rows.append({
            "label": label,
            "krippendorff_alpha": round(alpha, 4) if not np.isnan(alpha) else np.nan,
            "n_ratings": n_rated,
            "interpretation": note,
        })
    return pd.DataFrame(rows)


def compute_pairwise_kappa(df: pd.DataFrame) -> pd.DataFrame:
    rows = []
    for label in LABEL_COLS:
        mat = reconstruct_coders(df[label])   # shape (3, n_items)
        for c1 in range(N_CODERS):
            for c2 in range(c1 + 1, N_CODERS):
                both = ~(np.isnan(mat[c1]) | np.isnan(mat[c2]))
                y1 = mat[c1][both].astype(int)
                y2 = mat[c2][both].astype(int)
                if len(np.unique(y1)) < 2 or len(np.unique(y2)) < 2:
                    kappa = np.nan
                else:
                    kappa = cohen_kappa_score(y1, y2)
                rows.append({
                    "coder_pair": f"C{c1+1}_C{c2+1}",
                    "label": label,
                    "cohen_kappa": round(kappa, 4) if not np.isnan(kappa) else np.nan,
                    "n_shared": int(both.sum()),
                })
    return pd.DataFrame(rows)


def interpretation(alpha: float) -> str:
    if pd.isna(alpha):
        return "No variance"
    if alpha >= 0.80:
        return "Strong (>=0.80)"
    elif alpha >= 0.67:
        return "Tentative (0.67-0.80)"
    else:
        return "Unreliable (<0.67)"


def write_summary(alpha_df: pd.DataFrame, kappa_df: pd.DataFrame, path: Path) -> None:
    lines = [
        "=" * 72,
        "HUMAN INTER-RATER RELIABILITY",
        "=" * 72,
        "",
        "Method",
        "------",
        "Source file : tags.csv (conversation-level, 1 row per conversation)",
        "Labels      : averages of 3 human coders stored as fractions",
        "              (0.0=0/3, 0.33=1/3, 0.67=2/3, 1.0=3/3)",
        "Reconstruct : avg × 3 → integer k; coder i = 1 if (3-i) <= k",
        "Binarize    : avg > 0.5 → 1  (strict majority: >=2 of 3 coders)",
        "",
        "Krippendorff's Alpha (nominal, 3 coders)",
        "-" * 72,
        f"{'Label':<25} {'Alpha':>8}  {'Interpretation':<28} {'N obs':>6}",
        "-" * 72,
    ]
    for _, row in alpha_df.iterrows():
        a = row["krippendorff_alpha"]
        a_str = f"{a:>8.4f}" if not pd.isna(a) else "     NaN"
        n = row["n_ratings"] // N_CODERS
        lines.append(f"{row['label']:<25} {a_str}  {row['interpretation']:<28} {n:>6}")

    # Pairwise kappa summary: mean over labels per pair
    lines += ["", "Pairwise Cohen's Kappa (mean over labels)", "-" * 72]
    for pair, grp in kappa_df.groupby("coder_pair"):
        mean_k = grp["cohen_kappa"].mean()
        lines.append(f"  {pair}: mean kappa = {mean_k:.4f}  ({len(grp)} labels)")

    lines += [
        "",
        "Krippendorff (2004) thresholds:",
        "  >= 0.80 : strong agreement, suitable for publication",
        "  0.67-0.80: tentative conclusions only",
        "  < 0.67  : do not draw conclusions",
    ]
    path.write_text("\n".join(lines), encoding="utf-8")


def main():
    print("Loading tags.csv...")
    df = pd.read_csv(DATA)
    print(f"  {len(df):,} conversations, {len(LABEL_COLS)} labels")

    print("\nComputing Krippendorff's alpha...")
    alpha_df = compute_krippendorff(df)
    alpha_df.to_csv(OUT / "krippendorff_alpha.csv", index=False)
    print(alpha_df.to_string(index=False))

    print("\nComputing pairwise Cohen's kappa...")
    kappa_df = compute_pairwise_kappa(df)
    kappa_df.to_csv(OUT / "pairwise_kappa.csv", index=False)
    for pair, grp in kappa_df.groupby("coder_pair"):
        print(f"  {pair}: mean kappa = {grp['cohen_kappa'].mean():.4f}")

    write_summary(alpha_df, kappa_df, OUT / "irr_summary.txt")
    print(f"\nResults saved to: {OUT}/")


if __name__ == "__main__":
    main()
