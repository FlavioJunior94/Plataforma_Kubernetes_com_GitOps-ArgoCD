# 📋 Fase 1: Infraestrutura - Documentação Detalhada

## 🎯 Objetivo da Fase 1
Criar e configurar a infraestrutura base do projeto GitOps, incluindo:
- Cluster Kubernetes local com Kind
- Instalação e configuração do ArgoCD
- Configuração do Nginx Ingress Controller
- Scripts de automação e verificação

## 🏗️ Componentes Criados

### 1. Configuração do Cluster Kind
**Arquivo**: `infrastructure/kind/cluster-config.yaml`

**O que faz**:
- Define um cluster Kubernetes com 3 nós (1 control-plane + 2 workers)
- Configura port mapping para acesso externo (80, 443, 8080)
- Adiciona labels nos workers para simular ambientes (staging/production)
- Configura redes para pods e serviços

**Por que é importante**:
- Simula um ambiente real de produção com múltiplos nós
- Permite acesso externo às aplicações via Ingress
- Demonstra conhecimento de configuração de cluster

### 2. Scripts de Verificação de Pré-requisitos
**Arquivos**: 
- `check-prerequisites.sh` (Linux/macOS)
- `check-prerequisites.ps1` (Windows)

**O que fazem**:
- Verificam se Docker, kubectl, Kind e Helm estão instalados
- Testam se o Docker está rodando
- Mostram versões das ferramentas
- Fornecem instruções de instalação se algo estiver faltando

**Por que são importantes**:
- Evitam erros durante a execução
- Demonstram preocupação com experiência do usuário
- Facilitam a reprodução do projeto por outros

### 3. Configuração Personalizada do ArgoCD
**Arquivo**: `infrastructure/argocd/argocd-config.yaml`

**O que contém**:
- ConfigMap com configurações do ArgoCD
- Configurações de repositórios Git
- Políticas de RBAC (Role-Based Access Control)
- Service NodePort para acesso local

**Por que é importante**:
- Mostra conhecimento avançado do ArgoCD
- Configura segurança com RBAC
- Facilita acesso local para desenvolvimento

### 4. Scripts de Configuração do ArgoCD
**Arquivos**:
- `infrastructure/argocd/setup-argocd.sh` (Linux/macOS)
- `infrastructure/argocd/setup-argocd.ps1` (Windows)

**O que fazem**:
- Aplicam configurações personalizadas
- Obtêm senha inicial do admin
- Configuram ArgoCD CLI (se disponível)
- Fornecem informações de acesso

### 5. Makefile de Automação
**Arquivo**: `Makefile`

**Comandos principais**:
- `make help` - Lista todos os comandos disponíveis
- `make create-cluster` - Cria o cluster Kubernetes
- `make install-argocd` - Instala e configura ArgoCD
- `make install-ingress` - Instala Nginx Ingress Controller
- `make setup-complete` - Configuração completa do ambiente
- `make check-prereqs` - Verifica pré-requisitos

**Por que é importante**:
- Automatiza tarefas complexas
- Padroniza comandos
- Facilita reprodução do projeto
- Demonstra conhecimento de automação

## 🔧 Como Executar a Fase 1

### Passo 1: Verificar Pré-requisitos
```bash
# Windows
.\check-prerequisites.ps1

# Linux/macOS
./check-prerequisites.sh
```

### Passo 2: Criar o Cluster
```bash
cd scripts/linux && make create-cluster
```

**O que acontece**:
1. Kind lê o arquivo `cluster-config.yaml`
2. Cria 3 containers Docker (1 control-plane + 2 workers)
3. Configura rede Kubernetes
4. Mapeia portas para acesso externo
5. Configura kubectl para acessar o cluster

### Passo 3: Instalar ArgoCD
```bash
cd scripts/linux && make install-argocd
```

**O que acontece**:
1. Cria namespace `argocd`
2. Instala ArgoCD via manifesto oficial
3. Aguarda todos os pods ficarem prontos
4. Aplica configurações personalizadas
5. Configura service NodePort para acesso

### Passo 4: Instalar Ingress Controller
```bash
cd scripts/linux && make install-ingress
```

**O que acontece**:
1. Instala Nginx Ingress Controller
2. Configura para funcionar com Kind
3. Aguarda controller ficar pronto

### Passo 5: Verificar Status
```bash
cd scripts/linux && make status
```

**O que mostra**:
- Status dos nós do cluster
- Namespaces criados
- Pods do ArgoCD
- Serviços do ArgoCD

## 🎓 Conceitos Aprendidos

### 1. **Kind (Kubernetes in Docker)**
- Ferramenta para criar clusters Kubernetes locais
- Usa containers Docker como nós do cluster
- Ideal para desenvolvimento e testes
- Configuração via arquivo YAML

### 2. **ArgoCD**
- Ferramenta de GitOps para Kubernetes
- Monitora repositórios Git
- Sincroniza estado desejado com cluster
- Interface web para visualização

### 3. **Ingress Controller**
- Gerencia acesso externo ao cluster
- Roteamento baseado em regras
- Terminação SSL/TLS
- Load balancing

### 4. **Automação com Makefile**
- Centraliza comandos complexos
- Facilita reprodução
- Documenta processos
- Padroniza execução

## 🔍 Verificação de Funcionamento

### 1. Cluster Funcionando
```bash
kubectl get nodes
# Deve mostrar 3 nós: 1 control-plane + 2 workers
```

### 2. ArgoCD Funcionando
```bash
kubectl get pods -n argocd
# Todos os pods devem estar "Running"
```

### 3. Acesso ao ArgoCD
```bash
make argocd-port-forward
# Acesse https://localhost:8080
```

### 4. Ingress Funcionando
```bash
kubectl get pods -n ingress-nginx
# Controller deve estar "Running"
```

## 🚀 Próximos Passos

Com a infraestrutura pronta, você pode:

1. **Fase 2**: Criar a aplicação de exemplo
2. **Fase 3**: Configurar pipeline de CI/CD
3. **Fase 4**: Implementar GitOps com ArgoCD
4. **Fase 5**: Configurar múltiplos ambientes

## 💡 Dicas Importantes

1. **Sempre verifique pré-requisitos** antes de começar
2. **Use `make help`** para ver todos os comandos disponíveis
3. **Execute `make status`** para verificar o estado do cluster
4. **Mantenha o Docker rodando** durante todo o processo
5. **Use `make clean`** para recomeçar do zero se necessário

## 🐛 Solução de Problemas

### Cluster não cria
- Verifique se Docker está rodando
- Verifique se as portas 80, 443, 8080 estão livres
- Execute `make delete-cluster` e tente novamente

### ArgoCD não instala
- Verifique conectividade com internet
- Aguarde mais tempo (pode demorar alguns minutos)
- Verifique logs: `kubectl logs -n argocd deployment/argocd-server`

### Port-forward não funciona
- Verifique se o pod ArgoCD está rodando
- Tente uma porta diferente: `kubectl port-forward svc/argocd-server -n argocd 8081:443`