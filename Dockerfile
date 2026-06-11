FROM pytorch/pytorch:2.6.0-cuda12.4-cudnn9-runtime

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git wget python3 python3-pip \
    libgl1 libglib2.0-0 \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Установка точной версии kornia и других зависимостей
RUN pip3 install kornia==0.7.3 \
    imageio-ffmpeg \
    matplotlib \
    opencv-python-headless

RUN git clone https://github.com/comfyanonymous/ComfyUI /ComfyUI && \
    cd /ComfyUI && \
    pip3 install -r requirements.txt && \
    pip3 install sqlalchemy gdown

# Клонирование и установка кастомных нод с их зависимостями
RUN cd /ComfyUI/custom_nodes && \
    git clone https://github.com/kijai/ComfyUI-LTXVideo && \
    cd ComfyUI-LTXVideo && pip3 install -r requirements.txt && cd .. && \
    git clone https://github.com/kijai/ComfyUI-KJNodes && \
    git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite && \
    cd ComfyUI-VideoHelperSuite && pip3 install -r requirements.txt && cd .. && \
    git clone https://github.com/Fannovel16/comfyui_controlnet_aux && \
    cd comfyui_controlnet_aux && pip3 install -r requirements.txt && cd .. && \
    # Дополнительные ноды для LTX ID-LoRA воркфлоу
    git clone https://github.com/chrisgoringe/ComfyUI-TextInput && \
    git clone https://github.com/rgthree/rgthree-comfy && \
    git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus && \
    git clone https://github.com/rocketing/ComfyUI_IF_AI_HF_Pipeline && \
    cd ComfyUI_IF_AI_HF_Pipeline && pip3 install -r requirements.txt && cd ..

COPY start.sh /start.sh
RUN chmod +x /start.sh

WORKDIR /ComfyUI
EXPOSE 8188
CMD ["/start.sh"]
