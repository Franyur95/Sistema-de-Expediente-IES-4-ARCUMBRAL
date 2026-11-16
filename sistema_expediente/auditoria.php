<?php
require_once __DIR__ . '/includes/auth.php';
require_once __DIR__ . '/includes/semaforo.php';

$usuario = require_login();
exigir_permiso($usuario, 'auditoria.ver');

const ACCIONES_AUDITORIA = ['INSERT', 'UPDATE', 'DELETE', 'LOGIN', 'LOGOUT', 'EXPORT', 'BACKUP'];

function aud_fecha(string $clave): string
{
    $v = $_GET[$clave] ?? '';
    if (is_string($v) && preg_match('/^(\d{4})-(\d{2})-(\d{2})$/', $v, $m) && checkdate((int)$m[2], (int)$m[3], (int)$m[1])) {
        return $v;
    }
    return '';
}

function aud_url(array $p): string
{
    $p = array_filter($p, static fn($v) => $v !== '' && $v !== 0 && $v !== null);
    return 'auditoria.php' . ($p ? '?' . http_build_query($p) : '');
}

$accion  = (is_string($_GET['accion'] ?? null) && in_array($_GET['accion'], ACCIONES_AUDITORIA, true)) ? $_GET['accion'] : '';
$idUsu   = (isset($_GET['usuario']) && is_string($_GET['usuario']) && ctype_digit($_GET['usuario'])) ? (int)$_GET['usuario'] : 0;
$desde   = aud_fecha('desde');
$hasta   = aud_fecha('hasta');
$pagina  = pagina_desde_get();

$error = '';
$usuarios = [];
$filas = [];
$total = 0;
$paginas = 1;

try {
    $usuarios = db()->query('SELECT id_usuario, nombre, usuario FROM usuarios ORDER BY nombre')->fetchAll(PDO::FETCH_ASSOC);

    $where = [];
    $params = [];
    if ($accion !== '') { $where[] = 'a.accion = :accion'; $params[':accion'] = $accion; }
    if ($idUsu > 0)     { $where[] = 'a.id_usuario = :usu'; $params[':usu'] = $idUsu; }
    if ($desde !== '')  { $where[] = 'a.fecha >= :desde'; $params[':desde'] = $desde . ' 00:00:00'; }
    if ($hasta !== '')  { $where[] = 'a.fecha < DATE_ADD(:hasta, INTERVAL 1 DAY)'; $params[':hasta'] = $hasta; }
    $sqlWhere = $where ? ' WHERE ' . implode(' AND ', $where) : '';

    $st = db()->prepare('SELECT COUNT(*) FROM auditoria a' . $sqlWhere);
    $st->execute($params);
    $total = (int)$st->fetchColumn();
    $paginas = max(1, (int)ceil($total / POR_PAGINA));
    $pagina = min($pagina, $paginas);

    $st = db()->prepare(
        'SELECT a.fecha, a.accion, a.tabla, a.registro_id, a.motivo,
                u.nombre AS usuario_nombre, u.usuario AS usuario_login,
                e.apellido AS est_apellido, e.nombre AS est_nombre
         FROM auditoria a
         LEFT JOIN usuarios u ON u.id_usuario = a.id_usuario
         LEFT JOIN estudiantes e ON a.tabla = \'estudiantes\' AND e.id_estudiante = a.registro_id' . $sqlWhere . '
         ORDER BY a.fecha DESC, a.id_auditoria DESC
         LIMIT :lim OFFSET :off'
    );
    foreach ($params as $k => $v) {
        $st->bindValue($k, $v, is_int($v) ? PDO::PARAM_INT : PDO::PARAM_STR);
    }
    $st->bindValue(':lim', POR_PAGINA, PDO::PARAM_INT);
    $st->bindValue(':off', ($pagina - 1) * POR_PAGINA, PDO::PARAM_INT);
    $st->execute();
    $filas = $st->fetchAll(PDO::FETCH_ASSOC);
} catch (Throwable $ex) {
    error_log('Error en el registro de auditoría: ' . $ex->getMessage());
    $error = 'No se pudo consultar el registro de auditoría.';
}

$filtros = ['accion' => $accion, 'usuario' => $idUsu, 'desde' => $desde, 'hasta' => $hasta];

render_header('Registro de auditoría', $usuario);
?>
<p class="nota">Historial de operaciones del sistema: quién hizo cada cambio y cuándo. Es solo de consulta: ninguna pantalla permite modificar ni borrar estos registros.</p>

<?php if ($error !== ''): ?>
<div class="alerta error" role="alert"><?= e($error) ?></div>
<?php else: ?>

<section class="tarjeta">
  <form method="get" action="auditoria.php" class="form-busqueda">
    <div class="campo">
      <label for="usuario">Usuario</label>
      <select id="usuario" name="usuario">
        <option value="">Todos</option>
<?php foreach ($usuarios as $u): ?>
        <option value="<?= (int)$u['id_usuario'] ?>"<?= (int)$u['id_usuario'] === $idUsu ? ' selected' : '' ?>><?= e($u['nombre']) ?> (<?= e($u['usuario']) ?>)</option>
<?php endforeach; ?>
      </select>
    </div>
    <div class="campo">
      <label for="accion">Acción</label>
      <select id="accion" name="accion">
        <option value="">Todas</option>
<?php foreach (ACCIONES_AUDITORIA as $a): ?>
        <option value="<?= e($a) ?>"<?= $a === $accion ? ' selected' : '' ?>><?= e($a) ?></option>
<?php endforeach; ?>
      </select>
    </div>
    <div class="campo">
      <label for="desde">Desde</label>
      <input type="date" id="desde" name="desde" value="<?= e($desde) ?>">
    </div>
    <div class="campo">
      <label for="hasta">Hasta</label>
      <input type="date" id="hasta" name="hasta" value="<?= e($hasta) ?>">
    </div>
    <button type="submit" class="btn">Filtrar</button>
    <a class="btn btn-sec" href="auditoria.php">Limpiar</a>
  </form>
</section>

<p><?= $total ?> registro<?= $total === 1 ? '' : 's' ?>.</p>

<?php if ($filas): ?>
<div class="tabla-wrap">
  <table class="tabla">
    <thead><tr><th>Fecha y hora</th><th>Usuario</th><th>Acción</th><th>Sobre</th><th>Detalle</th></tr></thead>
    <tbody>
<?php foreach ($filas as $f): ?>
      <tr>
        <td><?= e(substr((string)$f['fecha'], 8, 2) . '/' . substr((string)$f['fecha'], 5, 2) . '/' . substr((string)$f['fecha'], 0, 4) . ' ' . substr((string)$f['fecha'], 11, 5)) ?></td>
        <td><?= $f['usuario_nombre'] !== null ? e($f['usuario_nombre']) . ' (' . e($f['usuario_login']) . ')' : '—' ?></td>
        <td><?= e($f['accion']) ?></td>
        <td>
<?php if ($f['est_apellido'] !== null): ?>
          <?= e($f['est_apellido']) ?>, <?= e($f['est_nombre']) ?>
<?php else: ?>
          <?= e($f['tabla']) ?><?= $f['registro_id'] !== null ? ' #' . (int)$f['registro_id'] : '' ?>
<?php endif; ?>
        </td>
        <td><?= e($f['motivo'] ?? '') ?></td>
      </tr>
<?php endforeach; ?>
    </tbody>
  </table>
</div>

<?php if ($paginas > 1): ?>
<nav class="paginacion" aria-label="Paginación">
<?php if ($pagina > 1): ?><a href="<?= e(aud_url($filtros + ['pagina' => $pagina - 1])) ?>">« Anterior</a><?php endif; ?>
  <span>Página <?= $pagina ?> de <?= $paginas ?></span>
<?php if ($pagina < $paginas): ?><a href="<?= e(aud_url($filtros + ['pagina' => $pagina + 1])) ?>">Siguiente »</a><?php endif; ?>
</nav>
<?php endif; ?>
<?php else: ?>
<div class="alerta aviso">No hay registros con esos filtros.</div>
<?php endif; ?>
<?php endif; ?>
<?php render_footer(); ?>
