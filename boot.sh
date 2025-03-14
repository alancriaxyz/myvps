#!/bin/bash

# VPS Bootstrap - One-Line Installer
# Este script pode ser executado com: curl -s https://raw.githubusercontent.com/alancriaxyz/myvps/main/boot.sh | sudo bash

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

# Create temporary directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Clone repository
log_info "Cloning MyVPS repository..."
git clone https://github.com/alancriaxyz/myvps.git
cd myvps

# Load configuration functions
if [ -f "config/settings.sh" ]; then
    # Carrega apenas as funções do arquivo settings.sh
    source <(grep -v '^#' config/settings.sh | grep -v '^$')
else
    log_error "Configuration file not found"
    exit 1
fi

# Prompt for configuration
log_info "Please provide configuration details..."
prompt_email
save_settings

# Configure files with the provided settings
configure_files

# Update system
log_info "Updating system packages..."
apt-get update
apt-get upgrade -y

# Install git if not installed
if ! command -v git &> /dev/null; then
    log_info "Installing git..."
    apt-get install -y git
fi

# # Make scripts executable
# chmod +x services/docker/setup/install.sh
# chmod +x services/traefik/install.sh
# chmod +x scripts/configure-firewall.sh

# # Run Docker environment setup
# log_info "Setting up Docker environment..."
# ./services/docker/setup/install.sh

# # Run Traefik setup
# log_info "Setting up Traefik..."
# ./services/traefik/install.sh

# # Run Firewall configuration script
# log_info "Configuring firewall..."
# ./scripts/configure-firewall.sh

# Cleanup
cd /
rm -rf "$TEMP_DIR"

log_info "Installation completed successfully!"
log_info "Please reboot your system to apply all changes." 