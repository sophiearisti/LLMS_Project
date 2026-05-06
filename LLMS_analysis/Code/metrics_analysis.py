# now that we classified all the files, we need to compare with the actual answers

#TAKE EACH FILE IN THE RESULTS FOLDER AND COMPARE WITH THE REAL ANSWERS, THAT IS LETERALLY ALL
# METRICS ARE ACCURACY, PRECISION, RECALL, F1 SCORE FOR EACH CATEGORY AND OVERALL
import os
from numpy import real
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.metrics import classification_report, accuracy_score, cohen_kappa_score
import krippendorff
from utils import *
import textwrap
import re

TAGS_FILE = "tags.csv"          # raw coder fractions for paper 1
N_HUMAN_CODERS = 3
OBS_KEYS_P1 = ["session", "period", "group", "game"]


def _reconstruct_coders(avg_series: pd.Series) -> np.ndarray:
    """
    Reconstruct N_HUMAN_CODERS binary vectors from averaged fractions.
    avg × 3 → k coders said "1"; assign 1 to the first k coders.
    Returns shape (N_HUMAN_CODERS, n_items).
    """
    n = len(avg_series)
    mat = np.full((N_HUMAN_CODERS, n), np.nan)
    for i, val in enumerate(avg_series):
        if pd.isna(val):
            continue
        k = int(round(float(val) * N_HUMAN_CODERS))
        k = max(0, min(N_HUMAN_CODERS, k))
        for c in range(N_HUMAN_CODERS):
            mat[c, i] = 1.0 if (N_HUMAN_CODERS - c) <= k else 0.0
    return mat


def krippendorff_alpha_nominal(y_true, y_pred):
    """
    Generic 2-rater Krippendorff alpha (used for papers 3 and 4).
    Builds a (2, n_items) reliability matrix and delegates to the krippendorff library.
    """
    y_true = pd.Series(y_true).astype(str).reset_index(drop=True)
    y_pred = pd.Series(y_pred).astype(str).reset_index(drop=True)

    combined = pd.concat([y_true, y_pred], ignore_index=True)
    codes, _ = pd.factorize(combined, sort=True)
    split = len(y_true)
    mat = np.vstack([codes[:split], codes[split:]]).astype(float)

    return float(krippendorff.alpha(mat, level_of_measurement="nominal"))


def krippendorff_alpha_4raters(tags_df: pd.DataFrame, merged_df: pd.DataFrame,
                                obs_keys: list, tag: str, y_pred_binary: pd.Series) -> float:
    """
    Compute Krippendorff's alpha across 3 human coders + 1 LLM for paper 1.

    tags_df      : full tags.csv (raw coder fractions per conversation)
    merged_df    : merged real×predicted df (may have multiple rows per conversation)
    obs_keys     : ['session','period','group','game']
    tag          : label column name
    y_pred_binary: LLM predictions aligned to merged_df rows (0/1)

    merged_df may have duplicate obs_keys (one row per message). We aggregate the
    LLM predictions to conversation level using majority vote (mean > 0.5) so the
    n_items dimension matches the human coder matrix derived from tags_df.
    """
    # Aggregate LLM predictions to conversation level (majority vote)
    tmp = merged_df[obs_keys].copy()
    tmp["_pred"] = pd.to_numeric(y_pred_binary.values, errors="coerce")
    conv_pred = (
        tmp.groupby(obs_keys)["_pred"]
        .mean()
        .reset_index()
        .rename(columns={"_pred": "_pred_agg"})
    )
    conv_pred["_pred_agg"] = (conv_pred["_pred_agg"] > 0.5).astype(float)

    # Pull human fractions for the same conversations from tags_df
    tags_sub = conv_pred[obs_keys].merge(
        tags_df[obs_keys + [tag]], on=obs_keys, how="left"
    )

    n_total = len(tags_sub)
    n_aligned = int(tags_sub[tag].notna().sum())
    n_missing = n_total - n_aligned
    if n_missing > 0:
        print(
            f"Warning [{tag}]: {n_missing}/{n_total} conversations not aligned to "
            f"tags_df — alpha computed on {n_aligned} rows."
        )
    if n_aligned < 2:
        return np.nan

    avg_vals = tags_sub[tag].values          # shape (n_conv,)
    llm_vals = conv_pred["_pred_agg"].values # shape (n_conv,)

    # Reconstruct 3 human coder rows → (3, n_conv)
    human_mat = _reconstruct_coders(pd.Series(avg_vals))

    # LLM row → (1, n_conv)
    llm_row = llm_vals.astype(float).reshape(1, -1)

    mat = np.vstack([human_mat, llm_row])  # (4, n_conv)

    flat = mat[~np.isnan(mat)]
    if len(np.unique(flat)) < 2:
        return np.nan

    return float(krippendorff.alpha(mat, level_of_measurement="nominal"))


PAPERS = {
   1: {
        "path": FIRST_PAPER,
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
    },

    3: {
        "path": THIRD_PAPER,
        "labels": ["is_promise", "is_efficiency", "is_ethics"]
    },
    4: {
        "path": FOURTH_PAPER,
        "labels": ["uninformative", "SDB", "overest_others", "underest_own", "academic_integrity", "info_asymmetry", "AI_discussion_priming", "privacy_concerns", "self_esteem", "self_report_bias", "network_effect", "truthful"]
    }
}

"""    2: {
        "path": SECOND_PAPER,
        "real_labels": ["topic1", "topic2", "topic3"],
        "labels": ["Numerical_Coordination_and_Strategy", "Trust_Cooperation_and_Betrayal", "OffTopic_Social_and_Affective_Chat"]
    },"""

def paper_evaluation(paper_id, real_answers_path, predicted_answers_path, folder, temp, mode, llm):
    
    real_df = pd.read_csv(real_answers_path)
    
    predicted_df = pd.read_csv(predicted_answers_path)

    # Normalize known legacy/typo column variants in prediction files.
    predicted_df.columns = [c.strip() for c in predicted_df.columns]
    rename_map = {}
    if "self_steem" in predicted_df.columns:
        rename_map["self_steem"] = "self_esteem"
    if "networkeffect" in predicted_df.columns:
        rename_map["networkeffect"] = "network_effect"
    if "self_report bias" in predicted_df.columns:
        rename_map["self_report bias"] = "self_report_bias"
    if rename_map:
        predicted_df = predicted_df.rename(columns=rename_map)
    
    message_col = "message"
    
    #quitar los NaN
    if paper_id != 1:
        real_df = real_df.dropna(subset=[message_col])
        predicted_df = predicted_df.dropna(subset=["original_message"])
        
    def normalize_message(text):
        text = str(text).strip().lower()
        text = re.sub(r"(^|/)\s*\d+\s*;\s*", r"\1", text)
        text = re.sub(r"\s*/\s*", " / ", text)
        text = re.sub(r"\s+", " ", text)
        return text.strip()

    results = []   # aquí acumularemos las métricas por categoría

    merged_df = None
    tags_df = None  # only loaded for paper 1

    if paper_id == 1:
        tags_path = os.path.join(DATA_PATH, PAPERS[1]["path"], TAGS_FILE)
        if os.path.exists(tags_path):
            tags_df = pd.read_csv(tags_path)
        else:
            print(f"Warning: {tags_path} not found — falling back to 2-rater alpha for paper 1")

    if paper_id in [1, 4]:
        if "original_message" in predicted_df.columns and message_col in real_df.columns:
            real_df["message_norm"] = real_df[message_col].astype(str).map(normalize_message)
            predicted_df["message_norm"] = predicted_df["original_message"].astype(str).map(normalize_message)

            merged_df = real_df.merge(
                predicted_df,
                left_on="message_norm",
                right_on="message_norm",
                suffixes=("_true", "_pred"),
                how="inner"
            )
            if len(merged_df) < min(len(real_df), len(predicted_df)):
                print(
                    "Warning: message-based alignment dropped rows. "
                    "Check for mismatches or duplicates."
                )
        else:
            print(
                "Warning: Could not align by message fields; "
                "falling back to row order."
            )

    for tag in PAPERS[paper_id]["labels"]:

        if  tag not in predicted_df.columns:
            print(f"Tag {tag} no existe en predicted dataframes para Paper {paper_id}")
            continue
        
        if tag not in real_df.columns:
            print(f"Tag {tag} no existe en real dataframes para Paper {paper_id}")
            continue
        
        if merged_df is not None:
            y_true = merged_df[tag + "_true"]
            y_pred = merged_df[tag + "_pred"]
        else:
            y_true = real_df[tag]
            y_pred = predicted_df[tag]
        
        if paper_id == 3:
            # Asegurarse de que ambas series tengan el mismo índice después de eliminar NaN
            real_df["message_norm"] = real_df["message"].astype(str).map(normalize_message)
            predicted_df["message_norm"] = predicted_df["original_message"].astype(str).map(normalize_message)

            merged = real_df.merge(
                predicted_df,
                left_on="message_norm",
                right_on="message_norm",
                suffixes=("_true", "_pred"),
                how="inner"
            )

            y_true = merged[tag + "_true"]
            y_pred = merged[tag + "_pred"]

        if isinstance(y_true, pd.DataFrame):
            y_true = y_true.iloc[:, 0]
        if isinstance(y_pred, pd.DataFrame):
            y_pred = y_pred.iloc[:, 0]

        y_true = y_true.fillna("nan")
        y_pred = y_pred.fillna("nan")

        
        y_true = y_true.astype(str).str.strip().str.lower()
        y_pred = y_pred.astype(str).str.strip().str.lower()
        
        #si es el primer paper, quitar a los que apliquen el .0 a los que terminen en .0
        #if paper_id == 1:
            # Convertir "0.0" → "0", "1.0" → "1", etc.
        y_true = y_true.str.replace(r"\.0$", "", regex=True)
        y_pred = y_pred.str.replace(r"\.0$", "", regex=True)

        # métricas básicas
        acc = accuracy_score(y_true, y_pred)
        kappa = float(cohen_kappa_score(y_true, y_pred))

        if paper_id == 1 and tags_df is not None and merged_df is not None:
            # 4-rater Krippendorff: 3 humans (reconstructed from fractions) + LLM
            y_pred_numeric = pd.to_numeric(
                merged_df[tag + "_pred"].astype(str).str.replace(r"\.0$", "", regex=True),
                errors="coerce"
            )
            kripp_alpha = krippendorff_alpha_4raters(
                tags_df, merged_df, OBS_KEYS_P1, tag, y_pred_numeric
            )
            kripp_alpha = float(kripp_alpha) if not np.isnan(kripp_alpha) else float("nan")
        else:
            kripp_alpha = float(krippendorff_alpha_nominal(y_true, y_pred))
        report = classification_report(y_true, y_pred, output_dict=True)

        print(f"\n Classification Report | Paper {paper_id} | Tag: {tag}")
        print(classification_report(y_true, y_pred))

        print("Accuracy:", acc)

        # guardar resultados en tabla
        classes = sorted(list(set(y_true.unique()) | set(y_pred.unique())))
        

        report = classification_report(y_true, y_pred, output_dict=True)


        row = {
            "paper_id": paper_id,
            "tag": tag,
            "accuracy": acc,
            "cohen_kappa": kappa,
            "krippendorff_alpha": kripp_alpha,
            "macro_f1": report["macro avg"]["f1-score"]
        }

        # Agregar métricas por clase según las claves reales del report
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
        
        print(results)

    # una vez tenemos todas las métricas por categoría, guardamos y visualizamos
    get_results_and_visualize(paper_id, results, folder, temp, mode, llm)
    
def get_results_and_visualize(paper_id, results, folder, temp, mode, llm):
    
    # ask for which model we want to evaluate
    
    # -------------------------------
    # Función para ajustar texto
    # -------------------------------
    def wrap_cell(x, width=25):
        if isinstance(x, str):
            return "\n".join(textwrap.wrap(x, width=width))
        return x

    # Convertir resultados a un DataFrame
    results_df = pd.DataFrame(results)


    # Guardar tabla
    out_path = f"results_paper_{paper_id}_temp{temp}_mode{mode}_type{folder}.csv"
    out_path = os.path.join(RESULTS_PATH, llm, PAPERS[paper_id]['path'], folder, out_path)
    results_df.to_csv(out_path, index=False)

    print(f"\nTabla guardada en: {out_path}")
    
    # -------------------------------
    # MÉTRICAS GLOBALES DEL PAPER
    # -------------------------------
    if paper_id != 4 and paper_id != 1:
        global_acc = results_df["accuracy"].mean()
        global_kappa = results_df["cohen_kappa"].mean()
        global_kripp_alpha = results_df["krippendorff_alpha"].mean()
        global_macro_f1 = results_df["macro_f1"].mean()
        global_precision_1 = results_df["precision_1"].mean()
        global_recall_1 = results_df["recall_1"].mean()
        global_f1_1 = results_df["f1_1"].mean()
        global_precision_0 = results_df["precision_0"].mean()
        global_recall_0 = results_df["recall_0"].mean()
        global_f1_0 = results_df["f1_0"].mean()
        
        # Añadir métricas globales como una fila extra
        global_row = pd.DataFrame([{
            "paper_id": paper_id,
            "tag": "GLOBAL",
            "accuracy": global_acc,
            "cohen_kappa": global_kappa,
            "krippendorff_alpha": global_kripp_alpha,
            "precision_0": global_precision_0,
            "recall_0": global_recall_0,
            "f1_0": global_f1_0,
            "precision_1": global_precision_1,
            "recall_1": global_recall_1,
            "f1_1": global_f1_1,
            "macro_f1": global_macro_f1
        }])
    elif paper_id == 1:
        global_row = {"paper_id": paper_id, "tag": "GLOBAL"}
        numeric_cols = results_df.select_dtypes(include=["number"]).columns
        for col in numeric_cols:
            global_row[col] = results_df[col].mean()
        global_row = pd.DataFrame([global_row])
    
    else:
        global_row = pd.DataFrame()  # Fila vacía si no se calculan métricas globales

    final_df = pd.concat([results_df, global_row], ignore_index=True)

    # -------------------------------
    # REDONDEO A 3 DECIMALES
    # -------------------------------
    final_df = final_df.apply(
        lambda col: col.map(lambda x: round(x, 3) if isinstance(x, (float, int)) else x)
    )

    # -------------------------------
    # AJUSTE DE TEXTO
    # -------------------------------
    wrapped_df = final_df.apply(lambda col: col.map(lambda x: wrap_cell(x, width=25)))

    # -----------------------------------------
    # CREAR TABLA BONITA Y GUARDAR COMO PNG
    # -----------------------------------------
    fig, ax = plt.subplots(figsize=(18, 0.55 * len(final_df) + 2))
    ax.axis("off")

    table = ax.table(
        cellText=wrapped_df.values,
        colLabels=wrapped_df.columns,
        loc='center',
        cellLoc='center'
    )

    table.auto_set_font_size(False)
    table.set_fontsize(10)
    table.scale(1.2, 1.5)

    # Ajustar ancho de columnas automáticamente
    table.auto_set_column_width(col=list(range(len(final_df.columns))))

    # Título
    plt.title(f"Resultados del Paper {paper_id}\nMétricas por etiqueta y métricas globales", 
              fontsize=16, pad=20)

    png_path = f"results_paper_{paper_id}_temp{temp}_mode{mode}_type{folder}.png"
    png_path = os.path.join(RESULTS_PATH,llm, PAPERS[paper_id]['path'], folder, png_path)
    plt.savefig(png_path, dpi=300, bbox_inches="tight")
    plt.close()

    print(f"Imagen guardada en: {png_path}")

def main():
    folder_results = ["0shot", "fewshot"] #, "0shotCot", "fewshotCot"]
    llms = ["gemini", "gpt", "claude"]

    for paper_id in PAPERS.keys():
        real_answers_path = os.path.join(DATA_PATH, PAPERS[paper_id]['path'], REAL_ANSWERS_FILE)

        for folder in folder_results:
            for llm in llms:
                folder_path = os.path.join(RESULTS_PATH, llm, PAPERS[paper_id]['path'], folder)

                if not os.path.isdir(folder_path):
                    continue

                # Support historical and current naming conventions.
                pattern = re.compile(
                    r"^results(?:_(?:line|group|line_batch))?_temp(?P<temp>[^_]+)_mode(?P<mode>[^.]+)\.csv$"
                )

                available_files = []
                for filename in os.listdir(folder_path):
                    match = pattern.match(filename)
                    if match:
                        available_files.append(
                            (filename, match.group("temp"), match.group("mode"))
                        )

                if not available_files:
                    continue

                for filename, temp, m in sorted(available_files):
                    predicted_answers_path = os.path.join(folder_path, filename)

                    print(
                        f"Evaluating results for Paper {paper_id}, LLM: {llm}, "
                        f"Folder: {folder}, Temp: {temp}, Mode: {m}, File: {filename}"
                    )

                    try:
                        paper_evaluation(
                            paper_id,
                            real_answers_path,
                            predicted_answers_path,
                            folder,
                            temp,
                            m,
                            llm,
                        )
                    except FileNotFoundError:
                        print(f"⚠ Skipping missing file: {predicted_answers_path}")
                    except Exception as e:
                        print(f"⚠ Error evaluating {predicted_answers_path}: {e}")

                    print("\n" + "="*50 + "\n")
                    

main()