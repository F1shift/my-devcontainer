FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

USER root

# Install common dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    software-properties-common \
    lsb-release \
    chromium \
    curl \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js (for Gemini CLI)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g @google/gemini-cli

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/

# Configure for the 'vscode' user (default devcontainer user)
USER vscode
WORKDIR /home/vscode

# Install GitHub Spec Kit (Specify CLI)
# RUN uv tool install specify-cli --from git+https://github.com/github/spec-kit.git

CMD ["/bin/bash"]
