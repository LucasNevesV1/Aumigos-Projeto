<?php
header('Content-Type: application/json');
session_start();
require_once '../config/conexao.php';

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
        case 'listar':
            listar($pdo, $id_usuario);
            break;
        case 'criar':
            criar($pdo, $data, $id_usuario);
            break;
        case 'editar':
            editar($pdo, $data, $id_usuario);
            break;
        case 'excluir':
            excluir($pdo, $data, $id_usuario);
            break;
        case 'status':
            atualizarStatus($pdo, $data, $id_usuario);
            break;
        default:
            echo json_encode(['erro' => 'Ação inválida']);
    }
} catch (Exception $e) {
    echo json_encode(['erro' => $e->getMessage()]);
}

function listar($pdo, $id_usuario) {
    $stmt = $pdo->prepare("
        SELECT a.*, e.dataEntrada, e.motivoEntrada, e.statusSaude
        FROM animal a
        LEFT JOIN entradaanimal e ON a.id_entrada = e.id_entrada
        WHERE a.status != 'excluido' AND a.id_usuario = ?
        ORDER BY a.id_animal DESC
    ");
    $stmt->execute([$id_usuario]);
    echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
}

function criar($pdo, $data, $id_usuario) {
    $stmtEntrada = $pdo->prepare('
        INSERT INTO entradaanimal (dataEntrada, motivoEntrada, statusSaude, descricaoEntrada)
        VALUES (?, ?, ?, ?)
    ');
    $stmtEntrada->execute([
        $data['dataEntrada']    ?: null,
        $data['motivoEntrada']  ?? '',
        $data['statusSaude']    ?? '',
        $data['descricao']      ?? ''
    ]);
    $idEntrada = $pdo->lastInsertId();

    $stmt = $pdo->prepare('
        INSERT INTO animal (id_entrada, id_usuario, nome, especie, raca, genero, dataNascimento, cor, tamanho, descricao, status)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ');
    $stmt->execute([
        $idEntrada,
        $id_usuario,
        $data['nome']           ?? '',
        $data['especie']        ?? '',
        $data['raca']           ?? '',
        $data['genero']         ?? '',
        $data['dataNascimento'] ?: null,
        $data['cor']            ?? '',
        $data['tamanho']        ?? '',
        $data['descricao']      ?? '',
        'disponivel'
    ]);
    echo json_encode(['id' => $pdo->lastInsertId()]);
}

function editar($pdo, $data, $id_usuario) {
    $stmtGet = $pdo->prepare('SELECT id_entrada FROM animal WHERE id_animal = ? AND id_usuario = ?');
    $stmtGet->execute([$data['id'] ?? 0, $id_usuario]);
    $animal = $stmtGet->fetch(PDO::FETCH_ASSOC);

    if (!$animal) {
        echo json_encode(['erro' => 'Animal não encontrado ou sem permissão']);
        return;
    }

    if ($animal['id_entrada']) {
        $stmtEntrada = $pdo->prepare('
            UPDATE entradaanimal
            SET dataEntrada = ?, motivoEntrada = ?, statusSaude = ?
            WHERE id_entrada = ?
        ');
        $stmtEntrada->execute([
            $data['dataEntrada']   ?: null,
            $data['motivoEntrada'] ?? '',
            $data['statusSaude']   ?? '',
            $animal['id_entrada']
        ]);
    }

    $stmt = $pdo->prepare('
        UPDATE animal
        SET nome = ?, especie = ?, raca = ?, genero = ?, dataNascimento = ?, cor = ?, tamanho = ?, descricao = ?
        WHERE id_animal = ? AND id_usuario = ?
    ');
    $stmt->execute([
        $data['nome']           ?? '',
        $data['especie']        ?? '',
        $data['raca']           ?? '',
        $data['genero']         ?? '',
        $data['dataNascimento'] ?: null,
        $data['cor']            ?? '',
        $data['tamanho']        ?? '',
        $data['descricao']      ?? '',
        $data['id']             ?? 0,
        $id_usuario
    ]);
    echo json_encode(['ok' => true]);
}

function excluir($pdo, $data, $id_usuario) {
    $ids = $data['ids'] ?? [];
    if (empty($ids)) {
        echo json_encode(['erro' => 'Nenhum id informado']);
        return;
    }
    $placeholders = implode(',', array_fill(0, count($ids), '?'));
    $params = array_merge($ids, [$id_usuario]);
    $stmt = $pdo->prepare("UPDATE animal SET status = 'excluido' WHERE id_animal IN ($placeholders) AND id_usuario = ?");
    $stmt->execute($params);
    echo json_encode(['ok' => true]);
}

function atualizarStatus($pdo, $data, $id_usuario) {
    $stmt = $pdo->prepare('UPDATE animal SET status = ? WHERE id_animal = ? AND id_usuario = ?');
    $stmt->execute([$data['status'], $data['id'], $id_usuario]);
    echo json_encode(['ok' => true]);
}
