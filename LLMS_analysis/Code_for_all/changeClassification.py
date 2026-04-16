import pandas as pd
import numpy as np

# --------------------------------------------------
# 1. Abrir archivo
# --------------------------------------------------
df = pd.read_csv("../Data/managerial_leadership_Jordi_Cooper/archivo_agrupado.csv")

# --------------------------------------------------
# 2. Seleccionar SOLO columnas numéricas
# --------------------------------------------------
numeric_cols = df.select_dtypes(include=[np.number]).columns

# --------------------------------------------------
# 3. Eliminar filas que contengan 0.5 (con tolerancia)
# --------------------------------------------------
mask_05 = df[numeric_cols].apply(lambda x: np.isclose(x, 0.5))
df = df[~mask_05.any(axis=1)]

# --------------------------------------------------
# 4. Reemplazar 0.66666669 → 1  y  0.33333334 → 0
# --------------------------------------------------
for col in numeric_cols:
    df[col] = np.where(
        np.isclose(df[col], 0.66666669),
        1,
        np.where(
            np.isclose(df[col], 0.33333334),
            0,
            df[col]
        )
    )

# --------------------------------------------------
# 5. Guardar
# --------------------------------------------------
df.to_csv("archivo_agrupado_del_05.csv", index=False)

print("Filas con 0.5 eliminadas y valores corregidos correctamente.")