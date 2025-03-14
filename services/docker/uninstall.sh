#!/bin/bash

# Docker Uninstall Script
# This script removes Docker and all its components

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

# Stop all running containers
if command -v docker &> /dev/null; then
    log_info "Stopping all containers..."
    docker container stop $(docker container ls -aq) 2>/dev/null || true

    # Remove all Docker resources
    log_info "Removing all Docker resources (containers, images, volumes, networks)..."
    docker system prune -af --volumes

    # Remove Docker packages
    log_info "Removing Docker packages..."
    apt-get remove --purge -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

    # Remove Docker directories and files
    log_info "Removing Docker directories and files..."
    rm -rf /var/lib/docker
    rm -rf /var/lib/containerd
    rm -rf /etc/docker
    rm -f /etc/apt/keyrings/docker.gpg
    rm -f /etc/apt/sources.list.d/docker.list

    # Remove docker group
    log_info "Removing docker group..."
    groupdel docker 2>/dev/null || true

    # Clean unused packages
    log_info "Cleaning unused packages..."
    apt-get autoremove -y
    apt-get clean

    # Update apt cache after removing repository
    log_info "Updating apt cache..."
    apt-get update
else
    log_warn "Docker is not installed on the system"
fi

log_info "Docker has been completely removed from the system!" 