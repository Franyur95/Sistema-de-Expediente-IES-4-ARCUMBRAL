<?php
require_once __DIR__ . '/includes/auth.php';

require_once __DIR__ . '/includes/estudiantes.php';
require_once __DIR__ . '/includes/academico.php';

$usuario = require_login();
exigir_permiso($usuario, 'expedientes.ver');

$id = id_desde_get();
$a = $id > 0 ? obtener_estudiante($id) : null;
if (!$a) {
    pagina_error(404, 'Expediente no encontrado', 'El expediente solicitado no existe.', $usuario);
}
// La consulta es libre entre turnos; la modificación se restringe más abajo.
$puedeModificar = puede_editar($usuario) && carrera_permitida($usuario, (int)$a['id_carrera']);
$puedeVerAcademico = puede_ver_academico($usuario);

$tipos = cargar_tipos();
$docs  = docs_desde_db($tipos, $id);

function dato(string $etiqueta, ?string $valor): void
{
    $v = ($valor === null || $valor === '') ? '—' : $valor;
    echo '<div class="dato"><dt>' . e($etiqueta) . '</dt><dd>' . nl2br(e($v)) . '</dd></div>';
}

render_header('Expediente: ' . $a['apellido'] . ', ' . $a['nombre'], $usuario);
?>
<div class="botones botones-arriba">
<?php if ($puedeModificar): ?>
  <a class="btn" href="editar.php?id=<?= (int)$a['id_estudiante'] ?>">Modificar datos</a>
<?php endif; ?>
<?php if ($puedeVerAcademico && carrera_permitida($usuario, (int)$a['id_carrera'])): ?>
  <a class="btn" href="academico.php?id=<?= (int)$a['id_estudiante'] ?>"><?= puede_editar_academico($usuario) ? 'Gestionar situación académica' : 'Ver situación académica' ?></a>
<?php endif; ?>
  <a class="btn btn-sec" href="buscar.php">Volver a la búsqueda</a>
</div>

<section class="tarjeta">
  <h2>Datos personales</h2>
  <dl class="datos">
    <?php dato('Apellidos', $a['apellido']); ?>
    <?php dato('Nombres', $a['nombre']); ?>
    <?php dato('L.E. / L.C. / D.N.I. N.º', $a['dni']); ?>
    <?php dato('Fecha de nacimiento', fecha_ar($a['fecha_nacimiento'])); ?>
    <?php dato('Nació en', $a['lugar_nacimiento']); ?>
    <?php dato('Teléfono', $a['telefono']); ?>
    <?php dato('Domicilio', $a['domicilio']); ?>
  </dl>
</section>

<section class="tarjeta">
  <h2>Ingreso y carrera</h2>
  <dl class="datos">
    <?php dato('Profesorado', $a['carrera'] . ' (turno ' . $a['turno'] . ')'); ?>
    <?php dato('Decreto - Resolución', $a['resolucion']); ?>
    <?php dato('Título con el que ingresó', $a['titulo_ingreso']); ?>
    <?php dato('Establecimiento que lo otorga', $a['establecimiento']); ?>
    <?php dato('Año de ingreso', (string)$a['anio_ingreso']); ?>
    <?php dato('Estado', $a['estado']); ?>
    <?php dato('Expediente creado el', fecha_ar($a['creado_en'])); ?>
    <?php dato('Observaciones', $a['observaciones']); ?>
  </dl>
</section>

<?php if ($puedeVerAcademico): ?>
<section class="tarjeta">
  <h2>Nuevos registros de inscripción para cursar y recursar</h2>
  <?php render_inscripciones(listar_inscripciones($id)); ?>
</section>

<section class="tarjeta">
  <h2>Situación académica</h2>
  <?php render_situacion_academica(situacion_academica($id, (int)$a['id_carrera'])); ?>
</section>
<?php endif; ?>

<section class="tarjeta">
  <h2>Documentación</h2>
<?php if ($tipos): ?>
  <div class="tabla-wrap">
    <table class="tabla">
      <thead><tr><th>Documento</th><th>Presentado</th><th>Fecha</th><th>Observaciones</th></tr></thead>
      <tbody>
<?php $faltan = 0; foreach ($tipos as $t): $x = $docs[(int)$t['id_tipo']];
        if (!$x['presentado'] && $t['obligatorio']) { $faltan++; } ?>
        <tr>
          <td><?= e($t['nombre']) ?><?= $t['obligatorio'] ? ' <span class="badge">Obligatorio</span>' : '' ?></td>
          <td><?= $x['presentado'] ? 'Sí' : '<span class="pendiente">No</span>' ?></td>
          <td><?= $x['presentado'] ? e(fecha_ar($x['fecha'])) : '—' ?></td>
          <td><?= e($x['obs'] !== '' ? $x['obs'] : '—') ?></td>
        </tr>
<?php endforeach; ?>
      </tbody>
    </table>
  </div>
  <p><?= $faltan > 0 ? '<strong>Documentos obligatorios pendientes: ' . $faltan . '.</strong>' : 'Toda la documentación obligatoria fue presentada.' ?></p>
<?php else: ?>
  <p>No hay tipos de documentación configurados.</p>
<?php endif; ?>
</section>
<?php render_footer(); ?>
