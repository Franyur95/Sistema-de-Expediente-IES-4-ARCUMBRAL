<?php
require_once __DIR__ . '/includes/auth.php';
require_once __DIR__ . '/includes/estudiantes.php';

$usuario = require_login();

$q = is_string($_GET['q'] ?? null) ? mb_substr(trim($_GET['q']), 0, 50) : '';
$pagina = (isset($_GET['pagina']) && is_string($_GET['pagina']) && ctype_digit($_GET['pagina']) && (int)$_GET['pagina'] >= 1)
    ? min((int)$_GET['pagina'], 100000) : 1;

$where = [];
$params = [];
if ($q !== '') {
    $like = '%' . str_replace(['\\', '%', '_'], ['\\\\', '\\%', '\\_'], $q) . '%';
    $where[] = '(e.apellido LIKE :q1 OR e.dni LIKE :q2)';
    $params[':q1'] = $like;
    $params[':q2'] = $like;
}
$sqlWhere = $where ? ' WHERE ' . implode(' AND ', $where) : '';

$st = db()->prepare('SELECT COUNT(*) FROM estudiante e' . $sqlWhere);
$st->execute($params);
$total = (int)$st->fetchColumn();
$paginas = max(1, (int)ceil($total / POR_PAGINA));
$pagina = min($pagina, $paginas);

$st = db()->prepare(
    'SELECT e.id_estudiante, e.id_carrera, e.dni, e.apellido, e.nombre, e.anio_ingreso, e.estado, c.nombre AS carrera, c.turno
     FROM estudiante e JOIN carrera c ON c.id_carrera = e.id_carrera' . $sqlWhere . '
     ORDER BY e.apellido, e.nombre LIMIT :lim OFFSET :off'
);
foreach ($params as $k => $v) {
    $st->bindValue($k, $v, is_int($v) ? PDO::PARAM_INT : PDO::PARAM_STR);
}
$st->bindValue(':lim', POR_PAGINA, PDO::PARAM_INT);
$st->bindValue(':off', ($pagina - 1) * POR_PAGINA, PDO::PARAM_INT);
$st->execute();
$filas = $st->fetchAll();

function url_pagina(string $q, int $p): string
{
    return 'buscar.php?' . http_build_query(['q' => $q, 'pagina' => $p]);
}

render_header('Buscar alumnos', $usuario);
?>
<section class="tarjeta">
  <form method="get" action="buscar.php" class="form-busqueda">
    <div class="campo">
      <label for="q">Apellido o DNI</label>
      <input type="search" id="q" name="q" value="<?= e($q) ?>" maxlength="50" autofocus>
    </div>
    <button type="submit" class="btn">Buscar</button>
    <?php if ($q !== ''): ?><a class="btn btn-sec" href="buscar.php">Ver todos</a><?php endif; ?>
  </form>
</section>

<p><?= $total ?> resultado<?= $total === 1 ? '' : 's' ?><?= $q !== '' ? ' para «' . e($q) . '»' : '' ?>.</p>

<?php if ($filas): ?>
<div class="tabla-wrap">
  <table class="tabla">
    <thead><tr><th>Apellido y nombre</th><th>DNI</th><th>Carrera</th><th>Año ingreso</th><th>Estado</th><th>Acciones</th></tr></thead>
    <tbody>
<?php foreach ($filas as $f): ?>
      <tr>
        <td><?= e($f['apellido']) ?>, <?= e($f['nombre']) ?></td>
        <td><?= e($f['dni']) ?></td>
        <td><?= e($f['carrera']) ?> (<?= e($f['turno']) ?>)</td>
        <td><?= (int)$f['anio_ingreso'] ?></td>
        <td><?= e($f['estado']) ?></td>
        <td class="acciones">
          <a href="ver.php?id=<?= (int)$f['id_estudiante'] ?>">Ver</a>
<?php if (puede_editar($usuario) && carrera_permitida($usuario, (int)$f['id_carrera'])): ?>
          <a href="editar.php?id=<?= (int)$f['id_estudiante'] ?>">Modificar</a>
<?php endif; ?>
        </td>
      </tr>
<?php endforeach; ?>
    </tbody>
  </table>
</div>

<?php if ($paginas > 1): ?>
<nav class="paginacion" aria-label="Paginación">
<?php if ($pagina > 1): ?><a href="<?= e(url_pagina($q, $pagina - 1)) ?>">« Anterior</a><?php endif; ?>
  <span>Página <?= $pagina ?> de <?= $paginas ?></span>
<?php if ($pagina < $paginas): ?><a href="<?= e(url_pagina($q, $pagina + 1)) ?>">Siguiente »</a><?php endif; ?>
</nav>
<?php endif; ?>
<?php else: ?>
<div class="alerta aviso">No se encontraron alumnos<?= $q !== '' ? ' con ese apellido o DNI' : '' ?>.</div>
<?php endif; ?>
<?php render_footer(); ?>
