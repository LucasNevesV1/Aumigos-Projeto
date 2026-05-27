<?php
header('Content-Type: application/json');
session_start();
require_once '../config/conexao.php';
require_once '../config/auditoria.php';

if (!isset($_SESSION['id_usuario'])) {
    echo json_encode(['erro' => 'Não autorizado']);
    exit;
}

$id_usuario = (int) $_SESSION['id_usuario'];
$action = $_GET['action'] ?? '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    $action = $data['action'] ?? $action;
}

try {
    switch ($action) {
        case 'listar':  listar($pdo);                        break;
        case 'stats':   stats($pdo);                         break;
        case 'opcoes':  opcoes($pdo);                        break;
        case 'criar':   criar($pdo, $data, $id_usuario);     break;
        case 'editar':  editar($pdo, $data, $id_usuario);    break;
        case 'excluir': excluir($pdo, $data, $id_usuario);   break;
        default:        echo json_encode(['erro' => 'Ação inválida']);
    }
} catch (Exception $e) {
    echo json_encode(['erro' => $e->getMessage()]);
}

function listar($pdo) {
    $stmt = $pdo->query('
        SELECT f.id_financeiro, f.tipoMovimentacao, f.valor, f.descricao,
               f.dataMovimentacao, f.dataRegistro,
               cf.categoriaFinanceira,
               fp.formaPagamento,
               sp.statusPagamento
        FROM financeiro f
        LEFT JOIN categoriafinanceira cf ON f.id_categoriaFinanceira = cf.id_categoriaFinanceira
        LEFT JOIN formapagamento fp ON f.id_formaPagamento = fp.id_formaPagamento
        LEFT JOIN statuspagamento sp ON f.id_statusPagamento = sp.id_statusPagamento
        ORDER BY f.dataMovimentacao DESC, f.id_financeiro DESC
    ');
    echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
}

function stats($pdo) {
    $mesAtual = date('Y-m');

    $saldo = $pdo->query("
        SELECT
            COALESCE(SUM(CASE WHEN tipoMovimentacao = 'Entrada' THEN valor ELSE 0 END), 0) AS total_entrada,
            COALESCE(SUM(CASE WHEN tipoMovimentacao = 'Saida'   THEN valor ELSE 0 END), 0) AS total_saida
        FROM financeiro
    ")->fetch(PDO::FETCH_ASSOC);

    $mes = $pdo->prepare("
        SELECT
            COALESCE(SUM(CASE WHEN tipoMovimentacao = 'Entrada' THEN valor ELSE 0 END), 0) AS entrada_mes,
            COALESCE(SUM(CASE WHEN tipoMovimentacao = 'Saida'   THEN valor ELSE 0 END), 0) AS saida_mes
        FROM financeiro
        WHERE DATE_FORMAT(dataMovimentacao, '%Y-%m') = ?
    ");
    $mes->execute([$mesAtual]);
    $mes = $mes->fetch(PDO::FETCH_ASSOC);

    $saldoAtual  = (float)$saldo['total_entrada'] - (float)$saldo['total_saida'];
    $entradaMes  = (float)$mes['entrada_mes'];
    $saidaMes    = (float)$mes['saida_mes'];
    $balanco     = $entradaMes - $saidaMes;

    echo json_encode([
        'saldoAtual' => $saldoAtual,
        'entradaMes' => $entradaMes,
        'saidaMes'   => $saidaMes,
        'balanco'    => $balanco,
    ]);
}

function opcoes($pdo) {
    $categorias = $pdo->query('SELECT id_categoriaFinanceira, categoriaFinanceira FROM categoriafinanceira ORDER BY categoriaFinanceira')
                      ->fetchAll(PDO::FETCH_ASSOC);
    $formas     = $pdo->query('SELECT id_formaPagamento, formaPagamento FROM formapagamento ORDER BY formaPagamento')
                      ->fetchAll(PDO::FETCH_ASSOC);
    $status     = $pdo->query('SELECT id_statusPagamento, statusPagamento FROM statuspagamento ORDER BY id_statusPagamento')
                      ->fetchAll(PDO::FETCH_ASSOC);
    echo json_encode(compact('categorias', 'formas', 'status'));
}

function criar($pdo, $data, $id_usuario) {
    $tipo = $data['tipo'] ?? '';
    if (!in_array($tipo, ['Entrada', 'Saida'])) {
        echo json_encode(['erro' => 'Tipo inválido']);
        return;
    }

    $stmt = $pdo->prepare('
        INSERT INTO financeiro
            (id_categoriaFinanceira, id_statusPagamento, id_formaPagamento,
             tipoMovimentacao, valor, descricao, dataMovimentacao, dataRegistro)
        VALUES (?, ?, ?, ?, ?, ?, ?, NOW())
    ');
    $stmt->execute([
        (int)($data['id_categoria']      ?? 1),
        (int)($data['id_status']         ?? 2),
        ($data['id_forma'] ?? null) ?: null,
        $tipo,
        (float)($data['valor']           ?? 0),
        trim($data['descricao']          ?? ''),
        $data['data']                    ?: date('Y-m-d'),
    ]);
    $id = (int)$pdo->lastInsertId();
    registrarLog($pdo, 'CADASTRO_FINANCEIRO', 'financeiro', $id, "Lançamento $tipo: R$ {$data['valor']} — {$data['descricao']}");
    echo json_encode(['id' => $id]);
}

function editar($pdo, $data, $id_usuario) {
    $tipo = $data['tipo'] ?? '';
    if (!in_array($tipo, ['Entrada', 'Saida'])) {
        echo json_encode(['erro' => 'Tipo inválido']);
        return;
    }
    $stmt = $pdo->prepare('
        UPDATE financeiro SET
            id_categoriaFinanceira = ?,
            id_statusPagamento     = ?,
            id_formaPagamento      = ?,
            tipoMovimentacao       = ?,
            valor                  = ?,
            descricao              = ?,
            dataMovimentacao       = ?
        WHERE id_financeiro = ?
    ');
    $stmt->execute([
        (int)($data['id_categoria'] ?? 1),
        (int)($data['id_status']    ?? 2),
        ($data['id_forma'] ?? null) ?: null,
        $tipo,
        (float)($data['valor']      ?? 0),
        trim($data['descricao']     ?? ''),
        $data['data']               ?: date('Y-m-d'),
        (int)($data['id']           ?? 0),
    ]);
    registrarLog($pdo, 'EDICAO_FINANCEIRO', 'financeiro', (int)($data['id'] ?? 0), "Lançamento editado: R$ {$data['valor']} — {$data['descricao']}");
    echo json_encode(['ok' => true]);
}

function excluir($pdo, $data, $id_usuario) {
    $ids = array_map('intval', $data['ids'] ?? []);
    if (empty($ids)) {
        echo json_encode(['erro' => 'Nenhum id informado']);
        return;
    }
    $ph = implode(',', array_fill(0, count($ids), '?'));
    $pdo->prepare("DELETE FROM financeiro WHERE id_financeiro IN ($ph)")->execute($ids);
    registrarLog($pdo, 'EXCLUSAO_FINANCEIRO', 'financeiro', null, 'Lançamentos excluídos (IDs): ' . implode(', ', $ids));
    echo json_encode(['ok' => true]);
}
