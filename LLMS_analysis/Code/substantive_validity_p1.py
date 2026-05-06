"""
Substantive validity analysis for Paper 1 (Brandts & Cooper, 2025).

Reproduces Table 6 from the paper (frequency of coding categories by treatment)
using LLM-coded labels instead of human codes, and compares the two.

Output saved to:
  Results/by_paper/managerial_leadership_Jordi_Cooper/
    table6_reproduction.csv
    table7_reproduction.csv  (truth-telling by game state)
    table6_reproduction.pdf/.png
    table7_reproduction.pdf/.png
"""

import os
import sys
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches

# ── paths ──────────────────────────────────────────────────────────────────────
SCRIPT_DIR  = os.path.dirname(os.path.abspath(__file__))
BASE_DIR    = os.path.dirname(SCRIPT_DIR)
DATA_DIR    = os.path.join(BASE_DIR, "Data",    "managerial_leadership_Jordi_Cooper")
RESULTS_DIR = os.path.join(BASE_DIR, "Results")
OUT_DIR     = os.path.join(RESULTS_DIR, "by_paper", "managerial_leadership_Jordi_Cooper")
os.makedirs(OUT_DIR, exist_ok=True)

# ── category columns we care about ────────────────────────────────────────────
CATEGORIES = [
    "any_suggestion", "suggest_safe", "suggest_efficient", "agree_proposal",
    "discuss_fairness", "discuss_efficient", "discuss_rules", "explanation",
    "ask_game", "receive_report", "truthful", "falsehood",
    "neither_report",
]

# categories that are N/A in CH/S-D (no manager messages)
MANAGER_ONLY = {"ask_game"}

# treatments to report (in display order)
TREATMENTS   = ["CH/S-D", "CH/A-D", "CH-MC"]
TREATMENT_LABELS = {"CH/S-D": "CH/S-D", "CH/A-D": "CH/A-D", "CH-MC": "CH-MC"}

# paper's Table 6 values (human benchmark, % expressed as fractions 0-1)
# N/A encoded as NaN
TABLE6_HUMAN = {
    "any_suggestion":    {"CH/S-D": 0.931, "CH/A-D": 0.733, "CH-MC": 0.907},
    "suggest_safe":      {"CH/S-D": 0.541, "CH/A-D": 0.376, "CH-MC": 0.606},
    "suggest_efficient": {"CH/S-D": 0.484, "CH/A-D": 0.410, "CH-MC": 0.577},
    "agree_proposal":    {"CH/S-D": 0.789, "CH/A-D": 0.540, "CH-MC": 0.679},
    "discuss_fairness":  {"CH/S-D": 0.318, "CH/A-D": 0.346, "CH-MC": 0.439},
    "discuss_efficient": {"CH/S-D": 0.394, "CH/A-D": 0.160, "CH-MC": 0.377},
    "discuss_rules":     {"CH/S-D": 0.117, "CH/A-D": 0.088, "CH-MC": 0.150},
    "explanation":       {"CH/S-D": 0.217, "CH/A-D": 0.393, "CH-MC": 0.323},
    "ask_game":          {"CH/S-D": np.nan, "CH/A-D": 0.149, "CH-MC": 0.194},
    "receive_report":    {"CH/S-D": np.nan, "CH/A-D": np.nan, "CH-MC": np.nan},
    "truthful":          {"CH/S-D": np.nan, "CH/A-D": 0.288, "CH-MC": 0.684},
    "falsehood":         {"CH/S-D": np.nan, "CH/A-D": 0.000, "CH-MC": 0.034},
    "neither_report":    {"CH/S-D": np.nan, "CH/A-D": np.nan, "CH-MC": np.nan},
}

# best-config raw classification files per model
BEST_CONFIGS = {
    "Claude": os.path.join(RESULTS_DIR, "claude", "managerial_leadership_Jordi_Cooper",
                           "0shot", "results_line_batch_temp0.1_modeuser.csv"),
    "Gemini": os.path.join(RESULTS_DIR, "gemini", "managerial_leadership_Jordi_Cooper",
                           "fewshot", "results_temp0_modeuser.csv"),
    "GPT":    os.path.join(RESULTS_DIR, "gpt",    "managerial_leadership_Jordi_Cooper",
                           "fewshot", "results_temp0_modeuser.csv"),
}


# ── load data ──────────────────────────────────────────────────────────────────

def load_classify():
    """Load classify.csv; row index = row_id."""
    df = pd.read_csv(os.path.join(DATA_DIR, "classify.csv"))
    df.index = range(len(df))     # ensure 0-based index = row_id
    df.index.name = "row_id"
    return df[["session", "period", "group", "game"]].reset_index()


def load_tags():
    """Load tags.csv — conversation-level human codes + treatment + game state."""
    df = pd.read_csv(os.path.join(DATA_DIR, "tags.csv"))
    df = df.rename(columns={"true_treatment_ordered": "treatment"})
    # keep only chat treatments
    df = df[df["treatment"].isin(TREATMENTS)].copy()
    return df


def normalize_binary(series):
    """Convert averaged coder fractions → binary (≥0.5 → 1, else 0)."""
    return (pd.to_numeric(series, errors="coerce").fillna(0) >= 0.5).astype(int)


def load_llm_results(model_name, path):
    """Load raw LLM classification CSV and binarize predictions."""
    if not os.path.exists(path):
        print(f"  WARNING: file not found for {model_name}: {path}")
        return None
    df = pd.read_csv(path)
    # binarize numeric predictions
    for col in CATEGORIES:
        if col in df.columns:
            df[col] = (pd.to_numeric(df[col], errors="coerce").fillna(0) >= 0.5).astype(int)
    return df


# ── build merged dataset ───────────────────────────────────────────────────────

def build_merged(classify_df, tags_df, llm_results: dict):
    """
    Merge classify → tags (via session/period/group/game) to get treatment labels
    and human codes. Then attach LLM predictions.

    classify.csv has multiple rows per conversation (message blocks per speaker).
    LLM results are at the same row level. We aggregate to conversation level
    using OR logic: if ANY block in a conversation has category=1 → conversation=1.

    Returns a dict: {"Human": df, "Claude": df, ...} where each df has
    columns [treatment, game, *CATEGORIES], one row per conversation.
    """
    merge_keys = ["session", "period", "group", "game"]

    # human codes: restrict to the 96 conversations in classify, binarize fractions
    human_df = tags_df.merge(
        classify_df[merge_keys].drop_duplicates(), on=merge_keys, how="inner"
    ).copy()
    for col in CATEGORIES:
        if col in human_df.columns:
            human_df[col] = normalize_binary(human_df[col])
        else:
            human_df[col] = np.nan
    human_df = human_df[["treatment", "game"] + CATEGORIES].copy()

    datasets = {"Human": human_df}

    for model, llm_df in llm_results.items():
        if llm_df is None:
            continue

        # keep only row_ids present in classify (handles GPT 233-row case)
        valid_ids = classify_df["row_id"].values
        llm_df = llm_df[llm_df["row_id"].isin(valid_ids)].copy()

        # merge row_id → conversation keys
        merged = classify_df[merge_keys + ["row_id"]].merge(
            llm_df[["row_id"] + [c for c in CATEGORIES if c in llm_df.columns]],
            on="row_id", how="inner"
        )

        # aggregate to conversation level: OR across message blocks (max)
        agg_dict = {c: "max" for c in CATEGORIES if c in merged.columns}
        conv_df = merged.groupby(merge_keys, as_index=False).agg(agg_dict)

        # join treatment from tags
        conv_df = conv_df.merge(
            tags_df[merge_keys + ["treatment"]].drop_duplicates(merge_keys),
            on=merge_keys, how="inner"
        )
        conv_df = conv_df[["treatment", "game"] + CATEGORIES].copy()
        datasets[model] = conv_df

    return datasets


# ── Table 6: treatment-level means ────────────────────────────────────────────

def compute_table6(datasets):
    """
    Returns a DataFrame with MultiIndex (category, treatment) and
    columns = coder names. Values = mean rate (0-1).
    """
    records = []
    for coder, df in datasets.items():
        for cat in CATEGORIES:
            if cat not in df.columns:
                continue
            for trt in TREATMENTS:
                sub = df[df["treatment"] == trt][cat]
                sub_num = pd.to_numeric(sub, errors="coerce").dropna()
                val = sub_num.mean() if len(sub_num) > 0 else np.nan
                records.append({"coder": coder, "category": cat,
                                 "treatment": trt, "rate": val})
    return pd.DataFrame(records)


# ── Table 7: truth-telling by game state ──────────────────────────────────────

def compute_table7(datasets):
    """
    Truth-telling (truthful) and lying (falsehood) by game state in CH-MC only.
    Returns DataFrame with columns: coder, game, truthful_rate, falsehood_rate.
    """
    records = []
    for coder, df in datasets.items():
        sub = df[df["treatment"] == "CH-MC"].copy()
        for g in sorted(sub["game"].dropna().unique()):
            g_df = sub[sub["game"] == g]
            for col in ["truthful", "falsehood"]:
                if col not in g_df.columns:
                    continue
                vals = pd.to_numeric(g_df[col], errors="coerce").dropna()
                records.append({
                    "coder": coder, "game": int(g), "category": col,
                    "rate": vals.mean() if len(vals) > 0 else np.nan,
                    "n": len(vals),
                })
    return pd.DataFrame(records)


# ── plotting ───────────────────────────────────────────────────────────────────

CODER_COLORS = {
    "Human":  "#555555",
    "Claude": "#ff6361",
    "Gemini": "#bc5090",
    "GPT":    "#003f5c",
}

def plot_table6(t6_df, out_stem):
    """
    Small-multiple bar chart: one panel per category,
    bars = treatment, colors = coder; horizontal grey line = paper's Table 6 value.
    Focus on categories with clear Table 6 human benchmark.
    """
    focus = [c for c in CATEGORIES if any(
        not np.isnan(v) for v in TABLE6_HUMAN.get(c, {}).values()
    )]

    coders = [c for c in ["Human", "Claude", "Gemini", "GPT"]
              if c in t6_df["coder"].unique()]
    n_cats = len(focus)
    ncols  = 3
    nrows  = int(np.ceil(n_cats / ncols))

    fig, axes = plt.subplots(nrows, ncols, figsize=(14, 3.5 * nrows),
                             sharey=False, constrained_layout=True)
    axes_flat = axes.flatten() if n_cats > 1 else [axes]

    bar_width  = 0.18
    x_trt      = np.arange(len(TREATMENTS))

    for idx, cat in enumerate(focus):
        ax = axes_flat[idx]

        # paper's Table 6 human reference line
        for ti, trt in enumerate(TREATMENTS):
            ref = TABLE6_HUMAN.get(cat, {}).get(trt, np.nan)
            if not np.isnan(ref):
                ax.plot([ti - 0.4, ti + 0.4], [ref, ref],
                        color="black", linewidth=1.8, linestyle="--",
                        zorder=3)

        for ci, coder in enumerate(coders):
            sub = t6_df[(t6_df["coder"] == coder) & (t6_df["category"] == cat)]
            vals = []
            for trt in TREATMENTS:
                row = sub[sub["treatment"] == trt]
                vals.append(row["rate"].values[0] if len(row) > 0 else np.nan)
            offset = (ci - (len(coders) - 1) / 2) * bar_width
            bars = ax.bar(x_trt + offset, vals, bar_width,
                          color=CODER_COLORS.get(coder, "grey"),
                          alpha=0.85, label=coder, zorder=2)

        ax.set_xticks(x_trt)
        ax.set_xticklabels(TREATMENTS, fontsize=8, rotation=15, ha="right")
        ax.set_ylim(0, 1.05)
        ax.set_ylabel("Mean rate", fontsize=8)
        ax.set_title(cat.replace("_", " "), fontsize=9, fontweight="bold")
        ax.yaxis.grid(True, linewidth=0.4, color="grey", alpha=0.5)
        ax.set_axisbelow(True)

    # hide empty panels
    for idx in range(n_cats, len(axes_flat)):
        axes_flat[idx].set_visible(False)

    # legend
    handles = [mpatches.Patch(color=CODER_COLORS[c], label=c) for c in coders]
    handles.append(plt.Line2D([0], [0], color="black", linewidth=1.8,
                               linestyle="--", label="Paper Table 6 (human)"))
    fig.legend(handles=handles, loc="lower center",
               ncol=len(handles), fontsize=9,
               bbox_to_anchor=(0.5, -0.04), frameon=False)

    fig.suptitle("Table 6 Reproduction: Category Rates by Treatment\n"
                 "Brandts & Cooper (2025) — LLM best-config vs. human codes",
                 fontsize=11, fontweight="bold")

    fig.savefig(out_stem + ".pdf", bbox_inches="tight")
    fig.savefig(out_stem + ".png", dpi=150, bbox_inches="tight")
    plt.close(fig)
    print(f"Saved: {out_stem}.pdf/.png")


def plot_table7(t7_df, out_stem):
    """Truth-telling and lying by game state in CH-MC."""
    coders = [c for c in ["Human", "Claude", "Gemini", "GPT"]
              if c in t7_df["coder"].unique()]
    games  = sorted(t7_df["game"].dropna().unique().astype(int))

    fig, axes = plt.subplots(1, 2, figsize=(11, 4), constrained_layout=True)

    for ax, cat in zip(axes, ["truthful", "falsehood"]):
        sub = t7_df[t7_df["category"] == cat]
        x   = np.arange(len(games))
        bar_width = 0.18
        for ci, coder in enumerate(coders):
            c_sub = sub[sub["coder"] == coder]
            vals  = [c_sub[c_sub["game"] == g]["rate"].values[0]
                     if len(c_sub[c_sub["game"] == g]) > 0 else np.nan
                     for g in games]
            offset = (ci - (len(coders) - 1) / 2) * bar_width
            ax.bar(x + offset, vals, bar_width,
                   color=CODER_COLORS.get(coder, "grey"),
                   alpha=0.85, label=coder)

        ax.set_xticks(x)
        ax.set_xticklabels([f"γ={g}" for g in games], fontsize=9)
        ax.set_ylim(0, 1.05)
        ax.set_ylabel("Mean rate", fontsize=9)
        ax.set_title(f"CH-MC: {cat} by game state", fontsize=10, fontweight="bold")
        ax.yaxis.grid(True, linewidth=0.4, color="grey", alpha=0.5)
        ax.set_axisbelow(True)

    handles = [mpatches.Patch(color=CODER_COLORS[c], label=c) for c in coders]
    fig.legend(handles=handles, loc="lower center", ncol=len(handles),
               fontsize=9, bbox_to_anchor=(0.5, -0.06), frameon=False)
    fig.suptitle("Table 7 Reproduction: Truth-telling by Game State (CH-MC)\n"
                 "Brandts & Cooper (2025) — LLM best-config vs. human codes",
                 fontsize=11, fontweight="bold")

    fig.savefig(out_stem + ".pdf", bbox_inches="tight")
    fig.savefig(out_stem + ".png", dpi=150, bbox_inches="tight")
    plt.close(fig)
    print(f"Saved: {out_stem}.pdf/.png")


# ── main ───────────────────────────────────────────────────────────────────────

def main():
    print("Loading data...")
    classify_df = load_classify()
    tags_df     = load_tags()

    print(f"  classify.csv: {len(classify_df)} rows")
    print(f"  tags.csv (chat treatments): {len(tags_df)} rows")
    print(f"  Treatment counts:\n{tags_df['treatment'].value_counts().to_string()}")

    print("\nLoading LLM results...")
    llm_results = {}
    for model, path in BEST_CONFIGS.items():
        df = load_llm_results(model, path)
        if df is not None:
            print(f"  {model}: {len(df)} rows from {os.path.basename(path)}")
            llm_results[model] = df

    print("\nMerging...")
    datasets = build_merged(classify_df, tags_df, llm_results)
    for coder, df in datasets.items():
        print(f"  {coder}: {len(df)} rows, treatments: "
              f"{df['treatment'].value_counts().to_dict()}")

    # ── Table 6 ──
    print("\nComputing Table 6 (treatment-level means)...")
    t6_df = compute_table6(datasets)

    # print verification: human codes should match paper
    print("\n  Verification — Human codes vs. paper Table 6:")
    for cat in ["truthful", "suggest_safe", "any_suggestion"]:
        for trt in TREATMENTS:
            row = t6_df[(t6_df["coder"] == "Human") &
                        (t6_df["category"] == cat) &
                        (t6_df["treatment"] == trt)]
            computed = row["rate"].values[0] if len(row) > 0 else np.nan
            paper    = TABLE6_HUMAN.get(cat, {}).get(trt, np.nan)
            diff     = abs(computed - paper) if not np.isnan(paper) else np.nan
            flag     = "  <-- CHECK" if (not np.isnan(diff) and diff > 0.05) else ""
            print(f"    {cat:<20} {trt:<10}  computed={computed:.3f}  "
                  f"paper={paper:.3f}  diff={diff:.3f}{flag}"
                  if not np.isnan(diff) else
                  f"    {cat:<20} {trt:<10}  computed={computed:.3f}  paper=N/A")

    # save CSV
    csv_path = os.path.join(OUT_DIR, "table6_reproduction.csv")
    # pivot to wide format: rows = category × treatment, cols = coder
    t6_pivot = t6_df.pivot_table(index=["category", "treatment"],
                                  columns="coder", values="rate")
    t6_pivot["paper_Table6"] = t6_pivot.apply(
        lambda r: TABLE6_HUMAN.get(r.name[0], {}).get(r.name[1], np.nan), axis=1
    )
    t6_pivot.to_csv(csv_path)
    print(f"\nSaved: {csv_path}")

    # plot
    plot_table6(t6_df, os.path.join(OUT_DIR, "table6_reproduction"))

    # ── Table 7 ──
    print("\nComputing Table 7 (truth-telling by game state in CH-MC)...")
    t7_df = compute_table7(datasets)

    csv7_path = os.path.join(OUT_DIR, "table7_reproduction.csv")
    t7_pivot  = t7_df.pivot_table(index=["category", "game"],
                                   columns="coder", values="rate")
    t7_pivot.to_csv(csv7_path)
    print(f"Saved: {csv7_path}")

    plot_table7(t7_df, os.path.join(OUT_DIR, "table7_reproduction"))

    print("\nDone.")


if __name__ == "__main__":
    main()
