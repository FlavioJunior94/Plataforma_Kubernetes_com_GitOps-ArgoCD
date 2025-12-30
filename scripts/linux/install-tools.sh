#!/bin/bash

# Script para instalar automaticamente as ferramentas necessárias no Linux
# Execute com sudo ou como root

set -e

echo "🚀 Instalando ferramentas necessárias para o projeto GitOps..."
echo "============================================================"

# Verificar se está rodando como root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Este script precisa ser executado como root"
    echo "   Execute: sudo ./install-tools.sh"
    exit 1
fi

echo "✅ Executando como root"

# Detectar distribuição Linux
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
fi

echo "📋 Sistema detectado: $OS"

# Atualizar repositórios
echo "🔄 Atualizando repositórios..."
if [[ "$OS" == *"Ubuntu"* ]] || [[ "$OS" == *"Debian"* ]]; then
    apt update
elif [[ "$OS" == *"CentOS"* ]] || [[ "$OS" == *"Red Hat"* ]] || [[ "$OS" == *"Fedora"* ]]; then
    yum update -y || dnf update -y
fi

# Instalar Docker
if ! command -v docker &> /dev/null; then
    echo "🐳 Instalando Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    usermod -aG docker $SUDO_USER
    systemctl enable docker
    systemctl start docker
    rm get-docker.sh
    echo "✅ Docker instalado!"
else
    echo "✅ Docker já está instalado"
fi

# Instalar kubectl
if ! command -v kubectl &> /dev/null; then
    echo "☸️  Instalando kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
    echo "✅ kubectl instalado!"
else
    echo "✅ kubectl já está instalado"
fi

# Instalar Kind
if ! command -v kind &> /dev/null; then
    echo "🎯 Instalando Kind..."
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
    chmod +x ./kind
    mv ./kind /usr/local/bin/kind
    echo "✅ Kind instalado!"
else
    echo "✅ Kind já está instalado"
fi

# Instalar Helm
if ! command -v helm &> /dev/null; then
    echo "⛵ Instalando Helm..."
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    echo "✅ Helm instalado!"
else
    echo "✅ Helm já está instalado"
fi

echo ""
echo "============================================================"
echo "🎉 Instalação concluída!"
echo ""
echo "📋 Próximos passos:"
echo "   1. Faça logout e login novamente (para grupo docker)"
echo "   2. Execute: ./check-prerequisites.sh"
echo "   3. Execute: make setup-complete"
echo ""
echo "💡 Se o Docker não funcionar, execute: sudo systemctl start docker"