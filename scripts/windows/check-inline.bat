@echo off
REM Versão inline do check-prerequisites para rodar no terminal atual

echo 🔍 Verificando pré-requisitos para o projeto GitOps...
echo ==================================================

REM Verificar Docker
echo Verificando Docker...
docker --version >nul 2>&1 && (
    echo ✅ Docker está instalado
    docker --version
) || (
    echo ❌ Docker NÃO está instalado
    set MISSING=1
)

REM Verificar kubectl
echo Verificando kubectl...
kubectl version --client --short >nul 2>&1 && (
    echo ✅ kubectl está instalado
    kubectl version --client --short 2>nul
) || (
    echo ❌ kubectl NÃO está instalado
    set MISSING=1
)

REM Verificar Kind
echo Verificando Kind...
kind version >nul 2>&1 && (
    echo ✅ Kind está instalado
    kind version 2>nul
) || (
    echo ❌ Kind NÃO está instalado
    set MISSING=1
)

REM Verificar Helm
echo Verificando Helm...
helm version --short >nul 2>&1 && (
    echo ✅ Helm está instalado
    helm version --short 2>nul
) || (
    echo ❌ Helm NÃO está instalado
    set MISSING=1
)

echo.
echo ==================================================

REM Verificar se Docker está rodando
echo Verificando se Docker está rodando...
docker info >nul 2>&1 && (
    echo ✅ Docker está rodando
) || (
    echo ❌ Docker não está rodando - Inicie o Docker Desktop
    set MISSING=1
)

echo.
if not defined MISSING (
    echo 🎉 Todos os pré-requisitos estão atendidos!
    echo    Próximo passo: setup-complete.bat setup-complete
) else (
    echo ⚠️  Algumas ferramentas estão faltando
    echo    Consulte INSTALLATION.md para instruções de instalação
)