# Use official lightweight Python image
FROM python:3.13-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    LC_ALL=en_NZ.UTF-8 \
    LANG=en_NZ.UTF-8

# Install system packages needed by Pillow & PostgreSQL
RUN apt-get update && apt-get install -y \
    build-essential \
    libjpeg-dev \
    zlib1g-dev \
    libpng-dev \
    libfreetype6-dev \
    locales \
    && locale-gen en_NZ.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy backend files
COPY backend/requirements.txt .

# Install dependencies (upgrade pip to avoid build issues)
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Copy the rest of your code
COPY backend .

# Expose FastAPI port
EXPOSE 8000

# Run the app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
