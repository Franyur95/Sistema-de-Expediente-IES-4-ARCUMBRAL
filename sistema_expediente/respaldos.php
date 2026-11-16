<?php
require_once __DIR__ . '/includes/auth.php';

$usuario = require_login();
exigir_permiso($usuario, 'respaldos.ver');
$puedeGenerar = tiene_permiso($usuario, 'respaldos.editar', true);

const DIR_RESPALDOS = __DIR__ . '/backups';
const PATRON_RESPALDO = '/^respaldo_\d{8}_\d{6}\.sql$/';

function respaldo_registrar(int $idUsuario, string $accion, string $detalle): void
{
    try {
        db()->prepare("INSERT INTO auditoria (id_usuario, tabla, registro_id, accion, motivo) VALUES (?, 'sistema', NULL, ?, ?)")
            ->execute([$idUsuario, $accion, mb_substr($detalle, 0, 255)]);
    } catch (Throwable $ex) {
        error_log('No se pudo registrar el respaldo en auditoría: ' . $ex->getMessage());
    }
}

function respaldo_preparar_carpeta(): bool
{
    if (!is_dir(DIR_RESPALDOS) && !@mkdir(DIR_RESPALDOS, 0775, true)) {
        return false;
    }
    $ht = DIR_RESPALDOS . '/.htaccess';
    if (!file_exists($ht)) {
        @file_put_contents($ht, "Require all denied\n");
    }
    return true;
}

function respaldo_mysqldump(): string
{
    foreach (['C:\\xampp\\mysql\\bin\\mysqldump.exe', '/opt/lampp/bin/mysqldump'] as $ruta) {
        if (file_exists($ruta)) {
            return $ruta;
        }
    }
    return 'mysqldump';
}

/** Genera la copia con mysqldump. Devuelve [ok, mensaje]. */
function respaldo_generar(string $archivo): array
{
    if (!function_exists('proc_open')) {
        return [false, 'El servidor tiene deshabilitada la ejecución de programas (proc_open).'];
    }
    $cmd = [
        respaldo_mysqldump(), '--host=' . DB_HOST, '--port=' . DB_PORT, '--user=' . DB_USER,
        '--single-transaction', '--routines', '--triggers', '--default-character-set=utf8mb4',
        '--result-file=' . $archivo, DB_NAME,
    ];
    $env = getenv() ?: [];
    if (DB_PASS !== '') {
        $env['MYSQL_PWD'] = DB_PASS;
    }
    $proc = @proc_open($cmd, [1 => ['pipe', 'w'], 2 => ['pipe', 'w']], $pipes, null, $env);
    if (!is_resource($proc)) {
        return [false, 'No se pudo iniciar mysqldump.'];
    }
    stream_get_contents($pipes[1]);
    $err = stream_get_contents($pipes[2]);
    fclose($pipes[1]);
    fclose($pipes[2]);
    $codigo = proc_close($proc);

    if ($codigo !== 0 || !file_exists($archivo) || filesize($archivo) === 0) {
        error_log('Falló mysqldump (código ' . $codigo . '): ' . trim((string)$err));
        if (file_exists($archivo)) {
            @unlink($archivo);
        }
        return [false, 'No se pudo generar la copia. Revise que mysqldump esté instalado y el registro de errores de PHP.'];
    }
    return [true, 'Copia generada correctamente.'];
}

// Descarga de una copia (solo con permiso y nombre válido).
if (isset($_GET['descargar']) && is_string($_GET['descargar'])) {
    $nombre = basename($_GET['descargar']);
    $ruta = DIR_RESPALDOS . '/' . $nombre;
    if (preg_match(PATRON_RESPALDO, $nombre) && is_file($ruta)) {
        respaldo_registrar($usuario['id_usuario'], 'EXPORT', 'Descarga de la copia ' . $nombre);
        header('Content-Type: application/octet-stream');
        header('Content-Disposition: attachment; filename="' . $nombre . '"');
        header('Content-Length: ' . filesize($ruta));
        readfile($ruta);
        exit;
    }
    flash('error', 'La copia solicitada no existe.');
    redirigir('respaldos.php');
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!csrf_valido()) {
        flash('error', 'El formulario venció. Intente nuevamente.');
    } elseif (!$puedeGenerar) {
        flash('error', 'No tiene permiso para generar copias.');
    } elseif (!respaldo_preparar_carpeta()) {
        flash('error', 'No se pudo crear la carpeta de copias (backups).');
    } else {
        $nombre = 'respaldo_' . date('Ymd_His') . '.sql';
        [$ok, $msg] = respaldo_generar(DIR_RESPALDOS . '/' . $nombre);
        if ($ok) {
            respaldo_registrar($usuario['id_usuario'], 'BACKUP', 'Copia de seguridad manual: ' . $nombre);
            flash('ok', $msg . ' (' . $nombre . ')');
        } else {
            flash('error', $msg);
        }
    }
    redirigir('respaldos.php');
}

$copias = [];
foreach (glob(DIR_RESPALDOS . '/respaldo_*.sql') ?: [] as $ruta) {
    $nombre = basename($ruta);
    if (preg_match(PATRON_RESPALDO, $nombre)) {
        $copias[] = ['nombre' => $nombre, 'fecha' => filemtime($ruta), 'kb' => (int)ceil(filesize($ruta) / 1024)];
    }
}
usort($copias, static fn($a, $b) => $b['fecha'] <=> $a['fecha']);

render_header('Gestión de respaldos', $usuario);
?>
<section class="tarjeta">
  <h2>Copia de seguridad ahora</h2>
  <p>Genera un archivo .sql con toda la base de datos (datos, vistas y disparadores) en la carpeta <code>backups</code> del servidor.</p>
<?php if ($puedeGenerar): ?>
  <form method="post" action="respaldos.php">
    <?= csrf_campo() ?>
    <button type="submit" class="btn">Generar copia ahora</button>
  </form>
<?php else: ?>
  <p class="ayuda">Su rol solo permite consultar las copias existentes.</p>
<?php endif; ?>
</section>

<section class="tarjeta">
  <h2>Copias disponibles (<?= count($copias) ?>)</h2>
<?php if ($copias): ?>
  <div class="tabla-wrap">
    <table class="tabla">
      <thead><tr><th>Archivo</th><th>Fecha</th><th>Tamaño</th><th>Acciones</th></tr></thead>
      <tbody>
<?php foreach ($copias as $c): ?>
        <tr>
          <td><?= e($c['nombre']) ?></td>
          <td><?= e(date('d/m/Y H:i', $c['fecha'])) ?></td>
          <td><?= (int)$c['kb'] ?> KB</td>
          <td class="acciones"><a href="respaldos.php?descargar=<?= e(rawurlencode($c['nombre'])) ?>">Descargar</a></td>
        </tr>
<?php endforeach; ?>
      </tbody>
    </table>
  </div>
<?php else: ?>
  <p>Todavía no hay copias generadas.</p>
<?php endif; ?>
</section>

<section class="tarjeta">
  <h2>Programar copias automáticas</h2>
  <p>La copia automática la ejecuta Windows, no el navegador. En el servidor, abra el Símbolo del sistema como administrador y ejecute (ajuste la ruta si su carpeta es otra):</p>
  <p><code>schtasks /Create /SC DAILY /ST 20:00 /TN "Respaldo SIEA" /TR "C:\xampp\htdocs\sistema_expediente\database\respaldo_diario.bat"</code></p>
  <p class="ayuda">Esto crea una copia todos los días a las 20:00 en la carpeta <code>backups</code>. Conviene copiar esos archivos también a un pendrive o disco externo, fuera de la computadora servidor.</p>
</section>
<?php render_footer(); ?>
