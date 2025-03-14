#!/bin/bash

# Docker Installation Script
# This script handles the installation of Docker and Docker Compose

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

install_docker() {
    if ! command -v docker &> /dev/null; then
        log_info "Installing Docker..."
        
        # Add Docker's official GPG key
        apt-get install -y ca-certificates curl gnupg
        install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        chmod a+r /etc/apt/keyrings/docker.gpg

        # Add the repository to Apt sources
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
          $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
          tee /etc/apt/sources.list.d/docker.list > /dev/null

        # Install Docker Engine
        apt-get update # Necessário após adicionar novo repositório
        apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

        # Start and enable Docker service
        systemctl start docker
        systemctl enable docker

        if command -v docker &> /dev/null; then
            log_info "Docker installed successfully"
        else
            log_error "Failed to install Docker"
            exit 1
        fi
    else
        log_info "Docker is already installed"
    fi
}

install_docker_compose() {
    if ! command -v docker compose &> /dev/null; then
        log_info "Installing Docker Compose..."
        
        # Docker Compose is now included in docker-compose-plugin
        if command -v docker compose &> /dev/null; then
            log_info "Docker Compose installed successfully"
        else
            log_error "Failed to install Docker Compose"
            exit 1
        fi
    else
        log_info "Docker Compose is already installed"
    fi
}

# Main execution
install_docker
install_docker_compose

# Verify installations
docker --version
docker compose version
