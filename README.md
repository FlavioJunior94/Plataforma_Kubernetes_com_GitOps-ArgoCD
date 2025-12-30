# Plataforma K8s GitOps: Automação e Entrega Contínua com ArgoCD e Helm

## 🎯 Problema
Como garantir que o cluster Kubernetes reflita exatamente o que foi aprovado no Git, eliminando configurações manuais e garantindo rastreabilidade completa?

## 💡 Solução
Implementação de modelo GitOps utilizando ArgoCD para automação total do ciclo de entrega, onde o cluster "puxa" as configurações do Git ao invés do CI "empurrar" para o cluster.

## 🛠️ Tecnologias Utilizadas
- **Kubernetes**: Orquestração de containers
- **Kind**: Cluster Kubernetes local
- **ArgoCD**: Ferramenta de GitOps para Continuous Delivery
- **Helm**: Gerenciador de pacotes para Kubernetes
- **Docker**: Containerização da aplicação
- **GitHub Actions**: Pipeline de CI/CD
- **Nginx Ingress**: Controlador de entrada
- **Let's Encrypt**: Certificados SSL automáticos

## 📁 Estrutura do Projeto
```
├── infrastructure/          # Configurações de infraestrutura
│   ├── kind/               # Configuração do cluster Kind
│   ├── argocd/             # Instalação e configuração do ArgoCD
│   └── ingress/            # Configuração do Nginx Ingress
├── scripts/                # Scripts de automação por SO
│   ├── windows/            # Scripts para Windows
│   │   ├── check-prerequisites.bat
│   │   ├── check-prerequisites.ps1
│   │   ├── install-tools.bat
│   │   ├── install-missing.bat
│   │   └── setup-complete.bat
│   └── linux/              # Scripts para Linux/macOS
│       ├── check-prerequisites.sh
│       ├── install-tools.sh
│       ├── install-missing.sh
│       ├── setup-argocd.sh
│       └── Makefile
├── application/            # Código da aplicação
│   ├── src/                # Código fonte
│   ├── Dockerfile          # Containerização
│   └── tests/              # Testes unitários
├── helm-charts/            # Charts Helm da aplicação
│   └── myapp/              # Chart da aplicação
├── environments/           # Configurações por ambiente
│   ├── staging/            # Ambiente de staging
│   └── production/         # Ambiente de produção
└── .github/workflows/      # Pipelines GitHub Actions
```

## 🚀 Como Executar

### Pré-requisitos
- Docker instalado
- Kind instalado
- kubectl instalado
- Helm instalado

### Windows
```cmd
# Verificar pré-requisitos
scripts\windows\check-prerequisites.bat

# Instalar ferramentas faltantes (como Administrador)
scripts\windows\install-missing.bat

# Configuração completa
scripts\windows\setup-complete.bat setup-complete

# Acessar ArgoCD
scripts\windows\setup-complete.bat argocd-port-forward
```

### Linux/macOS
```bash
# Verificar pré-requisitos
./scripts/linux/check-prerequisites.sh

# Instalar ferramentas faltantes (com sudo)
sudo ./scripts/linux/install-missing.sh

# Configuração completa
cd scripts/linux && make setup-complete

# Acessar ArgoCD
cd scripts/linux && make argocd-port-forward
```

### Guias Específicos
- 📖 [Guia de Instalação](INSTALLATION.md)
- 🪟 [Guia para Windows](WINDOWS-GUIDE.md)
- 📋 [Documentação da Fase 1](docs/FASE-1-INFRAESTRUTURA.md)

## 📊 Arquitetura
[------------]apt install make -y


---
**Desenvolvido por**: Juninho  
**Objetivo**: Demonstrar habilidades em DevOps, GitOps e Kubernetes