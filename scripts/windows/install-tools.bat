@echo off
REM Script que INSTALA automaticamente as ferramentas necessárias
REM Execute como ADMINISTRADOR

echo 🚀 Instalando ferramentas necessárias para o projeto GitOps...
echo ============================================================

REM Verificar se está rodando como administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Este script precisa ser executado como ADMINISTRADOR
    echo    Clique com botão direito e "Executar como administrador"
    pause
    exit /b 1
)

echo ✅ Executando como administrador

REM Verificar se Chocolatey está instalado
choco --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 📦 Instalando Chocolatey...
    powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
    
    REM Recarregar PATH
    call refreshenv
    
    echo ✅ Chocolatey instalado!
) else (
    echo ✅ Chocolatey já está instalado
)

REM Verificar e instalar Docker Desktop
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 🐳 Instalando Docker Desktop...
    choco install docker-desktop -y
    echo ⚠️  IMPORTANTE: Reinicie o computador após a instalação do Docker
) else (
    echo ✅ Docker já está instalado
)

REM Verificar e instalar kubectl
kubectl version --client --short >nul 2>&1
if %errorlevel% neq 0 (
    echo ☸️  Instalando kubectl...
    choco install kubernetes-cli -y
    echo ✅ kubectl instalado!
) else (
    echo ✅ kubectl já está instalado
)

REM Verificar e instalar Kind
kind version >nul 2>&1
if %errorlevel% neq 0 (
    echo 🎯 Instalando Kind...
    choco install kind -y
    echo ✅ Kind instalado!
) else (
    echo ✅ Kind já está instalado
)

REM Verificar e instalar Helm
helm version --short >nul 2>&1
if %errorlevel% neq 0 (
    echo ⛵ Instalando Helm...
    choco install kubernetes-helm -y
    echo ✅ Helm instalado!
) else (
    echo ✅ Helm já está instalado
)

echo.
echo ============================================================
echo 🎉 Instalação concluída!
echo.
echo 📋 Próximos passos:
echo    1. Se instalou Docker Desktop, REINICIE o computador
echo    2. Inicie o Docker Desktop
echo    3. Execute: check-inline.bat (para verificar)
echo    4. Execute: .\setup-complete.bat setup-complete
echo.
echo Pressione qualquer tecla para continuar...
pause >nul