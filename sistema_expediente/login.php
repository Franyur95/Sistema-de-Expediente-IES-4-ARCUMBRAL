
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
        $st = db()->prepare('SELECT id_usuario, nombre, usuario, clave_hash AS clave, rol, id_carrera, debe_cambiar_clave FROM usuarios WHERE usuario = ? AND activo = 1');
        $st->execute([$usuarioIngresado]);
        $u = $st->fetch();

        // Siempre se verifica un hash, exista o no el usuario.
        $coincide = password_verify($clave, $u ? $u['clave'] : HASH_FALSO);

        if ($u && $coincide) {
            if (password_needs_rehash($u['clave'], PASSWORD_DEFAULT)) {
                $up = db()->prepare('UPDATE usuarios SET clave_hash = ? WHERE id_usuario = ?');
                $up->execute([password_hash($clave, PASSWORD_DEFAULT), $u['id_usuario']]);
            }

            session_regenerate_id(true);

            $_SESSION['usuario'] = [
                'id_usuario' => (int)$u['id_usuario'],
                'nombre'     => $u['nombre'],
                'usuario'    => $u['usuario'],
                'rol'        => $u['rol'],
                'id_carrera' => $u['id_carrera'] === null ? null : (int)$u['id_carrera'],
                'debe_cambiar_clave' => (int)$u['debe_cambiar_clave'],
            ];

            $_SESSION['ultima_actividad'] = time();
            unset($_SESSION['csrf']);

            auditar('Inicio de sesión', null, null, (int)$u['id_usuario']);

            redirigir(
                (int)$u['debe_cambiar_clave'] === 1
                    ? 'cambiar_clave.php?obligatoria=1'
                    : 'index.php'
            );
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

            <input
                type="text"
                id="usuario"
                name="usuario"
                value="<?= e($usuarioIngresado) ?>"
                maxlength="50"
                required
                autocomplete="username"
                autofocus
            >
        </div>

        <div class="campo">
            <label for="clave">Contraseña</label>

            <div class="campo-contrasena">

                <input
                    type="password"
                    id="clave"
                    name="clave"
                    required
                    autocomplete="current-password"
                >

                <button
                    type="button"
                    id="boton-ver-clave"
                    class="btn-ver-clave"
                    aria-label="Mostrar contraseña"
                    aria-pressed="false"
                    aria-controls="clave"
                >

                    <!-- Ojo abierto -->
                    <svg
                        id="ojo-abierto"
                        xmlns="http://www.w3.org/2000/svg"
                        width="22"
                        height="22"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        stroke-width="2"
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        aria-hidden="true"
                    >
                        <path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12Z"/>
                        <circle cx="12" cy="12" r="3"/>
                    </svg>

                    <!-- Ojo cerrado -->
                    <svg
                        id="ojo-cerrado"
                        xmlns="http://www.w3.org/2000/svg"
                        width="22"
                        height="22"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        stroke-width="2"
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        aria-hidden="true"
                        hidden
                    >
                        <path d="M3 3l18 18"/>
                        <path d="M10.6 5.1A10.7 10.7 0 0 1 12 5c6.5 0 10 7 10 7a16 16 0 0 1-3.1 3.8"/>
                        <path d="M6.2 6.2C3.5 8.1 2 12 2 12s3.5 7 10 7a10.8 10.8 0 0 0 5.8-1.7"/>
                        <path d="M10 10a3 3 0 0 0 4 4"/>
                    </svg>

                </button>

            </div>
        </div>

        <div class="botones">
            <button type="submit" class="btn">
                Ingresar
            </button>
        </div>

    </form>

</section>

<script src="js/mostrar_clave.js" defer></script>

<?php render_footer(); ?>
