# 📋 Fase 4: GitOps com ArgoCD - Documentação Detalhada

## 🎯 Objetivo da Fase 4
Implementar GitOps completo com ArgoCD:
- Criação de Applications no ArgoCD
- Sincronização automática com Git
- Monitoramento contínuo
- Deploy declarativo

## 🏗️ Componentes Criados

### 1. ArgoCD Application
**Arquivo**: `argocd-app.yaml`

**Configuração**:
- Application name: gitops-demo-app
- Source: Repositório Git público (exemplo)
- Destination: Cluster local
- Sync Policy: Automático com prune e self-heal

**Por que essa configuração**:
- **Automático**: Deploy sem intervenção manual
- **Prune**: Remove recursos órfãos
- **Self-heal**: Corrige drift de configuração

### 2. Manifestos Kubernetes
**Pasta**: `k8s-manifests/`

**Arquivos criados**:
- `deployment.yaml` - Deployment da aplicação
- `service.yaml` - Service para exposição

**Por que separar manifestos**:
- ArgoCD monitora mudanças nos arquivos
- Facilita versionamento
- Permite rollback granular

## 🔧 Como Executar a Fase 4

### Passo 1: Criar Application via YAML
```bash
kubectl apply -f argocd-app.yaml
```

### Passo 2: Verificar Application
```bash
kubectl get applications -n argocd
```

### Passo 3: Acessar ArgoCD UI
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
# Acesse: https://localhost:8080
```

### Passo 4: Obter Senha do Admin
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### Passo 5: Monitorar Sync
- Acesse ArgoCD UI
- Clique na Application
- Observe status de sincronização

## 🎓 Conceitos Aprendidos

### 1. **GitOps Principles**
- **Declarativo**: Estado desejado em Git
- **Versionado**: Histórico completo de mudanças
- **Imutável**: Deploys reproduzíveis
- **Pull-based**: Cluster puxa do Git

### 2. **ArgoCD Applications**
- **Source**: Onde estão os manifestos
- **Destination**: Onde deployar
- **Sync Policy**: Como sincronizar
- **Health Status**: Estado dos recursos

### 3. **Sync Strategies**
- **Manual**: Sync sob demanda
- **Automatic**: Sync automático
- **Prune**: Remove recursos órfãos
- **Self-heal**: Corrige drift

### 4. **Application Patterns**
- **App of Apps**: Application que gerencia outras
- **Multi-source**: Múltiplas fontes
- **Multi-cluster**: Múltiplos clusters
- **Progressive Delivery**: Canary/Blue-Green

## 🔍 Fluxo GitOps Completo

### 1. Developer Workflow
```bash
# 1. Desenvolvedor faz mudança no código
git add .
git commit -m "feat: adicionar novo endpoint"
git push origin main

# 2. CI/CD builda nova imagem
docker build -t myapp:v1.1.0 .
docker push registry/myapp:v1.1.0

# 3. Desenvolvedor atualiza manifesto
# deployment.yaml: image: myapp:v1.1.0
git add k8s-manifests/deployment.yaml
git commit -m "deploy: atualizar para v1.1.0"
git push origin main

# 4. ArgoCD detecta mudança automaticamente
# 5. ArgoCD faz deploy da nova versão
# 6. Aplicação atualizada em produção
```

### 2. ArgoCD Workflow
```bash
# 1. ArgoCD monitora repositório (polling a cada 3min)
# 2. Detecta mudança nos manifestos
# 3. Compara estado atual vs desejado
# 4. Aplica mudanças no cluster
# 5. Monitora health dos recursos
# 6. Reporta status de sync
```

## 📊 Interface do ArgoCD

### 1. Dashboard Principal
- Lista de todas as Applications
- Status de sync (Synced/OutOfSync)
- Health status (Healthy/Degraded)
- Última sincronização

### 2. Application Details
- **Topology View**: Visualização dos recursos
- **Tree View**: Hierarquia dos recursos
- **Network View**: Conectividade entre recursos
- **List View**: Lista detalhada

### 3. Sync Options
- **Sync**: Sincronizar manualmente
- **Refresh**: Atualizar estado
- **Hard Refresh**: Forçar atualização
- **Rollback**: Voltar versão anterior

## 🔧 Configurações Avançadas

### 1. Sync Policies
```yaml
syncPolicy:
  automated:
    prune: true        # Remove recursos órfãos
    selfHeal: true     # Corrige drift
    allowEmpty: false  # Não permite sync vazio
  syncOptions:
    - CreateNamespace=true  # Cria namespace se não existir
    - PrunePropagationPolicy=foreground
    - PruneLast=true
```

### 2. Health Checks Customizados
```yaml
spec:
  ignoreDifferences:
  - group: apps
    kind: Deployment
    jsonPointers:
    - /spec/replicas  # Ignora diferenças em replicas
```

### 3. Hooks de Sync
```yaml
metadata:
  annotations:
    argocd.argoproj.io/hook: PreSync
    argocd.argoproj.io/hook-delete-policy: BeforeHookCreation
```

## 🚀 Comandos ArgoCD CLI

### Instalação do CLI
```bash
# Linux/macOS
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd

# Login
argocd login localhost:8080
```

### Comandos Úteis
```bash
# Listar applications
argocd app list

# Status de uma application
argocd app get myapp

# Sync manual
argocd app sync myapp

# Logs da application
argocd app logs myapp

# Histórico de sync
argocd app history myapp

# Rollback
argocd app rollback myapp 1
```

## 🔍 Monitoramento e Observabilidade

### 1. Métricas do ArgoCD
- Número de applications
- Status de sync
- Tempo de sync
- Erros de sync

### 2. Logs Importantes
```bash
# Logs do Application Controller
kubectl logs -n argocd deployment/argocd-application-controller

# Logs do Server
kubectl logs -n argocd deployment/argocd-server

# Logs do Repo Server
kubectl logs -n argocd deployment/argocd-repo-server
```

### 3. Events do Kubernetes
```bash
# Events da application
kubectl get events --field-selector involvedObject.name=myapp

# Events do namespace
kubectl get events -n default
```

## 🔧 Troubleshooting

### Application OutOfSync
```bash
# Verificar diferenças
argocd app diff myapp

# Forçar refresh
argocd app get myapp --refresh

# Sync manual
argocd app sync myapp
```

### Application Degraded
```bash
# Verificar recursos
kubectl get all -l app.kubernetes.io/instance=myapp

# Verificar logs dos pods
kubectl logs -l app.kubernetes.io/instance=myapp

# Verificar events
kubectl get events --field-selector involvedObject.name=myapp
```

### Sync Falha
```bash
# Verificar logs do ArgoCD
kubectl logs -n argocd deployment/argocd-application-controller

# Verificar configuração da application
kubectl describe application myapp -n argocd

# Verificar acesso ao repositório
argocd repo list
```

## 🚀 Próximos Passos

Com GitOps funcionando, você pode:

1. **Fase 5**: Implementar CI/CD pipeline completo
2. **Fase 6**: Configurar múltiplos ambientes
3. **Fase 7**: Adicionar monitoramento e alertas
4. **Fase 8**: Implementar progressive delivery

## 💡 Dicas Importantes

1. **Sempre use Git** como fonte da verdade
2. **Configure sync automático** para produtividade
3. **Use prune com cuidado** em produção
4. **Monitore health status** regularmente
5. **Mantenha manifestos organizados** por ambiente

## 🎯 Benefícios do GitOps

### 1. **Auditabilidade**
- Histórico completo no Git
- Quem fez o quê e quando
- Rollback fácil e seguro

### 2. **Segurança**
- Acesso controlado via Git
- Não precisa de kubectl em produção
- Princípio do menor privilégio

### 3. **Produtividade**
- Deploy automático
- Menos erros manuais
- Processo padronizado

### 4. **Confiabilidade**
- Estado sempre sincronizado
- Drift detection automático
- Recovery automático