import csv
import os
import glob
import shutil
import pandas as pd

BASE = r"c:\Users\danie\Dropbox\Javeriana\Proyecto LLMS text\LLMS_Project\LLMS_analysis"
TARGET_DIR = os.path.join(BASE, "Results", "claude", "under_reporting_Ling_Kale_Imas", "fewshot")

EXPECTED_TAGS = [
    "uninformative",
    "SDB",
    "overest_others",
    "underest_own",
    "academic_integrity",
    "info_asymmetry",
    "AI_discussion_priming",
    "privacy_concerns",
    "self_esteem",
    "self_report_bias",
    "network_effect",
    "truthful",
]

# Canonical columns for prediction files.
CANONICAL_COLS = EXPECTED_TAGS + ["original_message", "row_id"]


def normalize_col(name):
    key = str(name).strip()
    low = key.lower().replace(" ", "_")

    aliases = {
        "ai_discussion_priming": "AI_discussion_priming",
        "self_report_bias": "self_report_bias",
        "self_report bias": "self_report_bias",
        "self_steem": "self_esteem",
        "networkeffect": "network_effect",
        "network_effect": "network_effect",
        "original_message": "original_message",
        "row_id": "row_id",
    }

    if low in aliases:
        return aliases[low]
    if key in EXPECTED_TAGS or key in ("original_message", "row_id"):
        return key
    return key


def robust_read_rows(path):
    rows = []
    with open(path, "r", encoding="utf-8", newline="") as f:
        reader = csv.reader(f)
        header = next(reader)
        n = len(header)
        for row in reader:
            if not row:
                continue
            if len(row) < n:
                row = row + [""] * (n - len(row))
            elif len(row) > n:
                # Assume first n-2 fields are labels, remaining fields belong to message + row_id.
                prefix = row[: n - 2]
                tail = row[n - 2 :]
                message = ",".join(tail[:-1]) if len(tail) > 1 else tail[0]
                row_id = tail[-1] if len(tail) > 1 else ""
                row = prefix + [message, row_id]
            rows.append(row)
    return header, rows


def coalesce_duplicate_columns(df):
    # If duplicate column names exist, keep first non-null/non-empty value across duplicates.
    unique_cols = []
    for c in df.columns:
        if c not in unique_cols:
            unique_cols.append(c)

    out = pd.DataFrame(index=df.index)
    for c in unique_cols:
        matching = [col for col in df.columns if col == c]
        series = None
        for mc in matching:
            current = df[mc]
            if isinstance(current, pd.DataFrame):
                # If pandas returns a DataFrame for duplicated names, coalesce its columns first.
                temp = current.iloc[:, 0].astype(str)
                for i in range(1, current.shape[1]):
                    temp = temp.mask(temp.str.strip().eq("") | temp.isna(), current.iloc[:, i].astype(str))
                current = temp
            else:
                current = current.astype(str)

            if series is None:
                series = current
            else:
                series = series.mask(series.str.strip().eq("") | series.isna(), current)

        out[c] = series if series is not None else ""
    return out


def clean_prediction_file(path):
    backup = path + ".bak"
    if not os.path.exists(backup):
        shutil.copy2(path, backup)

    header, rows = robust_read_rows(path)
    df = pd.DataFrame(rows, columns=header)

    # Normalize headers.
    df.columns = [normalize_col(c) for c in df.columns]
    df = coalesce_duplicate_columns(df)

    # Ensure required columns exist.
    for c in CANONICAL_COLS:
        if c not in df.columns:
            df[c] = ""

    # Normalize tag values to binary 0/1.
    for c in EXPECTED_TAGS:
        vals = pd.to_numeric(df[c], errors="coerce")
        vals = vals.fillna(0)
        vals = (vals >= 0.5).astype(int)
        df[c] = vals

    # Normalize row_id.
    rid = pd.to_numeric(df["row_id"], errors="coerce")
    missing = rid.isna()
    if missing.any():
        # Fill missing row_id sequentially from max existing + 1.
        max_existing = int(rid.dropna().max()) if (~missing).any() else -1
        next_ids = list(range(max_existing + 1, max_existing + 1 + int(missing.sum())))
        rid.loc[missing] = next_ids
    df["row_id"] = rid.astype(int)

    # Keep only canonical columns in order.
    out = df[CANONICAL_COLS].copy()

    # Sort by row_id and drop duplicate row_id keeping first occurrence.
    out = out.sort_values("row_id").drop_duplicates(subset=["row_id"], keep="first")

    out.to_csv(path, index=False, encoding="utf-8")
    return len(rows), len(out)


def main():
    files = sorted(glob.glob(os.path.join(TARGET_DIR, "results_line_batch_temp*_modeuser.csv")))
    print(f"Cleaning {len(files)} prediction file(s) in: {TARGET_DIR}")

    for path in files:
        before_rows, after_rows = clean_prediction_file(path)
        print(f"- {os.path.basename(path)}: rows before parse={before_rows}, rows saved={after_rows}")


if __name__ == "__main__":
    main()
