# --- Build stage: install dependencies ---
FROM python:3.14-slim AS builder

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# --- Final stage: minimal runtime image ---
FROM python:3.14-slim

# Run as a non-root user — a real security expectation, not a formality;
# Trivy and most container security scanners flag root-user images.
RUN useradd --create-home --shell /bin/bash appuser

# Pick up OS security fixes published after the base image was built (the
# Trivy gate flagged zlib1g), and remove pip/setuptools: the app does not need
# them at runtime, and they carry bundled libraries that scanners flag.
RUN apt-get update \
 && apt-get upgrade -y --no-install-recommends \
 && rm -rf /var/lib/apt/lists/* \
 && python -m pip uninstall -y pip setuptools wheel
WORKDIR /app

COPY --from=builder /root/.local /home/appuser/.local
COPY main.py .

RUN chown -R appuser:appuser /app
USER appuser
ENV PATH=/home/appuser/.local/bin:$PATH

EXPOSE 3000
CMD ["gunicorn", "--bind", "0.0.0.0:3000", "main:app"]
