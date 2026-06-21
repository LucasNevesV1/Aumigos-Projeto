<?php
session_start();
require_once '../config/conexao.php';
require_once '../config/auditoria.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: ../pages/login-usuario.html');
    exit;
}

$email = trim($_POST['email'] ?? '');
$senha = $_POST['senha'] ?? '';

if (!$email || !$senha) {
    header('Location: ../pages/login-usuario.html?erro=campos_vazios');
    exit;
}

// Busca o usuário sem filtrar por ativo para distinguir conta inativa de credencial errada
$stmt = $pdo->prepare('
    SELECT u.id_usuario, u.nome, u.senha, u.ativo, u.id_tipoUsuario, t.descricaoUsuario
    FROM usuario u
    JOIN tipousuario t ON t.id_tipoUsuario = u.id_tipoUsuario
    WHERE u.email = ?
');
$stmt->execute([$email]);
$usuario = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$usuario || !password_verify($senha, $usuario['senha'])) {
    registrarLog($pdo, 'LOGIN_FALHA', 'usuario', null, "Tentativa de login inválida para e-mail: $email");
    header('Location: ../pages/login-usuario.html?erro=credenciais_invalidas');
    exit;
}

if (!(int) $usuario['ativo']) {
    registrarLog($pdo, 'LOGIN_CONTA_DESATIVADA', 'usuario', $usuario['id_usuario'], "Tentativa de login em conta desativada: {$usuario['nome']}");
    header('Location: ../pages/login-usuario.html?erro=conta_desativada');
    exit;
}

// Salva sessão
$_SESSION['id_usuario']   = $usuario['id_usuario'];
$_SESSION['nome']         = $usuario['nome'];
$_SESSION['id_tipo']      = $usuario['id_tipoUsuario'];
$_SESSION['perfil']       = $usuario['descricaoUsuario'];

registrarLog($pdo, 'LOGIN', 'usuario', $usuario['id_usuario'], "Login: {$usuario['nome']} ({$usuario['descricaoUsuario']})");

// Redireciona conforme o tipo de conta
$destino = match((int) $usuario['id_tipoUsuario']) {
    1       => '../pages/admin.html',              // Admin
    2       => '../pages/tela-inicial-ongs.html',  // ONG
    3       => '../pages/interesse-adocao.html',   // Apoiador
    default => '../pages/interesse-adocao.html',
};
header('Location: ' . $destino);
exit;
