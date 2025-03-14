#!/bin/bash

# Traefik Installation Script
# This script creates the necessary files and starts the Traefik service

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

# Create acme.json file
log_info "Creating acme.json file..."
touch acme.json
chmod 600 acme.json

# Start Traefik
log_info "Starting Traefik service..."
docker-compose up -d

# Check if Traefik is running
if docker ps | grep -q traefik; then
    log_info "Traefik is running successfully!"
    log_info "You can access the dashboard at http://your-server-ip:8080"
else
    log_error "Failed to start Traefik. Please check the logs with: docker-compose logs traefik"
    exit 1
fi 