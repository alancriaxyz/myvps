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

# Update system and install git
log_info "Updating system packages..."
apt-get update
apt-get upgrade -y

# Install git if not installed
if ! command -v git &> /dev/null; then
    log_info "Installing git..."
    apt-get install -y git
fi

# Clone or update repository
bash scripts/clone.sh

# Install Docker and Docker Compose
bash services/docker/install.sh

# # Define configuration functions
# prompt_email() {
#     echo "Please enter your email address for SSL certificates and notifications"
#     read -p "Email: " email_input
    
#     # Validação simplificada de email
#     if [[ "$email_input" == *"@"*"."* ]]; then
#         echo "Email accepted: $email_input"
#         # Export directly to environment
#         export MYVPS_EMAIL="$email_input"
#         log_info "Email variable exported: $MYVPS_EMAIL"
#         return 0
#     fi
#     echo "Invalid email format. Please try again."
#     prompt_email
# }

# replace_variables() {
#     local file="$1"
#     local temp_file=$(mktemp)
    
#     # Replace email in the file
#     sed "s/seuemail@example.com/$MYVPS_EMAIL/g" "$file" > "$temp_file"
    
#     # Move the temporary file back to the original
#     mv "$temp_file" "$file"
# }

# configure_files() {
#     # Configure Traefik docker-compose.yml
#     if [ -f "myvps/services/traefik/docker-compose.yml" ]; then
#         replace_variables "myvps/services/traefik/docker-compose.yml"
#     fi
# }

# # Prompt for configuration
# log_info "Please provide configuration details..."
# prompt_email

# # Configure files with the provided settings
# configure_files

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

log_info "Installation completed successfully!"
log_info "Please reboot your system to apply all changes." 