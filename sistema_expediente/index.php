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
<p>Bienvenido/a, <strong><?= e($usuario['nombre']) ?></strong>. Seleccione una opción.</p>

<div class="grid-menu">
<?php if ($puedeVerExpedientes && puede_editar($usuario)): ?>
  <a class="opcion" href="nuevo.php"><strong>Nuevo expediente</strong><span>Registrar un alumno y su documentación.</span></a>
<?php endif; ?>
<?php if ($puedeVerExpedientes): ?>
  <a class="opcion" href="buscar.php"><strong>Buscar alumnos</strong><span>Por apellido o DNI.</span></a>
<?php endif; ?>
<?php if (tiene_permiso($usuario, 'usuarios.ver')): ?>
  <a class="opcion" href="usuarios.php"><strong>Administración de usuarios</strong><span>Consultar cuentas, roles y estado. La edición depende del permiso asignado.</span></a>
<?php endif; ?>
  <a class="opcion" href="cambiar_clave.php"><strong>Mi contraseña</strong><span>Cambiar la clave de acceso.</span></a>
</div>

<?php if ($puedeVerExpedientes): ?>
<section class="tarjeta">
  <h2>Expedientes registrados: <?= $total ?></h2>
<?php if ($ultimos): ?>
  <h3>Últimos cargados</h3>
  <div class="tabla-wrap">
    <table class="tabla">
      <thead><tr><th>Alumno</th><th>DNI</th><th>Estado</th><th>Cargado el</th><th></th></tr></thead>
      <tbody>
<?php foreach ($ultimos as $f): ?>
        <tr>
          <td><?= e($f['apellido']) ?>, <?= e($f['nombre']) ?></td>
          <td><?= e($f['dni']) ?></td>
          <td><?= e($f['estado']) ?></td>
          <td><?= e(fecha_ar($f['creado_en'])) ?></td>
          <td><a href="ver.php?id=<?= (int)$f['id_estudiante'] ?>">Ver</a></td>
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
<section class="tarjeta"><p>Su usuario no tiene permiso para consultar expedientes. Puede utilizar las opciones autorizadas para su rol.</p></section>
<?php endif; ?>
<?php render_footer(); ?>
