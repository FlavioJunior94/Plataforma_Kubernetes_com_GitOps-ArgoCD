# Script PowerShell para verificar pré-requisitos do projeto GitOps
# Este script verifica se todas as ferramentas necessárias estão instaladas no Windows

Write-Host "🔍 Verificando pré-requisitos para o projeto GitOps..." -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

# Função para verificar se um comando existe
function Test-Command {
    param($CommandName)
    
    try {
        if (Get-Command $CommandName -ErrorAction Stop) {
            Write-Host "✅ $CommandName está instalado" -ForegroundColor Green
            
            switch ($CommandName) {
                "docker" { 
                    $version = docker --version
                    Write-Host "   Versão: $version" -ForegroundColor Gray
                }
                "kubectl" { 
                    $version = kubectl version --client --short 2>$null
                    Write-Host "   Versão: $version" -ForegroundColor Gray
                }
                "kind" { 
                    $version = kind version 2>$null
                    Write-Host "   Versão: $version" -ForegroundColor Gray
                }
                "helm" { 
                    $version = helm version --short 2>$null
                    Write-Host "   Versão: $version" -ForegroundColor Gray
                }
            }
            return $true
        }
    }
    catch {
        Write-Host "❌ $CommandName NÃO está instalado" -ForegroundColor Red
        return $false
    }
}

# Lista de ferramentas necessárias
$tools = @("docker", "kubectl", "kind", "helm")
$missingTools = @()

# Verificar cada ferramenta
foreach ($tool in $tools) {
    if (-not (Test-Command $tool)) {
        $missingTools += $tool
    }
}

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan

# Verificar se Docker está rodando
if (Get-Command docker -ErrorAction SilentlyContinue) {
    try {
        docker info 2>$null | Out-Null
        Write-Host "✅ Docker está rodando" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Docker está instalado mas não está rodando" -ForegroundColor Red
        Write-Host "   Inicie o Docker Desktop" -ForegroundColor Yellow
        $missingTools += "docker-running"
    }
}

# Resultado final
if ($missingTools.Count -eq 0) {
    Write-Host ""
    Write-Host "🎉 Todos os pré-requisitos estão atendidos!" -ForegroundColor Green
    Write-Host "   Você pode executar: make create-cluster" -ForegroundColor Cyan
    exit 0
}
else {
    Write-Host ""
    Write-Host "⚠️  Ferramentas faltando: $($missingTools -join ', ')" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "📋 Instruções de instalação:" -ForegroundColor Cyan
    Write-Host ""
    
    foreach ($tool in $missingTools) {
        switch ($tool) {
            "docker" {
                Write-Host "🐳 Docker:" -ForegroundColor Blue
                Write-Host "   Baixe e instale o Docker Desktop: https://docs.docker.com/desktop/windows/install/" -ForegroundColor Gray
                Write-Host "   Ou via Chocolatey: choco install docker-desktop" -ForegroundColor Gray
                Write-Host ""
            }
            "kubectl" {
                Write-Host "☸️  kubectl:" -ForegroundColor Blue
                Write-Host "   Via Chocolatey: choco install kubernetes-cli" -ForegroundColor Gray
                Write-Host "   Ou baixe direto: https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/" -ForegroundColor Gray
                Write-Host ""
            }
            "kind" {
                Write-Host "🎯 Kind:" -ForegroundColor Blue
                Write-Host "   Via Chocolatey: choco install kind" -ForegroundColor Gray
                Write-Host "   Ou baixe direto: https://kind.sigs.k8s.io/docs/user/quick-start/#installation" -ForegroundColor Gray
                Write-Host ""
            }
            "helm" {
                Write-Host "⛵ Helm:" -ForegroundColor Blue
                Write-Host "   Via Chocolatey: choco install kubernetes-helm" -ForegroundColor Gray
                Write-Host "   Ou baixe direto: https://helm.sh/docs/intro/install/" -ForegroundColor Gray
                Write-Host ""
            }
        }
    }
    
    Write-Host "💡 Dica: Instale o Chocolatey primeiro para facilitar:" -ForegroundColor Yellow
    Write-Host "   Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" -ForegroundColor Gray
    
    exit 1
}