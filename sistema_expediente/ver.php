<?php
require_once __DIR__ . '/includes/auth.php';

require_once __DIR__ . '/includes/estudiantes.php';
require_once __DIR__ . '/includes/academico.php';
require_once __DIR__ . '/includes/semaforo.php';
require_once __DIR__ . '/includes/tramites.php';

$usuario = require_login();
exigir_permiso($usuario, 'expedientes.ver');

$id = id_desde_get();
$a = $id > 0 ? obtener_estudiante($id) : null;

if (!$a) {
    pagina_error(
        404,
        'Expediente no encontrado',
        'El expediente solicitado no existe.',
        $usuario
    );
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
    <a class="btn" href="editar.php?id=<?= (int)$a['id_estudiante'] ?>">
        Modificar datos
    </a>
<?php endif; ?>

<?php if ($puedeVerAcademico): ?>
    <a class="btn" href="academico.php?id=<?= (int)$a['id_estudiante'] ?>">
        Generar situación académica
    </a>
<?php endif; ?>

<?php if (tiene_permiso($usuario, 'tramites.ver')): ?>
    <a class="btn" href="tramites_alumno.php?id=<?= (int)$a['id_estudiante'] ?>">
        Trámites
    </a>
<?php endif; ?>

    <a class="btn btn-sec" href="imprimir.php?id=<?= (int)$a['id_estudiante'] ?>" target="_blank" rel="noopener">
        Imprimir planilla
    </a>

    <a class="btn btn-sec" href="buscar.php">
        Volver a la búsqueda
    </a>

</div>
 <p class="anio-cursa">
  <strong>Año que cursa:</strong> <?= e(anio_que_cursa((int)$a['anio_ingreso'], $a['estado'])) ?>
  · <strong>Ingreso:</strong> <?= (int)$a['anio_ingreso'] ?>
  · <strong>DNI:</strong> <?= e($a['dni']) ?>
</p> 

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
        <?php dato('Año que cursa', anio_que_cursa((int)$a['anio_ingreso'], $a['estado'])); ?>
        <?php dato('Estado', $a['estado']); ?>
        <?php dato('Expediente creado el', fecha_ar($a['creado_en'])); ?>
        <?php dato('Observaciones', $a['observaciones']); ?>
    </dl>
</section>

<?php if ($puedeVerAcademico): ?>

<section class="tarjeta">
    <h2>Inscripciones al curso</h2>

    <?php render_inscripciones_curso(listar_inscripciones_curso($id)); ?>
</section>

<section class="tarjeta">
    <h2>Situación académica</h2>

    <?php render_situacion_academica(
        situacion_academica($id, (int)$a['id_carrera'])
    ); ?>
</section>

<?php endif; ?>

<?php if (tiene_permiso($usuario, 'tramites.ver')): ?>
<section class="tarjeta">
    <h2>Trámites</h2>
    <?php $trams = listar_tramites_estudiante($id); if ($trams): ?>
    <div class="tabla-wrap">
        <table class="tabla">
            <thead><tr><th>Trámite</th><th>Solicitado</th><th>Estado</th><th>Plazo</th><th>Resolución</th></tr></thead>
            <tbody>
            <?php foreach ($trams as $tr): ?>
                <tr>
                    <td><?= e(tramite_tipo_etq($tr['tipo'])) ?></td>
                    <td><?= e(fecha_ar($tr['fecha_solicitud'])) ?></td>
                    <td><?= e(tramite_estado_etq($tr['estado'])) ?></td>
                    <td><?= tramite_plazo_html($tr) ?></td>
                    <td><?= $tr['nro_resolucion'] ? e($tr['nro_resolucion']) . ' (' . e(fecha_ar($tr['fecha_resolucion'])) . ')' : '—' ?></td>
                </tr>
            <?php endforeach; ?>
            </tbody>
        </table>
    </div>
    <?php else: ?>
    <p>Sin trámites registrados.</p>
    <?php endif; ?>
    <p><a href="tramites_alumno.php?id=<?= (int)$a['id_estudiante'] ?>">Gestionar trámites de este alumno</a></p>
</section>
<?php endif; ?>

<section class="tarjeta">
    <h2>Documentación</h2>
    <?php $sem = tiene_permiso($usuario, 'semaforo.ver') ? semaforo_estudiante($id) : null; if ($sem): ?>
        <p class="semaforo-fila">Estado de la documentación: <?= semaforo_insignia((string)$sem['semaforo']) ?> <small><?= e(semaforo_detalle($sem)) ?></small></p>
    <?php endif; ?>

    <?php if ($tipos): ?>

        <div class="tabla-wrap">
            <table class="tabla">
                <thead>
                    <tr>
                        <th>Documento</th>
                        <th>Presentado</th>
                        <th>Fecha</th>
                        <th>Observaciones</th>
                    </tr>
                </thead>

                <tbody>
                    <?php
                    $faltan = 0;

                    foreach ($tipos as $t):
                        $x = $docs[(int)$t['id_tipo']];

                        if (!$x['presentado'] && $t['obligatorio']) {
                            $faltan++;
                        }
                    ?>
                        <tr>
                            <td>
                                <?= e($t['nombre']) ?>
                                <?= $t['obligatorio'] ? ' <span class="badge">Obligatorio</span>' : '' ?>
                            </td>

                            <td>
                                <?= $x['presentado'] ? 'Sí' : '<span class="pendiente">No</span>' ?>
                            </td>

                            <td>
                                <?= $x['presentado'] ? e(fecha_ar($x['fecha'])) : '—' ?>
                            </td>

                            <td>
                                <?= e($x['obs'] !== '' ? $x['obs'] : '—') ?>
                            </td>
                        </tr>

                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>

        <p>
            <?= $faltan > 0
                ? '<strong>Documentos obligatorios pendientes: ' . $faltan . '.</strong>'
                : 'Toda la documentación obligatoria fue presentada.' ?>
        </p>

    <?php else: ?>

        <p>No hay tipos de documentación configurados.</p>

    <?php endif; ?>
</section>

<section class="tarjeta">
  <h2>Historial de cambios</h2>
<?php $hist = historial_estudiante($id); if ($hist): ?>
  <div class="tabla-wrap"><table class="tabla">
    <thead><tr><th>Fecha y hora</th><th>Usuario</th><th>Acción</th><th>Detalle</th></tr></thead>
    <tbody>
<?php foreach ($hist as $h): ?>
      <tr>
        <td><?= e(date('d/m/Y H:i', strtotime($h['fecha']))) ?></td>
        <td><?= e($h['usuario'] ?? '—') ?> (<?= e($h['rol'] ?? '') ?>)</td>
        <td><?= e($h['accion']) ?></td>
        <td><?= e($h['motivo']) ?></td>
      </tr>
<?php endforeach; ?>
    </tbody>
  </table></div>
<?php else: ?>
  <p>Sin movimientos registrados.</p>
<?php endif; ?>
</section>


<?php render_footer(); ?>
