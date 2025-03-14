#!/bin/bash

# MyVPS Configuration Settings
# This file contains the configuration variables used throughout the project

# Email configuration
EMAIL=""

# Function to prompt for email
prompt_email() {
    local max_attempts=3
    local attempt=1
    
    echo "Please enter a valid email address (e.g., user@example.com)"
    echo "The email will be used for SSL certificates and notifications"
    
    while [ $attempt -le $max_attempts ]; do
        read -p "Enter your email: " EMAIL
        # Validação simplificada de email
        if [[ "$EMAIL" == *"@"*"."* ]]; then
            echo "Email accepted: $EMAIL"
            return 0
        fi
        echo "Invalid email format. Please enter a valid email address (e.g., user@example.com)"
        echo "Attempt $attempt of $max_attempts"
        echo "You entered: $EMAIL"
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