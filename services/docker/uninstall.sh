#!/bin/bash

# Docker Uninstall Script
# Este script remove o Docker e todos os seus componentes

set -euo pipefail

# Códigos de cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # Sem Cor

# Funções de log
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar se está rodando como root
if [ "$EUID" -ne 0 ]; then 
    log_error "Por favor, execute como root (sudo)"
    exit 1
fi

# Confirmação do usuário
log_warn "ATENÇÃO! Este script irá remover:"
echo "  - Docker Engine"
echo "  - Docker CLI"
echo "  - Containerd.io"
echo "  - Docker Compose Plugin"
echo "  - Todos os containers"
echo "  - Todas as imagens"
echo "  - Todos os volumes"
echo "  - Todas as redes"
echo ""
read -p "Você tem certeza que deseja continuar? (digite 'sim' para confirmar) " confirmation

if [ "$confirmation" != "sim" ]; then
    log_info "Operação cancelada pelo usuário"
    exit 0
fi

# Parar todos os containers em execução
if command -v docker &> /dev/null; then
    log_info "Parando todos os containers..."
    docker container stop $(docker container ls -aq) 2>/dev/null || true

    # Remover todos os recursos Docker
    log_info "Removendo todos os recursos Docker (containers, imagens, volumes, redes)..."
    docker system prune -af --volumes

    # Remover pacotes Docker
    log_info "Removendo pacotes Docker..."
    apt-get remove --purge -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

    # Remover diretórios Docker
    log_info "Removendo diretórios Docker..."
    rm -rf /var/lib/docker
    rm -rf /var/lib/containerd

    # Remover grupo docker
    log_info "Removendo grupo docker..."
    groupdel docker 2>/dev/null || true

    # Limpar pacotes não utilizados
    log_info "Limpando pacotes não utilizados..."
    apt-get autoremove -y
    apt-get clean
else
    log_warn "Docker não está instalado no sistema"
fi

log_info "Docker foi completamente removido do sistema!"
log_warn "Recomenda-se reiniciar o sistema para aplicar todas as alterações." 