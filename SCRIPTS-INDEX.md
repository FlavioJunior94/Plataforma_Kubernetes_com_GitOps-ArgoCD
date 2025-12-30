# 📋 Índice de Scripts - Projeto GitOps

## 🪟 Scripts Windows (`scripts/windows/`)

### Verificação
- `check-prerequisites.bat` - Verifica se ferramentas estão instaladas
- `check-prerequisites.ps1` - Versão PowerShell da verificação

### Instalação (Execute como Administrador)
- `install-tools.bat` - Instala todas as ferramentas necessárias
- `install-missing.bat` - Instala apenas as ferramentas faltantes

### Automação
- `setup-complete.bat` - Script principal com todos os comandos
- `setup-argocd.ps1` - Configuração específica do ArgoCD

### Comandos Principais Windows
```cmd
# Verificar pré-requisitos
scripts\windows\check-prerequisites.bat

# Instalar ferramentas faltantes (como Admin)
scripts\windows\install-missing.bat

# Ver comandos disponíveis
scripts\windows\setup-complete.bat help

# Configuração completa
scripts\windows\setup-complete.bat setup-complete

# Acessar ArgoCD
scripts\windows\setup-complete.bat argocd-port-forward
```

## 🐧 Scripts Linux/macOS (`scripts/linux/`)

### Verificação
- `check-prerequisites.sh` - Verifica se ferramentas estão instaladas

### Instalação (Execute com sudo)
- `install-tools.sh` - Instala todas as ferramentas necessárias
- `install-missing.sh` - Instala apenas as ferramentas faltantes

### Automação
- `Makefile` - Automação de comandos via make
- `setup-argocd.sh` - Configuração específica do ArgoCD

### Comandos Principais Linux/macOS
```bash
# Verificar pré-requisitos
./scripts/linux/check-prerequisites.sh

# Instalar ferramentas faltantes (com sudo)
sudo ./scripts/linux/install-missing.sh

# Ver comandos disponíveis
cd scripts/linux && make help

# Configuração completa
cd scripts/linux && make setup-complete

# Acessar ArgoCD
cd scripts/linux && make argocd-port-forward
```

## 🎯 Fluxo Recomendado

### Para Windows:
1. `scripts\windows\check-prerequisites.bat`
2. `scripts\windows\install-missing.bat` (como Admin)
3. `scripts\windows\setup-complete.bat setup-complete`
4. `scripts\windows\setup-complete.bat argocd-port-forward`

### Para Linux/macOS:
1. `./scripts/linux/check-prerequisites.sh`
2. `sudo ./scripts/linux/install-missing.sh`
3. `cd scripts/linux && make setup-complete`
4. `cd scripts/linux && make argocd-port-forward`

## 📚 Documentação Relacionada

- `README.md` - Documentação principal
- `INSTALLATION.md` - Guia de instalação detalhado
- `WINDOWS-GUIDE.md` - Guia específico para Windows
- `docs/FASE-1-INFRAESTRUTURA.md` - Documentação técnica da Fase 1
- `FASE-1-COMPLETA.md` - Resumo da Fase 1

## 🔧 Estrutura Organizada

A nova organização separa claramente:
- **Windows**: Scripts .bat e .ps1 otimizados para Windows
- **Linux/macOS**: Scripts .sh e Makefile otimizados para Unix-like
- **Infraestrutura**: Configurações YAML do Kubernetes
- **Documentação**: Guias e explicações técnicas

Isso facilita:
- ✅ Manutenção dos scripts
- ✅ Contribuições da comunidade
- ✅ Reprodução em diferentes ambientes
- ✅ Organização profissional do projeto