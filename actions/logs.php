<?php
header('Content-Type: application/json');
session_start();
require_once '../config/conexao.php';

if (!isset($_SESSION['id_usuario']) || (int) $_SESSION['id_tipo'] !== 1) {
    http_response_code(403);
    echo json_encode(['erro' => 'Acesso restrito ao administrador']);
    exit;
}

$pagina = max(1, (int) ($_GET['pagina'] ?? 1));
$limite = 50;
$offset = ($pagina - 1) * $limite;
$acao   = trim($_GET['acao']  ?? '');
$busca  = trim($_GET['busca'] ?? '');

$where  = [];
$params = [];

if ($acao) {
    $where[]  = 'l.acao = ?';
    $params[] = $acao;
}
if ($busca) {
    $where[]  = '(l.descricao LIKE ? OR u.nome LIKE ?)';
    $params[] = "%$busca%";
    $params[] = "%$busca%";
}

$cond = $where ? 'WHERE ' . implode(' AND ', $where) : '';

$total = $pdo->prepare("
    SELECT COUNT(*)
    FROM log_auditoria l
    LEFT JOIN usuario u ON u.id_usuario = l.id_usuario
    $cond
");
$total->execute($params);
$totalLinhas = (int) $total->fetchColumn();

$stmt = $pdo->prepare("
    SELECT l.id, l.data_hora, l.acao, l.tabela_afetada, l.id_registro,
           l.descricao, l.ip_origem,
           COALESCE(u.nome, 'Sistema') AS usuario_nome
    FROM log_auditoria l
    LEFT JOIN usuario u ON u.id_usuario = l.id_usuario
    $cond
    ORDER BY l.data_hora DESC
    LIMIT $limite OFFSET $offset
");
$stmt->execute($params);

echo json_encode([
    'total'  => $totalLinhas,
    'pagina' => $pagina,
    'limite' => $limite,
    'logs'   => $stmt->fetchAll(PDO::FETCH_ASSOC),
]);
