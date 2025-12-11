# Download models
[← Setup](setup.md) | [Next → Run & script](run-and-script.md)

## If you want to let the script automatically install models, feel free to skip this page!

## Where files go
- Default folder: `models/` (created automatically beside `mlx-switch-bench.sh`).
- Each model sits in its own subfolder
- Folder names below match the helper script menu so you can pick them easily.

## Starter models bundled in the script
- `Llama-3.2-3B-Instruct-4bit` — balanced quality and size
- `SmolLM-360M-4bit` — tiny and very fast
- `OpenELM-1_1B-Instruct-8bit` — Apple’s small model

The helper script will auto-download these into `models/` if they’re missing. 
I would suggest running the script, and downloading all three, then restarting. 
But if you prefer manual pulls from huggingface, not using the script:

## Download commands (manual)
Run while online from the repo root (so `models/` is created in the project).

```bash
mkdir -p models

huggingface-cli download mlx-community/Llama-3.2-3B-Instruct-4bit \
  --local-dir "models/Llama-3.2-3B-Instruct-4bit" \
  --local-dir-use-symlinks False --include "*"

huggingface-cli download mlx-community/SmolLM-360M-4bit \
  --local-dir "models/SmolLM-360M-4bit" \
  --local-dir-use-symlinks False --include "*"

huggingface-cli download mlx-community/OpenELM-1_1B-Instruct-8bit \
  --local-dir "models/OpenELM-1_1B-Instruct-8bit" \
  --local-dir-use-symlinks False --include "*"
```

---
Previous → [Setup](setup.md) | Next → [Run & script](run-and-script.md)
