FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04

# Install Python
RUN apt-get update && apt-get install -y python3-pip git

# Clone Wan2GP
RUN git clone https://github.com/deepbeepmeep/Wan2GP.git /app
WORKDIR /app

# Install dependencies
RUN pip install torch==2.6.0 torchvision torchaudio --index-url https://download.pytorch.org/whl/test/cu124
RUN pip install -r requirements.txt

# Expose web server port
EXPOSE 7860

# Launch WanGP web UI
CMD ["python3", "wgp.py", "--i2v-14B", "--frames", "49", "--steps", "20", "--guidance", "7", "--host", "0.0.0.0"]
