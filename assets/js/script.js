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

    // ===== MÁSCARA DE TELEFONE - CADASTRO =====
    const telefoneInput = document.getElementById('cadastro-telefone-input');

    if (telefoneInput) {
        telefoneInput.addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, ''); // Remove tudo que não é dígito
            
            // Aplica a máscara
            if (value.length <= 10) {
                // Formato: (XX) XXXX-XXXX
                value = value.replace(/(\d{2})(\d)/, '($1) $2');
                value = value.replace(/(\d{4})(\d)/, '$1-$2');
            } else {
                // Formato: (XX) XXXXX-XXXX
                value = value.replace(/(\d{2})(\d)/, '($1) $2');
                value = value.replace(/(\d{5})(\d)/, '$1-$2');
            }
            
            e.target.value = value;
        });
    }

    // ===== FILTRO DE PERFIL E MÁSCARAS CPF/CNPJ =====
    const perfilSelect = document.getElementById('cadastro-perfil-select');
    const nomeInput = document.getElementById('cadastro-nome-input');
    const cpfCnpjInput = document.getElementById('cadastro-cpf-cnpj-input');

    function aplicarMascaraCPF(value) {
        value = value.replace(/\D/g, '');
        value = value.replace(/(\d{3})(\d)/, '$1.$2');
        value = value.replace(/(\d{3})(\d)/, '$1.$2');
        value = value.replace(/(\d{3})(\d{1,2})$/, '$1-$2');
        return value;
    }

    function aplicarMascaraCNPJ(value) {
        value = value.replace(/\D/g, '');
        value = value.replace(/(\d{2})(\d)/, '$1.$2');
        value = value.replace(/(\d{3})(\d)/, '$1.$2');
        value = value.replace(/(\d{3})(\d)/, '$1/$2');
        value = value.replace(/(\d{4})(\d{1,2})$/, '$1-$2');
        return value;
    }

    if (perfilSelect && nomeInput && cpfCnpjInput) {
        perfilSelect.addEventListener('change', function() {
            const perfil = this.value;
            
            // Limpa o campo CPF/CNPJ ao trocar perfil
            cpfCnpjInput.value = '';
            
            if (perfil === 'ong') {
                // ONG: Nome da Instituição + CNPJ
                nomeInput.placeholder = 'Nome da Instituição';
                cpfCnpjInput.placeholder = 'CNPJ';
                cpfCnpjInput.maxLength = 18; // XX.XXX.XXX/XXXX-XX
            } else {
                // Apoiador/Adotante: Nome Completo + CPF
                nomeInput.placeholder = 'Nome Completo';
                cpfCnpjInput.placeholder = 'CPF';
                cpfCnpjInput.maxLength = 14; // XXX.XXX.XXX-XX
            }
        });

        // Aplica máscara no campo CPF/CNPJ conforme digita
        cpfCnpjInput.addEventListener('input', function(e) {
            const perfil = perfilSelect.value;
            let value = e.target.value;
            
            if (perfil === 'ong') {
                e.target.value = aplicarMascaraCNPJ(value);
            } else if (perfil === 'apoiador' || perfil === 'adotante') {
                e.target.value = aplicarMascaraCPF(value);
            }
        });
    }

    // ===== TOGGLE SENHA - CONFIRMAR SENHA (CADASTRO) =====
    const confirmPasswordToggle = document.getElementById('cadastro-confirm-toggle');
    const confirmPasswordInput = document.getElementById('cadastro-confirm-password-input');
    const confirmEyeIcon = document.getElementById('cadastro-confirm-eye-icon');

    if (confirmPasswordToggle && confirmPasswordInput && confirmEyeIcon) {
        confirmPasswordToggle.addEventListener('click', function() {
            const type = confirmPasswordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            confirmPasswordInput.setAttribute('type', type);

            if (type === 'text') {
                confirmEyeIcon.src = '../assets/img/eyeopen.png';
                confirmEyeIcon.alt = 'Ocultar senha';
            } else {
                confirmEyeIcon.src = '../assets/img/eyeclose.png';
                confirmEyeIcon.alt = 'Mostrar senha';
            }
        });
    }

    // ===== TOGGLE SENHA - REDEFINIR SENHA =====
    const novaSenhaToggle = document.getElementById('nova-senha-toggle');
    const novaSenhaInput = document.getElementById('nova-senha-input');
    const novaSenhaEye = document.getElementById('nova-senha-eye');

    if (novaSenhaToggle && novaSenhaInput && novaSenhaEye) {
        novaSenhaToggle.addEventListener('click', function() {
            const type = novaSenhaInput.getAttribute('type') === 'password' ? 'text' : 'password';
            novaSenhaInput.setAttribute('type', type);
            novaSenhaEye.src = type === 'text' ? '../assets/img/eyeopen.png' : '../assets/img/eyeclose.png';
            novaSenhaEye.alt = type === 'text' ? 'Ocultar senha' : 'Mostrar senha';
        });
    }

    const confirmarNovaToggle = document.getElementById('confirmar-nova-toggle');
    const confirmarNovaInput = document.getElementById('confirmar-nova-senha-input');
    const confirmarNovaEye = document.getElementById('confirmar-nova-eye');

    if (confirmarNovaToggle && confirmarNovaInput && confirmarNovaEye) {
        confirmarNovaToggle.addEventListener('click', function() {
            const type = confirmarNovaInput.getAttribute('type') === 'password' ? 'text' : 'password';
            confirmarNovaInput.setAttribute('type', type);
            confirmarNovaEye.src = type === 'text' ? '../assets/img/eyeopen.png' : '../assets/img/eyeclose.png';
            confirmarNovaEye.alt = type === 'text' ? 'Ocultar senha' : 'Mostrar senha';
        });
    }

    // ===== VALIDAÇÃO DE CONFIRMAÇÃO DE SENHA =====
    const passwordInput = document.getElementById('cadastro-password-input');
    const passwordMessage = document.getElementById('password-match-message');

    function validatePasswords() {
        if (passwordInput && confirmPasswordInput && passwordMessage) {
            const password = passwordInput.value;
            const confirmPassword = confirmPasswordInput.value;

            if (confirmPassword === '') {
                passwordMessage.textContent = '';
                passwordMessage.className = 'password-match-message';
                return;
            }

            if (password === confirmPassword) {
                passwordMessage.textContent = '✓ As senhas coincidem';
                passwordMessage.className = 'password-match-message success';
            } else {
                passwordMessage.textContent = '✗ As senhas não coincidem';
                passwordMessage.className = 'password-match-message error';
            }
        }
    }

    if (passwordInput && confirmPasswordInput) {
        passwordInput.addEventListener('input', validatePasswords);
        confirmPasswordInput.addEventListener('input', validatePasswords);
    }

    // Validação no submit do formulário
    const cadastroForm = document.querySelector('.auth-page--cadastro .auth-form');
    if (cadastroForm && passwordInput && confirmPasswordInput) {
        cadastroForm.addEventListener('submit', function(e) {
            if (passwordInput.value !== confirmPasswordInput.value) {
                e.preventDefault();
                alert('As senhas não coincidem. Por favor, verifique.');
                confirmPasswordInput.focus();
            }
        });
    }
});
