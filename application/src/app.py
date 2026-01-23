# API Flask simples para demonstrar GitOps
# Esta aplicação será containerizada e deployada via ArgoCD

from flask import Flask, jsonify, request
import os
import socket
import datetime

app = Flask(__name__)

VERSION = os.getenv('APP_VERSION', '1.0.0')
ENVIRONMENT = os.getenv('ENVIRONMENT', 'development')

@app.route('/')
def home():
    """Endpoint principal com informações da aplicação"""
    return jsonify({
        'message': 'GitOps Demo API está funcionando!',
        'version': VERSION,
        'environment': ENVIRONMENT,
        'hostname': socket.gethostname(),
        'timestamp': datetime.datetime.now().isoformat()
    })

@app.route('/health')
def health():
    """Endpoint de health check para Kubernetes"""
    return jsonify({
        'status': 'healthy',
        'version': VERSION,
        'timestamp': datetime.datetime.now().isoformat()
    }), 200

@app.route('/ready')
def ready():
    """Endpoint de readiness check para Kubernetes"""
    return jsonify({
        'status': 'ready',
        'version': VERSION
    }), 200

@app.route('/info')
def info():
    """Endpoint com informações detalhadas do ambiente"""
    return jsonify({
        'application': 'GitOps Demo API',
        'version': VERSION,
        'environment': ENVIRONMENT,
        'hostname': socket.gethostname(),
        'python_version': os.sys.version,
        'timestamp': datetime.datetime.now().isoformat(),
        'headers': dict(request.headers)
    })

@app.route('/version')
def version():
    """Endpoint simples para verificar versão"""
    return jsonify({
        'version': VERSION
    })

if __name__ == '__main__':
    port = int(os.getenv('PORT', 5000))
    debug = os.getenv('DEBUG', 'False').lower() == 'true'
    
    print(f"Iniciando GitOps Demo API v{VERSION}")
    print(f"Ambiente: {ENVIRONMENT}")
    print(f"Debug: {debug}")
    print(f"Porta: {port}")
    
    app.run(host='0.0.0.0', port=port, debug=debug)