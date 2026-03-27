import subprocess
import sys
from pathlib import Path

proc = subprocess.run(
    [sys.executable, "metrics_analysis.py"],
    capture_output=True,
    text=True,
)

Path("metrics_stdout.log").write_text(proc.stdout or "", encoding="utf-8")
Path("metrics_stderr.log").write_text(proc.stderr or "", encoding="utf-8")
Path("metrics_exec_status.txt").write_text(f"returncode={proc.returncode}\n", encoding="utf-8")
