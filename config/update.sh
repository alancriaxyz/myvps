#!/bin/bash

# System Update Script
# This script handles system package updates and installations

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

# Update system packages
update_system() {
    log_info "Updating system packages..."
    apt-get update
    apt-get upgrade -y
}

# Install required packages
install_required_packages() {
    # Install git if not installed
    if ! command -v git &> /dev/null; then
        log_info "Installing git..."
        apt-get install -y git
    fi
}

# Main execution
update_system
install_required_packages 