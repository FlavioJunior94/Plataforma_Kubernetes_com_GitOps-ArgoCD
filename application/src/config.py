# Configurações da aplicação GitOps Demo API. Este arquivo centraliza as configurações por ambiente
import os

class Config:
    """Configuração base"""
    SECRET_KEY = os.getenv('SECRET_KEY', 'dev-secret-key-change-in-production')
    DEBUG = False
    TESTING = False
    
class DevelopmentConfig(Config):
    """Configuração para desenvolvimento"""
    DEBUG = True
    ENVIRONMENT = 'development'
    
class StagingConfig(Config):
    """Configuração para staging"""
    DEBUG = False
    ENVIRONMENT = 'staging'
    
class ProductionConfig(Config):
    """Configuração para produção"""
    DEBUG = False
    ENVIRONMENT = 'production'
    
# Mapeamento de configurações por ambiente
config = {
    'development': DevelopmentConfig,
    'staging': StagingConfig,
    'production': ProductionConfig,
    'default': DevelopmentConfig
}