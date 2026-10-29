<?php
require_once __DIR__ . '/includes/auth.php';

$usuarioActual = require_login();
$puedeVer = tiene_permiso($usuarioActual, 'usuarios.ver');
$puedeEditar = tiene_permiso($usuarioActual, 'usuarios.editar', true);
if (!$puedeVer) {
    exigir_permiso($usuarioActual, 'usuarios.ver');
}

$etiquetasRoles = [
    'admin' => 'Administrador',
    'vicerrectora' => 'Vicerrectora',
    'secretaria_academica' => 'Secretaría académica',
    'secretaria_administrativa' => 'Secretaría administrativa',
    'coordinadora' => 'Coordinadora',
    'preceptora' => 'Preceptoría',
    'docente' => 'Docente',
    'consulta' => 'Solo consulta',
];
// Solo se ofrecen roles que tengan permisos definidos en la base actual.
$rolesConfigurados = db()->query('SELECT DISTINCT rol FROM rol_permiso ORDER BY rol')->fetchAll(PDO::FETCH_COLUMN);
$roles = [];
foreach ($rolesConfigurados as $rolConfigurado) {
    if (isset($etiquetasRoles[$rolConfigurado])) {
        $roles[$rolConfigurado] = $etiquetasRoles[$rolConfigurado];
    }
}
$turnos = ['mañana' => 'Mañana', 'tarde' => 'Tarde', 'ambos' => 'Ambos'];
$errores = [];
$edicionId = filter_input(INPUT_GET, 'editar', FILTER_VALIDATE_INT) ?: 0;
$registro = [
    'nombre' => '', 'usuario' => '', 'rol' => 'consulta', 'turno' => 'ambos',
    'id_carrera' => '', 'puede_ver_otras_carreras' => 0, 'email' => '', 'telefono' => '', 'activo' => 1,
];

if ($edicionId > 0) {
    $st = db()->prepare('SELECT id_usuario, nombre, usuario, rol, turno, id_carrera, puede_ver_otras_carreras, email, telefono, activo FROM usuarios WHERE id_usuario = ?');
    $st->execute([$edicionId]);
    $encontrado = $st->fetch(PDO::FETCH_ASSOC);
    if (!$encontrado) {
        pagina_error(404, 'Usuario no encontrado', 'El usuario solicitado no existe.', $usuarioActual);
    }
    $registro = $encontrado;
    if (!$puedeEditar) {
        $edicionId = 0; // Una cuenta de solo lectura nunca recibe formulario de edición.
    }
}

$carreras = db()->query('SELECT id_carrera, nombre, turno, activa FROM carreras ORDER BY nombre')->fetchAll(PDO::FETCH_ASSOC);

function etiqueta_rol_usuario(string $rol, array $roles): string
{
    return $roles[$rol] ?? $rol;
}

function auditar_usuario_modulo(string $accion, int $idObjetivo, int $idActor, array $datos): void
{
    $st = db()->prepare('INSERT INTO auditoria (id_usuario, tabla, registro_id, accion, datos_nuevos, ip, user_agent, motivo) VALUES (?, ?, ?, ?, ?, ?, ?, ?)');
    $st->execute([
        $idActor, 'usuarios', $idObjetivo, $accion,
        json_encode($datos, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES),
        $_SERVER['REMOTE_ADDR'] ?? null,
        mb_substr((string)($_SERVER['HTTP_USER_AGENT'] ?? ''), 0, 255),
        $accion === 'INSERT' ? 'Alta de usuario desde administración' : 'Actualización de usuario desde administración',
    ]);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!$puedeEditar) {
        http_response_code(403);
        pagina_error(403, 'Acceso denegado', 'Su rol puede consultar usuarios, pero no modificarlos.', $usuarioActual);
    }
    if (!csrf_valido()) {
        $errores[] = 'El formulario venció. Recargue la página e intente nuevamente.';
    }

    $accion = is_string($_POST['accion'] ?? null) ? $_POST['accion'] : '';
    $idPost = filter_var($_POST['id_usuario'] ?? 0, FILTER_VALIDATE_INT) ?: 0;

    if ($accion === 'guardar') {
        $nombre = trim(is_string($_POST['nombre'] ?? null) ? $_POST['nombre'] : '');
        $nombreUsuario = trim(is_string($_POST['usuario'] ?? null) ? $_POST['usuario'] : '');
        $rol = is_string($_POST['rol'] ?? null) ? $_POST['rol'] : '';
        $turno = is_string($_POST['turno'] ?? null) ? $_POST['turno'] : 'ambos';
        $idCarreraRaw = $_POST['id_carrera'] ?? '';
        $idCarrera = ($idCarreraRaw === '' || $idCarreraRaw === null) ? null : filter_var($idCarreraRaw, FILTER_VALIDATE_INT);
        $email = trim(is_string($_POST['email'] ?? null) ? $_POST['email'] : '');
        $telefono = trim(is_string($_POST['telefono'] ?? null) ? $_POST['telefono'] : '');
        $clave = is_string($_POST['clave'] ?? null) ? $_POST['clave'] : '';
        $activo = isset($_POST['activo']) ? 1 : 0;
        $otrasCarreras = isset($_POST['puede_ver_otras_carreras']) ? 1 : 0;

        if ($nombre === '' || mb_strlen($nombre) > 120) $errores[] = 'El nombre es obligatorio y admite hasta 120 caracteres.';
        if (!preg_match('/^[a-zA-Z0-9._-]{3,60}$/', $nombreUsuario)) $errores[] = 'El usuario debe tener entre 3 y 60 caracteres: letras, números, punto, guion o guion bajo.';
        if (!isset($roles[$rol])) $errores[] = 'Seleccione un rol válido.';
        if (!isset($turnos[$turno])) $errores[] = 'Seleccione un turno válido.';
        if ($idCarrera !== null && ($idCarrera === false || $idCarrera < 1)) $errores[] = 'Seleccione una carrera válida.';
        if ($email !== '' && (!filter_var($email, FILTER_VALIDATE_EMAIL) || mb_strlen($email) > 120)) $errores[] = 'El correo electrónico no es válido o supera los 120 caracteres.';
        if (mb_strlen($telefono) > 50) $errores[] = 'El teléfono admite hasta 50 caracteres.';
        if ($idPost === 0 && strlen($clave) < 12) $errores[] = 'La contraseña inicial debe tener al menos 12 caracteres.';
        if ($clave !== '' && strlen($clave) < 12) $errores[] = 'La nueva contraseña debe tener al menos 12 caracteres.';
        if ($idPost > 0 && $idPost === (int)$usuarioActual['id_usuario'] && ($activo !== 1 || $rol !== 'admin')) {
            $errores[] = 'No puede desactivar su propia cuenta ni quitarse el rol de administrador mientras está conectado.';
        }

        if ($idCarrera !== null && $idCarrera !== false) {
            $stCarrera = db()->prepare('SELECT COUNT(*) FROM carreras WHERE id_carrera = ?');
            $stCarrera->execute([$idCarrera]);
            if ((int)$stCarrera->fetchColumn() !== 1) $errores[] = 'La carrera seleccionada no existe.';
        }

        if (!$errores) {
            $stDup = db()->prepare('SELECT id_usuario FROM usuarios WHERE usuario = ? AND id_usuario <> ? LIMIT 1');
            $stDup->execute([$nombreUsuario, $idPost]);
            if ($stDup->fetchColumn()) $errores[] = 'Ese nombre de usuario ya está en uso.';
        }

        if (!$errores && $idPost > 0) {
            $stAnterior = db()->prepare('SELECT id_usuario, rol, activo FROM usuarios WHERE id_usuario = ?');
            $stAnterior->execute([$idPost]);
            $anterior = $stAnterior->fetch(PDO::FETCH_ASSOC);
            if (!$anterior) $errores[] = 'El usuario que intenta editar ya no existe.';
            elseif ((string)$anterior['rol'] === 'admin' && (int)$anterior['activo'] === 1 && ($rol !== 'admin' || $activo !== 1)) {
                $stAdmins = db()->query("SELECT COUNT(*) FROM usuarios WHERE rol = 'admin' AND activo = 1");
                if ((int)$stAdmins->fetchColumn() <= 1) $errores[] = 'No puede quitar o desactivar al último administrador activo.';
            }
        }

        if (!$errores) {
            try {
                db()->beginTransaction();
                if ($idPost > 0) {
                    if ($clave !== '') {
                        $sql = 'UPDATE usuarios SET nombre=?, usuario=?, rol=?, turno=?, id_carrera=?, puede_ver_otras_carreras=?, email=?, telefono=?, activo=?, clave_hash=?, debe_cambiar_clave=1 WHERE id_usuario=?';
                        $params = [$nombre, $nombreUsuario, $rol, $turno, $idCarrera, $otrasCarreras, $email !== '' ? $email : null, $telefono !== '' ? $telefono : null, $activo, password_hash($clave, PASSWORD_DEFAULT), $idPost];
                    } else {
                        $sql = 'UPDATE usuarios SET nombre=?, usuario=?, rol=?, turno=?, id_carrera=?, puede_ver_otras_carreras=?, email=?, telefono=?, activo=? WHERE id_usuario=?';
                        $params = [$nombre, $nombreUsuario, $rol, $turno, $idCarrera, $otrasCarreras, $email !== '' ? $email : null, $telefono !== '' ? $telefono : null, $activo, $idPost];
                    }
                    $st = db()->prepare($sql);
                    $st->execute($params);
                    auditar_usuario_modulo('UPDATE', $idPost, (int)$usuarioActual['id_usuario'], ['usuario' => $nombreUsuario, 'rol' => $rol, 'activo' => $activo]);
                    db()->commit();
                    flash('ok', 'Los datos del usuario se actualizaron correctamente.');
                } else {
                    $st = db()->prepare('INSERT INTO usuarios (nombre, usuario, clave_hash, rol, turno, id_carrera, puede_ver_otras_carreras, email, telefono, activo, debe_cambiar_clave) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1)');
                    $st->execute([$nombre, $nombreUsuario, password_hash($clave, PASSWORD_DEFAULT), $rol, $turno, $idCarrera, $otrasCarreras, $email !== '' ? $email : null, $telefono !== '' ? $telefono : null, $activo]);
                    $nuevoId = (int)db()->lastInsertId();
                    auditar_usuario_modulo('INSERT', $nuevoId, (int)$usuarioActual['id_usuario'], ['usuario' => $nombreUsuario, 'rol' => $rol, 'activo' => $activo]);
                    db()->commit();
                    flash('ok', 'Usuario creado. Deberá cambiar la contraseña al recibir sus credenciales.');
                }
                redirigir('usuarios.php');
            } catch (Throwable $ex) {
                if (db()->inTransaction()) db()->rollBack();
                error_log('Error en administración de usuarios: ' . $ex->getMessage());
                $errores[] = 'No se pudo guardar el usuario. Verifique que el nombre de usuario sea único y que la base esté disponible.';
            }
        }
        $registro = [
            'nombre' => $nombre, 'usuario' => $nombreUsuario, 'rol' => $rol, 'turno' => $turno,
            'id_carrera' => $idCarrera ?? '', 'puede_ver_otras_carreras' => $otrasCarreras,
            'email' => $email, 'telefono' => $telefono, 'activo' => $activo,
        ];
        $edicionId = $idPost;
    } elseif ($accion === 'cambiar_estado') {
        $objetivo = filter_var($_POST['id_usuario'] ?? 0, FILTER_VALIDATE_INT) ?: 0;
        $nuevoEstado = (int)($_POST['nuevo_estado'] ?? -1);
        if ($objetivo < 1 || !in_array($nuevoEstado, [0, 1], true)) {
            $errores[] = 'La operación solicitada no es válida.';
        } elseif ($objetivo === (int)$usuarioActual['id_usuario'] && $nuevoEstado === 0) {
            $errores[] = 'No puede desactivar su propia cuenta.';
        } else {
            $st = db()->prepare('SELECT id_usuario, usuario, rol, activo FROM usuarios WHERE id_usuario = ?');
            $st->execute([$objetivo]);
            $destino = $st->fetch(PDO::FETCH_ASSOC);
            if (!$destino) $errores[] = 'El usuario solicitado no existe.';
            elseif ($destino['rol'] === 'admin' && (int)$destino['activo'] === 1 && $nuevoEstado === 0 && (int)db()->query("SELECT COUNT(*) FROM usuarios WHERE rol='admin' AND activo=1")->fetchColumn() <= 1) {
                $errores[] = 'No puede desactivar al último administrador activo.';
            } else {
                try {
                    db()->beginTransaction();
                    $up = db()->prepare('UPDATE usuarios SET activo = ? WHERE id_usuario = ?');
                    $up->execute([$nuevoEstado, $objetivo]);
                    auditar_usuario_modulo('UPDATE', $objetivo, (int)$usuarioActual['id_usuario'], ['usuario' => $destino['usuario'], 'activo' => $nuevoEstado]);
                    db()->commit();
                    flash('ok', $nuevoEstado ? 'Usuario activado.' : 'Usuario desactivado.');
                    redirigir('usuarios.php');
                } catch (Throwable $ex) {
                    if (db()->inTransaction()) db()->rollBack();
                    error_log('Error al cambiar estado de usuario: ' . $ex->getMessage());
                    $errores[] = 'No se pudo cambiar el estado del usuario.';
                }
            }
        }
    } else {
        $errores[] = 'La operación solicitada no es válida.';
    }
}

$filtro = trim(is_string($_GET['q'] ?? null) ? $_GET['q'] : '');
$sqlLista = 'SELECT u.id_usuario, u.nombre, u.usuario, u.rol, u.turno, u.id_carrera, u.email, u.activo, c.nombre AS carrera_nombre FROM usuarios u LEFT JOIN carreras c ON c.id_carrera = u.id_carrera';
$paramsLista = [];
if ($filtro !== '') {
    $sqlLista .= ' WHERE u.nombre LIKE ? OR u.usuario LIKE ? OR u.email LIKE ?';
    $buscar = '%' . $filtro . '%';
    $paramsLista = [$buscar, $buscar, $buscar];
}
$sqlLista .= ' ORDER BY u.activo DESC, u.nombre ASC';
$stLista = db()->prepare($sqlLista);
$stLista->execute($paramsLista);
$usuarios = $stLista->fetchAll(PDO::FETCH_ASSOC);

render_header('Administración de usuarios', $usuarioActual);
?>

<?php foreach ($errores as $error): ?>
  <div class="alerta error" role="alert"><?= e($error) ?></div>
<?php endforeach; ?>

<?php if ($puedeEditar && ($edicionId > 0 || (isset($_GET['nuevo']) && $_GET['nuevo'] === '1'))): ?>
<section class="tarjeta">
  <h2><?= $edicionId > 0 ? 'Editar usuario' : 'Crear usuario' ?></h2>
  <p class="nota">Los campos marcados son obligatorios. Las contraseñas nunca se muestran ni se recuperan en texto legible.</p>
  <form method="post" action="usuarios.php<?= $edicionId > 0 ? '?editar=' . (int)$edicionId : '?nuevo=1' ?>" class="formulario">
    <?= csrf_campo() ?>
    <input type="hidden" name="accion" value="guardar">
    <input type="hidden" name="id_usuario" value="<?= (int)$edicionId ?>">
    <div class="fila">
      <div class="campo"><label for="nombre">Nombre completo *</label><input id="nombre" name="nombre" type="text" maxlength="120" required value="<?= e($registro['nombre']) ?>"></div>
      <div class="campo"><label for="usuario">Nombre de usuario *</label><input id="usuario" name="usuario" type="text" maxlength="60" pattern="[A-Za-z0-9._-]{3,60}" required value="<?= e($registro['usuario']) ?>" autocomplete="off"><span class="ayuda">3–60 caracteres: letras, números, punto, guion o guion bajo.</span></div>
    </div>
    <div class="fila">
      <div class="campo"><label for="rol">Rol *</label><select id="rol" name="rol" required><?php foreach ($roles as $valor => $texto): ?><option value="<?= e($valor) ?>" <?= $registro['rol'] === $valor ? 'selected' : '' ?>><?= e($texto) ?> (<?= e($valor) ?>)</option><?php endforeach; ?></select><span class="ayuda">Se utilizan los valores permitidos por la columna usuarios.rol.</span></div>
      <div class="campo"><label for="turno">Turno *</label><select id="turno" name="turno" required><?php foreach ($turnos as $valor => $texto): ?><option value="<?= e($valor) ?>" <?= $registro['turno'] === $valor ? 'selected' : '' ?>><?= e($texto) ?></option><?php endforeach; ?></select></div>
      <div class="campo"><label for="id_carrera">Carrera asignada</label><select id="id_carrera" name="id_carrera"><option value="">Sin carrera específica</option><?php foreach ($carreras as $carrera): ?><option value="<?= (int)$carrera['id_carrera'] ?>" <?= (string)$registro['id_carrera'] === (string)$carrera['id_carrera'] ? 'selected' : '' ?>><?= e($carrera['nombre']) ?><?= !(int)$carrera['activa'] ? ' (inactiva)' : '' ?></option><?php endforeach; ?></select></div>
    </div>
    <div class="fila">
      <div class="campo"><label for="email">Correo electrónico</label><input id="email" name="email" type="text" maxlength="120" value="<?= e($registro['email'] ?? '') ?>" autocomplete="email"></div>
      <div class="campo"><label for="telefono">Teléfono</label><input id="telefono" name="telefono" type="tel" maxlength="50" value="<?= e($registro['telefono'] ?? '') ?>"></div>
    </div>
    <div class="campo"><label><input type="checkbox" name="puede_ver_otras_carreras" value="1" <?= (int)$registro['puede_ver_otras_carreras'] === 1 ? 'checked' : '' ?>> Puede ver otras carreras</label><span class="ayuda">Este indicador no reemplaza los permisos del rol; las páginas deben respetarlo en sus consultas.</span></div>
    <div class="campo"><label><input type="checkbox" name="activo" value="1" <?= (int)$registro['activo'] === 1 ? 'checked' : '' ?>> Cuenta activa</label></div>
    <div class="campo"><label for="clave"><?= $edicionId > 0 ? 'Nueva contraseña (opcional)' : 'Contraseña inicial *' ?></label><input id="clave" name="clave" type="password" minlength="12" <?= $edicionId > 0 ? '' : 'required' ?> autocomplete="new-password"><span class="ayuda">Mínimo 12 caracteres. Al crear la cuenta o cambiar esta contraseña, se marcará que debe cambiarla al ingresar. <?= $edicionId > 0 ? 'Dejar en blanco para conservar la contraseña actual.' : 'Entregue la contraseña inicial al usuario por un canal seguro.' ?></span></div>
    <div class="botones"><button class="btn" type="submit">Guardar usuario</button><a class="btn btn-sec" href="usuarios.php">Cancelar</a></div>
  </form>
</section>
<?php elseif ($puedeEditar): ?>
<p class="botones botones-arriba"><a class="btn" href="usuarios.php?nuevo=1">Crear usuario</a></p>
<?php endif; ?>

<section class="tarjeta">
  <h2>Usuarios registrados (<?= count($usuarios) ?>)</h2>
  <form method="get" action="usuarios.php" class="form-busqueda">
    <div class="campo"><label for="q">Buscar por nombre, usuario o correo</label><input id="q" name="q" type="search" maxlength="120" value="<?= e($filtro) ?>"></div>
    <button class="btn" type="submit">Buscar</button>
    <?php if ($filtro !== ''): ?><a class="btn btn-sec" href="usuarios.php">Limpiar</a><?php endif; ?>
  </form>
  <div class="tabla-wrap">
    <table class="tabla">
      <thead><tr><th>Nombre</th><th>Usuario</th><th>Rol</th><th>Turno</th><th>Carrera</th><th>Estado</th><?php if ($puedeEditar): ?><th>Acciones</th><?php endif; ?></tr></thead>
      <tbody>
      <?php if (!$usuarios): ?><tr><td colspan="<?= $puedeEditar ? 7 : 6 ?>">No se encontraron usuarios.</td></tr><?php endif; ?>
      <?php foreach ($usuarios as $fila): ?>
        <tr>
          <td><?= e($fila['nombre']) ?></td><td><?= e($fila['usuario']) ?></td><td><?= e(etiqueta_rol_usuario($fila['rol'], $roles)) ?></td><td><?= e($turnos[$fila['turno']] ?? $fila['turno']) ?></td><td><?= e($fila['carrera_nombre'] ?? 'Todas / sin asignar') ?></td>
          <td><?= (int)$fila['activo'] === 1 ? '<span class="badge">Activa</span>' : '<span class="badge">Inactiva</span>' ?></td>
          <?php if ($puedeEditar): ?><td class="acciones"><a href="usuarios.php?editar=<?= (int)$fila['id_usuario'] ?>">Editar</a>
            <?php if ((int)$fila['id_usuario'] !== (int)$usuarioActual['id_usuario']): ?>
            <form method="post" action="usuarios.php" class="form-inline">
              <?= csrf_campo() ?><input type="hidden" name="accion" value="cambiar_estado"><input type="hidden" name="id_usuario" value="<?= (int)$fila['id_usuario'] ?>"><input type="hidden" name="nuevo_estado" value="<?= (int)$fila['activo'] === 1 ? 0 : 1 ?>">
              <button type="submit" class="btn-link btn-link-osc"><?= (int)$fila['activo'] === 1 ? 'Desactivar' : 'Activar' ?></button>
            </form>
            <?php endif; ?>
          </td><?php endif; ?>
        </tr>
      <?php endforeach; ?>
      </tbody>
    </table>
  </div>
</section>
<?php render_footer(); ?>
