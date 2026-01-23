#!/bin/bash
# Script completo para religar ambiente GitOps com TUDO configurado

set -e

echo "Religando ambiente GitOps completo..."
echo "=========================================="

# 1. Docker
echo "1. Verificando Docker..."
sudo systemctl start docker
sleep 5

# 2. Kind cluster
echo "2. Religando cluster Kind..."
docker start gitops-cluster-control-plane gitops-cluster-worker gitops-cluster-worker2
sleep 30
kubectl wait --for=condition=ready nodes --all --timeout=120s

# 3. Aguardar pods do sistema
echo "3. Aguardando pods do sistema..."
sleep 60  # Tempo extra para ArgoCD
kubectl get pods -A

# 4. Criar Application do ArgoCD (guestbook)
echo "4. Criando Application ArgoCD..."
kubectl apply -f argocd-app.yaml 2>/dev/null || echo "Application já existe"

# 5. Reconstruir nossa aplicação Flask
echo "5. Reconstruindo aplicação Flask..."
cd application
docker build --no-cache -t gitops-demo-api:1.0.0 .
kind load docker-image gitops-demo-api:1.0.0 --name gitops-cluster
cd ..

# 6. Deploy nossa aplicação com Helm
echo "6. Deployando nossa aplicação..."
helm uninstall gitops-demo 2>/dev/null || true
sleep 10
helm install gitops-demo helm-charts/myapp
sleep 15

# 7. Status final
echo "7. Status final:"
kubectl get pods
kubectl get services

echo ""
echo "✅ Ambiente GitOps religado com sucesso!"
echo "🌐 ArgoCD: kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo "🔑 Senha: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
echo "🚀 Nossa API: kubectl port-forward svc/gitops-demo-api-service 8081:80"
echo ""