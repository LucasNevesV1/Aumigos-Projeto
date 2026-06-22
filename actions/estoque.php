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
        case 'listar':      listar($pdo);                          break;
        case 'categorias':  categorias($pdo);                      break;
        case 'valorTotal':  valorTotal($pdo);                      break;
        case 'criar':       criar($pdo, $data, $id_usuario);       break;
        case 'movimentar':  movimentar($pdo, $data, $id_usuario);  break;
        case 'excluir':     excluir($pdo, $data, $id_usuario);     break;
        default:           echo json_encode(['erro' => 'Ação inválida']);
    }
} catch (Exception $e) {
    echo json_encode(['erro' => $e->getMessage()]);
}

function calcularStatus($qtdAtual, $qtdMinima) {
    if ($qtdAtual <= 0)          return 'critico';
    if ($qtdAtual <= $qtdMinima) return 'alerta';
    return 'estavel';
}

function listar($pdo) {
    $stmt = $pdo->query('
        SELECT e.id_estoque, p.nomeProduto, p.marca, c.categoria,
               e.quantidadeAtual, e.quantidadeMinima, p.unidadeMedida,
               e.custoUnitario, e.lote, e.tipoOrigem,
               e.dataValidade, e.dataUltimaEntrada,
               p.id_produto, c.id_categoriaProduto
        FROM estoque e
        JOIN produto p ON e.id_produto = p.id_produto
        JOIN categoriaproduto c ON p.id_categoriaProduto = c.id_categoriaProduto
        ORDER BY e.id_estoque DESC
    ');
    $itens = $stmt->fetchAll(PDO::FETCH_ASSOC);
    foreach ($itens as &$item) {
        $item['status'] = calcularStatus((float)$item['quantidadeAtual'], (float)$item['quantidadeMinima']);
    }
    echo json_encode($itens);
}

function valorTotal($pdo) {
    $row = $pdo->query('
        SELECT COALESCE(SUM(quantidadeAtual * custoUnitario), 0) AS valorEstoque
        FROM estoque
    ')->fetch(PDO::FETCH_ASSOC);
    echo json_encode(['valorEstoque' => (float)$row['valorEstoque']]);
}

function categorias($pdo) {
    $stmt = $pdo->query('SELECT id_categoriaProduto, categoria FROM categoriaproduto ORDER BY categoria');
    echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
}

function criar($pdo, $data, $id_usuario) {
    $hoje = date('Y-m-d');

    $stmt = $pdo->prepare('
        INSERT INTO produto (id_categoriaProduto, nomeProduto, marca, unidadeMedida, descricao)
        VALUES (?, ?, ?, ?, ?)
    ');
    $stmt->execute([
        (int)($data['id_categoria']  ?? 1),
        trim($data['nomeProduto']    ?? ''),
        trim($data['marca']          ?? ''),
        trim($data['unidade']        ?? ''),
        trim($data['descricao']      ?? ''),
    ]);
    $id_produto = (int)$pdo->lastInsertId();

    $stmt = $pdo->prepare('
        INSERT INTO estoque
            (id_produto, quantidadeAtual, quantidadeMinima, custoUnitario,
             lote, tipoOrigem, dataCriacao, dataUltimaEntrada, dataValidade)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    ');
    $stmt->execute([
        $id_produto,
        (float)($data['quantidade']       ?? 0),
        (float)($data['quantidadeMinima'] ?? 5),
        (float)($data['custoUnitario']    ?? 0),
        trim($data['lote']                ?? ''),
        trim($data['tipoOrigem']          ?? 'Compra'),
        $hoje,
        $hoje,
        $data['dataValidade'] ?: null,
    ]);
    $id_estoque = (int)$pdo->lastInsertId();

    $pdo->prepare('
        INSERT INTO movimentacaoestoque
            (id_estoque, tipoMovimentacao, quantidade, valor, descricao, dataMovimentacao)
        VALUES (?, "Entrada", ?, ?, "Cadastro inicial", ?)
    ')->execute([
        $id_estoque,
        (float)($data['quantidade']    ?? 0),
        (float)($data['custoUnitario'] ?? 0) * (float)($data['quantidade'] ?? 0),
        $hoje,
    ]);

    registrarLog($pdo, 'CADASTRO_ESTOQUE', 'estoque', $id_estoque, "Item cadastrado: {$data['nomeProduto']}");
    echo json_encode(['id' => $id_estoque]);
}

function movimentar($pdo, $data, $id_usuario) {
    $id_estoque = (int)($data['id_estoque'] ?? 0);
    $tipo       = $data['tipo']             ?? '';
    $quantidade = (float)($data['quantidade'] ?? 0);
    $valor      = (float)($data['valor']      ?? 0);

    if (!in_array($tipo, ['Entrada', 'Saida'])) {
        echo json_encode(['erro' => 'Tipo inválido']);
        return;
    }

    if ($tipo === 'Saida') {
        $row = $pdo->prepare('SELECT quantidadeAtual FROM estoque WHERE id_estoque = ?');
        $row->execute([$id_estoque]);
        $atual = (float)($row->fetchColumn() ?? 0);
        if ($atual < $quantidade) {
            echo json_encode(['erro' => 'Quantidade insuficiente em estoque']);
            return;
        }
    }

    $pdo->prepare('
        INSERT INTO movimentacaoestoque
            (id_estoque, tipoMovimentacao, quantidade, valor, descricao, dataMovimentacao)
        VALUES (?, ?, ?, ?, ?, ?)
    ')->execute([
        $id_estoque,
        $tipo,
        $quantidade,
        $valor,
        trim($data['descricao'] ?? ''),
        $data['data'] ?: date('Y-m-d'),
    ]);

    if ($tipo === 'Entrada') {
        $pdo->prepare('UPDATE estoque SET quantidadeAtual = quantidadeAtual + ?, dataUltimaEntrada = NOW() WHERE id_estoque = ?')
            ->execute([$quantidade, $id_estoque]);
    } else {
        $pdo->prepare('UPDATE estoque SET quantidadeAtual = quantidadeAtual - ? WHERE id_estoque = ?')
            ->execute([$quantidade, $id_estoque]);
    }

    $stmt = $pdo->prepare('SELECT quantidadeAtual, quantidadeMinima FROM estoque WHERE id_estoque = ?');
    $stmt->execute([$id_estoque]);
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    $novaQtd   = (float)$row['quantidadeAtual'];
    $novoStatus = calcularStatus($novaQtd, (float)$row['quantidadeMinima']);

    registrarLog($pdo, 'MOVIMENTACAO_ESTOQUE', 'estoque', $id_estoque, "Movimentação $tipo: $quantidade unidades");
    echo json_encode(['ok' => true, 'novaQuantidade' => $novaQtd, 'novoStatus' => $novoStatus]);
}

function excluir($pdo, $data, $id_usuario) {
    $ids = array_map('intval', $data['ids'] ?? []);
    if (empty($ids)) {
        echo json_encode(['erro' => 'Nenhum id informado']);
        return;
    }
    $ph = implode(',', array_fill(0, count($ids), '?'));
    $pdo->prepare("DELETE FROM movimentacaoestoque WHERE id_estoque IN ($ph)")->execute($ids);
    $pdo->prepare("DELETE FROM estoque WHERE id_estoque IN ($ph)")->execute($ids);
    registrarLog($pdo, 'EXCLUSAO_ESTOQUE', 'estoque', null, 'Itens excluídos (IDs): ' . implode(', ', $ids));
    echo json_encode(['ok' => true]);
}
