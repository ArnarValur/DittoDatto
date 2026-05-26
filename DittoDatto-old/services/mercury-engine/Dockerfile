# MercuryEngine V2 — Multi-stage Docker build
# Uses uv for fast, reproducible dependency installation
#
# Build: docker build -t mercury-engine .
# Run:   docker run -p 5002:5002 mercury-engine

FROM python:3.11-slim AS builder

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

WORKDIR /app

# Install dependencies first (cache layer)
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-dev --no-install-project

# Copy source
COPY src/ src/
RUN uv sync --frozen --no-dev

# --- Production stage ---
FROM python:3.11-slim

WORKDIR /app
COPY --from=builder /app /app

ENV PATH="/app/.venv/bin:$PATH"
ENV MERCURY_ENVIRONMENT=production
EXPOSE 5002

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5002/health')" || exit 1

CMD ["uvicorn", "mercury_engine.main:app", "--host", "0.0.0.0", "--port", "5002"]
