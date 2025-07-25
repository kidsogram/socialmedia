FROM pytorch/pytorch:2.2.1-cuda12.1-cudnn8-runtime

# Install dependencies
RUN apt-get update && apt-get install -y git ffmpeg && \
    git clone https://github.com/deepbeepmeep/Wan2GP.git /Wan2GP && \
    cd /Wan2GP && \
    pip install --no-cache-dir -r requirements.txt

WORKDIR /Wan2GP

ENTRYPOINT ["python", "wgp.py"]
