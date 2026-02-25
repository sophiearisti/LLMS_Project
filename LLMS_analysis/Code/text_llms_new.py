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

# Diccionario global
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
    if llm_chatgpt is None:
        llm_chatgpt = ChatOpenAI(
            model="gpt-5.1",
            max_retries=1,
            api_key=OAI_2
        )
    return llm_chatgpt


def get_gemini_client():
    global llm_gemini
    if llm_gemini is None:
        llm_gemini = genai.Client()
    return llm_gemini


def call_llm_for_message(base_prompt, message, temp, llm, mode="user"):
    if llm == "gemini":
        full_prompt = (
            base_prompt +
            "\n\nClassify ONLY this message and return only a Python dictionary:\n" +
            str(message)
        )
        response = llm_gemini.models.generate_content(
        response = get_gemini_client().models.generate_content(
            model=GEMINI_CLASSIFY_MODEL,
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
    
    # obtener todo el csv y guardarlo como un string
    messages = df["message"].tolist()
    
    combined_messages = "\n".join(messages)
    full_prompt = (
        prompt +
        "\n\nThese are the messages you should analyze:\n" +
        combined_messages
    )

    for temp in temps:
        for mode in modes:

            print(f"\n--- Obteniendo categorías para Paper {paper} | Temp: {temp} | Mode: {mode} ---\n")
            
            # LLAMADA AL LLM --------------------------------------
            
            # preguntal cual llm usar
            if llm == "gemini":
                
                response = get_gemini_client().models.generate_content(
                                model=GEMINI_CATEGORY_MODEL,
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

            print(f"Respuesta del LLM (Temp: {temp}, Mode: {mode}):")
            print(parsed)
            
            # escribir las categorias a un archivo txt
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

    read_mode = input("¿Desea leer línea por línea (1) o en grupos (2)? Ingrese 1 o 2: ")

    # ==========================================================
    # ======================= LINEA POR LINEA ==================
    # ==========================================================
    if read_mode == "1":

        for temp in temps:
            for mode in modes:

                out_file = f"results_temp{temp}_mode{mode}.csv"
                LLM = "gemini" if llm == "gemini" else "gpt"
                output_path = os.path.join(
                    RESULTS_PATH, LLM, PAPER_PATHS[int(paper)], out_file
                )

                # ---------- CHECKPOINT ----------
                if os.path.exists(output_path):
                    existing_df = pd.read_csv(output_path)
                    processed_ids = set(existing_df["row_id"].tolist())
                    print(f"Retomando ejecución. {len(processed_ids)} filas ya procesadas.")
                else:
                    processed_ids = set()
                    print("Nuevo archivo de resultados.")

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
                            desc=f"[Linea][Gemini x{GEMINI_WORKERS}] Temp {temp}, Mode {mode}"
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
                                print("\n Interrumpido manualmente. Progreso guardado.")
                                sys.exit()
                            except Exception as e:
                                print(f"\n⚠ Error en fila {idx}: {e}")

                    write_rows_to_csv(output_path, rows_buffer)

                else:
                    rows_buffer = []
                    for idx, message in tqdm(
                        pending_rows,
                        total=len(pending_rows),
                        desc=f"[Linea][GPT] Temp {temp}, Mode {mode}"
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
                            print("\n Interrumpido manualmente. Progreso guardado.")
                            sys.exit()

                        except Exception as e:
                            print(f"\n⚠ Error en fila {idx}: {e}")
                            print("Progreso guardado hasta ahora.")
                            break

                    write_rows_to_csv(output_path, rows_buffer)

                print(f"✔ Resultados guardados en {output_path}")

    # ==========================================================
    # ======================= MODO GRUPOS ======================
    # ==========================================================
    else:

        group_sizes = []

        group_sizes_file = input("¿Desea subir un archivo txt con los tamaños de grupo? (s/n): ")

        if group_sizes_file.lower() == "s":
            filepath = "../Data/managerial_leadership_Jordi_Cooper/conteo_por_juego.txt"
            with open(filepath, "r", encoding="utf-8") as f:
                group_sizes = [int(line.strip()) for line in f if line.strip().isdigit()]
        else:
            group_sizes_input = input("Ingrese los tamaños de grupo separados por comas (por ejemplo, 2,5,10): ")
            group_sizes = [int(size.strip()) for size in group_sizes_input.split(",") if size.strip().isdigit()]

        if not group_sizes:
            print("No se definieron tamaños de grupo válidos. Abortando modo grupos.")
            return

        for temp in temps:
            for mode in modes:

                out_file = f"results_temp{temp}_mode{mode}.csv"
                LLM = "gemini" if llm == "gemini" else "gpt"
                output_path = os.path.join(
                    RESULTS_PATH, LLM, PAPER_PATHS[int(paper)], out_file
                )

                # ---------- CHECKPOINT ----------
                if os.path.exists(output_path):
                    existing_df = pd.read_csv(output_path)
                    processed_ids = set(existing_df["group_id"].tolist())
                    print(f"🔄 Retomando ejecución. {len(processed_ids)} grupos ya procesados.")
                else:
                    processed_ids = set()
                    print("🆕 Nuevo archivo de resultados.")

                start_idx = 0
                group_counter = 0

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
                        actor = df["Type"].iloc[start_idx:end_idx].tolist()

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
                                    model=GEMINI_CLASSIFY_MODEL,
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
                            print("\n⛔ Interrumpido manualmente. Progreso guardado.")
                            sys.exit()

                        except Exception as e:
                            print(f"\n⚠ Error en grupo {group_counter}: {e}")
                            print("Progreso guardado hasta ahora.")
                            return

                        print(f"Procesado grupo {group_counter}")
                        start_idx += group_size
                        group_counter += 1

                print(f"✔ Resultados guardados en {output_path}")
 
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
    print(f"\n>>> Creando categorías para Paper {paper}...")
    
    # Crear el prompt básico
    prompt = crear_prompt_basico(PAPER_PATHS[int(paper)], filenames=[ROLE_FILE, CONTEXT_FILE, CLASSIFICATION_CAT_FILE, FORMAT_CAT_FILE])
    
    
    # pedir a chat gpt que cree las categorias
    categorias=obtener_categorias_llm(prompt, paper, llm)
    
    print(f"\n>>> Estas son las categorías creadas para Paper {paper}...")
    
    print(categorias)
    
    print(f"\n>>> Ahora clasifiquemos cada texto...")
    
    menu_asignacion_pos_categorizacion(paper) 

def asignar_zero_shot(paper, llm):
    print(f"\n>>> Asignando categorías (Zero-Shot) para Paper {paper}...")
    prompt = crear_prompt_basico(PAPER_PATHS[int(paper)])
    # pedir a chat gpt que cree las categorias
    obtener_categorizacion_llm(prompt, paper, llm)
    
def asignar_few_shot(paper, llm):
    print(f"\n>>> Asignando categorías (Few-Shot) para Paper {paper}...")
    prompt = crear_prompt_basico(PAPER_PATHS[int(paper)])
    #agregar la parte de few-shot
    #leer el fewshot.txt
    fewshot_path = os.path.join(PROMPTS_PATH, PAPER_PATHS[int(paper)], FEWSHOT_FILE)
    fewshot_text = leer_archivo_txt(fewshot_path)
    #si el archivo esta vacio, pedir los ejemplos por consola
    fewshot_text = empty_examples(fewshot_text)
    prompt += "\n" + fewshot_text   
    
    # pedir a chat gpt que cree las categorias
    obtener_categorizacion_llm(prompt, paper, llm)

def asignar_zero_shot_cot(paper, llm):
    print(f"\n>>> Asignando categorías (Zero-Shot CoT) para Paper {paper}...")
    prompt = crear_prompt_basico(PAPER_PATHS[int(paper)])
    #agregar la parte de 0ShotCoT
    #leer el 0ShotCoT.txt
    zeroshotcot_path = os.path.join(PROMPTS_PATH,PAPER_PATHS[int(paper)], ZEROSHOTCOT_FILE)
    zeroshotcot_text = leer_archivo_txt(zeroshotcot_path)
    prompt += "\n" + zeroshotcot_text
    
    # pedir a chat gpt que cree las categorias
    obtener_categorizacion_llm(prompt, paper, llm)

def asignar_few_shot_cot(paper, llm):
    print(f"\n>>> Asignando categorías (Few-Shot CoT) para Paper {paper}...")
    # agregar la parte de few-shot CoT
    prompt = crear_prompt_basico(PAPER_PATHS[int(paper)])
    #leer el few-shotCoT.txt
    fewshotcot_path = os.path.join(PROMPTS_PATH,PAPER_PATHS[int(paper)], FEWSHOTCOT_FILE)
    fewshotcot_text = leer_archivo_txt(fewshotcot_path)
    #si el archivo esta vacio, pedir los ejemplos por consola
    fewshotcot_text = empty_examples(fewshotcot_text)
    prompt += "\n" + fewshotcot_text
    
    obtener_categorizacion_llm(prompt, paper, llm)
    
def empty_examples(fewshot_text):
    if fewshot_text.strip() == "":
        print("El archivo fewShot.txt está vacío. Por favor, ingrese ejemplos de few-shot (deje una línea vacía para terminar):")
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
        print("\n--- Selecciona el tipo de estrategia de asignación ---")
        print("1. Zero-Shot")
        print("2. Few-Shot")
        print("3. Zero-Shot CoT")
        print("4. Few-Shot CoT")
        print("5. Volver al menú anterior")

        opcion = input("Elige una opción: ")

        if opcion == "1":
            llm = seleccionar_llm()
            asignar_zero_shot(paper, llm)
        elif opcion == "2":
            llm = seleccionar_llm()
            asignar_few_shot(paper, llm)
        elif opcion == "3":
            llm = seleccionar_llm()
            asignar_zero_shot_cot(paper, llm)
        elif opcion == "4":
            llm = seleccionar_llm()
            asignar_few_shot_cot(paper, llm)
        elif opcion == "5":
            return
        else:
            print("Opción no válida.")
             
def menu_asignacion_pos_categorizacion(paper):
    
    while True:
        print("\n--- Selecciona el tipo de estrategia de asignación ---")
        print("1. Zero-Shot")
        print("2. Few-Shot")
        print("3. Zero-Shot CoT")
        print("4. Few-Shot CoT")
        print("5. Volver al menú anterior")

        opcion = input("Elige una opción: ")

        if opcion == "1":
            llm = seleccionar_llm()
            asignar_zero_shot(paper, llm)
        elif opcion == "2":
            llm = seleccionar_llm()
            asignar_few_shot(paper, llm)
        elif opcion == "3":
            llm = seleccionar_llm()
            asignar_zero_shot_cot(paper, llm)
        elif opcion == "4":
            llm = seleccionar_llm()
            asignar_few_shot_cot(paper, llm)
        elif opcion == "5":
            return
        else:
            print("Opción no válida.")

def seleccionar_llm():
    while True:
        print("\n--- Selecciona el LLM ---")
        print("1. ChatGPT")
        print("2. Gemini")
        print("3. Volver")

        opcion = input("Elige una opción: ")

        if opcion == "1":
            return "chatgpt"
        elif opcion == "2":
            return "gemini"
        else:
            print("Opción no válida.")

def main_menu():
    
    while True:
        print("\n======= MENÚ PRINCIPAL =======")
        print("1. MANAGERIAL LEADERSHIP, TRUTH-TELLING AND EFFICIENT COORDINATION")
        print("2. STRATEGIC ENVIRONMENT EFFECT AND COMMUNICATION")
        print("3. Trust and Promises over Time")
        print("4. Underreporting of AI Use: The Role of Social Desirability Bias")
        print("5. Exit")
        
        paper = input("Selecciona el paper: ")

        if paper == "5":
            print("Saliendo del programa...")
            break
        
        if paper not in ["1", "2", "3", "4"]:
            print("Opción no válida.")
            continue
        
        print(f"\nHas seleccionado Paper {paper}")

        # Segundo menú
        while True:
            print("\n--- ¿Qué deseas hacer? ---")
            print("1. Crear categorías")
            print("2. Asignar categorías")
            print("3. Volver al menú principal")

            accion = input("Selecciona una opción: ")

            if accion == "1":
                llm = seleccionar_llm()
                crear_categorias(paper, llm)

            elif accion == "2":
                menu_asignacion(paper)

            elif accion == "3":
                break

            else:
                print("Opción no válida.")

# Ejecutar todo
main_menu()
