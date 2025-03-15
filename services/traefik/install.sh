#!/bin/bash

# Traefik Installation Script
# This script creates the necessary files and starts the Traefik service

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

# Check if Traefik is already running
if docker ps --format '{{.Names}}' | grep -q "^traefik$"; then
    log_warn "Traefik is already running"
    log_info "Skipping installation..."
    exit 0
fi

# Check if acme.json exists
if [ ! -f "/root/myvps/acme.json" ]; then
    log_info "Creating acme.json file..."
    touch /root/myvps/acme.json
    chmod 600 /root/myvps/acme.json
fi

# Start Traefik
log_info "Starting Traefik service..."
cd /root/myvps/services/traefik
docker compose up -d

# Check if containers are running
if [ $? -eq 0 ]; then
    log_info "Traefik has been successfully started!"
else
    log_error "Failed to start Traefik containers"
    exit 1
fi 