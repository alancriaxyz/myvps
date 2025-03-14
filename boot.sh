#!/bin/bash

# VPS Bootstrap - One-Line Installer
# Este script pode ser executado com: curl -s https://raw.githubusercontent.com/alancriaxyz/myvps/main/boot.sh | sudo bash

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

# Update system and install git
log_info "Updating system packages..."
apt-get update
apt-get upgrade -y

# Install git if not installed
if ! command -v git &> /dev/null; then
    log_info "Installing git..."
    apt-get install -y git
fi

# Clone or update repository
log_info "Cloning/updating repository..."
REPO_URL="https://github.com/alancriaxyz/myvps.git"
INSTALL_DIR="/root/myvps/"

if [ -d "$INSTALL_DIR" ]; then
    cd "$INSTALL_DIR"
    git fetch origin
    git reset --hard origin/main
    log_info "Repository updated successfully"
else
    git clone "$REPO_URL" "$INSTALL_DIR"
    log_info "Repository cloned successfully"
fi

# Run environment configuration
log_info "Running environment configuration..."
bash /root/myvps/configs/environment.sh

# Install Docker and Docker Compose
log_info "Installing Docker and Docker Compose..."
bash /root/myvps/services/docker/install.sh

# Install and configure Traefik
log_info "Installing and configuring Traefik..."
bash /root/myvps/services/traefik/install.sh

log_info "Installation completed successfully!"
log_warn "Please reboot your system to apply all changes." 