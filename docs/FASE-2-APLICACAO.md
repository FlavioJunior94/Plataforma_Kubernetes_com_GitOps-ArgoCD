# 📋 Fase 2: Aplicação - Documentação Detalhada

## 🎯 Objetivo da Fase 2
Desenvolver uma aplicação Flask de demonstração com:
- API REST com múltiplos endpoints
- Health checks para Kubernetes
- Containerização com Docker
- Testes unitários

## 🏗️ Componentes Criados

### 1. API Flask
**Arquivo**: `application/src/app.py`

**Endpoints criados**:
- `GET /` - Informações básicas da aplicação
- `GET /health` - Health check para liveness probe
- `GET /ready` - Readiness check para readiness probe
- `GET /info` - Informações detalhadas do ambiente
- `GET /version` - Versão da aplicação

**Por que esses endpoints**:
- **/** - Endpoint principal para testar conectividade
- **/health** - Kubernetes usa para verificar se pod está vivo
- **/ready** - Kubernetes usa para verificar se pod está pronto
- **/info** - Debug e monitoramento detalhado
- **/version** - Controle de versão para GitOps

### 2. Containerização
**Arquivo**: `application/Dockerfile`

**Características**:
- Multi-stage build para otimização
- Imagem base Python slim
- Usuário não-root para segurança
- Health check integrado
- Variáveis de ambiente configuráveis

**Por que multi-stage**:
- Reduz tamanho da imagem final
- Separa dependências de build das de runtime
- Melhora segurança removendo ferramentas de build

### 3. Dependências
**Arquivo**: `application/src/requirements.txt`

**Bibliotecas incluídas**:
- Flask - Framework web
- Werkzeug - Utilitários WSGI
- Gunicorn - Servidor WSGI para produção

### 4. Testes Unitários
**Arquivo**: `application/tests/test_app.py`

**Testes implementados**:
- Teste do endpoint principal
- Teste dos health checks
- Teste de informações da aplicação
- Teste de versão

## 🔧 Como Executar a Fase 2

### Passo 1: Construir a Imagem Docker
```bash
cd application
docker build -t gitops-demo-api:1.0.0 .
```

### Passo 2: Testar Localmente
```bash
# Executar container
docker run -p 5000:5000 gitops-demo-api:1.0.0

# Testar endpoints
curl http://localhost:5000/
curl http://localhost:5000/health
curl http://localhost:5000/ready
```

### Passo 3: Carregar no Cluster Kind
```bash
kind load docker-image gitops-demo-api:1.0.0 --name gitops-cluster
```

### Passo 4: Executar Testes
```bash
cd application
python -m pytest tests/ -v
```

## 🎓 Conceitos Aprendidos

### 1. **Health Checks em Kubernetes**
- **Liveness Probe**: Verifica se container está vivo
- **Readiness Probe**: Verifica se container está pronto para receber tráfego
- **Startup Probe**: Verifica inicialização de containers lentos

### 2. **Docker Multi-stage Build**
- Otimiza tamanho da imagem
- Melhora segurança
- Separa ambiente de build do runtime

### 3. **Segurança em Containers**
- Usuário não-root
- Imagem base minimal (slim)
- Remoção de ferramentas desnecessárias

### 4. **Desenvolvimento Cloud-Native**
- Aplicação stateless
- Configuração via variáveis de ambiente
- Logs estruturados
- Graceful shutdown

## 🔍 Estrutura da Aplicação

```
application/
├── src/
│   ├── app.py              # Código principal da API
│   └── requirements.txt    # Dependências Python
├── tests/
│   └── test_app.py        # Testes unitários
├── Dockerfile             # Containerização
└── README.md             # Documentação da aplicação
```

## 📊 Endpoints da API

### 1. Endpoint Principal (`/`)
```json
{
  "message": "GitOps Demo API está funcionando!",
  "version": "1.0.0",
  "environment": "development",
  "hostname": "container-id",
  "timestamp": "2024-01-23T10:30:00"
}
```

### 2. Health Check (`/health`)
```json
{
  "status": "healthy",
  "version": "1.0.0",
  "timestamp": "2024-01-23T10:30:00"
}
```

### 3. Readiness Check (`/ready`)
```json
{
  "status": "ready",
  "version": "1.0.0"
}
```

### 4. Informações Detalhadas (`/info`)
```json
{
  "application": "GitOps Demo API",
  "version": "1.0.0",
  "environment": "development",
  "hostname": "container-id",
  "python_version": "3.11.x",
  "timestamp": "2024-01-23T10:30:00",
  "headers": {...}
}
```

### 5. Versão (`/version`)
```json
{
  "version": "1.0.0"
}
```

## 🚀 Próximos Passos

Com a aplicação pronta, você pode:

1. **Fase 3**: Criar Helm Charts para deployment
2. **Fase 4**: Configurar GitOps com ArgoCD
3. **Fase 5**: Implementar CI/CD pipeline

## 💡 Dicas Importantes

1. **Sempre teste localmente** antes de deployar
2. **Use health checks** em todas as aplicações Kubernetes
3. **Mantenha imagens pequenas** com multi-stage builds
4. **Configure logs estruturados** para observabilidade
5. **Use variáveis de ambiente** para configuração

## 🐛 Solução de Problemas

### Aplicação não inicia
- Verifique se Flask está instalado: `pip list | grep Flask`
- Verifique logs: `docker logs <container-id>`
- Teste requirements.txt: `pip install -r requirements.txt`

### Health checks falham
- Verifique se endpoints respondem: `curl http://localhost:5000/health`
- Verifique porta correta (5000)
- Verifique se aplicação está rodando

### Imagem muito grande
- Use imagem base slim: `python:3.11-slim`
- Implemente multi-stage build
- Remova arquivos desnecessários

### Testes falham
- Verifique dependências de teste
- Execute testes individualmente: `pytest tests/test_app.py::test_home -v`
- Verifique se aplicação está funcionando