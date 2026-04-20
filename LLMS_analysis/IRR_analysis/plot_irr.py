"""
Visualize IRR results from human_irr.py outputs.
Produces:
  irr_results/krippendorff_alpha_plot.png  — bar chart of alpha per label
  irr_results/pairwise_kappa_heatmap.png   — heatmap of mean kappa per coder pair
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.colors as mcolors
from pathlib import Path

OUT = Path(__file__).parent / "irr_results"


def plot_alpha(alpha_df: pd.DataFrame) -> None:
    fig, ax = plt.subplots(figsize=(10, 5))

    colors = []
    for a in alpha_df["krippendorff_alpha"]:
        if a >= 0.80:
            colors.append("#2ecc71")   # green
        elif a >= 0.67:
            colors.append("#f39c12")   # orange
        else:
            colors.append("#e74c3c")   # red

    bars = ax.barh(alpha_df["label"], alpha_df["krippendorff_alpha"], color=colors)
    ax.axvline(0.80, color="#2ecc71", linestyle="--", linewidth=1, label="Strong (0.80)")
    ax.axvline(0.67, color="#f39c12", linestyle="--", linewidth=1, label="Tentative (0.67)")
    ax.axvline(0.00, color="black", linewidth=0.5)

    ax.set_xlabel("Krippendorff's Alpha")
    ax.set_title("Human Inter-Rater Reliability per Label (Krippendorff's α)")
    ax.legend(loc="lower right")
    ax.set_xlim(-0.3, 1.05)

    for bar, val in zip(bars, alpha_df["krippendorff_alpha"]):
        ax.text(val + 0.01, bar.get_y() + bar.get_height() / 2,
                f"{val:.3f}", va="center", fontsize=8)

    plt.tight_layout()
    plt.savefig(OUT / "krippendorff_alpha_plot.png", dpi=150)
    plt.close()
    print("Saved: krippendorff_alpha_plot.png")


def plot_kappa_heatmap(kappa_df: pd.DataFrame) -> None:
    if kappa_df.empty:
        print("No pairwise kappa data to plot.")
        return

    # Mean kappa per coder pair (averaged over labels), using coder_pair column
    mean_kappa = (
        kappa_df.groupby("coder_pair")["cohen_kappa"]
        .mean()
        .reset_index()
    )
    # coder_pair values like "C1_C2"
    pairs = mean_kappa["coder_pair"].tolist()
    coders = sorted({p for pair in pairs for p in pair.split("_")})

    mat = pd.DataFrame(np.nan, index=coders, columns=coders)
    for _, row in mean_kappa.iterrows():
        c1, c2 = row["coder_pair"].split("_")
        mat.loc[c1, c2] = row["cohen_kappa"]
        mat.loc[c2, c1] = row["cohen_kappa"]
    arr = mat.values.copy()
    np.fill_diagonal(arr, 1.0)
    mat = pd.DataFrame(arr, index=mat.index, columns=mat.columns)

    fig, ax = plt.subplots(figsize=(6, 5))
    cmap = mcolors.LinearSegmentedColormap.from_list(
        "irr", ["#e74c3c", "#f39c12", "#2ecc71"], N=256
    )
    im = ax.imshow(mat.values.astype(float), cmap=cmap, vmin=0, vmax=1, aspect="auto")
    plt.colorbar(im, ax=ax, label="Mean Cohen's Kappa")

    ax.set_xticks(range(len(coders)))
    ax.set_yticks(range(len(coders)))
    ax.set_xticklabels(coders, fontsize=9)
    ax.set_yticklabels(coders, fontsize=9)

    # Annotate cells
    for i, ci in enumerate(coders):
        for j, cj in enumerate(coders):
            val = mat.loc[ci, cj]
            if not np.isnan(val):
                ax.text(j, i, f"{val:.3f}", ha="center", va="center", fontsize=9)

    ax.set_title("Mean Pairwise Cohen's Kappa (averaged over labels)")
    plt.tight_layout()
    plt.savefig(OUT / "pairwise_kappa_heatmap.png", dpi=150)
    plt.close()
    print("Saved: pairwise_kappa_heatmap.png")


def main():
    alpha_df = pd.read_csv(OUT / "krippendorff_alpha.csv")
    kappa_df  = pd.read_csv(OUT / "pairwise_kappa.csv")

    plot_alpha(alpha_df)
    plot_kappa_heatmap(kappa_df)


if __name__ == "__main__":
    main()
