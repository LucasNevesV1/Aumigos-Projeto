<?php
header('Content-Type: application/json');
session_start();
require_once '../config/conexao.php';

if (!isset($_SESSION['id_usuario'])) {
    echo json_encode(['erro' => 'Não autorizado']);
    exit;
}

/* Garante que o status 'Pendente' existe na tabela statusadocao */
function getIdStatusPendente($pdo) {
    $row = $pdo->query("SELECT id_statusAdocao FROM statusadocao WHERE statusNome = 'Pendente' LIMIT 1")->fetch();
    if ($row) return (int) $row['id_statusAdocao'];

    $pdo->exec("INSERT INTO statusadocao (statusNome, statusSituacao, dataCriacao) VALUES ('Pendente', 1, NOW())");
    return (int) $pdo->lastInsertId();
}

/* ── Roteamento ── */
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    listarDisponiveis($pdo);
} elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    registrarInteresse($pdo, $data, (int) $_SESSION['id_usuario']);
} else {
    echo json_encode(['erro' => 'Método não permitido']);
}

/* ── Lista animais disponíveis e em processo ── */
function listarDisponiveis($pdo) {
    try {
        $stmt = $pdo->query("
            SELECT
                a.id_animal,
                a.nome,
                a.especie,
                a.raca,
                a.genero,
                a.tamanho,
                a.dataNascimento,
                a.descricao,
                a.status,
                u.nome AS ong_nome
            FROM animal a
            JOIN usuario u ON u.id_usuario = a.id_usuario
            WHERE a.status IN ('disponivel', 'processo')
            ORDER BY a.id_animal DESC
        ");
        echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
    } catch (Exception $e) {
        echo json_encode(['erro' => $e->getMessage()]);
    }
}

/* ── Registra interesse e coloca o animal em 'processo' ── */
function registrarInteresse($pdo, $data, $id_usuario) {
    $id_animal = (int) ($data['id_animal'] ?? 0);
    $mensagem  = trim($data['mensagem']    ?? '');

    if (!$id_animal || !$mensagem) {
        echo json_encode(['erro' => 'Dados incompletos']);
        return;
    }

    try {
        $pdo->beginTransaction();

        /* Tenta marcar como 'processo' SOMENTE se ainda estiver 'disponivel'.
           Se outra pessoa já enviou interesse, rowCount() == 0 → retorna erro. */
        $upd = $pdo->prepare("
            UPDATE animal SET status = 'processo'
            WHERE id_animal = ? AND status = 'disponivel'
        ");
        $upd->execute([$id_animal]);

        if ($upd->rowCount() === 0) {
            $pdo->rollBack();
            echo json_encode(['erro' => 'Este animal não está mais disponível para solicitação.']);
            return;
        }

        $idStatusPendente = getIdStatusPendente($pdo);

        /* Insere o registro de adoção */
        $ins = $pdo->prepare("
            INSERT INTO adocao (id_usuario, dataSolicitacao, id_animal, id_statusAdocao, termoResponsabilidade)
            VALUES (?, NOW(), ?, ?, ?)
        ");
        $ins->execute([$id_usuario, $id_animal, $idStatusPendente, $mensagem]);

        $pdo->commit();
        echo json_encode(['ok' => true]);

    } catch (Exception $e) {
        $pdo->rollBack();
        echo json_encode(['erro' => $e->getMessage()]);
    }
}
