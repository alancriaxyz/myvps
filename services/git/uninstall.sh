#!/bin/bash

# Git Uninstall Script
# This script removes Git and its configurations

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

# Check if Git is installed
if command -v git &> /dev/null; then
    # Remove global Git configurations
    log_info "Removing global Git configurations..."
    rm -f /root/.gitconfig 2>/dev/null || true
    rm -rf /root/.git 2>/dev/null || true

    # Remove Git package
    log_info "Removing Git package..."
    apt-get remove --purge -y git

    # Clean cache and temporary objects
    log_info "Cleaning cache and temporary objects..."
    rm -rf /root/.git* 2>/dev/null || true
    
    # Clean unused packages
    log_info "Cleaning unused packages..."
    apt-get autoremove -y
    apt-get clean
else
    log_warn "Git is not installed on the system"
fi

log_info "Git has been completely removed from the system!" 