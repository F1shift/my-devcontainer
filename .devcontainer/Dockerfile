FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

USER root
ENV TZ="TZ:Asia/Tokyo"

# Install common dependencies
RUN apt-get update && apt-get install -y \
    curl \
    less \
    git \
    procps \
    sudo \
    zsh \
    man-db \
    unzip \
    gnupg2 \
    gh \
    iptables \
    ipset \
    iproute2 \
    iputils-ping \
    dnsutils \
    aggregate \
    jq \
    vim \
    libreoffice \
    poppler-utils \
    fonts-noto-cjk \
    fonts-ipafont \
    fonts-takao-gothic \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libxkbcommon0 \
    libatspi2.0-0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libgbm1 \
    libasound2t64 \
    software-properties-common \
    lsb-release \
    chromium \
    locales \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js (for Gemini CLI)
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g @google/gemini-cli

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/

# Ensure default user has access to /usr/local/share
RUN mkdir -p /usr/local/share/npm-global && chown -R vscode:vscode /usr/local/share

# Set `DEVCONTAINER` env var
ENV DEVCONTAINER=true

# Configure for the 'vscode' user (default devcontainer user)
USER vscode

# Git日本語表示を有効に
RUN git config --local core.quotepath false

WORKDIR /workspace

# Set default shell to zsh
ENV SHELL=/bin/zsh

CMD ["/bin/bash"]
