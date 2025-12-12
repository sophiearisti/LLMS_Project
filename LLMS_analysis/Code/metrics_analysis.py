# now that we classified all the files, we need to compare with the actual answers

#TAKE EACH FILE IN THE RESULTS FOLDER AND COMPARE WITH THE REAL ANSWERS, THAT IS LETERALLY ALL
# METRICS ARE ACCURACY, PRECISION, RECALL, F1 SCORE FOR EACH CATEGORY AND OVERALL
import os
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.metrics import classification_report, accuracy_score
from utils import *

""" PAPERS = {
   1: {
        "path": FIRST_PAPER,
        "labels": ["any_suggestion", "suggest_safe", "suggest_efficient", "agree_proposal", "discuss_coordinte", "discuss_fairness", "discuss_efficient", "discuss_rules", "explanation", "discuss_howtoplay", "ask_game", "receive_report", "truthful", "falsehood", "contradict", "neither_report"]
    },"""
PAPERS = {
    2: {
        "path": SECOND_PAPER,
        "real_labels": ["topic1", "topic2", "topic3"],
        "created_labels": ["Numerical_Coordination_and_Strategy", "Trust_Cooperation_and_Betrayal", "OffTopic_Social_and_Affective_Chat"]
    },
    3: {
        "path": THIRD_PAPER,
        "labels": ["is_promise", "is_efficiency", "is_ethics"]
    },
    4: {
        "path": FOURTH_PAPER,
        "labels": ["uninformative", "SDB", "overest. others", "underest. own", "academic integrity", "info asymmetry", "AI discussion priming", "privacy concerns", "self-steem", "self-report bias", "network effect", "truthful"]
    }
}


#for the first paper
# take the txt that states how to read each group of messages 
# for the fisrt row of each group of messages, get the real answers 
# compare with the predicted answers in the results folder

def paper_evaluation(paper_id, real_answers_path, predicted_answers_path, folder, temp, mode):
    
    real_df = pd.read_csv(real_answers_path)
    # quitar los nan
    message_col = "message"

        
    #quitar los NaN
    real_df = real_df.dropna(subset=[message_col])
    
    predicted_df = pd.read_csv(predicted_answers_path)

    results = []   # aquí acumularemos las métricas por categoría

    for tag in PAPERS[paper_id]["labels"]:

        if  tag not in predicted_df.columns:
            print(f"Tag {tag} no existe en predicted dataframes para Paper {paper_id}")
            continue
        
        if tag not in real_df.columns:
            print(f"Tag {tag} no existe en real dataframes para Paper {paper_id}")
            continue

        y_true = real_df[tag]
        y_pred = predicted_df[tag]

        # métricas básicas
        acc = accuracy_score(y_true, y_pred)
        report = classification_report(y_true, y_pred, output_dict=True)

        print(f"\n Classification Report | Paper {paper_id} | Tag: {tag}")
        print(classification_report(y_true, y_pred))
        print("Accuracy:", acc)

        # guardar resultados en tabla
        results.append({
            "paper_id": paper_id,
            "tag": tag,
            "accuracy": acc,
            "precision_0": report["0"]["precision"] if "0" in report else None,
            "recall_0":    report["0"]["recall"]    if "0" in report else None,
            "f1_0":        report["0"]["f1-score"]  if "0" in report else None,
            "precision_1": report["1"]["precision"] if "1" in report else None,
            "recall_1":    report["1"]["recall"]    if "1" in report else None,
            "f1_1":        report["1"]["f1-score"]  if "1" in report else None,
            "macro_f1":    report["macro avg"]["f1-score"]
        })
        
    # una vez tenemos todas las métricas por categoría, guardamos y visualizamos
    get_results_and_visualize(paper_id, results, folder, temp, mode)

    
# for the second paper, this is trickier because the categories were created by the llm
def paper_two_evaluation(real_answers_path, predicted_answers_path, folder, temp, mode):
    # Load real answers
    real_df = pd.read_csv(real_answers_path)
    predicted_df = pd.read_csv(predicted_answers_path)
    
    results = []   # aquí acumularemos las métricas por categoría
    
    for real_tag, created_tag in zip(PAPERS[2]['real_labels'], PAPERS[2]['created_labels']):
        if real_tag not in real_df.columns or created_tag not in predicted_df.columns:
            print(f"Tag {real_tag} or {created_tag} not found in one of the dataframes.")
            return
        
        y_true = real_df[real_tag]
        y_pred = predicted_df[created_tag]

        # métricas básicas
        acc = accuracy_score(y_true, y_pred)
        report = classification_report(y_true, y_pred, output_dict=True)

        print(f"\n Classification Report | Paper 2 | Real Tag: {real_tag} | Created Tag: {created_tag}")
        print(classification_report(y_true, y_pred))
        print("Accuracy:", acc)

        # guardar resultados en tabla
        results.append({
            "paper_id": 2,
            "tag": f"{real_tag} | {created_tag}",
            "accuracy": acc,
            "precision_0": report["0"]["precision"] if "0" in report else None,
            "recall_0":    report["0"]["recall"]    if "0" in report else None,
            "f1_0":        report["0"]["f1-score"]  if "0" in report else None,
            "precision_1": report["1"]["precision"] if "1" in report else None,
            "recall_1":    report["1"]["recall"]    if "1" in report else None,
            "f1_1":        report["1"]["f1-score"]  if "1" in report else None,
            "macro_f1":    report["macro avg"]["f1-score"]
        })
        
    # una vez tenemos todas las métricas por categoría, guardamos y visualizamos
    get_results_and_visualize(2, results, folder, temp, mode)
        
def get_results_and_visualize(paper_id, results, folder, temp, mode):
    # Convertir resultados a un DataFrame
    results_df = pd.DataFrame(results)

    # Guardar tabla
    out_path = f"results_paper_{paper_id}_temp{temp}_mode{mode}_type{folder}.csv"
    out_path = os.path.join(RESULTS_PATH, PAPERS[paper_id]['path'], folder, out_path)
    results_df.to_csv(out_path, index=False)

    print(f"\nTabla guardada en: {out_path}")
    
    # -------------------------------
    # MÉTRICAS GLOBALES DEL PAPER
    # -------------------------------
    global_acc = results_df["accuracy"].mean()
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
        "precision_0": global_precision_0,
        "recall_0": global_recall_0,
        "f1_0": global_f1_0,
        "precision_1": global_precision_1,
        "recall_1": global_recall_1,
        "f1_1": global_f1_1,
        "macro_f1": global_macro_f1
    }])

    final_df = pd.concat([results_df, global_row], ignore_index=True)
    
    # -----------------------------------------
    # CREAR TABLA BONITA Y GUARDAR COMO PNG
    # -----------------------------------------
    fig, ax = plt.subplots(figsize=(14, 0.5 * len(final_df) + 2))
    ax.axis("off")

    table = ax.table(
        cellText=final_df.round(3).values,
        colLabels=final_df.columns,
        loc='center',
        cellLoc='center'
    )

    table.auto_set_font_size(False)
    table.set_fontsize(10)
    table.scale(1, 1.5)

    # Título
    plt.title(f"Resultados del Paper {paper_id}\nMétricas por etiqueta y métricas globales", fontsize=16, pad=20)

    png_path = f"results_paper_{paper_id}_temp{temp}_mode{mode}_type{folder}.png"
    png_path =os.path.join(RESULTS_PATH, PAPERS[paper_id]['path'], folder, png_path)
    plt.savefig(png_path, dpi=300, bbox_inches="tight")
    plt.close()

    print(f"Imagen guardada en: {png_path}")

def main():
    folder_results = ["0shot", "fewshot"] #, "0shotCot", "fewshotCot"]
    temps   = [0, 0.25, 0.5,  0.75, 1]
    mode  = ["user"] #, "assistant"]
    
    for paper_id in PAPERS.keys():
        
        real_answers_path = os.path.join(DATA_PATH, PAPERS[paper_id]['path'], REAL_ANSWERS_FILE)

        for folder in folder_results:
            for temp in temps:
                for m in mode:
                    print(f"Evaluating results for Paper {paper_id}, Folder: {folder}, Temp: {temp}, Mode: {m}")
                    
                    out_file = f"results_temp{temp}_mode{m}.csv"
                    
                    predicted_answers_path = os.path.join(RESULTS_PATH, PAPERS[paper_id]['path'], folder, out_file)
                    
                    print(f"Evaluating Paper {paper_id}...")
                    
                    if paper_id == 2:
                        paper_two_evaluation(real_answers_path, predicted_answers_path, folder, temp, m)
                    else:
                        paper_evaluation(paper_id, real_answers_path, predicted_answers_path, folder, temp, m)
                    
                    print("\n" + "="*50 + "\n")
                    

main()