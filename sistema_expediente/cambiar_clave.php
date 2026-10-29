<?php
require_once __DIR__ . '/includes/auth.php';

$usuario = require_login();
$errores = [];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $actual = is_string($_POST['actual'] ?? null) ? $_POST['actual'] : '';
    $nueva  = is_string($_POST['nueva'] ?? null) ? $_POST['nueva'] : '';
    $repite = is_string($_POST['repite'] ?? null) ? $_POST['repite'] : '';

    if (!csrf_valido()) {
        $errores[] = 'El formulario venció. Intente nuevamente.';
    } else {
        $st = db()->prepare('SELECT clave FROM usuario WHERE id_usuario = ?');
        $st->execute([$usuario['id_usuario']]);
        $hash = (string)$st->fetchColumn();

        if (!password_verify($actual, $hash)) {
            $errores[] = 'La contraseña actual es incorrecta.';
        }
        if (strlen($nueva) < 8) {
            $errores[] = 'La nueva contraseña debe tener al menos 8 caracteres.';
        } elseif (strlen($nueva) > 72) {
            $errores[] = 'La nueva contraseña no puede superar 72 caracteres.';
        } elseif (!preg_match('/[A-Za-z]/', $nueva) || !preg_match('/\d/', $nueva)) {
            $errores[] = 'La nueva contraseña debe combinar letras y números.';
        }
        if ($nueva !== $repite) {
            $errores[] = 'La confirmación no coincide con la nueva contraseña.';
        }
        if (!$errores && $nueva === $actual) {
            $errores[] = 'La nueva contraseña debe ser distinta de la actual.';
        }

        if (!$errores) {
            $up = db()->prepare('UPDATE usuario SET clave = ? WHERE id_usuario = ?');
            $up->execute([password_hash($nueva, PASSWORD_DEFAULT), $usuario['id_usuario']]);
            auditar('Cambio de contraseña', null, null, $usuario['id_usuario']);
            session_regenerate_id(true);
            flash('ok', 'Contraseña actualizada correctamente.');
            redirigir('index.php');
        }
    }
}

render_header('Cambiar mi contraseña', $usuario);
if ($errores) {
    echo '<div class="alerta error" role="alert"><ul>';
    foreach ($errores as $m) {
        echo '<li>' . e($m) . '</li>';
    }
    echo '</ul></div>';
}
?>
<section class="tarjeta tarjeta-login">
  <form method="post" action="cambiar_clave.php" class="formulario">
    <?= csrf_campo() ?>
    <div class="campo">
      <label for="actual">Contraseña actual</label>
      <input type="password" id="actual" name="actual" required autocomplete="current-password">
    </div>
    <div class="campo">
      <label for="nueva">Nueva contraseña</label>
      <input type="password" id="nueva" name="nueva" required minlength="8" maxlength="72" autocomplete="new-password">
      <small class="ayuda">Mínimo 8 caracteres, con letras y números.</small>
    </div>
    <div class="campo">
      <label for="repite">Repetir nueva contraseña</label>
      <input type="password" id="repite" name="repite" required minlength="8" maxlength="72" autocomplete="new-password">
    </div>
    <div class="botones">
      <button type="submit" class="btn">Cambiar contraseña</button>
      <a class="btn btn-sec" href="index.php">Cancelar</a>
    </div>
  </form>
</section>
<?php render_footer(); ?>
