FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04

# Install Python and essential dependencies (including OpenCV dependencies)
RUN apt-get update && apt-get install -y \
    python3-pip git \
    libgl1-mesa-glx libglib2.0-0 libsm6 libxext6 libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone Wan2GP
RUN git clone https://github.com/deepbeepmeep/Wan2GP.git /app
WORKDIR /app

# Install Python dependencies
RUN pip install torch==2.6.0 torchvision torchaudio --index-url https://download.pytorch.org/whl/test/cu124
RUN pip install -r requirements.txt

# Expose necessary port
EXPOSE 7860

# Run prefetch to download model at build (optional but recommended)
RUN python3 wgp.py --i2v-1-3B --frames 1 --steps 1 --guidance 1 || true

# Start the application clearly logging output
CMD ["bash", "-c", "python3 wgp.py --i2v-14B --frames 49 --steps 20 --guidance 7 --host 0.0.0.0"]
