<?php
require_once '../config/conexao.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: ../pages/login-usuario.html');
    exit;
}

$token           = trim($_POST['token'] ?? '');
$senha           = $_POST['senha'] ?? '';
$confirmar_senha = $_POST['confirmar_senha'] ?? '';

if (!$token || !$senha || !$confirmar_senha) {
    header('Location: ../pages/redefinir-senha.html?token=' . urlencode($token) . '&erro=campos_vazios');
    exit;
}

if ($senha !== $confirmar_senha) {
    header('Location: ../pages/redefinir-senha.html?token=' . urlencode($token) . '&erro=senhas_diferentes');
    exit;
}

// Busca token válido (não usado e não expirado)
$stmt = $pdo->prepare('
    SELECT email FROM reset_senha
    WHERE token = ? AND usado = 0 AND expira_em > NOW()
');
$stmt->execute([$token]);
$reset = $stmt->fetch();

if (!$reset) {
    header('Location: ../pages/redefinir-senha.html?erro=token_invalido');
    exit;
}

$email      = $reset['email'];
$senha_hash = password_hash($senha, PASSWORD_BCRYPT);

// Atualiza senha do usuário
$pdo->prepare('UPDATE usuario SET senha = ? WHERE email = ?')
    ->execute([$senha_hash, $email]);

// Marca token como usado
$pdo->prepare('UPDATE reset_senha SET usado = 1 WHERE token = ?')
    ->execute([$token]);

header('Location: ../pages/login-usuario.html?cadastro=sucesso&msg=senha_redefinida');
exit;
