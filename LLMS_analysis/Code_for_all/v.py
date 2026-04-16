import streamlit as st
import pandas as pd

st.title("Interprete de CSV")

# Crea el widget para subir archivos
archivo_subido = st.file_uploader("Elige tu archivo CSV", type="csv")

if archivo_subido is not None:
    # Leer el CSV directamente
    df = pd.read_csv(archivo_subido)
    
    st.write("### Vista previa de los datos:")
    st.dataframe(df.head())
    
    st.write("### Estadísticas básicas:")
    st.write(df.describe())