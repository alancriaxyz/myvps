#!/bin/bash

# MyVPS Configuration Settings
# This file contains the configuration variables used throughout the project

# Email configuration
EMAIL=""

# Function to prompt for email
prompt_email() {
    local max_attempts=3
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        read -p "Enter your email for SSL certificates: " EMAIL
        if [[ "$EMAIL" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
            return 0
        fi
        echo "Invalid email format. Please try again. (Attempt $attempt of $max_attempts)"
        ((attempt++))
    done
    
    echo "Maximum attempts reached. Please try again later."
    exit 1
}

# Function to save settings
save_settings() {
    mkdir -p config
    cat > "config/settings.sh" << EOF
#!/bin/bash

# MyVPS Configuration Settings
EMAIL="$EMAIL"
EOF
}

# Function to replace variables in a file
replace_variables() {
    local file="$1"
    local temp_file=$(mktemp)
    
    # Replace email in the file
    sed "s/seuemail@example.com/$EMAIL/g" "$file" > "$temp_file"
    
    # Move the temporary file back to the original
    mv "$temp_file" "$file"
}

# Function to configure all files
configure_files() {
    # Configure Traefik docker-compose.yml
    if [ -f "services/traefik/docker-compose.yml" ]; then
        replace_variables "services/traefik/docker-compose.yml"
    fi
} 