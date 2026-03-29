# routes/site_routes.py
from flask import Blueprint, render_template, request, flash, redirect, url_for, current_app
from app.extensions import mail
from flask_mail import Message
import sqlite3
import os

site_bp = Blueprint('site_bp', __name__)

def get_db():
    # Caminho para o banco de dados que você enviou
    db = sqlite3.connect('xmei_pj.db')
    db.row_factory = sqlite3.Row
    return db

@site_bp.route('/')
def index():
    return render_template('site_section/index.html')

@site_bp.route('/funcionalidades')
def funcionalidades():
    return render_template('site_section/funcionalidades.html')

@site_bp.route('/beneficios')
def beneficios():
    return render_template('site_section/beneficios.html')

@site_bp.route('/precos')
def precos():
    return render_template('site_section/precos.html')

@site_bp.route('/contato', methods=['GET', 'POST'])
def contato():
    if request.method == 'POST':
        nome = request.form.get('nome')
        email = request.form.get('email')
        msg_corpo = request.form.get('mensagem')

        try:
            msg = Message(
                subject=f"Novo Contato xMei PJ : {nome}",
                sender=current_app.config['MAIL_USERNAME'],
                recipients=[current_app.config['MAIL_USERNAME']],
                body=f"Nome: {nome}\nEmail: {email}\n\nMensagem:\n{msg_corpo}"
            )
            mail.send(msg)
            flash("Sua mensagem foi enviada com sucesso!", "success")
        except Exception as e:
            flash(f"Erro ao enviar e-mail: {e}", "danger")
        
        return redirect(url_for('site_bp.contato'))
    return render_template('site_section/contato.html')

@site_bp.route('/site_section/cadastro_gratis')
def cadastro_gratis():
    return render_template('site_section/cadastro_gratis.html')

@site_bp.route('/processar_cadastro', methods=['POST'])
def processar_dados(): # O nome da função é processar_dados
    ...