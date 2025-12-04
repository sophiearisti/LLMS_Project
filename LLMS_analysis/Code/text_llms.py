import ast
from langchain_openai import ChatOpenAI
from tqdm import tqdm
from utils import *
import pandas as pd
import os

# Diccionario global
PAPER_PATHS = {
    1: FIRST_PAPER,
    2: SECOND_PAPER,
    3: THIRD_PAPER,
    4: FOURTH_PAPER
}

llm_chatgpt = ChatOpenAI(
    model="gpt-4o",
    max_retries=1,
    api_key=OAI_2
)


"""# Cargar la base de datos y filtrar filas sin 'razones'
df = pd.read_excel('../data/directores/db_directores.xls')
df = df.dropna(subset=['razones']).reset_index(drop=True)

# Instanciar el modelo ChatGPT
llm_chatgpt = ChatOpenAI(
    model="gpt-4o",
    max_retries=1,
    api_key=OAI_2
)

# Definir temperaturas a utilizar
TEMPS = [0, 0.5]

infos = []

# Iterar sobre temperaturas y textos en la columna 'razones', y capturar 'departamento'
for num in range(1):
    for temp in tqdm(TEMPS, desc="Temperaturas", total=len(TEMPS)):
        # Itera sobre cada par (razones, departamento)
        for text, dept in tqdm(zip(df['razones'].values, df['departamento'].values),
                                 desc="Datos", total=len(df)):
            # Construir el prompt y obtener la respuesta con la temperatura correspondiente
            ans = llm_chatgpt.invoke(PROMPT_1 + " " + text, temperature=temp)
            ans = ans.content  # Extraer el contenido de la respuesta
            # Se asume que la respuesta contiene un diccionario en formato string,
            # por lo que se extrae la parte que comienza con '{'
            idx = ans.find("{")
            ans = ans[idx:]
            dictio = {
                'llm': f"gpt-4o_{temp}",
                'info': ans,
                'num': num,
                'departamento': dept  # Se guarda el departamento
            }
            infos.append(dictio)



# Procesar las respuestas evaluándolas y convirtiéndolas en Series de pandas
series = []
errores = []
for idx, dictio in enumerate(infos):
    try:
        di = eval(dictio['info'])
        di['llm'] = dictio['llm']
        di['num'] = dictio['num']
        di['departamento'] = dictio['departamento']  # Incluir el departamento
        series.append(pd.Series(di))
    except Exception as e:
        print("Error al evaluar la respuesta:", dictio['llm'], idx)
        errores.append(dictio)

# Concatenar las series en un DataFrame (se conservan todas las columnas)
data = pd.concat(series, axis=1).T


# Guardar el resultado en un archivo CSV
data.to_csv('../results/directores/results_db_directores.csv', index=False)
"""

def parse_llm_dict(ans):

    try:
        start = ans.find("{")
        end   = ans.rfind("}") + 1
        raw_dict = ans[start:end]
        return ast.literal_eval(raw_dict)
    except:
        return {"error": ans[:300]}

def obtener_categorias_llm(prompt, paper):
    temps   = [0, 0.2, 0.25, 0.5, 0.6, 0.7, 1]
    modes   = ["user"] # "assistant"]
    
    path = os.path.join(DATA_PATH, PAPER_PATHS[int(paper)], "classify.csv")
    df = pd.read_csv(path)
    #obtener todo el csv y guardarlo como un string
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
            if mode == "user":
                response = llm_chatgpt.invoke(full_prompt, temperature=temp)
            else:
                response = llm_chatgpt.invoke_as_assistant(full_prompt, temperature=temp)
            ans = response.content
            # -----------------------------------------------------

            parsed = parse_llm_dict(ans)

            print(f"Respuesta del LLM (Temp: {temp}, Mode: {mode}):")
            print(parsed)
            return parsed

def obtener_categorizacion_llm(prompt, paper):
    temps   = [0, 0.2, 0.25, 0.5, 0.6, 0.7, 1]
    modes   = ["user"] #, "assistant"]

    path = os.path.join(DATA_PATH, PAPER_PATHS[int(paper)], DATA_FILE)
    df = pd.read_csv(path)

    message_col = "message"
    
    #hay una que tiene Message ESTO SE QUITA IGUALMENE PORQUEME DA TOC
    if "message" not in df.columns:
        message_col = "Message"

    read_mode = input("¿Desea leer línea por línea (1) o en grupos (2)? Ingrese 1 o 2: ")

    if read_mode == "1":

        for temp in temps:
            for mode in modes:

                results = []

                for idx, row in tqdm(df.iterrows(), total=len(df),
                                     desc=f"[Linea] Temp {temp}, Mode {mode}"):

                    message = row[message_col]

                    full_prompt = (
                        prompt +
                        "\n\nThis is the message you should analyze:\n" +
                        str(message)
                    )
                    
                    print(full_prompt)

                    # LLAMADA AL LLM --------------------------------------
                    if mode == "user":
                        response = llm_chatgpt.invoke(full_prompt, temperature=temp)
                    else:
                        response = llm_chatgpt.invoke_as_assistant(full_prompt, temperature=temp)
                    ans = response.content
                    # -----------------------------------------------------
                    
                    print(ans)
                    
                    parsed = parse_llm_dict(ans)
                    parsed["original_message"] = message

                    results.append(parsed)

                # GUARDAR RESULTADOS POR TEMP Y MODO
                out_file = f"results_temp{temp}_mode{mode}.csv"
                output_path = os.path.join(RESULTS_PATH, PAPER_PATHS[int(paper)], out_file)

                pd.DataFrame(results).to_csv(output_path, index=False)
                print(f"✔ Resultados guardados en {output_path}")
    else:

        group_sizes = [51]  

        for temp in temps:
            for mode in modes:

                results = []
                start_idx = 0

                while start_idx < len(df):

                    for group_size in group_sizes:

                        end_idx = min(start_idx + group_size, len(df))

                        group_msgs = df[message_col].iloc[start_idx:end_idx].tolist()
                        combined_message = "\n".join(group_msgs)

                        full_prompt = (
                            prompt +
                            "\n\nThese are the messages you should analyze:\n" +
                            combined_message
                        )

                        # LLAMADA AL LLM --------------------------------------
                        if mode == "user":
                            response = llm_chatgpt.invoke(full_prompt, temperature=temp)
                        else:
                            response = llm_chatgpt.invoke_as_assistant(full_prompt, temperature=temp)
                        ans = response.content
                        # -----------------------------------------------------

                        parsed = parse_llm_dict(ans)
                        parsed["original_messages"] = combined_message

                        results.append(parsed)

                        start_idx += group_size

                        if start_idx >= len(df):
                            break

                out_file = f"results_temp{temp}_mode{mode}_group.csv"
                output_path = os.path.join(RESULTS_PATH, PAPER_PATHS[int(paper)], out_file)

                pd.DataFrame(results).to_csv(output_path, index=False)
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


def crear_categorias(paper):
    print(f"\n>>> Creando categorías para Paper {paper}...")
    
    # Crear el prompt básico
    prompt = crear_prompt_basico(PAPER_PATHS[int(paper)], filenames=[ROLE_FILE, CONTEXT_FILE, CLASSIFICATION_CAT_FILE, FORMAT_CAT_FILE])
    
    
    # pedir a chat gpt que cree las categorias
    categorias=obtener_categorias_llm(prompt, paper)
    
    print(f"\n>>> Estas son las categorías creadas para Paper {paper}...")
    
    print(categorias)
    
    print(f"\n>>> Ahora clasifiquemos cada texto...")
    
    menu_asignacion_pos_categorizacion(paper)
    

def asignar_zero_shot(paper):
    print(f"\n>>> Asignando categorías (Zero-Shot) para Paper {paper}...")
    prompt = crear_prompt_basico(PAPER_PATHS[int(paper)])
    # pedir a chat gpt que cree las categorias
    obtener_categorizacion_llm(prompt, paper)


def asignar_few_shot(paper):
    print(f"\n>>> Asignando categorías (Few-Shot) para Paper {paper}...")
    prompt = crear_prompt_basico(PAPER_PATHS[int(paper)])
    #agregar la parte de few-shot
    #leer el fewshot.txt
    fewshot_path = os.path.join(PROMPTS_PATH, PAPER_PATHS[int(paper)], FEWSHOT_FILE)
    fewshot_text = leer_archivo_txt(fewshot_path)
    prompt += "\n" + fewshot_text   
    
    # pedir a chat gpt que cree las categorias
    obtener_categorizacion_llm(prompt, paper)

def asignar_zero_shot_cot(paper):
    print(f"\n>>> Asignando categorías (Zero-Shot CoT) para Paper {paper}...")
    prompt = crear_prompt_basico(PAPER_PATHS[int(paper)])
    #agregar la parte de 0ShotCoT
    #leer el 0ShotCoT.txt
    zeroshotcot_path = os.path.join(PROMPTS_PATH,PAPER_PATHS[int(paper)], ZEROSHOTCOT_FILE)
    zeroshotcot_text = leer_archivo_txt(zeroshotcot_path)
    prompt += "\n" + zeroshotcot_text
    
    # pedir a chat gpt que cree las categorias
    obtener_categorizacion_llm(prompt, paper)

def asignar_few_shot_cot(paper):
    print(f"\n>>> Asignando categorías (Few-Shot CoT) para Paper {paper}...")
    # agregar la parte de few-shot CoT
    prompt = crear_prompt_basico(PAPER_PATHS[int(paper)])
    #leer el few-shotCoT.txt
    fewshotcot_path = os.path.join(PROMPTS_PATH,PAPER_PATHS[int(paper)], FEWSHOTCOT_FILE)
    fewshotcot_text = leer_archivo_txt(fewshotcot_path)
    prompt += "\n" + fewshotcot_text
    
    obtener_categorizacion_llm(prompt, paper)
    
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
            asignar_zero_shot(paper)
        elif opcion == "2":
            asignar_few_shot(paper)
        elif opcion == "3":
            asignar_zero_shot_cot(paper)
        elif opcion == "4":
            asignar_few_shot_cot(paper)
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
            asignar_zero_shot(paper)
        elif opcion == "2":
            asignar_few_shot(paper)
        elif opcion == "3":
            asignar_zero_shot_cot(paper)
        elif opcion == "4":
            asignar_few_shot_cot(paper)
        elif opcion == "5":
            return
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
                crear_categorias(paper)

            elif accion == "2":
                menu_asignacion(paper)

            elif accion == "3":
                break

            else:
                print("Opción no válida.")


# Ejecutar todo
main_menu()
