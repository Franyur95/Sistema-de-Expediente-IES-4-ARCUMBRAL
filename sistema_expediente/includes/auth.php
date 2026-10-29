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

// Los permisos efectivos se leen de rol_permiso/permisos, definidos por el esquema v2.

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
    $st = db()->prepare('SELECT id_usuario, nombre, usuario, rol, id_carrera, debe_cambiar_clave FROM usuarios WHERE id_usuario = ? AND activo = 1');
    $st->execute([(int)$u['id_usuario']]);
    $fresco = $st->fetch();
    if (!$fresco) {
        cerrar_sesion();
        redirigir('login.php');
    }
    $fresco['id_usuario'] = (int)$fresco['id_usuario'];
    $fresco['id_carrera'] = $fresco['id_carrera'] === null ? null : (int)$fresco['id_carrera'];
    $fresco['debe_cambiar_clave'] = (int)$fresco['debe_cambiar_clave'];
    $_SESSION['usuario'] = $fresco;

    // Las cuentas nuevas o con contraseña restablecida deben cambiarla antes de usar otros módulos.
    $paginaActual = basename((string)($_SERVER['SCRIPT_NAME'] ?? ''));
    if ($fresco['debe_cambiar_clave'] === 1 && !in_array($paginaActual, ['cambiar_clave.php', 'logout.php'], true)) {
        redirigir('cambiar_clave.php?obligatoria=1');
    }

    return $fresco;
}

/**
 * Consulta el permiso efectivo del rol en las tablas permisos/rol_permiso.
 * Los resultados se cachean solo durante esta petición PHP.
 */
function tiene_permiso(array $usuario, string $codigo, bool $editar = false): bool
{
    static $cache = [];
    $rol = (string)($usuario['rol'] ?? '');
    if ($rol === '' || $codigo === '') {
        return false;
    }

    $clave = $rol . '|' . $codigo;
    if (!array_key_exists($clave, $cache)) {
        $sql = 'SELECT rp.puede_ver, rp.puede_editar
                FROM rol_permiso rp
                INNER JOIN permisos p ON p.id_permiso = rp.id_permiso
                WHERE rp.rol = ? AND p.codigo = ?
                LIMIT 1';
        $st = db()->prepare($sql);
        $st->execute([$rol, $codigo]);
        $fila = $st->fetch(PDO::FETCH_ASSOC);
        $cache[$clave] = $fila ? [
            'ver' => (int)$fila['puede_ver'] === 1,
            'editar' => (int)$fila['puede_editar'] === 1,
        ] : ['ver' => false, 'editar' => false];
    }

    return $cache[$clave][$editar ? 'editar' : 'ver'];
}

/** Exige permiso de lectura o edición y bloquea el acceso directo a la URL. */
function exigir_permiso(array $usuario, string $codigo, bool $editar = false): void
{
    if (!tiene_permiso($usuario, $codigo, $editar)) {
        http_response_code(403);
        $accion = $editar ? 'modificar' : 'consultar';
        pagina_error(403, 'Acceso denegado', 'Su rol no tiene permiso para ' . $accion . ' este módulo.', $usuario);
    }
}

function puede_ver_expedientes(array $usuario): bool
{
    return tiene_permiso($usuario, 'expedientes.ver');
}

function puede_editar(array $usuario): bool
{
    return tiene_permiso($usuario, 'expedientes.editar', true);
}

function puede_ver_academico(array $usuario): bool
{
    return tiene_permiso($usuario, 'notas.ver');
}

function puede_editar_academico(array $usuario): bool
{
    return tiene_permiso($usuario, 'notas.editar', true);
}

/**
 * Los usuarios con carrera asignada solo pueden operar sobre esa carrera.
 * Los usuarios sin carrera asignada pueden operar sobre todas las carreras autorizadas por su rol.
 */
function carrera_permitida(array $usuario, int $idCarrera): bool
{
    return $idCarrera > 0 && (($usuario['id_carrera'] ?? null) === null || (int)$usuario['id_carrera'] === $idCarrera);
}

function exigir_edicion(array $usuario): void
{
    exigir_permiso($usuario, 'expedientes.editar', true);
}

function exigir_edicion_academica(array $usuario): void
{
    exigir_permiso($usuario, 'notas.editar', true);
}

/* ---------- Auditoría ---------- */

function auditar(string $accion, ?string $detalle, ?int $idEstudiante, int $idUsuario): void
{
    if (str_starts_with($accion, 'Inicio')) { $tipo = 'LOGIN'; }
    elseif (str_starts_with($accion, 'Alta') || str_starts_with($accion, 'Carga')) { $tipo = 'INSERT'; }
    elseif (str_starts_with($accion, 'Elimin')) { $tipo = 'DELETE'; }
    else { $tipo = 'UPDATE'; }

    $motivo = mb_substr($accion . ($detalle ? ': ' . $detalle : ''), 0, 255);
    $tabla = str_contains(mb_strtolower($accion), 'contraseña') ? 'usuarios' : (str_contains(mb_strtolower($accion), 'inscrip') || str_contains(mb_strtolower($accion), 'cursada') || str_contains(mb_strtolower($accion), 'examen') ? 'cursadas' : 'estudiantes');
    $st = db()->prepare('INSERT INTO auditoria (id_usuario, tabla, registro_id, accion, motivo, ip, user_agent) VALUES (?, ?, ?, ?, ?, ?, ?)');
    $st->execute([$idUsuario, $tabla, $idEstudiante, $tipo, $motivo, $_SERVER['REMOTE_ADDR'] ?? null, mb_substr((string)($_SERVER['HTTP_USER_AGENT'] ?? ''), 0, 255)]);
}