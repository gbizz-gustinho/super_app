@frota_bp.route('/dashboard')
def dashboard():
    # 1. Verifica se o usuário está logado
    if 'user_id' not in session:
        return redirect(url_for('auth.login'))
    
    # 2. Verifica se o usuário já vinculou uma empresa (SaaS Multi-tenant)
    if not session.get('id_empresa'):
        flash("Por favor, cadastre sua empresa para continuar.", "warning")
        return redirect(url_for('frota_bp.setup_empresa'))

    # 3. Busca dados REAIS filtrando pelo id_empresa
    db = get_db()
    resumo = {
        'total_veiculos': db.execute("SELECT COUNT(*) FROM vei_imobilizado WHERE id_empresa = ?", (session['id_empresa'],)).fetchone()[0],
        'saldo': 0.00,
        'alertas': 3
    }
    
    return render_template('app/dashboard.html', resumo=resumo)