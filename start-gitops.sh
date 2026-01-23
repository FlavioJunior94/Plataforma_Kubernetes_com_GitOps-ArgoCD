#!/bin/bash
# Script completo para religar ambiente GitOps após reiniciar máquina
# Uso: ./start-gitops.sh

set -e

echo "🚀 Religando ambiente GitOps completo..."
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

# 3. Pods do sistema
echo "3. Aguardando pods do sistema..."
sleep 20
kubectl wait --for=condition=ready pod -l app.kubernetes.io/part-of=argocd -n argocd --timeout=300s

# 4. Reconstruir aplicação
echo "4. Reconstruindo aplicação..."
cd application
docker build -t gitops-demo-api:1.0.0 .
kind load docker-image gitops-demo-api:1.0.0 --name gitops-cluster
cd ..

# 5. Deploy com Helm
echo "5. Deployando com Helm..."
helm uninstall gitops-demo 2>/dev/null || true
sleep 10
helm install gitops-demo helm-charts/myapp
sleep 15

# 6. Status final
echo "6. Status final:"
kubectl get pods
kubectl get services

echo ""
echo "✅ Ambiente GitOps religado com sucesso!"
echo "🌐 Para acessar ArgoCD: kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo "🔑 Senha ArgoCD: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
echo ""
echo "🧪 Para testar aplicação: kubectl port-forward service/gitops-demo-api-service 8080:80"