#!/usr/bin/env bash
set -euo pipefail

# created from mlx-lm docs, unix bash scripting class, and knowledge about local llms from my own app development and capstone project

# Base directory for models; defaults to a local ./models next to this script.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="${MLX_MODELS_DIR:-$SCRIPT_DIR/models}"

# Optional virtual environment for mlx-lm (override with VENV_PATH).
VENV_PATH="${VENV_PATH:-$HOME/.venvs/mlx-lm}"
PYTHON_BIN="${PYTHON_BIN:-python3}"

# Activate venv if present so mlx-lm is on PATH.
if [ -d "$VENV_PATH" ]; then
  # shellcheck disable=SC1090
  source "$VENV_PATH/bin/activate"
  PYTHON_BIN="python"
fi

if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
  echo "Python not found (expected $PYTHON_BIN). Install Python 3 first." >&2
  exit 1
fi

if ! "$PYTHON_BIN" - <<'PY'
import importlib.util, sys
sys.exit(0 if importlib.util.find_spec("mlx_lm") else 1)
PY
then
  echo "mlx-lm is not installed for $PYTHON_BIN. Activate your venv or run: pip install mlx-lm" >&2
  exit 1
fi

if ! command -v huggingface-cli >/dev/null 2>&1; then
  echo "huggingface-cli not found. Install huggingface_hub (pip install huggingface_hub) or ensure it is on PATH." >&2
  exit 1
fi

mkdir -p "$BASE_DIR"

MODELS=(
  "1|Llama-3.2-3B-Instruct-4bit|mlx-community/Llama-3.2-3B-Instruct-4bit|0.7|512"
  "2|SmolLM-360M-4bit|mlx-community/SmolLM-360M-4bit|0.65|256"
  "3|OpenELM-1_1B-Instruct-8bit|mlx-community/OpenELM-1_1B-Instruct-8bit|0.7|512"
)

have_any_model=false
for entry in "${MODELS[@]}"; do
  IFS='|' read -r _ name _ _ _ <<<"$entry"
  if [ -d "$BASE_DIR/$name" ]; then
    have_any_model=true
    break
  fi
done

download_model() {
  local repo="$1" dest="$2"
  echo "Downloading $repo to $dest ..."
  mkdir -p "$dest"
  huggingface-cli download "$repo" --local-dir "$dest" --local-dir-use-symlinks False --include "*"
}

if [ "$have_any_model" = false ]; then
  echo "No models found in $BASE_DIR."
  read -rp "Download now? [y/N]: " dl_now
  dl_now=${dl_now:-n}
  dl_now=$(printf "%s" "$dl_now" | tr '[:upper:]' '[:lower:]')
  if [ "$dl_now" != "y" ]; then
    echo "Nothing downloaded. Run again when ready to download or place models in $BASE_DIR."
    exit 1
  fi

  echo "Download which option?"
  echo " 1) Llama-3.2-3B-Instruct-4bit"
  echo " 2) SmolLM-360M-4bit"
  echo " 3) OpenELM-1_1B-Instruct-8bit"
  echo " 4) All of the above"
  read -rp "Choice: " dl_choice
  case "$dl_choice" in
    1|2|3)
      idx=$((dl_choice-1))
      IFS='|' read -r _ name repo _ _ <<<"${MODELS[$idx]}"
      download_model "$repo" "$BASE_DIR/$name"
      ;;
    4)
      for entry in "${MODELS[@]}"; do
        IFS='|' read -r _ name repo _ _ <<<"$entry"
        download_model "$repo" "$BASE_DIR/$name"
      done
      ;;
    *)
      echo "Invalid choice. Exiting without download."
      exit 1
      ;;
  esac
  echo "Download complete. Re-launch the script to select a model and run."
  exit 0
fi

cat <<'EOF'
Select an MLX model to run:

 1) Llama-3.2-3B-Instruct-4bit  (balanced quality)
 2) SmolLM-360M-4bit            (fastest)
 3) OpenELM-1_1B-Instruct-8bit  (Apple small model)

 c) Custom model folder path
EOF

read -rp "Model # (1-3 or c): " choice

MODEL_DIR=""
MODEL_REPO=""
DEFAULT_TEMP=""
DEFAULT_MAX_TOKENS=""

case "$choice" in
  1|2|3)
    idx=$((choice-1))
    IFS='|' read -r _ MODEL_DIR MODEL_REPO DEFAULT_TEMP DEFAULT_MAX_TOKENS <<<"${MODELS[$idx]}"
    ;;
  [cC])
    read -rp "Absolute path to your MLX model folder: " MODEL_PATH
    ;;
  *)
    echo "Invalid choice: $choice" >&2
    exit 1
    ;;
esac

if [ -z "${MODEL_PATH:-}" ]; then
  MODEL_PATH="${BASE_DIR}/${MODEL_DIR}"
fi

if [ ! -d "$MODEL_PATH" ]; then
  echo "Model not downloaded at $MODEL_PATH. Try again after downloading."
  exit 1
fi

DEFAULT_TEMP="${DEFAULT_TEMP:-0.7}"
DEFAULT_MAX_TOKENS="${DEFAULT_MAX_TOKENS:-256}"

echo
echo "Selected model path: $MODEL_PATH"
echo "Default temperature: ${DEFAULT_TEMP}"
echo "Default max new tokens: ${DEFAULT_MAX_TOKENS}"
echo

read -rp "Temperature [${DEFAULT_TEMP}]: " temp_input
TEMP="${temp_input:-$DEFAULT_TEMP}"

if ! [[ "$TEMP" =~ ^[0-9]*\.?[0-9]+$ ]]; then
  echo "Invalid temperature '$TEMP'. Use a number like 0.7" >&2
  exit 1
fi

read -rp "Max new tokens [${DEFAULT_MAX_TOKENS}]: " tokens_input
MAX_TOKENS="${tokens_input:-$DEFAULT_MAX_TOKENS}"

if ! [[ "$MAX_TOKENS" =~ ^[0-9]+$ ]]; then
  echo "Invalid max tokens '$MAX_TOKENS'. Use an integer like 256." >&2
  exit 1
fi

echo
read -rp "Prompt (single line): " PROMPT
echo

echo "======================================================="
echo "  MLX run starting"
echo "  Model path:  $MODEL_PATH"
echo "  Temperature: $TEMP"
echo "  Max tokens:  $MAX_TOKENS"
echo "======================================================="
echo

SECONDS=0

"$PYTHON_BIN" -m mlx_lm.generate \
  --model "$MODEL_PATH" \
  --temp "$TEMP" \
  --max-tokens "$MAX_TOKENS" \
  --prompt "$PROMPT"

elapsed=$SECONDS

echo
echo "======================================================="
echo "  MLX run finished"
echo "  Wall-clock time: ${elapsed}s"
echo "======================================================="
