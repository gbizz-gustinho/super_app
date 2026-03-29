# app.py (Versão final e completa)

import sys
import os

# Adiciona o diretório raiz do projeto ao caminho do Python
sys.path.insert(0, os.path.abspath(os.path.dirname(__file__)))

from flask import Flask

# Importe suas extensões e blueprints
from app.extensions import bcrypt, mail
from database import close_connection
from app.routes.site_routes import site_bp
from app.routes.auth import auth_bp

def create_app():
    """Cria e configura uma instância do aplicativo Flask."""
    
    app = Flask(__name__, template_folder='app/templates', static_folder='app/static')

    # Configuração
    app.config['SECRET_KEY'] = os.getenv('FLASK_SECRET_KEY', 'uma-chave-secreta-padrao-para-dev')
    app.config['MAIL_SERVER'] = 'smtp.gmail.com'
    app.config['MAIL_PORT'] = 587
    app.config['MAIL_USE_TLS'] = True
    app.config['MAIL_USERNAME'] = os.getenv('MAIL_USERNAME')
    app.config['MAIL_PASSWORD'] = os.getenv('MAIL_PASSWORD')
    app.config['MAIL_DEFAULT_SENDER'] = os.getenv('MAIL_USERNAME')

    # Inicialização das Extensões
    bcrypt.init_app(app)
    mail.init_app(app)

    # Registro dos Blueprints
    app.register_blueprint(site_bp)
    app.register_blueprint(auth_bp, url_prefix='/auth')

    # Registro de Funções de Contexto
    @app.teardown_appcontext
    def teardown_db(exception):
        close_connection(exception)
        
    return app

if __name__ == '__main__':
    app = create_app()
    # A sua linha correta, para permitir acesso externo na rede local
    app.run(debug=True, host='0.0.0.0', port=5000)
