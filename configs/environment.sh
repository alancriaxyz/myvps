#!/bin/bash

# Configuration Setup Script
# This script handles environment configuration and variable replacement

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Config file path
CONFIG_FILE="/root/myvps/.env"

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

# Load existing configuration
load_config() {
    # Create or load the config file
    if [ ! -f "$CONFIG_FILE" ]; then
        log_info "Creating new config file: $CONFIG_FILE"
        echo "# MyVPS Configuration" > "$CONFIG_FILE"
        echo "MYVPS_EMAIL=" >> "$CONFIG_FILE"
        echo "MYVPS_DOMAIN=" >> "$CONFIG_FILE"
        chmod 600 "$CONFIG_FILE"
    else
        log_info "Loading existing configuration from $CONFIG_FILE"
    fi

    # Load the configuration
    source "$CONFIG_FILE"
}

# Save configuration
save_config() {
    log_info "Saving configuration to $CONFIG_FILE"
    echo "MYVPS_EMAIL=$MYVPS_EMAIL" > "$CONFIG_FILE"
    echo "MYVPS_DOMAIN=$MYVPS_DOMAIN" >> "$CONFIG_FILE"
    chmod 600 "$CONFIG_FILE"
}

# Configuration functions
prompt_email() {
    # Check if email is already set from config file
    if [ -n "${MYVPS_EMAIL:-}" ]; then
        log_info "Using existing email: $MYVPS_EMAIL"
        return 0
    fi

    # Check if any containers are running
    if docker ps -q &> /dev/null; then
        log_error "Containers are running but no email configuration found. This shouldn't happen!"
        exit 1
    fi

    echo "Please enter your email address for SSL certificates and notifications"
    read -p "Email: " email_input
    
    # Simple email validation
    if [[ "$email_input" == *"@"*"."* ]]; then
        echo "Email accepted: $email_input"
        # Export to environment
        export MYVPS_EMAIL="$email_input"
        log_info "Email variable exported: $MYVPS_EMAIL"
        return 0
    fi
    log_error "Invalid email format. Please try again."
    prompt_email
}

prompt_domain() {
    # Check if domain is already set from config file
    if [ -n "${MYVPS_DOMAIN:-}" ]; then
        log_info "Using existing domain: $MYVPS_DOMAIN"
        return 0
    fi

    # Check if any containers are running
    if docker ps -q &> /dev/null; then
        log_error "Containers are running but no domain configuration found. This shouldn't happen!"
        exit 1
    fi

    echo "Please enter your domain (e.g., yourdomain.com)"
    read -p "Domain: " domain_input
    
    # Simple domain validation
    if [[ "$domain_input" =~ ^[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}$ ]]; then
        echo "Domain accepted: $domain_input"
        # Export to environment
        export MYVPS_DOMAIN="$domain_input"
        log_info "Domain variable exported: $MYVPS_DOMAIN"
        return 0
    fi
    log_error "Invalid domain format. Please try again."
    prompt_domain
}

replace_variables() {
    local file="$1"
    local temp_file=$(mktemp)
    
    log_info "Configuring file: $file"
    
    # Replace email and domain in the file
    sed -e "s/seuemail@example.com/$MYVPS_EMAIL/g" \
        -e "s/DOMAIN_PLACEHOLDER/$MYVPS_DOMAIN/g" \
        "$file" > "$temp_file"
    
    # Move the temporary file back to the original
    mv "$temp_file" "$file"
    log_info "File configured successfully: $file"
}

configure_files() {
    log_info "Starting configuration process..."
    
    # Configure Traefik docker-compose.yml
    local traefik_compose="/root/myvps/services/traefik/docker-compose.yml"
    if [ -f "$traefik_compose" ]; then
        replace_variables "$traefik_compose"
    else
        log_warn "Traefik compose file not found: $traefik_compose"
    fi

    # Configure Portainer docker-compose.yml
    local portainer_compose="/root/myvps/services/portainer/docker-compose.yml"
    if [ -f "$portainer_compose" ]; then
        replace_variables "$portainer_compose"
    else
        log_warn "Portainer compose file not found: $portainer_compose"
    fi

    # Configure WAHA docker-compose.yml if exists
    local waha_compose="/root/myvps/services/waha/docker-compose.yml"
    if [ -f "$waha_compose" ]; then
        replace_variables "$waha_compose"
    else
        log_warn "WAHA compose file not found: $waha_compose"
    fi
}

# Main execution
log_info "Starting configuration setup..."

# Load existing configuration
load_config

# Prompt for configuration details
prompt_email
prompt_domain

# Save configuration for future use
save_config

# Configure files with the provided settings
configure_files

log_info "Configuration setup completed successfully!" 