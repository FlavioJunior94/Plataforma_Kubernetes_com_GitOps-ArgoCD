# Script PowerShell para configurar o ArgoCD após a instalação
# Este script aplica configurações personalizadas e configura o acesso

$ErrorActionPreference = "Stop"

$NAMESPACE = "argocd"
$CLUSTER_NAME = "gitops-cluster"

Write-Host "🔧 Configurando ArgoCD..." -ForegroundColor Cyan
Write-Host "=========================" -ForegroundColor Cyan

# Aplicar configurações personalizadas
Write-Host "📝 Aplicando configurações personalizadas..." -ForegroundColor Yellow
kubectl apply -f infrastructure/argocd/argocd-config.yaml

# Aguardar todos os pods ficarem prontos
Write-Host "⏳ Aguardando todos os pods do ArgoCD ficarem prontos..." -ForegroundColor Yellow
kubectl wait --for=condition=ready pod -l app.kubernetes.io/part-of=argocd -n $NAMESPACE --timeout=300s

# Obter a senha inicial do admin
Write-Host "🔑 Obtendo senha do admin..." -ForegroundColor Yellow
$ADMIN_PASSWORD = kubectl -n $NAMESPACE get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | ForEach-Object { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }

# Fazer port-forward em background para configurar via CLI
Write-Host "🌐 Iniciando port-forward temporário..." -ForegroundColor Yellow
$portForwardJob = Start-Job -ScriptBlock {
    kubectl port-forward svc/argocd-server -n argocd 8080:443
}

# Aguardar o port-forward ficar ativo
Start-Sleep -Seconds 5

# Fazer login no ArgoCD CLI (se disponível)
if (Get-Command argocd -ErrorAction SilentlyContinue) {
    Write-Host "🔐 Fazendo login no ArgoCD CLI..." -ForegroundColor Yellow
    argocd login localhost:8080 --username admin --password $ADMIN_PASSWORD --insecure
    
    # Adicionar cluster local
    Write-Host "🎯 Adicionando cluster local..." -ForegroundColor Yellow
    argocd cluster add kind-$CLUSTER_NAME --name local-cluster
    
    Write-Host "✅ ArgoCD CLI configurado!" -ForegroundColor Green
}
else {
    Write-Host "⚠️  ArgoCD CLI não encontrado. Pule esta etapa ou instale o CLI." -ForegroundColor Yellow
}

# Parar o port-forward temporário
Stop-Job $portForwardJob -ErrorAction SilentlyContinue
Remove-Job $portForwardJob -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "✅ ArgoCD configurado com sucesso!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Informações de acesso:" -ForegroundColor Cyan
Write-Host "   URL: https://localhost:8080 (execute: make argocd-port-forward)" -ForegroundColor Gray
Write-Host "   Usuário: admin" -ForegroundColor Gray
Write-Host "   Senha: $ADMIN_PASSWORD" -ForegroundColor Gray
Write-Host ""
Write-Host "💡 Próximos passos:" -ForegroundColor Cyan
Write-Host "   1. Execute: make argocd-port-forward" -ForegroundColor Gray
Write-Host "   2. Acesse https://localhost:8080" -ForegroundColor Gray
Write-Host "   3. Faça login com as credenciais acima" -ForegroundColor Gray
Write-Host "   4. Configure suas aplicações" -ForegroundColor Gray