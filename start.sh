#!/bin/bash
mkdir -p /ComfyUI/models/diffusion_models
mkdir -p /ComfyUI/models/text_encoders
mkdir -p /ComfyUI/models/vae
mkdir -p /ComfyUI/models/checkpoints

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
echo "✅ Скачивание завершено!"

# Перемещаем файлы в правильные папки
echo "📦 Раскладываем файлы по папкам..."

# Модель из diffusion_models -> checkpoints
if [ -f /ComfyUI/models/diffusion_models/ltx-2.3-22b-distilled-fp8.safetensors ]; then
    mv /ComfyUI/models/diffusion_models/ltx-2.3-22b-distilled-fp8.safetensors /ComfyUI/models/checkpoints/
    echo "  ✅ Модель перемещена в checkpoints/"
fi

# Video VAE оставляем в vae/ (уже там)
echo "  ✅ Video VAE в vae/"

# Audio VAE оставляем в vae/ (уже там)
echo "  ✅ Audio VAE в vae/"

# Text encoder оставляем без изменений (уже в text_encoders/)
echo "  ✅ Text encoder в text_encoders/"

echo "✅ Готово!"
python3 /ComfyUI/main.py --listen 0.0.0.0 --port 8188
