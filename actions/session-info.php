<?php
session_start();
header('Content-Type: application/json');

if (!isset($_SESSION['nome'])) {
    http_response_code(401);
    echo json_encode(['erro' => 'Não autenticado']);
    exit;
}

echo json_encode([
    'nome'    => $_SESSION['nome'],
    'id_tipo' => $_SESSION['id_tipo'] ?? null,
]);