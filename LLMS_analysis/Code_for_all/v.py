import streamlit as st
import pandas as pd
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
import shutil

llm_chatgpt = None

llm_gemini = None

llm_claude = None

GEMINI_CATEGORY_MODEL = "gemini-3.1-pro-preview"
GEMINI_CLASSIFY_MODEL = "gemini-3-flash-preview"
GEMINI_WORKERS = 20

# Selected models (updated at runtime via seleccionar_llm)
SELECTED_CHATGPT_MODEL = "gpt-5.2"
SELECTED_GEMINI_MODEL = "gemini-3-flash-preview"
SELECTED_CLAUDE_MODEL = "XXXXXX"

def seleccionar_llm_st():
    st.markdown("### Configuración del Modelo")
    
    col1, col2 = st.columns(2)
    
    with col1:
        proveedor = st.selectbox("Provider", ["ChatGPT", "Gemini"], index=0)

    with col2:
        if proveedor == "ChatGPT":
            modelos = ["gpt-5.2", "gpt-5.1", "gpt-5-mini", "gpt-4o"]
            # El recomendado suele ser el primero o uno específico
            modelo_elegido = st.selectbox("ChatGPT Model", modelos, index=0)
            return {"proveedor": "chatgpt", "modelo": modelo_elegido}
            
        elif proveedor == "Gemini":
            modelos = ["gemini-3.1-pro-preview", "gemini-3.1-pro-preview-customtools", 
                       "gemini-3-flash-preview", "gemini-3-pro-preview"]
            modelo_elegido = st.selectbox("Gemini Model", modelos, index=0)
            return {"proveedor": "gemini", "modelo": modelo_elegido}
    
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

def menu_asignacion_st(df):
    st.markdown("---")
    st.subheader("Assignment Strategy")

    # Selección de estrategia
    estrategia = st.radio(
        "Select the prompting strategy::",
        ["Zero-Shot", "Few-Shot", "Zero-Shot CoT", "Few-Shot CoT"],
        horizontal=True
    )

    info_llm = seleccionar_llm_st()

    if info_llm:
        prompt_resultados(info_llm, estrategia, df)
        
def prompt_resultados(info_llm, estrategia, df):
    # 1. Inicializar estados para persistencia
    if 'proceso_finalizado' not in st.session_state:
        st.session_state.proceso_finalizado = False
    
    st.write(f" **Configured:** {info_llm['proveedor']} ({info_llm['modelo']})")
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

    # --- CONSTRUCCIÓN DEL PROMPT ---
    partes = [rol, contexto, clasificacion, formato, constraints, extra_content]
    prompt_final = "\n".join([p for p in partes if p.strip()])

    # --- BOTÓN DE EJECUCIÓN ---
    if st.button("Generate Prompt and Run"):
        if prompt_final:
            st.session_state.proceso_finalizado = True
            # No ejecutamos aquí directamente para evitar que se pierda al refrescar
        else:
            st.error("The prompt is empty. Please configure the blocks.")
            st.session_state.proceso_finalizado = False

    # --- MOSTRAR RESULTADOS Y PROCESAMIENTO ---
    if st.session_state.proceso_finalizado:
        st.subheader("Final Generated Prompt")
        st.code(prompt_final, language="markdown")
        
        # Llamamos a la función de procesamiento. 
        # Al estar fuera del 'if button', persistirá aunque hagas clic en descargar.
        ejecutar_procesamiento_st(
            df, 
            prompt_final, 
            info_llm, 
            temps, 
            message_col,  
            estrategia.lower().replace(" ", "_")
        )
        
        # Opcional: Botón para resetear y volver a configurar
        if st.button("Reset and Edit Prompt"):
            st.session_state.proceso_finalizado = False
            st.rerun()
           
def configuracion_temperaturas():
    
    # Sin crear columnas ni usar 'with'
    temps = st.multiselect("Temperatures", [0, 0.1, 0.5, 1, 1.2], default=[0])
    
        
    return temps

def ejecutar_procesamiento_st(df, prompt, config_llm, temps, message_col, strategy_folder):
    df_clean = df.dropna(subset=[message_col]).reset_index(drop=True)
    
    for temp in temps:
        # --- PROBLEMA 1: UN CONTENEDOR POR PROCESO ---
        # Cada temperatura vive en su propia caja visual
        with st.container(border=True):
            st.subheader(f"Temperature: {temp}")
            
            # Variables de control visual locales a este bloque
            bar = st.progress(0)
            status = st.empty()
            log_area = st.expander(f"See error logs (Temp {temp})")

            # Construir rutas
            out_file = f"results_line_temp{temp}.csv"
            output_path = os.path.join(RESULTS_PATH, config_llm['proveedor'] , strategy_folder, out_file)
            os.makedirs(os.path.dirname(output_path), exist_ok=True)

            processed_ids = set()
            rows_buffer = []

            # Checkpoint (Cargar si existe)
            if os.path.exists(output_path):
                existing_df = pd.read_csv(output_path)
                if "row_id" in existing_df.columns:
                    processed_ids = set(existing_df["row_id"].tolist())
                    rows_buffer = existing_df.to_dict('records')
                    status.info(f"Progreso previo: {len(processed_ids)} detected lines.")

            # Filtrar pendientes
            pending_rows = [
                (idx, row[message_col]) 
                for idx, row in df_clean.iterrows() 
                if idx not in processed_ids
            ]
            
            total_total = len(df_clean)

            # --- EJECUCIÓN ---
            if not pending_rows and len(processed_ids) >= total_total:
                bar.progress(1.0)
                status.success(f"Temperature {temp} completed previously.")
            else:
                if config_llm['proveedor'] == "gemini":
                    with ThreadPoolExecutor(max_workers=5) as executor:
                        futures = {
                            executor.submit(call_llm_for_message, prompt, msg, temp, "gemini"): (idx, msg) 
                            for idx, msg in pending_rows
                        }
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
                else:
                    for i, (idx, msg) in enumerate(pending_rows):
                        try:
                            ans = call_llm_for_message(prompt, msg, temp, "chatgpt")
                            parsed = parse_llm_dict(ans)
                            parsed["row_id"], parsed["original_message"] = idx, msg
                            rows_buffer.append(parsed)

                            if len(rows_buffer) % 5 == 0:
                                pd.DataFrame(rows_buffer).to_csv(output_path, index=False)

                            completados = len(processed_ids) + i + 1
                            bar.progress(completados / total_total)
                            status.markdown(f"**GPT:** `{completados}/{total_total}`")
                        except Exception as e:
                            log_area.error(f"Fila {idx}: {e}")

                # Guardado final de la temperatura
                pd.DataFrame(rows_buffer).to_csv(output_path, index=False)

            # --- BOTÓN DE DESCARGA (COMO ANTES) ---
            # Se muestra siempre que haya datos en el buffer o archivo
            if rows_buffer:
                pd.DataFrame(rows_buffer).to_csv(output_path, index=False)
                mostrar_boton_descarga(rows_buffer, temp)

def mostrar_boton_descarga(rows, temp):
    df_temp = pd.DataFrame(rows)
    st.success(f"✅ ¡Temp {temp} ready to be downloaded!")
    st.write("### Preliminary data view:")
    st.dataframe(df_temp.head())
    csv_temp = df_temp.to_csv(index=False).encode('utf-8')
    st.download_button(
        label=f" Download results Temp {temp}",
        data=csv_temp,
        file_name=f"resultados_temp_{temp}.csv",
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
    
def main():
    
    st.title("Responses classification with LLMs")
    
    if st.button("Reset / Clear Screen"):
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
            selection_mode="single"
        )

        # 3. Lógica de ejecución según la acción seleccionada
        if accion == "Create categories":
            st.subheader("Configuration of new categories")
            
            #primero obtener categorias, depues hacer el mismo proceso

        elif accion == "Assign categories":
            st.subheader("Assign categories to csv")
            
            menu_asignacion_st(df)

    else:
        st.info("Waiting for CSV to abilitate actions")

if __name__ == "__main__":
    
    main()
    
    
