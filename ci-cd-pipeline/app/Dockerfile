# --- Build stage: install dependencies ---
FROM python:3.12-slim AS builder

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# --- Final stage: minimal runtime image ---
FROM python:3.12-slim

# Run as a non-root user — a real security expectation, not a formality;
# Trivy and most container security scanners flag root-user images.
RUN useradd --create-home --shell /bin/bash appuser
WORKDIR /app

COPY --from=builder /root/.local /home/appuser/.local
COPY main.py .

RUN chown -R appuser:appuser /app
USER appuser
ENV PATH=/home/appuser/.local/bin:$PATH

EXPOSE 3000
CMD ["gunicorn", "--bind", "0.0.0.0:3000", "main:app"]
