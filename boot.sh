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

# Create temporary directory
TEMP_DIR=$(mktemp -d)
log_info "Created temporary directory: $TEMP_DIR"
cd "$TEMP_DIR"
log_info "Current directory: $(pwd)"

# Update system and install git
log_info "Updating system packages..."
apt-get update
apt-get upgrade -y

# Install git if not installed
if ! command -v git &> /dev/null; then
    log_info "Installing git..."
    apt-get install -y git
fi

# Clone repository
log_info "Cloning MyVPS repository..."
git clone https://github.com/alancriaxyz/myvps.git
log_info "Repository cloned. Current directory contents:"
ls -la

# Copy files to current directory
log_info "Copying files to current directory..."
cp -r myvps/* /root/
log_info "Files copied successfully"

# Cleanup
cd /
rm -rf "$TEMP_DIR"

log_info "Installation completed successfully!"
log_info "Please reboot your system to apply all changes." 