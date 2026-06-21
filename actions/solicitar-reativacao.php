<?php
header('Content-Type: application/json');
require_once '../config/conexao.php';
require_once '../config/auditoria.php';
require_once '../vendor/autoload.php';

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['erro' => 'Método não permitido']);
    exit;
}

$data     = json_decode(file_get_contents('php://input'), true);
$nome     = trim($data['nome']     ?? '');
$email    = trim($data['email']    ?? '');
$mensagem = trim($data['mensagem'] ?? '');

if (!$nome || !$email || !$mensagem) {
    echo json_encode(['erro' => 'Preencha todos os campos.']);
    exit;
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    echo json_encode(['erro' => 'E-mail inválido.']);
    exit;
}

// Verifica se o e-mail pertence a uma conta realmente desativada
$stmt = $pdo->prepare('SELECT id_usuario FROM usuario WHERE email = ? AND ativo = 0');
$stmt->execute([$email]);
$usuario = $stmt->fetch();

if (!$usuario) {
    // Não revela se o e-mail existe ou não
    echo json_encode(['ok' => true]);
    exit;
}

// Registra a solicitação no log de auditoria
session_start();
registrarLog($pdo, 'SOLICITACAO_REATIVACAO', 'usuario', $usuario['id_usuario'],
    "Solicitação de reativação de: $nome ($email)");

// Envia e-mail ao admin via PHPMailer + Mailtrap
$mail = new PHPMailer(true);
try {
    $mail->isSMTP();
    $mail->Host       = 'sandbox.smtp.mailtrap.io';
    $mail->SMTPAuth   = true;
    $mail->Username   = '0f7c76647cd9d5';
    $mail->Password   = 'ea1496ffd7b712';
    $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
    $mail->Port       = 587;
    $mail->CharSet    = 'UTF-8';

    $mail->setFrom('noreply@aumigos.local', 'AuMigos');
    $mail->addAddress('admin@aumigos.com', 'Administrador AuMigos');
    $mail->addReplyTo($email, $nome);

    $mail->isHTML(true);
    $mail->Subject = "Solicitação de reativação de conta — $nome";

    $nomeEsc     = htmlspecialchars($nome);
    $emailEsc    = htmlspecialchars($email);
    $mensagemEsc = nl2br(htmlspecialchars($mensagem));

    $mail->Body = '
    <!DOCTYPE html>
    <html lang="pt-br">
    <head><meta charset="UTF-8"></head>
    <body style="margin:0;padding:0;background:#f9f7f2;font-family:Arial,sans-serif;">
        <table width="100%" cellpadding="0" cellspacing="0" style="background:#f9f7f2;padding:40px 0;">
            <tr>
                <td align="center">
                    <table width="520" cellpadding="0" cellspacing="0"
                        style="background:#ffffff;border-radius:12px;overflow:hidden;box-shadow:0 2px 8px rgba(0,0,0,.08);">

                        <tr>
                            <td style="background:#006666;padding:32px 40px;text-align:center;">
                                <span style="font-size:26px;font-weight:bold;color:#ffffff;letter-spacing:1px;">AuMigos</span>
                                <p style="margin:6px 0 0;color:#a8d8d8;font-size:13px;">Plataforma de adoção responsável</p>
                            </td>
                        </tr>

                        <tr>
                            <td style="padding:36px 40px;">
                                <p style="margin:0 0 16px;font-size:16px;color:#333">
                                    Uma conta desativada enviou uma <strong>solicitação de reativação</strong>.
                                </p>

                                <table width="100%" cellpadding="0" cellspacing="0"
                                    style="background:#f9f7f2;border-radius:8px;padding:16px 20px;margin-bottom:24px">
                                    <tr><td style="font-size:14px;color:#555;padding:4px 0">
                                        <strong>Nome:</strong> ' . $nomeEsc . '
                                    </td></tr>
                                    <tr><td style="font-size:14px;color:#555;padding:4px 0">
                                        <strong>E-mail:</strong> ' . $emailEsc . '
                                    </td></tr>
                                    <tr><td style="font-size:14px;color:#555;padding:12px 0 4px">
                                        <strong>Mensagem:</strong><br>' . $mensagemEsc . '
                                    </td></tr>
                                </table>

                                <p style="margin:0;font-size:13px;color:#aaa;line-height:1.6;">
                                    Para reativar a conta, acesse o Painel Admin &rsaquo; Usuários e clique em <em>Reativar</em>.
                                </p>
                            </td>
                        </tr>

                        <tr>
                            <td style="background:#f9f7f2;padding:20px 40px;text-align:center;border-top:1px solid #eee;">
                                <p style="margin:0;font-size:12px;color:#aaa;">
                                    &copy; 2026 AuMigos &mdash; Todos os direitos reservados
                                </p>
                            </td>
                        </tr>

                    </table>
                </td>
            </tr>
        </table>
    </body>
    </html>';

    $mail->AltBody = "Solicitação de reativação\nNome: $nome\nE-mail: $email\nMensagem: $mensagem";
    $mail->send();

} catch (Exception $e) {
    // Falha silenciosa no e-mail — o log já foi registrado
}

echo json_encode(['ok' => true]);
