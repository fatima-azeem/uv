# === Stage 1: Build dependencies (heavy stuff)
ARG PYTHON_VERSION=3.13.5
FROM python:${PYTHON_VERSION}-slim as build

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /app

# Use a faster Debian mirror (optional, adjust for your region)
RUN sed -i 's|http://deb.debian.org|http://ftp.fr.debian.org|g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        gcc \
        curl \
        libffi-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install uv globally
RUN python -m pip install --upgrade pip && \
    pip install --no-cache-dir uv

# Copy project code for dependency resolution if needed
COPY . .

# === Stage 2: Final runtime image (slim + fast)
FROM python:${PYTHON_VERSION}-slim as final

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Copy uv from builder stage (if needed)
COPY --from=build /usr/local /usr/local
COPY --from=build /app /app

# Expose app port
EXPOSE 8001

# CMD to run app
CMD ["uv", "run", "uvicorn", "app.main:app", "--reload", "--port", "8001", "--host", "0.0.0.0"]
