import csv
import os
import time
from dotenv import load_dotenv

# Definir la ruta del archivo de prompt
PROMPT_FILE = "../prompts/directores/prompt_cargas.txt"

# Leer el contenido del archivo prompt_razones.txt
if os.path.exists(PROMPT_FILE):
    with open(PROMPT_FILE, "r", encoding="utf-8") as f:
        PROMPT_1 = f.read().strip()
else:
    # Valor por defecto en caso de que no se encuentre el archivo
    PROMPT_1 = "Analiza lo siguiente y proporciona un análisis detallado:"

# API Key para OpenAI.
load_dotenv()  # load from .env file
OAI_2 = os.getenv("OAI_2")