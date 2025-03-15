#!/bin/bash

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

# Get to the script's directory
cd "$(dirname "$0")"

# Create data directory if it doesn't exist
mkdir -p data

# Check if domain is set
if [ -z "${MYVPS_DOMAIN:-}" ]; then
    log_error "Domain not set. Please run environment.sh first"
    exit 1
fi

log_info "Starting Portainer installation..."

# Deploy Portainer
docker compose up -d

log_info "Portainer has been installed successfully!"
log_info "You can access it at: https://portainer.${MYVPS_DOMAIN}"
log_warn "Please make sure your DNS is properly configured to point to your server's IP address." 