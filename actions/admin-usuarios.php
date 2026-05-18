<?php
header('Content-Type: application/json');
session_start();
require_once '../config/conexao.php';
require_once '../config/auditoria.php';

if (!isset($_SESSION['id_usuario']) || (int) $_SESSION['id_tipo'] !== 1) {
    http_response_code(403);
    echo json_encode(['erro' => 'Acesso restrito ao administrador']);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    listarUsuarios($pdo);
} elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    $acao = $data['acao'] ?? '';

    match ($acao) {
        'desativar' => alterarStatus($pdo, (int)($data['id'] ?? 0), 0),
        'reativar'  => alterarStatus($pdo, (int)($data['id'] ?? 0), 1),
        'excluir'   => excluirUsuario($pdo, (int)($data['id'] ?? 0)),
        default     => (function() { echo json_encode(['erro' => 'Ação inválida']); })()
    };
} else {
    http_response_code(405);
    echo json_encode(['erro' => 'Método não permitido']);
}

function listarUsuarios($pdo) {
    $stmt = $pdo->query("
        SELECT u.id_usuario, u.nome, u.email, u.documento, u.telefone,
               u.dataCadastro, u.ativo, t.descricaoUsuario AS tipo
        FROM usuario u
        JOIN tipousuario t ON t.id_tipoUsuario = u.id_tipoUsuario
        WHERE u.id_tipoUsuario != 1
        ORDER BY u.dataCadastro DESC
    ");
    echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
}

function alterarStatus($pdo, $id, $ativo) {
    if (!$id) { echo json_encode(['erro' => 'ID inválido']); return; }

    $stmt = $pdo->prepare('SELECT id_tipoUsuario FROM usuario WHERE id_usuario = ?');
    $stmt->execute([$id]);
    $u = $stmt->fetch();
    if (!$u || (int)$u['id_tipoUsuario'] === 1) {
        echo json_encode(['erro' => 'Operação não permitida']);
        return;
    }

    $pdo->prepare('UPDATE usuario SET ativo = ? WHERE id_usuario = ?')->execute([$ativo, $id]);
    $acaoLog = $ativo ? 'REATIVACAO_USUARIO' : 'DESATIVACAO_USUARIO';
    $desc    = $ativo ? "Conta reativada (ID: $id)" : "Conta desativada (ID: $id)";
    registrarLog($pdo, $acaoLog, 'usuario', $id, $desc);
    echo json_encode(['ok' => true]);
}

function excluirUsuario($pdo, $id) {
    if (!$id) { echo json_encode(['erro' => 'ID inválido']); return; }

    $stmt = $pdo->prepare('SELECT nome, id_tipoUsuario FROM usuario WHERE id_usuario = ?');
    $stmt->execute([$id]);
    $u = $stmt->fetch();

    if (!$u || (int)$u['id_tipoUsuario'] === 1) {
        echo json_encode(['erro' => 'Operação não permitida']);
        return;
    }

    // Verifica registros vinculados — bloqueia exclusão e registra a tentativa
    $stmtAnimal = $pdo->prepare('SELECT COUNT(*) FROM animal WHERE id_usuario = ?');
    $stmtAnimal->execute([$id]);
    if ((int)$stmtAnimal->fetchColumn() > 0) {
        registrarLog($pdo, 'TENTATIVA_EXCLUSAO_USUARIO', 'usuario', $id, "Exclusão bloqueada: {$u['nome']} possui animais registrados");
        echo json_encode(['erro' => 'Usuário possui animais registrados. Desative a conta em vez de excluir.']);
        return;
    }

    $stmtDoacao = $pdo->prepare('SELECT COUNT(*) FROM doacao WHERE id_usuario = ?');
    $stmtDoacao->execute([$id]);
    if ((int)$stmtDoacao->fetchColumn() > 0) {
        registrarLog($pdo, 'TENTATIVA_EXCLUSAO_USUARIO', 'usuario', $id, "Exclusão bloqueada: {$u['nome']} possui histórico em doacao");
        echo json_encode(['erro' => 'Usuário possui histórico de adoções. Desative a conta em vez de excluir.']);
        return;
    }

    $stmtAdocao = $pdo->prepare('SELECT COUNT(*) FROM adocao WHERE id_usuario = ?');
    $stmtAdocao->execute([$id]);
    if ((int)$stmtAdocao->fetchColumn() > 0) {
        registrarLog($pdo, 'TENTATIVA_EXCLUSAO_USUARIO', 'usuario', $id, "Exclusão bloqueada: {$u['nome']} possui histórico em adocao");
        echo json_encode(['erro' => 'Usuário possui histórico de adoções. Desative a conta em vez de excluir.']);
        return;
    }

    try {
        $pdo->prepare('DELETE FROM usuario WHERE id_usuario = ? AND id_tipoUsuario != 1')->execute([$id]);
        // Log somente após confirmação real da exclusão
        registrarLog($pdo, 'EXCLUSAO_USUARIO', 'usuario', $id, "Conta excluída: {$u['nome']} (ID: $id)");
        echo json_encode(['ok' => true]);
    } catch (Exception $e) {
        registrarLog($pdo, 'TENTATIVA_EXCLUSAO_USUARIO', 'usuario', $id, "Exclusão bloqueada por FK não mapeada: {$u['nome']}");
        echo json_encode(['erro' => 'Não foi possível excluir. Desative a conta em vez de excluir.']);
    }
}
