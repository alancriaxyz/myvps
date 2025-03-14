#!/bin/bash

# Git Uninstall Script
# Este script remove o Git e suas configurações

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
echo "  - Git"
echo "  - Configurações globais do Git"
echo "  - Cache e objetos temporários do Git"
echo ""
read -p "Você tem certeza que deseja continuar? (digite 'sim' para confirmar) " confirmation

if [ "$confirmation" != "sim" ]; then
    log_info "Operação cancelada pelo usuário"
    exit 0
fi

# Verificar se o Git está instalado
if command -v git &> /dev/null; then
    # Remover configurações globais do Git
    log_info "Removendo configurações globais do Git..."
    rm -f /root/.gitconfig 2>/dev/null || true
    rm -rf /root/.git 2>/dev/null || true

    # Remover pacote Git
    log_info "Removendo pacote Git..."
    apt-get remove --purge -y git

    # Limpar cache e objetos temporários
    log_info "Limpando cache e objetos temporários..."
    rm -rf /root/.git* 2>/dev/null || true
    
    # Limpar pacotes não utilizados
    log_info "Limpando pacotes não utilizados..."
    apt-get autoremove -y
    apt-get clean
else
    log_warn "Git não está instalado no sistema"
fi

log_info "Git foi completamente removido do sistema!" 