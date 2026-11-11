<?php
require_once __DIR__ . '/includes/auth.php';
require_once __DIR__ . '/includes/estudiantes.php';
require_once __DIR__ . '/includes/reportes.php';

$usuario = require_login();
exigir_permiso($usuario, 'expedientes.ver');

$filtros = reporte_filtros($usuario);
$alumnos = reporte_alumnos($filtros, REPORTE_MAX_ALUMNOS + 1);
$truncado = count($alumnos) > REPORTE_MAX_ALUMNOS;

if ($truncado) {
    array_pop($alumnos);
}

$resumen = reporte_resumen_filtros($filtros);
$fechaEmision = date('d/m/Y H:i');
?>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Listado de alumnos - <?= e(APP_SIGLA) ?></title>
<link rel="stylesheet" href="css/estilos.css">
<link rel="stylesheet" href="css/imprimir.css">
</head>
<body class="cuerpo-impresion">

<div class="barra-acciones no-imprimir">
  <a class="btn btn-sec" href="<?= e(reporte_url_filtros('reportes.php', $filtros)) ?>">
    Volver a reportes
  </a>
  <button type="button" class="btn" data-imprimir>Imprimir / Guardar como PDF</button>
  <span class="ayuda-impresion">
    En el diálogo de impresión elija <strong>Guardar como PDF</strong>
    y orientación <strong>Horizontal</strong>.
  </span>
</div>

<article class="hoja hoja-listado">
  <header class="hoja-cabecera">
    <div class="institucion">
      <?= e(APP_NOMBRE) ?>
      <small>Sistema de Expedientes de Alumnos · <?= e(APP_SIGLA) ?></small>
    </div>
    <div class="documento">
      <strong>LISTADO DE ALUMNOS</strong>
      <span>Emitido el <?= e($fechaEmision) ?></span>
    </div>
  </header>

  <h2>Listado de alumnos</h2>
  <p class="subtitulo">
    <?= e($resumen) ?> · Total: <?= count($alumnos) ?> alumno(s)
  </p>

  <?php if ($truncado): ?>
    <p class="aviso-impresion">
      Se muestran los primeros <?= REPORTE_MAX_ALUMNOS ?> resultados.
      Refine los filtros para imprimir el resto.
    </p>
  <?php endif; ?>

  <?php if ($alumnos): ?>
    <table class="tabla-listado">
      <thead>
        <tr>
          <th class="centro">N.°</th>
          <th>Apellido y nombre</th>
          <th class="centro">DNI</th>
          <th>Carrera</th>
          <th class="centro">Turno</th>
          <th class="centro">Año ingreso</th>
          <th class="centro">Estado</th>
          <th class="centro">Documentación</th>
        </tr>
      </thead>
      <tbody>
        <?php foreach ($alumnos as $indice => $alumno): ?>
          <tr>
            <td class="centro"><?= $indice + 1 ?></td>
            <td><?= e($alumno['apellido']) ?>, <?= e($alumno['nombre']) ?></td>
            <td class="centro"><?= e($alumno['dni']) ?></td>
            <td><?= e($alumno['carrera']) ?></td>
            <td class="centro"><?= e($alumno['turno']) ?></td>
            <td class="centro"><?= (int)$alumno['anio_ingreso'] ?></td>
            <td class="centro"><?= e(ucfirst($alumno['estado'])) ?></td>
            <td class="centro">
              <?= (int)$alumno['faltan'] === 0
                  ? 'Completa'
                  : 'Faltan ' . (int)$alumno['faltan'] ?>
            </td>
          </tr>
        <?php endforeach; ?>
      </tbody>
    </table>
  <?php else: ?>
    <p>No se encontraron alumnos con los filtros indicados.</p>
  <?php endif; ?>

  <div class="firmas">
    <div class="firma"><div class="linea">Firma y sello de la autoridad</div></div>
    <div class="firma"><div class="linea">Aclaración</div></div>
    <div class="firma"><div class="linea">Fecha</div></div>
  </div>

  <footer class="hoja-pie">
    Generado por <?= e($usuario['nombre']) ?> (<?= e($usuario['rol']) ?>)
    · <?= e($fechaEmision) ?> · <?= e(APP_SIGLA) ?>
  </footer>
</article>

<script src="js/reportes.js"></script>
</body>
</html>
