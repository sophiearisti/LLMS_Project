## Final Figure/Table Set for Main Text

Use only these three items in the main paper:

1. Figure 1: Best metric score heatmap (by model, metric, paper)
2. Figure 2: Temperature sensitivity of aggregate score
3. Table 1: Model summary (wins, average rank, robustness)

Generated outputs are expected in `LLMS_analysis/Graphs/paper_ready/`:

- `figure1_heatmap_best_config.png`
- `figure2_temperature_sensitivity.png`
- `table1_model_summary.csv`

---

## Caption Drafts (Paste-Ready)

### Figure 1 caption
Best metric score by model across papers. Each cell reports the highest mean score achieved by a model for a given metric after selecting the best prompting configuration (0-shot or few-shot) and temperature. Cell annotations indicate the winning configuration as shot@temperature. This panel summarizes headline performance while preserving configuration information.

### Figure 2 caption
Temperature sensitivity of aggregate performance. The y-axis reports the aggregate score, defined as the mean of six core metrics (accuracy, Cohen's kappa, precision and recall for classes 0 and 1). Separate line types represent prompting style (0-shot vs few-shot). Stable lines indicate robustness to decoding temperature.

### Table 1 caption
Comparative model summary across papers. Wins counts the number of paper-metric settings in which a model attains the top score. Average rank and median rank are computed from within-setting rankings. Temperature SD reports variability in aggregate score across temperatures, where lower values indicate greater robustness.

---

## Results Text Draft (Fill With Your Numbers)

### Main comparison paragraph
Across all paper-metric settings, [MODEL_A] achieved the strongest overall performance, with [WINS_A] wins and the best average rank ([AVG_RANK_A]). [MODEL_B] and [MODEL_C] followed with [WINS_B] and [WINS_C] wins, respectively. These results indicate that the ranking is [stable/mixed] across tasks rather than driven by a single benchmark.

### Prompting effect paragraph
Few-shot prompting improved aggregate performance by [DELTA_FEWSHOT] points on average relative to 0-shot conditions, with the largest gains observed in [METRIC_X]. The improvement pattern was [consistent/heterogeneous] across papers, suggesting that prompt-format sensitivity depends on task structure.

### Robustness paragraph
Model robustness to temperature variation differed meaningfully. [MODEL_ROBUST] showed the lowest cross-temperature variability (SD = [SD_MIN]), whereas [MODEL_SENSITIVE] was more sensitive to decoding settings (SD = [SD_MAX]). Thus, performance conclusions for [MODEL_SENSITIVE] should be interpreted jointly with generation hyperparameters.

### Appendix reference sentence
Detailed per-tag and per-configuration plots are provided in the appendix, where we report the full set of condition-specific graphs used to construct the summary statistics.

---

## Methods Note (One Sentence)

All summary statistics are computed from the same underlying result files used for the appendix figures; the main-text panels apply pre-registered aggregation rules to improve interpretability and reduce visual overload.

---

## How to Generate

Run:

`Rscript LLMS_analysis/Graphs/paper_summary_figures.R`

If Rscript is not available on PATH, run the script from your R IDE/session with working directory in `LLMS_analysis/Graphs`.
