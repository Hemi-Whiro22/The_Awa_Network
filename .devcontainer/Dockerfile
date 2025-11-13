FROM mcr.microsoft.com/devcontainers/python:3.11

# Install system deps if needed
RUN apt-get update && apt-get install -y \
    libpq-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*
# Install any needed packages specified in requirements.txt
COPY requirements.txt /tmp/pip-tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/pip-tmp/requirements.txt \
    && rm -rf /tmp/pip-tmp
# Install additional VS Code extensions
RUN code --install-extension ms-python.python \
    && code --install-extension ms-python.vscode-pylance \
    && code --install-extension ms-azuretools.vscode-docker
# --- IGNORE ---