document.addEventListener('DOMContentLoaded', function () {

    // ===== HELPER: TOGGLE SENHA =====
    function setupPasswordToggle(toggleId, inputId, eyeId) {
        const toggle = document.getElementById(toggleId);
        const input = document.getElementById(inputId);
        const eye = document.getElementById(eyeId);
        if (!toggle || !input || !eye) return;

        toggle.addEventListener('click', function () {
            const show = input.getAttribute('type') === 'password';
            input.setAttribute('type', show ? 'text' : 'password');
            eye.src = show ? '../assets/img/eyeopen.png' : '../assets/img/eyeclose.png';
            eye.alt = show ? 'Ocultar senha' : 'Mostrar senha';
        });
    }

    setupPasswordToggle('login-password-toggle',    'login-password-input',          'login-eye-icon');
    setupPasswordToggle('cadastro-password-toggle', 'cadastro-password-input',       'cadastro-eye-icon');
    setupPasswordToggle('cadastro-confirm-toggle',  'cadastro-confirm-password-input','cadastro-confirm-eye-icon');
    setupPasswordToggle('nova-senha-toggle',        'nova-senha-input',              'nova-senha-eye');
    setupPasswordToggle('confirmar-nova-toggle',    'confirmar-nova-senha-input',    'confirmar-nova-eye');

    // ===== CADASTRO - MÁSCARA DE TELEFONE =====
    const telefoneInput = document.getElementById('cadastro-telefone-input');

    if (telefoneInput) {
        telefoneInput.addEventListener('input', function (e) {
            let value = e.target.value.replace(/\D/g, '');

            if (value.length <= 10) {
                value = value.replace(/(\d{2})(\d)/, '($1) $2');
                value = value.replace(/(\d{4})(\d)/, '$1-$2');
            } else {
                value = value.replace(/(\d{2})(\d)/, '($1) $2');
                value = value.replace(/(\d{5})(\d)/, '$1-$2');
            }

            e.target.value = value;
        });
    }

    // ===== CADASTRO - PERFIL E MÁSCARAS CPF/CNPJ =====
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
        const camposApoiadorCadastro = document.querySelectorAll('.cadastro-apoiador-field');

        perfilSelect.addEventListener('change', function () {
            cpfCnpjInput.value = '';
            const isOng      = this.value === 'ong';
            const isApoiador = this.value === 'apoiador';

            nomeInput.placeholder      = isOng ? 'Nome da Instituição' : 'Nome Completo';
            cpfCnpjInput.placeholder   = isOng ? 'CNPJ' : 'CPF';
            cpfCnpjInput.maxLength     = isOng ? 18 : 14;

            camposApoiadorCadastro.forEach(el => {
                el.style.display = isApoiador ? '' : 'none';
            });
        });

        cpfCnpjInput.addEventListener('input', function (e) {
            if (perfilSelect.value === 'ong') {
                e.target.value = aplicarMascaraCNPJ(e.target.value);
            } else {
                e.target.value = aplicarMascaraCPF(e.target.value);
            }
        });
    }

    // ===== CADASTRO - VALIDAÇÃO DE SENHAS =====
    const passwordInput = document.getElementById('cadastro-password-input');
    const confirmPasswordInput = document.getElementById('cadastro-confirm-password-input');
    const passwordMessage = document.getElementById('password-match-message');

    function validatePasswords() {
        if (!passwordInput || !confirmPasswordInput || !passwordMessage) return;
        const confirmPassword = confirmPasswordInput.value;

        if (confirmPassword === '') {
            passwordMessage.textContent = '';
            passwordMessage.className = 'password-match-message';
            return;
        }

        if (passwordInput.value === confirmPassword) {
            passwordMessage.textContent = '✓ As senhas coincidem';
            passwordMessage.className = 'password-match-message success';
        } else {
            passwordMessage.textContent = '✗ As senhas não coincidem';
            passwordMessage.className = 'password-match-message error';
        }
    }

    if (passwordInput && confirmPasswordInput) {
        passwordInput.addEventListener('input', validatePasswords);
        confirmPasswordInput.addEventListener('input', validatePasswords);
    }

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

    // ===== INDEX - HEADER MOBILE =====
    const headerToggle = document.getElementById('header-mobile-toggle');
    const headerNav = document.getElementById('header-nav');

    if (headerToggle && headerNav) {
        headerToggle.addEventListener('click', function () {
            const isOpen = headerNav.classList.toggle('nav-open');
            headerToggle.setAttribute('aria-expanded', isOpen);
        });

        headerNav.querySelectorAll('a').forEach(function (link) {
            link.addEventListener('click', function () {
                headerNav.classList.remove('nav-open');
                headerToggle.setAttribute('aria-expanded', 'false');
            });
        });
    }

    // ===== INDEX - DEPOIMENTOS =====
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

    if (depTabsWrapper) depTabsWrapper.setAttribute('data-active', 'ongs');

    // ===== NOME DA ONG NA NAVBAR =====
    const navbarOngNome = document.getElementById('navbarOngNome');
    if (navbarOngNome) {
        fetch('../actions/session-info.php')
            .then(r => r.json())
            .then(data => { if (data.nome) navbarOngNome.textContent = data.nome; })
            .catch(() => {});
    }

    // ===== NAVBAR FLUTUANTE (TELA INICIAL ONGS E CONSULTA ANIMAL) =====
    const navbar = document.getElementById('floatingNavbar');
    const menuToggle = document.getElementById('menuToggle');
    const profileToggle = document.getElementById('profileToggle');
    const profileDropdown = document.getElementById('profileDropdown');

    if (navbar) {
        window.addEventListener('scroll', function () {
            navbar.classList.toggle('scrolled', window.scrollY > 50);
        });
    }

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

    // ===== TELA CONFIG USUÁRIO =====
    const configForm = document.getElementById('configForm');
    if (configForm) {
        const btnVoltar      = document.getElementById('btnVoltar');
        const configLogoLink = document.getElementById('configLogoLink');
        const sidebarPerfil  = document.getElementById('sidebarPerfilLabel');
        const feedback       = document.getElementById('configFeedback');

        // tipousuario: 1=Administrador, 2=ONG, 3=Apoiador, 4=Médico Veterinário
        const tipoLabels = { 1: 'Administrador', 2: 'ONG', 3: 'Apoiador', 4: 'Médico Veterinário' };

        function homeUrl(idTipo) {
            return idTipo === 2 ? 'tela-inicial-ongs.html' : 'interesse-adocao.html';
        }

        function mostrarFeedback(msg, tipo) {
            if (!feedback) return;
            feedback.textContent = msg;
            feedback.className = 'config-feedback ' + tipo;
            setTimeout(() => { feedback.textContent = ''; feedback.className = 'config-feedback'; }, 4000);
        }

        function setVal(id, val) {
            const el = document.getElementById(id);
            if (el) el.value = val || '';
        }

        // Data dinâmica no header
        const agora = new Date();
        const meses = ['Jan','Fev','Mar','Abr','Mai','Jun','Jul','Ago','Set','Out','Nov','Dez'];
        const elDay = document.getElementById('headerDay');
        const elMonth = document.getElementById('headerMonth');
        if (elDay)   elDay.textContent   = String(agora.getDate()).padStart(2, '0');
        if (elMonth) elMonth.textContent = meses[agora.getMonth()];

        fetch('../actions/config-usuario.php')
            .then(r => r.json())
            .then(data => {
                if (data.erro) return;

                const idTipo = parseInt(data.id_tipoUsuario);
                const home   = homeUrl(idTipo);
                if (btnVoltar)      btnVoltar.href      = home;
                if (configLogoLink) configLogoLink.href = home;
                if (sidebarPerfil)  sidebarPerfil.textContent = idTipo === 2 ? 'Perfil ONG' : 'Perfil';

                // Campos pessoais
                setVal('config-nome',           data.nome);
                setVal('config-email',          data.email);
                setVal('config-documento',      data.documento);
                setVal('config-telefone',       data.telefone);
                setVal('config-data-nascimento',data.dataNascimento);
                setVal('config-profissao',      data.profissao);
                setVal('config-id-endereco',    data.id_endereco);

                const generoEl = document.getElementById('config-genero');
                if (generoEl && data.genero) generoEl.value = data.genero;

                // Tipo de conta e data de cadastro (somente leitura)
                setVal('config-tipo-conta', tipoLabels[idTipo] || 'Usuário');
                if (data.dataCadastro) {
                    const [y, m, d] = data.dataCadastro.split('-');
                    setVal('config-data-cadastro', `${d}/${m}/${y}`);
                }

                setVal('config-ativo', data.ativo == 1 ? 'Ativo' : 'Inativo');

                // Profissão e gênero: apenas para Apoiadores (id 3)
                if (idTipo === 3) {
                    document.querySelectorAll('.config-campo-apoiador').forEach(el => el.style.display = 'flex');
                }

                // Data de nascimento: apenas para não-ONGs
                if (idTipo !== 2) {
                    document.querySelectorAll('.config-campo-nao-ong').forEach(el => el.style.display = 'flex');
                }

                // Endereço
                setVal('config-logradouro-tipo', data.logradouro_tipo);
                setVal('config-logradouro-nome', data.logradouro_nome);
                setVal('config-numero',          data.numero);
                setVal('config-cep',             data.cep);
                setVal('config-bairro',          data.bairro);
                setVal('config-complemento',     data.complemento);
                setVal('config-cidade',          data.cidade);
                const estadoEl = document.getElementById('config-estado');
                if (estadoEl && data.estado) estadoEl.value = data.estado;
            })
            .catch(() => {});

        configForm.addEventListener('submit', function (e) {
            e.preventDefault();
            const btn = configForm.querySelector('.config-btn-salvar');
            btn.disabled = true;

            const payload = {
                nome:            document.getElementById('config-nome').value.trim(),
                email:           document.getElementById('config-email').value.trim(),
                telefone:        document.getElementById('config-telefone').value.trim(),
                dataNascimento:  document.getElementById('config-data-nascimento').value || null,
                profissao:       document.getElementById('config-profissao').value.trim(),
                genero:          document.getElementById('config-genero').value,
                senha:           document.getElementById('config-senha').value,
                id_endereco:     document.getElementById('config-id-endereco').value || null,
                logradouro_tipo: document.getElementById('config-logradouro-tipo').value,
                logradouro_nome: document.getElementById('config-logradouro-nome').value.trim(),
                numero:          document.getElementById('config-numero').value.trim(),
                cep:             document.getElementById('config-cep').value.trim(),
                complemento:     document.getElementById('config-complemento').value.trim(),
                bairro:          document.getElementById('config-bairro').value.trim(),
                cidade:          document.getElementById('config-cidade').value.trim(),
                estado:          document.getElementById('config-estado').value,
            };

            fetch('../actions/config-usuario.php', {
                method:  'POST',
                headers: { 'Content-Type': 'application/json' },
                body:    JSON.stringify(payload)
            })
            .then(r => r.json())
            .then(res => {
                if (res.erro) { mostrarFeedback('Erro: ' + res.erro, 'erro'); return; }
                mostrarFeedback('Alterações salvas com sucesso!', 'sucesso');
                document.getElementById('config-senha').value = '';
                const navbar = document.getElementById('navbarOngNome');
                if (navbar) navbar.textContent = payload.nome;
            })
            .catch(() => mostrarFeedback('Erro ao conectar com o servidor.', 'erro'))
            .finally(() => { btn.disabled = false; });
        });
    }

    // ===== CONSULTA ANIMAL - LISTA E PAGINAÇÃO =====
    const listaContainer = document.querySelector('.consulta-list');

    if (listaContainer) {
        const itensPorPagina = 10;
        let paginaAtual  = 1;
        let todosAnimais = [];
        let dados        = [];
        let filtroStatus = '';
        let termoBusca   = '';

        // Expõe estado para a função global atualizarCorStatus
        window._consultaState            = { get todosAnimais() { return todosAnimais; } };
        window._atualizarStatsConsulta   = atualizarStats;

        function cap(str) {
            if (!str) return '—';
            return str.charAt(0).toUpperCase() + str.slice(1);
        }

        function atualizarStats() {
            const el = id => document.getElementById(id);
            if (el('statTotal'))      el('statTotal').textContent      = todosAnimais.length;
            if (el('statDisponivel')) el('statDisponivel').textContent = todosAnimais.filter(a => a.status === 'disponivel').length;
            if (el('statTratamento')) el('statTratamento').textContent = todosAnimais.filter(a => a.status === 'tratamento').length;
            if (el('statAdotado'))    el('statAdotado').textContent    = todosAnimais.filter(a => a.status === 'adotado').length;
        }

        function aplicarFiltros() {
            const termo = termoBusca.toLowerCase();
            dados = todosAnimais.filter(a => {
                const matchStatus = !filtroStatus || a.status === filtroStatus;
                const matchBusca  = !termo ||
                    (a.nome    || '').toLowerCase().includes(termo) ||
                    (a.especie || '').toLowerCase().includes(termo) ||
                    (a.raca    || '').toLowerCase().includes(termo);
                return matchStatus && matchBusca;
            });
            paginaAtual = 1;
            renderizarLista(paginaAtual);
        }

        function renderizarLista(pagina) {
            listaContainer.querySelectorAll('.list-row, .list-empty').forEach(el => el.remove());

            if (dados.length === 0) {
                const vazio = document.createElement('div');
                vazio.className = 'list-empty';
                vazio.textContent = 'Nenhum animal encontrado.';
                listaContainer.appendChild(vazio);
                atualizarBotoesPaginacao();
                return;
            }

            const inicio = (pagina - 1) * itensPorPagina;
            dados.slice(inicio, inicio + itensPorPagina).forEach((animal, index) => {
                const id     = animal.id_animal;
                const numero = inicio + index + 1;
                const entrada = animal.dataEntrada
                    ? animal.dataEntrada.split('-').reverse().join('-')
                    : '---';
                const status = animal.status || 'disponivel';
                const row = document.createElement('div');
                row.className = 'list-row grid-layout';
                row.innerHTML = `
                    <div class="col-checkbox"><input type="checkbox" class="custom-checkbox animal-check" data-id="${id}"></div>
                    <div class="col-id font-bold">${numero}</div>
                    <div class="col-nome">
                        <div class="animal-photo"><img src="../assets/img/animais-de-estimacao.png" alt="Foto do animal"></div>
                        <span class="font-bold">${animal.nome}</span>
                    </div>
                    <div class="col-perfil font-bold">${cap(animal.especie)}<br>${animal.raca || '—'}</div>
                    <div class="col-caracteristicas font-bold">${animal.genero || '—'}</div>
                    <div class="col-entrada font-bold">${entrada}</div>
                    <div class="col-status">
                        <select class="status-badge status-${status}" data-id="${id}" onchange="atualizarCorStatus(this)">
                            <option value="disponivel" ${status === 'disponivel' ? 'selected' : ''}>Disponível</option>
                            <option value="tratamento" ${status === 'tratamento' ? 'selected' : ''}>Em tratamento</option>
                            <option value="processo"   ${status === 'processo'   ? 'selected' : ''}>Processo</option>
                            <option value="adotado"    ${status === 'adotado'    ? 'selected' : ''}>Adotado</option>
                        </select>
                        ${status === 'processo' ? `
                        <button class="btn-solicitacao" onclick="abrirSolicitacao(${id}, '${animal.nome}')" title="Ver solicitação">
                            <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24"
                                fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                <circle cx="12" cy="12" r="3"/>
                            </svg>
                        </button>` : ''}
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

        fetch('../actions/animal.php?action=listar')
            .then(r => r.json())
            .then(lista => { todosAnimais = lista; dados = lista; atualizarStats(); renderizarLista(paginaAtual); })
            .catch(() => console.error('Erro ao carregar animais'));

        // Busca em tempo real
        const searchInput = document.getElementById('searchInput');
        const clearSearch = document.getElementById('clearSearch');
        if (searchInput) {
            searchInput.addEventListener('input', function () { termoBusca = this.value; aplicarFiltros(); });
        }
        if (clearSearch) {
            clearSearch.addEventListener('click', function () {
                if (searchInput) { searchInput.value = ''; termoBusca = ''; }
                aplicarFiltros();
            });
        }

        // Filtro por status
        const btnFiltro      = document.getElementById('btnFiltro');
        const filterDropdown = document.getElementById('filterDropdown');
        if (btnFiltro && filterDropdown) {
            btnFiltro.addEventListener('click', function (e) {
                filterDropdown.classList.toggle('open');
                e.stopPropagation();
            });
            filterDropdown.querySelectorAll('.filter-opt').forEach(function (btn) {
                btn.addEventListener('click', function () {
                    filtroStatus = this.dataset.status;
                    filterDropdown.querySelectorAll('.filter-opt').forEach(b => b.classList.remove('active'));
                    this.classList.add('active');
                    btnFiltro.classList.toggle('btn-icon--active', !!filtroStatus);
                    filterDropdown.classList.remove('open');
                    aplicarFiltros();
                });
            });
            document.addEventListener('click', function (e) {
                if (!filterDropdown.contains(e.target) && e.target !== btnFiltro) {
                    filterDropdown.classList.remove('open');
                }
            });
        }

        const btnEditar  = document.getElementById('btnEditar');
        const btnExcluir = document.getElementById('btnExcluir');

        function atualizarBotoesAcao() {
            const total = document.querySelectorAll('.animal-check:checked').length;
            if (btnEditar)  btnEditar.disabled  = total !== 1;
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
                    todosAnimais = todosAnimais.filter(a => !ids.includes(a.id_animal));
                    atualizarStats();
                    aplicarFiltros();
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
    const animalId   = Number(selectElement.getAttribute('data-id'));
    const novoStatus = selectElement.value;

    selectElement.classList.remove('status-disponivel', 'status-tratamento', 'status-processo', 'status-adotado');
    selectElement.classList.add('status-' + novoStatus);

    // Atualiza estado local e cards de resumo
    if (window._consultaState) {
        const animal = window._consultaState.todosAnimais.find(a => a.id_animal === animalId);
        if (animal) animal.status = novoStatus;
        if (window._atualizarStatsConsulta) window._atualizarStatsConsulta();
    }

    fetch('../actions/animal.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: 'status', id: animalId, status: novoStatus })
    });
}

// ===== MODAL DE SOLICITAÇÃO DE ADOÇÃO =====

/* Formata "YYYY-MM-DD..." → "DD/MM/YYYY" */
function formatarDataHora(str) {
    if (!str) return '—';
    const [year, month, day] = str.split(' ')[0].split('-');
    return `${day}/${month}/${year}`;
}

let _solIdAdocao  = null;
let _solIdAnimal  = null;

function abrirSolicitacao(idAnimal, nomeAnimal) {
    const overlay = document.getElementById('solOverlay');
    if (!overlay) return;

    _solIdAnimal = idAnimal;
    _solIdAdocao = null;

    document.getElementById('sol-animal-label').textContent = nomeAnimal;
    document.getElementById('sol-nome').textContent      = 'Carregando...';
    document.getElementById('sol-email').textContent     = '—';
    document.getElementById('sol-email').href            = '#';
    document.getElementById('sol-telefone').textContent  = '—';
    document.getElementById('sol-telefone').href         = '#';
    document.getElementById('sol-mensagem').textContent  = '—';
    document.getElementById('sol-data').textContent      = '—';
    document.getElementById('btnAprovar').disabled       = true;
    document.getElementById('btnReprovar').disabled      = true;

    overlay.classList.add('open');

    fetch(`../actions/adocao-ong.php?id_animal=${idAnimal}`)
        .then(r => r.json())
        .then(data => {
            if (data.erro) {
                document.getElementById('sol-nome').textContent = 'Erro: ' + data.erro;
                return;
            }

            _solIdAdocao = data.id_adocao;

            document.getElementById('sol-nome').textContent = data.adotante_nome || '—';

            const email = data.adotante_email || '';
            const elEmail = document.getElementById('sol-email');
            elEmail.textContent = email || '—';
            elEmail.href = email ? `mailto:${email}` : '#';

            const tel = (data.adotante_telefone || '').replace(/\D/g, '');
            const elTel = document.getElementById('sol-telefone');
            elTel.textContent = data.adotante_telefone || '—';
            elTel.href = tel ? `https://wa.me/55${tel}` : '#';

            document.getElementById('sol-mensagem').textContent = data.mensagem || '(sem mensagem)';

            document.getElementById('sol-data').textContent = formatarDataHora(data.dataSolicitacao);

            document.getElementById('btnAprovar').disabled  = false;
            document.getElementById('btnReprovar').disabled = false;
        })
        .catch(() => {
            document.getElementById('sol-nome').textContent = 'Erro ao carregar dados.';
        });
}

function fecharSolicitacao() {
    const overlay = document.getElementById('solOverlay');
    if (overlay) overlay.classList.remove('open');
    _solIdAdocao = null;
    _solIdAnimal = null;
}

async function processarSolicitacao(acao) {
    if (!_solIdAdocao || !_solIdAnimal) return;

    const btnAprovar  = document.getElementById('btnAprovar');
    const btnReprovar = document.getElementById('btnReprovar');
    btnAprovar.disabled = btnReprovar.disabled = true;

    try {
        const res  = await fetch('../actions/adocao-ong.php', {
            method:  'POST',
            headers: { 'Content-Type': 'application/json' },
            body:    JSON.stringify({ id_adocao: _solIdAdocao, id_animal: _solIdAnimal, acao })
        });
        const data = await res.json();

        if (data.erro) {
            alert('Erro: ' + data.erro);
            btnAprovar.disabled = btnReprovar.disabled = false;
            return;
        }

        /* Atualiza a linha na tabela sem recarregar a página */
        const select = document.querySelector(`.status-badge[data-id="${_solIdAnimal}"]`);
        if (select) {
            select.value = data.novoStatus;
            atualizarCorStatus(select);
            /* Remove o botão "Ver solicitação" da linha */
            const btnSol = select.parentElement.querySelector('.btn-solicitacao');
            if (btnSol) btnSol.remove();
        }

        fecharSolicitacao();
    } catch {
        alert('Erro de conexão. Tente novamente.');
        btnAprovar.disabled = btnReprovar.disabled = false;
    }
}

/* Listeners do modal — inicializa uma vez quando o DOM estiver pronto */
document.addEventListener('DOMContentLoaded', function () {
    const solClose  = document.getElementById('solClose');
    const solOverlay = document.getElementById('solOverlay');
    const btnAprovar  = document.getElementById('btnAprovar');
    const btnReprovar = document.getElementById('btnReprovar');

    if (solClose)   solClose.addEventListener('click', fecharSolicitacao);
    if (solOverlay) solOverlay.addEventListener('click', e => { if (e.target === solOverlay) fecharSolicitacao(); });
    if (btnAprovar)  btnAprovar.addEventListener('click',  () => processarSolicitacao('aprovar'));
    if (btnReprovar) btnReprovar.addEventListener('click', () => processarSolicitacao('reprovar'));

    document.addEventListener('keydown', e => { if (e.key === 'Escape') fecharSolicitacao(); });
});
