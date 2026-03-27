# LLMS Text Classification Analysis

A comprehensive framework for text classification using multiple Large Language Models (LLMs). This tool supports ChatGPT, Gemini, and Claude with various prompting strategies and processing modes.

## Overview

This project orchestrates LLM-based text classification across multiple papers with support for:
- **Multiple LLMs**: ChatGPT, Gemini, and Claude
- **Prompting Strategies**: Zero-Shot, Few-Shot, Zero-Shot Chain-of-Thought, Few-Shot Chain-of-Thought
- **Processing Modes**: Line-by-line, Group-based, Batch API (Claude only)
- **Cost Optimization**: Prompt caching and parallel batch processing for Claude
- **Resumable Execution**: Checkpoint-based progress tracking

## Project Structure

```
LLMS_analysis/
├── Code/                    # Python scripts for LLM orchestration
│   ├── text_llms.py        # Main classification pipeline
│   ├── utils.py            # Utility functions (file paths, API keys)
│   ├── metrics_analysis.py # Results analysis and metrics
│   └── changeClassification.py
├── Data/                    # Input CSV files by paper
│   ├── directores/
│   ├── managerial_leadership_Jordi_Cooper/
│   ├── strategic_environment_Ozkes_Hanaki/
│   ├── trust_promises_Ederer_Schneider/
│   └── under_reporting_Ling_Kale_Imas/
├── prompts/                 # LLM prompt templates
│   ├── {paper_name}/
│   │   ├── classificationTask.txt
│   │   ├── context.txt
│   │   ├── 0shotCoT.txt
│   │   ├── fewShot.txt
│   │   └── ...
├── Results/                 # Output classification results
│   ├── gpt/
│   ├── gemini/
│   └── claude/
└── Graphs/                  # Visualization outputs
```

## Setup

### 1. Environment Variables

Create a `.env` file in the `Code/` directory with your API keys:

```env
OAI_2=your-openai-api-key
GEMINI=your-google-gemini-api-key
CLAUDE=your-anthropic-claude-api-key
```

### 2. Python Dependencies

Install required packages:

```bash
pip install anthropic langchain-openai google-generativeai pandas tqdm
```

### 3. File Configuration

Edit `utils.py` to configure:
- Paper folder paths (FIRST_PAPER, SECOND_PAPER, etc.)
- Data paths
- Prompt paths
- Results directory paths

## Usage

### Running the Main Pipeline

```bash
cd LLMS_analysis/Code
python text_llms.py
```

### Menu Navigation

The interactive menu provides options to:

1. **Select a Paper** (1-4)
   - Choose which paper's data to classify

2. **Select LLM**
   - **ChatGPT**: Models: gpt-5.2, gpt-5.1, gpt-5-mini, gpt-4o
   - **Gemini**: Models: gemini-3.1-pro-preview, gemini-3-flash-preview, etc.
   - **Claude**: Models: claude-opus-4-6, claude-sonnet-4-6, claude-haiku-4-5

3. **Create Categories** (optional)
   - Generates classification categories for the selected paper using the chosen LLM

4. **Select Assignment Strategy**
   - **Zero-Shot**: Direct classification without examples
   - **Few-Shot**: Classification with provided examples
   - **Zero-Shot CoT**: Chain-of-thought reasoning without examples
   - **Few-Shot CoT**: Chain-of-thought reasoning with examples

### Processing Modes

#### Line-by-Line (Mode: 1)
- Classifies each message individually
- Best for: Precise per-message classification
- Gemini uses parallel workers (20 concurrent)
- Claude and ChatGPT process sequentially
- Features: Prompt caching for Claude, progress tracking with tqdm

#### Group Mode (Mode: 2)
- Classifies groups of messages together
- Best for: Context-aware classification when messages relate to each other
- Requires group size input (e.g., 2,5,10)
- Supported by all three LLMs

#### Batch API Mode (Mode: 3, Claude Only)
- Submits all messages at once via Anthropic's Batch API
- Best for: Cost-efficient processing of large datasets
- Features:
  - Automatic polling every 30 seconds
  - Resumable execution (checkpoint-based)
  - Prompt caching on system message
  - ~50% reduction in input token costs
  - Automatic result streaming

### Temperature Selection

Choose one or all temperatures:
- `0`: Deterministic (most consistent)
- `0.1`: Nearly deterministic
- `0.5`: Moderate variation
- `1.0`: Standard randomness
- `1.2`: High variation

## Output Files

Classification results are saved in `Results/{llm}/{paper_name}/{strategy}/`:

```
results_line_temp{T}_mode{mode}.csv     # Line-by-line mode
results_group_temp{T}_mode{mode}.csv    # Group mode
results_line_batch_temp{T}_mode{mode}.csv # Claude batch mode
```

Each result file contains:
- All extracted classification fields (as dictionary keys)
- `original_message`: The input message/text
- `row_id`: The original row index (for line/batch modes)
- `group_id`: The group index (for group mode)

## Features

### Prompt Caching (Claude)
- Caches the base prompt across all requests
- Reduces input token costs by ~25%
- Automatically applied to system messages with `cache_control: {"type": "ephemeral"}`

### Batch API (Claude)
- Processes multiple messages in a single API call
- Reduces per-message overhead (~50% cost savings)
- Polls with 30-second intervals
- Automatically resumes from checkpoints

### Checkpointing
- All modes track processed rows/groups
- Resume interrupted runs without reprocessing
- Row/group IDs tracked in output CSV

### Error Handling
- Keyboard interrupt (Ctrl+C) saves progress automatically
- Failed requests logged with row information
- Graceful fallback if API keys missing

## Model Recommendations

| Use Case | Recommended Model |
|----------|------------------|
| **Category Generation** | Claude Opus (claude-opus-4-6) |
| **Classification - Speed** | Claude Haiku (claude-haiku-4-5) or Gemini Flash |
| **Classification - Quality** | Claude Sonnet (claude-sonnet-4-6) |
| **Cost-Optimized Batch** | Claude Sonnet + Batch API |
| **Parallel Processing** | Gemini (20 workers) |

## Advanced: Metrics Analysis

After classification, analyze results:

```bash
python metrics_analysis.py
```

This generates metrics and visualizations for:
- Classification distribution
- Agreement between LLMs
- Performance by strategy
- Cost analysis

## Troubleshooting

### "Missing API key" Error
- Verify `.env` file exists in `Code/` directory
- Check key names match: `OAI_2`, `GEMINI`, `CLAUDE`

### Batch API Stuck on "processing"
- Check network connection
- Batch polling continues every 30 seconds
- Maximum wait typically 5-15 minutes depending on dataset size

### Memory Issues with Large Batches
- Reduce batch size by selecting fewer rows
- Process in smaller temperature groups
- Use group mode with smaller group sizes

### Classification Quality Issues
- Review prompt templates in `prompts/{paper}/`
- Try Few-Shot mode with representative examples
- Experiment with different temperatures
- Consider using higher-quality models (Opus for categories)

## Cost Estimation

Approximate costs per 1,000 messages:

| LLM | Line-Mode | Batch Mode | Notes |
|-----|-----------|-----------|-------|
| ChatGPT (gpt-4o) | $0.30-0.50 | N/A | Input: $15/M tokens |
| Gemini Pro | $0.10-0.20 | N/A | Input: $1.5/M tokens |
| Claude Sonnet | $0.20-0.30 | $0.10-0.15 | Batch: ~50% savings |
| Claude Opus | $0.50-0.70 | $0.25-0.35 | For categories only |

*Actual costs depend on prompt length and message complexity*

## Development Notes

- `text_llms.py`: Main orchestration logic (~900 lines)
- `utils.py`: Configuration and constants
- `call_llm_for_message()`: Core LLM call wrapper
- Polling interval for batch API: 30 seconds (configurable)
- Buffer size for CSV writing: 10 rows

## License

[Add your license information]

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review prompt templates in `prompts/{paper}/`
3. Verify API keys and data files
4. Check output CSV files for partial results
