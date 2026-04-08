<?php
session_start();
require_once '../config/conexao.php';

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

$stmt = $pdo->prepare('
    SELECT u.id_usuario, u.nome, u.senha, u.id_tipoUsuario, t.descricaoUsuario
    FROM usuario u
    JOIN tipousuario t ON t.id_tipoUsuario = u.id_tipoUsuario
    WHERE u.email = ? AND u.ativo = 1
');
$stmt->execute([$email]);
$usuario = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$usuario || !password_verify($senha, $usuario['senha'])) {
    header('Location: ../pages/login-usuario.html?erro=credenciais_invalidas');
    exit;
}

// Salva sessão
$_SESSION['id_usuario']   = $usuario['id_usuario'];
$_SESSION['nome']         = $usuario['nome'];
$_SESSION['id_tipo']      = $usuario['id_tipoUsuario'];
$_SESSION['perfil']       = $usuario['descricaoUsuario'];

// Redireciona para o dashboard
header('Location: ../pages/tela-inicial-ongs.html');
exit;
