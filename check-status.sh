#!/bin/bash
# Script para verificar status completo do ambiente GitOps

echo "=========================================="
echo "🔍 Verificação Completa do Ambiente GitOps"
echo "=========================================="
echo ""

echo "1️⃣ Status do Cluster:"
kubectl cluster-info --request-timeout=5s 2>/dev/null && echo "✅ Cluster respondendo" || echo "❌ Cluster não responde"
echo ""

echo "2️⃣ Nós do Cluster:"
kubectl get nodes
echo ""

echo "3️⃣ Pods do ArgoCD:"
kubectl get pods -n argocd
echo ""

echo "4️⃣ Applications do ArgoCD:"
kubectl get applications -n argocd
echo ""

echo "5️⃣ Pods das Aplicações:"
kubectl get pods
echo ""

echo "6️⃣ Serviços:"
kubectl get services
echo ""

echo "7️⃣ Helm Releases:"
helm list
echo ""

echo "=========================================="
echo "✅ Verificação completa!"
echo "=========================================="
echo ""
echo "📌 Próximos comandos úteis:"
echo "   ArgoCD UI: kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo "   App API: kubectl port-forward svc/gitops-demo-api-service 8081:80"
echo ""