# Setup
[← Home](README.md) | [Next → Download models](models.md)

## Requirements
- Apple Silicon Mac (M1, M2, M3, M4) with macOS 14+.
- 10+ GB free disk space for a couple of small models.
- Python 3.10+ (3.11 recommended) (mlx-lm is a Python package)
- Internet access once to install packages and download models.

## Install Python + mlx-lm
Use a virtual environment to avoid touching system your Python.

```bash
# if you do not already have Python 3, install
# brew install python@3.11

python3 -m venv ~/.venvs/mlx-lm
source ~/.venvs/mlx-lm/bin/activate
python -m pip install --upgrade pip
pip install mlx-lm
```

keep the venv jotted down so you understand where/how this program is running: `~/.venvs/mlx-lm`. 
The helper script will auto-activate it when it is present. (But is optional)

---
Previous → [Home](README.md) | Next → [Download models](models.md)
