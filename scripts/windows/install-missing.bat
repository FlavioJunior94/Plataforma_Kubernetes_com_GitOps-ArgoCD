@echo off
REM Script rápido para instalar apenas Kind e Helm (que estão faltando)
REM Execute como ADMINISTRADOR

echo 🔧 Instalando Kind e Helm...
echo ============================

REM Verificar se está rodando como administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Execute como ADMINISTRADOR (botão direito -> "Executar como administrador")
    pause
    exit /b 1
)

REM Verificar se Chocolatey está instalado
choco --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 📦 Instalando Chocolatey primeiro...
    powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
    
    REM Atualizar PATH
    set PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
)

echo 🎯 Instalando Kind...
choco install kind -y

echo ⛵ Instalando Helm...
choco install kubernetes-helm -y

echo.
echo ✅ Instalação concluída!
echo.
echo 📋 Agora:
echo    1. Inicie o Docker Desktop
echo    2. Execute: check-inline.bat
echo    3. Execute: .\setup-complete.bat setup-complete
echo.
pause