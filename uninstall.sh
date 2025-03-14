#!/bin/bash

# VPS Bootstrap - Uninstaller Script
# WARNING: This script removes Docker, Git and all project files

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

# User confirmation
log_warn "WARNING! This script will remove:"
echo "  - Docker and all containers"
echo "  - Docker Compose"
echo "  - Git"
echo "  - All project files"
echo ""
read -p "Are you sure you want to continue? (type 'yes' to confirm): " confirmation

if [ "$confirmation" != "yes" ]; then
    log_info "Operation cancelled by user"
    exit 0
fi

# Remove Docker and containers using specific script
log_info "Removing Docker and all containers..."
bash services/docker/uninstall.sh

# Remove Git using specific script
log_info "Removing Git..."
bash services/git/uninstall.sh

# Remove project directory
log_info "Removing project directory..."
cd ..
rm -rf /root/myvps

# Clean unused packages
log_info "Cleaning unused packages..."
apt-get autoremove -y
apt-get clean

log_info "Uninstallation completed successfully!"
log_warn "It is recommended to reboot your system to apply all changes." 