"""
run_paper1_v2.py
================
Experimental runner for Paper 1 (Managerial Leadership) using
revised prompts in managerial_leadership_Jordi_Cooper_v2/.

CHANGES vs text_llms_new.py / text_llms.py:
-------------------------------------------
1. Points to the new v2 prompts folder so NO original files are touched.
2. Menu is simplified to Paper 1 only.
3. FIRST_PAPER_V2 overrides the path so output CSVs land in:
       Results/<llm>/managerial_leadership_Jordi_Cooper_v2/<strategy>/
   allowing direct comparison with the originals in:
       Results/<llm>/managerial_leadership_Jordi_Cooper/<strategy>/
4. Identical classification and parsing logic as text_llms_new.py so
   the metrics script can be reused unchanged.

WHAT THE v2 PROMPTS FIX (see prompts/managerial_leadership_Jordi_Cooper_v2/):
  - format.txt       : 0.5 is now an explicit valid label
  - classificationTask.txt : typo 'discuss_coordinte' → 'discuss_coordinate'
                              + clarification of 0.5 usage
  - constraints.txt  : 0.5 interaction rules added to the hierarchy
  - fewShot.txt      : example 2 corrected (discuss_fairness 1→0.5) +
                        new example 4 with multiple 0.5 labels
  - few-shotCoT.txt  : same corrections + reasons for 0.5 choices
  - 0shotCoT.txt     : typo fixed, 0.5 mentioned in preamble
"""

import ast
from langchain_openai import ChatOpenAI
from google import genai
from google.genai import types
from tqdm import tqdm
from utils import *
import pandas as pd
import os
import sys
from concurrent.futures import ThreadPoolExecutor, as_completed

# ── v2 override: point to the new prompts sub-folder ──────────────────────────
FIRST_PAPER_V2 = "managerial_leadership_Jordi_Cooper_v2/"

PAPER_PATHS_V2 = {
    1: FIRST_PAPER_V2,
}

# ── LLM globals (same pattern as text_llms_new.py) ────────────────────────────
llm_chatgpt = None
llm_gemini  = None

GEMINI_WORKERS         = 20
SELECTED_CHATGPT_MODEL = "gpt-5.2"
SELECTED_GEMINI_MODEL  = "gemini-3.1-pro-preview"


# ── Helpers ───────────────────────────────────────────────────────────────────

def write_rows_to_csv(output_path, rows):
    if not rows:
        return
    file_exists = os.path.exists(output_path)
    pd.DataFrame(rows).to_csv(
        output_path,
        mode="a",
        header=not file_exists,
        index=False,
        encoding="utf-8",
    )


def get_chatgpt_client():
    global llm_chatgpt
    if llm_chatgpt is None or llm_chatgpt.model_name != SELECTED_CHATGPT_MODEL:
        llm_chatgpt = ChatOpenAI(
            model=SELECTED_CHATGPT_MODEL,
            max_retries=1,
            api_key=OAI_2,
        )
    return llm_chatgpt


def get_gemini_client():
    global llm_gemini
    if llm_gemini is None:
        if not GEMINI:
            raise ValueError("Missing GEMINI API key. Set GEMINI in your .env file.")
        llm_gemini = genai.Client(api_key=GEMINI)
    return llm_gemini


def call_llm_for_message(base_prompt, message, temp, llm, mode="user"):
    if llm == "gemini":
        full_prompt = (
            base_prompt
            + "\n\nClassify ONLY this message and return only a Python dictionary:\n"
            + str(message)
        )
        response = get_gemini_client().models.generate_content(
            model=SELECTED_GEMINI_MODEL,
            contents=full_prompt,
            config=types.GenerateContentConfig(temperature=temp),
        )
        return response.text

    user_prompt = (
        "Classify ONLY this message and return only a Python dictionary. "
        "Do not add explanations.\n\n"
        f"Message:\n{message}"
    )
    if mode == "user":
        response = get_chatgpt_client().bind(temperature=temp).invoke([
            ("system", base_prompt),
            ("user",   user_prompt),
        ])
    else:
        response = get_chatgpt_client().invoke_as_assistant(user_prompt, temperature=temp)
    return response.content


def parse_llm_dict(ans):
    try:
        start = ans.find("{")
        end   = ans.rfind("}") + 1
        raw   = ans[start:end]
        return ast.literal_eval(raw)
    except Exception:
        return {"error": ans[:300]}


def seleccionar_temperaturas():
    options = [0, 0.1, 0.5, 1, 1.2]
    while True:
        print("\n--- Select temperature(s) ---")
        for i, v in enumerate(options, 1):
            print(f"{i}. {v}")
        print(f"{len(options)+1}. All")
        opt = input("Choose an option: ").strip()
        if opt.isdigit():
            n = int(opt)
            if 1 <= n <= len(options):
                return [options[n - 1]], False
            if n == len(options) + 1:
                return options, True
        print("Invalid option.")


def leer_archivo_txt(filepath):
    with open(filepath, "r", encoding="utf-8") as f:
        return f.read()


def crear_prompt_basico_v2(
    filenames=[ROLE_FILE, CONTEXT_FILE, CLASSIFICATION_FILE, FORMAT_FILE, CONSTRAINTS_FILE],
):
    """
    Build the base prompt from the v2 prompts folder.
    Uses FIRST_PAPER_V2 instead of FIRST_PAPER so the original files are untouched.
    """
    contents = []
    for filename in filenames:
        full_path = os.path.join(PROMPTS_PATH, FIRST_PAPER_V2, filename)
        contents.append(leer_archivo_txt(full_path))
    return "\n".join(contents)


# ── Classification strategies (Paper 1 only, v2 prompts) ──────────────────────

def asignar_zero_shot_v2(llm):
    print("\n>>> Zero-Shot  [v2 prompts]")
    prompt = crear_prompt_basico_v2()
    obtener_categorizacion_llm_v2(prompt, llm, "0shot")


def asignar_few_shot_v2(llm):
    print("\n>>> Few-Shot  [v2 prompts]")
    prompt = crear_prompt_basico_v2()
    fewshot_path = os.path.join(PROMPTS_PATH, FIRST_PAPER_V2, FEWSHOT_FILE)
    prompt += "\n" + leer_archivo_txt(fewshot_path)
    obtener_categorizacion_llm_v2(prompt, llm, "fewshot")


def asignar_zero_shot_cot_v2(llm):
    print("\n>>> Zero-Shot CoT  [v2 prompts]")
    prompt = crear_prompt_basico_v2()
    cot_path = os.path.join(PROMPTS_PATH, FIRST_PAPER_V2, ZEROSHOTCOT_FILE)
    prompt += "\n" + leer_archivo_txt(cot_path)
    obtener_categorizacion_llm_v2(prompt, llm, "0shot_cot")


def asignar_few_shot_cot_v2(llm):
    print("\n>>> Few-Shot CoT  [v2 prompts]")
    prompt = crear_prompt_basico_v2()
    cot_path = os.path.join(PROMPTS_PATH, FIRST_PAPER_V2, FEWSHOTCOT_FILE)
    prompt += "\n" + leer_archivo_txt(cot_path)
    obtener_categorizacion_llm_v2(prompt, llm, "fewshot_cot")


# ── Core classification loop ──────────────────────────────────────────────────

def obtener_categorizacion_llm_v2(prompt, llm, strategy_folder):
    """
    Run the classification for Paper 1 with the v2 prompts and save results
    under Results/<llm>/managerial_leadership_Jordi_Cooper_v2/<strategy_folder>/.
    Results file naming is identical to the original so metrics_paper1_v2.py
    can load them with the same logic.
    """
    temps, _ = seleccionar_temperaturas()
    modes    = ["user"]

    # Data is read from the SAME source as the original (no data change)
    data_path = os.path.join(DATA_PATH, FIRST_PAPER, DATA_FILE)
    df = pd.read_csv(data_path)
    message_col = "message"
    df = df.dropna(subset=[message_col]).reset_index(drop=True)

    read_mode = input("Read line by line (1) or in groups (2)? Enter 1 or 2: ")

    # ── LINE BY LINE ──────────────────────────────────────────────────────────
    if read_mode == "1":
        for temp in temps:
            for mode in modes:
                out_file    = f"results_line_temp{temp}_mode{mode}.csv"
                LLM         = "gemini" if llm == "gemini" else "gpt"
                output_path = os.path.join(
                    RESULTS_PATH, LLM, FIRST_PAPER_V2, strategy_folder, out_file
                )
                os.makedirs(os.path.dirname(output_path), exist_ok=True)

                # Checkpoint
                if os.path.exists(output_path):
                    existing_df   = pd.read_csv(output_path)
                    processed_ids = set(existing_df["row_id"].tolist()) if "row_id" in existing_df.columns else set()
                    print(f"Resuming. {len(processed_ids)} rows already processed.")
                else:
                    processed_ids = set()
                    print("New results file.")

                pending = [(idx, row[message_col]) for idx, row in df.iterrows() if idx not in processed_ids]

                if llm == "gemini":
                    buffer = []
                    with ThreadPoolExecutor(max_workers=GEMINI_WORKERS) as ex:
                        futures = {
                            ex.submit(call_llm_for_message, prompt, msg, temp, llm, mode): (idx, msg)
                            for idx, msg in pending
                        }
                        for future in tqdm(as_completed(futures), total=len(futures),
                                           desc=f"[Gemini] Temp {temp}"):
                            idx, msg = futures[future]
                            try:
                                parsed = parse_llm_dict(future.result())
                                parsed["original_message"] = msg
                                parsed["row_id"] = idx
                                buffer.append(parsed)
                                if len(buffer) >= 10:
                                    write_rows_to_csv(output_path, buffer)
                                    buffer = []
                            except Exception as e:
                                print(f"⚠ Error row {idx}: {e}")
                    write_rows_to_csv(output_path, buffer)

                else:
                    buffer = []
                    for idx, msg in tqdm(pending, total=len(pending), desc=f"[GPT] Temp {temp}"):
                        try:
                            parsed = parse_llm_dict(call_llm_for_message(prompt, msg, temp, llm, mode))
                            parsed["original_message"] = msg
                            parsed["row_id"] = idx
                            buffer.append(parsed)
                            if len(buffer) >= 10:
                                write_rows_to_csv(output_path, buffer)
                                buffer = []
                        except KeyboardInterrupt:
                            write_rows_to_csv(output_path, buffer)
                            print("\nInterrupted. Progress saved.")
                            sys.exit()
                        except Exception as e:
                            print(f"⚠ Error row {idx}: {e}")
                            break
                    write_rows_to_csv(output_path, buffer)

                print(f"✔ Saved → {output_path}")

    # ── GROUP MODE ────────────────────────────────────────────────────────────
    else:
        group_sizes_file = input("Load txt file with group sizes? (y/n): ")
        if group_sizes_file.lower() in ("y", "yes"):
            fp = os.path.join(DATA_PATH, FIRST_PAPER, "conteo_por_juego.txt")
            with open(fp, "r", encoding="utf-8") as f:
                group_sizes = [int(l.strip()) for l in f if l.strip().isdigit()]
        else:
            raw = input("Enter group sizes separated by commas (e.g., 2,5,10): ")
            group_sizes = [int(s.strip()) for s in raw.split(",") if s.strip().isdigit()]

        if not group_sizes:
            print("No valid group sizes. Aborting.")
            return

        for temp in temps:
            for mode in modes:
                out_file    = f"results_group_temp{temp}_mode{mode}.csv"
                LLM         = "gemini" if llm == "gemini" else "gpt"
                output_path = os.path.join(
                    RESULTS_PATH, LLM, FIRST_PAPER_V2, strategy_folder, out_file
                )
                os.makedirs(os.path.dirname(output_path), exist_ok=True)

                if os.path.exists(output_path):
                    existing_df   = pd.read_csv(output_path)
                    processed_ids = set(existing_df["group_id"].tolist()) if "group_id" in existing_df.columns else set()
                    print(f"Resuming. {len(processed_ids)} groups already processed.")
                else:
                    processed_ids = set()
                    print("New results file.")

                start_idx     = 0
                group_counter = 0
                actor_col     = "Type" if "Type" in df.columns else None

                while start_idx < len(df):
                    for group_size in group_sizes:
                        if start_idx >= len(df):
                            break
                        end_idx = min(start_idx + group_size, len(df))
                        if group_counter in processed_ids:
                            start_idx     += group_size
                            group_counter += 1
                            continue

                        group_msgs = df[message_col].iloc[start_idx:end_idx].tolist()
                        if actor_col:
                            actor      = df[actor_col].iloc[start_idx:end_idx].tolist()
                            group_msgs = [f"{a}; {m}" for a, m in zip(actor, group_msgs)]

                        combined_csv    = "/".join(group_msgs)
                        combined_prompt = "\n".join(group_msgs)
                        full_prompt     = prompt + "\n\nThese are the messages you should analyze:\n" + combined_prompt

                        try:
                            if llm == "gemini":
                                ans = get_gemini_client().models.generate_content(
                                    model=SELECTED_GEMINI_MODEL,
                                    contents=full_prompt,
                                    config=types.GenerateContentConfig(temperature=temp),
                                ).text
                            else:
                                ans = get_chatgpt_client().invoke(full_prompt, temperature=temp).content

                            parsed = parse_llm_dict(ans)
                            parsed["original_messages"] = combined_csv
                            parsed["group_id"]          = group_counter

                            file_exists = os.path.exists(output_path)
                            with open(output_path, "a", encoding="utf-8") as f:
                                pd.DataFrame([parsed]).to_csv(f, header=not file_exists, index=False)

                        except KeyboardInterrupt:
                            print("\nInterrupted. Progress saved.")
                            sys.exit()
                        except Exception as e:
                            print(f"⚠ Error group {group_counter}: {e}")
                            return

                        print(f"Processed group {group_counter}")
                        start_idx     += group_size
                        group_counter += 1

                print(f"✔ Saved → {output_path}")


# ── Menu ──────────────────────────────────────────────────────────────────────

def seleccionar_llm():
    global SELECTED_CHATGPT_MODEL, SELECTED_GEMINI_MODEL, llm_chatgpt

    CHATGPT_MODELS = {"1": "gpt-5.2", "2": "gpt-5.1", "3": "gpt-5-mini", "4": "gpt-4o"}
    GEMINI_MODELS  = {"1": "gemini-3.1-pro-preview", "2": "gemini-3-flash-preview",
                      "3": "gemini-3-pro-preview"}

    while True:
        print(f"\n--- Select LLM [ChatGPT/{SELECTED_CHATGPT_MODEL} | Gemini/{SELECTED_GEMINI_MODEL}] ---")
        print("1. ChatGPT")
        print("2. Gemini")
        print("3. Go back")
        opt = input("Choose: ")
        if opt == "1":
            for k, v in CHATGPT_MODELS.items():
                print(f"{k}. {v}" + (" ◀ current" if v == SELECTED_CHATGPT_MODEL else ""))
            m = input("Choose model: ").strip()
            if m in CHATGPT_MODELS:
                SELECTED_CHATGPT_MODEL = CHATGPT_MODELS[m]
            llm_chatgpt = None
            return "chatgpt"
        elif opt == "2":
            for k, v in GEMINI_MODELS.items():
                print(f"{k}. {v}" + (" ◀ current" if v == SELECTED_GEMINI_MODEL else ""))
            m = input("Choose model: ").strip()
            if m in GEMINI_MODELS:
                SELECTED_GEMINI_MODEL = GEMINI_MODELS[m]
            return "gemini"
        elif opt == "3":
            return None
        else:
            print("Invalid option.")


def menu_asignacion_v2():
    while True:
        print("\n--- Paper 1 [v2 prompts] — Select strategy ---")
        print("1. Zero-Shot")
        print("2. Few-Shot")
        print("3. Zero-Shot CoT")
        print("4. Few-Shot CoT")
        print("5. Go back")
        opt = input("Choose: ")
        if opt == "1":
            llm = seleccionar_llm()
            if llm: asignar_zero_shot_v2(llm)
        elif opt == "2":
            llm = seleccionar_llm()
            if llm: asignar_few_shot_v2(llm)
        elif opt == "3":
            llm = seleccionar_llm()
            if llm: asignar_zero_shot_cot_v2(llm)
        elif opt == "4":
            llm = seleccionar_llm()
            if llm: asignar_few_shot_cot_v2(llm)
        elif opt == "5":
            return
        else:
            print("Invalid option.")


def main():
    print("\n=== Paper 1 v2 experiment runner ===")
    print("Results → Results/<llm>/managerial_leadership_Jordi_Cooper_v2/")
    print("Prompts → prompts/managerial_leadership_Jordi_Cooper_v2/")
    while True:
        print("\n1. Classify (assign categories)")
        print("2. Exit")
        opt = input("Choose: ")
        if opt == "1":
            menu_asignacion_v2()
        elif opt == "2":
            break
        else:
            print("Invalid option.")


main()
