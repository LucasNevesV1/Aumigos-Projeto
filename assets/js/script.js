// ===== TOGGLE DE MOSTRAR/OCULTAR SENHA =====
// Padronização: kebab-case para IDs

document.addEventListener('DOMContentLoaded', function() {
    // ===== TOGGLE SENHA - LOGIN =====
    const loginPasswordToggle = document.getElementById('login-password-toggle');
    const loginPasswordInput = document.getElementById('login-password-input');
    const loginEyeIcon = document.getElementById('login-eye-icon');

    if (loginPasswordToggle && loginPasswordInput && loginEyeIcon) {
        loginPasswordToggle.addEventListener('click', function() {
            // Alterna entre 'password' e 'text'
            const type = loginPasswordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            loginPasswordInput.setAttribute('type', type);

            // Troca o ícone
            if (type === 'text') {
                // Mostrando senha - usa eyeopen
                loginEyeIcon.src = '../assets/img/eyeopen.png';
                loginEyeIcon.alt = 'Ocultar senha';
            } else {
                // Ocultando senha - usa eyeclose
                loginEyeIcon.src = '../assets/img/eyeclose.png';
                loginEyeIcon.alt = 'Mostrar senha';
            }
        });
    }

    // ===== TOGGLE SENHA - CADASTRO =====
    const cadastroPasswordToggle = document.getElementById('cadastro-password-toggle');
    const cadastroPasswordInput = document.getElementById('cadastro-password-input');
    const cadastroEyeIcon = document.getElementById('cadastro-eye-icon');

    if (cadastroPasswordToggle && cadastroPasswordInput && cadastroEyeIcon) {
        cadastroPasswordToggle.addEventListener('click', function() {
            // Alterna entre 'password' e 'text'
            const type = cadastroPasswordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            cadastroPasswordInput.setAttribute('type', type);

            // Troca o ícone
            if (type === 'text') {
                // Mostrando senha - usa eyeopen
                cadastroEyeIcon.src = '../assets/img/eyeopen.png';
                cadastroEyeIcon.alt = 'Ocultar senha';
            } else {
                // Ocultando senha - usa eyeclose
                cadastroEyeIcon.src = '../assets/img/eyeclose.png';
                cadastroEyeIcon.alt = 'Mostrar senha';
            }
        });
    }
});
