# Testes unitários para a GitOps Demo API
# Estes testes serão executados no pipeline de CI

import unittest
import json
import sys
import os

# Adicionar o diretório src ao path para importar a aplicação
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from app import app

class GitOpsDemoAPITestCase(unittest.TestCase):
    """Testes para a GitOps Demo API"""
    
    def setUp(self):
        """Configuração antes de cada teste"""
        self.app = app.test_client()
        self.app.testing = True
        
    def test_home_endpoint(self):
        """Testa o endpoint principal /"""
        response = self.app.get('/')
        self.assertEqual(response.status_code, 200)
        
        data = json.loads(response.data)
        self.assertIn('message', data)
        self.assertIn('version', data)
        self.assertIn('environment', data)
        self.assertIn('hostname', data)
        self.assertIn('timestamp', data)
        
    def test_health_endpoint(self):
        """Testa o endpoint de health check"""
        response = self.app.get('/health')
        self.assertEqual(response.status_code, 200)
        
        data = json.loads(response.data)
        self.assertEqual(data['status'], 'healthy')
        self.assertIn('version', data)
        self.assertIn('timestamp', data)
        
    def test_ready_endpoint(self):
        """Testa o endpoint de readiness check"""
        response = self.app.get('/ready')
        self.assertEqual(response.status_code, 200)
        
        data = json.loads(response.data)
        self.assertEqual(data['status'], 'ready')
        self.assertIn('version', data)
        
    def test_info_endpoint(self):
        """Testa o endpoint de informações detalhadas"""
        response = self.app.get('/info')
        self.assertEqual(response.status_code, 200)
        
        data = json.loads(response.data)
        self.assertIn('application', data)
        self.assertIn('version', data)
        self.assertIn('environment', data)
        self.assertIn('hostname', data)
        self.assertIn('python_version', data)
        self.assertIn('timestamp', data)
        self.assertIn('headers', data)
        
    def test_version_endpoint(self):
        """Testa o endpoint de versão"""
        response = self.app.get('/version')
        self.assertEqual(response.status_code, 200)
        
        data = json.loads(response.data)
        self.assertIn('version', data)
        
    def test_nonexistent_endpoint(self):
        """Testa endpoint que não existe"""
        response = self.app.get('/nonexistent')
        self.assertEqual(response.status_code, 404)

if __name__ == '__main__':
    # Executar testes
    unittest.main()