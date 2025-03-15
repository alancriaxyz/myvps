#!/bin/bash

# Portainer Installation Script
# This script creates the necessary files and starts the Portainer service

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

# Check if Portainer is already running
if docker ps --format '{{.Names}}' | grep -q "^portainer$"; then
    log_warn "Portainer is already running"
    log_info "Skipping installation..."
    exit 0
fi

# Create data directory if it doesn't exist
log_info "Creating data directory..."
mkdir -p /root/myvps/services/portainer/data

# Start Portainer
log_info "Starting Portainer service..."
cd /root/myvps/services/portainer
docker compose up -d

# Check if containers are running
if [ $? -eq 0 ]; then
    log_info "Portainer has been successfully started!"
    log_info "You can access it at: https://portainer.${MYVPS_DOMAIN}"
    log_warn "Please make sure your DNS is properly configured to point to your server's IP address."
else
    log_error "Failed to start Portainer containers"
    exit 1
fi 