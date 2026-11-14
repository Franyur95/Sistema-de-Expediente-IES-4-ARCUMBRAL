<?php
require_once __DIR__ . '/includes/auth.php';

if (isset($_SESSION['usuario'])) {
    redirigir('index.php');
}

$enviado = false;
$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $nombre = mb_substr(trim(is_string($_POST['usuario'] ?? null) ? $_POST['usuario'] : ''), 0, 60);

    if (!csrf_valido()) {
        $error = 'El formulario venció. Intente nuevamente.';
    } elseif ($nombre === '') {
        $error = 'Ingrese su nombre de usuario.';
    } else {
        $st = db()->prepare('SELECT id_usuario, rol FROM usuarios WHERE usuario = ? AND activo = 1');
        $st->execute([$nombre]);
        $u = $st->fetch();

        // El administrador no usa este circuito.
        if ($u && $u['rol'] !== 'admin') {
            $st = db()->prepare('SELECT 1 FROM solicitud_clave WHERE id_usuario = ? AND atendida = 0');
            $st->execute([$u['id_usuario']]);
            if (!$st->fetchColumn()) {
                db()->prepare('INSERT INTO solicitud_clave (id_usuario) VALUES (?)')->execute([$u['id_usuario']]);
            }
        }
        $enviado = true; // Mismo mensaje exista o no el usuario.
    }
}

render_header('Olvidé mi contraseña');
if ($error !== '') {
    echo '<div class="alerta error" role="alert">' . e($error) . '</div>';
}
if ($enviado) {
    echo '<div class="alerta ok">Si el usuario existe, la solicitud quedó registrada. '
       . 'Comuníquese con el administrador para recibir una contraseña temporal.</div>';
    echo '<p><a class="btn btn-sec" href="login.php">Volver al ingreso</a></p>';
} else {
?>
<section class="tarjeta tarjeta-login">
  <form method="post" action="olvide_clave.php" class="formulario">
    <?= csrf_campo() ?>
    <div class="campo">
      <label for="usuario">Usuario</label>
      <input type="text" id="usuario" name="usuario" maxlength="60" required autofocus>
    </div>
    <div class="botones">
      <button type="submit" class="btn">Solicitar nueva contraseña</button>
      <a class="btn btn-sec" href="login.php">Cancelar</a>
    </div>
  </form>
</section>
<?php
}
render_footer();