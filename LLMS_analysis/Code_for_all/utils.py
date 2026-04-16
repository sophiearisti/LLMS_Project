import csv
import os
import time
from dotenv import load_dotenv

# Definir la ruta del archivo de prompt
PROMPTS_PATH = "../prompts/"
DATA_PATH = "../Data/"
RESULTS_PATH = "../Results/"

FIRST_PAPER = "managerial_leadership_Jordi_Cooper/"
SECOND_PAPER = "strategic_environment_Ozkes_Hanaki/"
THIRD_PAPER = "trust_promises_Ederer_Schneider/"
FOURTH_PAPER = "under_reporting_Ling_Kale_Imas/"

ROLE_FILE ="role.txt"
CONTEXT_FILE ="context.txt"
CLASSIFICATION_FILE ="classificationTask.txt"
FORMAT_FILE ="format.txt"
CONSTRAINTS_FILE ="constraints.txt"
FEWSHOT_FILE ="fewShot.txt"
ZEROSHOTCOT_FILE ="0ShotCoT.txt"
FEWSHOTCOT_FILE ="few-shotCoT.txt"

CLASSIFICATION_CAT_FILE ="classificationTaskCat.txt"
FORMAT_CAT_FILE ="formatCat.txt"

#DATA_FILE= "test.csv"

DATA_FILE= "classify.csv"

REAL_ANSWERS_FILE = "real_answers.csv"

# API Key para OpenAI.
load_dotenv()  # load from .env file
OAI_2 = os.getenv("OAI_2")
GEMINI = os.getenv("GEMINI")
CLAUDE = os.getenv("CLAUDE")