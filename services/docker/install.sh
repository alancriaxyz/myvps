#!/bin/bash

# Docker Environment Setup
# This script configures the Docker environment including:
# - Docker Engine installation
# - Docker Compose installation
# - Required system packages
# - User permissions
# - Directory structure

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    log_error "Please run as root"
    exit 1
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install essential packages for Docker
log_info "Installing essential packages..."
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common

# Install Docker if not already installed
if ! command_exists docker; then
    log_info "Installing Docker..."
    
    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Add Docker repository
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
        $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker Engine
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io

    # Add current user to docker group
    if [ -n "$SUDO_USER" ]; then
        usermod -aG docker "$SUDO_USER"
    fi
else
    log_info "Docker is already installed"
fi

# Install Docker Compose if not already installed
if ! command_exists docker-compose; then
    log_info "Installing Docker Compose..."
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
else
    log_info "Docker Compose is already installed"
fi

# Create Docker environment directories
log_info "Creating Docker environment directories..."
mkdir -p /opt/vps-bootstrap/services/docker/{compose,config,data}

# Set proper permissions
log_info "Setting proper permissions..."
chown -R root:root /opt/vps-bootstrap/services/docker
chmod -R 755 /opt/vps-bootstrap/services/docker

# Final status check
log_info "Checking Docker installation status..."
docker --version
docker-compose --version

log_info "Docker environment setup completed successfully!"
log_info "Please reboot your system to apply all changes." 