<?php
require_once __DIR__ . '/includes/auth.php';

if (isset($_SESSION['usuario'])) {
    redirigir('index.php');
}

$error = '';
$usuarioIngresado = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $usuarioIngresado = mb_substr(trim(is_string($_POST['usuario'] ?? null) ? $_POST['usuario'] : ''), 0, 50);
    $clave = is_string($_POST['clave'] ?? null) ? $_POST['clave'] : '';

    if (!csrf_valido()) {
        $error = 'El formulario venció. Intente nuevamente.';
    } elseif ($usuarioIngresado === '' || $clave === '') {
        $error = 'Ingrese usuario y contraseña.';
    } else {
        $st = db()->prepare('SELECT id_usuario, nombre, usuario, clave, rol, id_carrera FROM usuario WHERE usuario = ? AND activo = 1');
        $st->execute([$usuarioIngresado]);
        $u = $st->fetch();

        // Siempre se verifica un hash, exista o no el usuario.
        $coincide = password_verify($clave, $u ? $u['clave'] : HASH_FALSO);

        if ($u && $coincide) {
            if (password_needs_rehash($u['clave'], PASSWORD_DEFAULT)) {
                $up = db()->prepare('UPDATE usuario SET clave = ? WHERE id_usuario = ?');
                $up->execute([password_hash($clave, PASSWORD_DEFAULT), $u['id_usuario']]);
            }
            session_regenerate_id(true);
            $_SESSION['usuario'] = [
                'id_usuario' => (int)$u['id_usuario'],
                'nombre'     => $u['nombre'],
                'usuario'    => $u['usuario'],
                'rol'        => $u['rol'],
                'id_carrera' => $u['id_carrera'] === null ? null : (int)$u['id_carrera'],
            ];
            $_SESSION['ultima_actividad'] = time();
            unset($_SESSION['csrf']);
            auditar('Inicio de sesión', null, null, (int)$u['id_usuario']);
            redirigir('index.php');
        }
        $error = 'Usuario o contraseña incorrectos.';
    }
}

render_header('Iniciar sesión');

if (isset($_GET['expirada'])) {
    echo '<div class="alerta aviso">La sesión se cerró por inactividad. Vuelva a ingresar.</div>';
}
if (isset($_GET['salio'])) {
    echo '<div class="alerta ok">Cerró sesión correctamente.</div>';
}
if ($error !== '') {
    echo '<div class="alerta error" role="alert">' . e($error) . '</div>';
}
?>
<section class="tarjeta tarjeta-login">
  <form method="post" action="login.php" class="formulario">
    <?= csrf_campo() ?>
    <div class="campo">
      <label for="usuario">Usuario</label>
      <input type="text" id="usuario" name="usuario" value="<?= e($usuarioIngresado) ?>" maxlength="50" required autocomplete="username" autofocus>
    </div>
    <div class="campo">
      <label for="clave">Contraseña</label>
      <input type="password" id="clave" name="clave" required autocomplete="current-password">
    </div>
    <div class="botones">
      <button type="submit" class="btn">Ingresar</button>
    </div>
  </form>
</section>
<?php render_footer(); ?>
