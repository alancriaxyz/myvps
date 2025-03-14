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

# Save current directory
CURRENT_DIR=$(pwd)

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
log_info "Current directory before clone: $(pwd)"
if git clone https://github.com/alancriaxyz/myvps.git; then
    log_info "Clone successful"
    log_info "Directory contents after clone:"
    ls -la
else
    log_error "Failed to clone repository"
    exit 1
fi

# Cleanup
cd /
rm -rf "$TEMP_DIR"

log_info "Installation completed successfully!"
log_info "Please reboot your system to apply all changes." 