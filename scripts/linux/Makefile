# Makefile para automação do projeto GitOps
# Este arquivo centraliza todos os comandos necessários para executar o projeto

.PHONY: help create-cluster delete-cluster install-argocd install-ingress deploy-apps clean

# Variáveis
CLUSTER_NAME=gitops-cluster
ARGOCD_NAMESPACE=argocd
INGRESS_NAMESPACE=ingress-nginx

help: ## Mostra esta mensagem de ajuda
	@echo "Comandos disponíveis:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

create-cluster: ## Cria o cluster Kubernetes com Kind
	@echo "🚀 Criando cluster Kubernetes com Kind..."
	kind create cluster --config infrastructure/kind/cluster-config.yaml --name $(CLUSTER_NAME)
	@echo "✅ Cluster criado com sucesso!"
	kubectl cluster-info --context kind-$(CLUSTER_NAME)

delete-cluster: ## Remove o cluster Kubernetes
	@echo "🗑️ Removendo cluster..."
	kind delete cluster --name $(CLUSTER_NAME)
	@echo "✅ Cluster removido!"

install-argocd: ## Instala e configura o ArgoCD no cluster
	@echo "📦 Instalando ArgoCD..."
	kubectl create namespace $(ARGOCD_NAMESPACE) --dry-run=client -o yaml | kubectl apply -f -
	kubectl apply -n $(ARGOCD_NAMESPACE) -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	@echo "⏳ Aguardando ArgoCD ficar pronto..."
	kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n $(ARGOCD_NAMESPACE)
	@echo "🔧 Aplicando configurações personalizadas..."
	kubectl apply -f infrastructure/argocd/argocd-config.yaml
	@echo "✅ ArgoCD instalado e configurado com sucesso!"
	@echo "🔑 Para acessar o ArgoCD, execute: make argocd-password"

install-ingress: ## Instala o Nginx Ingress Controller
	@echo "🌐 Instalando Nginx Ingress Controller..."
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
	@echo "⏳ Aguardando Ingress Controller ficar pronto..."
	kubectl wait --namespace $(INGRESS_NAMESPACE) --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s
	@echo "✅ Nginx Ingress Controller instalado!"

argocd-password: ## Mostra a senha do ArgoCD
	@echo "🔑 Senha do ArgoCD (usuário: admin):"
	@kubectl -n $(ARGOCD_NAMESPACE) get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo

argocd-port-forward: ## Faz port-forward para acessar o ArgoCD
	@echo "🌐 Acessando ArgoCD em https://localhost:8080"
	@echo "👤 Usuário: admin"
	@echo "🔑 Senha: execute 'make argocd-password' para ver a senha"
	kubectl port-forward svc/argocd-server -n $(ARGOCD_NAMESPACE) 8080:443

deploy-apps: ## Deploys das aplicações via ArgoCD
	@echo "🚀 Configurando aplicações no ArgoCD..."
	kubectl apply -f environments/staging/
	kubectl apply -f environments/production/
	@echo "✅ Aplicações configuradas!"

clean: ## Remove tudo e recria o ambiente
	@echo "🧹 Limpando ambiente..."
	make delete-cluster
	make create-cluster
	make install-argocd
	make install-ingress
	@echo "✅ Ambiente limpo e recriado!"

status: ## Mostra o status do cluster
	@echo "📊 Status do Cluster:"
	@echo "Nodes:"
	@kubectl get nodes
	@echo "\nNamespaces:"
	@kubectl get namespaces
	@echo "\nPods do ArgoCD:"
	@kubectl get pods -n $(ARGOCD_NAMESPACE)
	@echo "\nServiços do ArgoCD:"
	@kubectl get svc -n $(ARGOCD_NAMESPACE)

setup-complete: ## Configuração completa do ambiente
	@echo "🚀 Configurando ambiente completo..."
	make create-cluster
	make install-argocd
	make install-ingress
	@echo "✅ Ambiente pronto para uso!"
	@echo "💡 Execute 'make argocd-port-forward' para acessar o ArgoCD"

check-prereqs: ## Verifica pré-requisitos
	@echo "🔍 Verificando pré-requisitos..."
	@powershell -ExecutionPolicy Bypass -File check-prerequisites.ps1