import os
import re
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent
METRICS_PATH = BASE_DIR / "metrics_analysis.py"

code = METRICS_PATH.read_text(encoding="utf-8")
code = code.rsplit("main()", 1)[0]

code = code.replace('AI = "gpt/"', 'AI = "gemini/"')
code = code.replace('os.path.join(RESULTS_PATH,"gpt/", PAPERS[paper_id][\'path\'], folder, png_path)', 'os.path.join(RESULTS_PATH, "gemini/", PAPERS[paper_id][\'path\'], folder, png_path)')

ns = {}
exec(code, ns)

paper_id = 1
folder = "0shot"
paper_path = ns["PAPERS"][paper_id]["path"]

real_answers_path = os.path.join(ns["DATA_PATH"], paper_path, ns["REAL_ANSWERS_FILE"])
target_dir = Path(ns["RESULTS_PATH"]) / "gemini" / paper_path / folder

pattern = re.compile(r"results_(?:line_|group_)?temp(?P<temp>[^_]+)_mode(?P<mode>[^.]+)\.csv$")

files = sorted([p for p in target_dir.glob("*.csv") if pattern.match(p.name)])

if not files:
    print(f"No input result files found in: {target_dir}")
    raise SystemExit(0)

print(f"Found {len(files)} result files in {target_dir}")

for file_path in files:
    match = pattern.match(file_path.name)
    temp = match.group("temp")
    mode = match.group("mode")

    print("=" * 80)
    print(f"Evaluating file: {file_path.name}")
    print(f"Temp: {temp} | Mode: {mode}")

    ns["paper_evaluation"](
        paper_id,
        real_answers_path,
        str(file_path),
        folder,
        temp,
        mode,
    )

print("\nDone: metrics generated for all 0shot files.")
