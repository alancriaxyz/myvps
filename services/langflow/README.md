# Langflow Service

Langflow is an UI for LangChain, designed to provide an easy way to prototype and create LangChain flows using a drag and drop interface.

## Features

- Drag and drop interface for LangChain components
- Visual flow builder
- Easy integration with various LLM models
- Automatic SSL/TLS with Traefik
- Persistent data storage

## Prerequisites

- Docker and Docker Compose installed
- Traefik reverse proxy running
- Domain name configured

## Installation

To install Langflow, run the installation script with your domain name:

```bash
./services/langflow/install.sh yourdomain.com
```

This will:
1. Create necessary data directories
2. Pull the latest Langflow Docker image
3. Start the service with Traefik integration
4. Configure SSL/TLS certificates automatically

## Access

After installation, Langflow will be available at:
```
https://langflow.yourdomain.com
```

## Configuration

The service is configured through environment variables in the docker-compose.yml file:

- `LANGFLOW_AUTO_LOGIN`: Disable/enable automatic login (default: false)
- `LANGFLOW_HOST`: Host binding (default: 0.0.0.0)
- `LANGFLOW_PORT`: Internal port (default: 7860)

## Data Persistence

All Langflow data is stored in a Docker volume named `langflow_data` for persistence across container restarts. 