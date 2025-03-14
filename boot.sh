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

# Save current directory
CURRENT_DIR=$(pwd)

# Create temporary directory
TEMP_DIR=$(mktemp -d)
log_info "Created temporary directory: $TEMP_DIR"
cd "$TEMP_DIR"
log_info "Current directory: $(pwd)"

# Update system and install git
log_info "Updating system packages..."
apt-get update
apt-get upgrade -y

# Install git if not installed
if ! command -v git &> /dev/null; then
    log_info "Installing git..."
    apt-get install -y git
fi

# Clone repository
log_info "Cloning MyVPS repository..."
git clone https://github.com/alancriaxyz/myvps.git
log_info "Repository cloned. Current directory contents:"
ls -la

# Copy entire myvps directory
log_info "Copying myvps directory..."
cp -r myvps "$CURRENT_DIR/"
log_info "Directory copied successfully"

# # Load configuration functions
# if [ -f "myvps/config/settings.sh" ]; then
#     # Define as funções diretamente aqui para evitar problemas com source
#     prompt_email() {
#         echo "Please enter your email address for SSL certificates and notifications"
#         read -p "Email: " MYVPS_EMAIL
        
#         # Validação simplificada de email
#         if [[ "$MYVPS_EMAIL" == *"@"*"."* ]]; then
#             echo "Email accepted: $MYVPS_EMAIL"
#             export MYVPS_EMAIL
#             return 0
#         fi
#         echo "Invalid email format. Please try again."
#         prompt_email
#     }

#     save_settings() {
#         mkdir -p myvps/config
#         cat > "myvps/config/settings.sh" << EOF
# #!/bin/bash

# # MyVPS Configuration Settings
# export MYVPS_EMAIL="$MYVPS_EMAIL"
# EOF
#     }

#     replace_variables() {
#         local file="$1"
#         local temp_file=$(mktemp)
        
#         # Replace email in the file
#         sed "s/seuemail@example.com/$MYVPS_EMAIL/g" "$file" > "$temp_file"
        
#         # Move the temporary file back to the original
#         mv "$temp_file" "$file"
#     }

#     configure_files() {
#         # Configure Traefik docker-compose.yml
#         if [ -f "myvps/services/traefik/docker-compose.yml" ]; then
#             replace_variables "myvps/services/traefik/docker-compose.yml"
#         fi
#     }
# else
#     log_error "Configuration file not found"
#     exit 1
# fi

# # Prompt for configuration
# log_info "Please provide configuration details..."
# prompt_email
# save_settings

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

# Cleanup
cd /
rm -rf "$TEMP_DIR"

log_info "Installation completed successfully!"
log_info "Please reboot your system to apply all changes." 