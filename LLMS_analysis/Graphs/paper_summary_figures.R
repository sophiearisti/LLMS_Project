library(readr)
library(dplyr)
library(ggplot2)

# Paper-ready Cohen kappa heatmap:
# 1) Heatmap of average Cohen kappa by model and configuration
# 2) Tags with fewer than 10 positive cases are excluded
# 3) Outputs are saved as both PDF and PNG

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
  "trust_promises_Ederer_Schneider" = "Ederer and Schneider (2022)",
  "under_reporting_Ling_Kale_Imas" = "Ling et al. (2025)"
)

llm_labels <- c(
  "gpt" = "GPT",
  "gemini" = "Gemini",
  "claude" = "Claude"
)

shot_levels <- c("0shot", "fewshot")
temperature_levels <- c(0, 0.1, 0.5, 1, 1.2)
config_levels <- as.vector(outer(shot_levels, temperature_levels, paste, sep = "@"))

theme_heatmap <- function() {
  theme_minimal(base_size = 11) +
    theme(
      plot.title = element_text(size = 12, face = "bold", margin = margin(b = 6)),
      plot.subtitle = element_text(size = 10, color = "grey40", margin = margin(b = 8)),
      axis.title.x = element_text(size = 10, margin = margin(t = 6)),
      axis.title.y = element_text(size = 10, margin = margin(r = 6)),
      axis.text = element_text(size = 9, color = "grey30"),
      panel.grid = element_blank(),
      strip.text = element_text(size = 10, face = "bold"),
      legend.title = element_text(size = 9, face = "bold"),
      legend.text = element_text(size = 9),
      plot.margin = margin(8, 12, 8, 8)
    )
}

normalize_labels <- function(values) {
  values_chr <- as.character(values)
  values_chr[is.na(values)] <- "nan"
  values_chr <- tolower(trimws(values_chr))
  sub("\\.0$", "", values_chr)
}

# Resolve paths relative to this script's directory.
script_args <- commandArgs(trailingOnly = FALSE)
script_flag <- "--file="
script_path <- sub(script_flag, "", script_args[grep(script_flag, script_args)])
script_dir <- if (length(script_path) > 0) dirname(normalizePath(script_path)) else getwd()

results_dir <- normalizePath(file.path(script_dir, "..", "Results"), winslash = "/", mustWork = FALSE)
data_dir <- normalizePath(file.path(script_dir, "..", "Data"), winslash = "/", mustWork = FALSE)
output_dir <- file.path(script_dir, "paper_ready")

if (!dir.exists(results_dir)) {
  stop("Results directory not found. Expected: ", results_dir)
}

if (!dir.exists(data_dir)) {
  stop("Data directory not found. Expected: ", data_dir)
}

dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

csv_paths <- list.files(
  path = results_dir,
  pattern = "^results_paper_.*\\.csv$",
  recursive = TRUE,
  full.names = TRUE
)

if (length(csv_paths) == 0) {
  stop("No results CSV files found under: ", results_dir)
}

parse_meta <- function(path) {
  path_norm <- gsub("\\\\", "/", path)
  rel <- sub(paste0("^", gsub("([.|(){}+^$?*\\[\\]\\\\])", "\\\\\\1", results_dir), "/"), "", path_norm)
  parts <- strsplit(rel, "/")[[1]]
  file_name <- basename(path_norm)

  temp_match <- regmatches(file_name, regexpr("_temp[0-9.]+", file_name))
  temp_value <- as.numeric(sub("_temp", "", temp_match))

  shot_match <- regmatches(file_name, regexpr("_type(0shot|fewshot)", file_name))
  shot_value <- sub("_type", "", shot_match)

  data.frame(
    llm = ifelse(length(parts) >= 1, parts[1], NA_character_),
    paper_name = ifelse(length(parts) >= 2, parts[2], NA_character_),
    shot = shot_value,
    temperature = temp_value,
    stringsAsFactors = FALSE
  )
}

all_data <- vector("list", length(csv_paths))

for (i in seq_along(csv_paths)) {
  p <- csv_paths[i]
  meta <- parse_meta(p)
  df <- read_csv(p, show_col_types = FALSE)

  if (!("cohen_kappa" %in% names(df)) && ("kappa" %in% names(df))) {
    df <- df %>% mutate(cohen_kappa = kappa)
  }

  if (!("cohen_kappa" %in% names(df))) {
    warning("Skipping file missing cohen_kappa: ", p)
    next
  }

  df <- df %>%
    mutate(
      llm = meta$llm,
      paper_name = meta$paper_name,
      shot = meta$shot,
      temperature = meta$temperature
    )

  all_data[[i]] <- df
}

results_df <- bind_rows(all_data)

if (nrow(results_df) == 0) {
  stop("No valid rows after loading files.")
}

results_df <- results_df %>%
  filter(
    llm %in% c("gpt", "gemini", "claude"),
    shot %in% shot_levels,
    paper_name %in% papers$paper_name
  )

compute_positive_counts <- function(paper_nm, available_tags) {
  truth_path <- file.path(data_dir, paper_nm, "real_answers.csv")

  if (!file.exists(truth_path)) {
    warning("Ground-truth file not found for positive-count filtering: ", truth_path)
    return(data.frame(
      paper_name = character(),
      tag = character(),
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
      tag = tag_name,
      positive_n = sum(normalized == "1", na.rm = TRUE),
      stringsAsFactors = FALSE
    )
  }))
}

positive_counts <- bind_rows(lapply(papers$paper_name, function(paper_nm) {
  available_tags <- unique(results_df$tag[results_df$paper_name == paper_nm])
  compute_positive_counts(paper_nm, available_tags)
}))

heatmap_df <- results_df %>%
  left_join(positive_counts, by = c("paper_name", "tag")) %>%
  filter(!is.na(positive_n), positive_n >= 10) %>%
  group_by(paper_name, llm, shot, temperature) %>%
  summarise(
    mean_kappa = mean(cohen_kappa, na.rm = TRUE),
    evaluable_tag_n = n_distinct(tag),
    .groups = "drop"
  ) %>%
  mutate(
    config = paste0(shot, "@", temperature),
    config = factor(config, levels = config_levels),
    llm = factor(llm, levels = c("gpt", "gemini", "claude"))
  )

if (nrow(heatmap_df) == 0) {
  stop("No heatmap rows remain after applying the positive-case filter.")
}

heatmap_df <- heatmap_df %>%
  mutate(
    label = paste0(sprintf("%.2f", mean_kappa), "\nN=", evaluable_tag_n),
    highlight = mean_kappa >= 0.8
  )

p_heatmap <- ggplot(heatmap_df, aes(x = config, y = llm, fill = mean_kappa)) +
  geom_tile(color = "white", linewidth = 0.4) +
  geom_tile(
    data = heatmap_df %>% filter(highlight),
    fill = NA,
    color = "#111111",
    linewidth = 0.9
  ) +
  geom_text(aes(label = label), size = 3, lineheight = 0.9) +
  facet_wrap(~paper_name, ncol = 1, labeller = as_labeller(paper_labels)) +
  scale_x_discrete(drop = FALSE) +
  scale_y_discrete(labels = llm_labels, drop = FALSE) +
  scale_fill_gradientn(
    colors = c("#b2182b", "#f4a582", "#f7f7f7", "#92c5de", "#2166ac"),
    values = scales::rescale(c(0, 0.6, 0.7, 0.8, 1)),
    limits = c(0, 1),
    breaks = c(0, 0.6, 0.8, 1),
    labels = c("0.00", "0.60", "0.80", "1.00"),
    name = "Cohen Kappa"
  ) +
  labs(
    title = "LLM Coding Agreement Across Papers and Configurations",
    subtitle = "Cells show average Cohen kappa across tags with at least 10 positive cases; bold border marks kappa >= 0.80",
    x = "Configuration (shot@temperature)",
    y = "Model"
  ) +
  theme_heatmap() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))

ggsave(
  filename = file.path(output_dir, "figure1_cohen_kappa_heatmap_by_paper.pdf"),
  plot = p_heatmap,
  width = 11,
  height = 8.5
)

ggsave(
  filename = file.path(output_dir, "figure1_cohen_kappa_heatmap_by_paper.png"),
  plot = p_heatmap,
  width = 11,
  height = 8.5,
  dpi = 300
)

message("Done. Outputs written to: ", output_dir)
message(" - figure1_cohen_kappa_heatmap_by_paper.pdf")
message(" - figure1_cohen_kappa_heatmap_by_paper.png")
