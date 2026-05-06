required_packages <- c("haven", "sandwich")

for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    stop(sprintf("Package '%s' is required. Install it before running this script.", pkg), call. = FALSE)
  }
}

get_script_path <- function() {
  args <- commandArgs(trailingOnly = FALSE)
  file_arg <- "--file="
  hit <- grep(file_arg, args)
  if (length(hit) > 0) {
    return(normalizePath(sub(file_arg, "", args[hit[1]]), winslash = "/", mustWork = FALSE))
  }
  return(normalizePath(getwd(), winslash = "/", mustWork = FALSE))
}

SCRIPT_PATH <- get_script_path()
SCRIPT_DIR <- if (file.info(SCRIPT_PATH)$isdir) SCRIPT_PATH else dirname(SCRIPT_PATH)
PROJECT_ROOT <- normalizePath(file.path(SCRIPT_DIR, "..", "..", "..", "..", ".."), winslash = "/", mustWork = TRUE)
DATA_DIR <- file.path(PROJECT_ROOT, "LLMS_analysis", "Data", "managerial_leadership_Jordi_Cooper")
RESULTS_DIR <- file.path(PROJECT_ROOT, "LLMS_analysis", "Results")
REPLICATION_DIR <- file.path(PROJECT_ROOT, "Papers", "3-Replication-Package")

CLASSIFY_FILE <- file.path(DATA_DIR, "classify.csv")
BEST_CONFIGS_FILE <- file.path(SCRIPT_DIR, "best_model_configs.csv")
CODING_DTA_FILE <- file.path(REPLICATION_DIR, "BC Coding Data, Main Experiment.dta")

OBS_KEYS <- c("session", "period", "group", "game")
TAGS <- c(
  "agree_proposal",
  "discuss_coordinate",
  "discuss_fairness",
  "discuss_efficient",
  "discuss_rules",
  "discuss_howtoplay",
  "explanation",
  "ask_game",
  "truthful",
  "falsehood"
)

TREATMENT_MAP <- c(
  "5" = "CH/S-D",
  "6" = "CH/A-D",
  "7" = "CH-MC"
)

label_treatment <- function(values) {
  mapped <- unname(TREATMENT_MAP[as.character(values)])
  ifelse(is.na(mapped), as.character(values), mapped)
}

MODEL_SPECS <- list(
  list(
    model = "chsd_coord",
    treatment = "CH/S-D",
    dep = "coordinate",
    regressors = c(
      "agree_proposal", "discuss_coordinate", "discuss_fairness",
      "discuss_efficient", "discuss_rules", "discuss_howtoplay",
      "explanation", "lag_coordinate_safe", "lag_coordinate_efficient",
      "lag_coordinate_failure", "late"
    ),
    mask_col = "chat_decent"
  ),
  list(
    model = "chsd_eff",
    treatment = "CH/S-D",
    dep = "coordinate_efficient",
    regressors = c(
      "agree_proposal", "discuss_coordinate", "discuss_fairness",
      "discuss_efficient", "discuss_rules", "discuss_howtoplay",
      "explanation", "lag_coordinate_safe", "lag_coordinate_efficient",
      "lag_coordinate_failure", "late"
    ),
    mask_col = "chat_decent"
  ),
  list(
    model = "chad_coord",
    treatment = "CH/A-D",
    dep = "coordinate",
    regressors = c(
      "agree_proposal", "discuss_coordinate", "discuss_fairness",
      "discuss_efficient", "discuss_rules", "discuss_howtoplay",
      "explanation", "lag_coordinate_safe", "lag_coordinate_efficient",
      "lag_coordinate_failure", "ask_game", "truthful", "falsehood", "late"
    ),
    mask_col = "chat_advice"
  ),
  list(
    model = "chad_eff",
    treatment = "CH/A-D",
    dep = "coordinate_efficient",
    regressors = c(
      "agree_proposal", "discuss_coordinate", "discuss_fairness",
      "discuss_efficient", "discuss_rules", "discuss_howtoplay",
      "explanation", "lag_coordinate_safe", "lag_coordinate_efficient",
      "lag_coordinate_failure", "ask_game", "truthful", "falsehood", "late"
    ),
    mask_col = "chat_advice"
  ),
  list(
    model = "chmc_eff",
    treatment = "CH-MC",
    dep = "coordinate_efficient",
    regressors = c(
      "agree_proposal", "discuss_coordinate", "discuss_fairness",
      "discuss_efficient", "discuss_rules", "discuss_howtoplay",
      "explanation", "lag_coordinate_safe", "lag_coordinate_efficient",
      "lag_coordinate_failure", "ask_game", "truthful", "falsehood", "late"
    ),
    mask_col = "chat_cent"
  )
)

PAPER_TABLE8 <- data.frame(
  term = c(
    "agree_proposal", "discuss_coordinate", "discuss_fairness", "discuss_efficient",
    "discuss_rules", "discuss_howtoplay", "explanation", "ask_game", "truthful", "falsehood"
  ),
  chsd_coord = c(0.108, -0.036, 0.013, 0.011, -0.055, 0.033, -0.041, NA, NA, NA),
  chsd_eff = c(0.217, 0.203, -0.265, 0.253, -0.061, -0.109, 0.056, NA, NA, NA),
  chad_coord = c(0.114, 0.032, -0.004, 0.050, 0.218, -0.060, -0.077, -0.055, 0.023, NA),
  chad_eff = c(0.184, 0.079, -0.087, 0.262, 0.112, 0.161, -0.166, -0.121, 0.205, NA),
  chmc_eff = c(0.045, -0.089, -0.101, 0.111, -0.165, -0.117, 0.035, 0.121, 0.295, -0.032),
  stringsAsFactors = FALSE
)

paper_long <- function() {
  out <- NULL
  for (model in names(PAPER_TABLE8)[names(PAPER_TABLE8) != "term"]) {
    chunk <- data.frame(
      term = PAPER_TABLE8$term,
      model = model,
      paper_coef = PAPER_TABLE8[[model]],
      stringsAsFactors = FALSE
    )
    out <- rbind(out, chunk)
  }
  out
}

read_best_configs <- function() {
  cfg <- read.csv(BEST_CONFIGS_FILE, stringsAsFactors = FALSE)
  cfg <- cfg[c("llm", "prompt_folder", "temperature", "selection_metric", "mean_krippendorff_alpha", "mean_macro_f1", "prediction_file")]
  cfg
}

read_prediction_labels <- function(path) {
  pred <- read.csv(path, stringsAsFactors = FALSE)
  if (!"row_id" %in% names(pred)) {
    stop(sprintf("Prediction file is missing row_id: %s", path), call. = FALSE)
  }
  keep <- data.frame(row_id = pred$row_id, stringsAsFactors = FALSE)
  for (tag in TAGS) {
    if (tag %in% names(pred)) {
      values <- suppressWarnings(as.numeric(pred[[tag]]))
      keep[[tag]] <- ifelse(is.na(values), NA_real_, as.numeric(values >= 0.5))
    } else {
      keep[[tag]] <- NA_real_
    }
  }
  keep
}

prepare_coding_base <- function() {
  coding <- haven::read_dta(CODING_DTA_FILE)
  coding <- as.data.frame(coding, stringsAsFactors = FALSE)
  for (key in OBS_KEYS) {
    coding[[key]] <- suppressWarnings(as.numeric(coding[[key]]))
  }
  keep_cols <- unique(c(
    OBS_KEYS,
    "session",
    "global_group",
    "true_treatment_ordered",
    "chat_decent",
    "chat_advice",
    "chat_cent",
    "coordinate",
    "coordinate_safe",
    "coordinate_efficient",
    "contradict",
    "disagreement",
    TAGS
  ))
  keep_cols <- keep_cols[keep_cols %in% names(coding)]
  coding <- unique(coding[keep_cols])
  coding$true_treatment_ordered <- label_treatment(coding$true_treatment_ordered)
  coding$late <- as.numeric(coding$period >= 10)
  coding$coordinate_failure <- 1 - coding$coordinate
  coding <- coding[order(coding$session, coding$global_group, coding$period), ]
  split_group <- split(coding, coding$global_group)
  split_group <- lapply(split_group, function(df) {
    df$lag_coordinate_efficient <- c(NA, head(df$coordinate_efficient, -1))
    df$lag_coordinate_safe <- c(NA, head(df$coordinate_safe, -1))
    df$lag_coordinate_failure <- c(NA, head(df$coordinate_failure, -1))
    df$hard_lie <- df$falsehood * as.numeric(df$contradict == 0) * as.numeric(df$disagreement == 0)
    df
  })
  do.call(rbind, split_group)
}

prepare_classified_base <- function(coding_base) {
  classify <- read.csv(CLASSIFY_FILE, stringsAsFactors = FALSE)
  for (key in OBS_KEYS) {
    classify[[key]] <- suppressWarnings(as.numeric(classify[[key]]))
  }
  classify$row_id <- seq_len(nrow(classify)) - 1

  coding_keep <- unique(c(
    OBS_KEYS,
    "global_group",
    "true_treatment_ordered",
    "chat_decent",
    "chat_advice",
    "chat_cent",
    "coordinate",
    "coordinate_safe",
    "coordinate_efficient",
    TAGS,
    "late",
    "coordinate_failure",
    "lag_coordinate_efficient",
    "lag_coordinate_safe",
    "lag_coordinate_failure"
  ))
  coding_unique <- unique(coding_base[coding_keep])
  merge(classify, coding_unique, by = OBS_KEYS, all.x = TRUE, sort = FALSE)
}

write_missing_treatment_diagnostic <- function(base) {
  classify <- read.csv(CLASSIFY_FILE, stringsAsFactors = FALSE)
  coding <- haven::read_dta(CODING_DTA_FILE)
  coding <- as.data.frame(coding, stringsAsFactors = FALSE)
  for (key in OBS_KEYS) {
    classify[[key]] <- suppressWarnings(as.numeric(classify[[key]]))
    coding[[key]] <- suppressWarnings(as.numeric(coding[[key]]))
  }
  coding$true_treatment_ordered <- label_treatment(coding$true_treatment_ordered)

  coding_key_cols <- unique(c(OBS_KEYS, "true_treatment_ordered", "session"))
  coding_keys <- unique(coding[coding_key_cols])
  mapped <- merge(classify, coding_keys, by = OBS_KEYS, all.x = TRUE, sort = FALSE)

  coding_counts <- as.data.frame(table(coding_keys$true_treatment_ordered), stringsAsFactors = FALSE)
  names(coding_counts) <- c("treatment", "coding_keys")
  classify_counts <- as.data.frame(table(mapped$true_treatment_ordered), stringsAsFactors = FALSE)
  names(classify_counts) <- c("treatment", "classified_keys")

  diag <- merge(coding_counts, classify_counts, by = "treatment", all = TRUE, sort = FALSE)
  diag$coding_keys[is.na(diag$coding_keys)] <- 0
  diag$classified_keys[is.na(diag$classified_keys)] <- 0
  diag$missing_from_classified <- as.integer(diag$classified_keys == 0)
  diag <- diag[order(diag$treatment), ]

  write.csv(diag, file.path(SCRIPT_DIR, "table8_r_missing_treatments_diagnostic.csv"), row.names = FALSE)

  missing <- diag$treatment[diag$missing_from_classified == 1]
  lines <- c(
    "Treatment coverage diagnostic for Table 8 R comparison",
    "",
    sprintf("Classified source file: %s", CLASSIFY_FILE),
    sprintf("Replication coding file: %s", CODING_DTA_FILE),
    "",
    paste("Missing treatments in classified keys:", if (length(missing) == 0) "None" else paste(missing, collapse = ", "))
  )
  writeLines(lines, con = file.path(SCRIPT_DIR, "table8_r_missing_treatments_diagnostic.txt"))
  diag
}

make_ensemble_labels <- function(label_frames) {
  if (length(label_frames) == 0) {
    return(NULL)
  }

  row_ids <- sort(unique(unlist(lapply(label_frames, function(df) df$row_id))))
  out <- data.frame(row_id = row_ids, stringsAsFactors = FALSE)
  for (tag in TAGS) {
    matrix_values <- sapply(label_frames, function(df) {
      aligned <- merge(data.frame(row_id = row_ids), df[c("row_id", tag)], by = "row_id", all.x = TRUE, sort = FALSE)
      aligned[[tag]]
    })
    if (is.null(dim(matrix_values))) {
      matrix_values <- matrix(matrix_values, ncol = 1)
    }
    means <- rowMeans(matrix_values, na.rm = TRUE)
    means[is.nan(means)] <- NA_real_
    out[[tag]] <- ifelse(is.na(means), NA_real_, as.numeric(means >= 0.5))
  }
  out
}

get_source_labels <- function(base) {
  sources <- list()
  sources$human <- base[c("row_id", TAGS)]

  cfg <- read_best_configs()
  write.csv(cfg, file.path(SCRIPT_DIR, "table8_r_best_model_configs_used.csv"), row.names = FALSE)

  llm_frames <- list()
  for (i in seq_len(nrow(cfg))) {
    llm <- cfg$llm[i]
    pred_file <- cfg$prediction_file[i]
    frame <- read_prediction_labels(pred_file)
    sources[[llm]] <- frame
    llm_frames[[llm]] <- frame
  }

  ensemble <- make_ensemble_labels(llm_frames)
  if (!is.null(ensemble)) {
    sources$ensemble_majority <- ensemble
  }

  sources
}

compute_lpm_coefficients <- function(data, dep, regressors) {
  needed <- unique(c(dep, "global_group", "game", regressors))
  present <- needed[needed %in% names(data)]
  used <- data[stats::complete.cases(data[present]), , drop = FALSE]
  if (nrow(used) == 0) {
    return(data.frame(term = character(), coef = numeric(), se = numeric(), p_value = numeric(), n = integer(), stringsAsFactors = FALSE))
  }

  varying_regs <- regressors[sapply(regressors, function(term) {
    term %in% names(used) && length(unique(used[[term]])) > 1
  })]
  if (length(varying_regs) == 0) {
    return(data.frame(term = character(), coef = numeric(), se = numeric(), p_value = numeric(), n = integer(), stringsAsFactors = FALSE))
  }

  form <- stats::as.formula(paste(dep, "~", paste(c(varying_regs, "factor(game)"), collapse = " + ")))
  fit <- tryCatch(
    stats::lm(form, data = used),
    error = function(e) NULL
  )
  if (is.null(fit)) {
    return(data.frame(term = character(), coef = numeric(), se = numeric(), p_value = numeric(), n = integer(), stringsAsFactors = FALSE))
  }

  vcov_mat <- tryCatch(
    sandwich::vcovCL(fit, cluster = used$global_group, type = "HC1"),
    error = function(e) NULL
  )
  if (is.null(vcov_mat)) {
    return(data.frame(term = character(), coef = numeric(), se = numeric(), p_value = numeric(), n = integer(), stringsAsFactors = FALSE))
  }

  beta <- stats::coef(fit)
  beta <- beta[!is.na(beta)]

  rows <- list()
  for (term in regressors) {
    if (!term %in% names(beta)) {
      next
    }
    se <- sqrt(vcov_mat[term, term])
    p_value <- 2 * stats::pt(-abs(beta[[term]] / se), df = fit$df.residual)
    rows[[length(rows) + 1]] <- data.frame(
      term = term,
      coef = unname(beta[[term]]),
      se = unname(se),
      p_value = unname(p_value),
      n = nrow(used),
      stringsAsFactors = FALSE
    )
  }

  if (length(rows) == 0) {
    return(data.frame(term = character(), coef = numeric(), se = numeric(), p_value = numeric(), n = integer(), stringsAsFactors = FALSE))
  }

  as.data.frame(do.call(rbind, rows), stringsAsFactors = FALSE)
}

run_models_for_base <- function(base, model_specs) {
  rows <- list()
  for (spec in model_specs) {
    mask <- !is.na(base[[spec$mask_col]]) & base[[spec$mask_col]] == 1 & !is.na(base$period) & base$period > 1
    subset <- base[mask, , drop = FALSE]
    result <- compute_lpm_coefficients(subset, spec$dep, spec$regressors)
    for (term in TAGS) {
      hit <- result[result$term == term, , drop = FALSE]
      if (nrow(hit) == 1) {
        rows[[length(rows) + 1]] <- data.frame(
          model = spec$model,
          treatment = spec$treatment,
          dependent_variable = spec$dep,
          term = term,
          coef = hit$coef,
          se = hit$se,
          p_value = hit$p_value,
          n = hit$n,
          stringsAsFactors = FALSE
        )
      } else {
        rows[[length(rows) + 1]] <- data.frame(
          model = spec$model,
          treatment = spec$treatment,
          dependent_variable = spec$dep,
          term = term,
          coef = NA_real_,
          se = NA_real_,
          p_value = NA_real_,
          n = nrow(subset),
          stringsAsFactors = FALSE
        )
      }
    }
  }
  as.data.frame(do.call(rbind, rows), stringsAsFactors = FALSE)
}

run_models_for_sources <- function(base, sources, model_specs) {
  out <- list()
  for (source_name in names(sources)) {
    labels <- sources[[source_name]]
    merged <- merge(base[setdiff(names(base), TAGS)], labels, by = "row_id", all.x = TRUE, sort = FALSE)
    result <- run_models_for_base(merged, model_specs)
    result$source <- source_name
    out[[length(out) + 1]] <- result
  }

  combined <- out[[1]]
  if (length(out) > 1) {
    for (i in 2:length(out)) {
      combined <- rbind(combined, out[[i]])
    }
  }
  rownames(combined) <- NULL
  combined
}

build_wide_comparison <- function(results, include_paper = TRUE) {
  long <- as.data.frame(results[c("treatment", "model", "term", "source", "coef")], stringsAsFactors = FALSE)
  wide <- reshape(
    long,
    timevar = "source",
    idvar = c("treatment", "model", "term"),
    direction = "wide"
  )
  names(wide) <- sub("^coef\\.", "", names(wide))
  rownames(wide) <- NULL

  if (include_paper) {
    paper <- paper_long()
    key_wide <- paste(wide$model, wide$term, sep = "||")
    key_paper <- paste(paper$model, paper$term, sep = "||")
    wide$paper_coef <- paper$paper_coef[match(key_wide, key_paper)]
  }

  wide
}

build_replication_package_comparison <- function(replication_results) {
  comparison <- merge(replication_results, paper_long(), by = c("model", "term"), all.x = TRUE, sort = FALSE)
  comparison$abs_diff <- abs(comparison$coef - comparison$paper_coef)
  comparison$matches_within_0_02 <- as.integer(!is.na(comparison$abs_diff) & comparison$abs_diff <= 0.02)
  comparison$matches_within_0_05 <- as.integer(!is.na(comparison$abs_diff) & comparison$abs_diff <= 0.05)
  comparison
}

build_replication_package_summary <- function(comparison) {
  comparable <- comparison[!is.na(comparison$coef) & !is.na(comparison$paper_coef), , drop = FALSE]
  if (nrow(comparable) == 0) {
    return(data.frame(
      comparable_terms = 0,
      mean_abs_diff = NA_real_,
      median_abs_diff = NA_real_,
      share_within_0_02 = NA_real_,
      share_within_0_05 = NA_real_,
      stringsAsFactors = FALSE
    ))
  }
  data.frame(
    comparable_terms = nrow(comparable),
    mean_abs_diff = mean(comparable$abs_diff),
    median_abs_diff = stats::median(comparable$abs_diff),
    share_within_0_02 = mean(comparable$matches_within_0_02),
    share_within_0_05 = mean(comparable$matches_within_0_05),
    stringsAsFactors = FALSE
  )
}

build_label_coverage <- function(base, diag) {
  treatment_counts <- as.data.frame(table(base$true_treatment_ordered), stringsAsFactors = FALSE)
  names(treatment_counts) <- c("treatment", "classified_count")
  merge(treatment_counts, diag[c("treatment", "coding_keys", "missing_from_classified")], by = "treatment", all.x = TRUE, sort = FALSE)
}

main <- function() {
  coding_base <- prepare_coding_base()
  message("prepared coding_base")
  classified_base <- prepare_classified_base(coding_base)
  message("prepared classified_base")
  diag <- write_missing_treatment_diagnostic(classified_base)
  message("wrote missing treatment diagnostic")
  sources <- get_source_labels(classified_base)
  message("loaded source labels")

  replication_results <- run_models_for_base(coding_base, MODEL_SPECS)
  message("ran replication-package models")
  replication_comparison <- build_replication_package_comparison(replication_results)
  replication_summary <- build_replication_package_summary(replication_comparison)
  message("built replication-package comparisons")

  available_treatments <- sort(unique(stats::na.omit(classified_base$true_treatment_ordered)))
  llm_specs <- MODEL_SPECS[vapply(MODEL_SPECS, function(spec) spec$treatment %in% available_treatments, logical(1))]
  llm_results <- run_models_for_sources(classified_base, sources, llm_specs)
  message("ran human and LLM replacement models")
  llm_wide <- build_wide_comparison(llm_results, include_paper = TRUE)
  message("built llm wide comparison")
  coverage <- build_label_coverage(classified_base, diag)
  message("built label coverage")

  write.csv(replication_results, file.path(SCRIPT_DIR, "table8_r_replication_package_lpm.csv"), row.names = FALSE)
  write.csv(replication_comparison, file.path(SCRIPT_DIR, "table8_r_replication_package_comparison.csv"), row.names = FALSE)
  write.csv(replication_summary, file.path(SCRIPT_DIR, "table8_r_replication_package_summary.csv"), row.names = FALSE)
  write.csv(llm_results, file.path(SCRIPT_DIR, "table8_r_probit_replication.csv"), row.names = FALSE)
  write.csv(llm_wide, file.path(SCRIPT_DIR, "table8_r_probit_comparison_table.csv"), row.names = FALSE)
  write.csv(coverage, file.path(SCRIPT_DIR, "table8_r_label_coverage.csv"), row.names = FALSE)

  message("Wrote table8_r_replication_package_lpm.csv")
  message("Wrote table8_r_replication_package_comparison.csv")
  message("Wrote table8_r_replication_package_summary.csv")
  message("Wrote table8_r_probit_replication.csv (LPM)")
  message("Wrote table8_r_probit_comparison_table.csv (LPM)")
  message("Wrote table8_r_best_model_configs_used.csv")
  message("Wrote table8_r_label_coverage.csv")
}

main()