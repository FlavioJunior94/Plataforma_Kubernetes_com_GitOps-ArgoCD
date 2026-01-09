# Dockerfile multi-stage para GitOps Demo API. Dockerfile cria uma imagem otimizada e segura para produção

# Estágio 1: Build (imagem temporária para instalar dependências)
FROM python:3.11-slim AS builder

# Instalar dependências do sistema necessárias para build
RUN apt-get update && apt-get install -y \
    gcc \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Criar diretório de trabalho
WORKDIR /app

# Copiar arquivo de dependências
COPY src/requirements.txt .

# Instalar dependências Python em um diretório específico
RUN pip install --no-cache-dir --user -r requirements.txt

# Estágio 2: Runtime (imagem final otimizada)
FROM python:3.11-slim

# Metadados da imagem
LABEL maintainer="Juninho"
LABEL description="GitOps Demo API - Aplicação Flask para demonstrar GitOps com ArgoCD"
LABEL version="1.0.0"

# Criar usuário não-root para segurança
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Criar diretório da aplicação
WORKDIR /app

# Copiar dependências instaladas do estágio de build
COPY --from=builder /root/.local /home/appuser/.local

# Copiar código da aplicação
COPY src/ .

# Ajustar permissões
RUN chown -R appuser:appuser /app

# Mudar para usuário não-root
USER appuser

# Adicionar diretório local do usuário ao PATH
ENV PATH=/home/appuser/.local/bin:$PATH

# Variáveis de ambiente
ENV FLASK_APP=app.py
ENV FLASK_ENV=production
ENV PYTHONPATH=/app
ENV PORT=5000

# Expor porta da aplicação
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5000/health || exit 1

# Comando para iniciar a aplicação
# Usando python diretamente para debug
CMD ["python", "app.py"]