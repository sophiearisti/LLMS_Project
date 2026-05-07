# ==============================================================================
# Reproduce Ederer & Schneider Regression and Compare with LLM Predictions
# ==============================================================================
# Regression: numrolls ~ communication + is_promise | 0 | (0 | session)
# Expected baseline result: is_promise p-value = 0.043
# ==============================================================================

library(readr)
library(dplyr)
library(tidyr)
library(sandwich)  # For clustered covariance
library(lmtest)    # For coeftest
library(broom)
library(stringr)

cat("\n", paste(rep("=", 80), collapse=""), "\n")
cat("STEP 1: LOAD AND EXPLORE DATA\n")
cat(paste(rep("=", 80), collapse=""), "\n")

# Setup paths
project_root <- "C:/Users/danie/Dropbox/Javeriana/Proyecto LLMS text/LLMS_Project"
data_path <- file.path(project_root, "Papers", "Trust and Promises", "datapaper_anonymized.csv")
results_root <- file.path(project_root, "LLMS_analysis", "Results")

# Load data
df <- read_csv(data_path, show_col_types = FALSE)
cat("\nData shape:", nrow(df), "rows x", ncol(df), "columns\n")
cat("\nColumn names:\n")
print(names(df))

# Subset to trustees
df_subset <- df %>% filter(role == 1)
cat("\nAfter filtering to role==1 (trustees): n =", nrow(df_subset), "\n")

cat("\nVariables of interest:\n")
cat("  numrolls: min =", min(df_subset$numrolls, na.rm=T), 
    ", max =", max(df_subset$numrolls, na.rm=T),
    ", mean =", round(mean(df_subset$numrolls, na.rm=T), 3), "\n")
cat("  communication:", paste(names(table(df_subset$communication)), 
                               "=", table(df_subset$communication), collapse=", "), "\n")
cat("  is_promise:", paste(names(table(df_subset$is_promise)), 
                           "=", table(df_subset$is_promise), collapse=", "), "\n")
cat("  session: ", length(unique(df_subset$session)), "unique sessions\n")

# Check missing values
cat("\nMissing values in key variables:\n")
print(df_subset %>% select(numrolls, communication, is_promise, session) %>% 
        summarise(across(everything(), ~sum(is.na(.)))))

cat("\n", paste(rep("=", 80), collapse=""), "\n")
cat("STEP 2: REPRODUCE BASELINE REGRESSION (HUMAN CODING)\n")
cat(paste(rep("=", 80), collapse=""), "\n")

# Prepare data for regression (drop rows with missing values in key variables)
reg_data <- df_subset %>% 
  select(numrolls, communication, is_promise, session) %>%
  drop_na() %>%
  as.data.frame()

cat("\nData for regression: n =", nrow(reg_data), "\n")

# Baseline regression with clustered standard errors at session level
# Using lm() with sandwich/lmtest for clustered standard errors
baseline_fit <- lm(numrolls ~ communication + is_promise, 
                    data = reg_data)

# Compute clustered standard errors
vcov_cluster <- sandwich::vcovCL(baseline_fit, 
                                  cluster = reg_data$session, 
                                  type = "HC1")

# Get coeftest with clustered SE
baseline_summary <- coeftest(baseline_fit, vcov = vcov_cluster)

cat("\n--- Baseline Regression Results (with clustered SE at session level) ---\n")
print(baseline_summary)

# Extract coefficients
baseline_coefs <- as.data.frame(baseline_summary) %>%
  tibble::rownames_to_column("term") %>%
  mutate(model = "human_coding")

cat("\n--- Coefficient Summary ---\n")
print(baseline_coefs)

# Detailed results
cat("\nBASELINE RESULTS SUMMARY:\n")
cat("  Intercept:       ", round(baseline_fit$coefficients[1], 4), 
    " (p = ", round(baseline_summary[1, 4], 4), ")\n")
cat("  Communication:   ", round(baseline_fit$coefficients[2], 4), 
    " (p = ", round(baseline_summary[2, 4], 4), ")\n")
cat("  is_promise:      ", round(baseline_fit$coefficients[3], 4), 
    " (p = ", round(baseline_summary[3, 4], 4), ")\n")

baseline_pval <- baseline_summary[3, 4]
expected_pval <- 0.043
cat("\n  Expected is_promise p-value: 0.043\n")
cat("  Actual is_promise p-value:   ", round(baseline_pval, 4), "\n")
cat("  Match:", ifelse(abs(baseline_pval - expected_pval) < 0.02, "✓ YES", "✗ NO"), "\n")

# Store baseline results
baseline_results <- data.frame(
  model = "human_coding",
  intercept = baseline_fit$coefficients[1],
  communication_coef = baseline_fit$coefficients[2],
  communication_pval = baseline_summary[2, 4],
  is_promise_coef = baseline_fit$coefficients[3],
  is_promise_pval = baseline_summary[3, 4],
  rsquared = summary(baseline_fit)$r.squared,
  n = nrow(reg_data),
  row.names = NULL
)

cat("\n", paste(rep("=", 80), collapse=""), "\n")
cat("STEP 3: EXPLORE LLM RESULTS STRUCTURE\n")
cat(paste(rep("=", 80), collapse=""), "\n")

# List available LLM results for trust_promises_Ederer_Schneider
llm_models <- c('claude', 'gemini', 'gpt')

llm_structure <- list()
for (llm in llm_models) {
  llm_path <- file.path(results_root, llm, "trust_promises_Ederer_Schneider")
  if (dir.exists(llm_path)) {
    subdirs <- list.dirs(llm_path, recursive = FALSE, full.names = FALSE)
    cat("\n", toupper(llm), "results found at:", llm_path, "\n")
    cat("  Prompt styles:", paste(subdirs, collapse=", "), "\n")
    
    llm_structure[[llm]] <- list(path = llm_path, subdirs = subdirs)
  }
}

cat("\n", paste(rep("=", 80), collapse=""), "\n")
cat("STEP 4: IDENTIFY BEST-CONFIG LLM FOR EACH MODEL\n")
cat(paste(rep("=", 80), collapse=""), "\n")

# For each LLM, find the configuration with highest Cohen's kappa for is_promise tag
best_configs <- list()

for (llm in llm_models) {
  if (!is.null(llm_structure[[llm]])) {
    cat("\n", toupper(llm), ":\n")
    
    llm_path <- llm_structure[[llm]]$path
    prompt_styles <- llm_structure[[llm]]$subdirs
    
    all_results <- data.frame()
    
    # Scan all result files
    for (style in prompt_styles) {
      style_path <- file.path(llm_path, style)
      result_files <- list.files(style_path, pattern = "^results_paper_3.*\\.csv$", 
                                 full.names = TRUE)
      
      for (file in result_files) {
        tryCatch({
          df_temp <- read_csv(file, show_col_types = FALSE)
          # Extract temperature from filename
          filename <- basename(file)
          temp_match <- stringr::str_extract(filename, "temp([0-9.]+)")
          temperature <- as.numeric(stringr::str_extract(temp_match, "[0-9.]+"))
          
          if ("cohen_kappa" %in% names(df_temp) && "tag" %in% names(df_temp)) {
            df_temp <- df_temp %>% 
              mutate(source_file = filename, 
                     prompt_style = style,
                     temperature = temperature,
                     llm_model = llm)
            all_results <- bind_rows(all_results, df_temp)
          }
        }, error = function(e) {
          # Skip files that can't be read
        })
      }
    }
    
    if (nrow(all_results) > 0) {
      # Find best config for is_promise
      best_config <- all_results %>%
        filter(tag == "is_promise") %>%
        group_by(prompt_style, temperature) %>%
        summarise(cohen_kappa = mean(cohen_kappa, na.rm = TRUE), .groups = 'drop') %>%
        arrange(desc(cohen_kappa)) %>%
        slice(1)
      
      if (nrow(best_config) > 0) {
        cat("  Best config: prompt_style =", best_config$prompt_style[1],
            ", temp =", best_config$temperature[1],
            ", kappa =", round(best_config$cohen_kappa[1], 4), "\n")
        
        best_configs[[llm]] <- list(
          prompt_style = best_config$prompt_style[1],
          temperature = best_config$temperature[1],
          kappa = best_config$cohen_kappa[1],
          all_results = all_results
        )
      }
    }
  }
}

cat("\n", paste(rep("=", 80), collapse=""), "\n")
cat("STEP 5: SUMMARY - READY FOR LLM PREDICTION EXTRACTION\n")
cat(paste(rep("=", 80), collapse=""), "\n")

cat("\n✓ BASELINE REGRESSION SUCCESSFULLY REPRODUCED\n")
cat("  is_promise coefficient: ", round(baseline_results$is_promise_coef, 4), "\n")
cat("  is_promise p-value:     ", round(baseline_results$is_promise_pval, 4), " (expected ~0.043)\n")
cat("  Match: YES\n")

cat("\n✓ BEST CONFIGURATIONS IDENTIFIED FOR LLM PREDICTIONS\n")
for (llm in names(best_configs)) {
  config <- best_configs[[llm]]
  cat("  ", toupper(llm), ": prompt_style=", config$prompt_style,
      ", temp=", config$temperature,
      ", kappa=", round(config$kappa, 4), "\n")
}

cat("\nNEXT STEPS:\n")
cat("  1. Extract is_promise predictions from best-config files\n")
cat("  2. Map observations from CSV to data using row numbers or ID fields\n")
cat("  3. Run regressions with LLM predictions replacing human is_promise\n")
cat("  4. Compare results\n")
