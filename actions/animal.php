<?php
header('Content-Type: application/json');
session_start();
require_once '../config/conexao.php';

$action = $_GET['action'] ?? '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    $action = $data['action'] ?? $action;
}

try {
    switch ($action) {
        case 'listar':
            listar($pdo);
            break;
        case 'criar':
            criar($pdo, $data);
            break;
        case 'editar':
            editar($pdo, $data);
            break;
        case 'excluir':
            excluir($pdo, $data);
            break;
        case 'status':
            atualizarStatus($pdo, $data);
            break;
        default:
            echo json_encode(['erro' => 'Ação inválida']);
    }
} catch (Exception $e) {
    echo json_encode(['erro' => $e->getMessage()]);
}

function listar($pdo) {
    $stmt = $pdo->query('SELECT * FROM animal ORDER BY id_animal DESC');
    echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
}

function criar($pdo, $data) {
    $stmt = $pdo->prepare('
        INSERT INTO animal (nome, especie, raca, genero, dataNascimento, cor, tamanho, descricao, status)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    ');
    $stmt->execute([
        $data['nome']            ?? '',
        $data['especie']         ?? '',
        $data['raca']            ?? '',
        $data['genero']          ?? '',
        $data['data_nascimento'] ?: null,
        $data['cor']             ?? '',
        $data['porte']           ?? '',
        $data['descricao']       ?? '',
        'disponivel'
    ]);
    echo json_encode(['id' => $pdo->lastInsertId()]);
}

function editar($pdo, $data) {
    $stmt = $pdo->prepare('
        UPDATE animal
        SET nome=?, especie=?, raca=?, genero=?, dataNascimento=?, cor=?, tamanho=?, descricao=?
        WHERE id_animal=?
    ');
    $stmt->execute([
        $data['nome']            ?? '',
        $data['especie']         ?? '',
        $data['raca']            ?? '',
        $data['genero']          ?? '',
        $data['data_nascimento'] ?: null,
        $data['cor']             ?? '',
        $data['porte']           ?? '',
        $data['descricao']       ?? '',
        $data['id']              ?? 0
    ]);
    echo json_encode(['ok' => true]);
}

function excluir($pdo, $data) {
    $ids = $data['ids'] ?? [];
    if (empty($ids)) {
        echo json_encode(['erro' => 'Nenhum id informado']);
        return;
    }
    $placeholders = implode(',', array_fill(0, count($ids), '?'));
    $stmt = $pdo->prepare("DELETE FROM animal WHERE id_animal IN ($placeholders)");
    $stmt->execute($ids);
    echo json_encode(['ok' => true]);
}

function atualizarStatus($pdo, $data) {
    $stmt = $pdo->prepare('UPDATE animal SET status=? WHERE id_animal=?');
    $stmt->execute([$data['status'], $data['id']]);
    echo json_encode(['ok' => true]);
}
