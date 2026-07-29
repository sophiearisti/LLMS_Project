"""
Generate table8_probit_comparison_table.tex from restricted-sample R probit outputs.

Reads:
    - table8_r_probit_replication.csv  (human + Claude/Gemini/GPT/Ensemble)

Writes:
    - table8_probit_comparison_table.tex
"""
from pathlib import Path
import pandas as pd
BASE_DIR = Path(__file__).resolve().parent
OUTPUT_TEX = BASE_DIR / "table8_probit_comparison_table.tex"

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

TERM_ORDER = [
    "agree_proposal",
    "discuss_coordinate",
    "discuss_fairness",
    "discuss_efficient",
    "discuss_rules",
    "discuss_howtoplay",
    "explanation",
    "ask_game",
    "truthful",
    "falsehood",
]

TERM_LABELS = {
    "agree_proposal":    "Agreement",
    "discuss_coordinate": "Discuss need to coordinate",
    "discuss_fairness":  "Discuss fairness",
    "discuss_efficient": "Discuss efficiency",
    "discuss_rules":     "Questions about rules",
    "discuss_howtoplay": "Questions about play",
    "explanation":       "Explanation",
    "ask_game":          "Ask what game",
    "truthful":          "Truthfully reveal game",
    "falsehood":         "Lie about game",
}

PANELS = [
    ("chsd_coord", "CH/S-D, coordination"),
    ("chsd_eff",   "CH/S-D, efficient coordination"),
    ("chmc_eff",   "CH-MC, efficient coordination"),
]

# Threshold below which a coefficient is treated as numerically degenerate
DEGENERATE_COEF = 1e-10
DEGENERATE_SE   = 1e-10


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def sig_stars(p: float) -> str:
    if pd.isna(p):
        return ""
    if p < 0.001:
        return "***"
    if p < 0.01:
        return "**"
    if p < 0.05:
        return "*"
    return ""


def is_degenerate(coef, se) -> bool:
    """Return True if the estimate is numerically degenerate."""
    if pd.isna(coef):
        return True
    if abs(coef) < DEGENERATE_COEF and (pd.isna(se) or abs(se) < DEGENERATE_SE):
        return True
    return False


def fmt_estimate(coef, se, p) -> str:
    """Format a marginal effect for an siunitx S column."""
    if is_degenerate(coef, se):
        return ""
    stars = sig_stars(p)
    num = f"{coef:.3f}"
    if stars:
        return f"{num}{{{stars}}}"
    return num


def fmt_se(se) -> str:
    """Format a clustered standard error beneath its marginal effect."""
    if pd.isna(se) or abs(se) < DEGENERATE_SE:
        return ""
    return f"[{se:.3f}]"


# ---------------------------------------------------------------------------
# Load data
# ---------------------------------------------------------------------------

def load_results():
    df = pd.read_csv(BASE_DIR / "table8_r_probit_replication.csv")
    df = df[df["model"].isin([p[0] for p in PANELS])].copy()
    df = df[df["source"].isin(["human", "claude", "gpt", "ensemble_majority"])].copy()
    df = df[["model", "term", "coef", "se", "p_value", "n", "pseudo_r2", "source"]].copy()
    return df


# ---------------------------------------------------------------------------
# Build lookup: (model, term, source) -> (coef, se, p_value, n, pseudo_r2)
# ---------------------------------------------------------------------------

def build_lookup(results_df):
    lut = {}

    for _, row in results_df.iterrows():
        lut[(row["model"], row["term"], row["source"])] = (
            row["coef"], row["se"], row["p_value"], row["n"], row["pseudo_r2"]
        )

    return lut


# ---------------------------------------------------------------------------
# Table builder
# ---------------------------------------------------------------------------

SOURCES = ["human", "claude", "gpt", "ensemble_majority"]
COL_LABELS = {
    "human":            "Human",
    "claude":           "Claude",
    "gpt":              "GPT",
    "ensemble_majority": "Ensemble",
}

# No blanking by source needed in the standard case.
PANEL_BLANK_SOURCES = {}


def panel_rows(model_key, lut):
    rows = []
    blank_srcs = PANEL_BLANK_SOURCES.get(model_key, set())

    for term in TERM_ORDER:
        estimate_cells = []
        se_cells = []
        non_empty = False
        for src in SOURCES:
            if src in blank_srcs:
                estimate_cells.append("")
                se_cells.append("")
                continue
            entry = lut.get((model_key, term, src))
            if entry is None:
                estimate_cells.append("")
                se_cells.append("")
            else:
                coef, se, p, _, _ = entry
                estimate = fmt_estimate(coef, se, p)
                estimate_cells.append(estimate)
                se_cells.append(fmt_se(se) if estimate else "")
                if estimate:
                    non_empty = True

        # Skip rows that are all blank (e.g. ask_game / truthful in chsd panels)
        if not non_empty and all(c == "" for c in estimate_cells):
            first_cell = estimate_cells[0]
            if not first_cell:
                continue

        label = TERM_LABELS[term]
        estimate_row = f"  {label}\n  & " + " & ".join(
            c if c else "{}" for c in estimate_cells
        ) + " \\\\"
        se_row = "  & " + " & ".join(
            rf"\multicolumn{{1}}{{c}}{{{c}}}" if c else "{}" for c in se_cells
        ) + " \\\\"
        rows.extend([estimate_row, se_row])

    if not rows:
        rows.append(
            r"\multicolumn{5}{l}{\textit{All restricted-sample estimates are numerically degenerate in this panel.}} \\" 
        )

    return rows


def panel_fit_rows(model_key, lut):
    """Return model sample size and McFadden pseudo-R² for each source."""
    stats = []
    for src in SOURCES:
        entries = [
            entry for (model, _, source), entry in lut.items()
            if model == model_key and source == src
        ]
        if entries:
            _, _, _, n, pseudo_r2 = entries[0]
            stats.append((n, pseudo_r2))
        else:
            stats.append((float("nan"), float("nan")))

    n_cells = [str(int(n)) if pd.notna(n) else "{}" for n, _ in stats]
    r2_cells = [f"{r2:.3f}" if pd.notna(r2) else "{}" for _, r2 in stats]
    return [
        "  Observations\n  & " + " & ".join(n_cells) + r" \\",
        r"  Pseudo-$R^2$" + "\n  & " + " & ".join(r2_cells) + r" \\",
    ]


def build_table(results_df):
    lut = build_lookup(results_df)
    header = (
        r"Dependent variable"
        + "\n  & "
        + " & ".join(f"{{{COL_LABELS[s]}}}" for s in SOURCES)
        + r" \\"
    )
    labels = [
        "tab:table8-lpm-condensed",
        "tab:table8-lpm-condensed-chsd-eff",
        "tab:table8-lpm-condensed-chmc-eff",
    ]
    tables = []

    for (model_key, panel_label), label in zip(PANELS, labels):
        lines = [
            r"\begin{table}[!htbp]",
            r"\centering",
            r"\scriptsize",
            rf"\caption{{Probit marginal effects on the restricted shared-data sample: {panel_label}.}}",
            rf"\label{{{label}}}",
            r"\begin{threeparttable}",
            r"\begin{tabular}{@{}l",
            r"  *{4}{S[table-format=-1.3, table-space-text-post={***}]}@{}}",
            r"\toprule",
            rf"& \multicolumn{{4}}{{c}}{{{panel_label}}} \\",
            r"\cmidrule(l){2-5}",
            header,
            r"\midrule",
        ]
        lines.extend(panel_rows(model_key, lut))
        lines += [
            r"\midrule",
        ]
        lines.extend(panel_fit_rows(model_key, lut))
        lines += [
            r"\bottomrule",
            r"\end{tabular}",
            r"\begin{minipage}{\textwidth}",
            r"\begin{tablenotes}[flushleft]",
            r"\scriptsize",
            r"\item \textit{Notes:} Entries are Probit marginal effects (evaluated at means) with clustered standard errors at the conversation-group level, reported in brackets. Pseudo-$R^2$ is deviance-based. Significance: $^{*}p<.05$, $^{**}p<.01$, $^{***}p<.001$.",
            r"\item All columns are estimated on the same restricted shared-data sample; the human column is the apples-to-apples benchmark. LLM estimates use few-shot prompting at temperature~0 (Claude, GPT). CH/A-D is omitted because message-level inputs are not present in the shared classification files. Blank cells indicate regressors dropped due to no within-sample variation.",
            r"\end{tablenotes}",
            r"\end{minipage}",
            r"\end{threeparttable}",
            r"\end{table}",
        ]
        tables.append("\n".join(lines))

    return "\n\n".join(tables) + "\n"


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    results_df = load_results()
    latex = build_table(results_df)
    OUTPUT_TEX.write_text(latex, encoding="utf-8")
    print(f"Wrote {OUTPUT_TEX}")


if __name__ == "__main__":
    main()
