<?php
require_once __DIR__ . '/includes/auth.php';
require_once __DIR__ . '/includes/estudiantes.php';
require_once __DIR__ . '/includes/academico.php';
require_once __DIR__ . '/includes/semaforo.php';   // pagina_desde_get()
require_once __DIR__ . '/includes/tramites.php';

$usuario = require_login();
exigir_permiso($usuario, 'tramites.ver');

// Filtros: estado (abiertos por defecto), tipo y apellido/DNI.
$estado = is_string($_GET['estado'] ?? null) ? $_GET['estado'] : 'abiertos';
if ($estado !== 'abiertos' && $estado !== 'todos' && !isset(TRAMITE_ESTADOS[$estado])) {
    $estado = 'abiertos';
}
$tipo = (is_string($_GET['tipo'] ?? null) && isset(TRAMITE_TIPOS[$_GET['tipo']])) ? $_GET['tipo'] : '';
$q = is_string($_GET['q'] ?? null) ? mb_substr(trim($_GET['q']), 0, 50) : '';
$pagina = pagina_desde_get();

$where = [];
$params = [];

if ($estado === 'abiertos') {
    $where[] = "t.estado IN ('en_curso','en_revision','observado')";
} elseif ($estado !== 'todos') {
    $where[] = 't.estado = :estado';
    $params[':estado'] = $estado;
}
if ($tipo !== '') {
    $where[] = 't.tipo = :tipo';
    $params[':tipo'] = $tipo;
}
if ($q !== '') {
    $like = '%' . str_replace(['\\', '%', '_'], ['\\\\', '\\%', '\\_'], $q) . '%';
    $where[] = '(e.apellido LIKE :q1 OR e.dni LIKE :q2)';
    $params[':q1'] = $like;
    $params[':q2'] = $like;
}
$sqlWhere = $where ? ' WHERE ' . implode(' AND ', $where) : '';

$st = db()->prepare('SELECT COUNT(*) FROM tramites t JOIN estudiantes e ON e.id_estudiante = t.id_estudiante' . $sqlWhere);
$st->execute($params);
$total = (int)$st->fetchColumn();
$paginas = max(1, (int)ceil($total / POR_PAGINA));
$pagina = min($pagina, $paginas);

$st = db()->prepare(
    'SELECT t.id_tramite, t.id_estudiante, t.tipo, t.estado, t.fecha_solicitud, t.fecha_limite,
            t.nro_resolucion, t.fecha_resolucion, e.apellido, e.nombre, e.dni
     FROM tramites t JOIN estudiantes e ON e.id_estudiante = t.id_estudiante'
    . $sqlWhere .
    ' ORDER BY (t.estado IN (\'resuelto\',\'rechazado\')), t.fecha_limite IS NULL, t.fecha_limite, t.id_tramite DESC
     LIMIT :lim OFFSET :off'
);
foreach ($params as $k => $v) {
    $st->bindValue($k, $v, PDO::PARAM_STR);
}
$st->bindValue(':lim', POR_PAGINA, PDO::PARAM_INT);
$st->bindValue(':off', ($pagina - 1) * POR_PAGINA, PDO::PARAM_INT);
$st->execute();
$filas = $st->fetchAll(PDO::FETCH_ASSOC);

function tr_url(string $estado, string $tipo, string $q, int $p): string
{
    return 'tramites.php?' . http_build_query(['estado' => $estado, 'tipo' => $tipo, 'q' => $q, 'pagina' => $p]);
}

render_header('Trámites', $usuario);
?>
<p class="nota">Pases, asimilaciones, equivalencias y notas de aprobación. Para iniciar uno, abra el expediente del alumno y use «Trámites».</p>

<section class="tarjeta">
  <form method="get" action="tramites.php" class="form-busqueda">
    <div class="campo">
      <label for="f_estado">Estado</label>
      <select id="f_estado" name="estado">
        <option value="abiertos"<?= $estado === 'abiertos' ? ' selected' : '' ?>>Abiertos (sin resolver)</option>
        <option value="todos"<?= $estado === 'todos' ? ' selected' : '' ?>>Todos</option>
<?php foreach (TRAMITE_ESTADOS as $k => $etq): ?>
        <option value="<?= e($k) ?>"<?= $estado === $k ? ' selected' : '' ?>><?= e($etq) ?></option>
<?php endforeach; ?>
      </select>
    </div>
    <div class="campo">
      <label for="f_tipo">Tipo</label>
      <select id="f_tipo" name="tipo">
        <option value="">Todos</option>
<?php foreach (TRAMITE_TIPOS as $k => $etq): ?>
        <option value="<?= e($k) ?>"<?= $tipo === $k ? ' selected' : '' ?>><?= e($etq) ?></option>
<?php endforeach; ?>
      </select>
    </div>
    <div class="campo">
      <label for="f_q">Apellido o DNI</label>
      <input type="search" id="f_q" name="q" value="<?= e($q) ?>" maxlength="50">
    </div>
    <button type="submit" class="btn">Filtrar</button>
    <a class="btn btn-sec" href="tramites.php">Limpiar</a>
  </form>
</section>

<p><?= $total ?> trámite<?= $total === 1 ? '' : 's' ?>.</p>

<?php if ($filas): ?>
<div class="tabla-wrap">
  <table class="tabla">
    <thead><tr><th>Alumno</th><th>DNI</th><th>Trámite</th><th>Solicitado</th><th>Fecha límite</th><th>Plazo</th><th>Estado</th><th>Resolución</th><th>Acciones</th></tr></thead>
    <tbody>
<?php foreach ($filas as $f): ?>
      <tr>
        <td><?= e($f['apellido']) ?>, <?= e($f['nombre']) ?></td>
        <td><?= e($f['dni']) ?></td>
        <td><?= e(tramite_tipo_etq($f['tipo'])) ?></td>
        <td><?= e(fecha_ar($f['fecha_solicitud'])) ?></td>
        <td><?= e($f['fecha_limite'] ? fecha_ar($f['fecha_limite']) : '—') ?></td>
        <td><?= tramite_plazo_html($f) ?></td>
        <td><?= e(tramite_estado_etq($f['estado'])) ?></td>
        <td><?= $f['nro_resolucion'] ? e($f['nro_resolucion']) . ' (' . e(fecha_ar($f['fecha_resolucion'])) . ')' : '—' ?></td>
        <td class="acciones"><a href="tramites_alumno.php?id=<?= (int)$f['id_estudiante'] ?>">Abrir</a></td>
      </tr>
<?php endforeach; ?>
    </tbody>
  </table>
</div>

<?php if ($paginas > 1): ?>
<nav class="paginacion" aria-label="Paginación">
<?php if ($pagina > 1): ?><a href="<?= e(tr_url($estado, $tipo, $q, $pagina - 1)) ?>">« Anterior</a><?php endif; ?>
  <span>Página <?= $pagina ?> de <?= $paginas ?></span>
<?php if ($pagina < $paginas): ?><a href="<?= e(tr_url($estado, $tipo, $q, $pagina + 1)) ?>">Siguiente »</a><?php endif; ?>
</nav>
<?php endif; ?>
<?php else: ?>
<div class="alerta aviso">No hay trámites con esos filtros.</div>
<?php endif; ?>
<?php render_footer(); ?>
