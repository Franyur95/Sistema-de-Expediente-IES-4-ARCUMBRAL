<?php
/*
 * Sesión, autenticación, permisos, CSRF, mensajes flash y auditoría.
 * Todas las páginas incluyen este archivo al comienzo.
 */

require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/layout.php';

error_reporting(E_ALL);
ini_set('display_errors', DEBUG ? '1' : '0');
ini_set('log_errors', '1');

// Hash de relleno para que el tiempo de respuesta no revele si un usuario existe.
const HASH_FALSO = '$2y$10$T/5X7Elc7KAgT91F5Iu1n.BnVjX82H.HvTRdWyTHEL8Gvoz59Se3O';

// Roles que pueden crear y modificar expedientes. La Vicerrectora solo consulta.
const ROLES_EDICION = ['preceptora', 'coordinadora', 'admin'];

// Cabeceras de seguridad (el sistema no usa JavaScript, por eso la política es estricta).
header('X-Frame-Options: DENY');
header('X-Content-Type-Options: nosniff');
header('Referrer-Policy: same-origin');
header("Content-Security-Policy: default-src 'self'; style-src 'self'; img-src 'self'; form-action 'self'; frame-ancestors 'none'");
header('Cache-Control: no-store, no-cache, must-revalidate');
header('Pragma: no-cache');

if (session_status() === PHP_SESSION_NONE) {
    session_name('expediente_sid');
    session_set_cookie_params([
        'lifetime' => 0,
        'path'     => '/',
        'httponly' => true,
        'samesite' => 'Lax',
        'secure'   => !empty($_SERVER['HTTPS']),
    ]);
    session_start();
}

/* ---------- Utilidades ---------- */

function e($valor): string
{
    return htmlspecialchars((string)$valor, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

function redirigir(string $url): void
{
    header('Location: ' . $url);
    exit;
}

function fecha_ar(?string $fecha): string
{
    if ($fecha === null || $fecha === '') {
        return '—';
    }
    $dt = DateTimeImmutable::createFromFormat('!Y-m-d', substr($fecha, 0, 10));
    return $dt ? $dt->format('d/m/Y') : '—';
}

/* ---------- Mensajes flash ---------- */

function flash(string $tipo, string $mensaje): void
{
    $_SESSION['flash'][] = ['tipo' => $tipo, 'msg' => $mensaje];
}

function flash_html(): string
{
    $html = '';
    foreach ($_SESSION['flash'] ?? [] as $f) {
        $clase = $f['tipo'] === 'ok' ? 'ok' : ($f['tipo'] === 'aviso' ? 'aviso' : 'error');
        $html .= '<div class="alerta ' . $clase . '" role="status">' . e($f['msg']) . '</div>';
    }
    unset($_SESSION['flash']);
    return $html;
}

/* ---------- CSRF ---------- */

function csrf_token(): string
{
    if (empty($_SESSION['csrf'])) {
        $_SESSION['csrf'] = bin2hex(random_bytes(32));
    }
    return $_SESSION['csrf'];
}

function csrf_campo(): string
{
    return '<input type="hidden" name="csrf" value="' . e(csrf_token()) . '">';
}

function csrf_valido(): bool
{
    $enviado = $_POST['csrf'] ?? '';
    return is_string($enviado) && $enviado !== '' && hash_equals($_SESSION['csrf'] ?? '', $enviado);
}

/* ---------- Sesión y permisos ---------- */

function cerrar_sesion(): void
{
    $_SESSION = [];
    if (ini_get('session.use_cookies')) {
        $p = session_get_cookie_params();
        setcookie(session_name(), '', time() - 3600, $p['path'], $p['domain'], $p['secure'], $p['httponly']);
    }
    session_destroy();
}

/**
 * Exige un usuario autenticado y activo. Devuelve sus datos actualizados desde la base.
 */
function require_login(): array
{
    $u = $_SESSION['usuario'] ?? null;
    if (!is_array($u) || !isset($u['id_usuario'])) {
        redirigir('login.php');
    }

    if (time() - (int)($_SESSION['ultima_actividad'] ?? 0) > SESION_MINUTOS * 60) {
        cerrar_sesion();
        redirigir('login.php?expirada=1');
    }
    $_SESSION['ultima_actividad'] = time();

    // Se vuelve a consultar el usuario: si fue desactivado o cambió de rol, se aplica de inmediato.
    $st = db()->prepare('SELECT id_usuario, nombre, usuario, rol, id_carrera FROM usuarios WHERE id_usuario = ? AND activo = 1');
    $st->execute([(int)$u['id_usuario']]);
    $fresco = $st->fetch();
    if (!$fresco) {
        cerrar_sesion();
        redirigir('login.php');
    }
    $fresco['id_usuario'] = (int)$fresco['id_usuario'];
    $fresco['id_carrera'] = $fresco['id_carrera'] === null ? null : (int)$fresco['id_carrera'];
    $_SESSION['usuario'] = $fresco;

    return $fresco;
}

function puede_editar(array $usuario): bool
{
    return in_array($usuario['rol'], ROLES_EDICION, true);
}

/** Un usuario con carrera asignada solo puede MODIFICAR alumnos de esa carrera (consultar puede todos). */
function carrera_permitida(array $usuario, int $idCarrera): bool
{
    return $usuario['id_carrera'] === null || (int)$usuario['id_carrera'] === $idCarrera;
}

function exigir_edicion(array $usuario): void
{
    if (!puede_editar($usuario)) {
        pagina_error(403, 'Acceso denegado', 'Su rol (' . $usuario['rol'] . ') solo permite consultar expedientes.', $usuario);
    }
}

/* ---------- Auditoría ---------- */

function auditar(string $accion, ?string $detalle, ?int $idEstudiante, int $idUsuario): void
{
    if (str_starts_with($accion, 'Inicio')) { $tipo = 'LOGIN'; }
    elseif (str_starts_with($accion, 'Alta') || str_starts_with($accion, 'Carga')) { $tipo = 'INSERT'; }
    elseif (str_starts_with($accion, 'Elimin')) { $tipo = 'DELETE'; }
    else { $tipo = 'UPDATE'; }

    $motivo = mb_substr($accion . ($detalle ? ': ' . $detalle : ''), 0, 255);
    $st = db()->prepare('INSERT INTO auditoria (id_usuario, tabla, registro_id, accion, motivo, ip) VALUES (?, ?, ?, ?, ?, ?)');
    $st->execute([$idUsuario, 'estudiantes', $idEstudiante, $tipo, $motivo, $_SERVER['REMOTE_ADDR'] ?? null]);
}