#!/bin/bash

# Source the utils file
source ./scripts/utils.sh

# Check if domain is provided
if [ -z "$1" ]; then
    error "Please provide a domain name as the first argument"
    info "Usage: $0 <domain>"
    exit 1
fi

# Set domain
export DOMAIN=$1

# Check if Traefik is running
if ! docker network inspect traefik-public >/dev/null 2>&1; then
    error "Traefik network not found. Please install Traefik first"
    info "Run: ./services/traefik/install.sh"
    exit 1
fi

# Check if Langflow is already running
if docker ps --format '{{.Names}}' | grep -q "^langflow$"; then
    warn "Langflow is already running"
    info "To recreate, first remove the existing container:"
    info "docker compose -f services/langflow/docker-compose.yml down"
    exit 0
fi

# Create data directory if it doesn't exist
if [ ! -d "data/langflow" ]; then
    info "Creating data directory..."
    mkdir -p data/langflow
fi

# Pull the latest images
info "Pulling latest images..."
docker-compose -f services/langflow/docker-compose.yml pull

# Start the containers
info "Starting Langflow..."
docker-compose -f services/langflow/docker-compose.yml up -d

# Check if containers are running
if [ $? -eq 0 ]; then
    success "Langflow has been successfully installed!"
    info "You can access it at: https://langflow.${DOMAIN}"
else
    error "Failed to start Langflow containers"
    exit 1
fi 