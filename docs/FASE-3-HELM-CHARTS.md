# 📋 Fase 3: Helm Charts - Documentação Detalhada

## 🎯 Objetivo da Fase 3
Criar Helm Charts para deployment da aplicação com:
- Templates Kubernetes reutilizáveis
- Configuração por ambiente
- Boas práticas de Helm
- Suporte a múltiplos ambientes

## 🏗️ Componentes Criados

### 1. Chart.yaml
**Arquivo**: `helm-charts/myapp/Chart.yaml`

**Conteúdo**:
- Metadados do chart (nome, versão, descrição)
- Informações do mantenedor
- Palavras-chave para busca
- URLs do repositório

**Por que é importante**:
- Define identidade do chart
- Facilita descoberta e catalogação
- Documenta autoria e propósito

### 2. Values.yaml
**Arquivo**: `helm-charts/myapp/values.yaml`

**Configurações incluídas**:
- Configurações da aplicação (nome, versão, ambiente)
- Configurações da imagem Docker
- Número de réplicas
- Configurações de serviço
- Configurações de Ingress
- Recursos (CPU/memória)
- Health checks
- Segurança

**Por que centralizar configurações**:
- Facilita customização por ambiente
- Evita duplicação de código
- Permite override de valores
- Simplifica manutenção

### 3. Templates Kubernetes

#### Deployment Template
**Arquivo**: `helm-charts/myapp/templates/deployment.yaml`

**Recursos configurados**:
- Deployment com réplicas configuráveis
- Health checks (liveness/readiness probes)
- Variáveis de ambiente
- Recursos (requests/limits)
- Configurações de segurança

#### Service Template
**Arquivo**: `helm-charts/myapp/templates/service.yaml`

**Configurações**:
- Tipo de serviço (ClusterIP, NodePort, LoadBalancer)
- Portas e target ports
- Seletores para pods
- Anotações customizáveis

#### Ingress Template
**Arquivo**: `helm-charts/myapp/templates/ingress.yaml`

**Funcionalidades**:
- Roteamento HTTP/HTTPS
- Múltiplos hosts
- Configuração de TLS
- Anotações para Ingress Controller

### 4. Helpers Template
**Arquivo**: `helm-charts/myapp/templates/_helpers.tpl`

**Funções auxiliares**:
- Geração de nomes consistentes
- Labels padrão
- Seletores
- Configurações reutilizáveis

## 🔧 Como Executar a Fase 3

### Passo 1: Validar Chart
```bash
helm lint helm-charts/myapp
```

### Passo 2: Testar Templates
```bash
helm template gitops-demo helm-charts/myapp
```

### Passo 3: Instalar no Cluster
```bash
helm install gitops-demo helm-charts/myapp
```

### Passo 4: Verificar Deployment
```bash
kubectl get pods
kubectl get services
kubectl get ingress
```

### Passo 5: Testar Aplicação
```bash
kubectl port-forward service/gitops-demo-api-service 8080:80
curl http://localhost:8080/health
```

## 🎓 Conceitos Aprendidos

### 1. **Helm Templates**
- Linguagem de template Go
- Funções built-in do Helm
- Condicionais e loops
- Helpers reutilizáveis

### 2. **Configuração por Ambiente**
- Values.yaml como configuração base
- Override de valores por ambiente
- Múltiplos arquivos de valores
- Configuração via CLI

### 3. **Boas Práticas Helm**
- Nomes consistentes
- Labels padronizados
- Recursos opcionais
- Validação de valores

### 4. **Kubernetes Resources**
- Deployment para aplicações stateless
- Service para exposição interna
- Ingress para acesso externo
- ConfigMaps e Secrets

## 🔍 Estrutura do Chart

```
helm-charts/myapp/
├── Chart.yaml                 # Metadados do chart
├── values.yaml               # Configurações padrão
├── templates/
│   ├── deployment.yaml       # Template do Deployment
│   ├── service.yaml         # Template do Service
│   ├── ingress.yaml         # Template do Ingress
│   ├── _helpers.tpl         # Funções auxiliares
│   └── NOTES.txt           # Instruções pós-instalação
└── .helmignore             # Arquivos ignorados
```

## 📊 Configurações por Ambiente

### Desenvolvimento
```yaml
# values-dev.yaml
replicaCount: 1
image:
  tag: "latest"
ingress:
  hosts:
    - host: app-dev.local
resources:
  requests:
    cpu: 100m
    memory: 128Mi
```

### Staging
```yaml
# values-staging.yaml
replicaCount: 2
image:
  tag: "1.0.0"
ingress:
  hosts:
    - host: app-staging.example.com
resources:
  requests:
    cpu: 250m
    memory: 256Mi
```

### Produção
```yaml
# values-prod.yaml
replicaCount: 3
image:
  tag: "1.0.0"
ingress:
  hosts:
    - host: app.example.com
  tls:
    - secretName: app-tls
      hosts:
        - app.example.com
resources:
  requests:
    cpu: 500m
    memory: 512Mi
  limits:
    cpu: 1000m
    memory: 1Gi
```

## 🚀 Comandos Úteis

### Instalação e Upgrade
```bash
# Instalar
helm install myapp helm-charts/myapp

# Upgrade
helm upgrade myapp helm-charts/myapp

# Instalar com valores customizados
helm install myapp helm-charts/myapp -f values-prod.yaml

# Dry-run para testar
helm install myapp helm-charts/myapp --dry-run
```

### Gerenciamento
```bash
# Listar releases
helm list

# Status do release
helm status myapp

# Histórico de releases
helm history myapp

# Rollback
helm rollback myapp 1
```

### Debug
```bash
# Renderizar templates
helm template myapp helm-charts/myapp

# Debug com valores
helm template myapp helm-charts/myapp --debug

# Validar chart
helm lint helm-charts/myapp
```

## 🔧 Customização Avançada

### 1. Múltiplos Ambientes
```bash
# Desenvolvimento
helm install myapp-dev helm-charts/myapp -f values-dev.yaml

# Staging
helm install myapp-staging helm-charts/myapp -f values-staging.yaml

# Produção
helm install myapp-prod helm-charts/myapp -f values-prod.yaml
```

### 2. Override via CLI
```bash
helm install myapp helm-charts/myapp \
  --set replicaCount=3 \
  --set image.tag=2.0.0 \
  --set ingress.hosts[0].host=myapp.example.com
```

### 3. Configuração de Secrets
```bash
helm install myapp helm-charts/myapp \
  --set-string secrets.database.password="$(kubectl get secret db-secret -o jsonpath='{.data.password}' | base64 -d)"
```

## 🚀 Próximos Passos

Com os Helm Charts prontos, você pode:

1. **Fase 4**: Configurar GitOps com ArgoCD
2. **Fase 5**: Implementar CI/CD pipeline
3. **Fase 6**: Configurar monitoramento

## 💡 Dicas Importantes

1. **Sempre valide charts** com `helm lint`
2. **Use dry-run** para testar mudanças
3. **Mantenha values.yaml documentado**
4. **Use helpers** para evitar duplicação
5. **Teste em múltiplos ambientes**

## 🐛 Solução de Problemas

### Chart não instala
- Verifique sintaxe YAML: `helm lint helm-charts/myapp`
- Teste templates: `helm template myapp helm-charts/myapp`
- Verifique valores: `helm get values myapp`

### Pods não iniciam
- Verifique imagem Docker: `kubectl describe pod <pod-name>`
- Verifique recursos: `kubectl top pods`
- Verifique logs: `kubectl logs <pod-name>`

### Ingress não funciona
- Verifique Ingress Controller: `kubectl get pods -n ingress-nginx`
- Verifique configuração: `kubectl describe ingress <ingress-name>`
- Teste DNS local: adicione entrada em `/etc/hosts`