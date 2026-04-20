# Human Inter-Rater Reliability (IRR) Analysis

This folder computes and visualizes the agreement among the **3 human coders** who annotated the managerial leadership chat experiment. It uses Krippendorff's alpha as the primary multi-rater metric, and pairwise Cohen's kappa as a cross-check.

---

## Folder structure

```
IRR_analysis/
├── human_irr.py          # Main script — computes alphas and kappas
├── plot_irr.py           # Visualization script — bar chart + heatmap
├── README.md             # This file
└── irr_results/          # Generated outputs (created on first run)
    ├── krippendorff_alpha.csv
    ├── pairwise_kappa.csv
    ├── irr_summary.txt
    ├── krippendorff_alpha_plot.png
    └── pairwise_kappa_heatmap.png
```

---

## Input data

**File:** `../Data/managerial_leadership_Jordi_Cooper/tags.csv`

- 1,458 rows, one per conversation (identified by `session × period × group × game`)
- 15 binary label columns (see list below)
- Label values are **averages of 3 human coders**: `0.0 = 0/3`, `0.33 = 1/3`, `0.67 = 2/3`, `1.0 = 3/3`
- Individual coder annotations are not stored separately in any file; they must be reconstructed from the fractions

---

## Label columns

| Column | Description |
|---|---|
| `any_suggestion` | Any coordination suggestion was made |
| `suggest_safe` | Suggested the safe (low-risk) option |
| `suggest_efficient` | Suggested the efficient (high-payoff) option |
| `agree_proposal` | Agreed to a proposal |
| `discuss_fairness` | Discussed fairness of payoffs |
| `discuss_efficient` | Discussed efficiency of options |
| `discuss_rules` | Discussed game rules |
| `explanation` | Gave an explanation |
| `discuss_howtoplay` | Discussed how to play |
| `ask_game` | Asked about the game |
| `receive_report` | Received a report |
| `truthful` | Gave truthful information |
| `falsehood` | Gave false information |
| `contradict` | Contradicted a previous statement |
| `neither_report` | Neither truthful nor false (ambiguous) |

---

## Methodology

### Step 1 — Reconstruct individual coder vectors

Because only the **average** across coders is stored, we reconstruct 3 binary coder vectors from each fraction:

```
k = round(avg × 3)        # integer number of coders who said "1" (0, 1, 2, or 3)
coder 1 = 1 if k >= 1     # most "permissive" coder
coder 2 = 1 if k >= 2
coder 3 = 1 if k >= 3     # most "strict" coder
```

This produces the minimal-disagreement reconstruction consistent with the stored fraction. It is the standard approach when only aggregated annotations are available.

### Step 2 — Binarization (for majority-vote ground truth)

For downstream use (e.g., comparing against LLM labels):

```
avg > 0.5  →  1   (strict majority: at least 2 of 3 coders)
avg ≤ 0.5  →  0
```

This threshold is applied in `human_irr.py` but the ground-truth binarized file is not written here — it should be generated in the LLM comparison script.

### Step 3 — Krippendorff's alpha

Krippendorff's alpha is the preferred metric for multi-rater, multi-item reliability because:
- It handles **3+ raters** natively (unlike Cohen's kappa, which is pairwise only)
- It accounts for **chance agreement** differently depending on the measurement level
- It is appropriate for **nominal (binary)** labels

The reliability matrix passed to `krippendorff.alpha()` has shape `(3, 1458)` with `NaN` where a coder's rating cannot be recovered (not applicable here since all items have 3 coders).

**Level of measurement:** `nominal` (binary 0/1 labels).

**Interpretation thresholds** (Krippendorff 2004):

| Alpha | Interpretation |
|---|---|
| ≥ 0.80 | Strong agreement — suitable for publication |
| 0.67 – 0.80 | Tentative — use conclusions cautiously |
| < 0.67 | Unreliable — do not draw substantive conclusions |

### Step 4 — Pairwise Cohen's kappa

Three coder pairs are evaluated (C1–C2, C1–C3, C2–C3) for each label. This reveals whether disagreement is evenly distributed or driven by one problematic coder. Results are averaged over labels for a summary view.

---

## Results summary

From the run on 1,458 conversations:

| Label | Krippendorff α | Interpretation |
|---|---|---|
| any_suggestion | 0.8814 | Strong |
| suggest_safe | 0.9488 | Strong |
| suggest_efficient | 0.9506 | Strong |
| agree_proposal | 0.7152 | Tentative |
| discuss_fairness | 0.4653 | **Unreliable** |
| discuss_efficient | 0.7035 | Tentative |
| discuss_rules | 0.4420 | **Unreliable** |
| explanation | 0.2386 | **Unreliable** |
| discuss_howtoplay | 0.2727 | **Unreliable** |
| ask_game | 0.9045 | Strong |
| receive_report | 0.9242 | Strong |
| truthful | 0.9248 | Strong |
| falsehood | 0.8313 | Strong |
| contradict | 0.8448 | Strong |
| neither_report | 0.9428 | Strong |

**Pairwise mean kappa:** C1–C2 = 0.688, C1–C3 = 0.639, C2–C3 = 0.893

Labels `discuss_fairness`, `discuss_rules`, `explanation`, and `discuss_howtoplay` show low human agreement and should be treated cautiously in any LLM comparison.

---

## How to run

```bash
# 1. Install dependencies (once)
pip install krippendorff scikit-learn pandas matplotlib

# 2. Compute IRR metrics
python human_irr.py

# 3. Generate plots
python plot_irr.py
```

Run both scripts from inside the `IRR_analysis/` folder. Outputs are written to `irr_results/`.

---

## Dependencies

| Package | Purpose |
|---|---|
| `krippendorff` | Krippendorff's alpha computation |
| `scikit-learn` | Cohen's kappa via `sklearn.metrics.cohen_kappa_score` |
| `pandas` | Data loading and manipulation |
| `numpy` | Numerical operations |
| `matplotlib` | Visualization |
