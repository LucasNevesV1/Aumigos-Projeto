// ===== TOGGLE DE MOSTRAR/OCULTAR SENHA =====
// Padronização: kebab-case para IDs

document.addEventListener('DOMContentLoaded', function () {
    // ===== TOGGLE SENHA - LOGIN =====
    const loginPasswordToggle = document.getElementById('login-password-toggle');
    const loginPasswordInput = document.getElementById('login-password-input');
    const loginEyeIcon = document.getElementById('login-eye-icon');

    if (loginPasswordToggle && loginPasswordInput && loginEyeIcon) {
        loginPasswordToggle.addEventListener('click', function () {
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
        cadastroPasswordToggle.addEventListener('click', function () {
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
        telefoneInput.addEventListener('input', function (e) {
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
        perfilSelect.addEventListener('change', function () {
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
        cpfCnpjInput.addEventListener('input', function (e) {
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
        confirmPasswordToggle.addEventListener('click', function () {
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
        cadastroForm.addEventListener('submit', function (e) {
            if (passwordInput.value !== confirmPasswordInput.value) {
                e.preventDefault();
                alert('As senhas não coincidem. Por favor, verifique.');
                confirmPasswordInput.focus();
            }
        });
    }

    // ===== LOGIN - FEEDBACK =====
    const loginForm = document.getElementById('login-form');

    if (loginForm) {
        const loginParams = new URLSearchParams(window.location.search);

        if (loginParams.get('cadastro') === 'sucesso') {
            const msg = document.createElement('p');
            msg.className = 'auth-feedback auth-feedback--sucesso';
            msg.textContent = loginParams.get('msg') === 'senha_redefinida'
                ? 'Senha redefinida com sucesso! Faça seu login.'
                : 'Cadastro realizado com sucesso! Faça seu login.';
            loginForm.insertAdjacentElement('beforebegin', msg);
        }

        if (loginParams.get('erro') === 'credenciais_invalidas') {
            const msg = document.createElement('p');
            msg.className = 'auth-feedback auth-feedback--erro';
            msg.textContent = 'E-mail ou senha incorretos.';
            loginForm.insertAdjacentElement('beforebegin', msg);
        }
    }

    // ===== ESQUECI SENHA - FEEDBACK =====
    const esqueciSenhaForm = document.getElementById('esqueci-senha-form');

    if (esqueciSenhaForm) {
        const esqueciParams = new URLSearchParams(window.location.search);

        if (esqueciParams.get('status') === 'enviado') {
            const msg = document.createElement('p');
            msg.className = 'auth-feedback auth-feedback--sucesso';
            msg.textContent = 'Se esse e-mail estiver cadastrado, você receberá o link em instantes.';
            esqueciSenhaForm.insertAdjacentElement('beforebegin', msg);
        }

        if (esqueciParams.get('erro') === 'email_vazio') {
            const msg = document.createElement('p');
            msg.className = 'auth-feedback auth-feedback--erro';
            msg.textContent = 'Informe um e-mail válido.';
            esqueciSenhaForm.insertAdjacentElement('beforebegin', msg);
        }
    }

    // ===== REDEFINIR SENHA - TOKEN E FEEDBACK =====
    const redefinirForm = document.getElementById('redefinir-form');

    if (redefinirForm) {
        const redefinirParams = new URLSearchParams(window.location.search);
        const token = redefinirParams.get('token');

        if (!token) {
            const msg = document.createElement('p');
            msg.className = 'auth-feedback auth-feedback--erro';
            msg.textContent = 'Link inválido ou expirado. Solicite um novo.';
            redefinirForm.insertAdjacentElement('beforebegin', msg);
            redefinirForm.style.display = 'none';
        } else {
            document.getElementById('token-input').value = token;
        }

        const erros = {
            token_invalido:    'Link inválido ou expirado. Solicite um novo.',
            campos_vazios:     'Preencha todos os campos.',
            senhas_diferentes: 'As senhas não coincidem.',
        };

        const erro = redefinirParams.get('erro');
        if (erro && erros[erro]) {
            const msg = document.createElement('p');
            msg.className = 'auth-feedback auth-feedback--erro';
            msg.textContent = erros[erro];
            redefinirForm.insertAdjacentElement('beforebegin', msg);
        }
    }

    // ===== HEADER MOBILE - HAMBURGER =====
    const headerToggle = document.getElementById('header-mobile-toggle');
    const headerNav = document.getElementById('header-nav');

    if (headerToggle && headerNav) {
        headerToggle.addEventListener('click', function () {
            const isOpen = headerNav.classList.toggle('nav-open');
            headerToggle.setAttribute('aria-expanded', isOpen);
        });

        // Fecha o menu ao clicar em qualquer link da nav
        headerNav.querySelectorAll('a').forEach(function (link) {
            link.addEventListener('click', function () {
                headerNav.classList.remove('nav-open');
                headerToggle.setAttribute('aria-expanded', 'false');
            });
        });
    }

    // ===== DEPOIMENTOS - TROCA DE ABAS =====
    const depTabs = document.querySelectorAll('.dep-tab');
    const depPanels = document.querySelectorAll('.dep-panel');
    const depTabsWrapper = document.querySelector('.depoimentos-tabs');

    depTabs.forEach(function (tab) {
        tab.addEventListener('click', function () {
            const alvo = tab.getAttribute('data-tab');

            depTabs.forEach(t => t.classList.remove('dep-tab--active'));
            tab.classList.add('dep-tab--active');

            if (depTabsWrapper) depTabsWrapper.setAttribute('data-active', alvo);

            depPanels.forEach(function (panel) {
                panel.classList.toggle('dep-panel--active', panel.getAttribute('data-panel') === alvo);
            });
        });
    });

    // Define o estado inicial
    if (depTabsWrapper) depTabsWrapper.setAttribute('data-active', 'ongs');

    // ===== CONSULTA ANIMAL - NAVBAR =====
    const navbar = document.getElementById('floatingNavbar');
    const menuToggle = document.getElementById('menuToggle');
    const profileToggle = document.getElementById('profileToggle');
    const profileDropdown = document.getElementById('profileDropdown');

    if (menuToggle && navbar) {
        menuToggle.addEventListener('click', function (event) {
            navbar.classList.toggle('menu-open');
            if (profileDropdown) {
                profileDropdown.classList.remove('profile-open');
                navbar.classList.remove('profile-open');
            }
            event.stopPropagation();
        });
    }

    if (profileToggle && profileDropdown) {
        profileToggle.addEventListener('click', function (event) {
            profileDropdown.classList.toggle('profile-open');
            if (navbar) {
                navbar.classList.toggle('profile-open');
                navbar.classList.remove('menu-open');
            }
            event.stopPropagation();
        });
    }

    document.addEventListener('click', function (event) {
        if (navbar && menuToggle && !menuToggle.contains(event.target) && navbar.classList.contains('menu-open')) {
            navbar.classList.remove('menu-open');
        }
        if (profileToggle && !profileToggle.contains(event.target) && profileDropdown && profileDropdown.classList.contains('profile-open')) {
            profileDropdown.classList.remove('profile-open');
            if (navbar) navbar.classList.remove('profile-open');
        }
    });

    // ===== CONSULTA ANIMAL - RENDERIZAÇÃO DA LISTA =====
    const listaContainer = document.querySelector('.consulta-list');
    if (listaContainer) {
        const itensPorPagina = 8;
        let paginaAtual = 1;
        let dados = [];

        function renderizarLista(pagina) {
            listaContainer.querySelectorAll('.list-row').forEach(row => row.remove());

            const inicio = (pagina - 1) * itensPorPagina;
            const itensDaPagina = dados.slice(inicio, inicio + itensPorPagina);

            itensDaPagina.forEach(animal => {
                const id = animal.id_animal;
                const entrada = animal.data_entrada || '---';
                const status = animal.status || 'disponivel';
                const row = document.createElement('div');
                row.className = 'list-row grid-layout';
                row.innerHTML = `
                    <div class="col-checkbox"><input type="checkbox" class="custom-checkbox animal-check" data-id="${id}"></div>
                    <div class="col-id font-bold">${id}</div>
                    <div class="col-nome">
                        <div class="animal-photo"></div>
                        <span class="font-bold">${animal.nome}</span>
                    </div>
                    <div class="col-perfil font-bold">${animal.especie}<br>${animal.raca}</div>
                    <div class="col-caracteristicas font-bold">${animal.genero}</div>
                    <div class="col-entrada font-bold">${entrada}</div>
                    <div class="col-status">
                        <select class="status-badge status-${status}" data-id="${id}" onchange="atualizarCorStatus(this)">
                            <option value="disponivel" ${status === 'disponivel' ? 'selected' : ''}>Disponível</option>
                            <option value="tratamento" ${status === 'tratamento' ? 'selected' : ''}>Em tratamento</option>
                            <option value="processo" ${status === 'processo' ? 'selected' : ''}>Processo</option>
                            <option value="adotado" ${status === 'adotado' ? 'selected' : ''}>Adotado</option>
                        </select>
                    </div>
                `;
                listaContainer.appendChild(row);
            });

            atualizarBotoesPaginacao();
        }

        function atualizarBotoesPaginacao() {
            const totalPaginas = Math.ceil(dados.length / itensPorPagina);
            const containerPaginacao = document.querySelector('.pagination');
            if (!containerPaginacao) return;

            containerPaginacao.innerHTML = '';
            if (totalPaginas === 0) return;

            const btnPrev = document.createElement('button');
            btnPrev.className = 'page-btn';
            btnPrev.innerHTML = `<svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2" fill="none"><polyline points="15 18 9 12 15 6"></polyline></svg>`;
            btnPrev.disabled = paginaAtual === 1;
            btnPrev.onclick = () => { paginaAtual--; renderizarLista(paginaAtual); };
            containerPaginacao.appendChild(btnPrev);

            for (let i = 1; i <= totalPaginas; i++) {
                const btnNum = document.createElement('button');
                btnNum.className = `page-btn ${i === paginaAtual ? 'active' : ''}`;
                btnNum.textContent = i;
                btnNum.onclick = () => { paginaAtual = i; renderizarLista(paginaAtual); };
                containerPaginacao.appendChild(btnNum);
            }

            const btnNext = document.createElement('button');
            btnNext.className = 'page-btn';
            btnNext.innerHTML = `<svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2" fill="none"><polyline points="9 18 15 12 9 6"></polyline></svg>`;
            btnNext.disabled = paginaAtual === totalPaginas;
            btnNext.onclick = () => { paginaAtual++; renderizarLista(paginaAtual); };
            containerPaginacao.appendChild(btnNext);
        }

        // Carrega animais do banco
        fetch('../actions/animal.php?action=listar')
            .then(r => r.json())
            .then(lista => { dados = lista; renderizarLista(paginaAtual); })
            .catch(() => console.error('Erro ao carregar animais'));

        const btnEditar = document.getElementById('btnEditar');
        const btnExcluir = document.getElementById('btnExcluir');

        function atualizarBotoesAcao() {
            const total = document.querySelectorAll('.animal-check:checked').length;
            if (btnEditar) btnEditar.disabled = total !== 1;
            if (btnExcluir) btnExcluir.disabled = total === 0;
        }

        listaContainer.addEventListener('change', function (e) {
            if (e.target.classList.contains('animal-check')) atualizarBotoesAcao();
        });

        const checkMaster = document.querySelector('.list-header .custom-checkbox');
        if (checkMaster) {
            checkMaster.addEventListener('change', function () {
                document.querySelectorAll('.animal-check').forEach(cb => cb.checked = checkMaster.checked);
                atualizarBotoesAcao();
            });
        }

        if (btnExcluir) {
            btnExcluir.addEventListener('click', function () {
                const selecionados = [...document.querySelectorAll('.animal-check:checked')];
                const ids = selecionados.map(cb => Number(cb.dataset.id));
                if (!confirm(`Excluir ${ids.length} animal(is)?`)) return;

                fetch('../actions/animal.php', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ action: 'excluir', ids })
                })
                .then(r => r.json())
                .then(res => {
                    if (res.erro) { alert('Erro ao excluir: ' + res.erro); return; }
                    dados = dados.filter(a => !ids.includes(a.id_animal));
                    paginaAtual = 1;
                    renderizarLista(paginaAtual);
                    atualizarBotoesAcao();
                })
                .catch(() => alert('Erro ao conectar com o servidor.'));
            });
        }

        if (btnEditar) {
            btnEditar.addEventListener('click', function () {
                const id = document.querySelector('.animal-check:checked').dataset.id;
                window.location.href = `registro-animal.html?id=${id}`;
            });
        }
    }

});

// ===== CONSULTA ANIMAL - ATUALIZAR STATUS (global) =====
function atualizarCorStatus(selectElement) {
    const animalId = selectElement.getAttribute('data-id');
    const novoStatus = selectElement.value;

    selectElement.classList.remove('status-disponivel', 'status-tratamento', 'status-processo', 'status-adotado');
    selectElement.classList.add('status-' + novoStatus);

    fetch('../actions/animal.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: 'status', id: animalId, status: novoStatus })
    });
}
