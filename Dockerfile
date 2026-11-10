# Production-ready Docker container for MetaFlow (Encrypted Traffic Classifier)
FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PORT=8600

WORKDIR /app

# System dependencies (libpcap for Scapy)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpcap-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# App code, models, data and the web frontend
COPY src/ ./src/
COPY models/ ./models/
COPY data/processed/ ./data/processed/
COPY data/sample_pcaps/ ./data/sample_pcaps/
COPY reports/ ./reports/
COPY web/ ./web/
COPY README.md .

EXPOSE 8600

CMD ["python", "web/server.py"]