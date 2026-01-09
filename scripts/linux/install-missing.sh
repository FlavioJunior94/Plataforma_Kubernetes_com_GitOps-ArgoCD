#!/bin/bash

# Script rápido para instalar apenas as ferramentas que estão faltando
# Execute com sudo

set -e

echo "🔧 Instalando ferramentas faltantes..."
echo "====================================="

# Verificar se está rodando como root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Execute com sudo: sudo ./install-missing.sh"
    exit 1
fi

MISSING_TOOLS=()

# Verificar e instalar kubectl
if ! command -v kubectl &> /dev/null; then
    echo "☸️  Instalando kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
    echo "✅ kubectl instalado!"
    MISSING_TOOLS+=("kubectl")
fi

# Verificar e instalar Kind
if ! command -v kind &> /dev/null; then
    echo "🎯 Instalando Kind..."
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
    chmod +x ./kind
    mv ./kind /usr/local/bin/kind
    echo "✅ Kind instalado!"
    MISSING_TOOLS+=("kind")
fi

# Verificar e instalar Helm
if ! command -v helm &> /dev/null; then
    echo "⛵ Instalando Helm..."
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    echo "✅ Helm instalado!"
    MISSING_TOOLS+=("helm")
fi

# Verificar Docker
if ! command -v docker &> /dev/null; then
    echo "🐳 Instalando Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    usermod -aG docker $SUDO_USER
    systemctl enable docker
    systemctl start docker
    rm get-docker.sh
    echo "✅ Docker instalado!"
    MISSING_TOOLS+=("docker")
fi

echo ""
if [ ${#MISSING_TOOLS[@]} -eq 0 ]; then
    echo "✅ Todas as ferramentas já estavam instaladas!"
else
    echo "✅ Ferramentas instaladas: ${MISSING_TOOLS[*]}"
fi

echo ""
echo " Próximos passos:"
echo "   1. Executar: ./check-prerequisites.sh"
echo "   2. Executar: make setup-complete"