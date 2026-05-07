"""
Ederer & Schneider (2022) regression comparison: human vs. LLM-coded is_promise.

Replicates: numrolls ~ communication + is_promise if role==1, cluster(session)
Expected human p-value for is_promise: ~0.043

For each LLM (Claude, GPT, Gemini) at 0-shot, temp=0:
  - Load is_promise predictions
  - Align to real_answers.csv by message content
  - Run same regression with LLM-coded is_promise
  - Output comparison LaTeX table
"""

import os
import numpy as np
import pandas as pd
import statsmodels.api as sm
from pathlib import Path

PROJECT = Path(__file__).parent.parent.parent
DATA = PROJECT / "LLMS_analysis" / "Data" / "trust_promises_Ederer_Schneider"
RESULTS_ROOT = PROJECT / "LLMS_analysis" / "Results"
OUT_DIR = RESULTS_ROOT / "by_paper" / "trust_promises_Ederer_Schneider" / "_substantive_analysis"
OUT_DIR.mkdir(parents=True, exist_ok=True)

LLM_FILES = {
    "Claude": RESULTS_ROOT / "claude" / "trust_promises_Ederer_Schneider" / "0shot" / "results_line_temp0_modeuser.csv",
    "GPT":    RESULTS_ROOT / "gpt"    / "trust_promises_Ederer_Schneider" / "0shot" / "results_temp0_modeuser.csv",
    "Gemini": RESULTS_ROOT / "gemini" / "trust_promises_Ederer_Schneider" / "0shot" / "results_temp0_modeuser.csv",
}


def stars(p: float) -> str:
    if p < 0.01:
        return "^{***}"
    if p < 0.05:
        return "^{**}"
    if p < 0.10:
        return "^{*}"
    return ""


def run_regression(df_trustees: pd.DataFrame, is_promise_col: str) -> dict:
    reg_data = df_trustees[["numrolls", "communication", is_promise_col, "session"]].dropna()
    X = sm.add_constant(reg_data[["communication", is_promise_col]])
    model = sm.OLS(reg_data["numrolls"], X).fit(
        cov_type="cluster", cov_kwds={"groups": reg_data["session"].values}
    )
    return {
        "comm_coef":      model.params["communication"],
        "comm_se":        model.bse["communication"],
        "comm_p":         model.pvalues["communication"],
        "promise_coef":   model.params[is_promise_col],
        "promise_se":     model.bse[is_promise_col],
        "promise_p":      model.pvalues[is_promise_col],
        "const_coef":     model.params["const"],
        "const_se":       model.bse["const"],
        "const_p":        model.pvalues["const"],
        "r2":             model.rsquared,
        "n":              int(model.nobs),
    }


def load_llm_predictions(path: Path) -> pd.Series:
    """Return a Series mapping stripped message → is_promise (0 or 1)."""
    df = pd.read_csv(path)
    df["_msg_key"] = df["original_message"].str.strip()
    # keep first occurrence if duplicates
    df = df.drop_duplicates(subset="_msg_key", keep="first")
    return df.set_index("_msg_key")["is_promise"]


def build_llm_column(df_full: pd.DataFrame, llm_preds: pd.Series) -> pd.Series:
    """
    For all 707 rows in real_answers:
      - role==1, communication==0: is_promise = 0
      - role==1, communication==1 with message: look up by message content
      - role==1, communication==1 with NaN/empty message: is_promise = 0 (no message → no promise)
      - role==0: NaN (excluded from regression anyway)
    """
    out = pd.Series(np.nan, index=df_full.index)
    mask_comm0 = (df_full["role"] == 1) & (df_full["communication"] == 0)
    out[mask_comm0] = 0

    mask_comm1 = (df_full["role"] == 1) & (df_full["communication"] == 1)
    keys = df_full.loc[mask_comm1, "message"].str.strip()
    mapped = keys.map(llm_preds)
    # rows where message was NaN or didn't match any LLM prediction → no promise
    mapped = mapped.fillna(0)
    out[mask_comm1] = mapped.values
    return out


def coef_cell(coef: float, p: float) -> str:
    s = stars(p)
    return f"${coef:.3f}{s}$"


def se_cell(se: float) -> str:
    return f"$({se:.3f})$"


def write_latex_table(results: dict, path: Path) -> None:
    cols = ["Human", "Claude", "GPT", "Gemini"]
    header = " & ".join([""] + cols) + r" \\"

    def coef_row(label, key_coef, key_p):
        cells = [coef_cell(results[c][key_coef], results[c][key_p]) for c in cols]
        return f"        {label} & " + " & ".join(cells) + r" \\"

    def se_row(key_se):
        cells = [se_cell(results[c][key_se]) for c in cols]
        return r"         & " + " & ".join(cells) + r" \\"

    n_vals = " & ".join(str(results[c]["n"]) for c in cols)
    r2_vals = " & ".join(f'{results[c]["r2"]:.3f}' for c in cols)

    lines = [
        r"\begin{table}",
        r"    \centering",
        r"    \caption{Regression comparison: human vs.\ LLM-coded \textit{is\_promise} -- \citet{ederer_schneider_2022}}",
        r"    \label{tab:ederer_regression}",
        r"    \begin{adjustbox}{max width=0.82\linewidth}",
        r"    \small",
        r"    \begin{tabular}{lcccc}",
        r"        \toprule",
        f"         {header}",
        r"        \midrule",
        coef_row(r"Communication", "comm_coef", "comm_p"),
        se_row("comm_se"),
        coef_row(r"Promise", "promise_coef", "promise_p"),
        se_row("promise_se"),
        coef_row(r"Constant", "const_coef", "const_p"),
        se_row("const_se"),
        r"        \midrule",
        f"        $N$ & {n_vals} \\\\",
        f"        $R^2$ & {r2_vals} \\\\",
        r"        \bottomrule",
        r"    \end{tabular}",
        r"    \end{adjustbox}",
        r"    \vspace{0.2cm}",
        r"    \begin{minipage}{0.82\linewidth}",
        r"        \footnotesize",
        (r"        \textit{Note:} OLS with standard errors clustered by session. Sample: trustees "
         r"(\textit{role}~$= 1$). Human column uses original author coding. LLM columns replace "
         r"\textit{is\_promise} with model predictions at zero-shot, temperature~0. "
         r"Standard errors in parentheses. $^{***}p<0.01$, $^{**}p<0.05$, $^{*}p<0.10$."),
        r"    \end{minipage}",
        r"\end{table}",
    ]
    path.write_text("\n".join(lines), encoding="utf-8")
    print(f"LaTeX table written to {path}")


def main():
    real = pd.read_csv(DATA / "real_answers.csv")
    trustees = real[real["role"] == 1].copy()

    results = {}

    # ── Human baseline ────────────────────────────────────────────────────────
    res = run_regression(trustees, "is_promise")
    results["Human"] = res
    print(
        f"Human:  communication p={res['comm_p']:.4f}  "
        f"is_promise coef={res['promise_coef']:.4f} p={res['promise_p']:.4f}  "
        f"N={res['n']}"
    )

    # ── LLM columns ───────────────────────────────────────────────────────────
    for name, fpath in LLM_FILES.items():
        if not fpath.exists():
            print(f"{name}: file not found at {fpath}")
            continue
        preds = load_llm_predictions(fpath)
        real[f"is_promise_{name}"] = build_llm_column(real, preds)
        trustees_copy = real[real["role"] == 1].copy()
        res = run_regression(trustees_copy, f"is_promise_{name}")
        results[name] = res
        print(
            f"{name}:   communication p={res['comm_p']:.4f}  "
            f"is_promise coef={res['promise_coef']:.4f} p={res['promise_p']:.4f}  "
            f"N={res['n']}"
        )

    write_latex_table(results, OUT_DIR / "regression_comparison.tex")


if __name__ == "__main__":
    main()
