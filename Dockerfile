FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04

# Install Python and dependencies (including OpenCV requirements)
RUN apt-get update && apt-get install -y \
    python3-pip git curl wget \
    libgl1-mesa-glx libglib2.0-0 libsm6 libxext6 libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone Wan2GP
RUN git clone https://github.com/deepbeepmeep/Wan2GP.git /app
WORKDIR /app

# Install Python dependencies
RUN pip install torch==2.6.0 torchvision torchaudio --index-url https://download.pytorch.org/whl/test/cu124
RUN pip install -r requirements.txt

# Create a simple health check script
RUN echo '#!/bin/bash\ncurl -f http://localhost:7860/ > /dev/null 2>&1 && echo "Service is ready" || exit 1' > /app/health_check.sh
RUN chmod +x /app/health_check.sh

# Expose necessary port
EXPOSE 7860

# Add health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=300s --retries=5 \
    CMD /app/health_check.sh

# Create startup script with better error handling
RUN echo '#!/bin/bash\n\
echo "Starting Wan2GP server..."\n\
echo "GPU Info:"\n\
nvidia-smi\n\
echo "Starting server on 0.0.0.0:7860"\n\
python3 wgp.py --i2v-14B --frames 49 --steps 20 --server-name 0.0.0.0 --server-port 7860 --share\n\
' > /app/start.sh

RUN chmod +x /app/start.sh

# Start the application
CMD ["/app/start.sh"]
