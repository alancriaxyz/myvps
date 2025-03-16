#!/bin/bash

# Verifica se as variáveis necessárias estão definidas
if [ -z "$DOMAIN" ]; then
    echo "Error: DOMAIN environment variable is not set"
    exit 1
fi

# Verifica se o container já está rodando
if [ "$(docker ps -q -f name=waha)" ]; then
    echo "Error: Container 'waha' is already running"
    exit 1
fi

if [ -z "$API_KEY" ]; then
    # Gera uma API key se não foi fornecida
    API_KEY=$(openssl rand -hex 32)
    echo "Generated new API key: $API_KEY"
fi

# Cria diretório de dados se não existir
mkdir -p data

# Substitui as variáveis no docker-compose
sed -i.bak "s/your-api-key-here/$API_KEY/g" docker-compose.yml
sed -i.bak "s/DOMAIN_PLACEHOLDER/$DOMAIN/g" docker-compose.yml

# Remove o arquivo de backup
rm -f docker-compose.yml.bak

# Inicia os containers
docker compose up -d

echo "WAHA installation completed!"
echo "Your WAHA instance is available at: https://waha.$DOMAIN"
echo "API Key: $API_KEY"