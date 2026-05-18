<?php
header('Content-Type: application/json');
session_start();
require_once '../config/conexao.php';
require_once '../config/auditoria.php';

if (!isset($_SESSION['id_usuario'])) {
    echo json_encode(['erro' => 'Não autorizado']);
    exit;
}

$id_ong = (int) $_SESSION['id_usuario'];

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    buscarSolicitacao($pdo, (int) ($_GET['id_animal'] ?? 0), $id_ong);
} elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    processarSolicitacao($pdo, $data, $id_ong);
} else {
    echo json_encode(['erro' => 'Método não permitido']);
}

/* ── Busca a solicitação pendente de um animal da ONG ── */
function buscarSolicitacao($pdo, $id_animal, $id_ong) {
    if (!$id_animal) { echo json_encode(['erro' => 'ID inválido']); return; }

    $stmt = $pdo->prepare("
        SELECT
            ad.id_adocao,
            ad.dataSolicitacao,
            ad.termoResponsabilidade AS mensagem,
            u.nome     AS adotante_nome,
            u.email    AS adotante_email,
            u.telefone AS adotante_telefone
        FROM adocao ad
        JOIN usuario u        ON u.id_usuario        = ad.id_usuario
        JOIN animal a         ON a.id_animal          = ad.id_animal
        JOIN statusadocao s   ON s.id_statusAdocao    = ad.id_statusAdocao
        WHERE ad.id_animal = ?
          AND a.id_usuario = ?
          AND s.statusNome = 'Pendente'
        ORDER BY ad.dataSolicitacao DESC
        LIMIT 1
    ");
    $stmt->execute([$id_animal, $id_ong]);
    $row = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$row) { echo json_encode(['erro' => 'Solicitação não encontrada']); return; }

    echo json_encode($row);
}

/* ── Aprova ou reprova a solicitação ── */
function processarSolicitacao($pdo, $data, $id_ong) {
    $id_adocao = (int) ($data['id_adocao'] ?? 0);
    $id_animal = (int) ($data['id_animal'] ?? 0);
    $acao      = $data['acao'] ?? '';

    if (!$id_adocao || !$id_animal || !in_array($acao, ['aprovar', 'reprovar'])) {
        echo json_encode(['erro' => 'Dados inválidos']);
        return;
    }

    /* Confirma que o animal pertence à ONG */
    $chk = $pdo->prepare("SELECT id_animal FROM animal WHERE id_animal = ? AND id_usuario = ?");
    $chk->execute([$id_animal, $id_ong]);
    if (!$chk->fetch()) { echo json_encode(['erro' => 'Sem permissão']); return; }

    try {
        $pdo->beginTransaction();

        $nomeStatus   = $acao === 'aprovar' ? 'Aprovado' : 'Recusado';
        $statusAnimal = $acao === 'aprovar' ? 'adotado'  : 'disponivel';

        /* Garante que o status existe na tabela */
        $s = $pdo->prepare("SELECT id_statusAdocao FROM statusadocao WHERE statusNome = ? LIMIT 1");
        $s->execute([$nomeStatus]);
        $row = $s->fetch();
        if ($row) {
            $idStatus = (int) $row['id_statusAdocao'];
        } else {
            $pdo->prepare("INSERT INTO statusadocao (statusNome, statusSituacao, dataCriacao) VALUES (?, 1, NOW())")
                ->execute([$nomeStatus]);
            $idStatus = (int) $pdo->lastInsertId();
        }

        /* Atualiza o registro de adoção */
        $campoData = $acao === 'aprovar' ? ', dataAdocao = CURDATE()' : '';
        $pdo->prepare("UPDATE adocao SET id_statusAdocao = ? $campoData WHERE id_adocao = ?")
            ->execute([$idStatus, $id_adocao]);

        /* Atualiza o status do animal */
        $pdo->prepare("UPDATE animal SET status = ? WHERE id_animal = ?")
            ->execute([$statusAnimal, $id_animal]);

        $pdo->commit();

        $acaoLog = $acao === 'aprovar' ? 'ADOCAO_APROVADA' : 'ADOCAO_REJEITADA';
        registrarLog($pdo, $acaoLog, 'adocao', $id_adocao, "Adoção ID $id_adocao ($acao) — animal ID: $id_animal");

        echo json_encode(['ok' => true, 'novoStatus' => $statusAnimal]);

    } catch (Exception $e) {
        $pdo->rollBack();
        echo json_encode(['erro' => $e->getMessage()]);
    }
}
