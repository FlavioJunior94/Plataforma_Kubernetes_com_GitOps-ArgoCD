# 🪟 Guia Específico para Windows

## 🚨 Problemas Resolvidos

### 1. Política de Execução do PowerShell
**Problema**: `execução de scripts foi desabilitada neste sistema`

**Solução**: Criamos scripts `.bat` que não precisam de política de execução:
- `check-prerequisites.bat` - Verifica pré-requisitos
- `setup-complete.bat` - Substitui o Makefile

### 2. Make não disponível no Windows
**Problema**: `O termo 'make' não é reconhecido`

**Solução**: Script `setup-complete.bat` com todos os comandos do Makefile

## 🚀 Como Usar no Windows

### 1. Verificar Pré-requisitos
```cmd
check-prerequisites.bat
```

### 2. Comandos Disponíveis
```cmd
# Ver todos os comandos
setup-complete.bat help

# Verificar pré-requisitos
setup-complete.bat check-prereqs

# Criar cluster
setup-complete.bat create-cluster

# Instalar ArgoCD
setup-complete.bat install-argocd

# Configuração completa (tudo de uma vez)
setup-complete.bat setup-complete

# Ver status do cluster
setup-complete.bat status

# Acessar ArgoCD
setup-complete.bat argocd-port-forward
```

## 📋 Passo a Passo para Windows

### Passo 1: Verificar Ferramentas
```cmd
check-prerequisites.bat
```

Se alguma ferramenta estiver faltando, instale via Chocolatey:

```powershell
# Execute como Administrador no PowerShell
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Depois instale as ferramentas
choco install docker-desktop -y
choco install kubernetes-cli -y
choco install kind -y
choco install kubernetes-helm -y
```

### Passo 2: Configurar Ambiente Completo
```cmd
setup-complete.bat setup-complete
```

### Passo 3: Verificar Status
```cmd
setup-complete.bat status
```

### Passo 4: Acessar ArgoCD
```cmd
# Em um terminal, execute:
setup-complete.bat argocd-port-forward

# Em outro terminal, obtenha a senha:
setup-complete.bat argocd-password
```

Depois acesse: https://localhost:8080
- Usuário: `admin`
- Senha: (a que apareceu no comando acima)

## 🛠️ Comandos Equivalentes

| Makefile (Linux/macOS) | Windows Batch |
|------------------------|---------------|
| `make help` | `setup-complete.bat help` |
| `make check-prereqs` | `check-prerequisites.bat` |
| `make create-cluster` | `setup-complete.bat create-cluster` |
| `make install-argocd` | `setup-complete.bat install-argocd` |
| `make setup-complete` | `setup-complete.bat setup-complete` |
| `make status` | `setup-complete.bat status` |
| `make argocd-password` | `setup-complete.bat argocd-password` |
| `make argocd-port-forward` | `setup-complete.bat argocd-port-forward` |
| `make clean` | `setup-complete.bat clean` |

## 💡 Dicas para Windows

1. **Use o Terminal do Windows** ou **PowerShell** (não o CMD antigo)
2. **Mantenha o Docker Desktop rodando** sempre
3. **Execute como Administrador** se tiver problemas de permissão
4. **Use Chocolatey** para instalar ferramentas facilmente

## 🐛 Solução de Problemas Windows

### Docker não inicia
- Certifique-se que a virtualização está habilitada no BIOS
- Reinicie o Docker Desktop
- Verifique se o Hyper-V está habilitado

### Portas ocupadas
```cmd
# Verificar quem está usando a porta 8080
netstat -ano | findstr :8080

# Matar processo se necessário
taskkill /PID [número_do_processo] /F
```

### Cluster não cria
```cmd
# Limpar tudo e tentar novamente
setup-complete.bat clean
```

### Problemas de rede
- Desabilite temporariamente antivírus/firewall
- Verifique se não há proxy corporativo bloqueando

## ✅ Teste Rápido

Execute estes comandos em sequência para testar:

```cmd
# 1. Verificar ferramentas
check-prerequisites.bat

# 2. Configurar tudo
setup-complete.bat setup-complete

# 3. Verificar status
setup-complete.bat status

# 4. Acessar ArgoCD (em terminal separado)
setup-complete.bat argocd-port-forward
```

Se tudo funcionar, você verá:
- ✅ Cluster com 3 nós
- ✅ ArgoCD rodando
- ✅ Acesso em https://localhost:8080