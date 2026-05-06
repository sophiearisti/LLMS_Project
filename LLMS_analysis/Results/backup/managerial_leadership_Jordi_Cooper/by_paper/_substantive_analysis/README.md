# Paper 1 Substantive Analysis

This folder contains a paper-specific pipeline for Application 1 substantive validity.

`run_substantive_analysis.py` does four things:

1. Selects the best LLM configuration for each model using the existing `results_paper_1_*.csv` metric files.
2. Rebuilds a conversation-level analysis dataset by merging:
   - `LLMS_analysis/Data/managerial_leadership_Jordi_Cooper/classify.csv`
   - `LLMS_analysis/Data/managerial_leadership_Jordi_Cooper/real_answers.csv`
   - `Papers/3-Replication-Package/BC Coding Data, Main Experiment.dta`
   - `Papers/3-Replication-Package/BC Master Data, Main Experiment.dta`
3. Creates substantive-validity outputs for human labels, best-config LLM labels, and a simple majority ensemble.
4. Writes manuscript-ready CSVs for treatment contrasts, behavioral associations, and preservation checks.

Generated files:

- `all_model_config_scores.csv`
- `best_model_configs.csv`
- `selected_prediction_files.csv`
- `human_replication_base.csv`
- `analysis_dataset_long.csv`
- `tag_prevalence_by_treatment.csv`
- `treatment_gap_models.csv`
- `behavioral_association_models.csv`
- `preservation_summary.csv`
- `substantive_analysis_summary.json`

Active Table 8 workflow:

- `run_table8_llm_comparison.R`
- `make_table8_probit_latex.py`
- `table8_probit_comparison_table.tex`
- `table8_r_probit_replication.csv`
- `table8_r_probit_comparison_table.csv`
- `table8_r_replication_package_lpm.csv`
- `table8_r_replication_package_comparison.csv`
- `table8_r_replication_package_summary.csv`
- `table8_r_label_coverage.csv`
- `table8_r_missing_treatments_diagnostic.csv`
- `table8_r_missing_treatments_diagnostic.txt`

Notes for the active Table 8 workflow:

- The current manuscript table is the standalone file `table8_probit_comparison_table.tex`.
- The underlying estimation is now LPM, but some historical file names still retain `probit` for compatibility.
- CH/A-D is omitted because the shared chat/classification files do not contain the message-level inputs for that treatment.

Run from the workspace root with the project virtual environment:

```powershell
"c:/Users/danie/Dropbox/Javeriana/Proyecto LLMS text/LLMS_Project/LLMS_analysis/.venv/Scripts/python.exe" "c:/Users/danie/Dropbox/Javeriana/Proyecto LLMS text/LLMS_Project/LLMS_analysis/Results/by_paper/managerial_leadership_Jordi_Cooper/_substantive_analysis/run_substantive_analysis.py"
```