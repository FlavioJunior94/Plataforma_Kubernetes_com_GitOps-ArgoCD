#!/bin/bash

# Script para configurar o ArgoCD após a instalação
# Este script aplica configurações personalizadas e configura o acesso

set -e

NAMESPACE="argocd"
CLUSTER_NAME="gitops-cluster"

echo "🔧 Configurando ArgoCD..."
echo "========================="

# Aplicar configurações personalizadas
echo "📝 Aplicando configurações personalizadas..."
kubectl apply -f infrastructure/argocd/argocd-config.yaml

# Aguardar todos os pods ficarem prontos
echo "⏳ Aguardando todos os pods do ArgoCD ficarem prontos..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/part-of=argocd -n $NAMESPACE --timeout=300s

# Obter a senha inicial do admin
echo "🔑 Obtendo senha do admin..."
ADMIN_PASSWORD=$(kubectl -n $NAMESPACE get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

# Fazer port-forward em background para configurar via CLI
echo "🌐 Iniciando port-forward temporário..."
kubectl port-forward svc/argocd-server -n $NAMESPACE 8080:443 > /dev/null 2>&1 &
PORT_FORWARD_PID=$!

# Aguardar o port-forward ficar ativo
sleep 5

# Fazer login no ArgoCD CLI (se disponível)
if command -v argocd &> /dev/null; then
    echo "🔐 Fazendo login no ArgoCD CLI..."
    argocd login localhost:8080 --username admin --password $ADMIN_PASSWORD --insecure
    
    # Adicionar cluster local
    echo "🎯 Adicionando cluster local..."
    argocd cluster add kind-$CLUSTER_NAME --name local-cluster
    
    echo "✅ ArgoCD CLI configurado!"
else
    echo "⚠️  ArgoCD CLI não encontrado. Pule esta etapa ou instale o CLI."
fi

# Parar o port-forward temporário
kill $PORT_FORWARD_PID 2>/dev/null || true

echo ""
echo "✅ ArgoCD configurado com sucesso!"
echo ""
echo "📋 Informações de acesso:"
echo "   URL: https://localhost:8080 (execute: make argocd-port-forward)"
echo "   Usuário: admin"
echo "   Senha: $ADMIN_PASSWORD"
echo ""
echo "💡 Próximos passos:"
echo "   1. Execute: make argocd-port-forward"
echo "   2. Acesse https://localhost:8080"
echo "   3. Faça login com as credenciais acima"
echo "   4. Configure suas aplicações"