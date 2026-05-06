library(readr)
library(dplyr)
library(ggplot2)
library(scales)

# Paper-ready heatmaps:
# 1) Agreement heatmap — Krippendorff alpha for paper 1 (4-rater),
#    Cohen kappa for all other papers (2-rater)
# 2) Macro F1 heatmap
# 3) Tags with fewer than 10 positive cases are excluded
# 4) Outputs saved as PDF and PNG

papers <- data.frame(
  paper_id = c(1, 3, 4),
  paper_name = c(
    "managerial_leadership_Jordi_Cooper",
    "trust_promises_Ederer_Schneider",
    "under_reporting_Ling_Kale_Imas"
  ),
  stringsAsFactors = FALSE
)

paper_labels <- c(
  "managerial_leadership_Jordi_Cooper" = "Brandts and Cooper (2025)",
  "trust_promises_Ederer_Schneider"    = "Ederer and Schneider (2022)",
  "under_reporting_Ling_Kale_Imas"     = "Ling et al. (2025)"
)

llm_labels <- c(
  "gpt"    = "GPT",
  "gemini" = "Gemini",
  "claude" = "Claude"
)

shot_levels        <- c("0shot", "fewshot")
temperature_levels <- c(0, 0.1, 0.5, 1, 1.2)
config_levels      <- as.vector(
  outer(shot_levels, temperature_levels, paste, sep = "@")
)

theme_heatmap <- function() {
  theme_minimal(base_size = 11) +
    theme(
      plot.title    = element_text(
        size = 12, face = "bold", margin = margin(b = 6)
      ),
      plot.subtitle = element_text(
        size = 10, color = "grey40", margin = margin(b = 8)
      ),
      axis.title.x  = element_text(size = 10, margin = margin(t = 6)),
      axis.title.y  = element_text(size = 10, margin = margin(r = 6)),
      axis.text     = element_text(size = 9, color = "grey30"),
      panel.grid    = element_blank(),
      strip.text    = element_text(size = 10, face = "bold"),
      legend.title  = element_text(size = 9, face = "bold"),
      legend.text   = element_text(size = 9),
      plot.margin   = margin(8, 12, 8, 8)
    )
}

normalize_labels <- function(values) {
  values_chr <- as.character(values)
  values_chr[is.na(values)] <- "nan"
  values_chr <- tolower(trimws(values_chr))
  sub("\\.0$", "", values_chr)
}

# Resolve paths relative to this script's directory.
script_args  <- commandArgs(trailingOnly = FALSE)
script_flag  <- "--file="
script_path  <- sub(
  script_flag, "",
  script_args[grep(script_flag, script_args)]
)
script_dir   <- if (length(script_path) > 0) {
  dirname(normalizePath(script_path))
} else {
  getwd()
}

results_dir <- normalizePath(
  file.path(script_dir, "..", "Results"),
  winslash = "/", mustWork = FALSE
)
data_dir <- normalizePath(
  file.path(script_dir, "..", "Data"),
  winslash = "/", mustWork = FALSE
)
output_dir <- file.path(script_dir, "paper_ready")

if (!dir.exists(results_dir)) {
  stop("Results directory not found. Expected: ", results_dir)
}
if (!dir.exists(data_dir)) {
  stop("Data directory not found. Expected: ", data_dir)
}

dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

csv_paths <- list.files(
  path      = results_dir,
  pattern   = "^results_paper_.*\\.csv$",
  recursive = TRUE,
  full.names = TRUE
)

if (length(csv_paths) == 0) {
  stop("No results CSV files found under: ", results_dir)
}

parse_meta <- function(path) {
  path_norm <- gsub("\\\\", "/", path)
  escaped   <- gsub(
    "([.|(){}+^$?*\\[\\]\\\\])", "\\\\\\1", results_dir
  )
  rel    <- sub(paste0("^", escaped, "/"), "", path_norm)
  parts  <- strsplit(rel, "/")[[1]]
  fname  <- basename(path_norm)

  temp_match  <- regmatches(fname, regexpr("_temp[0-9.]+", fname))
  temp_value  <- as.numeric(sub("_temp", "", temp_match))
  shot_match  <- regmatches(
    fname, regexpr("_type(0shot|fewshot)", fname)
  )
  shot_value  <- sub("_type", "", shot_match)

  data.frame(
    llm        = ifelse(length(parts) >= 1, parts[1], NA_character_),
    paper_name = ifelse(length(parts) >= 2, parts[2], NA_character_),
    shot       = shot_value,
    temperature = temp_value,
    stringsAsFactors = FALSE
  )
}

all_data <- vector("list", length(csv_paths))

for (i in seq_along(csv_paths)) {
  p    <- csv_paths[i]
  meta <- parse_meta(p)
  df   <- read_csv(p, show_col_types = FALSE)

  if (!("cohen_kappa" %in% names(df)) && ("kappa" %in% names(df))) {
    df <- df |> mutate(cohen_kappa = kappa)
  }

  required_metrics <- c("cohen_kappa", "macro_f1")
  if (!all(required_metrics %in% names(df))) {
    warning("Skipping file missing required metrics: ", p)
    next
  }

  df <- df |>
    mutate(
      llm         = meta$llm,
      paper_name  = meta$paper_name,
      shot        = meta$shot,
      temperature = meta$temperature
    )

  all_data[[i]] <- df
}

results_df <- bind_rows(all_data)

if (nrow(results_df) == 0) {
  stop("No valid rows after loading files.")
}

results_df <- results_df |>
  filter(
    llm %in% c("gpt", "gemini", "claude"),
    shot %in% shot_levels,
    paper_name %in% papers$paper_name
  )

compute_positive_counts <- function(paper_nm, available_tags) {
  truth_path <- file.path(data_dir, paper_nm, "real_answers.csv")

  if (!file.exists(truth_path)) {
    warning(
      "Ground-truth file not found for filtering: ", truth_path
    )
    return(data.frame(
      paper_name = character(),
      tag        = character(),
      positive_n = integer(),
      stringsAsFactors = FALSE
    ))
  }

  truth_df <- read_csv(truth_path, show_col_types = FALSE)
  tag_cols <- intersect(available_tags, names(truth_df))

  bind_rows(lapply(tag_cols, function(tag_name) {
    normalized <- normalize_labels(truth_df[[tag_name]])
    data.frame(
      paper_name = paper_nm,
      tag        = tag_name,
      positive_n = sum(normalized == "1", na.rm = TRUE),
      stringsAsFactors = FALSE
    )
  }))
}

positive_counts <- bind_rows(lapply(
  papers$paper_name, function(paper_nm) {
    available_tags <- unique(
      results_df$tag[results_df$paper_name == paper_nm]
    )
    compute_positive_counts(paper_nm, available_tags)
  }
))

filtered_results_df <- results_df |>
  left_join(positive_counts, by = c("paper_name", "tag")) |>
  filter(!is.na(positive_n), positive_n >= 10)

if (nrow(filtered_results_df) == 0) {
  stop("No rows remain after applying the positive-case filter.")
}

# ─────────────────────────────────────────────────────────────────
# Agreement metric routing:
#   paper 1  → krippendorff_alpha (4-rater: 3 humans + LLM)
#   others   → cohen_kappa        (2-rater: human gold vs. LLM)
# ─────────────────────────────────────────────────────────────────

PAPER1 <- "managerial_leadership_Jordi_Cooper"

filtered_results_df <- filtered_results_df |>
  mutate(
    agreement = case_when(
      paper_name == PAPER1 ~ krippendorff_alpha,
      TRUE                 ~ cohen_kappa
    )
  )

build_heatmap_data <- function(data, metric_name, threshold = 0.8) {
  data |>
    group_by(
      .data$paper_name, .data$llm,
      .data$shot, .data$temperature
    ) |>
    summarise(
      mean_value      = mean(.data[[metric_name]], na.rm = TRUE),
      evaluable_tag_n = n_distinct(.data$tag),
      .groups = "drop"
    ) |>
    mutate(
      config    = paste0(.data$shot, "@", .data$temperature),
      config    = factor(.data$config, levels = config_levels),
      llm       = factor(
        .data$llm, levels = intersect(c("gpt", "gemini", "claude"),
                                      unique(.data$llm))
      ),
      label     = paste0(
        sprintf("%.2f", .data$mean_value),
        "\nN=", .data$evaluable_tag_n
      ),
      highlight = .data$mean_value >= threshold
    )
}

build_agreement_heatmap_data <- function(data, threshold = 0.8) {
  build_heatmap_data(data, "agreement", threshold)
}

make_heatmap_plot <- function(
    heatmap_df, fill_name, title_str,
    subtitle_str, threshold = 0.8) {

  ggplot(
    heatmap_df,
    aes(
      x    = .data$config,
      y    = .data$llm,
      fill = .data$mean_value
    )
  ) +
    geom_tile(color = "white", linewidth = 0.4) +
    geom_tile(
      data      = heatmap_df |> filter(.data$highlight),
      fill      = NA,
      color     = "#111111",
      linewidth = 0.9
    ) +
    geom_text(
      aes(label = .data$label),
      size = 3, lineheight = 0.9
    ) +
    facet_wrap(
      ~paper_name, ncol = 1,
      labeller = as_labeller(paper_labels)
    ) +
    scale_x_discrete(drop = FALSE) +
    scale_y_discrete(labels = llm_labels, drop = TRUE) +
    scale_fill_gradientn(
      colors = c(
        "#b2182b", "#f4a582", "#f7f7f7", "#92c5de", "#2166ac"
      ),
      values = rescale(c(0, 0.6, 0.7, threshold, 1)),
      limits = c(0, 1),
      breaks = c(0, 0.6, threshold, 1),
      labels = c(
        "0.00", "0.60",
        sprintf("%.2f", threshold), "1.00"
      ),
      name = fill_name
    ) +
    labs(
      title    = title_str,
      subtitle = subtitle_str,
      x        = "Configuration (shot@temperature)",
      y        = "Model"
    ) +
    theme_heatmap() +
    theme(axis.text.x = element_text(angle = 30, hjust = 1))
}

save_plot <- function(p, file_stub, width = 11, height = 8.5) {
  ggsave(
    file.path(output_dir, paste0(file_stub, ".pdf")),
    p, width = width, height = height
  )
  ggsave(
    file.path(output_dir, paste0(file_stub, ".png")),
    p, width = width, height = height, dpi = 300
  )
}

# ─────────────────────────────────────────────────────────────────
# Figure 1 — Agreement heatmap
# ─────────────────────────────────────────────────────────────────

agreement_df <- build_agreement_heatmap_data(
  filtered_results_df, threshold = 0.8
)

agreement_subtitle <- paste0(
  "Brandts & Cooper: Krippendorff alpha (3 human coders + LLM)  |  ",
  "Other papers: Cohen kappa (human gold standard vs. LLM)\n",
  "Tags < 10 positive cases excluded.",
  " Bold border = agreement >= 0.80."
)

p_agreement <- make_heatmap_plot(
  heatmap_df   = agreement_df,
  fill_name    = "Agreement",
  title_str    = paste0(
    "LLM Agreement with Human Annotations",
    " Across Papers and Configurations"
  ),
  subtitle_str = agreement_subtitle,
  threshold    = 0.8
)

save_plot(p_agreement, "figure1_agreement_heatmap_by_paper")

# ─────────────────────────────────────────────────────────────────
# Figure 2 — Macro F1 heatmap
# ─────────────────────────────────────────────────────────────────

macro_f1_df <- build_heatmap_data(
  filtered_results_df, "macro_f1", threshold = 0.8
)

f1_subtitle <- paste0(
  "Cells show average Macro F1 across tags",
  " with at least 10 positive cases.",
  " Bold border = Macro F1 \u2265 0.80."
)

p_f1 <- make_heatmap_plot(
  heatmap_df   = macro_f1_df,
  fill_name    = "Macro F1",
  title_str    = paste0(
    "LLM Macro F1 Across Papers and Configurations"
  ),
  subtitle_str = f1_subtitle,
  threshold    = 0.8
)

save_plot(p_f1, "figure2_macro_f1_heatmap_by_paper")

message("Done. Outputs written to: ", output_dir)
message(
  " - figure1_agreement_heatmap_by_paper.pdf/.png",
  "  (Krippendorff alpha paper 1, Cohen kappa others)"
)
message(" - figure2_macro_f1_heatmap_by_paper.pdf/.png")

# ─────────────────────────────────────────────────────────────────
# Per-paper figures (same style, single facet each)
# ─────────────────────────────────────────────────────────────────

agreement_metric_labels <- c(
  "managerial_leadership_Jordi_Cooper" = paste0(
    "Krippendorff’s α (3 human coders + LLM)"
  ),
  "trust_promises_Ederer_Schneider"    = "Cohen kappa",
  "under_reporting_Ling_Kale_Imas"     = "Cohen kappa"
)

for (i in seq_len(nrow(papers))) {
  paper_nm  <- papers$paper_name[i]
  paper_lbl <- paper_labels[paper_nm]
  metric_nm <- agreement_metric_labels[paper_nm]

  paper_data <- filtered_results_df |> filter(paper_name == paper_nm)
  if (nrow(paper_data) == 0) next

  # Agreement
  paper_agreement_df <- build_agreement_heatmap_data(paper_data, threshold = 0.8)
  if (nrow(paper_agreement_df) > 0) {
    p_agree <- make_heatmap_plot(
      heatmap_df   = paper_agreement_df,
      fill_name    = "Agreement",
      title_str    = paste0("Agreement with Human Annotations — ", paper_lbl),
      subtitle_str = paste0(metric_nm, ". Tags < 10 positive cases excluded.",
                            " Bold border = agreement >= 0.80."),
      threshold    = 0.8
    )
    save_plot(p_agree,
              paste0("figure1_agreement_heatmap_", paper_nm),
              width = 11, height = 4)
  }

  # Macro F1
  paper_f1_df <- build_heatmap_data(paper_data, "macro_f1", threshold = 0.8)
  if (nrow(paper_f1_df) > 0) {
    p_f1_p <- make_heatmap_plot(
      heatmap_df   = paper_f1_df,
      fill_name    = "Macro F1",
      title_str    = paste0("Macro F1 — ", paper_lbl),
      subtitle_str = paste0("Average Macro F1 across tags with >= 10 positive cases.",
                            " Bold border = Macro F1 >= 0.80."),
      threshold    = 0.8
    )
    save_plot(p_f1_p,
              paste0("figure2_macro_f1_heatmap_", paper_nm),
              width = 11, height = 4)
  }
}
message("Per-paper figures saved in: ", output_dir)
