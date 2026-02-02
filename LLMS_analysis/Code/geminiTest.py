#lest try to connect to gemini api
from google import genai
from google.genai import types
from tqdm import tqdm
from utils import *
import pandas as pd

client = genai.Client()

response = client.models.generate_content(
    model="gemini-3-flash-preview",
    contents="hola como estas",
    config=types.GenerateContentConfig(
        temperature=0.5
    )
)

print(response.text)
