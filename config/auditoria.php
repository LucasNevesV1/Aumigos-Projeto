<?php
function registrarLog($pdo, $acao, $tabela = null, $id_registro = null, $descricao = null) {
    try {
        $id_usuario = $_SESSION['id_usuario'] ?? null;
        $ip         = $_SERVER['REMOTE_ADDR'] ?? null;

        $pdo->prepare('
            INSERT INTO log_auditoria (id_usuario, acao, tabela_afetada, id_registro, descricao, ip_origem)
            VALUES (?, ?, ?, ?, ?, ?)
        ')->execute([$id_usuario, $acao, $tabela, $id_registro, $descricao, $ip]);
    } catch (Exception $e) {
        // Falha silenciosa — o sistema continua funcionando mesmo sem a tabela de auditoria
    }
}
