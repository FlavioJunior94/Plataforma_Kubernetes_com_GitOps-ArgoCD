@echo off
REM Script para substituir o Makefile no Windows
REM Uso: setup-complete.bat

if "%1"=="" goto help
if "%1"=="help" goto help
if "%1"=="create-cluster" goto create-cluster
if "%1"=="delete-cluster" goto delete-cluster
if "%1"=="install-argocd" goto install-argocd
if "%1"=="install-ingress" goto install-ingress
if "%1"=="argocd-password" goto argocd-password
if "%1"=="argocd-port-forward" goto argocd-port-forward
if "%1"=="status" goto status
if "%1"=="setup-complete" goto setup-complete
if "%1"=="clean" goto clean
if "%1"=="check-prereqs" goto check-prereqs

echo ❌ Comando não reconhecido: %1
goto help

:help
echo Comandos disponíveis:
echo.
echo   check-prereqs      - Verifica pré-requisitos
echo   create-cluster     - Cria o cluster Kubernetes
echo   delete-cluster     - Remove o cluster Kubernetes
echo   install-argocd     - Instala e configura ArgoCD
echo   install-ingress    - Instala Nginx Ingress Controller
echo   argocd-password    - Mostra senha do ArgoCD
echo   argocd-port-forward - Acessa ArgoCD via port-forward
echo   status             - Mostra status do cluster
echo   setup-complete     - Configuração completa do ambiente
echo   clean              - Remove tudo e recria ambiente
echo   help               - Mostra esta ajuda
echo.
echo Exemplo: setup-complete.bat create-cluster
goto end

:check-prereqs
echo 🔍 Verificando pré-requisitos...
call check-prerequisites.bat
goto end

:create-cluster
echo 🚀 Criando cluster Kubernetes com Kind...
kind create cluster --config infrastructure/kind/cluster-config.yaml --name gitops-cluster
if %errorlevel% == 0 (
    echo ✅ Cluster criado com sucesso!
    kubectl cluster-info --context kind-gitops-cluster
) else (
    echo ❌ Erro ao criar cluster
)
goto end

:delete-cluster
echo 🗑️ Removendo cluster...
kind delete cluster --name gitops-cluster
echo ✅ Cluster removido!
goto end

:install-argocd
echo 📦 Instalando ArgoCD...
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
echo ⏳ Aguardando ArgoCD ficar pronto...
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd
echo 🔧 Aplicando configurações personalizadas...
kubectl apply -f infrastructure/argocd/argocd-config.yaml
echo ✅ ArgoCD instalado e configurado com sucesso!
echo 🔑 Para acessar o ArgoCD, execute: setup-complete.bat argocd-password
goto end

:install-ingress
echo 🌐 Instalando Nginx Ingress Controller...
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
echo ⏳ Aguardando Ingress Controller ficar pronto...
kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s
echo ✅ Nginx Ingress Controller instalado!
goto end

:argocd-password
echo 🔑 Senha do ArgoCD (usuário: admin):
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" > temp_password.txt
certutil -decode temp_password.txt decoded_password.txt >nul 2>&1
type decoded_password.txt
del temp_password.txt decoded_password.txt >nul 2>&1
echo.
goto end

:argocd-port-forward
echo 🌐 Acessando ArgoCD em https://localhost:8080
echo 👤 Usuário: admin
echo 🔑 Senha: execute 'setup-complete.bat argocd-password' para ver a senha
kubectl port-forward svc/argocd-server -n argocd 8080:443
goto end

:status
echo 📊 Status do Cluster:
echo Nodes:
kubectl get nodes
echo.
echo Namespaces:
kubectl get namespaces
echo.
echo Pods do ArgoCD:
kubectl get pods -n argocd
echo.
echo Serviços do ArgoCD:
kubectl get svc -n argocd
goto end

:setup-complete
echo 🚀 Configurando ambiente completo...
call setup-complete.bat create-cluster
if %errorlevel% == 0 (
    call setup-complete.bat install-argocd
    if %errorlevel% == 0 (
        call setup-complete.bat install-ingress
        if %errorlevel% == 0 (
            echo ✅ Ambiente pronto para uso!
            echo 💡 Execute 'setup-complete.bat argocd-port-forward' para acessar o ArgoCD
        )
    )
)
goto end

:clean
echo 🧹 Limpando ambiente...
call setup-complete.bat delete-cluster
call setup-complete.bat create-cluster
call setup-complete.bat install-argocd
call setup-complete.bat install-ingress
echo ✅ Ambiente limpo e recriado!
goto end

:end