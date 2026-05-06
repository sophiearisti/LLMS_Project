# Application 1 Implementation Plan — Brandts & Cooper (2025)

Generated: 2026-05-04. Implement manually in two steps.

---

## Background data (do not re-derive)

**Dataset**: 133 conversations × 15 labels; multi-label binary; coded at conversation level.

**Tag evaluability** (based on positive counts in `real_answers.csv`):

| Tag               | Positives | Status        |
|-------------------|-----------|---------------|
| any_suggestion    | 125       | evaluable     |
| agree_proposal    | 97        | evaluable     |
| neither_report    | 88        | evaluable     |
| suggest_safe      | 80        | evaluable     |
| suggest_efficient | 63        | evaluable     |
| discuss_fairness  | 54        | evaluable     |
| discuss_efficient | 54        | evaluable     |
| receive_report    | 45        | evaluable     |
| truthful          | 45        | evaluable     |
| explanation       | 27        | evaluable     |
| ask_game          | 17        | evaluable     |
| discuss_rules     | 13        | evaluable     |
| discuss_howtoplay | 9         | RARE (<10)    |
| suggest_safe      | 80        | evaluable     |
| falsehood         | 0         | UNEVALUABLE   |
| contradict        | 0         | UNEVALUABLE   |

→ **12 evaluable tags** (≥10 positives); 1 rare; 2 unevaluable.

**Best-config Krippendorff α per tag per LLM** (maximum across all shot × temperature combos):

| Tag               | Claude | Gemini | GPT    | Human α |
|-------------------|--------|--------|--------|---------|
| suggest_safe      | 0.604  | 0.569  | 0.788  | 0.949   |
| truthful          | 0.603  | 0.549  | 0.126  | 0.925   |
| agree_proposal    | 0.571  | 0.587  | 0.781  | 0.715   |
| receive_report    | 0.556  | 0.489  | 0.092  | 0.924   |
| suggest_efficient | 0.552  | 0.512  | 0.761  | 0.951   |
| discuss_efficient | 0.544  | 0.519  | 0.616  | 0.704   |
| neither_report    | 0.499  | 0.462  | 0.092  | 0.943   |
| any_suggestion    | 0.448  | 0.516  | 0.658  | 0.881   |
| ask_game          | 0.445  | 0.495  | 0.551  | 0.904   |
| discuss_rules     | 0.266  | 0.275  | 0.481  | 0.442   |
| discuss_fairness  | 0.240  | 0.238  | 0.242  | 0.465   |
| explanation       | 0.076  | 0.078  | -0.093 | 0.239   |
| contradict        | 0.000  | -0.013 | 0.000  | 0.845   |
| falsehood         | -0.003 | NaN    | 0.000  | 0.831   |

**Mean α across evaluable tags (averaged across all temperatures):**

| LLM    | 0-shot | Few-shot | Best config                  |
|--------|--------|----------|------------------------------|
| Claude | 0.360  | 0.356    | 0.380 (0-shot, T = 0.1)      |
| Gemini | 0.299  | 0.359    | 0.375 (few-shot, T = 0)      |
| GPT    | 0.239  | 0.289    | 0.318 (few-shot, T = 0)      |

---

## Step 1 — Add dot plot to `Graphs.R`

**File**: `LLMS_analysis/Graphs/Graphs.R`

**Where to insert**: Append the following block at the very end of the file, after the
`message("Done. Figures saved in numbered subfolders.")` line.

**What it produces**:
`Graphs/1/dotplot_best_config_managerial_leadership_Jordi_Cooper.pdf`
`Graphs/1/dotplot_best_config_managerial_leadership_Jordi_Cooper.png`

**R code to append**:

```r
# ─────────────────────────────────────────────────────────────────────────────
# Dot plot: best-config Krippendorff alpha per tag × model — Paper 1 only
#   Y-axis : tags in canonical fixed order (bottom = any_suggestion, top = neither_report)
#   X-axis : Krippendorff alpha
#   Points : best configuration (max alpha) per tag × model
#   Segment: per-tag human alpha as a grey reference mark
#   Vline  : alpha = 0.80
# ─────────────────────────────────────────────────────────────────────────────

# Canonical order for Paper 1 (bottom-to-top)
LABELS_P1 <- irr_floor_p1$tag   # already defined earlier in the script

model_colors <- c(
  "GPT"    = "#003f5c",
  "Gemini" = "#bc5090",
  "Claude" = "#ff6361"
)

# Best alpha per tag × model (max over all shot × temperature combinations)
p1_best <- results_df %>%
  filter(paper == 1, tag != "GLOBAL", !is.na(krippendorff_alpha)) %>%
  mutate(model = llm_labels[llm]) %>%
  group_by(tag, model) %>%
  summarise(alpha = max(krippendorff_alpha, na.rm = TRUE), .groups = "drop") %>%
  mutate(tag = factor(tag, levels = LABELS_P1))

# Human IRR reference
human_ref <- irr_floor_p1 %>%
  mutate(tag = factor(tag, levels = LABELS_P1))

if (nrow(p1_best) > 0) {

  p_dot <- ggplot(p1_best, aes(x = alpha, y = tag, colour = model)) +
    # Human alpha reference segments (grey, drawn first so dots sit on top)
    geom_segment(
      data = human_ref,
      aes(x = human_alpha, xend = human_alpha, y = as.numeric(tag) - 0.4,
          yend = as.numeric(tag) + 0.4),
      colour = "grey65", linewidth = 0.7,
      inherit.aes = FALSE
    ) +
    # Reference line at alpha = 0.80
    geom_vline(xintercept = 0.80, linetype = "dashed",
               colour = "grey40", linewidth = 0.4) +
    # Model dots
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
    annotate("text", x = 0.95, y = 1,
             label = "Human α", hjust = 0.5, vjust = -0.5,
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
```

**How to run**: Open `Graphs/Graphs.R` in R/RStudio and source the whole file, or run:
```
Rscript "LLMS_analysis/Graphs/Graphs.R"
```

---

## Step 2 — Rewrite the Application 1 section in `main_manuscript.tex`

**File**: `LLMS_analysis/main_manuscript.tex`

### 2a. Replace the validation metrics subsubsection

Find and replace the current `\subsubsection{Application 1: validation metrics}` block
(lines 330–367 approximately) with the following:

```latex
\subsubsection{Application 1: validation metrics}

Before evaluating LLM performance, we partition the 15 categories by their
prevalence in the evaluation sample. Two categories—\textit{falsehood} and
\textit{contradict}—have no positive cases, making agreement statistics
undefined; we exclude them from all analysis.\footnote{The absence of
falsehood and contradict in our sample reflects the structure of the
treatments we evaluate, which focus on free-form chat with delegation and
managerial control. These categories may be more prevalent in other
treatment arms.} One additional category—\textit{discuss\_howtoplay}—has
only 9 positive cases, below the threshold of 10 we require for reliable
estimation; we report it in the appendix but exclude it from main
conclusions. This leaves 12 evaluable categories.

Figure~\ref{fig:alpha_Jordi} reports the human inter-rater reliability
(Krippendorff's $\alpha$) for each category. The evaluable categories fall
into two groups. Eight are \textit{behaviorally concrete}: they capture
whether agents make or agree to specific proposals, ask about the game
state, or truthfully report private information, and human coders agree
strongly on these ($\alpha \geq 0.70$). Four are \textit{interpretively
ambiguous}: they concern the general topic of conversation (fairness,
efficiency, rules) or require inferring communicative intent
(\textit{explanation}), and human coders agree less ($\alpha$ ranging from
0.24 to 0.47). This distinction is important because LLMs cannot be
expected to systematically outperform human inter-rater agreement; the
human $\alpha$ ceiling is the relevant per-category benchmark.

Figure~\ref{fig:agreement_Jordi} summarizes mean agreement across
evaluable categories for each model and configuration. Averaged across the
12 evaluable tags, Claude achieves the highest mean $\alpha$ (0.38 at its
best configuration: zero-shot, $T = 0.1$), followed closely by Gemini
(0.37, few-shot, $T = 0$) and GPT (0.32, few-shot, $T = 0$). Few-shot
prompting substantially improves agreement for Gemini ($+0.06$ relative to
zero-shot) and GPT ($+0.05$), but leaves Claude essentially unchanged,
suggesting that Claude's zero-shot performance is already near its ceiling
for this task. Temperature variation within each prompting strategy has
modest effects (range $< 0.05$ across models), indicating that results are
robust to decoding temperature.

Figure~\ref{fig:dotplot_Jordi} shows the best-configuration $\alpha$ per
category for each model, together with the per-category human $\alpha$ as
a reference. Performance is heterogeneous across categories in a pattern
that closely mirrors the human IRR structure. Categories where agents make
concrete proposals or report factual outcomes—\textit{suggest\_safe},
\textit{truthful}, \textit{agree\_proposal}, \textit{receive\_report},
\textit{suggest\_efficient}, \textit{discuss\_efficient},
\textit{neither\_report}—reach $\alpha \geq 0.45$ under the best-
performing model. Categories that require detecting general communicative
acts without unambiguous surface markers—\textit{any\_suggestion},
\textit{ask\_game}, \textit{discuss\_rules}, \textit{discuss\_fairness}—
yield moderate agreement (best-model $\alpha$ between 0.24 and 0.66). The
category \textit{explanation} yields near-zero agreement across all models
($\alpha < 0.10$), but this is also the category with the lowest human IRR
($\alpha = 0.24$), suggesting the difficulty is not specific to LLMs.

A notable cross-category pattern emerges: per-tag LLM agreement tracks
per-tag human inter-rater agreement. Categories where human coders
themselves disagree tend to show the lowest LLM performance. This
correspondence implies that LLM coding difficulty partially reflects
inherent definitional ambiguity—the same sources that make categories hard
for human coders also make them hard for LLMs. It also means that
near-zero LLM $\alpha$ on categories such as \textit{explanation} should
not be interpreted as a model failure in isolation, but rather as evidence
that these categories are difficult to operationalize regardless of the
coder.
```

### 2b. Replace the three figure references inside that block

The old figures referenced:
- `1_Figures/krippendorff_alpha_plot.pdf` → **keep as-is** (fig:alpha_Jordi)
- `1_Figures/figure1_heatmap_best_config_managerial_leadership_Jordi_Cooper.pdf` → **replace**
- `1_Figures/figure2_temperature_sensitivity_managerial_leadership_Jordi_Cooper.pdf` → **remove**

Replace the two old figure environments with these three:

```latex
\begin{figure}[htbp]
    \caption{Human inter-rater reliability per category (Krippendorff's $\alpha$)}
    \label{fig:alpha_Jordi}
    \centering
    \includegraphics[width=0.9\textwidth]{1_Figures/krippendorff_alpha_plot.pdf}
    \footnotesize
    \textit{Note:} Computed from three independent human coders on 133 conversations.
    Green = strong agreement ($\alpha \geq 0.80$); orange = tentative (0.67--0.80);
    red = unreliable ($< 0.67$).
\end{figure}

\begin{figure}[htbp]
    \caption{Best-configuration Krippendorff's $\alpha$ per category and model ---
             \citet{brandts_cooper_2025}}
    \label{fig:dotplot_Jordi}
    \centering
    \includegraphics[width=0.9\textwidth]{1_Figures/dotplot_best_config_managerial_leadership_Jordi_Cooper.pdf}
    \footnotesize
    \textit{Note:} Each point is the maximum $\alpha$ for that model across all
    shot $\times$ temperature combinations. Grey vertical bars indicate the
    per-category human inter-rater $\alpha$. Dashed line marks $\alpha = 0.80$.
    Categories with zero positive cases (\textit{falsehood}, \textit{contradict})
    and with fewer than 10 positives (\textit{discuss\_howtoplay}) are omitted.
\end{figure}

\begin{figure}[htbp]
    \caption{Agreement with human annotations: model $\times$ configuration heatmap ---
             \citet{brandts_cooper_2025}}
    \label{fig:agreement_Jordi}
    \centering
    \includegraphics[width=0.9\textwidth]{1_Figures/figure1_agreement_heatmap_managerial_leadership_Jordi_Cooper.pdf}
    \footnotesize
    \textit{Note:} Cells report mean Krippendorff's $\alpha$ (3 human coders + LLM)
    averaged across the 12 evaluable categories ($\geq 10$ positive cases).
    Bold border indicates mean $\alpha \geq 0.80$.
    Configuration labels: shot@temperature (e.g.\ \texttt{fewshot@0} = few-shot, $T = 0$).
\end{figure}
```

### 2c. Copy the new figure files to 1_Figures/

The manuscript references figures from `1_Figures/`. You need to copy:

```
From: LLMS_analysis/Graphs/1/dotplot_best_config_managerial_leadership_Jordi_Cooper.pdf
To:   LLMS_analysis/1_Figures/dotplot_best_config_managerial_leadership_Jordi_Cooper.pdf

From: LLMS_analysis/Graphs/paper_ready/figure1_agreement_heatmap_managerial_leadership_Jordi_Cooper.pdf
To:   LLMS_analysis/1_Figures/figure1_agreement_heatmap_managerial_leadership_Jordi_Cooper.pdf
```

Also keep the existing file already in 1_Figures/:
```
LLMS_analysis/1_Figures/krippendorff_alpha_plot.pdf   (already there from IRR analysis)
```

### 2d. Leave substantive validity as a TODO

The `\subsubsection{Application 1: substantive validity}` block requires linking
conversation-level labels to treatment conditions (CH-MC, CH/S-D, etc.) from the original
replication package in `remake/managerial_leadership_Jordi_Cooper/`. This is a separate
analysis task. For now, keep a placeholder:

```latex
\subsubsection{Application 1: substantive validity}

\textcolor{red}{TODO: Link LLM and human labels to treatment conditions from the
replication package and test whether treatment contrasts and behavioral correlations
are preserved under LLM coding.}
```

---

## Reviewer-lens checklist

Before submitting the section, verify:

- [ ] `falsehood` and `contradict` are explicitly excluded with a footnote explaining why
- [ ] Human IRR figure appears before the LLM results figures (it establishes the ceiling)
- [ ] The per-category human $\alpha$ reference marks are visible in the dot plot
- [ ] The text never claims LLM $\alpha = 0$ is a "failure" without noting the human IRR
- [ ] Temperature robustness is stated in text, not shown in a separate figure (main text)
- [ ] Few-shot vs. zero-shot difference is reported as a secondary practical finding
- [ ] Substantive validity section has a clear TODO (no false claims of completeness)
