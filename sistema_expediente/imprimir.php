<?php
require_once __DIR__ . '/includes/auth.php';
require_once __DIR__ . '/includes/estudiantes.php';
require_once __DIR__ . '/includes/academico.php';
require_once __DIR__ . '/includes/reportes.php';

$usuario = require_login();
exigir_permiso($usuario, 'expedientes.ver');

$ids = reporte_ids_desde_get();
$alumnos = [];

foreach ($ids as $id) {
    $alumno = obtener_estudiante($id);

    if (!$alumno) {
        continue;
    }

    // Los reportes respetan la carrera asignada al usuario.
    if (!carrera_permitida($usuario, (int)$alumno['id_carrera'])) {
        continue;
    }

    $alumnos[] = $alumno;
}

if (!$alumnos) {
    pagina_error(
        404,
        'Sin alumnos para imprimir',
        'No se encontraron expedientes para los alumnos solicitados o su usuario no tiene acceso a esa carrera.',
        $usuario
    );
}

$puedeVerAcademico = puede_ver_academico($usuario);
$tipos = cargar_tipos();
$fechaEmision = date('d/m/Y H:i');

$valor = static function ($v): string {
    return ($v === null || $v === '') ? '—' : (string)$v;
};

$anio = static function ($v): string {
    return ($v === null || $v === '') ? '—' : (string)(int)$v;
};
?>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Planilla de expediente - <?= e(APP_SIGLA) ?></title>
<link rel="stylesheet" href="css/estilos.css">
<link rel="stylesheet" href="css/imprimir.css">
</head>
<body class="cuerpo-impresion">

<div class="barra-acciones no-imprimir">
  <a class="btn btn-sec" href="<?= e(reporte_url_filtros('reportes.php', reporte_filtros($usuario))) ?>">
    Volver a reportes
  </a>
  <button type="button" class="btn" data-imprimir>Imprimir / Guardar como PDF</button>
  <span class="ayuda-impresion">
    En el diálogo de impresión elija <strong>Guardar como PDF</strong>
    y orientación <strong>Horizontal</strong>.
  </span>
</div>

<?php foreach ($alumnos as $alumno): ?>
  <?php
  $id = (int)$alumno['id_estudiante'];
  $docs = docs_desde_db($tipos, $id);
  $inscripciones = listar_inscripciones_curso($id);
  $examenes = $puedeVerAcademico ? listar_examenes($id) : [];
  $situacion = $puedeVerAcademico
      ? situacion_academica($id, (int)$alumno['id_carrera'])
      : null;

  $faltan = 0;
  foreach ($tipos as $tipo) {
      $doc = $docs[(int)$tipo['id_tipo']] ?? ['presentado' => false];

      if (!$doc['presentado'] && $tipo['obligatorio']) {
          $faltan++;
      }
  }
  ?>

  <article class="hoja">
    <header class="hoja-cabecera">
      <div class="institucion">
        <?= e(APP_NOMBRE) ?>
        <small>Sistema de Expedientes de Alumnos · <?= e(APP_SIGLA) ?></small>
      </div>
      <div class="documento">
        <strong>PLANILLA DE EXPEDIENTE</strong>
        <span>Emitida el <?= e($fechaEmision) ?></span>
      </div>
    </header>

    <h2><?= e($alumno['apellido']) ?>, <?= e($alumno['nombre']) ?></h2>
    <p class="subtitulo">
      DNI <?= e($alumno['dni']) ?>
      · <?= e($alumno['carrera']) ?> (turno <?= e($alumno['turno']) ?>)
      · Estado: <?= e(ucfirst($alumno['estado'])) ?>
    </p>

    <h3>Datos personales y de ingreso</h3>

    <table class="tabla-datos">
      <tbody>
        <tr>
          <th>Apellidos</th>
          <td><?= e($alumno['apellido']) ?></td>
          <th>Nombres</th>
          <td><?= e($alumno['nombre']) ?></td>
        </tr>
        <tr>
          <th>DNI</th>
          <td><?= e($alumno['dni']) ?></td>
          <th>Fecha de nacimiento</th>
          <td><?= e(fecha_ar($alumno['fecha_nacimiento'])) ?></td>
        </tr>
        <tr>
          <th>Lugar de nacimiento</th>
          <td><?= e($valor($alumno['lugar_nacimiento'])) ?></td>
          <th>Teléfono</th>
          <td><?= e($valor($alumno['telefono'])) ?></td>
        </tr>
        <tr>
          <th>Domicilio</th>
          <td colspan="3"><?= e($valor($alumno['domicilio'])) ?></td>
        </tr>
        <tr>
          <th>Profesorado</th>
          <td><?= e($alumno['carrera']) ?></td>
          <th>Turno</th>
          <td><?= e($alumno['turno']) ?></td>
        </tr>
        <tr>
          <th>Decreto / Resolución</th>
          <td><?= e($valor($alumno['resolucion'])) ?></td>
          <th>Año de ingreso</th>
          <td><?= e($anio($alumno['anio_ingreso'])) ?></td>
        </tr>
        <tr>
          <th>Título de ingreso</th>
          <td><?= e($valor($alumno['titulo_ingreso'])) ?></td>
          <th>Establecimiento</th>
          <td><?= e($valor($alumno['establecimiento'])) ?></td>
        </tr>
        <tr>
          <th>Estado</th>
          <td><?= e(ucfirst($alumno['estado'])) ?></td>
          <th>Expediente creado</th>
          <td><?= e(fecha_ar($alumno['creado_en'])) ?></td>
        </tr>
        <tr>
          <th>Observaciones</th>
          <td colspan="3">
            <?= nl2br(e($valor($alumno['observaciones']))) ?>
          </td>
        </tr>
      </tbody>
    </table>

    <h3>Documentación</h3>

    <?php if ($tipos): ?>
      <table>
        <thead>
          <tr>
            <th>Documento</th>
            <th class="centro">Obligatorio</th>
            <th class="centro">Presentado</th>
            <th class="centro">Fecha</th>
            <th>Observaciones</th>
          </tr>
        </thead>
        <tbody>
          <?php foreach ($tipos as $tipo): ?>
            <?php
            $doc = $docs[(int)$tipo['id_tipo']] ?? [
                'presentado' => false,
                'fecha' => '',
                'obs' => '',
            ];
            ?>
            <tr>
              <td><?= e($tipo['nombre']) ?></td>
              <td class="centro"><?= $tipo['obligatorio'] ? 'Sí' : 'No' ?></td>
              <td class="centro"><?= $doc['presentado'] ? 'Sí' : 'No' ?></td>
              <td class="centro">
                <?= $doc['presentado'] ? e(fecha_ar($doc['fecha'])) : '—' ?>
              </td>
              <td><?= e($valor($doc['obs'])) ?></td>
            </tr>
          <?php endforeach; ?>
        </tbody>
      </table>

      <p class="nota-pie">
        <?= $faltan > 0
            ? 'Documentos obligatorios pendientes: ' . $faltan . '.'
            : 'Documentación obligatoria completa.' ?>
      </p>
    <?php else: ?>
      <p>No hay tipos de documentación configurados.</p>
    <?php endif; ?>

    <h3>Inscripciones al curso</h3>

    <?php if ($inscripciones): ?>
      <table>
        <thead>
          <tr>
            <th class="centro">Fecha</th>
            <th class="centro">Curso</th>
            <th class="centro">Condición</th>
            <th>Observaciones</th>
          </tr>
        </thead>
        <tbody>
          <?php foreach ($inscripciones as $inscripcion): ?>
            <tr>
              <td class="centro"><?= e(fecha_ar($inscripcion['fecha_inscripcion'])) ?></td>
              <td class="centro"><?= (int)$inscripcion['curso'] ?>° año</td>
              <td class="centro"><?= e(ucfirst($inscripcion['condicion'])) ?></td>
              <td><?= e($valor($inscripcion['observaciones'])) ?></td>
            </tr>
          <?php endforeach; ?>
        </tbody>
      </table>
    <?php else: ?>
      <p>Sin registros de inscripción al curso.</p>
    <?php endif; ?>

    <?php if ($puedeVerAcademico && $situacion !== null): ?>
      <h3>Situación académica</h3>

      <?php render_situacion_academica($situacion); ?>

      <h3>Exámenes finales</h3>

      <?php if ($examenes): ?>
        <table>
          <thead>
            <tr>
              <th>Espacio curricular</th>
              <th class="centro">Tipo</th>
              <th class="centro">Fecha</th>
              <th class="centro">Calificación</th>
              <th class="centro">Libro</th>
              <th class="centro">Folio</th>
              <th>Observación</th>
            </tr>
          </thead>
          <tbody>
            <?php foreach ($examenes as $examen): ?>
              <?php
              $espacio = $examen['materia'];

              if (!empty($examen['submateria'])) {
                  $espacio .= ' - ' . $examen['submateria'];
              }
              ?>
              <tr>
                <td><?= e($espacio) ?></td>
                <td class="centro"><?= e($examen['tipo'] ?? '') ?></td>
                <td class="centro"><?= e(fecha_ar($examen['fecha'])) ?></td>
                <td class="centro"><?= e(nota_fmt($examen['nota'])) ?></td>
                <td class="centro"><?= e($valor($examen['libro'])) ?></td>
                <td class="centro"><?= e($valor($examen['folio'])) ?></td>
                <td><?= e($valor($examen['observacion'])) ?></td>
              </tr>
            <?php endforeach; ?>
          </tbody>
        </table>
      <?php else: ?>
        <p>Sin exámenes registrados.</p>
      <?php endif; ?>
    <?php elseif (!$puedeVerAcademico): ?>
      <p class="nota-pie">
        La situación académica no se incluye porque su usuario no tiene permiso para consultar notas.
      </p>
    <?php endif; ?>

    <div class="firmas">
      <div class="firma"><div class="linea">Firma del alumno</div></div>
      <div class="firma"><div class="linea">Aclaración</div></div>
      <div class="firma"><div class="linea">Firma y sello de la autoridad</div></div>
    </div>

    <footer class="hoja-pie">
      Generado por <?= e($usuario['nombre']) ?> (<?= e($usuario['rol']) ?>)
      · <?= e($fechaEmision) ?> · <?= e(APP_SIGLA) ?>
    </footer>
  </article>
<?php endforeach; ?>

<script src="js/reportes.js"></script>
</body>
</html>
