<?php
session_start();
require_once '../config/conexao.php';
header('Content-Type: application/json');

if (!isset($_SESSION['id_usuario'])) {
    http_response_code(401);
    echo json_encode(['erro' => 'Não autenticado']);
    exit;
}

$id = (int) $_SESSION['id_usuario'];

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $stmt = $pdo->prepare('
        SELECT u.nome, u.email, u.documento, u.telefone, u.dataCadastro,
               u.ativo, u.id_tipoUsuario, u.dataNascimento, u.profissao, u.genero,
               u.id_endereco,
               e.logradouro_tipo, e.logradouro_nome, e.numero, e.cep,
               e.complemento, e.bairro, e.cidade, e.estado
        FROM usuario u
        LEFT JOIN endereco e ON e.id_endereco = u.id_endereco
        WHERE u.id_usuario = ?
    ');
    $stmt->execute([$id]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$user) {
        http_response_code(404);
        echo json_encode(['erro' => 'Usuário não encontrado']);
        exit;
    }

    echo json_encode($user);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $body = json_decode(file_get_contents('php://input'), true) ?? [];

    $nome           = trim($body['nome']           ?? '');
    $email          = trim($body['email']          ?? '');
    $telefone       = trim($body['telefone']       ?? '');
    $ativo          = isset($body['ativo']) ? (int) $body['ativo'] : 1;
    $senha          = $body['senha']               ?? '';
    $dataNascimento = $body['dataNascimento']       ?? null;
    $profissao      = trim($body['profissao']      ?? '');
    $genero         = trim($body['genero']         ?? '');
    $idEndereco     = $body['id_endereco']         ? (int) $body['id_endereco'] : null;

    $logradouroTipo = trim($body['logradouro_tipo'] ?? '');
    $logradouroNome = trim($body['logradouro_nome'] ?? '');
    $numero         = trim($body['numero']          ?? '');
    $cep            = trim($body['cep']             ?? '');
    $complemento    = trim($body['complemento']     ?? '');
    $bairro         = trim($body['bairro']          ?? '');
    $cidade         = trim($body['cidade']          ?? '');
    $estado         = trim($body['estado']          ?? '');

    if (!$nome || !$email) {
        echo json_encode(['erro' => 'Nome e e-mail são obrigatórios']);
        exit;
    }

    $stmt = $pdo->prepare('SELECT id_usuario FROM usuario WHERE email = ? AND id_usuario != ?');
    $stmt->execute([$email, $id]);
    if ($stmt->rowCount() > 0) {
        echo json_encode(['erro' => 'E-mail já cadastrado por outro usuário']);
        exit;
    }

    // Atualiza dados do usuário
    $camposSenha = $senha
        ? 'nome=?, email=?, telefone=?, ativo=?, dataNascimento=?, profissao=?, genero=?, senha=?'
        : 'nome=?, email=?, telefone=?, ativo=?, dataNascimento=?, profissao=?, genero=?';

    $params = $senha
        ? [$nome, $email, $telefone, $ativo, $dataNascimento ?: null, $profissao, $genero, password_hash($senha, PASSWORD_BCRYPT), $id]
        : [$nome, $email, $telefone, $ativo, $dataNascimento ?: null, $profissao, $genero, $id];

    $pdo->prepare("UPDATE usuario SET $camposSenha WHERE id_usuario=?")->execute($params);

    // Salva endereço
    $temEndereco = $logradouroNome !== '';
    if ($temEndereco) {
        $endParams = [$logradouroTipo, $logradouroNome, $numero, $cep, $complemento, $bairro, $cidade, $estado];
        if ($idEndereco) {
            $s = $pdo->prepare('
                UPDATE endereco
                SET logradouro_tipo=?, logradouro_nome=?, numero=?, cep=?, complemento=?, bairro=?, cidade=?, estado=?
                WHERE id_endereco=?
            ');
            $s->execute(array_merge($endParams, [$idEndereco]));
        } else {
            $s = $pdo->prepare('
                INSERT INTO endereco (logradouro_tipo, logradouro_nome, numero, cep, complemento, bairro, cidade, estado)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            ');
            $s->execute($endParams);
            $novoId = (int) $pdo->lastInsertId();
            $pdo->prepare('UPDATE usuario SET id_endereco=? WHERE id_usuario=?')->execute([$novoId, $id]);
        }
    }

    $_SESSION['nome'] = $nome;
    echo json_encode(['ok' => true]);
    exit;
}

http_response_code(405);
echo json_encode(['erro' => 'Método não permitido']);
