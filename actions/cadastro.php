<?php
session_start();
require_once '../config/conexao.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: ../pages/cadastro-usuario.html');
    exit;
}

$nome     = trim($_POST['nome'] ?? '');
$documento = trim($_POST['cpf_cnpj'] ?? '');
$email    = trim($_POST['email'] ?? '');
$telefone = trim($_POST['telefone'] ?? '');
$senha    = $_POST['senha'] ?? '';
$confirmar = $_POST['confirmar-senha'] ?? '';
$perfil   = $_POST['perfil'] ?? '';

// Mapeia perfil para id_tipoUsuario
$tipos = [
    'ong'      => 2,
    'adotante' => 3,
    'apoiador' => 5,
];

// Validações básicas
if (!$nome || !$documento || !$email || !$telefone || !$senha || !$perfil) {
    header('Location: ../pages/cadastro-usuario.html?erro=campos_vazios');
    exit;
}

if ($senha !== $confirmar) {
    header('Location: ../pages/cadastro-usuario.html?erro=senhas_diferentes');
    exit;
}

if (!isset($tipos[$perfil])) {
    header('Location: ../pages/cadastro-usuario.html?erro=perfil_invalido');
    exit;
}

$id_tipo = $tipos[$perfil];

// Verifica se email ou documento já existem
$stmt = $pdo->prepare('SELECT id_usuario FROM usuario WHERE email = ? OR documento = ?');
$stmt->execute([$email, $documento]);

if ($stmt->rowCount() > 0) {
    header('Location: ../pages/cadastro-usuario.html?erro=ja_cadastrado');
    exit;
}

// Salva no banco
$senha_hash = password_hash($senha, PASSWORD_BCRYPT);

$stmt = $pdo->prepare('
    INSERT INTO usuario (nome, documento, email, telefone, senha, id_tipoUsuario, dataCadastro)
    VALUES (?, ?, ?, ?, ?, ?, CURDATE())
');
$stmt->execute([$nome, $documento, $email, $telefone, $senha_hash, $id_tipo]);

header('Location: ../pages/login-usuario.html?cadastro=sucesso');
exit;
