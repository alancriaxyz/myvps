#!/bin/bash

# VPS Bootstrap - Uninstaller Script
# ATENÇÃO: Este script remove o Docker, Git e todos os arquivos do projeto

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
echo "  - Docker e todos os containers"
echo "  - Docker Compose"
echo "  - Git"
echo "  - Todos os arquivos do projeto"
echo ""
read -p "Você tem certeza que deseja continuar? (digite 'sim' para confirmar) " confirmation

if [ "$confirmation" != "sim" ]; then
    log_info "Operação cancelada pelo usuário"
    exit 0
fi

# Remover Docker e containers usando o script específico
log_info "Removendo Docker e todos os containers..."
bash services/docker/uninstall.sh

# Remover Git usando o script específico
log_info "Removendo Git..."
bash services/git/uninstall.sh

# Remover diretório do projeto
log_info "Removendo diretório do projeto..."
cd ..
rm -rf /root/myvps

# Limpar pacotes não utilizados
log_info "Limpando pacotes não utilizados..."
apt-get autoremove -y
apt-get clean

log_info "Desinstalação concluída com sucesso!"
log_warn "Recomenda-se reiniciar o sistema para aplicar todas as alterações." 