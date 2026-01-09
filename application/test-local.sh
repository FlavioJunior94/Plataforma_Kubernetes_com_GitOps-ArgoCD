#!/bin/bash

# Script para testar a aplicação GitOps Demo API localmente

set -e

echo "🧪 Testando GitOps Demo API localmente..."
echo "========================================"

# Verificar se Python está instalado
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 não encontrado. Instalando..."
    apt update
    apt install -y python3 python3-pip python3-venv curl
fi

# Verificar se pip está disponível
if ! command -v pip3 &> /dev/null; then
    echo "❌ pip3 não encontrado. Instalando..."
    apt install -y python3-pip
fi


cd "$(dirname "$0")/src"

echo "📦 Instalando dependências..."
pip3 install -r requirements.txt

echo "🧪 Executando testes..."
cd ../tests
python3 test_app.py

echo "🚀 Iniciando aplicação..."
cd ../src
export FLASK_ENV=development
export DEBUG=true
python3 app.py &

sleep 3

echo "🔍 Testando endpoints..."

# Testar endpoints
echo "Testing /"
curl -s http://localhost:5000/ | python3 -m json.tool

echo -e "\nTesting /health"
curl -s http://localhost:5000/health | python3 -m json.tool

echo -e "\nTesting /version"
curl -s http://localhost:5000/version | python3 -m json.tool

echo -e "\n✅ Aplicação funcionando!"
echo "🌐 Acesse: http://localhost:5000"
echo "🛑 Para parar: Ctrl+C"

# Manter aplicação rodando
wait