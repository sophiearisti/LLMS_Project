import ast
from http import client
from langchain_openai import ChatOpenAI
from google import genai
from google.genai import types
from tqdm import tqdm
from utils import *
import pandas as pd
import os
import sys
from concurrent.futures import ThreadPoolExecutor, as_completed

# Global dictionary
PAPER_PATHS = {
    1: FIRST_PAPER,
    2: SECOND_PAPER,
    3: THIRD_PAPER,
    4: FOURTH_PAPER
}

llm_chatgpt = None

llm_gemini = None

GEMINI_CATEGORY_MODEL = "gemini-3-pro-preview"
GEMINI_CLASSIFY_MODEL = "gemini-3-flash-preview"
GEMINI_WORKERS = 10

# Selected models (updated at runtime via seleccionar_llm)
SELECTED_CHATGPT_MODEL = "gpt-5.2"
SELECTED_GEMINI_MODEL = "gemini-3-flash-preview"


def write_rows_to_csv(output_path, rows):
    if not rows:
        return

    file_exists = os.path.exists(output_path)
    pd.DataFrame(rows).to_csv(
        output_path,
        mode="a",
        header=not file_exists,
        index=False,
        encoding="utf-8"
    )


def get_chatgpt_client():
    global llm_chatgpt
    if llm_chatgpt is None or llm_chatgpt.model_name != SELECTED_CHATGPT_MODEL:
        llm_chatgpt = ChatOpenAI(
            model=SELECTED_CHATGPT_MODEL,
            max_retries=1,
            api_key=OAI_2
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
            base_prompt +
            "\n\nClassify ONLY this message and return only a Python dictionary:\n" +
            str(message)
        )
        response = get_gemini_client().models.generate_content(
            model=SELECTED_GEMINI_MODEL,
            contents=full_prompt,
            config=types.GenerateContentConfig(temperature=temp)
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
            ("user", user_prompt)
        ])
    else:
        response = get_chatgpt_client().invoke_as_assistant(user_prompt, temperature=temp)

    return response.content

def parse_llm_dict(ans):

    try:
        start = ans.find("{")
        end   = ans.rfind("}") + 1
        raw_dict = ans[start:end]
        return ast.literal_eval(raw_dict)
    except:
        return {"error": ans[:300]}

def obtener_categorias_llm(prompt, paper, llm):  
    
    temps   = [0, 0.1, 0.5,  1, 1.2]
    modes   = ["user"] #, "assistant"]
    
    path = os.path.join(DATA_PATH, PAPER_PATHS[int(paper)], "classify.csv")
    df = pd.read_csv(path)
    
    # get all csv content and store as a string
    messages = df["message"].tolist()
    
    combined_messages = "\n".join(messages)
    full_prompt = (
        prompt +
        "\n\nThese are the messages you should analyze:\n" +
        combined_messages
    )

    for temp in temps:
        for mode in modes:

            print(f"\n--- Getting categories for Paper {paper} | Temp: {temp} | Mode: {mode} ---\n")
            
            # LLM CALL --------------------------------------
            
            if llm == "gemini":
                
                response = get_gemini_client().models.generate_content(
                                model=SELECTED_GEMINI_MODEL,
                                contents=full_prompt,
                                config=types.GenerateContentConfig(temperature=temp)
                            )
                
                ans = response.text
                
            else:
                
                if mode == "user":
                    response = get_chatgpt_client().invoke(full_prompt, temperature=temp)
                    
                else:
                    response = get_chatgpt_client().invoke_as_assistant(full_prompt, temperature=temp)
                
                ans = response.content
            # -----------------------------------------------------

            parsed = parse_llm_dict(ans)

            print(f"LLM Response (Temp: {temp}, Mode: {mode}):")
            print(parsed)
            
            # write categories to a txt file
            path = os.path.join(PROMPTS_PATH, PAPER_PATHS[int(paper)], CLASSIFICATION_FILE)
            
            # append to the file
            with open(path, "w", encoding="utf-8") as f:
                f.write("Bearing in mind these categories, your next task is to classify each of the messages in one or more of them. These are the categories, the way they are named are how they must be tagged in the python dictionary:\n\n")
                
                for key, value in parsed.items():
                    f.write(f"{key}: {value}\n\n")

            return parsed

def obtener_categorizacion_llm(prompt, paper, llm):

    temps   = [0, 0.1, 0.5, 1, 1.2]
    modes   = ["user"]

    path = os.path.join(DATA_PATH, PAPER_PATHS[int(paper)], DATA_FILE)
    df = pd.read_csv(path)

    message_col = "message"
    df = df.dropna(subset=[message_col]).reset_index(drop=True)

    read_mode = input("Read line by line (1) or in groups (2)? Enter 1 or 2: ")

    # ==========================================================
    # ========================= LINE BY LINE ===================
    # ==========================================================
    if read_mode == "1":

        for temp in temps:
            for mode in modes:

                out_file = f"results_line_temp{temp}_mode{mode}.csv"
                LLM = "gemini" if llm == "gemini" else "gpt"
                output_path = os.path.join(
                    RESULTS_PATH, LLM, PAPER_PATHS[int(paper)], out_file
                )

                # ---------- CHECKPOINT ----------
                if os.path.exists(output_path):
                    existing_df = pd.read_csv(output_path)
                    if "row_id" in existing_df.columns:
                        processed_ids = set(existing_df["row_id"].tolist())
                        print(f"Resuming execution. {len(processed_ids)} rows already processed.")
                    else:
                        processed_ids = set()
                        print("⚠ Existing results file has no row_id column. Starting from scratch for line mode.")
                else:
                    processed_ids = set()
                    print("New results file.")

                pending_rows = [
                    (idx, row[message_col])
                    for idx, row in df.iterrows()
                    if idx not in processed_ids
                ]

                if llm == "gemini":
                    rows_buffer = []

                    with ThreadPoolExecutor(max_workers=GEMINI_WORKERS) as executor:
                        futures = {
                            executor.submit(
                                call_llm_for_message,
                                prompt,
                                message,
                                temp,
                                llm,
                                mode
                            ): (idx, message)
                            for idx, message in pending_rows
                        }

                        for future in tqdm(
                            as_completed(futures),
                            total=len(futures),
                            desc=f"[Line][Gemini x{GEMINI_WORKERS}] Temp {temp}, Mode {mode}"
                        ):
                            idx, message = futures[future]
                            try:
                                ans = future.result()
                                parsed = parse_llm_dict(ans)
                                parsed["original_message"] = message
                                parsed["row_id"] = idx
                                rows_buffer.append(parsed)

                                if len(rows_buffer) >= 25:
                                    write_rows_to_csv(output_path, rows_buffer)
                                    rows_buffer = []

                            except KeyboardInterrupt:
                                write_rows_to_csv(output_path, rows_buffer)
                                print("\n Manually interrupted. Progress saved.")
                                sys.exit()
                            except Exception as e:
                                print(f"\n⚠ Error on row {idx}: {e}")

                    write_rows_to_csv(output_path, rows_buffer)

                else:
                    rows_buffer = []
                    for idx, message in tqdm(
                        pending_rows,
                        total=len(pending_rows),
                        desc=f"[Line][GPT] Temp {temp}, Mode {mode}"
                    ):
                        try:
                            ans = call_llm_for_message(prompt, message, temp, llm, mode)
                            parsed = parse_llm_dict(ans)
                            parsed["original_message"] = message
                            parsed["row_id"] = idx
                            rows_buffer.append(parsed)

                            if len(rows_buffer) >= 25:
                                write_rows_to_csv(output_path, rows_buffer)
                                rows_buffer = []

                        except KeyboardInterrupt:
                            write_rows_to_csv(output_path, rows_buffer)
                            print("\n Manually interrupted. Progress saved.")
                            sys.exit()

                        except Exception as e:
                            print(f"\n⚠ Error on row {idx}: {e}")
                            print("Progress saved so far.")
                            break

                    write_rows_to_csv(output_path, rows_buffer)

                print(f"✔ Results saved at {output_path}")

    # ==========================================================
    # ========================= GROUP MODE =====================
    # ==========================================================
    else:

        group_sizes = []

        group_sizes_file = input("Load a txt file with group sizes? (y/n): ")

        if group_sizes_file.lower() in ("y", "yes"):
            filepath = "../Data/managerial_leadership_Jordi_Cooper/conteo_por_juego.txt"
            with open(filepath, "r", encoding="utf-8") as f:
                group_sizes = [int(line.strip()) for line in f if line.strip().isdigit()]
        else:
            group_sizes_input = input("Enter group sizes separated by commas (e.g., 2,5,10): ")
            group_sizes = [int(size.strip()) for size in group_sizes_input.split(",") if size.strip().isdigit()]

        if not group_sizes:
            print("No valid group sizes defined. Aborting group mode.")
            return

        for temp in temps:
            for mode in modes:

                out_file = f"results_group_temp{temp}_mode{mode}.csv"
                LLM = "gemini" if llm == "gemini" else "gpt"
                output_path = os.path.join(
                    RESULTS_PATH, LLM, PAPER_PATHS[int(paper)], out_file
                )

                # ---------- CHECKPOINT ----------
                if os.path.exists(output_path):
                    existing_df = pd.read_csv(output_path)
                    if "group_id" in existing_df.columns:
                        processed_ids = set(existing_df["group_id"].tolist())
                        print(f"🔄 Resuming execution. {len(processed_ids)} groups already processed.")
                    else:
                        processed_ids = set()
                        print("⚠ Existing results file has no group_id column. Starting from scratch for group mode.")
                else:
                    processed_ids = set()
                    print("🆕 New results file.")

                start_idx = 0
                group_counter = 0
                actor_col = "Type" if "Type" in df.columns else None

                if actor_col is None:
                    print("⚠ Column 'Type' not found. Group prompts will use messages without actor prefix.")

                while start_idx < len(df):

                    for group_size in group_sizes:

                        if start_idx >= len(df):
                            break

                        end_idx = min(start_idx + group_size, len(df))

                        if group_counter in processed_ids:
                            start_idx += group_size
                            group_counter += 1
                            continue

                        group_msgs = df[message_col].iloc[start_idx:end_idx].tolist()
                        if actor_col is not None:
                            actor = df[actor_col].iloc[start_idx:end_idx].tolist()
                            group_msgs = [f"{a}; {m}" for a, m in zip(actor, group_msgs)]

                        combined_csv = "/".join(group_msgs)
                        combined_prompt = "\n".join(group_msgs)

                        full_prompt = (
                            prompt +
                            "\n\nThese are the messages you should analyze:\n" +
                            combined_prompt
                        )

                        try:
                            if llm == "gemini":
                                response = get_gemini_client().models.generate_content(
                                    model=SELECTED_GEMINI_MODEL,
                                    contents=full_prompt,
                                    config=types.GenerateContentConfig(temperature=temp)
                                )
                                ans = response.text
                            else:
                                response = get_chatgpt_client().invoke(full_prompt, temperature=temp)
                                ans = response.content

                            parsed = parse_llm_dict(ans)
                            parsed["original_messages"] = combined_csv
                            parsed["group_id"] = group_counter

                            file_exists = os.path.exists(output_path)

                            with open(output_path, "a", encoding="utf-8") as f:
                                pd.DataFrame([parsed]).to_csv(
                                    f,
                                    header=not file_exists,
                                    index=False
                                )

                        except KeyboardInterrupt:
                            print("\n⛔ Manually interrupted. Progress saved.")
                            sys.exit()

                        except Exception as e:
                            print(f"\n⚠ Error on group {group_counter}: {e}")
                            print("Progress saved so far.")
                            return

                        print(f"Processed group {group_counter}")
                        start_idx += group_size
                        group_counter += 1

                print(f"✔ Results saved at {output_path}")
 
def leer_archivo_txt(filepath) :

    with open(filepath, "r", encoding="utf-8") as f:
        return f.read()
   
def crear_prompt_basico(folder_path, filenames=[ROLE_FILE, CONTEXT_FILE, CLASSIFICATION_FILE, FORMAT_FILE, CONSTRAINTS_FILE]):

    contents = []

    for filename in filenames:
        full_path = os.path.join(PROMPTS_PATH, folder_path, filename)
        text = leer_archivo_txt(full_path)
        contents.append(text)

    return "\n".join(contents)

def crear_categorias(paper, llm):
    print(f"\n>>> Creating categories for Paper {paper}...")
    
    # Build the base prompt
    prompt = crear_prompt_basico(PAPER_PATHS[int(paper)], filenames=[ROLE_FILE, CONTEXT_FILE, CLASSIFICATION_CAT_FILE, FORMAT_CAT_FILE])
    
    
    # ask the llm to create categories
    categorias=obtener_categorias_llm(prompt, paper, llm)
    
    print(f"\n>>> These are the categories created for Paper {paper}...")
    
    print(categorias)
    
    print(f"\n>>> Now let's classify each text...")
    
    menu_asignacion_pos_categorizacion(paper) 

def asignar_zero_shot(paper, llm):
    print(f"\n>>> Assigning categories (Zero-Shot) for Paper {paper}...")
    prompt = crear_prompt_basico(PAPER_PATHS[int(paper)])
    obtener_categorizacion_llm(prompt, paper, llm)
    
def asignar_few_shot(paper, llm):
    print(f"\n>>> Assigning categories (Few-Shot) for Paper {paper}...")
    prompt = crear_prompt_basico(PAPER_PATHS[int(paper)])
    # add the few-shot part
    # read fewshot.txt
    fewshot_path = os.path.join(PROMPTS_PATH, PAPER_PATHS[int(paper)], FEWSHOT_FILE)
    fewshot_text = leer_archivo_txt(fewshot_path)
    # if the file is empty, ask for examples via console
    fewshot_text = empty_examples(fewshot_text)
    prompt += "\n" + fewshot_text   
    
    obtener_categorizacion_llm(prompt, paper, llm)

def asignar_zero_shot_cot(paper, llm):
    print(f"\n>>> Assigning categories (Zero-Shot CoT) for Paper {paper}...")
    prompt = crear_prompt_basico(PAPER_PATHS[int(paper)])
    # add the Zero-Shot CoT part
    # read 0ShotCoT.txt
    zeroshotcot_path = os.path.join(PROMPTS_PATH,PAPER_PATHS[int(paper)], ZEROSHOTCOT_FILE)
    zeroshotcot_text = leer_archivo_txt(zeroshotcot_path)
    prompt += "\n" + zeroshotcot_text
    
    obtener_categorizacion_llm(prompt, paper, llm)

def asignar_few_shot_cot(paper, llm):
    print(f"\n>>> Assigning categories (Few-Shot CoT) for Paper {paper}...")
    # add the few-shot CoT part
    prompt = crear_prompt_basico(PAPER_PATHS[int(paper)])
    # read few-shotCoT.txt
    fewshotcot_path = os.path.join(PROMPTS_PATH,PAPER_PATHS[int(paper)], FEWSHOTCOT_FILE)
    fewshotcot_text = leer_archivo_txt(fewshotcot_path)
    # if the file is empty, ask for examples via console
    fewshotcot_text = empty_examples(fewshotcot_text)
    prompt += "\n" + fewshotcot_text
    
    obtener_categorizacion_llm(prompt, paper, llm)
    
def empty_examples(fewshot_text):
    if fewshot_text.strip() == "":
        print("The fewShot.txt file is empty. Please enter few-shot examples (leave an empty line to finish):")
        ejemplos = []
        while True:
            linea = input()
            if linea.strip() == "":
                break
            ejemplos.append(linea)
        fewshot_text = "\n".join(ejemplos)
    return fewshot_text

def menu_asignacion(paper):
    
    while True:
        print("\n--- Select the assignment strategy ---")
        print("1. Zero-Shot")
        print("2. Few-Shot")
        print("3. Zero-Shot CoT")
        print("4. Few-Shot CoT")
        print("5. Go back")

        opcion = input("Choose an option: ")

        if opcion == "1":
            llm = seleccionar_llm()
            if llm: asignar_zero_shot(paper, llm)
        elif opcion == "2":
            llm = seleccionar_llm()
            if llm: asignar_few_shot(paper, llm)
        elif opcion == "3":
            llm = seleccionar_llm()
            if llm: asignar_zero_shot_cot(paper, llm)
        elif opcion == "4":
            llm = seleccionar_llm()
            if llm: asignar_few_shot_cot(paper, llm)
        elif opcion == "5":
            return
        else:
            print("Invalid option.")
             
def menu_asignacion_pos_categorizacion(paper):
    
    while True:
        print("\n--- Select the assignment strategy ---")
        print("1. Zero-Shot")
        print("2. Few-Shot")
        print("3. Zero-Shot CoT")
        print("4. Few-Shot CoT")
        print("5. Go back")

        opcion = input("Choose an option: ")

        if opcion == "1":
            llm = seleccionar_llm()
            if llm: asignar_zero_shot(paper, llm)
        elif opcion == "2":
            llm = seleccionar_llm()
            if llm: asignar_few_shot(paper, llm)
        elif opcion == "3":
            llm = seleccionar_llm()
            if llm: asignar_zero_shot_cot(paper, llm)
        elif opcion == "4":
            llm = seleccionar_llm()
            if llm: asignar_few_shot_cot(paper, llm)
        elif opcion == "5":
            return
        else:
            print("Invalid option.")

def seleccionar_llm():
    global SELECTED_CHATGPT_MODEL, SELECTED_GEMINI_MODEL, llm_chatgpt

    CHATGPT_MODELS = {
        "1": "gpt-4o-mini",
        "2": "gpt-4o",
        "3": "gpt-4.1",
        "4": "gpt-5.1",
    }
    GEMINI_MODELS = {
        "1": "gemini-2.0-flash",
        "2": "gemini-2.0-pro",
        "3": "gemini-3-flash-preview",
        "4": "gemini-3-pro-preview",
    }

    while True:
        print(f"\n--- Select LLM  [recommended: ChatGPT/{SELECTED_CHATGPT_MODEL}  |  Gemini/{SELECTED_GEMINI_MODEL}] ---")
        print("1. ChatGPT")
        print("2. Gemini")
        print("3. Go back")

        opcion = input("Choose an option: ")

        if opcion == "1":
            print("\n--- Select ChatGPT model ---")
            for k, v in CHATGPT_MODELS.items():
                marker = " ◀ recommended" if v == SELECTED_CHATGPT_MODEL else ""
                print(f"{k}. {v}{marker}")
            model_op = input("Choose a model: ").strip()
            if model_op in CHATGPT_MODELS:
                SELECTED_CHATGPT_MODEL = CHATGPT_MODELS[model_op]
            else:
                print(f"Invalid option. Recommended model will be used: {SELECTED_CHATGPT_MODEL}")
            llm_chatgpt = None  # force client to reinitialize with new model
            print(f"Selected model: {SELECTED_CHATGPT_MODEL}")
            return "chatgpt"

        elif opcion == "2":
            print("\n--- Select Gemini model ---")
            for k, v in GEMINI_MODELS.items():
                marker = " ◀ recommended" if v == SELECTED_GEMINI_MODEL else ""
                print(f"{k}. {v}{marker}")
            model_op = input("Choose a model: ").strip()
            if model_op in GEMINI_MODELS:
                SELECTED_GEMINI_MODEL = GEMINI_MODELS[model_op]
            else:
                print(f"Invalid option. Recommended model will be used: {SELECTED_GEMINI_MODEL}")
            print(f"Selected model: {SELECTED_GEMINI_MODEL}")
            return "gemini"

        elif opcion == "3":
            return None

        else:
            print("Invalid option.")
    
def main_menu():
    while True:
        print("\n======= MAIN MENU =======")
        print("1. MANAGERIAL LEADERSHIP, TRUTH-TELLING AND EFFICIENT COORDINATION")
        print("2. STRATEGIC ENVIRONMENT EFFECT AND COMMUNICATION")
        print("3. Trust and Promises over Time")
        print("4. Underreporting of AI Use: The Role of Social Desirability Bias")
        print("5. Exit")
        
        paper = input("Select a paper: ")

        if paper == "5":
            print("Exiting...")
            break
        
        if paper not in ["1", "2", "3", "4"]:
            print("Invalid option.")
            continue
        
        print(f"\nYou selected Paper {paper}")

        # Action submenu
        while True:
            print(f"\n--- What would you like to do? [ChatGPT/{SELECTED_CHATGPT_MODEL} | Gemini/{SELECTED_GEMINI_MODEL}] ---")
            print("1. Create categories")
            print("2. Assign categories")
            print("3. Change LLM / Model")
            print("4. Go back to main menu")

            accion = input("Select an option: ")

            if accion == "1":
                llm = seleccionar_llm()
                if llm: crear_categorias(paper, llm)

            elif accion == "2":
                menu_asignacion(paper)

            elif accion == "3":
                seleccionar_llm()

            elif accion == "4":
                break

            else:
                print("Invalid option.")

# Run everything
main_menu()
