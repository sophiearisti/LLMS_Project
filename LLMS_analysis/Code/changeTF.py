import pandas as pd

# Cargar el archivo CSV
df = pd.read_csv("../Data/under_reporting_Ling_Kale_Imas/real_answers.csv")

# Reemplazar TRUE, FALSE, T, F (en cualquier combinación de mayúsculas/minúsculas)
df = df.replace({
    "TRUE": 1,
    "True": 1,
    "true": 1,
    "T": 1,
    "FALSE": 0,
    "False": 0,
    "false": 0,
    "F": 0,
    "F?": 0.5
})

df = df.replace({True: 1, False: 0})


# Guardar el archivo modificado
df.to_csv("../Data/under_reporting_Ling_Kale_Imas/real_answers2.csv", index=False)