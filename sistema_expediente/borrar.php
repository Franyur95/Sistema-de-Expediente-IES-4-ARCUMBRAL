<?php
require_once __DIR__ . '/includes/auth.php';
require_once __DIR__ . '/includes/estudiantes.php';

$usuario = require_login();
exigir_permiso($usuario, 'expedientes.eliminar', true);

$id = id_desde_get();
$a = $id > 0 ? obtener_estudiante($id) : null;
if (!$a) {
    pagina_error(404, 'Expediente no encontrado', 'El expediente solicitado no existe.', $usuario);
}
if (!carrera_permitida($usuario, (int)$a['id_carrera'])) {
    pagina_error(403, 'Acceso denegado', 'No puede eliminar alumnos de otra carrera.', $usuario);
}

$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!csrf_valido()) {
        $error = 'El formulario venció. Intente nuevamente.';
    } elseif (campo($_POST, 'dni_confirmacion') !== (string)$a['dni']) {
        $error = 'El DNI escrito no coincide. No se eliminó nada.';
    } else {
        $pdo = db();
        try {
            $pdo->beginTransaction();
            // Se audita antes de borrar (el registro deja de existir) y dentro de la misma transacción.
            auditar(
                'Eliminación de expediente',
                $a['apellido'] . ', ' . $a['nombre'] . ' (DNI ' . $a['dni'] . ')',
                $id,
                $usuario['id_usuario']
            );
            $st = $pdo->prepare('DELETE FROM estudiantes WHERE id_estudiante = ?');
            $st->execute([$id]);
            $pdo->commit();
            flash('ok', 'Expediente eliminado correctamente.');
            redirigir('buscar.php');
        } catch (PDOException $ex) {
            if ($pdo->inTransaction()) {
                $pdo->rollBack();
            }
            if (($ex->errorInfo[0] ?? '') === '45000') {
                $error = 'No se puede eliminar: el alumno tiene historial académico (cursadas, exámenes o trámites). '
                       . 'Para darlo de baja, cambie su estado a Abandono desde "Modificar datos".';
            } else {
                error_log('Error al eliminar expediente: ' . $ex->getMessage());
                $error = 'No se pudo eliminar el expediente. No se realizaron cambios.';
            }
        }
    }
}

render_header('Eliminar expediente', $usuario);
if ($error !== '') {
    echo '<div class="alerta error" role="alert">' . e($error) . '</div>';
}
?>
<section class="tarjeta">
  <h2><?= e($a['apellido']) ?>, <?= e($a['nombre']) ?></h2>
  <p>DNI <?= e($a['dni']) ?></p>
  <div class="alerta aviso">
    <strong>Esta acción no se puede deshacer.</strong> Se borrará el expediente junto con su documentación e inscripciones.
    Solo se permite si el alumno no tiene cursadas, exámenes ni trámites.
  </div>
  <form method="post" action="borrar.php?id=<?= (int)$id ?>" class="formulario">
    <?= csrf_campo() ?>
    <div class="campo">
      <label for="dni_confirmacion">Para confirmar, escriba el DNI del alumno</label>
      <input type="text" id="dni_confirmacion" name="dni_confirmacion" required autocomplete="off" inputmode="numeric">
    </div>
    <div class="botones">
      <button type="submit" class="btn">Eliminar definitivamente</button>
      <a class="btn btn-sec" href="ver.php?id=<?= (int)$id ?>">Cancelar</a>
    </div>
  </form>
</section>
<?php render_footer(); ?>