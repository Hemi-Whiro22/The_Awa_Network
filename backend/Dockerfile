FROM python:3.11-slim

# Setup locale support early
RUN apt-get update && apt-get install -y locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && echo "mi_NZ.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set locale environment variables (fallback to en_US if mi_NZ not available)
ENV LANG=mi_NZ.UTF-8
ENV LC_ALL=mi_NZ.UTF-8
ENV LANGUAGE=mi_NZ:en_US

# Set working directory
WORKDIR /app

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code and environment configuration
COPY . /app

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]