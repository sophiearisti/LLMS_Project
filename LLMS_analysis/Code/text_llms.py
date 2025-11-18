from langchain_openai import ChatOpenAI
from utils import PROMPT_1, OAI_2
from tqdm import tqdm
import pandas as pd

# Cargar la base de datos y filtrar filas sin 'razones'
df = pd.read_excel('../data/db_directores.xls')
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