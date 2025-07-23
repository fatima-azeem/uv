# Use a build argument for Python version
ARG PYTHON_VERSION=3.13.5
FROM python:${PYTHON_VERSION}-slim as base

# Environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    DEBIAN_FRONTEND=noninteractive

# Set working directory
WORKDIR /app

# Install system dependencies in a single layer with cleanup
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gcc \
        curl \
        libffi-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip and install uv (split for better caching)
RUN python -m pip install --upgrade pip
RUN pip install uv

# Copy project files last to maximize cache reuse
COPY . .

# Expose application port
EXPOSE 8001

# Run application with uv + uvicorn
CMD ["uv", "run", "uvicorn", "app.main:app", "--reload", "--port", "8001", "--host", "0.0.0.0"]
