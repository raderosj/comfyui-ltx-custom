#!/bin/bash
mkdir -p /ComfyUI/models/diffusion_models
mkdir -p /ComfyUI/models/text_encoders
mkdir -p /ComfyUI/models/vae

pip install -q huggingface_hub hf_transfer
export HF_TOKEN=${HF_TOKEN}

echo "📥 Скачиваем LTX модели..."
python3 -c "
from huggingface_hub import snapshot_download
import os
snapshot_download(
    repo_id='raderos/comfyui-models-ltx',
    local_dir='/ComfyUI/models',
    token=os.environ['HF_TOKEN']
)
"
echo "✅ Готово!"
python3 /ComfyUI/main.py --listen 0.0.0.0 --port 8188
