#!/bin/bash

# Создаём нужные папки
mkdir -p /ComfyUI/models/checkpoints
mkdir -p /ComfyUI/models/text_encoders
mkdir -p /ComfyUI/models/vae
mkdir -p /ComfyUI/models/loras
mkdir -p /ComfyUI/models/latent_upscale_models

# Устанавливаем huggingface_hub (если нужно)
pip install -q huggingface_hub

# Передаём HF_TOKEN
export HF_TOKEN=${HF_TOKEN}

echo "========================================="
echo "📥 Скачиваем тяжёлые модели LTX-2.3"
echo "   Репозиторий: raderos/comfyui-models-ltx"
echo "========================================="

# Скачиваем всё одним вызовом
python3 -c "
from huggingface_hub import snapshot_download
import os

snapshot_download(
    repo_id='raderos/comfyui-models-ltx',
    local_dir='/ComfyUI/models',
    token=os.environ.get('HF_TOKEN', ''),
    resume_download=True
)
"

echo "✅ Все модели скачаны!"

echo ""
echo "🚀 Запускаем ComfyUI с флагами LOW_VRAM..."
python3 /ComfyUI/main.py --listen 0.0.0.0 --port 8188 --lowvram --disable-smart-memory
