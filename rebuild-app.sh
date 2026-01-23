#!/bin/bash
# Script para reconstruir aplicação com Flask

echo "Reconstruindo aplicação GitOps Demo..."

# Ir para diretório da aplicação
cd application

# Reconstruir imagem Docker
echo "1. Construindo imagem Docker..."
docker build -t gitops-demo-api:1.0.0 .

# Carregar no cluster Kind
echo "2. Carregando imagem no cluster Kind..."
kind load docker-image gitops-demo-api:1.0.0 --name gitops-cluster

# Voltar para raiz
cd ..

# Reiniciar deployment
echo "3. Reiniciando deployment..."
kubectl rollout restart deployment gitops-demo-api

# Aguardar pods ficarem prontos
echo "4. Aguardando pods..."
kubectl rollout status deployment gitops-demo-api

# Verificar status
echo "5. Status final:"
kubectl get pods

echo "✅ Aplicação reconstruída!"