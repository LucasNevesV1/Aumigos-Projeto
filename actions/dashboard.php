<?php
header('Content-Type: application/json');
session_start();
require_once '../config/conexao.php';

if (!isset($_SESSION['id_usuario'])) {
    echo json_encode(['erro' => 'Não autorizado']);
    exit;
}

$id_usuario = (int) $_SESSION['id_usuario'];
$mesAtual   = date('Y-m');

// Animais
$stmt = $pdo->prepare("
    SELECT
        COUNT(*)                                                          AS total,
        SUM(CASE WHEN a.status = 'disponivel' THEN 1 ELSE 0 END)        AS disponivel,
        SUM(CASE WHEN a.status = 'adotado'    THEN 1 ELSE 0 END)        AS adotado,
        SUM(CASE WHEN a.status = 'tratamento'  THEN 1 ELSE 0 END)        AS em_tratamento
    FROM animal a
    LEFT JOIN entradaanimal e ON a.id_entrada = e.id_entrada
    WHERE a.status != 'excluido' AND a.id_usuario = ?
");
$stmt->execute([$id_usuario]);
$animais = $stmt->fetch(PDO::FETCH_ASSOC);

// Financeiro — saldo geral
$fin = $pdo->query("
    SELECT
        COALESCE(SUM(CASE WHEN tipoMovimentacao = 'Entrada' THEN valor ELSE 0 END), 0) AS total_entrada,
        COALESCE(SUM(CASE WHEN tipoMovimentacao = 'Saida'   THEN valor ELSE 0 END), 0) AS total_saida
    FROM financeiro
")->fetch(PDO::FETCH_ASSOC);

// Financeiro — mês atual
$finMes = $pdo->prepare("
    SELECT
        COALESCE(SUM(CASE WHEN tipoMovimentacao = 'Entrada' THEN valor ELSE 0 END), 0) AS entrada_mes,
        COALESCE(SUM(CASE WHEN tipoMovimentacao = 'Saida'   THEN valor ELSE 0 END), 0) AS saida_mes
    FROM financeiro
    WHERE DATE_FORMAT(dataMovimentacao, '%Y-%m') = ?
");
$finMes->execute([$mesAtual]);
$finMes = $finMes->fetch(PDO::FETCH_ASSOC);

// Alertas de estoque (critico ou alerta)
$alertas = $pdo->query("
    SELECT p.nomeProduto, e.quantidadeAtual, e.quantidadeMinima, p.unidadeMedida
    FROM estoque e
    JOIN produto p ON e.id_produto = p.id_produto
    WHERE e.quantidadeAtual <= e.quantidadeMinima
    ORDER BY e.quantidadeAtual ASC
    LIMIT 6
")->fetchAll(PDO::FETCH_ASSOC);

// Gráfico — últimos 12 meses
$grafico = $pdo->query("
    SELECT
        DATE_FORMAT(dataMovimentacao, '%Y-%m')                                        AS mes,
        COALESCE(SUM(CASE WHEN tipoMovimentacao = 'Entrada' THEN valor ELSE 0 END),0) AS entrada,
        COALESCE(SUM(CASE WHEN tipoMovimentacao = 'Saida'   THEN valor ELSE 0 END),0) AS saida
    FROM financeiro
    WHERE dataMovimentacao >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
    GROUP BY mes
    ORDER BY mes ASC
")->fetchAll(PDO::FETCH_ASSOC);

$saldoAtual = (float)$fin['total_entrada'] - (float)$fin['total_saida'];

echo json_encode([
    'nome'    => $_SESSION['nome'] ?? 'aumigo',
    'animais' => [
        'total'         => (int)$animais['total'],
        'disponivel'    => (int)$animais['disponivel'],
        'adotado'       => (int)$animais['adotado'],
        'em_tratamento' => (int)$animais['em_tratamento'],
    ],
    'financeiro' => [
        'saldoAtual' => $saldoAtual,
        'entradaMes' => (float)$finMes['entrada_mes'],
        'saidaMes'   => (float)$finMes['saida_mes'],
    ],
    'alertasEstoque' => $alertas,
    'grafico12meses' => $grafico,
]);
