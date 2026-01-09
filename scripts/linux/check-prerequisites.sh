#!/bin/bash

# Script para verificar pré-requisitos do projeto GitOps
# Este script verifica se todas as ferramentas necessárias estão instaladas

echo "...Verificando pré-requisitos para o projeto GitOps..."
echo "=================================================="

# Função para verificar se um comando existe
check_command() {
    if command -v $1 &> /dev/null; then
        echo "✅ $1 está instalado"
        if [ "$1" = "docker" ]; then
            echo "   Versão: $(docker --version)"
        elif [ "$1" = "kubectl" ]; then
            echo "   Versão: $(kubectl version --client --short 2>/dev/null)"
        elif [ "$1" = "kind" ]; then
            echo "   Versão: $(kind version 2>/dev/null)"
        elif [ "$1" = "helm" ]; then
            echo "   Versão: $(helm version --short 2>/dev/null)"
        fi
    else
        echo "❌ $1 NÃO está instalado"
        return 1
    fi
}

# Lista de ferramentas necessárias
TOOLS=("docker" "kubectl" "kind" "helm")
MISSING_TOOLS=()

# Verificar cada ferramenta
for tool in "${TOOLS[@]}"; do
    if ! check_command $tool; then
        MISSING_TOOLS+=($tool)
    fi
done

echo ""
echo "=========================================================================================="

# Verificar se Docker está rodando
if command -v docker &> /dev/null; then
    if docker info &> /dev/null; then
        echo "✅ Docker está rodando"
    else
        echo "❌ Docker está instalado mas não está rodando"
        echo "   Execute: sudo systemctl start docker (Linux) ou inicie o Docker Desktop"
        MISSING_TOOLS+=("docker-running")
    fi
fi

# Resultado final
if [ ${#MISSING_TOOLS[@]} -eq 0 ]; then
    echo ""
    echo "✅✅✅ Todos os pré-requisitos estão atendidos!✅✅✅"
    echo " executar: make create-cluster"
    exit 0
else
    echo ""
    echo "⚠️  Ferramentas faltando: ${MISSING_TOOLS[*]}"
    echo ""
    echo " Instruções de instalação:"
    echo ""
    
    for tool in "${MISSING_TOOLS[@]}"; do
        case $tool in
            "docker")
                echo "🐳 Docker:"
                echo "   Windows: https://docs.docker.com/desktop/windows/install/"
                echo "   Linux: curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh"
                echo ""
                ;;
            "kubectl")
                echo "☸️  kubectl:"
                echo "   Windows: choco install kubernetes-cli"
                echo "   Linux: curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
                echo ""
                ;;
            "kind")
                echo "🎯 Kind:"
                echo "   Windows: choco install kind"
                echo "   Linux: curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64 && chmod +x ./kind && sudo mv ./kind /usr/local/bin/kind"
                echo ""
                ;;
            "helm")
                echo "⛵ Helm:"
                echo "   Windows: choco install kubernetes-helm"
                echo "   Linux: curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash"
                echo ""
                ;;
        esac
    done
    
    exit 1
fi