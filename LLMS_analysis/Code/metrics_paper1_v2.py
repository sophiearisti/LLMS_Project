"""
metrics_paper1_v2.py
====================
Evaluation script for the Paper 1 v2 experiment.

CHANGES vs metrics_analysis.py:
--------------------------------
1. Only evaluates Paper 1 (no other papers).
2. Reads predictions from managerial_leadership_Jordi_Cooper_v2/ sub-folders
   so results are isolated and never overwrite the original experiments.
3. 'discuss_coordinate' removed from the labels list — that column does not
   exist in the human-coded real_answers.csv (it was silently skipped in
   the original, which caused confusion). We call it out explicitly here.
4. Evaluation covers both the original strategy folders (0shot, fewshot) AND
   the new CoT folders (0shot_cot, fewshot_cot) so all four can be compared
   in one run.
5. Results PNG/CSV are saved inside the v2 sub-folder tree:
       Results/gpt/managerial_leadership_Jordi_Cooper_v2/<strategy>/

ALSO NOTE: the three-class metric (0, 0.5, 1) is now fully evaluated
   because the v2 prompts explicitly allow 0.5 outputs. The previous
   failing of precision_0.5 = recall_0.5 = f1_0.5 = 0.0 for all tags
   should improve. Cohen's Kappa and Krippendorff's alpha are expected
   to improve most for: discuss_fairness, discuss_efficient, explanation.
"""

import os
import re
import pandas as pd
import matplotlib.pyplot as plt
import textwrap
from sklearn.metrics import classification_report, accuracy_score, cohen_kappa_score
from utils import *

# ── v2 override ───────────────────────────────────────────────────────────────
FIRST_PAPER_V2 = "managerial_leadership_Jordi_Cooper_v2/"

PAPERS_V2 = {
    1: {
        "path": FIRST_PAPER_V2,
        # NOTE: 'discuss_coordinate' is intentionally omitted — it is absent
        # from the human-coded real_answers.csv and was silently skipped in
        # the original metrics script. Removing it avoids misleading output.
        "labels": [
            "any_suggestion",
            "suggest_safe",
            "suggest_efficient",
            "agree_proposal",
            "discuss_fairness",
            "discuss_efficient",
            "discuss_rules",
            "explanation",
            "discuss_howtoplay",
            "ask_game",
            "receive_report",
            "truthful",
            "falsehood",
            "contradict",
            "neither_report",
        ],
    }
}


# ── Agreement helpers ─────────────────────────────────────────────────────────

def krippendorff_alpha_nominal(y_true, y_pred):
    y_true = pd.Series(y_true).astype(str)
    y_pred = pd.Series(y_pred).astype(str)
    observed = (y_true != y_pred).mean()
    pooled   = pd.concat([y_true, y_pred], ignore_index=True)
    probs    = pooled.value_counts(normalize=True)
    expected = 1 - (probs ** 2).sum()
    if expected == 0:
        return 1.0 if observed == 0 else 0.0
    return 1 - (observed / expected)


def normalize_message(text):
    text = str(text).strip().lower()
    text = re.sub(r"(^|/)\s*\d+\s*;\s*", r"\1", text)
    text = re.sub(r"\s*/\s*", " / ", text)
    text = re.sub(r"\s+", " ", text)
    return text.strip()


# ── Core evaluation ───────────────────────────────────────────────────────────

def paper_evaluation_v2(predicted_answers_path, folder, temp, mode, LLM="gpt"):
    paper_id = 1
    real_answers_path = os.path.join(DATA_PATH, FIRST_PAPER, REAL_ANSWERS_FILE)

    real_df      = pd.read_csv(real_answers_path)
    predicted_df = pd.read_csv(predicted_answers_path)

    message_col = "message"

    # Align by normalised message text
    real_df["message_norm"]      = real_df[message_col].astype(str).map(normalize_message)
    predicted_df["message_norm"] = predicted_df["original_message"].astype(str).map(normalize_message)

    merged_df = real_df.merge(
        predicted_df,
        on="message_norm",
        suffixes=("_true", "_pred"),
        how="inner",
    )

    if len(merged_df) < min(len(real_df), len(predicted_df)):
        print(
            f"  Warning: alignment dropped rows "
            f"({len(merged_df)} matched / {len(real_df)} real / {len(predicted_df)} predicted). "
            "Check for duplicates or message mismatches."
        )

    results = []

    for tag in PAPERS_V2[paper_id]["labels"]:

        if tag + "_pred" not in merged_df.columns:
            print(f"  [SKIP] '{tag}' not found in predicted output.")
            continue
        if tag + "_true" not in merged_df.columns and tag not in merged_df.columns:
            print(f"  [SKIP] '{tag}' not found in real answers.")
            continue

        # Prefer the suffixed versions from the merge; fall back for columns
        # that do not clash (i.e., only appear once).
        true_col = tag + "_true" if tag + "_true" in merged_df.columns else tag
        pred_col = tag + "_pred" if tag + "_pred" in merged_df.columns else tag

        y_true = merged_df[true_col].fillna("nan").astype(str).str.strip().str.lower()
        y_pred = merged_df[pred_col].fillna("nan").astype(str).str.strip().str.lower()

        # Strip trailing ".0" from float-formatted integers (e.g. "1.0" → "1")
        y_true = y_true.str.replace(r"\.0$", "", regex=True)
        y_pred = y_pred.str.replace(r"\.0$", "", regex=True)

        acc         = accuracy_score(y_true, y_pred)
        kappa       = float(cohen_kappa_score(y_true, y_pred))
        kripp_alpha = float(krippendorff_alpha_nominal(y_true, y_pred))
        report      = classification_report(y_true, y_pred, output_dict=True)

        print(f"\n  Classification Report | Tag: {tag}")
        print(classification_report(y_true, y_pred))
        print(f"  Accuracy: {acc:.3f}  |  Kappa: {kappa:.3f}  |  Kripp-α: {kripp_alpha:.3f}")

        classes = sorted(set(y_true.unique()) | set(y_pred.unique()))

        row = {
            "paper_id":           paper_id,
            "tag":                tag,
            "accuracy":           acc,
            "cohen_kappa":        kappa,
            "krippendorff_alpha": kripp_alpha,
            "macro_f1":           report["macro avg"]["f1-score"],
        }

        for c in classes:
            c_str = str(c).lower()
            if c_str in report:
                row[f"precision_{c}"] = report[c_str]["precision"]
                row[f"recall_{c}"]    = report[c_str]["recall"]
                row[f"f1_{c}"]        = report[c_str]["f1-score"]
            else:
                row[f"precision_{c}"] = None
                row[f"recall_{c}"]    = None
                row[f"f1_{c}"]        = None

        results.append(row)

    get_results_and_visualize_v2(results, folder, temp, mode, LLM)


def get_results_and_visualize_v2(results, folder, temp, mode, LLM="gpt"):
    paper_id = 1

    def wrap_cell(x, width=25):
        if isinstance(x, str):
            return "\n".join(textwrap.wrap(x, width=width))
        return x

    results_df = pd.DataFrame(results)

    out_csv = f"results_paper_{paper_id}_temp{temp}_mode{mode}_type{folder}.csv"
    out_path = os.path.join(RESULTS_PATH, LLM + "/", FIRST_PAPER_V2, folder, out_csv)
    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    results_df.to_csv(out_path, index=False)
    print(f"\n  Table saved → {out_path}")

    # Global row
    global_row       = {"paper_id": paper_id, "tag": "GLOBAL"}
    numeric_cols     = results_df.select_dtypes(include=["number"]).columns
    for col in numeric_cols:
        global_row[col] = results_df[col].mean()
    global_row       = pd.DataFrame([global_row])
    final_df         = pd.concat([results_df, global_row], ignore_index=True)

    final_df = final_df.apply(
        lambda col: col.map(lambda x: round(x, 3) if isinstance(x, (float, int)) else x)
    )
    wrapped_df = final_df.apply(lambda col: col.map(lambda x: wrap_cell(x, width=25)))

    fig, ax = plt.subplots(figsize=(18, 0.55 * len(final_df) + 2))
    ax.axis("off")
    table = ax.table(
        cellText=wrapped_df.values,
        colLabels=wrapped_df.columns,
        loc="center",
        cellLoc="center",
    )
    table.auto_set_font_size(False)
    table.set_fontsize(10)
    table.scale(1.2, 1.5)
    table.auto_set_column_width(col=list(range(len(final_df.columns))))
    plt.title(
        f"Paper 1 v2 | Temp {temp} | Strategy: {folder}\nMetrics per label and global averages",
        fontsize=14,
        pad=20,
    )

    out_png = f"results_paper_{paper_id}_temp{temp}_mode{mode}_type{folder}.png"
    png_path = os.path.join(RESULTS_PATH, LLM + "/", FIRST_PAPER_V2, folder, out_png)
    plt.savefig(png_path, dpi=300, bbox_inches="tight")
    plt.close()
    print(f"  Image saved  → {png_path}")


# ── Main ──────────────────────────────────────────────────────────────────────

def main():
    # Select LLM
    print("Select LLM whose results to evaluate:")
    print("1. gpt")
    print("2. gemini")
    llm_choice = input("Choose (1 or 2): ").strip()
    LLM = "gemini" if llm_choice == "2" else "gpt"
    print(f"Using: {LLM}")

    # Evaluate all four strategy folders so 0shot_cot and fewshot_cot are
    # included (they were excluded from the original metrics loop).
    folder_results = ["0shot", "fewshot", "0shot_cot", "fewshot_cot"]
    temps  = [0, 0.1, 0.5, 1, 1.2]
    modes  = ["user"]

    for folder in folder_results:
        for temp in temps:
            for mode in modes:
                print(
                    f"\n{'='*60}\n"
                    f"Evaluating Paper 1 v2 | LLM: {LLM} | Folder: {folder} | Temp: {temp} | Mode: {mode}"
                    f"\n{'='*60}"
                )
                # v2 results live under FIRST_PAPER_V2
                out_file = f"results_line_temp{temp}_mode{mode}.csv"
                predicted_path = os.path.join(
                    RESULTS_PATH, LLM + "/", FIRST_PAPER_V2, folder, out_file
                )
                if not os.path.exists(predicted_path):
                    print(f"  [NOT FOUND] {predicted_path}  — skipping.")
                    continue

                paper_evaluation_v2(predicted_path, folder, temp, mode, LLM)


main()
