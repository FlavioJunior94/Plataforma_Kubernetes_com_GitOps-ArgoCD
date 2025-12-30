# 🛠️ Guia de Instalação das Ferramentas

Este guia te ajudará a instalar todas as ferramentas necessárias para executar o projeto GitOps.

## 📋 Ferramentas Necessárias

1. **Docker** - Para containerização
2. **kubectl** - Cliente do Kubernetes
3. **Kind** - Kubernetes local
4. **Helm** - Gerenciador de pacotes do Kubernetes

## 🪟 Instalação no Windows

### Opção 1: Usando Chocolatey (Recomendado)

Primeiro, instale o Chocolatey se ainda não tiver:

```powershell
# Execute como Administrador no PowerShell
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

Depois instale as ferramentas:

```powershell
# Instalar Docker Desktop
choco install docker-desktop -y

# Instalar kubectl
choco install kubernetes-cli -y

# Instalar Kind
choco install kind -y

# Instalar Helm
choco install kubernetes-helm -y
```

### Opção 2: Instalação Manual

#### Docker Desktop
1. Baixe em: https://docs.docker.com/desktop/windows/install/
2. Execute o instalador
3. Reinicie o computador
4. Inicie o Docker Desktop

#### kubectl
1. Baixe em: https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/
2. Adicione ao PATH do sistema

#### Kind
1. Baixe em: https://kind.sigs.k8s.io/docs/user/quick-start/#installation
2. Adicione ao PATH do sistema

#### Helm
1. Baixe em: https://helm.sh/docs/intro/install/
2. Adicione ao PATH do sistema

## 🐧 Instalação no Linux (Ubuntu/Debian)

```bash
# Atualizar repositórios
sudo apt update

# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
sudo usermod -aG docker $USER
newgrp docker

# Instalar kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Instalar Kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Instalar Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

## 🍎 Instalação no macOS

### Usando Homebrew (Recomendado)

```bash
# Instalar Homebrew se não tiver
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Instalar as ferramentas
brew install docker
brew install kubectl
brew install kind
brew install helm
```

## ✅ Verificação da Instalação

Após instalar tudo, execute o script de verificação:

### Windows (PowerShell)
```powershell
.\check-prerequisites.ps1
```

### Linux/macOS
```bash
chmod +x check-prerequisites.sh
./check-prerequisites.sh
```

## 🚀 Próximos Passos

Quando todas as ferramentas estiverem instaladas:

1. **Inicie o Docker Desktop** (Windows/macOS)
2. **Execute o comando de verificação** para confirmar que tudo está funcionando
3. **Crie o cluster**: `make create-cluster`

## 🆘 Problemas Comuns

### Docker não inicia
- **Windows**: Certifique-se de que a virtualização está habilitada no BIOS
- **Linux**: Adicione seu usuário ao grupo docker: `sudo usermod -aG docker $USER`

### kubectl não encontrado
- Verifique se o PATH está configurado corretamente
- Reinicie o terminal após a instalação

### Kind não funciona
- Certifique-se de que o Docker está rodando
- Verifique se há conflitos de porta (80, 443, 8080)

### Problemas de permissão (Linux)
```bash
# Dar permissões corretas aos scripts
chmod +x *.sh
```

## 📞 Suporte

Se encontrar problemas:
1. Verifique os logs de erro
2. Consulte a documentação oficial de cada ferramenta
3. Execute o script de verificação para diagnóstico