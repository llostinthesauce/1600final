# Running MLX Models on Mac Offline
**Author:** llostinthesauce  

**Audience:** Curious Apple Silicon users (any age) who want to try local LLMs. Here I assume mild comfort with file architeture, Python, and the bash shell.

**Purpose & Summary:** Install `mlx-lm`, install demo models (Llama 3.2, SmolLM, and Apple’s OpenELM), and run them fully offline with a tiny helper script. (or manually)

### Why run MLX locally?
MLX is Apple's native framework for running LLMs locally, and leverages the Apple Silicon hardware, such as M1-M5 chips, as well as the AXX chips for mobile. 

MLX has considerable performance improvements over running llama.cpp, or .gguf file types, at least in my testing.

It is likely that Apple will launch their own bundled LLMs, or more native ways to run them with a pretty GUI in the coming months to years, but currently, the best way for YOU to be in control and to run them, is a simple script like this.

Running LLMs offline and efficently is a lovely way to protect user privacy, and is likely a glimpse into the future. 

A simple framework like this is a proof of concept, and could be scaled based on hardware, and also be easily expanded to use an OpenAI style API endpoint to run a local AI server.

For more reading:
- Official MLX docs: https://apple.github.io/mlx/
- MLX examples: https://github.com/ml-explore

Jump to: [Setup](setup.md) · [Download models](models.md) · [Run & script](run-and-script.md)

## What you’ll learn
- Install the `mlx-lm` Python package
- Download small MLX-ready chat models (Llama 3.2, SmolLM, OpenELM).
- Run chat prompts offline via one shell script or a single command.

## Quickstart (5–10 minutes)
1) Follow **[Setup](setup.md)** to install Python + `mlx-lm`.  
2) Run the helper script in **[Run & script](run-and-script.md)**; on first launch (no models yet) it will offer to download one/all into `models/`, then ask you to relaunch.  
3) Pick a model and run your first prompt offline.
Note: run commands from the repo root so `models/` resolves correctly, and activate your venv (or otherwise have `mlx-lm` installed) before using the script or one-liner.

## Repository contents
- `README.md` — Home page
- `setup.md` — Tools, Python, and `mlx-lm` install steps.  
- `models.md` — Where to get MLX-ready models 
- `run-and-script.md` — Manual `mlx_lm.generate` commands and the `mlx-switch-bench.sh` helper.

---
Next → [Setup](setup.md)
