# ../Data/managerial_leadership_Jordi_Cooper/real_answers_desaggregated.csv
#../Data/managerial_leadership_Jordi_Cooper/conteo_por_juego.txt
import pandas as pd

# --------------------------------------------------
# 1. Leer CSV
# --------------------------------------------------

df = pd.read_csv("../Data/managerial_leadership_Jordi_Cooper/real_answers_desaggregated.csv")
df.columns = df.columns.str.strip()

# Eliminar columna innecesaria
if "Unnamed: 0" in df.columns:
    df = df.drop(columns="Unnamed: 0")

# --------------------------------------------------
# 2. Leer tamaños
# --------------------------------------------------

with open("../Data/managerial_leadership_Jordi_Cooper/conteo_por_juego.txt") as f:
    group_sizes = [int(x.strip()) for x in f.readlines()]

if sum(group_sizes) != len(df):
    raise ValueError("La suma de agrupaciones NO coincide con el número de filas")

# --------------------------------------------------
# 3. Crear bloques consecutivos
# --------------------------------------------------

block_ids = []
for i, size in enumerate(group_sizes):
    block_ids.extend([i] * size)

df["block"] = block_ids

# --------------------------------------------------
# 4. Agrupar correctamente usando apply
# --------------------------------------------------

fixed_cols = [
    "session","period","group","game",
    "any_suggestion","suggest_safe","suggest_efficient",
    "agree_proposal","discuss_fairness","discuss_efficient",
    "discuss_rules","explanation","discuss_howtoplay",
    "ask_game","receive_report","truthful","falsehood",
    "contradict","neither_report"
]

def aggregate_block(group):
    result = {}

    # Mantener valores fijos (primera fila)
    for col in fixed_cols:
        result[col] = group.iloc[0][col]

    # Concatenar Type; message
    result["message"] = " / ".join(
        group["Type"].astype(str) + "; " + group["message"].astype(str)
    )

    result["conteo"] = len(group)

    return pd.Series(result)

df_grouped = df.groupby("block").apply(aggregate_block).reset_index(drop=True)

# --------------------------------------------------
# 5. Guardar
# --------------------------------------------------

df_grouped.to_csv("archivo_agrupado.csv", index=False)

print("Agrupación completada correctamente.")