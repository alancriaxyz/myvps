#!/bin/bash

# Git Installation Script
# This script handles the installation of Git

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

# Install Git if not present
install_git() {
    if ! command -v git &> /dev/null; then
        log_info "Installing git..."
        apt-get install -y git
        
        if command -v git &> /dev/null; then
            log_info "Git installed successfully"
        else
            log_error "Failed to install Git"
            exit 1
        fi
    else
        log_info "Git is already installed"
    fi
}

# Main execution
install_git 