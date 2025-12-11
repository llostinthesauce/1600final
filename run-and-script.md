# Run & script
[← Download models](models.md) | [Home](README.md)

## Use the helper script
`mlx-switch-bench.sh` provides a tiny menu for three models (Llama 3.2, SmolLM, OpenELM). If no models are present, it offers a one-time download (pick one or all), then asks you to relaunch. Run it from the repo root and make sure `mlx-lm` is installed (or your venv is active).

To make the script executable and run it:
```bash
chmod +x mlx-switch-bench.sh
./mlx-switch-bench.sh
```

What it does:
- If no models exist yet, it can download one or all (then asks you to re-run).
- Uses a `models/` folder beside the script (created automatically).
- Auto-activates `~/.venvs/mlx-lm` if it exists.
- Prompts for temperature, max tokens, and your prompt.
- Reports clock time when generation finishes.

## Customize the script
- To change the menu options, edit the `MODEL_DIR` entries near the top of `mlx-switch-bench.sh`.
- If your models live somewhere else, set `MLX_MODELS_DIR=/path/to/models` before running the script or choose option `c` and paste the path.
- Tweak `DEFAULT_TEMP` and `DEFAULT_MAX_TOKENS` for each case if you want different defaults. (Temp = Accuracy), (Tokens = Length)
- Feel free to add more models outside of the scope of this, and just append them to the .sh script

## Offline checklist
- Run `./mlx-switch-bench.sh` once while online to prove the model paths are correct.
- Confirm the model folders contain all files (`ls models/<model>`)
- Disconnect from the network and rerun the script; generation will still work since everything is local

## Bonus: Manual one-liner command
Use this if you want to manually prompt one of the models. Run it from the repo root so `models/` resolves, and be sure `mlx-lm` is installed/venv active.
```bash
source ~/.venvs/mlx-lm/bin/activate
MODEL="$(pwd)/models/Llama-3.2-3B-Instruct-4bit"

mlx_lm.generate \
  --model "$MODEL" \
  --temp 0.7 \
  --max-tokens 256 \
  --prompt "Put your prompt here!."
```

Swap `MODEL` for any folder you downloaded.

---
Previous → [Download models](models.md) | Home → [README](README.md)
