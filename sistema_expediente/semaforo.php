<?php
require_once __DIR__ . '/includes/auth.php';
require_once __DIR__ . '/includes/semaforo.php';

$usuario = require_login();
exigir_permiso($usuario, 'semaforo.ver');

$colores   = ['rojo', 'amarillo', 'verde'];
$color     = (is_string($_GET['color'] ?? null) && in_array($_GET['color'], $colores, true)) ? $_GET['color'] : '';
$idCarrera = (isset($_GET['carrera']) && is_string($_GET['carrera']) && ctype_digit($_GET['carrera'])) ? (int)$_GET['carrera'] : 0;
$q         = is_string($_GET['q'] ?? null) ? mb_substr(trim($_GET['q']), 0, 50) : '';
$pagina    = pagina_desde_get();

function sem_url(array $p): string
{
    $p = array_filter($p, static fn($v) => $v !== '' && $v !== 0 && $v !== null);
    return 'semaforo.php' . ($p ? '?' . http_build_query($p) : '');
}

$error    = '';
$carreras = [];
$resumen  = ['rojo' => 0, 'amarillo' => 0, 'verde' => 0];
$filas    = [];
$total    = 0;
$paginas  = 1;

try {
    $carreras = db()->query('SELECT id_carrera, nombre, turno FROM carreras ORDER BY nombre, turno')->fetchAll(PDO::FETCH_ASSOC);

    $where  = [];
    $params = [];
    if ($idCarrera > 0) {
        $where[] = 's.id_carrera = :carrera';
        $params[':carrera'] = $idCarrera;
    }
    if ($q !== '') {
        $like = '%' . str_replace(['\\', '%', '_'], ['\\\\', '\\%', '\\_'], $q) . '%';
        $where[] = '(s.apellido LIKE :q1 OR s.dni LIKE :q2)';
        $params[':q1'] = $like;
        $params[':q2'] = $like;
    }
    $sqlBase = $where ? ' WHERE ' . implode(' AND ', $where) : '';

    $st = db()->prepare('SELECT s.semaforo, COUNT(*) AS n FROM v_semaforo_documentacion s' . $sqlBase . ' GROUP BY s.semaforo');
    $st->execute($params);
    foreach ($st->fetchAll(PDO::FETCH_ASSOC) as $r) {
        if (isset($resumen[$r['semaforo']])) {
            $resumen[$r['semaforo']] = (int)$r['n'];
        }
    }

    $whereLista  = $where;
    $paramsLista = $params;
    if ($color !== '') {
        $whereLista[] = 's.semaforo = :color';
        $paramsLista[':color'] = $color;
    }
    $sqlLista = $whereLista ? ' WHERE ' . implode(' AND ', $whereLista) : '';

    $st = db()->prepare('SELECT COUNT(*) FROM v_semaforo_documentacion s' . $sqlLista);
    $st->execute($paramsLista);
    $total   = (int)$st->fetchColumn();
    $paginas = max(1, (int)ceil($total / POR_PAGINA));
    $pagina  = min($pagina, $paginas);

    $st = db()->prepare(
        'SELECT s.id_estudiante, s.apellido, s.nombre, s.dni, s.faltan, s.vencidos, s.por_vencer, s.semaforo,
                c.nombre AS carrera, c.turno
         FROM v_semaforo_documentacion s
         JOIN carreras c ON c.id_carrera = s.id_carrera' . $sqlLista . '
         ORDER BY FIELD(s.semaforo, \'rojo\', \'amarillo\', \'verde\'), s.apellido, s.nombre
         LIMIT :lim OFFSET :off'
    );
    foreach ($paramsLista as $k => $v) {
        $st->bindValue($k, $v, is_int($v) ? PDO::PARAM_INT : PDO::PARAM_STR);
    }
    $st->bindValue(':lim', POR_PAGINA, PDO::PARAM_INT);
    $st->bindValue(':off', ($pagina - 1) * POR_PAGINA, PDO::PARAM_INT);
    $st->execute();
    $filas = $st->fetchAll(PDO::FETCH_ASSOC);
} catch (Throwable $ex) {
    error_log('Error en el semáforo de documentación: ' . $ex->getMessage());
    $error = 'No se pudo consultar el semáforo. Verifique que la vista v_semaforo_documentacion exista en la base.';
}

render_header('Semáforo de documentación', $usuario);
?>
<p class="nota">Estado de la documentación obligatoria de los alumnos activos. <strong>Rojo:</strong> falta o venció algún documento.
<strong>Amarillo:</strong> algún documento está por vencer. <strong>Verde:</strong> todo vigente.</p>

<?php if ($error !== ''): ?>
<div class="alerta error" role="alert"><?= e($error) ?></div>
<?php else: ?>

<section class="tarjeta">
  <form method="get" action="semaforo.php" class="form-busqueda">
    <div class="campo">
      <label for="q">Apellido o DNI</label>
      <input type="search" id="q" name="q" value="<?= e($q) ?>" maxlength="50">
    </div>
    <div class="campo">
      <label for="carrera">Carrera</label>
      <select id="carrera" name="carrera">
        <option value="">Todas</option>
<?php foreach ($carreras as $c): ?>
        <option value="<?= (int)$c['id_carrera'] ?>"<?= (int)$c['id_carrera'] === $idCarrera ? ' selected' : '' ?>><?= e($c['nombre']) ?> (<?= e($c['turno']) ?>)</option>
<?php endforeach; ?>
      </select>
    </div>
    <input type="hidden" name="color" value="<?= e($color) ?>">
    <button type="submit" class="btn">Filtrar</button>
    <a class="btn btn-sec" href="semaforo.php">Limpiar</a>
  </form>
</section>

<div class="resumen-semaforo">
<?php foreach ($colores as $c): ?>
  <a class="resumen-item<?= $color === $c ? ' activo' : '' ?>" href="<?= e(sem_url(['q' => $q, 'carrera' => $idCarrera, 'color' => $color === $c ? '' : $c])) ?>">
    <?= semaforo_insignia($c) ?> <strong><?= (int)$resumen[$c] ?></strong>
  </a>
<?php endforeach; ?>
</div>

<p><?= $total ?> alumno<?= $total === 1 ? '' : 's' ?><?= $color !== '' ? ' en ' . e(SEMAFORO_ETIQUETAS[$color]) : '' ?>.</p>

<?php if ($filas): ?>
<div class="tabla-wrap">
  <table class="tabla">
    <thead><tr><th>Estado</th><th>Apellido y nombre</th><th>DNI</th><th>Carrera</th><th>Detalle</th><th>Acciones</th></tr></thead>
    <tbody>
<?php foreach ($filas as $f): ?>
      <tr>
        <td><?= semaforo_insignia((string)$f['semaforo']) ?></td>
        <td><?= e($f['apellido']) ?>, <?= e($f['nombre']) ?></td>
        <td><?= e($f['dni']) ?></td>
        <td><?= e($f['carrera']) ?> (<?= e($f['turno']) ?>)</td>
        <td><?= e(semaforo_detalle($f)) ?></td>
        <td class="acciones"><a href="ver.php?id=<?= (int)$f['id_estudiante'] ?>">Ver</a></td>
      </tr>
<?php endforeach; ?>
    </tbody>
  </table>
</div>

<?php if ($paginas > 1): ?>
<nav class="paginacion" aria-label="Paginación">
<?php if ($pagina > 1): ?><a href="<?= e(sem_url(['q' => $q, 'carrera' => $idCarrera, 'color' => $color, 'pagina' => $pagina - 1])) ?>">« Anterior</a><?php endif; ?>
  <span>Página <?= $pagina ?> de <?= $paginas ?></span>
<?php if ($pagina < $paginas): ?><a href="<?= e(sem_url(['q' => $q, 'carrera' => $idCarrera, 'color' => $color, 'pagina' => $pagina + 1])) ?>">Siguiente »</a><?php endif; ?>
</nav>
<?php endif; ?>
<?php else: ?>
<div class="alerta aviso">No hay alumnos con esos filtros.</div>
<?php endif; ?>
<?php endif; ?>
<?php render_footer(); ?>
