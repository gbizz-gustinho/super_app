from flask import Blueprint, render_template, request, flash, redirect, url_for, session
from database import get_db
from app.extensions import bcrypt
import sqlite3

auth_bp = Blueprint('auth', __name__, template_folder='../templates/auth')

@auth_bp.route('/register', methods=['POST'])
def register():
    nome = request.form.get('nome')
    email = request.form.get('email')
    senha = request.form.get('senha')
    
    if not nome or not email or not senha:
        flash('Preencha todos os campos obrigatórios.', 'danger')
        return redirect(url_for('auth.login'))

    hashed_senha = bcrypt.generate_password_hash(senha).decode('utf-8')
    
    db = get_db()
    try:
        db.execute(
            'INSERT INTO login_usuarios (nome, email, senha) VALUES (?, ?, ?)',
            (nome, email, hashed_senha)
        )
        db.commit()
        flash('Conta criada com sucesso!', 'success')
    except sqlite3.IntegrityError:
        flash('Este e-mail já está em uso.', 'warning')
    finally:
        db.close()
        
    return redirect(url_for('auth.login'))

@auth_bp.route('/logout')
def logout():
    session.clear() # Limpa os dados do usuário
    return redirect(url_for('auth.login'))    

@auth_bp.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form.get('email')
        senha = request.form.get('senha')
        
        db = get_db()
        user = db.execute('SELECT * FROM login_usuarios WHERE email = ?', (email,)).fetchone()
        db.close()

        if user and bcrypt.check_password_hash(user['senha'], senha):
            session.clear()
            session['user_id'] = user['id']
            session['username'] = user['nome']
            session['id_empresa'] = user['id_empresa']

            # --- PONTE DIRETA PARA DASHBOARD ---
            # Comentamos o setup para evitar o BuildError e cair direto no trabalho
            # if not user['id_empresa']:
            #     return redirect(url_for('frota_bp.setup_empresa'))
            
            return redirect('/dashboard') # Isso ignora o nome da função e vai direto para a URL # <--- Alvo principal
        
        flash('E-mail ou senha inválidos.', 'danger')
    
    # Ajustado para o caminho que funcionou no seu log (templates/site_section/login.html)
    return render_template('site_section/login.html')