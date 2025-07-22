ARG PYTHON_VERSION=3.13.5
FROM python:${PYTHON_VERSION}-slim as base

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# System dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    curl \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# Install dependencies including uv and uvicorn
RUN python -m pip install --upgrade pip && \
    pip install uv

# Copy application code
COPY . .

# Expose the app port
EXPOSE 8009

# Switch to non-privileged user
# USER appuser

# Run the application
CMD ["uv", "run", "uvicorn", "app.main:app", "--reload", "--port", "8001", "--host", "0.0.0.0"]