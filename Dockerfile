FROM pytorch/pytorch:2.6.0-cuda12.4-cudnn9-runtime

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git wget python3 python3-pip libgl1 libglib2.0-0 ffmpeg \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
RUN pip3 install gguf opencv-python-headless

RUN git clone https://github.com/comfyanonymous/ComfyUI /ComfyUI && \
    cd /ComfyUI && \
    pip3 install -r requirements.txt && \
    pip3 install sqlalchemy gdown

RUN cd /ComfyUI/custom_nodes && \
    # Основные ноды (уже были)
    git clone https://github.com/kijai/ComfyUI-LTXVideo && \
    git clone https://github.com/kijai/ComfyUI-KJNodes && \
    git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite && \
    git clone https://github.com/Fannovel16/comfyui_controlnet_aux && \
    # Ноды для воркфлоу Geeky Ghost
    git clone https://github.com/GeekyGhost/ComfyUI-Wav2Lip && \
    cd ComfyUI-Wav2Lip && pip3 install -r requirements.txt && cd .. && \
    git clone https://github.com/GeekyGhost/ComfyUI-GeekyRemB && \
    git clone https://github.com/Gourieff/comfyui-reactor-node && \
    cd comfyui-reactor-node && pip3 install -r requirements.txt && cd .. && \
    git clone https://github.com/rocketing/ComfyUI_IF_AI_HF_Pipeline && \
    cd ComfyUI_IF_AI_HF_Pipeline && pip3 install -r requirements.txt && cd .. && \
    git clone https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet && \
    git clone https://github.com/Kosinkadink/ComfyUI-AnimateDiff-Evolved && \
    cd ComfyUI-AnimateDiff-Evolved && pip3 install -r requirements.txt && cd .. && \
    git clone https://github.com/rgthree/rgthree-comfy && \
    git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack && \
    cd ComfyUI-Impact-Pack && python3 install.py && pip3 install -r requirements.txt && cd .. && \
    git clone https://github.com/Fannovel16/ComfyUI-Frame-Interpolation && \
    cd ComfyUI-Frame-Interpolation && pip3 install -r requirements.txt && cd .. && \
    git clone https://github.com/chrisgoringe/ComfyUI-TextInput && \
    git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus

COPY start.sh /start.sh
RUN chmod +x /start.sh

WORKDIR /ComfyUI
EXPOSE 8188
CMD ["/start.sh"]
