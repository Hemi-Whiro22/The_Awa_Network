# Use the official Python image from the Docker Hub
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy the CLI scripts and shared utilities
COPY .mauri/carver.py /app/
COPY shared/ /app/shared/

# Install any needed packages specified in requirements.txt (if any)
# RUN pip install --no-cache-dir -r requirements.txt

# Run the CLI script
CMD ["python", "carver.py"]
