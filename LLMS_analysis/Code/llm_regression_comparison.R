# ==============================================================================
# Part 2: Extract LLM Predictions and Run Regressions
# ==============================================================================

library(readr)
library(dplyr)
library(tidyr)
library(sandwich)
library(lmtest)
library(stringr)

normalize_text <- function(x) {
  x %>%
    stringr::str_replace_all("\r|\n", " ") %>%
    stringr::str_squish() %>%
    stringr::str_to_lower()
}

cat("\n", paste(rep("=", 80), collapse=""), "\n")
cat("PART 2: EXTRACT LLM PREDICTIONS AND COMPARE REGRESSIONS\n")
cat(paste(rep("=", 80), collapse=""), "\n")

# Setup paths
project_root <- "C:/Users/danie/Dropbox/Javeriana/Proyecto LLMS text/LLMS_Project"
data_path <- file.path(project_root, "Papers", "Trust and Promises", "datapaper_anonymized.csv")
results_root <- file.path(project_root, "LLMS_analysis", "Results")

# Load original data
df <- read_csv(data_path, show_col_types = FALSE)
df_subset <- df %>% filter(role == 1) %>% as.data.frame()

# Add row index
df_subset$row_index <- which(df$role == 1)

# Prepare data for regression
reg_data <- df_subset %>% 
  select(row_index, numrolls, communication, is_promise, session, Message) %>%
  mutate(message_norm = normalize_text(Message)) %>%
  filter(!is.na(numrolls), !is.na(communication), !is.na(is_promise), !is.na(session)) %>%
  as.data.frame()

cat("\nBaseline data: n =", nrow(reg_data), "\n")

# ==============================================================================
# LOAD LLM PREDICTIONS FROM BEST-CONFIG FILES
# ==============================================================================

cat("\n", paste(rep("=", 80), collapse=""), "\n")
cat("STEP 1: LOAD LLM PREDICTIONS FROM BEST-CONFIG FILES\n")
cat(paste(rep("=", 80), collapse=""), "\n")

# Best configs identified earlier
best_configs <- list(
  claude = list(prompt_style = "0shot", temperature = 0),
  gemini = list(prompt_style = "0shot", temperature = 0.1),
  gpt = list(prompt_style = "0shot", temperature = 0.5)
)

llm_predictions <- list()

for (llm in names(best_configs)) {
  config <- best_configs[[llm]]
  style_path <- file.path(results_root, llm, "trust_promises_Ederer_Schneider", config$prompt_style)
  temp_str <- as.character(config$temperature)

  candidate_files <- c(
    file.path(style_path, sprintf("results_line_batch_temp%s_modeuser.csv", temp_str)),
    file.path(style_path, sprintf("results_line_temp%s_modeuser.csv", temp_str)),
    file.path(style_path, sprintf("results_temp%s_modeuser.csv", temp_str))
  )
  existing_file <- candidate_files[file.exists(candidate_files)][1]

  cat("\n", toupper(llm), ": target temp", temp_str, "\n")

  if (!is.na(existing_file)) {
    cat("  Loading from", basename(existing_file), "\n")
    tryCatch({
      llm_raw <- read_csv(existing_file, show_col_types = FALSE)

      if (!("is_promise" %in% names(llm_raw))) {
        stop("Column 'is_promise' not found in prediction file")
      }

      if ("original_message" %in% names(llm_raw)) {
        llm_preds <- llm_raw %>%
          select(is_promise, original_message) %>%
          mutate(message_norm = normalize_text(original_message)) %>%
          select(message_norm, is_promise)
      } else if ("row_id" %in% names(llm_raw)) {
        llm_preds <- llm_raw %>%
          select(is_promise, row_id) %>%
          mutate(row_index = row_id + 1) %>%
          select(row_index, is_promise)
      } else {
        # Fallback when row_id is absent: assume original order.
        llm_preds <- llm_raw %>%
          select(is_promise) %>%
          mutate(row_index = dplyr::row_number()) %>%
          select(row_index, is_promise)
      }

      llm_preds <- llm_preds %>% mutate(llm_name = llm)
      cat("  Loaded", nrow(llm_preds), "predictions\n")
      llm_predictions[[llm]] <- llm_preds
    }, error = function(e) {
      cat("  Error loading file:", e$message, "\n")
    })
  } else {
    cat("  No matching prediction file found.\n")
    available_files <- list.files(style_path, pattern = "^results.*temp.*modeuser\\.csv$")
    cat("  Available files:", paste(available_files, collapse = ", "), "\n")
  }
}

# ==============================================================================
# MERGE PREDICTIONS WITH REGRESSION DATA
# ==============================================================================

cat("\n", paste(rep("=", 80), collapse=""), "\n")
cat("STEP 2: MERGE LLM PREDICTIONS WITH DATA\n")
cat(paste(rep("=", 80), collapse=""), "\n")

# Create a combined dataframe with all predictions
regression_results <- list()

for (llm in names(llm_predictions)) {
  cat("\nMerging", toupper(llm), "predictions...\n")
  
  llm_preds <- llm_predictions[[llm]]

  merged_data <- reg_data %>% mutate(is_promise_llm = is_promise)

  # Prefer message-based merge when available.
  if ("message_norm" %in% names(llm_preds)) {
    pred_map <- llm_preds %>%
      select(message_norm, is_promise) %>%
      rename(is_promise_pred = is_promise) %>%
      distinct()

    merged_data <- merged_data %>%
      left_join(pred_map, by = "message_norm") %>%
      mutate(
        is_promise_llm = ifelse(
          communication == 1 & !is.na(is_promise_pred),
          is_promise_pred,
          is_promise_llm
        )
      )
  } else {
    pred_map <- llm_preds %>%
      select(row_index, is_promise) %>%
      rename(is_promise_pred = is_promise)

    merged_data <- merged_data %>%
      left_join(pred_map, by = "row_index") %>%
      mutate(
        is_promise_llm = ifelse(
          !is.na(is_promise_pred),
          is_promise_pred,
          is_promise_llm
        )
      )
  }
  
  cat("  Replaced coding for", sum(merged_data$communication == 1 & merged_data$is_promise_llm != merged_data$is_promise), "communication rows\n")
  
  # ==============================================================================
  # RUN REGRESSION WITH LLM PREDICTIONS
  # ==============================================================================
  
  cat("\n  Running regression with", toupper(llm), "predictions...\n")
  
  # Use full sample after replacement strategy.
  reg_data_llm <- merged_data %>%
    select(numrolls, communication, is_promise_llm, session) %>%
    drop_na() %>%
    as.data.frame()
  
  cat("  Regression data: n =", nrow(reg_data_llm), "\n")
  
  # Fit regression
  llm_fit <- lm(numrolls ~ communication + is_promise_llm, data = reg_data_llm)
  
  # Compute clustered standard errors
  vcov_cluster <- sandwich::vcovCL(llm_fit, 
                                    cluster = reg_data_llm$session, 
                                    type = "HC1")
  
  # Get coeftest
  llm_summary <- coeftest(llm_fit, vcov = vcov_cluster)
  
  cat("  Regression Results:\n")
  print(llm_summary)
  
  # Store results
  regression_results[[llm]] <- data.frame(
    model = llm,
    intercept = llm_fit$coefficients[1],
    communication_coef = llm_fit$coefficients[2],
    communication_pval = llm_summary[2, 4],
    communication_se = llm_summary[2, 2],
    is_promise_coef = llm_fit$coefficients[3],
    is_promise_pval = llm_summary[3, 4],
    is_promise_se = llm_summary[3, 2],
    rsquared = summary(llm_fit)$r.squared,
    n = nrow(reg_data_llm),
    row.names = NULL
  )
}

# ==============================================================================
# COMPARISON TABLE
# ==============================================================================

cat("\n", paste(rep("=", 80), collapse=""), "\n")
cat("STEP 3: REGRESSION COMPARISON TABLE\n")
cat(paste(rep("=", 80), collapse=""), "\n")

# Load baseline results (from previous script run)
baseline_results <- data.frame(
  model = "human_coding",
  intercept = 3.65193,
  communication_coef = 0.52114,
  communication_pval = 0.52187,
  communication_se = 0.81287,
  is_promise_coef = 1.97692,
  is_promise_pval = 0.03732,
  is_promise_se = 0.94579,
  rsquared = 0.1231,
  n = 353
)

# Combine all results
all_results <- do.call(rbind, c(list(baseline_results), regression_results))
rownames(all_results) <- NULL

cat("\n\nFULL COMPARISON TABLE:\n")
print(all_results)

# Create a nicely formatted comparison table for is_promise effect
comparison_table <- all_results %>%
  select(model, is_promise_coef, is_promise_se, is_promise_pval, n) %>%
  mutate(
    is_promise_coef = round(is_promise_coef, 4),
    is_promise_se = round(is_promise_se, 4),
    is_promise_pval = round(is_promise_pval, 4),
    significant = ifelse(is_promise_pval < 0.05, "✓", "")
  ) %>%
  rename(Model = model,
         `Coef(is_promise)` = is_promise_coef,
         `SE` = is_promise_se,
         `p-value` = is_promise_pval,
         `Sig?` = significant,
         `N` = n)

cat("\n\nIS_PROMISE EFFECT COMPARISON:\n")
cat("(Promise effect on number of ROLL choices)\n\n")
print(comparison_table, right = FALSE)

# Summary statistics
cat("\n\nSUMMARY:\n")
cat("Baseline (human coding) is_promise p-value:", round(baseline_results$is_promise_pval, 4), "\n")
cat("  Coefficient:", round(baseline_results$is_promise_coef, 4), "\n")

for (llm in names(regression_results)) {
  res <- regression_results[[llm]]
  cat("\n", toupper(llm), "is_promise p-value:", round(res$is_promise_pval, 4), "\n")
  cat("  Coefficient:", round(res$is_promise_coef, 4), "\n")
  cat("  Effect preserved:", ifelse(res$is_promise_pval < 0.05, "YES ✓", "NO ✗"), "\n")
}

cat("\nDone!\n")
