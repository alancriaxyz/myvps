#!/bin/bash

# Repository Clone Script
# This script handles cloning and updating the MyVPS repository

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

# Clone or update repository
clone_repository() {
    log_info "Cloning MyVPS repository..."

    # Check if myvps directory exists
    if [ -d "myvps" ]; then
        log_warn "Directory 'myvps' already exists. Updating it..."
        cd myvps
        if git pull origin main; then
            log_info "Repository updated successfully"
            cd ..
        else
            log_error "Failed to update repository"
            cd ..
            exit 1
        fi
    else
        if git clone https://github.com/alancriaxyz/myvps.git; then
            log_info "Clone successful"
        else
            log_error "Failed to clone repository"
            exit 1
        fi
    fi
}

# Main execution
clone_repository 