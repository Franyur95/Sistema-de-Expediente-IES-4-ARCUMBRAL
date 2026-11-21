<?php
require_once __DIR__ . '/includes/auth.php';
require_once __DIR__ . '/includes/semaforo.php';

$usuario = require_login();
exigir_permiso($usuario, 'alertas.ver');

const TIPOS_ALERTA = [
    'vencidos'   => 'Documentos vencidos',
    'por_vencer' => 'Documentos por vencer',
    'faltan'     => 'Documentos que faltan',
    'tramites'   => 'Trámites vencidos o por vencer',
];
const ESTADO_DOC = ['vencidos' => 'vencido', 'por_vencer' => 'por_vencer', 'faltan' => 'falta'];

$tipo = (is_string($_GET['tipo'] ?? null) && isset(TIPOS_ALERTA[$_GET['tipo']])) ? $_GET['tipo'] : 'vencidos';
$pagina = pagina_desde_get();

function alr_url(string $tipo, int $pagina = 1): string
{
    return 'alertas.php?' . http_build_query(['tipo' => $tipo, 'pagina' => $pagina]);
}

$conteo = array_fill_keys(array_keys(TIPOS_ALERTA), 0);
$errores = [];
$filas = [];
$paginas = 1;

// Conteos de documentación.
try {
    $st = db()->query("SELECT estado, COUNT(*) AS n FROM v_documentacion_estado WHERE estado <> 'vigente' GROUP BY estado");
    foreach ($st->fetchAll(PDO::FETCH_ASSOC) as $r) {
        $clave = array_search($r['estado'], ESTADO_DOC, true);
        if ($clave !== false) {
            $conteo[$clave] = (int)$r['n'];
        }
    }
} catch (Throwable $ex) {
    error_log('Alertas de documentación: ' . $ex->getMessage());
    $errores[] = 'No se pudieron consultar las alertas de documentación (vista v_documentacion_estado).';
}

// Conteo de trámites.
try {
    $conteo['tramites'] = (int)db()->query("SELECT COUNT(*) FROM v_tramites_pendientes WHERE situacion IN ('vencido','por_vencer')")->fetchColumn();
} catch (Throwable $ex) {
    error_log('Alertas de trámites: ' . $ex->getMessage());
    $errores[] = 'No se pudieron consultar los trámites (vista v_tramites_pendientes).';
}

$total = $conteo[$tipo];
$paginas = max(1, (int)ceil($total / POR_PAGINA));
$pagina = min($pagina, $paginas);

try {
    if ($tipo === 'tramites') {
        $st = db()->prepare(
            "SELECT id_estudiante, apellido, nombre, dni, tipo, fecha_limite, dias_restantes, situacion
             FROM v_tramites_pendientes
             WHERE situacion IN ('vencido','por_vencer')
             ORDER BY fecha_limite, apellido, nombre
             LIMIT :lim OFFSET :off"
        );
    } else {
        $st = db()->prepare(
            'SELECT d.id_estudiante, d.apellido, d.nombre, d.dni, d.documento, d.vence_el, c.nombre AS carrera, c.turno
             FROM v_documentacion_estado d
             JOIN carreras c ON c.id_carrera = d.id_carrera
             WHERE d.estado = :estado
             ORDER BY d.apellido, d.nombre, d.documento
             LIMIT :lim OFFSET :off'
        );
        $st->bindValue(':estado', ESTADO_DOC[$tipo], PDO::PARAM_STR);
    }
    $st->bindValue(':lim', POR_PAGINA, PDO::PARAM_INT);
    $st->bindValue(':off', ($pagina - 1) * POR_PAGINA, PDO::PARAM_INT);
    $st->execute();
    $filas = $st->fetchAll(PDO::FETCH_ASSOC);
} catch (Throwable $ex) {
    error_log('Listado de alertas: ' . $ex->getMessage());
    $errores[] = 'No se pudo cargar el listado de alertas.';
}

render_header('Alertas', $usuario);
?>
<p class="nota">Avisos sobre alumnos activos. El apto físico y el seguro vencen el 31 de diciembre; se marcan «por vencer» 30 días antes.</p>

<?php foreach ($errores as $m): ?>
<div class="alerta error" role="alert"><?= e($m) ?></div>
<?php endforeach; ?>

<div class="resumen-semaforo">
<?php foreach (TIPOS_ALERTA as $clave => $etq): ?>
  <a class="resumen-item<?= $tipo === $clave ? ' activo' : '' ?>" href="<?= e(alr_url($clave)) ?>">
    <?= e($etq) ?> <strong><?= (int)$conteo[$clave] ?></strong>
  </a>
<?php endforeach; ?>
</div>

<?php if ($filas): ?>
<div class="tabla-wrap">
  <table class="tabla">
<?php if ($tipo === 'tramites'): ?>
    <thead><tr><th>Apellido y nombre</th><th>DNI</th><th>Trámite</th><th>Fecha límite</th><th>Situación</th><th>Acciones</th></tr></thead>
    <tbody>
<?php foreach ($filas as $f): ?>
      <tr>
        <td><?= e($f['apellido']) ?>, <?= e($f['nombre']) ?></td>
        <td><?= e($f['dni']) ?></td>
        <td><?= e(ucfirst(str_replace('_', ' ', (string)$f['tipo']))) ?></td>
        <td><?= e(fecha_ar($f['fecha_limite'])) ?></td>
        <td><?= $f['situacion'] === 'vencido' ? '<span class="pendiente">Vencido</span>' : 'Vence en ' . (int)$f['dias_restantes'] . ' día(s)' ?></td>
        <td class="acciones"><a href="tramites_alumno.php?id=<?= (int)$f['id_estudiante'] ?>">Abrir trámites</a></td>
      </tr>
<?php endforeach; ?>
<?php else: ?>
    <thead><tr><th>Apellido y nombre</th><th>DNI</th><th>Carrera</th><th>Documento</th><th>Vence</th><th>Acciones</th></tr></thead>
    <tbody>
<?php foreach ($filas as $f): ?>
      <tr>
        <td><?= e($f['apellido']) ?>, <?= e($f['nombre']) ?></td>
        <td><?= e($f['dni']) ?></td>
        <td><?= e($f['carrera']) ?> (<?= e($f['turno']) ?>)</td>
        <td><?= e($f['documento']) ?></td>
        <td><?= $f['vence_el'] ? e(fecha_ar($f['vence_el'])) : '—' ?></td>
        <td class="acciones"><a href="ver.php?id=<?= (int)$f['id_estudiante'] ?>">Ver</a></td>
      </tr>
<?php endforeach; ?>
<?php endif; ?>
    </tbody>
  </table>
</div>

<?php if ($paginas > 1): ?>
<nav class="paginacion" aria-label="Paginación">
<?php if ($pagina > 1): ?><a href="<?= e(alr_url($tipo, $pagina - 1)) ?>">« Anterior</a><?php endif; ?>
  <span>Página <?= $pagina ?> de <?= $paginas ?></span>
<?php if ($pagina < $paginas): ?><a href="<?= e(alr_url($tipo, $pagina + 1)) ?>">Siguiente »</a><?php endif; ?>
</nav>
<?php endif; ?>
<?php elseif (!$errores): ?>
<div class="alerta ok">No hay alertas de este tipo.</div>
<?php endif; ?>
<?php render_footer(); ?>
