@echo off
REM Script para verificar pré-requisitos do projeto GitOps no Windows
REM Este script não precisa de política de execução do PowerShell

echo 🔍 Verificando pré-requisitos para o projeto GitOps...
echo ==================================================

set MISSING_TOOLS=

REM Verificar Docker
docker --version >nul 2>&1
if %errorlevel% == 0 (
    echo ✅ Docker está instalado
    docker --version
) else (
    echo ❌ Docker NÃO está instalado
    set MISSING_TOOLS=%MISSING_TOOLS% docker
)

REM Verificar kubectl
kubectl version --client --short >nul 2>&1
if %errorlevel% == 0 (
    echo ✅ kubectl está instalado
    kubectl version --client --short 2>nul
) else (
    echo ❌ kubectl NÃO está instalado
    set MISSING_TOOLS=%MISSING_TOOLS% kubectl
)

REM Verificar Kind
kind version >nul 2>&1
if %errorlevel% == 0 (
    echo ✅ Kind está instalado
    kind version 2>nul
) else (
    echo ❌ Kind NÃO está instalado
    set MISSING_TOOLS=%MISSING_TOOLS% kind
)

REM Verificar Helm
helm version --short >nul 2>&1
if %errorlevel% == 0 (
    echo ✅ Helm está instalado
    helm version --short 2>nul
) else (
    echo ❌ Helm NÃO está instalado
    set MISSING_TOOLS=%MISSING_TOOLS% helm
)

echo.
echo ==================================================

REM Verificar se Docker está rodando
docker info >nul 2>&1
if %errorlevel% == 0 (
    echo ✅ Docker está rodando
) else (
    echo ❌ Docker está instalado mas não está rodando
    echo    Inicie o Docker Desktop
    set MISSING_TOOLS=%MISSING_TOOLS% docker-running
)

echo.

if "%MISSING_TOOLS%" == "" (
    echo 🎉 Todos os pré-requisitos estão atendidos!
    echo    Você pode executar: setup-complete.bat setup-complete
    echo.
    echo Pressione qualquer tecla para continuar...
    pause >nul
    exit /b 0
) else (
    echo ⚠️  Ferramentas faltando:%MISSING_TOOLS%
    echo.
    echo 📋 Instruções de instalação:
    echo.
    echo 🐳 Docker:
    echo    Baixe: https://docs.docker.com/desktop/windows/install/
    echo    Ou via Chocolatey: choco install docker-desktop
    echo.
    echo ☸️  kubectl:
    echo    Via Chocolatey: choco install kubernetes-cli
    echo.
    echo 🎯 Kind:
    echo    Via Chocolatey: choco install kind
    echo.
    echo ⛵ Helm:
    echo    Via Chocolatey: choco install kubernetes-helm
    echo.
    echo 💡 Instale o Chocolatey primeiro:
    echo    Execute como Administrador no PowerShell:
    echo    Set-ExecutionPolicy Bypass -Scope Process -Force
    echo    [System.Net.ServicePointManager]::SecurityProtocol = 3072
    echo    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    echo.
)

echo.
echo Pressione qualquer tecla para continuar...
pause >nul
exit /b 1