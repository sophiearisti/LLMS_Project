import os
from pathlib import Path

metrics_path = Path(__file__).with_name("metrics_analysis.py")
code = metrics_path.read_text(encoding="utf-8")
code = code.rsplit("main()", 1)[0]
ns = {}
exec(code, ns)

real_path = os.path.join(ns["DATA_PATH"], ns["PAPERS"][1]["path"], ns["REAL_ANSWERS_FILE"])
pred_path = os.path.join(
    ns["RESULTS_PATH"],
    "gemini",
    ns["PAPERS"][1]["path"],
    "0shot",
    "results_line_temp0_modeuser.csv",
)

print("REAL:", real_path)
print("PRED:", pred_path)
ns["paper_evaluation"](1, real_path, pred_path, "0shot", 0, "user")
