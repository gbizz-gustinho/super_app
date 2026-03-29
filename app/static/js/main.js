// Espera o documento carregar para garantir que os elementos existem
document.addEventListener('DOMContentLoaded', () => {

    // Pega os elementos pelo ID que definimos
    const hamburgerButton = document.getElementById('hamburger-button');
    const sidebar = document.getElementById('sidebar');
    const hamburgerIcon = document.getElementById('hamburger-icon');
    const closeIcon = document.getElementById('close-icon');

    // Se o botão não existir na página, não faz nada
    if (hamburgerButton) {
        // Adiciona um "ouvinte" de clique no botão
        hamburgerButton.addEventListener('click', () => {
            // Alterna a classe que esconde/mostra a sidebar
            sidebar.classList.toggle('-translate-x-full');

            // Alterna qual ícone está visível (hambúrguer ou X)
            hamburgerIcon.classList.toggle('hidden');
            closeIcon.classList.toggle('hidden');
        });
    }

});

// ... (código do hamburger que já está lá) ...

// =======================================================
// LÓGICA PARA O BOTÃO DE ALTERNAR TEMA (DARK MODE)
// =======================================================

// Pega o botão de tema e o elemento <html>
const themeToggleButton = document.getElementById('theme-toggle');
const rootHtml = document.documentElement; // A tag <html>

// Função para aplicar o tema (dark ou light)
const applyTheme = (theme) => {
    if (theme === 'dark') {
        rootHtml.classList.add('dark');
    } else {
        rootHtml.classList.remove('dark');
    }
};

// **Verifica o tema salvo no navegador assim que a página carrega**
// Isso evita o "flash" de tema claro antes de carregar o escuro
const savedTheme = localStorage.getItem('theme') || (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
applyTheme(savedTheme);

// Adiciona o "ouvinte" de clique no botão
if (themeToggleButton) {
    themeToggleButton.addEventListener('click', () => {
        // Verifica se o tema atual é 'dark'
        const isDarkMode = rootHtml.classList.contains('dark');
        
        if (isDarkMode) {
            // Se for dark, muda para light
            applyTheme('light');
            localStorage.setItem('theme', 'light');
        } else {
            // Se for light, muda para dark
            applyTheme('dark');
            localStorage.setItem('theme', 'dark');
        }
    });
}