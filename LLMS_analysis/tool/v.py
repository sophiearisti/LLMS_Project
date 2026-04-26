import streamlit as st
import pandas as pd
import ast
import re
import json
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
import shutil
import anthropic
from openai import OpenAI

llm_chatgpt = None
llm_gemini = None
llm_claude = None
llm_openai_batch = None

GEMINI_CATEGORY_MODEL = "gemini-3.1-pro-preview"
GEMINI_CLASSIFY_MODEL = "gemini-3-flash-preview"
GEMINI_WORKERS = 20
CLAUDE_MAX_TOKENS = 4096

# Selected models (updated at runtime via seleccionar_llm)
# Selected models (updated at runtime via seleccionar_llm)
SELECTED_CHATGPT_MODEL = "gpt-5.4-mini"
SELECTED_GEMINI_MODEL = "gemini-3-flash-preview"
SELECTED_CLAUDE_MODEL = "claude-sonnet-4-6"
MIN_APPEND_KEY_OVERLAP = 0.90

def seleccionar_llm_st():
    
    st.markdown("### Configuración del Modelo")
    
    col1, col2 = st.columns(2)
    
    with col1:
        proveedor = st.selectbox("Provider", ["ChatGPT", "Gemini"], index=0)

    API_KEY = st.text_input("Enter your API Key", type="default")
    
    with col2:
        if proveedor == "ChatGPT":
            modelos = gpt_models
            # El recomendado suele ser el primero o uno específico
            modelo_elegido = st.selectbox("ChatGPT Model", modelos, index=0)
            return {"proveedor": "chatgpt", "modelo": modelo_elegido}, API_KEY
            
        elif proveedor == "Gemini":
            modelos = gemini_models
            modelo_elegido = st.selectbox("Gemini Model", modelos, index=0)
            return {"proveedor": "gemini", "modelo": modelo_elegido}, API_KEY
        
        elif proveedor == "Claude":
            modelos = claude_models
            modelo_elegido = st.selectbox("Claude Model", modelos, index=0)
            return {"proveedor": "claude", "modelo": modelo_elegido}, API_KEY
        
    return None

def input_prompt_component(label, help_text, example_text):
    # We create a visual container for each section
    with st.container(border=True):
        col_tit, col_help = st.columns([0.8, 0.2])
        
        with col_tit:
            st.markdown(f"### {label}")
            
        with col_help:
            # We replace the button/info with a Popover (floating window)
            with st.popover("💡 HELP"):
                st.markdown(f"**Example of {label}:**")
                st.caption(example_text) # More legible text for examples

        # Method selector
        method = st.radio(
            f"How would you like to enter the {label}?",
            ["Write text", "Upload .txt file"],
            key=f"radio_{label}",
            horizontal=True
        )
        
        if method == "Write text":
            return st.text_area(
                f"Enter the {label}:", 
                placeholder=help_text, 
                key=f"txt_{label}",
                height=150 # Fixed height to prevent it from looking too small
            )
        else:
            file = st.file_uploader(
                f"Upload the file for {label}", 
                type="txt", 
                key=f"file_{label}"
            )
            if file:
                return file.read().decode("utf-8")
    return ""

def menu_st(df, menu_type):
    
    estrategia = None
    
    if menu_type == 2:
        st.markdown("---")
        st.subheader("Assignment Strategy")

        # Selección de estrategia
        estrategia = st.radio(
            "Select the prompting strategy::",
            ["Zero-Shot", "Few-Shot", "Zero-Shot CoT", "Few-Shot CoT"],
            horizontal=True
        )
        
    elif menu_type == 1:
        st.markdown("---")
        st.subheader("Categories Creation Strategy")

    info_llm, API_KEY = seleccionar_llm_st()

    if info_llm and API_KEY:
        crear_prompt_obtener_resultados(info_llm, df, API_KEY, estrategia)
 
def crear_prompt_obtener_resultados(info_llm, df, API_KEY, estrategia):

    proveedor = info_llm['proveedor']
    
    modelo = info_llm['modelo']
        
    # 1. Inicializar estados para persistencia
    if 'proceso_finalizado' not in st.session_state:
        st.session_state.proceso_finalizado = False
    
    st.write(f" **Configured:** {proveedor} ({modelo})")
    st.header("Prompt Configuration")

    # --- BLOQUES BÁSICOS ---
    rol = input_prompt_component("Role", "e.g., You are an economics expert...", HELP_ROLE)
    contexto = input_prompt_component("Context", "e.g., This data comes from...", HELP_CONTEXTO)
    clasificacion = input_prompt_component("Classification", "e.g., Classify into A, B, or C...", HELP_CLASIFICACION)
    formato = input_prompt_component("Format", "e.g., Return a JSON...", HELP_FORMAT)
    constraints = input_prompt_component("Constraints", "e.g., Do not use adjectives...", HELP_CONSTRAINTS)

    extra_content = ""

    # --- BLOQUES DINÁMICOS (Corregidos) ---
    # Usamos 'in' correctamente para detectar la estrategia
    # si estrategia no es None
    if estrategia:
        if "Few-Shot" in estrategia:
            help_text = HELP_FS_COT if "CoT" in estrategia else HELP_FS
            extra_content += "\n" + input_prompt_component("Examples", "Add examples of input/output...", help_text)
        
        # Si la estrategia es "Zero-Shot CoT" o "Few-Shot CoT"
        if "CoT" in estrategia:
            extra_content += "\n" + input_prompt_component("Chain of Thought (CoT)", "Reasoning instructions...", HELP_COT)
        
    # --- CONFIGURACIÓN EXTRA ---
    st.info("Columns Configuration")
    message_col = st.selectbox(
        "Select the column containing the messages/texts:",
        options=df.columns,
        help="This is the column the LLM will read for classification."
    )

    st.info("Temperatures Configuration")    
    temps = configuracion_temperaturas()
    
    # --- PROCESSING MODE (only for Claude / GPT) ---
    if proveedor in ("claude", "chatgpt"):
        st.info("Processing Mode")
        processing_mode = st.radio(
            "How should the LLM process the rows?",
            ["Normal (line by line)", "Batch API (async, ~50% cheaper, up to 24 h)"],
            key="processing_mode_radio",
            horizontal=True,
        )
        if "Batch" in processing_mode:
            if proveedor == "claude":
                st.caption("📊 Track progress: https://console.anthropic.com/settings/workspaces/default/batches")
            else:
                st.caption("📊 Track progress: https://platform.openai.com/batches")
    else:
        processing_mode = "Normal (line by line)"
    
    
    # --- CONSTRUCCIÓN DEL PROMPT ---
    partes = [rol, contexto, clasificacion, formato, constraints, extra_content]
    prompt_final = "\n".join([p for p in partes if p.strip()])

    strategy_folder = estrategia.lower().replace(" ", "_") if estrategia else "default"

    # --- VALIDACIÓN DE ARCHIVOS PREVIOS (Antes del botón) ---
    # --- VALIDACIÓN DE ARCHIVOS PREVIOS ---
    st.subheader("File Check")
    modos_ejecucion = {}
    hay_archivos_previos = False

    for temp in temps:
        out_file = f"results_line_temp{temp}.csv"
        output_path = os.path.join(RESULTS_PATH, proveedor, strategy_folder, out_file)
        
        if os.path.exists(output_path):
            hay_archivos_previos = True
            st.warning(f"⚠️ Resultados previos detectados para Temp: {temp}")
            
            opcion = st.radio(
                f"Acción para {out_file}:",
                ["Mantener (Append)", "Eliminar y reiniciar"],
                key=f"radio_{strategy_folder}_{temp}"
            )
            modos_ejecucion[temp] = "overwrite" if "Eliminar" in opcion else "append"
        else:
            modos_ejecucion[temp] = "new"

    # --- VALIDACIÓN FINAL PARA MOSTRAR EL BOTÓN ---
    confirmado = True
    if hay_archivos_previos:
        # Añadimos un checkbox de confirmación final para "frenar" el proceso
        confirmado = st.checkbox("He verificado las acciones sobre los archivos previos.", value=False)

    # --- BOTÓN DE EJECUCIÓN (Solo si está confirmado) ---
    if confirmado:
        if st.button("Generate Prompt and Run"):
            if prompt_final.strip():
                # 1. Aplicar limpieza de archivos
                for temp, modo in modos_ejecucion.items():
                    if modo == "overwrite":
                        out_file = f"results_line_temp{temp}.csv"
                        output_path = os.path.join(RESULTS_PATH, proveedor, strategy_folder, out_file)
                        if os.path.exists(output_path):
                            os.remove(output_path)
                
                # 2. Asegurar directorios
                os.makedirs(os.path.join(RESULTS_PATH, proveedor, strategy_folder), exist_ok=True)

                st.session_state.proceso_finalizado = True
                st.rerun() # Forzamos recarga para que entre en el bloque de procesamiento
            else:
                st.error("The prompt is empty.")
    else:
        st.info("Por favor, confirma la gestión de archivos arriba para habilitar la ejecución.")

    # --- MOSTRAR RESULTADOS Y PROCESAMIENTO ---
    # si partes no esta empty y el proceso se ha marcado como finalizado, mostramos el prompt y ejecutamos
    if st.session_state.proceso_finalizado:
        # Opcional: Botón para resetear y volver a configurar
        if st.button("STOP, reset, and Edit Prompt"):
            st.session_state.proceso_finalizado = False
            st.rerun()
            
        st.subheader("Final Generated Prompt")
        st.code(prompt_final, language="markdown")
        
        # Llamamos a la función de procesamiento. 
        # Al estar fuera del 'if button', persistirá aunque hagas clic en descargar.
        if estrategia:
          
            ejecutar_procesamiento_categorizacion_st(
                df,
                prompt_final,
                info_llm,
                temps,
                message_col,
                estrategia.lower().replace(" ", "_"),
                API_KEY,
                "Batch" in processing_mode
            )
    
            st.session_state.proceso_finalizado = False

        else:
            ejecutar_procesamiento_crear_st(
                df, 
                prompt_final, 
                info_llm, 
                temps, 
                message_col,  
                API_KEY
            )
              
def configuracion_temperaturas():
    
    # Sin crear columnas ni usar 'with'
    temps = st.multiselect("Temperatures", [0, 0.1, 0.5, 1, 1.2], default=[0])
    
    return temps

def ejecutar_procesamiento_categorizacion_st(df, prompt, config_llm, temps, message_col, strategy_folder, API_KEY, batch=False):
    
    df_clean = df.dropna(subset=[message_col]).reset_index(drop=True)
    
    proveedor = config_llm['proveedor']
    
    model_override = config_llm.get('modelo', 'default-model')
    
    temps = normalize_temps_for_claude(temps, proveedor)
    
    for temp in temps:
        with st.container(border=True):
            st.subheader(f"Temperature: {temp}")
            bar = st.progress(0)
            status = st.empty()
            log_area = st.expander(f"Logs / Status (Temp {temp})")

            # Rutas de salida
            out_file = f"results_{'batch_' if batch else 'line_'}temp{temp}.csv"
            output_path = os.path.join(RESULTS_PATH, proveedor, strategy_folder, out_file)
            os.makedirs(os.path.dirname(output_path), exist_ok=True)

            processed_ids = set()
            rows_buffer = []

            # Checkpoint (Cargar si existe)
            if os.path.exists(output_path):
                try:
                    existing_df = pd.read_csv(output_path)
                    if "row_id" in existing_df.columns:
                        processed_ids = set(existing_df["row_id"].unique())
                        rows_buffer = existing_df.to_dict('records')
                        status.info(f"Progreso previo: {len(processed_ids)} líneas detectadas.")
                except Exception as e:
                    log_area.error(f"Error cargando checkpoint: {e}")

            # Filtrar pendientes
            pending_rows = [
                (idx, row[message_col]) 
                for idx, row in df_clean.iterrows() 
                if idx not in processed_ids
            ]
            
            total_total = len(df_clean)

            # --- CASO 1: YA COMPLETADO ---
            if not pending_rows and len(processed_ids) >= total_total:
                bar.progress(1.0)
                status.success(f"Temperature {temp} completada.")
                if rows_buffer:
                    mostrar_boton_descarga(pd.DataFrame(rows_buffer), temp, "results")
                continue

            # --- CASO 2: MODO BATCH (OFFLINE) ---
            if batch:
                
                status.warning("Preparando Batch para envío...")
                try:
                    # Crear el mapa de IDs para recuperar después
                    row_id_map = {
                        f"t{temp}_r{idx}": {"idx": int(idx), "message": str(msg)}
                        for idx, msg in pending_rows
                    }

                    if proveedor == "claude":
                        client = get_claude_client(API_KEY) # Asumiendo que existe
                        batch_requests = []
                        for custom_id, entry in row_id_map.items():
                            batch_requests.append({
                                "custom_id": custom_id,
                                "params": {
                                    "model": model_override,
                                    "max_tokens": 1000, # Ajustar según necesidad
                                    "temperature": temp,
                                    "system": prompt,
                                    "messages": [{"role": "user", "content": entry["message"]}],
                                },
                            })
                        batch_obj = client.messages.batches.create(requests=batch_requests)
                        batch_id = batch_obj.id

                    elif proveedor in ["chatgpt", "openai"]:
                        client = get_openai_batch_client(API_KEY)
                        batch_lines = []
                        for custom_id, entry in row_id_map.items():
                            batch_lines.append(json.dumps({
                                "custom_id": custom_id,
                                "method": "POST",
                                "url": "/v1/chat/completions",
                                "body": {
                                    "model": model_override,
                                    "temperature": temp,
                                    "messages": [
                                        {"role": "system", "content": prompt},
                                        {"role": "user", "content": entry["message"]},
                                    ],
                                },
                            }, ensure_ascii=False))

                        input_path = os.path.join(RESULTS_PATH, proveedor, strategy_folder, f"input_batch_temp{temp}.jsonl")
                        with open(input_path, "w", encoding="utf-8") as f:
                            f.write("\n".join(batch_lines) + "\n")

                        with open(input_path, "rb") as fh:
                            input_file = client.files.create(file=fh, purpose="batch")
                        batch_obj = client.batches.create(
                            input_file_id=input_file.id,
                            endpoint="/v1/chat/completions",
                            completion_window="24h",
                        )
                        batch_id = batch_obj.id

                    # Guardar metadatos del batch para poder descargarlos después
                    status_history = load_st_batch_status(proveedor)
                    status_history[batch_id] = {
                        "batch_id": batch_id,
                        "temp": temp,
                        "output_path": output_path,
                        "row_id_map": row_id_map # Importante para reconstruir el DF
                    }
                    save_st_batch_status(proveedor, status_history)
                    
                    status.success(f"Batch enviado: `{batch_id}`")
                    st.info("El resultado estará listo en la sección de 'Pendientes' en unas horas.")

                except Exception as e:
                    log_area.error(f"Error en Batch Temp {temp}: {e}")

            # --- CASO 3: MODO TIEMPO REAL (ONLINE) ---
            else:
                if proveedor == "gemini":
                    with ThreadPoolExecutor(max_workers=5) as executor:
                        futures = {}
                        for idx, msg in pending_rows:
                            full_prompt = f"{prompt}\n\nClassify ONLY this message:\n{msg}"
                            job = executor.submit(call_llm_for_message, full_prompt, temp, "gemini")
                            futures[job] = (idx, msg)

                        for i, future in enumerate(as_completed(futures)):
                            idx, msg = futures[future]
                            try:
                                ans = future.result()
                                parsed = parse_llm_dict(ans)
                                parsed["row_id"], parsed["original_message"] = idx, msg
                                rows_buffer.append(parsed)

                                if len(rows_buffer) % 10 == 0:
                                    pd.DataFrame(rows_buffer).to_csv(output_path, index=False)
                                
                                completados = len(processed_ids) + i + 1
                                bar.progress(completados / total_total)
                                status.markdown(f"**Gemini:** `{completados}/{total_total}`")
                            except Exception as e:
                                log_area.error(f"Fila {idx}: {e}")

                else: # GPT o Claude por línea
                    for i, (idx, msg) in enumerate(pending_rows):
                        try:
                            full_prompt = f"{prompt}\n\nClassify ONLY this message:\n{msg}"
                            ans = call_llm_for_message(full_prompt, temp, proveedor, API_KEY)
                            parsed = parse_llm_dict(ans)
                            parsed["row_id"], parsed["original_message"] = idx, msg
                            rows_buffer.append(parsed)

                            if len(rows_buffer) % 5 == 0:
                                pd.DataFrame(rows_buffer).to_csv(output_path, index=False)

                            completados = len(processed_ids) + i + 1
                            bar.progress(completados / total_total)
                            status.markdown(f"**{proveedor.upper()}:** `{completados}/{total_total}`")
                        except Exception as e:
                            log_area.error(f"Fila {idx}: {e}")

                # Finalizar y mostrar descarga
                df_final = pd.DataFrame(rows_buffer)
                df_final.to_csv(output_path, index=False)
                st.dataframe(df_final.head())
                mostrar_boton_descarga(df_final, temp, "results")

def get_claude_client(API_KEY):
    global llm_claude
    if llm_claude is None:
        if anthropic is None:
            raise ImportError("Anthropic SDK is not installed. Run 'pip install anthropic'.")
        llm_claude = anthropic.Anthropic(api_key=API_KEY)
    return llm_claude

def load_st_batch_status(provider):
    p = _st_batch_status_path(provider)
    if os.path.exists(p):
        try:
            with open(p) as f:
                return json.load(f)
        except Exception:
            pass
    return {}

def save_st_batch_status(provider, data):
    with open(_st_batch_status_path(provider), "w") as f:
        json.dump(data, f, indent=2)
        
def _st_batch_status_path(provider):
    path = os.path.join(RESULTS_PATH, provider, "batch_status_st.json")
    os.makedirs(os.path.dirname(path), exist_ok=True)
    return path

def get_openai_batch_client(API_KEY):
    global llm_openai_batch
    if llm_openai_batch is None:
        llm_openai_batch = OpenAI(api_key=API_KEY)
    return llm_openai_batch
        
def normalize_temps_for_claude(temps, llm):
    if llm != "claude":
        return temps
    valid = [t for t in temps if 0 <= float(t) <= 1]
    dropped = [t for t in temps if not (0 <= float(t) <= 1)]
    if dropped:
        st.warning(f"Claude only supports temperature 0–1. Skipping: {dropped}")
    return valid if valid else [0]

def ejecutar_procesamiento_crear_st(df, prompt, config_llm, temps, message_col, API_KEY):
    
    # Limpiamos el dataframe
    df_clean = df.dropna(subset=[message_col]).reset_index(drop=True)
    
    # Preparamos el bloque de mensajes una sola vez
    messages = df_clean[message_col].tolist()
    combined_messages = "\n".join([f"- {m}" for m in messages])
    
    full_prompt = (
        f"{prompt}\n\n"
        "These are the messages you need to analyze to create the categories:\n"
        f"{combined_messages}"
    )
    
    for temp in temps:
        with st.container(border=True):
            st.subheader(f"Results with temperature: {temp}")
            
            with st.spinner(f"The LLM is analyzing and categorizing (Temp {temp})..."):
                try:
                    # 1. Llamada única al LLM
                    proveedor = config_llm['proveedor']
                    
                    print(f"api2 {API_KEY}...") 
                    
                    if proveedor == "gemini":
                        # Usamos tu función existente call_llm_for_message pero enviando el bloque completo
                        ans = call_llm_for_message(full_prompt, temp, "gemini", API_KEY)
                        
                    else:
                        ans = call_llm_for_message(full_prompt, temp, "chatgpt", API_KEY)

                    
                    # 2. Parsear el resultado (JSON -> Dict/List)
                    categorias_data = parse_llm_dict(ans)
                    
                    # 3. Mostrar de forma "bonita"
                    if categorias_data:
                        res_df = None
    
                        if isinstance(categorias_data, dict):
                            # REVISIÓN PARA TU CASO ESPECÍFICO:
                            # Convertimos el dict {Llave: Valor} en una lista de tuplas [(Llave, Valor)]
                            # y le ponemos nombres de columnas claros.
                            res_df = pd.DataFrame(
                                list(categorias_data.items()), 
                                columns=["Category", "Description"]
                            )

                        # RENDERIZADO FINAL
                        if res_df is not None:
                            # Esto imprimirá la tabla estética en vez del JSON
                            st.table(res_df) 
                            
                            # Botón de descarga usando tu función
                            mostrar_boton_descarga(res_df, temp, "categories")
                        else:
                            st.warning("No se pudo estructurar la tabla.")
                    else:
                        st.warning("The LLM did not return any data or it could not be parsed.")

                except Exception as e:
                    st.error(f"Error processing temp {temp}: {e}")    
                               
def mostrar_boton_descarga(df_temp, temp, type):
    st.session_state.proceso_finalizado = True
    
    st.success(f"✅ ¡Temp {temp} ready to be downloaded!")
    
    csv_temp = df_temp.to_csv(index=False).encode('utf-8')
    
    st.download_button(
        label=f" Download results Temp {temp}",
        data=csv_temp,
        file_name=f"{type}_temp_{temp}.csv",
        mime="text/csv",
        key=f"dl_{temp}"
    )
    
    st.divider()
           
def write_rows_to_csv(output_path, rows):
    if not rows:
        return

    file_exists = os.path.exists(output_path)
    pd.DataFrame(rows).to_csv(
        output_path,
        mode = "a",
        header = not file_exists,
        index = False,
        encoding="utf-8"
    )

def get_chatgpt_client(API_KEY):
    global llm_chatgpt
    if llm_chatgpt is None or llm_chatgpt.model_name != SELECTED_CHATGPT_MODEL:
        llm_chatgpt = ChatOpenAI(
            model = SELECTED_CHATGPT_MODEL,
            max_retries = 1,
            api_key = API_KEY
        )
    return llm_chatgpt

def get_gemini_client(API_KEY):
    global llm_gemini
    if llm_gemini is None:
        llm_gemini = genai.Client(api_key=API_KEY)
    return llm_gemini

def call_llm_for_message(base_prompt, temp, llm, API_KEY):
    
    if llm == "gemini":
       
        response = get_gemini_client(API_KEY).models.generate_content(
            model=SELECTED_GEMINI_MODEL,
            contents=base_prompt,
            config=types.GenerateContentConfig(temperature=temp)
        )
        return response.text
    elif llm == "chatgpt":  
        response = get_chatgpt_client(API_KEY).bind(temperature=temp).invoke([
            ("system", base_prompt),
            ("user", base_prompt)
        ])
        print("Response from ChatGPT (user mode):", response.content)
    

    return response.content

def parse_llm_dict(ans):

    try:
        start = ans.find("{")
        end   = ans.rfind("}") + 1
        raw_dict = ans[start:end]
        return ast.literal_eval(raw_dict)
    except:
        return {"error": ans[:300]}
    
def main():
    
    st.title("Responses classification with LLMs")
    
    if st.button("Upload new CSV and reset"):
        folder = "Results"

        if os.path.exists(folder):
            shutil.rmtree(folder)  # elimina todo
            
        os.makedirs(folder)    # la recrea vacía (opcional)
        st.session_state.proceso_finalizado = False
        st.rerun()

    # 1. El usuario sube el archivo
    archivo_subido = st.file_uploader("Upload your CSV file", type="csv")

    if archivo_subido is not None:
        # Cargamos el dataframe para que esté disponible en las acciones
        df = pd.read_csv(archivo_subido)
        st.success("File successfully uploaded")
        
        st.write("### Preliminary data view:")
        st.dataframe(df.head())

        # 2. Preguntar qué se quiere hacer (reemplaza tus menús anteriores)
        accion = st.segmented_control(
                    "What would you like to do?", 
                    options=["Create categories", "Assign categories"], 
                    selection_mode="single",
                    on_change=reset_workspace  # <--- ESTO ES LA CLAVE
                )
        # 3. Lógica de ejecución según la acción seleccionada
        if accion == "Create categories":
            st.subheader("Configuration of new categories")
            #primero obtener categorias, depues hacer el mismo proceso
            menu_st(df, 1)

        elif accion == "Assign categories":
            st.subheader("Assign categories to csv")
            
            menu_st(df, 2)

    else:
        st.info("Waiting for CSV to abilitate actions")

def reset_workspace():
    # Esta función borra los estados de ejecución
    if 'proceso_finalizado' in st.session_state:
        st.session_state.proceso_finalizado = False
        
if __name__ == "__main__":
    
    main()
    
    
