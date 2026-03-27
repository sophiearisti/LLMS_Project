import os
import glob
import pandas as pd

base = r"c:\Users\danie\Dropbox\Javeriana\Proyecto LLMS text\LLMS_Project\LLMS_analysis"
folder = os.path.join(base, "Results", "claude", "under_reporting_Ling_Kale_Imas", "fewshot")
real_path = os.path.join(base, "Data", "under_reporting_Ling_Kale_Imas", "real_answers.csv")

real = pd.read_csv(real_path)
expected_tags = [
    "uninformative", "SDB", "overest_others", "underest_own", "academic_integrity",
    "info_asymmetry", "AI_discussion_priming", "privacy_concerns", "self_esteem",
    "self_report_bias", "network_effect", "truthful"
]

files = sorted(glob.glob(os.path.join(folder, "*.csv")))
print(f"Found {len(files)} CSV files in fewshot")

for f in files:
    print("\n" + "="*80)
    print(os.path.basename(f))
    try:
        df = pd.read_csv(f)
    except Exception as e:
        print("READ ERROR:", e)
        continue

    print("rows:", len(df), "cols:", len(df.columns))

    cols = set(df.columns)
    missing = [c for c in expected_tags if c not in cols]
    extra = [
        c for c in df.columns
        if c not in set(expected_tags + [
            "original_message", "row_id", "open_code", "message", "tag",
            "paper_id", "accuracy", "cohen_kappa", "krippendorff_alpha", "macro_f1"
        ]) and not c.startswith(("precision_", "recall_", "f1_"))
    ]

    if missing:
        print("missing expected tag columns:", missing)
    if extra:
        print("unexpected columns:", extra)

    if "row_id" in df.columns:
        dup = int(df["row_id"].duplicated().sum())
        nulls = int(df["row_id"].isna().sum())
        min_id = int(df["row_id"].min()) if not df["row_id"].isna().all() else None
        max_id = int(df["row_id"].max()) if not df["row_id"].isna().all() else None
        print("row_id duplicates:", dup, "row_id nulls:", nulls, "row_id range:", (min_id, max_id))

    for c in expected_tags:
        if c in df.columns:
            vals = sorted({str(v).strip() for v in df[c].dropna().unique()})
            bad = [v for v in vals if v not in {"0", "1", "0.0", "1.0"}]
            if bad:
                print(f"non-binary values in {c}:", bad[:10])

    msg_col = "original_message" if "original_message" in df.columns else ("message" if "message" in df.columns else None)
    if msg_col:
        mn = int(df[msg_col].isna().sum())
        print(f"{msg_col} nulls:", mn)

print("\nDone")
