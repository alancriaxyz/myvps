#!/bin/bash

# VPS Bootstrap - Firewall Configuration Script
# This script configures UFW (Uncomplicated Firewall) with basic security rules
# for a Debian-based system.

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

# Install UFW if not already installed
if ! command -v ufw >/dev/null 2>&1; then
    log_info "Installing UFW..."
    apt-get update
    apt-get install -y ufw
else
    log_info "UFW is already installed"
fi

# Configure UFW
log_info "Configuring firewall rules..."

# Reset UFW to default state
ufw --force reset

# Set default policies
ufw default deny incoming
ufw default allow outgoing

# Allow SSH (important to do this first to avoid lockout)
ufw allow ssh

# Allow HTTP and HTTPS
ufw allow 80/tcp
ufw allow 443/tcp

# Enable UFW
ufw --force enable

# Show status
log_info "Firewall status:"
ufw status verbose

log_info "Firewall configuration completed successfully!" 