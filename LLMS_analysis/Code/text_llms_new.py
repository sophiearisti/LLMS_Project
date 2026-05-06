import ast
from http import client
from langchain_openai import ChatOpenAI
import google.genai as genai
from google.genai import types
from tqdm import tqdm
from utils import *
import pandas as pd
import os
import sys
import time
import re
import json
from concurrent.futures import ThreadPoolExecutor, as_completed

try:
    import anthropic
except ImportError:
    anthropic = None

try:
    from openai import OpenAI
except ImportError:
    OpenAI = None

# Global dictionary
PAPER_PATHS = {
    1: FIRST_PAPER,
    2: SECOND_PAPER,
    3: THIRD_PAPER,
    4: FOURTH_PAPER
}

# Prompt folder override: keep evaluation/data paths stable, but read Paper 1 prompts from v2.
PROMPT_PAPER_PATHS = {
    1: "managerial_leadership_Jordi_Cooper_v2/",
    2: SECOND_PAPER,
    3: THIRD_PAPER,
    4: FOURTH_PAPER,
}

llm_chatgpt = None
llm_openai_batch = None

llm_gemini = None

llm_claude = None

GEMINI_CATEGORY_MODEL = "gemini-3.1-pro-preview"
GEMINI_CLASSIFY_MODEL = "gemini-3-flash-preview"
CLAUDE_CATEGORY_MODEL = "claude-opus-4-6"
GEMINI_WORKERS = 20
CLAUDE_MAX_TOKENS = 4096

# Selected models (updated at runtime via seleccionar_llm)
SELECTED_CHATGPT_MODEL = "gpt-5.4-mini"
SELECTED_GEMINI_MODEL = "gemini-3-flash-preview"
SELECTED_CLAUDE_MODEL = "claude-sonnet-4-6"
MIN_APPEND_KEY_OVERLAP = 0.90

EXPECTED_LABEL_KEYS = [
    "any_suggestion",
    "suggest_safe",
    "suggest_efficient",
    "agree_proposal",
    "discuss_coordinate",
    "discuss_fairness",
    "discuss_efficient",
    "discuss_rules",
    "explanation",
    "discuss_howtoplay",
    "ask_game",
    "receive_report",
    "truthful",
    "falsehood",
    "contradict",
    "neither_report",
]

LEGACY_KEY_ALIASES = {
    "discuss_coordinte": "discuss_coordinate",
    "discusscoordinate": "discuss_coordinate",
    "discusshowtoplay": "discuss_howtoplay",
}

def write_rows_to_csv(output_path, rows):
    if not rows:
        return

    file_exists = os.path.exists(output_path)
    pd.DataFrame(rows).to_csv(
        output_path,
        mode="a",
        header=not file_exists,
        index=False,
        encoding="utf-8"
    )


def normalize_message_for_match(text):
    text = str(text).strip().lower()
    text = text.replace("\r", " ").replace("\n", " ")
    text = re.sub(r"(^|/)\s*\d+\s*;\s*", r"\1", text)
    text = re.sub(r"\s*/\s*", " / ", text)
    text = re.sub(r"\s+", " ", text)
    return text.strip()


def _safe_int(value):
    try:
        return int(float(value))
    except Exception:
        return None


def load_existing_if_compatible(
    output_path,
    source_df,
    source_message_col,
    id_col="row_id",
    pred_message_col="original_message",
    min_overlap=MIN_APPEND_KEY_OVERLAP,
):
    """Return existing df if compatible with the current source dataframe.

    Compatibility is based on overlap of (row_id, normalized_message) keys.
    """
    if not os.path.exists(output_path):
        return None

    existing_df = pd.read_csv(output_path)
    if existing_df.empty:
        return existing_df

    required_cols = {id_col, pred_message_col}
    missing = [c for c in required_cols if c not in existing_df.columns]
    if missing:
        raise RuntimeError(
            f"Existing output file is not append-compatible ({missing} missing): {output_path}. "
            "Move, rename, or delete it before running classification."
        )

    source_keys = set()
    for idx, message in source_df[source_message_col].items():
        source_keys.add((_safe_int(idx), normalize_message_for_match(message)))

    existing_keys = set()
    for _, row in existing_df[[id_col, pred_message_col]].iterrows():
        row_id = _safe_int(row[id_col])
        if row_id is None:
            continue
        existing_keys.add((row_id, normalize_message_for_match(row[pred_message_col])))

    if not existing_keys:
        return existing_df

    overlap_count = len(source_keys & existing_keys)
    overlap_ratio = overlap_count / len(existing_keys)

    if overlap_ratio < min_overlap:
        raise RuntimeError(
            "Refusing to append into an incompatible results file. "
            f"Key overlap is {overlap_ratio:.1%} ({overlap_count}/{len(existing_keys)}), "
            f"required >= {min_overlap:.0%}. File: {output_path}"
        )

    return existing_df


def get_chatgpt_client():
    global llm_chatgpt
    if llm_chatgpt is None or llm_chatgpt.model_name != SELECTED_CHATGPT_MODEL:
        llm_chatgpt = ChatOpenAI(
            model=SELECTED_CHATGPT_MODEL,
            max_retries=1,
            api_key=OAI_2
        )
    return llm_chatgpt


def get_openai_batch_client():
    global llm_openai_batch
    if llm_openai_batch is None:
        if not OAI_2:
            raise ValueError("Missing OAI_2 API key. Set OAI_2 in your .env file.")
        if OpenAI is None:
            raise ImportError(
                "OpenAI SDK is not installed. Run 'pip install openai'."
            )
        llm_openai_batch = OpenAI(api_key=OAI_2)
    return llm_openai_batch


def get_gemini_client():
    global llm_gemini
    if llm_gemini is None:
        api_key = GEMINI or os.getenv("N020")
        if not api_key:
            raise ValueError("Missing GEMINI API key. Set GEMINI or N020 in your .env file.")
        llm_gemini = genai.Client(api_key=api_key)
    return llm_gemini


def get_claude_client():
    global llm_claude
    if llm_claude is None:
        if not CLAUDE:
            raise ValueError("Missing CLAUDE API key. Set CLAUDE in your .env file.")
        if anthropic is None:
            raise ImportError(
                "Anthropic SDK is not installed. Run 'pip install anthropic'."
            )
        llm_claude = anthropic.Anthropic(api_key=CLAUDE)
    return llm_claude


def extract_claude_text(response):
    """Extract text content from Claude response."""
    if hasattr(response, 'content') and response.content:
        text_blocks = []
        for block in response.content:
            if hasattr(block, 'type') and block.type == 'text':
                text_blocks.append(block.text)
        return "\\n".join(text_blocks) if text_blocks else ""
    return ""


def poll_batch_status(client, batch_id, poll_interval=30):
    """Poll batch status until completion."""
    while True:
        batch = client.messages.batches.retrieve(batch_id)
        counts = batch.request_counts
        print(f"[{batch.processing_status}] succeeded: {counts.succeeded} | errored: {counts.errored} | processing: {counts.processing}")
        if batch.processing_status == "ended":
            print("Batch finished.")
            return batch
        time.sleep(poll_interval)


def get_batch_status_file():
    """Return path to batch status tracker JSON."""
    status_file = os.path.join(RESULTS_PATH, "claude", "batch_status.json")
    os.makedirs(os.path.dirname(status_file), exist_ok=True)
    return status_file


def get_provider_batch_status_file(provider):
    """Return path to batch status tracker JSON for a provider."""
    status_file = os.path.join(RESULTS_PATH, provider, "batch_status.json")
    os.makedirs(os.path.dirname(status_file), exist_ok=True)
    return status_file


def load_batch_status():
    """Load in-progress batch IDs from tracker file."""
    status_file = get_batch_status_file()
    if os.path.exists(status_file):
        try:
            with open(status_file, 'r') as f:
                return json.load(f)
        except:
            return {}
    return {}


def save_batch_status(batches_dict):
    """Save batch status to tracker file."""
    status_file = get_batch_status_file()
    with open(status_file, 'w') as f:
        json.dump(batches_dict, f, indent=2)


def load_provider_batch_status(provider):
    """Load in-progress batch IDs from provider tracker file."""
    status_file = get_provider_batch_status_file(provider)
    if os.path.exists(status_file):
        try:
            with open(status_file, 'r') as f:
                return json.load(f)
        except Exception:
            return {}
    return {}


def save_provider_batch_status(provider, batches_dict):
    """Save provider batch status to tracker file."""
    status_file = get_provider_batch_status_file(provider)
    with open(status_file, 'w') as f:
        json.dump(batches_dict, f, indent=2)


def check_existing_batch(paper, strategy, temp):
    """Check if a batch is already in progress for this temp.
    Returns (batch_id, in_progress) or (None, False)."""
    batches = load_batch_status()
    key = f"{paper}_{strategy}_{temp}"
    if key in batches:
        batch_id = batches[key]["batch_id"]
        client = get_claude_client()
        batch = client.messages.batches.retrieve(batch_id)
        if batch.processing_status != "ended":
            print(f"Found in-progress batch for temp {temp}: {batch_id}")
            return batch_id, True
        else:
            # Batch finished, remove from tracker
            del batches[key]
            save_batch_status(batches)
            return None, False
    return None, False


def get_claude_temp_files(paper, strategy_folder, temp):
    """Return existing Claude result files for a paper/strategy/temp across modes."""
    base_dir = os.path.join(RESULTS_PATH, "claude", PAPER_PATHS[int(paper)], strategy_folder)
    candidates = [
        os.path.join(base_dir, f"results_line_temp{temp}_modeuser.csv"),
        os.path.join(base_dir, f"results_line_batch_temp{temp}_modeuser.csv"),
    ]
    return [p for p in candidates if os.path.exists(p)]


def get_processed_ids_from_files(file_paths):
    """Collect processed row_id values from multiple CSV files."""
    processed_ids = set()
    for file_path in file_paths:
        try:
            df_existing = pd.read_csv(file_path)
            if "row_id" in df_existing.columns:
                processed_ids.update(
                    [
                        _safe_int(v)
                        for v in df_existing["row_id"].dropna().tolist()
                        if _safe_int(v) is not None
                    ]
                )
        except Exception as e:
            print(f"⚠ Could not read existing file {file_path}: {e}")
    return processed_ids


def choose_batch_action_for_temp(temp, total_rows, processed_ids, existing_files):
    """Ask user whether to skip, continue, or rerun for this temperature."""
    processed_count = len(processed_ids)
    if processed_count == 0:
        return "continue"

    print(f"\nTemp {temp}: found {processed_count}/{total_rows} already processed rows.")
    print("Existing files:")
    for p in existing_files:
        print(f"- {p}")

    if processed_count >= total_rows:
        print("This temperature appears complete.")
        choice = input("Action: skip (s, recommended) or rerun (r)? ").strip().lower()
        if choice in ("r", "rerun"):
            return "rerun"
        return "skip"

    print("This temperature is partially processed.")
    choice = input("Action: continue pending (c, recommended), rerun (r), or skip (s)? ").strip().lower()
    if choice in ("r", "rerun"):
        return "rerun"
    if choice in ("s", "skip"):
        return "skip"
    return "continue"


def temp_to_id_token(temp):
    """Build a safe token for Anthropic custom_id (only [a-zA-Z0-9_-])."""
    return str(temp).replace(".", "p").replace("-", "m")


def build_classification_user_message(message, game=None):
    """Build the user message sent to classification APIs."""
    if game is not None:
        message_preamble = f"The actual game being played this period is: Game {game}\n\n"
    else:
        message_preamble = ""

    return (
        "Classify ONLY this message and return only a Python dictionary. "
        "Do not add explanations.\n\n" +
        message_preamble +
        f"Message:\n{message}"
    )


def get_provider_temp_files(provider, paper, strategy_folder, temp):
    """Return existing result files for a provider/paper/strategy/temp across modes."""
    base_dir = os.path.join(RESULTS_PATH, provider, PAPER_PATHS[int(paper)], strategy_folder)
    candidates = [
        os.path.join(base_dir, f"results_line_temp{temp}_modeuser.csv"),
        os.path.join(base_dir, f"results_line_batch_temp{temp}_modeuser.csv"),
    ]
    return [p for p in candidates if os.path.exists(p)]


def check_existing_openai_batch(paper, strategy, temp):
    """Check if an OpenAI batch is already in progress for this temp."""
    batches = load_provider_batch_status("gpt")
    key = f"{paper}_{strategy}_{temp}"
    if key in batches:
        batch_id = batches[key]["batch_id"]
        client = get_openai_batch_client()
        batch = client.batches.retrieve(batch_id)
        if batch.status not in ("completed", "failed", "expired", "cancelled"):
            print(f"Found in-progress GPT batch for temp {temp}: {batch_id}")
            return batch_id, True

        del batches[key]
        save_provider_batch_status("gpt", batches)
    return None, False


def get_openai_response_text(response_body):
    """Extract assistant text from /v1/chat/completions batch response body."""
    choices = response_body.get("choices", [])
    if not choices:
        return ""

    message = choices[0].get("message", {})
    content = message.get("content", "")

    if isinstance(content, str):
        return content

    if isinstance(content, list):
        text_parts = []
        for block in content:
            if isinstance(block, dict) and block.get("type") == "text":
                text_parts.append(block.get("text", ""))
        return "\n".join(text_parts)

    return str(content)


def get_openai_file_text(file_response):
    """Normalize OpenAI file content response to text."""
    text_attr = getattr(file_response, "text", None)
    if callable(text_attr):
        return text_attr()
    if isinstance(text_attr, str):
        return text_attr
    if hasattr(file_response, "read"):
        data = file_response.read()
        if isinstance(data, bytes):
            return data.decode("utf-8")
        return str(data)
    return str(file_response)


def normalize_temps_for_llm(temps, llm):
    """Ensure selected temperatures are valid for the target LLM."""
    if llm != "claude":
        return temps

    valid = [t for t in temps if 0 <= float(t) <= 1]
    dropped = [t for t in temps if not (0 <= float(t) <= 1)]

    if dropped:
        print(
            f"⚠ Claude supports temperature range 0..1. "
            f"Skipping invalid temperatures: {dropped}"
        )

    if not valid:
        print("⚠ No valid temperatures selected for Claude. Using [0].")
        return [0]

    return valid


def select_processing_mode(llm):
    """Prompt user to choose normal vs batch mode, with exit option."""
    while True:
        if llm in ("claude", "gpt", "chatgpt"):
            print("\n--- Select processing mode ---")
            print("1. Normal mode: read line by line")
            print("2. Batch mode (asynchronous, up to 24h, 50% cheaper)")
            print("0. Exit script")
            read_mode = input("Choose an option: ").strip()
            if read_mode in ("1", "2"):
                return read_mode
            if read_mode == "0":
                print("Exiting...")
                sys.exit()
            print("Invalid option.")
        else:
            print("\n--- Select processing mode ---")
            print("1. Normal mode: read line by line")
            print("0. Exit script")
            read_mode = input("Choose an option: ").strip()
            if read_mode == "1":
                return read_mode
            if read_mode == "0":
                print("Exiting...")
                sys.exit()
            print("Invalid option.")


def call_llm_for_message(base_prompt, message, temp, llm, mode="user", game=None):
    """
    CHANGE P0: Added optional 'game' parameter to inject game context.
    If game is provided, it's included in the message preamble.
    """
    user_prompt = build_classification_user_message(message, game)
    
    if llm == "gemini":
        gemini_client = get_gemini_client()
        full_prompt = (
            base_prompt +
            "\n\n" +
            user_prompt
        )
        response = gemini_client.models.generate_content(
            model=SELECTED_GEMINI_MODEL,
            contents=full_prompt,
            config=types.GenerateContentConfig(temperature=temp)
        )
        return response.text

    if llm == "claude":
        response = get_claude_client().messages.create(
            model=SELECTED_CLAUDE_MODEL,
            max_tokens=CLAUDE_MAX_TOKENS,
            temperature=temp,
            system=[
                {
                    "type": "text",
                    "text": base_prompt,
                    "cache_control": {"type": "ephemeral"},
                }
            ],
            messages=[
                {"role": "user", "content": user_prompt}
            ],
        )
        return extract_claude_text(response)

    if mode == "user":
        response = get_chatgpt_client().bind(temperature=temp).invoke([
            ("system", base_prompt),
            ("user", user_prompt)
        ])
    else:
        response = get_chatgpt_client().invoke_as_assistant(user_prompt, temperature=temp)

    return response.content

def parse_llm_dict(ans):

    try:
        start = ans.find("{")
        end   = ans.rfind("}") + 1
        raw_dict = ans[start:end]
        parsed = ast.literal_eval(raw_dict)

        if not isinstance(parsed, dict):
            return {"error": ans[:300]}

        # Normalize malformed keys (e.g., stray unicode prefixes) and legacy typos.
        canonical_to_expected = {
            re.sub(r"[^a-z_]", "", key.lower()): key for key in EXPECTED_LABEL_KEYS
        }

        normalized = {}
        for k, v in parsed.items():
            key = str(k).strip().lower()
            key = LEGACY_KEY_ALIASES.get(key, key)
            canonical = re.sub(r"[^a-z_]", "", key)
            expected_key = canonical_to_expected.get(canonical)
            if expected_key is not None:
                normalized[expected_key] = v

        # If we recognized label keys, make the output schema-complete to avoid NaNs.
        if normalized:
            complete = {key: 0 for key in EXPECTED_LABEL_KEYS}
            complete.update(normalized)
            return complete

        return {"error": ans[:300]}
    except:
        return {"error": ans[:300]}

def seleccionar_temperaturas():
    temperature_options = [0, 0.1, 0.5, 1, 1.2]

    while True:
        print("\n--- Select temperature(s) ---")
        for idx, value in enumerate(temperature_options, start=1):
            print(f"{idx}. {value}")
        print(f"{len(temperature_options) + 1}. All")

        option = input("Choose an option: ").strip()

        if option.isdigit():
            option_int = int(option)
            if 1 <= option_int <= len(temperature_options):
                return [temperature_options[option_int - 1]], False
            if option_int == len(temperature_options) + 1:
                return temperature_options, True

        print("Invalid option.")

def obtener_categorias_llm(prompt, paper, llm):  
    
    temps   = [0, 0.1, 0.5,  1, 1.2]
    temps   = normalize_temps_for_llm(temps, llm)
    modes   = ["user"] #, "assistant"]
    
    path = os.path.join(DATA_PATH, PAPER_PATHS[int(paper)], "classify.csv")
    df = pd.read_csv(path)
    
    # get all csv content and store as a string
    messages = df["message"].tolist()
    
    combined_messages = "\n".join(messages)
    full_prompt = (
        prompt +
        "\n\nThese are the messages you should analyze:\n" +
        combined_messages
    )

    for temp in temps:
        for mode in modes:

            print(f"\n--- Getting categories for Paper {paper} | Temp: {temp} | Mode: {mode} ---\n")
            
            # LLM CALL --------------------------------------
            
            if llm == "gemini":
                gemini_client = get_gemini_client()
                response = gemini_client.models.generate_content(
                    model=GEMINI_CATEGORY_MODEL,
                    contents=full_prompt,
                    config=types.GenerateContentConfig(temperature=temp)
                )
                
                ans = response.text
                
            elif llm == "claude":
                
                if mode == "user":
                    response = get_claude_client().messages.create(
                        model=CLAUDE_CATEGORY_MODEL,
                        max_tokens=CLAUDE_MAX_TOKENS,
                        temperature=temp,
                        system=[
                            {
                                "type": "text",
                                "text": prompt,
                                "cache_control": {"type": "ephemeral"},
                            }
                        ],
                        messages=[
                            {"role": "user", "content": full_prompt.replace(prompt, "")}
                        ],
                    )
                    ans = extract_claude_text(response)
                else:
                    # Assistant mode not supported for Claude categories yet
                    print("⚠ Assistant mode not supported for Claude. Using user mode instead.")
                    
            else:
                
                if mode == "user":
                    response = get_chatgpt_client().invoke(full_prompt, temperature=temp)
                    
                else:
                    response = get_chatgpt_client().invoke_as_assistant(full_prompt, temperature=temp)
                
                ans = response.content
            # -----------------------------------------------------

            parsed = parse_llm_dict(ans)

            print(f"LLM Response (Temp: {temp}, Mode: {mode}):")
            print(parsed)
            
            # write categories to a txt file
            path = os.path.join(PROMPTS_PATH, get_prompt_folder(paper), CLASSIFICATION_FILE)
            
            # append to the file
            with open(path, "w", encoding="utf-8") as f:
                f.write("Bearing in mind these categories, your next task is to classify each of the messages in one or more of them. These are the categories, the way they are named are how they must be tagged in the python dictionary:\n\n")
                
                for key, value in parsed.items():
                    f.write(f"{key}: {value}\n\n")

            return parsed

def obtener_categorizacion_llm(prompt, paper, llm, strategy_folder):

    temps, run_all_temps = seleccionar_temperaturas()
    temps = normalize_temps_for_llm(temps, llm)
    modes   = ["user"]

    path = os.path.join(DATA_PATH, PAPER_PATHS[int(paper)], DATA_FILE)
    df = pd.read_csv(path)

    message_col = "message"
    game_col = "game"  # CHANGE P0: Added game column reference
    df = df.dropna(subset=[message_col]).reset_index(drop=True)

    read_mode = select_processing_mode(llm)

    # ==========================================================
    # ========================= LINE BY LINE ===================
    # ==========================================================
    if read_mode == "1":

        for temp in temps:
            for mode in modes:

                out_file = f"results_line_temp{temp}_mode{mode}.csv"
                
                LLM = "gemini" if llm == "gemini" else ("claude" if llm == "claude" else "gpt")
                
                output_path = os.path.join(
                    RESULTS_PATH, LLM, PAPER_PATHS[int(paper)], strategy_folder, out_file
                )
                
                os.makedirs(os.path.dirname(output_path), exist_ok=True)

                # ---------- CHECKPOINT ----------
                existing_df = load_existing_if_compatible(
                    output_path,
                    df,
                    message_col,
                    id_col="row_id",
                    pred_message_col="original_message",
                )

                if existing_df is not None and not existing_df.empty:
                    processed_ids = set(
                        [
                            _safe_int(v)
                            for v in existing_df["row_id"].dropna().tolist()
                            if _safe_int(v) is not None
                        ]
                    )
                    print(f"Resuming execution. {len(processed_ids)} rows already processed.")
                else:
                    processed_ids = set()
                    print("New results file.")

                # CHANGE P0: Extract both message and game columns for pending rows
                pending_rows = [
                    (idx, row[message_col], row.get(game_col, None))
                    for idx, row in df.iterrows()
                    if idx not in processed_ids
                ]

                if llm == "gemini":
                    rows_buffer = []

                    with ThreadPoolExecutor(max_workers=GEMINI_WORKERS) as executor:
                        futures = {
                            executor.submit(
                                call_llm_for_message,
                                prompt,
                                message,
                                temp,
                                llm,
                                mode,
                                game  # CHANGE P0: Pass game parameter
                            ): (idx, message, game)
                            for idx, message, game in pending_rows
                        }

                        for future in tqdm(
                            as_completed(futures),
                            total=len(futures),
                            desc=f"[Line][Gemini x{GEMINI_WORKERS}] Temp {temp}, Mode {mode}"
                        ):
                            idx, message, game = futures[future]
                            try:
                                ans = future.result()
                                parsed = parse_llm_dict(ans)
                                parsed["original_message"] = message
                                parsed["row_id"] = idx
                                rows_buffer.append(parsed)

                                if len(rows_buffer) >= 10:
                                    write_rows_to_csv(output_path, rows_buffer)
                                    rows_buffer = []

                            except KeyboardInterrupt:
                                write_rows_to_csv(output_path, rows_buffer)
                                print("\n Manually interrupted. Progress saved.")
                                sys.exit()
                            except Exception as e:
                                print(f"\n⚠ Error on row {idx}: {e}")

                    write_rows_to_csv(output_path, rows_buffer)

                else:
                    rows_buffer = []
                    for idx, message, game in tqdm(
                        pending_rows,
                        total=len(pending_rows),
                        desc=f"[Line][{'Claude' if llm == 'claude' else 'GPT'}] Temp {temp}, Mode {mode}"
                    ):
                        try:
                            ans = call_llm_for_message(prompt, message, temp, llm, mode, game)  # CHANGE P0: Pass game parameter
                            parsed = parse_llm_dict(ans)
                            parsed["original_message"] = message
                            parsed["row_id"] = idx
                            rows_buffer.append(parsed)

                            if len(rows_buffer) >= 10:
                                write_rows_to_csv(output_path, rows_buffer)
                                rows_buffer = []

                        except KeyboardInterrupt:
                            write_rows_to_csv(output_path, rows_buffer)
                            print("\n Manually interrupted. Progress saved.")
                            sys.exit()

                        except Exception as e:
                            print(f"\n⚠ Error on row {idx}: {e}")
                            print("Progress saved so far.")
                            break

                    write_rows_to_csv(output_path, rows_buffer)

                print(f"✔ Results saved at {output_path}")


    # ==========================================================
    # ===================== CLAUDE BATCH MODE ==================
    # ==========================================================
    elif read_mode == "2" and llm == "claude":
        print(f"\n--- Claude Batch API Mode ---\n")

        client = get_claude_client()
        active_batches = {}

        for temp in temps:
            out_file = f"results_line_batch_temp{temp}_mode{modes[0]}.csv"
            output_path = os.path.join(
                RESULTS_PATH, "claude", PAPER_PATHS[int(paper)], strategy_folder, out_file
            )
            os.makedirs(os.path.dirname(output_path), exist_ok=True)

            existing_files = get_claude_temp_files(paper, strategy_folder, temp)
            for existing_file in existing_files:
                load_existing_if_compatible(
                    existing_file,
                    df,
                    message_col,
                    id_col="row_id",
                    pred_message_col="original_message",
                )
            processed_ids = get_processed_ids_from_files(existing_files)
            action = choose_batch_action_for_temp(temp, len(df), processed_ids, existing_files)

            if action == "skip":
                print(f"Skipping temp {temp}.")
                continue
            if action == "rerun":
                processed_ids = set()
                if os.path.exists(output_path):
                    os.remove(output_path)
                    print(f"Deleted existing batch output file for temp {temp}.")
            else:
                if processed_ids:
                    print(f"Continuing temp {temp}. {len(processed_ids)} rows already processed.")
                else:
                    print(f"Starting temp {temp} from scratch.")

            # CHANGE P0: Extract both message and game columns
            pending_rows = [
                (idx, row[message_col], row.get(game_col, None))
                for idx, row in df.iterrows()
                if idx not in processed_ids
            ]

            if not pending_rows:
                print(f"No pending rows for temp {temp}. Skipping batch.")
                continue

            # Check if batch already in progress for this temperature
            existing_batch_id, batch_in_progress = check_existing_batch(paper, strategy_folder, temp)
            
            if batch_in_progress:
                print(f"Batch already in progress for temp {temp}. Polling {existing_batch_id}...")
                batch_id = existing_batch_id
                create_new_batch = False
            else:
                create_new_batch = True
                batch_id = None
            
            # Build row_id_map for result processing (needed for both new and existing batches)
            temp_token = temp_to_id_token(temp)
            row_id_map = {}
            for i, (idx, message, game) in enumerate(pending_rows):
                row_id_map[f"temp{temp_token}_row{i}"] = (idx, message, game)
            
            if create_new_batch:
                print(f"Preparing batch with {len(pending_rows)} rows (Temp {temp})...")
                batch_requests = []
                
                for i, (idx, message, game) in enumerate(pending_rows):
                    custom_id = f"temp{temp_token}_row{i}"
                    
                    # CHANGE P0: Include game information in the message
                    if game is not None:
                        message_preamble = f"The actual game being played this period is: Game {game}\n\n"
                    else:
                        message_preamble = ""
                    
                    user_message = build_classification_user_message(message, game)
                    req = {
                        "custom_id": custom_id,
                        "params": {
                            "model": SELECTED_CLAUDE_MODEL,
                            "max_tokens": CLAUDE_MAX_TOKENS,
                            "temperature": temp,
                            "system": [
                                {
                                    "type": "text",
                                    "text": prompt,
                                    "cache_control": {"type": "ephemeral"},
                                }
                            ],
                            "messages": [
                                {"role": "user", "content": user_message}
                            ],
                        },
                    }
                    batch_requests.append(req)
                
                print(f"Submitting batch with {len(batch_requests)} requests...")
                batch_obj = client.messages.batches.create(requests=batch_requests)
                batch_id = batch_obj.id
                print(f"Batch created: {batch_id}")
                print("Tip: Go to console.anthropic.com → Batches to see live progress, status, and estimated completion time.")
                
                # Save batch ID to tracker
                batches = load_batch_status()
                batches[f"{paper}_{strategy_folder}_{temp}"] = {
                    "batch_id": batch_id,
                    "temperature": temp,
                    "paper": paper,
                    "strategy": strategy_folder
                }
                save_batch_status(batches)

            active_batches[temp] = {
                "batch_id": batch_id,
                "output_path": output_path,
                "row_id_map": row_id_map,
            }

        if not active_batches:
            print("No Claude batches to process.")
            return

        print(f"\nSubmitted/queued {len(active_batches)} batch(es). Polling all temperatures in parallel...\n")

        while active_batches:
            for temp in list(active_batches.keys()):
                info = active_batches[temp]
                batch = client.messages.batches.retrieve(info["batch_id"])
                counts = batch.request_counts
                print(
                    f"[Temp {temp}] [{batch.processing_status}] "
                    f"succeeded: {counts.succeeded} | errored: {counts.errored} | processing: {counts.processing}"
                )

                if batch.processing_status != "ended":
                    continue

                print(f"Batch {batch.id} completed for temp {temp}.")
                rows_buffer = []
                succeeded_count = 0
                errored_count = 0

                for result in client.messages.batches.results(batch.id):
                    try:
                        if result.result.type == "succeeded":
                            custom_id = result.custom_id
                            if custom_id not in info["row_id_map"]:
                                errored_count += 1
                                print(f"⚠ Unknown custom_id in results: {custom_id}")
                                continue

                            idx, message, game = info["row_id_map"][custom_id]
                            ans = extract_claude_text(result.result.message)
                            parsed = parse_llm_dict(ans)
                            parsed["original_message"] = message
                            parsed["row_id"] = idx
                            rows_buffer.append(parsed)
                            succeeded_count += 1

                            if len(rows_buffer) >= 10:
                                write_rows_to_csv(info["output_path"], rows_buffer)
                                rows_buffer = []
                        else:
                            errored_count += 1
                            print(f"⚠ Result {result.custom_id} failed: {result.result.error}")
                    except Exception as e:
                        errored_count += 1
                        print(f"⚠ Error processing batch result: {e}")

                write_rows_to_csv(info["output_path"], rows_buffer)

                if succeeded_count > 0:
                    print(f"✔ Batch results saved at {info['output_path']}")
                else:
                    print(
                        f"⚠ No successful results saved for temp {temp}. "
                        f"Succeeded: {succeeded_count}, Errored: {errored_count}."
                    )

                # Remove completed batch from tracker
                batches = load_batch_status()
                if f"{paper}_{strategy_folder}_{temp}" in batches:
                    del batches[f"{paper}_{strategy_folder}_{temp}"]
                    save_batch_status(batches)

                del active_batches[temp]

            if active_batches:
                time.sleep(30)

    elif read_mode == "2" and llm in ("gpt", "chatgpt"):
        print(f"\n--- GPT Batch API Mode ---\n")

        client = get_openai_batch_client()
        active_batches = {}

        for temp in temps:
            out_file = f"results_line_batch_temp{temp}_mode{modes[0]}.csv"
            output_path = os.path.join(
                RESULTS_PATH, "gpt", PAPER_PATHS[int(paper)], strategy_folder, out_file
            )
            os.makedirs(os.path.dirname(output_path), exist_ok=True)

            existing_files = get_provider_temp_files("gpt", paper, strategy_folder, temp)
            for existing_file in existing_files:
                load_existing_if_compatible(
                    existing_file,
                    df,
                    message_col,
                    id_col="row_id",
                    pred_message_col="original_message",
                )
            processed_ids = get_processed_ids_from_files(existing_files)
            action = choose_batch_action_for_temp(temp, len(df), processed_ids, existing_files)

            if action == "skip":
                print(f"Skipping temp {temp}.")
                continue
            if action == "rerun":
                processed_ids = set()
                if os.path.exists(output_path):
                    os.remove(output_path)
                    print(f"Deleted existing batch output file for temp {temp}.")
            else:
                if processed_ids:
                    print(f"Continuing temp {temp}. {len(processed_ids)} rows already processed.")
                else:
                    print(f"Starting temp {temp} from scratch.")

            pending_rows = [
                (idx, row[message_col], row.get(game_col, None))
                for idx, row in df.iterrows()
                if idx not in processed_ids
            ]

            if not pending_rows:
                print(f"No pending rows for temp {temp}. Skipping batch.")
                continue

            existing_batch_id, batch_in_progress = check_existing_openai_batch(paper, strategy_folder, temp)
            if batch_in_progress:
                print(f"Batch already in progress for temp {temp}. Polling {existing_batch_id}...")
                batch_id = existing_batch_id
                create_new_batch = False
            else:
                create_new_batch = True
                batch_id = None

            temp_token = temp_to_id_token(temp)
            row_id_map = {}
            for i, (idx, message, game) in enumerate(pending_rows):
                row_id_map[f"temp{temp_token}_row{i}"] = (idx, message, game)

            if create_new_batch:
                print(f"Preparing GPT batch with {len(pending_rows)} rows (Temp {temp})...")
                batch_lines = []

                for i, (idx, message, game) in enumerate(pending_rows):
                    custom_id = f"temp{temp_token}_row{i}"
                    user_message = build_classification_user_message(message, game)
                    req = {
                        "custom_id": custom_id,
                        "method": "POST",
                        "url": "/v1/chat/completions",
                        "body": {
                            "model": SELECTED_CHATGPT_MODEL,
                            "temperature": temp,
                            "messages": [
                                {"role": "system", "content": prompt},
                                {"role": "user", "content": user_message},
                            ],
                        },
                    }
                    batch_lines.append(json.dumps(req, ensure_ascii=False))

                batch_input_path = os.path.join(
                    RESULTS_PATH,
                    "gpt",
                    PAPER_PATHS[int(paper)],
                    strategy_folder,
                    f"batch_input_temp{temp}.jsonl",
                )
                with open(batch_input_path, "w", encoding="utf-8") as f:
                    for line in batch_lines:
                        f.write(line + "\n")

                print(f"Uploading batch input file for temp {temp}...")
                with open(batch_input_path, "rb") as batch_input_handle:
                    batch_input_file = client.files.create(
                        file=batch_input_handle,
                        purpose="batch",
                    )
                batch_obj = client.batches.create(
                    input_file_id=batch_input_file.id,
                    endpoint="/v1/chat/completions",
                    completion_window="24h",
                    metadata={
                        "paper": str(paper),
                        "strategy": strategy_folder,
                        "temperature": str(temp),
                    },
                )
                batch_id = batch_obj.id
                print(f"GPT batch created: {batch_id}")

                batches = load_provider_batch_status("gpt")
                batches[f"{paper}_{strategy_folder}_{temp}"] = {
                    "batch_id": batch_id,
                    "temperature": temp,
                    "paper": paper,
                    "strategy": strategy_folder,
                    "input_file_id": batch_input_file.id,
                    "batch_input_path": batch_input_path,
                }
                save_provider_batch_status("gpt", batches)

            active_batches[temp] = {
                "batch_id": batch_id,
                "output_path": output_path,
                "row_id_map": row_id_map,
            }

        if not active_batches:
            print("No GPT batches to process.")
            return

        print(f"\nSubmitted/queued {len(active_batches)} GPT batch(es). Polling all temperatures in parallel...\n")

        while active_batches:
            for temp in list(active_batches.keys()):
                info = active_batches[temp]
                batch = client.batches.retrieve(info["batch_id"])
                counts = batch.request_counts
                print(
                    f"[Temp {temp}] [{batch.status}] "
                    f"completed: {counts.completed} | failed: {counts.failed} | total: {counts.total}"
                )

                if batch.status not in ("completed", "failed", "expired", "cancelled"):
                    continue

                if batch.status != "completed" and not batch.output_file_id:
                    print(f"⚠ GPT batch {batch.id} ended with status {batch.status} and no output file.")
                    batches = load_provider_batch_status("gpt")
                    if f"{paper}_{strategy_folder}_{temp}" in batches:
                        del batches[f"{paper}_{strategy_folder}_{temp}"]
                        save_provider_batch_status("gpt", batches)
                    del active_batches[temp]
                    continue

                print(f"GPT batch {batch.id} completed for temp {temp}.")
                rows_buffer = []
                succeeded_count = 0
                errored_count = 0

                output_text = get_openai_file_text(client.files.content(batch.output_file_id))
                for line in output_text.splitlines():
                    if not line.strip():
                        continue
                    try:
                        result = json.loads(line)
                        custom_id = result.get("custom_id")
                        if custom_id not in info["row_id_map"]:
                            errored_count += 1
                            print(f"⚠ Unknown custom_id in GPT batch results: {custom_id}")
                            continue

                        idx, message, game = info["row_id_map"][custom_id]
                        if result.get("error") is not None:
                            errored_count += 1
                            print(f"⚠ GPT batch request {custom_id} failed: {result['error']}")
                            continue

                        response = result.get("response") or {}
                        if response.get("status_code") != 200:
                            errored_count += 1
                            print(f"⚠ GPT batch request {custom_id} returned status {response.get('status_code')}")
                            continue

                        ans = get_openai_response_text(response.get("body", {}))
                        parsed = parse_llm_dict(ans)
                        parsed["original_message"] = message
                        parsed["row_id"] = idx
                        rows_buffer.append(parsed)
                        succeeded_count += 1

                        if len(rows_buffer) >= 10:
                            write_rows_to_csv(info["output_path"], rows_buffer)
                            rows_buffer = []
                    except Exception as e:
                        errored_count += 1
                        print(f"⚠ Error processing GPT batch result: {e}")

                write_rows_to_csv(info["output_path"], rows_buffer)

                if succeeded_count > 0:
                    print(f"✔ GPT batch results saved at {info['output_path']}")
                else:
                    print(
                        f"⚠ No successful GPT batch results saved for temp {temp}. "
                        f"Succeeded: {succeeded_count}, Errored: {errored_count}."
                    )

                batches = load_provider_batch_status("gpt")
                if f"{paper}_{strategy_folder}_{temp}" in batches:
                    del batches[f"{paper}_{strategy_folder}_{temp}"]
                    save_provider_batch_status("gpt", batches)

                del active_batches[temp]

            if active_batches:
                time.sleep(30)

    elif read_mode == "2" and llm not in ("claude", "gpt", "chatgpt"):
        print("⚠ Batch mode is only available for Claude and GPT. Skipping.")
        return

    else:
        print(f"⚠ Unsupported mode: {read_mode}. Use line mode (1) or batch mode (3).")
        return
 
def leer_archivo_txt(filepath) :

    with open(filepath, "r", encoding="utf-8") as f:
        return f.read()

def get_prompt_folder(paper):
    return PROMPT_PAPER_PATHS[int(paper)]
   
# CHANGE P3: Reordered filenames to put CONSTRAINTS before FORMAT for better logical flow
def crear_prompt_basico(folder_path, filenames=[ROLE_FILE, CONTEXT_FILE, CLASSIFICATION_FILE, CONSTRAINTS_FILE, FORMAT_FILE]):

    contents = []

    for filename in filenames:
        full_path = os.path.join(PROMPTS_PATH, folder_path, filename)
        text = leer_archivo_txt(full_path)
        contents.append(text)

    return "\n".join(contents)

def crear_categorias(paper, llm):
    print(f"\n>>> Creating categories for Paper {paper}...")
    
    # Build the base prompt
    prompt = crear_prompt_basico(get_prompt_folder(paper), filenames=[ROLE_FILE, CONTEXT_FILE, CLASSIFICATION_CAT_FILE, FORMAT_CAT_FILE])
    
    
    # ask the llm to create categories
    categorias=obtener_categorias_llm(prompt, paper, llm)
    
    print(f"\n>>> These are the categories created for Paper {paper}...")
    
    print(categorias)
    
    print(f"\n>>> Now let's classify each text...")
    
    menu_asignacion_pos_categorizacion(paper) 

def asignar_zero_shot(paper, llm):
    print(f"\n>>> Assigning categories (Zero-Shot) for Paper {paper}...")
    prompt = crear_prompt_basico(get_prompt_folder(paper))
    obtener_categorizacion_llm(prompt, paper, llm, "0shot")
    
def asignar_few_shot(paper, llm):
    print(f"\n>>> Assigning categories (Few-Shot) for Paper {paper}...")
    prompt = crear_prompt_basico(get_prompt_folder(paper))
    # add the few-shot part
    # read fewshot.txt
    fewshot_path = os.path.join(PROMPTS_PATH, get_prompt_folder(paper), FEWSHOT_FILE)
    fewshot_text = leer_archivo_txt(fewshot_path)
    # if the file is empty, ask for examples via console
    fewshot_text = empty_examples(fewshot_text)
    prompt += "\n" + fewshot_text   
    
    obtener_categorizacion_llm(prompt, paper, llm, "fewshot")

def asignar_zero_shot_cot(paper, llm):
    print(f"\n>>> Assigning categories (Zero-Shot CoT) for Paper {paper}...")
    prompt = crear_prompt_basico(get_prompt_folder(paper))
    # add the Zero-Shot CoT part
    # read 0ShotCoT.txt
    zeroshotcot_path = os.path.join(PROMPTS_PATH, get_prompt_folder(paper), ZEROSHOTCOT_FILE)
    zeroshotcot_text = leer_archivo_txt(zeroshotcot_path)
    prompt += "\n" + zeroshotcot_text
    
    obtener_categorizacion_llm(prompt, paper, llm, "0shot_cot")

def asignar_few_shot_cot(paper, llm):
    print(f"\n>>> Assigning categories (Few-Shot CoT) for Paper {paper}...")
    # add the few-shot CoT part
    prompt = crear_prompt_basico(get_prompt_folder(paper))
    # read few-shotCoT.txt
    fewshotcot_path = os.path.join(PROMPTS_PATH, get_prompt_folder(paper), FEWSHOTCOT_FILE)
    fewshotcot_text = leer_archivo_txt(fewshotcot_path)
    # if the file is empty, ask for examples via console
    fewshotcot_text = empty_examples(fewshotcot_text)
    prompt += "\n" + fewshotcot_text
    
    obtener_categorizacion_llm(prompt, paper, llm, "fewshot_cot")
    
def empty_examples(fewshot_text):
    if fewshot_text.strip() == "":
        print("The fewShot.txt file is empty. Please enter few-shot examples (leave an empty line to finish):")
        ejemplos = []
        while True:
            linea = input()
            if linea.strip() == "":
                break
            ejemplos.append(linea)
        fewshot_text = "\n".join(ejemplos)
    return fewshot_text

def menu_asignacion(paper):
    
    while True:
        print("\n--- Select the assignment strategy ---")
        print("1. Zero-Shot")
        print("2. Few-Shot")
        print("3. Zero-Shot CoT")
        print("4. Few-Shot CoT")
        print("5. Go back")
        print("0. Exit script")

        opcion = input("Choose an option: ")

        if opcion == "1":
            llm = seleccionar_llm()
            if llm: asignar_zero_shot(paper, llm)
        elif opcion == "2":
            llm = seleccionar_llm()
            if llm: asignar_few_shot(paper, llm)
        elif opcion == "3":
            llm = seleccionar_llm()
            if llm: asignar_zero_shot_cot(paper, llm)
        elif opcion == "4":
            llm = seleccionar_llm()
            if llm: asignar_few_shot_cot(paper, llm)
        elif opcion == "5":
            return
        elif opcion == "0":
            print("Exiting...")
            sys.exit()
        else:
            print("Invalid option.")
             
def menu_asignacion_pos_categorizacion(paper):
    
    while True:
        print("\n--- Select the assignment strategy ---")
        print("1. Zero-Shot")
        print("2. Few-Shot")
        print("3. Zero-Shot CoT")
        print("4. Few-Shot CoT")
        print("5. Go back")
        print("0. Exit script")

        opcion = input("Choose an option: ")

        if opcion == "1":
            llm = seleccionar_llm()
            if llm: asignar_zero_shot(paper, llm)
        elif opcion == "2":
            llm = seleccionar_llm()
            if llm: asignar_few_shot(paper, llm)
        elif opcion == "3":
            llm = seleccionar_llm()
            if llm: asignar_zero_shot_cot(paper, llm)
        elif opcion == "4":
            llm = seleccionar_llm()
            if llm: asignar_few_shot_cot(paper, llm)
        elif opcion == "5":
            return
        elif opcion == "0":
            print("Exiting...")
            sys.exit()
        else:
            print("Invalid option.")

def seleccionar_llm():
    global SELECTED_CHATGPT_MODEL, SELECTED_GEMINI_MODEL, SELECTED_CLAUDE_MODEL, llm_chatgpt, llm_claude

    CHATGPT_MODELS = {
        "1": "gpt-5.4-mini",
        "2": "gpt-5.4",
        "3": "gpt-5.2",
    }
    GEMINI_MODELS = {
        "1": "gemini-3.1-pro-preview",
        "2": "gemini-3.1-pro-preview-customtools",
        "3": "gemini-3-flash-preview",
        "4": "gemini-3-pro-preview",
        "5": "gemini-3.1-flash-live-preview",
    }
    CLAUDE_MODELS = {
        "1": "claude-opus-4-6",
        "2": "claude-sonnet-4-6",
        "3": "claude-haiku-4-5-20251001",
    }

    while True:
        print(f"\n--- Select LLM  [recommended: ChatGPT/{SELECTED_CHATGPT_MODEL}  |  Gemini/{SELECTED_GEMINI_MODEL}  |  Claude/{SELECTED_CLAUDE_MODEL}] ---")
        print("1. ChatGPT")
        print("2. Gemini")
        print("3. Claude")
        print("4. Go back")
        print("0. Exit script")

        opcion = input("Choose an option: ")

        if opcion == "1":
            print("\n--- Select ChatGPT model ---")
            for k, v in CHATGPT_MODELS.items():
                marker = " ◀ recommended" if v == SELECTED_CHATGPT_MODEL else ""
                print(f"{k}. {v}{marker}")
            model_op = input("Choose a model: ").strip()
            if model_op in CHATGPT_MODELS:
                SELECTED_CHATGPT_MODEL = CHATGPT_MODELS[model_op]
            else:
                print(f"Invalid option. Recommended model will be used: {SELECTED_CHATGPT_MODEL}")
            llm_chatgpt = None
            print(f"Selected model: {SELECTED_CHATGPT_MODEL}")
            return "chatgpt"

        elif opcion == "2":
            print("\n--- Select Gemini model ---")
            for k, v in GEMINI_MODELS.items():
                marker = " ◀ recommended" if v == SELECTED_GEMINI_MODEL else ""
                print(f"{k}. {v}{marker}")
            model_op = input("Choose a model: ").strip()
            if model_op in GEMINI_MODELS:
                SELECTED_GEMINI_MODEL = GEMINI_MODELS[model_op]
            else:
                print(f"Invalid option. Recommended model will be used: {SELECTED_GEMINI_MODEL}")
            print(f"Selected model: {SELECTED_GEMINI_MODEL}")
            return "gemini"

        elif opcion == "3":
            print("\n--- Select Claude model ---")
            for k, v in CLAUDE_MODELS.items():
                marker = " ◀ recommended" if v == SELECTED_CLAUDE_MODEL else ""
                print(f"{k}. {v}{marker}")
            model_op = input("Choose a model: ").strip()
            if model_op in CLAUDE_MODELS:
                SELECTED_CLAUDE_MODEL = CLAUDE_MODELS[model_op]
            else:
                print(f"Invalid option. Recommended model will be used: {SELECTED_CLAUDE_MODEL}")
            llm_claude = None
            print(f"Selected model: {SELECTED_CLAUDE_MODEL}")
            return "claude"

        elif opcion == "4":
            return None

        elif opcion == "0":
            print("Exiting...")
            sys.exit()

        else:
            print("Invalid option.")

def main_menu():
    while True:
        print("\n======= MAIN MENU =======")
        print("1. MANAGERIAL LEADERSHIP, TRUTH-TELLING AND EFFICIENT COORDINATION")
        print("2. STRATEGIC ENVIRONMENT EFFECT AND COMMUNICATION")
        print("3. Trust and Promises over Time")
        print("4. Underreporting of AI Use: The Role of Social Desirability Bias")
        print("5. Exit")

        paper = input("Select a paper: ")

        if paper == "5":
            print("Exiting...")
            break

        if paper not in ["1", "2", "3", "4"]:
            print("Invalid option.")
            continue

        print(f"\nYou selected Paper {paper}")

        while True:
            print(
                f"\n--- What would you like to do? "
                f"[ChatGPT/{SELECTED_CHATGPT_MODEL} | Gemini/{SELECTED_GEMINI_MODEL} | Claude/{SELECTED_CLAUDE_MODEL}] ---"
            )
            print("1. Create categories")
            print("2. Assign categories")
            print("3. Go back to main menu")
            print("0. Exit script")

            accion = input("Select an option: ")

            if accion == "1":
                llm = seleccionar_llm()
                if llm:
                    crear_categorias(paper, llm)

            elif accion == "2":
                menu_asignacion(paper)

            elif accion == "3":
                break

            elif accion == "0":
                print("Exiting...")
                sys.exit()

            else:
                print("Invalid option.")

main_menu()
