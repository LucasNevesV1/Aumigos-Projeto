<?php
require_once '../config/conexao.php';
require_once '../vendor/autoload.php';

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: ../pages/esqueci-senha.html');
    exit;
}

$email = trim($_POST['email'] ?? '');

if (!$email) {
    header('Location: ../pages/esqueci-senha.html?erro=email_vazio');
    exit;
}

// Verifica se o e-mail existe no banco (silenciosamente — não revela se existe ou não)
$stmt = $pdo->prepare('SELECT id_usuario FROM usuario WHERE email = ? AND ativo = 1');
$stmt->execute([$email]);
$usuario = $stmt->fetch();

if ($usuario) {
    // Gera token seguro
    $token = bin2hex(random_bytes(32));
    $expira = date('Y-m-d H:i:s', strtotime('+1 hour'));

    // Invalida tokens anteriores para esse e-mail
    $pdo->prepare('UPDATE reset_senha SET usado = 1 WHERE email = ?')->execute([$email]);

    // Salva novo token
    $stmt = $pdo->prepare('INSERT INTO reset_senha (email, token, expira_em) VALUES (?, ?, ?)');
    $stmt->execute([$email, $token, $expira]);

    // Monta link
    $link = 'http://aumigos.local/pages/redefinir-senha.html?token=' . $token;

    // Envia e-mail via PHPMailer + Mailtrap
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
        $mail->addAddress($email);

        $mail->isHTML(true);
        $mail->Subject = 'Redefinição de senha - AuMigos';
        $mail->Body    = '
        <!DOCTYPE html>
        <html lang="pt-br">
        <head><meta charset="UTF-8"></head>
        <body style="margin:0;padding:0;background:#f9f7f2;font-family:Arial,sans-serif;">
            <table width="100%" cellpadding="0" cellspacing="0" style="background:#f9f7f2;padding:40px 0;">
                <tr>
                    <td align="center">
                        <table width="520" cellpadding="0" cellspacing="0" style="background:#ffffff;border-radius:12px;overflow:hidden;box-shadow:0 2px 8px rgba(0,0,0,0.08);">

                            <!-- Header verde -->
                            <tr>
                                <td style="background:#006666;padding:32px 40px;text-align:center;">
                                    <span style="font-size:26px;font-weight:bold;color:#ffffff;letter-spacing:1px;">AuMigos</span>
                                    <p style="margin:6px 0 0;color:#a8d8d8;font-size:13px;">Plataforma de adoção responsável</p>
                                </td>
                            </tr>

                            <!-- Corpo -->
                            <tr>
                                <td style="padding:36px 40px;">
                                    <p style="margin:0 0 12px;font-size:16px;color:#333333;">Olá!</p>
                                    <p style="margin:0 0 16px;font-size:15px;color:#555555;line-height:1.6;">
                                        Recebemos uma solicitação para redefinir a senha da sua conta <strong>AuMigos</strong>.
                                    </p>
                                    <p style="margin:0 0 28px;font-size:15px;color:#555555;line-height:1.6;">
                                        Clique no botão abaixo para criar uma nova senha. O link é válido por <strong style="color:#006666;">1 hora</strong>.
                                    </p>

                                    <!-- Botão -->
                                    <table width="100%" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td align="center" style="padding:8px 0 32px;">
                                                <a href="' . $link . '" style="display:inline-block;background:#006666;color:#ffffff;padding:14px 36px;border-radius:8px;text-decoration:none;font-size:15px;font-weight:bold;letter-spacing:0.5px;">
                                                    Redefinir senha
                                                </a>
                                            </td>
                                        </tr>
                                    </table>

                                    <p style="margin:0 0 8px;font-size:13px;color:#888888;">
                                        Se o botão não funcionar, copie e cole o link abaixo no seu navegador:
                                    </p>
                                    <p style="margin:0 0 28px;font-size:12px;word-break:break-all;">
                                        <a href="' . $link . '" style="color:#006666;">' . $link . '</a>
                                    </p>

                                    <hr style="border:none;border-top:1px solid #eeeeee;margin:0 0 24px;">

                                    <p style="margin:0;font-size:13px;color:#aaaaaa;line-height:1.6;">
                                        Se você não solicitou a redefinição de senha, ignore este e-mail. Sua senha permanece a mesma.
                                    </p>
                                </td>
                            </tr>

                            <!-- Footer -->
                            <tr>
                                <td style="background:#f9f7f2;padding:20px 40px;text-align:center;border-top:1px solid #eeeeee;">
                                    <p style="margin:0;font-size:12px;color:#aaaaaa;">
                                        © 2026 AuMigos &mdash; Todos os direitos reservados
                                    </p>
                                </td>
                            </tr>

                        </table>
                    </td>
                </tr>
            </table>
        </body>
        </html>
        ';
        $mail->AltBody = 'Acesse o link para redefinir sua senha: ' . $link;

        $mail->send();
    } catch (Exception $e) {
        // Falha silenciosa — não revela detalhes ao usuário
    }
}

// Sempre redireciona com "enviado" — não revela se e-mail existe
header('Location: ../pages/esqueci-senha.html?status=enviado');
exit;
