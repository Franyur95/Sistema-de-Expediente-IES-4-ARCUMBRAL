<?php
require_once __DIR__ . '/includes/auth.php';

$usuario = require_login();
$puedeVerExpedientes = puede_ver_expedientes($usuario);
$total = 0;
$ultimos = [];

if ($puedeVerExpedientes) {
    $total = (int)db()->query('SELECT COUNT(*) FROM estudiantes')->fetchColumn();

    $ultimos = db()->query(
        'SELECT id_estudiante, apellido, nombre, dni, estado, created_at AS creado_en
         FROM estudiantes ORDER BY id_estudiante DESC LIMIT 5'
    )->fetchAll();
}

render_header('Inicio', $usuario);
?>

<?php if ($puedeVerExpedientes): ?>

<section class="tarjeta tarjeta-expedientes">

  <div class="expedientes-cabecera">

    <h2>
      <span class="carpeta-icono" aria-hidden="true">▰</span>
      Expedientes registrados:
      <span class="contador-expedientes"><?= $total ?></span>
    </h2>

    <a class="buscador-acceso"
       href="buscar.php"
       aria-label="Ir a buscar alumnos">
      <span aria-hidden="true">⌕</span>
      Buscar alumno...
    </a>

  </div>

<?php if ($ultimos): ?>

  <h3>Últimos cargados</h3>

  <div class="tabla-wrap">
    <table class="tabla">

      <thead>
        <tr>
          <th>Alumno</th>
          <th>DNI</th>
          <th>Estado</th>
          <th>Cargado el</th>
          <th>Acciones</th>
        </tr>
      </thead>

      <tbody>

<?php foreach ($ultimos as $f): ?>

        <tr>
          <td>
            <?= e($f['apellido']) ?>,
            <?= e($f['nombre']) ?>
          </td>

          <td><?= e($f['dni']) ?></td>

          <td>
            <span class="estado-expediente">
              <?= e($f['estado']) ?>
            </span>
          </td>

          <td><?= e(fecha_ar($f['creado_en'])) ?></td>

          <td>
            <a class="accion-ver"
               href="ver.php?id=<?= (int)$f['id_estudiante'] ?>"
               aria-label="Ver expediente">
              Ver
            </a>
          </td>
        </tr>

<?php endforeach; ?>

      </tbody>

    </table>
  </div>

<?php else: ?>

  <p>Todavía no hay expedientes cargados.</p>

<?php endif; ?>

</section>

<?php else: ?>

<section class="tarjeta">
  <p>Seleccione una de las opciones autorizadas para su rol:</p>
  <div class="botones">
<?php if (tiene_permiso($usuario, 'usuarios.ver')): ?>
    <a class="btn" href="usuarios.php">Usuarios y permisos</a>
<?php endif; ?>
<?php if (tiene_permiso($usuario, 'auditoria.ver')): ?>
    <a class="btn" href="auditoria.php">Registro de auditoría</a>
<?php endif; ?>
<?php if (tiene_permiso($usuario, 'respaldos.ver')): ?>
    <a class="btn" href="respaldos.php">Respaldos</a>
<?php endif; ?>
  </div>
</section>

<?php endif; ?>

<?php render_footer(); ?>
