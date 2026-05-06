library(readr)
library(dplyr)
library(ggplot2)
library(patchwork)

# ─────────────────────────────────────────────────────────────────────────────
# Study parameters
# ─────────────────────────────────────────────────────────────────────────────

papers <- data.frame(
  paper_number = c(1, 3, 4),
  paper_folder = c(
    "managerial_leadership_Jordi_Cooper",
    "trust_promises_Ederer_Schneider",
    "under_reporting_Ling_Kale_Imas"
  ),
  paper_label = c(
    "Brandts & Cooper (2025) \u2014 Managerial Leadership",
    "Ederer & Schneider (2022) \u2014 Trust and Promises",
    "Ling et al. (2025) \u2014 Under-reporting AI use"
  ),
  stringsAsFactors = FALSE
)

shot_types   <- c("0shot", "fewshot")
temperatures <- c(0, 0.1, 0.5, 1, 1.2)
llms         <- c("gpt", "gemini", "claude")

# Paper 1: Krippendorff alpha (4-rater: 3 humans + LLM)
# Others:  Cohen kappa (2-rater: majority-vote human vs. LLM)
AGREEMENT_METRIC_P1    <- "krippendorff_alpha"
AGREEMENT_METRIC_OTHER <- "cohen_kappa"

metric_labels <- c(
  "krippendorff_alpha" = "Krippendorff's \u03b1 (3 humans + LLM)",
  "cohen_kappa"        = "Cohen's \u03ba",
  "accuracy"           = "Accuracy",
  "macro_f1"           = "Macro F1",
  "precision_0"        = "Precision (class 0)",
  "recall_0"           = "Recall (class 0)",
  "precision_1"        = "Precision (class 1)",
  "recall_1"           = "Recall (class 1)"
)

llm_labels <- c(
  "gpt"    = "GPT",
  "gemini" = "Gemini",
  "claude" = "Claude"
)

# ─────────────────────────────────────────────────────────────────────────────
# Colour palette — perceptually ordered by temperature, colourblind-safe
# ─────────────────────────────────────────────────────────────────────────────

temp_colors <- c(
  "0"   = "#003f5c",
  "0.1" = "#58508d",
  "0.5" = "#bc5090",
  "1"   = "#ff6361",
  "1.2" = "#ffa600"
)

# ─────────────────────────────────────────────────────────────────────────────
# Theme — Healy principles:
#   Show the data; remove all non-data ink that does not earn its place.
#   Horizontal bars: no y-axis title needed (labels are self-explanatory).
#   Sparse horizontal grid lines to aid reading across bars.
#   No background fill, no bounding box.
# ─────────────────────────────────────────────────────────────────────────────

theme_llm <- function(base_size = 11) {
  theme_minimal(base_size = base_size) +
    theme(
      panel.background    = element_blank(),
      plot.background     = element_blank(),
      panel.border        = element_blank(),

      plot.title          = element_text(size = base_size + 1, face = "bold",
                                         hjust = 0, margin = margin(b = 5)),
      plot.subtitle       = element_text(size = base_size - 1, colour = "grey45",
                                         hjust = 0, margin = margin(b = 8)),
      plot.caption        = element_text(size = base_size - 2, colour = "grey55",
                                         hjust = 0, margin = margin(t = 6)),

      axis.title.x        = element_text(size = base_size - 1, margin = margin(t = 5)),
      axis.title.y        = element_blank(),
      axis.text.x         = element_text(size = base_size - 2, colour = "grey30"),
      axis.text.y         = element_text(size = base_size - 2, colour = "grey20"),
      axis.line.x         = element_line(colour = "grey70", linewidth = 0.35),
      axis.ticks.x        = element_line(colour = "grey70", linewidth = 0.35),
      axis.ticks.y        = element_blank(),

      panel.grid.major.x  = element_line(colour = "grey92", linewidth = 0.35),
      panel.grid.major.y  = element_blank(),
      panel.grid.minor    = element_blank(),

      legend.title        = element_text(size = base_size - 2, face = "bold"),
      legend.text         = element_text(size = base_size - 2),
      legend.key.size     = unit(0.45, "cm"),
      legend.position     = "right",
      legend.background   = element_blank(),

      strip.text          = element_text(size = base_size - 1, face = "bold",
                                         colour = "grey20"),
      strip.background    = element_blank(),

      plot.margin         = margin(8, 14, 8, 8)
    )
}

# ─────────────────────────────────────────────────────────────────────────────
# Human IRR floor for paper 1
# Source: IRR_analysis/irr_results/krippendorff_alpha.csv
# Used as a dashed reference line so readers can benchmark LLM vs. human IRR.
# ─────────────────────────────────────────────────────────────────────────────

irr_floor_p1 <- data.frame(
  tag         = c("any_suggestion","suggest_safe","suggest_efficient","agree_proposal",
                  "discuss_fairness","discuss_efficient","discuss_rules","explanation",
                  "discuss_howtoplay","ask_game","receive_report","truthful",
                  "falsehood","contradict","neither_report"),
  human_alpha = c(0.8814, 0.9488, 0.9506, 0.7152,
                  0.4653, 0.7035, 0.4420, 0.2386,
                  0.2727, 0.9045, 0.9242, 0.9248,
                  0.8313, 0.8448, 0.9428),
  stringsAsFactors = FALSE
)

mean_human_alpha <- mean(irr_floor_p1$human_alpha, na.rm = TRUE)

# ─────────────────────────────────────────────────────────────────────────────
# Load data
# ─────────────────────────────────────────────────────────────────────────────

setwd("C:/Users/danie/Dropbox/Javeriana/Proyecto LLMS text/LLMS_Project/LLMS_analysis/Results")

all_data <- list()

for (llm in llms) {
  for (i in seq_len(nrow(papers))) {
    for (shot in shot_types) {

      paper_num   <- papers$paper_number[i]
      paper_name  <- papers$paper_folder[i]
      folder_path <- file.path(llm, paper_name, shot)

      for (temp in temperatures) {
        file_name <- paste0(
          "results_paper_", paper_num,
          "_temp", temp,
          "_modeuser_type", shot, ".csv"
        )
        full_path <- file.path(folder_path, file_name)

        if (file.exists(full_path)) {
          df <- read_csv(full_path, show_col_types = FALSE, na = c("", "NA"))
          df <- df %>% mutate(
            llm         = llm,
            paper       = paper_num,
            shot        = shot,
            temperature = as.character(temp)
          )
          all_data[[length(all_data) + 1]] <- df
          cat("Loaded:", full_path, "\n")
        }
      }
    }
  }
}

results_df <- bind_rows(all_data)

# Route each paper to the correct agreement metric column
results_df <- results_df %>%
  mutate(
    agreement = case_when(
      paper == 1 ~ krippendorff_alpha,
      TRUE       ~ cohen_kappa
    ),
    agreement_label = if_else(
      paper == 1,
      metric_labels["krippendorff_alpha"],
      metric_labels["cohen_kappa"]
    )
  )

# ─────────────────────────────────────────────────────────────────────────────
# Panel builder
# ─────────────────────────────────────────────────────────────────────────────

make_panel <- function(data, shot_label, metric_col, axis_label,
                       ref_line = NULL, ref_label = NULL,
                       fixed_levels = NULL) {

  data <- data %>% filter(!is.na(tag), tag != "GLOBAL", !is.na(.data[[metric_col]]))

  if (nrow(data) == 0) {
    return(ggplot() +
             annotate("text", x = 0.5, y = 0.5, label = "No data", size = 4) +
             theme_void() + labs(title = shot_label))
  }

  if (!is.null(fixed_levels)) {
    data <- data %>% mutate(tag = factor(tag, levels = fixed_levels))
  } else {
    lvls <- data %>%
      group_by(tag) %>%
      summarise(m = mean(.data[[metric_col]], na.rm = TRUE), .groups = "drop") %>%
      arrange(m) %>%
      pull(tag)
    data <- data %>% mutate(tag = factor(tag, levels = lvls))
  }

  p <- ggplot(data,
              aes(x    = tag,
                  y    = .data[[metric_col]],
                  fill = factor(temperature,
                                levels = as.character(c(0, 0.1, 0.5, 1, 1.2))))) +
    geom_col(
      position = position_dodge(width = 0.75),
      width    = 0.7,
      na.rm    = TRUE
    ) +
    coord_flip() +
    scale_fill_manual(values = temp_colors, name = "Temperature") +
    scale_y_continuous(
      limits = c(NA, 1),
      breaks = seq(0, 1, 0.2),
      labels = function(x) sprintf("%.1f", x),
      expand = expansion(mult = c(0, 0.03))
    ) +
    labs(title = shot_label, x = NULL, y = axis_label) +
    theme_llm()

  if (!is.null(ref_line)) {
    p <- p +
      geom_hline(yintercept = ref_line,
                 linetype = "dashed", colour = "grey40", linewidth = 0.45) +
      annotate("text",
               x = -Inf, y = ref_line,
               label = ref_label,
               hjust = -0.05, vjust = -0.45,
               size = 2.8, colour = "grey40")
  }
  p
}

# ─────────────────────────────────────────────────────────────────────────────
# Generate and save figures
# ─────────────────────────────────────────────────────────────────────────────

setwd("C:/Users/danie/Dropbox/Javeriana/Proyecto LLMS text/LLMS_Project/LLMS_analysis/Graphs")

metrics_to_plot <- list(
  list(col = "agreement",   label_fn = function(p) unique(results_df$agreement_label[results_df$paper == p])[1]),
  list(col = "accuracy",    label_fn = function(p) metric_labels["accuracy"]),
  list(col = "macro_f1",    label_fn = function(p) metric_labels["macro_f1"]),
  list(col = "precision_1", label_fn = function(p) metric_labels["precision_1"]),
  list(col = "recall_1",    label_fn = function(p) metric_labels["recall_1"]),
  list(col = "precision_0", label_fn = function(p) metric_labels["precision_0"]),
  list(col = "recall_0",    label_fn = function(p) metric_labels["recall_0"])
)

for (llm_name in llms) {
  for (i in seq_len(nrow(papers))) {

    paper_num  <- papers$paper_number[i]
    paper_name <- papers$paper_folder[i]
    paper_lbl  <- papers$paper_label[i]

    dir.create(as.character(paper_num), showWarnings = FALSE)

    for (m in metrics_to_plot) {

      metric_col  <- m$col
      metric_name <- m$label_fn(paper_num)
      if (is.null(metric_name) || is.na(metric_name)) next

      df_0shot <- results_df %>%
        filter(llm == llm_name, shot == "0shot",  paper == paper_num)
      df_few   <- results_df %>%
        filter(llm == llm_name, shot == "fewshot", paper == paper_num)

      if (nrow(df_0shot) == 0 && nrow(df_few) == 0) next

      # Reference line: mean human alpha on paper 1 agreement panels
      use_ref   <- (paper_num == 1 && metric_col == "agreement")
      ref_line  <- if (use_ref) mean_human_alpha else NULL
      ref_label <- if (use_ref) sprintf("Mean human \u03b1 = %.2f", mean_human_alpha) else NULL

      fixed_lvls <- if (paper_num == 1) irr_floor_p1$tag else NULL

      p1 <- make_panel(df_0shot, "Zero-shot",  metric_col, metric_name, ref_line, ref_label, fixed_lvls)
      p2 <- make_panel(df_few,   "Few-shot",   metric_col, metric_name, ref_line, ref_label, fixed_lvls)

      caption_text <- if (use_ref)
        paste0("Agreement = Krippendorff\u2019s \u03b1 across 3 human coders + LLM.",
               " Dashed line = mean human-only \u03b1 from IRR analysis.")
      else NULL

      combined <- (p1 / p2) +
        plot_annotation(
          title   = paste0(metric_name, "  \u00b7  ",
                           llm_labels[llm_name], "  \u00b7  ", paper_lbl),
          caption = caption_text,
          theme   = theme(
            plot.title   = element_text(size = 13, face = "bold", hjust = 0),
            plot.caption = element_text(size = 8,  colour = "grey50", hjust = 0)
          )
        ) +
        plot_layout(guides = "collect") &
        theme(legend.position = "right")

      out_stub <- paste0(metric_col, "_", llm_name, "_", paper_name)

      ggsave(
        filename = file.path(as.character(paper_num), paste0(out_stub, ".pdf")),
        plot     = combined, width = 10, height = 8
      )
      ggsave(
        filename = file.path(as.character(paper_num), paste0(out_stub, ".png")),
        plot     = combined, width = 10, height = 8, dpi = 300
      )
      cat("Saved:", out_stub, "\n")
    }
  }
}

message("Done. Figures saved in numbered subfolders.")

# ─────────────────────────────────────────────────────────────────────────────
# Dot plot: best-config Krippendorff alpha per tag × model — Paper 1 only
#   Y-axis : tags in canonical fixed order
#   X-axis : Krippendorff alpha
#   Points : best configuration (max alpha) per tag × model
#   Segment: per-tag human alpha as a grey reference mark
#   Vline  : alpha = 0.80
# ─────────────────────────────────────────────────────────────────────────────

EXCLUDED_TAGS_P1 <- c("falsehood", "contradict", "discuss_howtoplay")
LABELS_P1 <- irr_floor_p1$tag[!irr_floor_p1$tag %in% EXCLUDED_TAGS_P1]

model_colors <- c(
  "GPT"    = "#003f5c",
  "Gemini" = "#bc5090",
  "Claude" = "#ff6361"
)

p1_best <- results_df %>%
  filter(paper == 1, tag != "GLOBAL", !is.na(krippendorff_alpha),
         !tag %in% EXCLUDED_TAGS_P1) %>%
  mutate(model = llm_labels[llm]) %>%
  group_by(tag, model) %>%
  summarise(alpha = max(krippendorff_alpha, na.rm = TRUE), .groups = "drop") %>%
  mutate(tag = factor(tag, levels = LABELS_P1))

human_ref <- irr_floor_p1 %>%
  filter(!tag %in% EXCLUDED_TAGS_P1) %>%
  mutate(tag = factor(tag, levels = LABELS_P1))

if (nrow(p1_best) > 0) {

  p_dot <- ggplot(p1_best, aes(x = alpha, y = tag, colour = model)) +
    geom_errorbarh(
      data = human_ref,
      aes(xmin = human_alpha, xmax = human_alpha, y = tag),
      height = 0.5, colour = "grey65", linewidth = 0.9,
      inherit.aes = FALSE
    ) +
    geom_vline(xintercept = 0.80, linetype = "dashed",
               colour = "grey40", linewidth = 0.4) +
    geom_point(size = 2.8, alpha = 0.9) +
    scale_colour_manual(values = model_colors, name = "Model") +
    scale_x_continuous(
      limits = c(-0.15, 1),
      breaks = c(0, 0.2, 0.4, 0.6, 0.8, 1.0),
      labels = function(x) sprintf("%.1f", x),
      expand = expansion(mult = c(0.02, 0.03))
    ) +
    annotate("text", x = 0.80, y = 0.5,
             label = "α = 0.80", hjust = -0.08, vjust = 0,
             size = 2.8, colour = "grey40") +
    annotate("text", x = 0.97, y = 1.5,
             label = "Human α", hjust = 0.5, vjust = -0.3,
             size = 2.6, colour = "grey55") +
    labs(
      title    = paste0("Best-configuration Krippendorff's α per category · ",
                        "Brandts & Cooper (2025)"),
      subtitle = paste0("Each point = maximum α for that model across all ",
                        "shot × temperature combinations.\n",
                        "Grey bars = human inter-rater α. ",
                        "Dashed line = α = 0.80."),
      x        = "Krippendorff's α (3 human coders + LLM)",
      y        = NULL
    ) +
    theme_llm()

  ggsave(
    filename = file.path("1", "dotplot_best_config_managerial_leadership_Jordi_Cooper.pdf"),
    plot = p_dot, width = 9, height = 6
  )
  ggsave(
    filename = file.path("1", "dotplot_best_config_managerial_leadership_Jordi_Cooper.png"),
    plot = p_dot, width = 9, height = 6, dpi = 300
  )
  cat("Saved: dotplot_best_config_managerial_leadership_Jordi_Cooper\n")
}

# ─────────────────────────────────────────────────────────────────────────────
# Dot plot: best-config Macro F1 per tag × model — Paper 1 only
#   Same layout as the alpha dot plot; no human reference (F1 is already the
#   LLM-vs-human comparison).
# ─────────────────────────────────────────────────────────────────────────────

p1_best_f1 <- results_df %>%
  filter(paper == 1, tag != "GLOBAL", !is.na(macro_f1),
         !tag %in% EXCLUDED_TAGS_P1) %>%
  mutate(model = llm_labels[llm]) %>%
  group_by(tag, model) %>%
  summarise(f1 = max(macro_f1, na.rm = TRUE), .groups = "drop") %>%
  mutate(tag = factor(tag, levels = LABELS_P1))

if (nrow(p1_best_f1) > 0) {

  p_dot_f1 <- ggplot(p1_best_f1, aes(x = f1, y = tag, colour = model)) +
    geom_vline(xintercept = 0.80, linetype = "dashed",
               colour = "grey40", linewidth = 0.4) +
    geom_point(size = 2.8, alpha = 0.9) +
    scale_colour_manual(values = model_colors, name = "Model") +
    scale_x_continuous(
      limits = c(0, 1),
      breaks = c(0, 0.2, 0.4, 0.6, 0.8, 1.0),
      labels = function(x) sprintf("%.1f", x),
      expand = expansion(mult = c(0.02, 0.03))
    ) +
    annotate("text", x = 0.80, y = 0.5,
             label = "F1 = 0.80", hjust = -0.08, vjust = 0,
             size = 2.8, colour = "grey40") +
    labs(
      title    = paste0("Best-configuration Macro F1 per category · ",
                        "Brandts & Cooper (2025)"),
      subtitle = paste0("Each point = maximum Macro F1 for that model across all ",
                        "shot × temperature combinations.\n",
                        "Dashed line = F1 = 0.80."),
      x        = "Macro F1",
      y        = NULL
    ) +
    theme_llm()

  ggsave(
    filename = file.path("1", "dotplot_f1_best_config_managerial_leadership_Jordi_Cooper.pdf"),
    plot = p_dot_f1, width = 9, height = 6
  )
  ggsave(
    filename = file.path("1", "dotplot_f1_best_config_managerial_leadership_Jordi_Cooper.png"),
    plot = p_dot_f1, width = 9, height = 6, dpi = 300
  )
  cat("Saved: dotplot_f1_best_config_managerial_leadership_Jordi_Cooper\n")
}
