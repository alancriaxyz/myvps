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

# Create data directory if it doesn't exist
info "Creating data directory..."
mkdir -p data/langflow

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