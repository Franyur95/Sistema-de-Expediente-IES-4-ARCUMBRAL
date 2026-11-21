<?php
require_once __DIR__ . '/includes/auth.php';
require_once __DIR__ . '/includes/estudiantes.php';
require_once __DIR__ . '/includes/academico.php';
require_once __DIR__ . '/includes/tramites.php';

$usuario = require_login();
exigir_permiso($usuario, 'tramites.ver');

$id = id_desde_get();
$alumno = $id > 0 ? obtener_estudiante($id) : null;
if (!$alumno) {
    pagina_error(404, 'Expediente no encontrado', 'El expediente solicitado no existe.', $usuario);
}

// Consultar: todos los que tengan el permiso. Modificar: permiso de edición y misma carrera.
$puedeEditar = tiene_permiso($usuario, 'tramites.editar', true)
    && carrera_permitida($usuario, (int)$alumno['id_carrera']);

$url = 'tramites_alumno.php?id=' . $id;
$materias = materias_de_carrera((int)$alumno['id_carrera']);
$idsMaterias = array_map(static fn($m) => (int)$m['id_materia'], $materias);

$errores = [];
$vals = [
    'tipo' => '', 'fecha_solicitud' => date('Y-m-d'), 'fecha_limite' => '',
    'id_carrera_destino' => '', 'detalle' => '',
];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!$puedeEditar) {
        pagina_error(403, 'Acceso denegado', 'No tiene permiso para modificar trámites de este alumno.', $usuario);
    }
    if (!csrf_valido()) {
        flash('error', 'El formulario venció. Intente nuevamente.');
        redirigir($url);
    }

    $accion = campo($_POST, 'accion');
    $idTramite = ctype_digit(campo($_POST, 'id_tramite')) ? (int)campo($_POST, 'id_tramite') : 0;
    $tramite = $idTramite > 0 ? obtener_tramite($idTramite, $id) : null;

    try {
        if ($accion === 'crear') {
            [$err, $d] = validar_tramite_nuevo($_POST, $alumno);
            if (!$err) {
                crear_tramite($id, $alumno, $d, $usuario['id_usuario']);
                flash('ok', 'Trámite registrado.');
                redirigir($url);
            }
            $errores = $err;
            $vals = $d;
        } elseif (!$tramite) {
            flash('error', 'No se encontró el trámite.');
            redirigir($url);
        } else {
            $error = null;
            $okMsg = '';
            if ($accion === 'estado') {
                $error = cambiar_estado_tramite(
                    $id, $tramite, campo($_POST, 'estado'),
                    limpiar_espacios(campo($_POST, 'motivo')), $usuario
                );
                $okMsg = 'Estado actualizado.';
            } elseif ($accion === 'materias') {
                $lista = is_array($_POST['materias'] ?? null) ? $_POST['materias'] : [];
                $error = guardar_materias_tramite($id, $tramite, $lista, $idsMaterias, $usuario['id_usuario']);
                $okMsg = 'Espacios curriculares reconocidos guardados.';
            } elseif ($accion === 'resolver') {
                $error = resolver_tramite(
                    $id, $tramite,
                    limpiar_espacios(campo($_POST, 'nro_resolucion')),
                    campo($_POST, 'fecha_resolucion'),
                    $usuario['id_usuario']
                );
                $okMsg = 'Trámite resuelto.';
            } else {
                $error = 'Acción no válida.';
            }
            flash($error === null ? 'ok' : 'error', $error ?? $okMsg);
            redirigir($url);
        }
    } catch (PDOException $ex) {
        $msg = tramite_mensaje_disparador($ex);
        if ($msg === null) {
            error_log('Error en trámites: ' . $ex->getMessage());
            $msg = 'Ocurrió un error al guardar. No se realizaron cambios; intente nuevamente.';
        }
        flash('error', $msg);
        redirigir($url);
    }
}

$tramites = listar_tramites_estudiante($id);
$carreras = tramite_carreras();

render_header('Trámites: ' . $alumno['apellido'] . ', ' . $alumno['nombre'], $usuario);
?>
<div class="botones botones-arriba">
  <a class="btn btn-sec" href="ver.php?id=<?= $id ?>">Volver al expediente</a>
  <a class="btn btn-sec" href="tramites.php">Listado de trámites</a>
</div>
<p>DNI <?= e($alumno['dni']) ?> · <?= e($alumno['carrera']) ?> (<?= e($alumno['turno']) ?>)</p>

<?php if (!$puedeEditar): ?>
<div class="alerta aviso">Solo consulta: su rol o su carrera no permiten modificar los trámites de este alumno.</div>
<?php endif; ?>

<?php if (!$tramites): ?>
<section class="tarjeta"><p>Este alumno no tiene trámites registrados.</p></section>
<?php endif; ?>

<?php foreach ($tramites as $t):
    $abierto = tramite_esta_abierto($t);
    $conMaterias = in_array($t['tipo'], TRAMITE_CON_MATERIAS, true);
    $idsReconocidas = array_map(static fn($m) => (int)$m['id_materia'], $t['materias']);
?>
<section class="tarjeta">
  <h2><?= e(tramite_tipo_etq($t['tipo'])) ?> <span class="badge"><?= e(tramite_estado_etq($t['estado'])) ?></span></h2>
  <dl class="datos">
    <div class="dato"><dt>Solicitado el</dt><dd><?= e(fecha_ar($t['fecha_solicitud'])) ?></dd></div>
    <div class="dato"><dt>Fecha límite</dt><dd><?= e($t['fecha_limite'] ? fecha_ar($t['fecha_limite']) : '—') ?></dd></div>
    <div class="dato"><dt>Plazo</dt><dd><?= tramite_plazo_html($t) ?></dd></div>
    <div class="dato"><dt>Iniciado por</dt><dd><?= e($t['iniciado_por'] ?? '—') ?></dd></div>
<?php if ($t['tipo'] === 'pase'): ?>
    <div class="dato"><dt>Carrera de origen</dt><dd><?= e($t['carrera_origen'] ?? '—') ?></dd></div>
    <div class="dato"><dt>Carrera de destino</dt><dd><?= e($t['carrera_destino'] ?? '—') ?></dd></div>
<?php endif; ?>
<?php if ($t['estado'] === 'resuelto'): ?>
    <div class="dato"><dt>Resolución N.º</dt><dd><?= e($t['nro_resolucion']) ?></dd></div>
    <div class="dato"><dt>Fecha de resolución</dt><dd><?= e(fecha_ar($t['fecha_resolucion'])) ?></dd></div>
<?php endif; ?>
    <div class="dato"><dt>Detalle</dt><dd><?= nl2br(e($t['detalle'] ?: '—')) ?></dd></div>
  </dl>

<?php if ($conMaterias): ?>
  <h3>Espacios curriculares reconocidos</h3>
<?php if ($t['materias']): ?>
  <ul>
<?php foreach ($t['materias'] as $m): ?>
    <li><?= e($m['nombre']) ?> <small>(<?= (int)$m['anio'] ?>.º año)</small></li>
<?php endforeach; ?>
  </ul>
<?php else: ?>
  <p>Todavía no se cargó ningún espacio.</p>
<?php endif; ?>
<?php endif; ?>

<?php if ($abierto && $puedeEditar): ?>
<?php if ($conMaterias): ?>
  <h3>Cargar espacios reconocidos</h3>
  <form method="post" action="<?= e($url) ?>" class="formulario">
    <?= csrf_campo() ?>
    <input type="hidden" name="accion" value="materias">
    <input type="hidden" name="id_tramite" value="<?= (int)$t['id_tramite'] ?>">
    <div class="tabla-wrap"><table class="tabla">
      <thead><tr><th>Reconocida</th><th>Espacio curricular</th><th>Año</th></tr></thead>
      <tbody>
<?php foreach ($materias as $m): ?>
        <tr>
          <td class="centro"><input type="checkbox" id="m_<?= (int)$t['id_tramite'] ?>_<?= (int)$m['id_materia'] ?>" name="materias[]" value="<?= (int)$m['id_materia'] ?>"<?= in_array((int)$m['id_materia'], $idsReconocidas, true) ? ' checked' : '' ?>></td>
          <td><label for="m_<?= (int)$t['id_tramite'] ?>_<?= (int)$m['id_materia'] ?>"><?= e($m['nombre']) ?></label></td>
          <td><?= (int)$m['anio'] ?>.º</td>
        </tr>
<?php endforeach; ?>
      </tbody>
    </table></div>
    <div class="botones"><button type="submit" class="btn btn-sec">Guardar espacios</button></div>
  </form>
<?php endif; ?>

  <h3>Cambiar estado</h3>
  <form method="post" action="<?= e($url) ?>" class="formulario">
    <?= csrf_campo() ?>
    <input type="hidden" name="accion" value="estado">
    <input type="hidden" name="id_tramite" value="<?= (int)$t['id_tramite'] ?>">
    <div class="fila">
      <div class="campo">
        <label for="est_<?= (int)$t['id_tramite'] ?>">Nuevo estado</label>
        <select id="est_<?= (int)$t['id_tramite'] ?>" name="estado">
<?php foreach (['en_curso', 'en_revision', 'observado', 'rechazado'] as $k): ?>
          <option value="<?= e($k) ?>"<?= $k === $t['estado'] ? ' selected' : '' ?>><?= e(tramite_estado_etq($k)) ?></option>
<?php endforeach; ?>
        </select>
      </div>
      <div class="campo">
        <label for="mot_<?= (int)$t['id_tramite'] ?>">Motivo u observación</label>
        <input type="text" id="mot_<?= (int)$t['id_tramite'] ?>" name="motivo" maxlength="300">
        <small class="ayuda">Obligatorio al rechazar.</small>
      </div>
    </div>
    <div class="botones"><button type="submit" class="btn btn-sec">Cambiar estado</button></div>
  </form>

  <h3>Resolver trámite</h3>
  <p class="ayuda">Número y fecha de la resolución emitida por Secretaría Académica.<?= $conMaterias ? ' Al resolver, los espacios reconocidos pasan a figurar como aprobados en la situación académica.' : '' ?></p>
  <form method="post" action="<?= e($url) ?>" class="formulario">
    <?= csrf_campo() ?>
    <input type="hidden" name="accion" value="resolver">
    <input type="hidden" name="id_tramite" value="<?= (int)$t['id_tramite'] ?>">
    <div class="fila">
      <div class="campo">
        <label for="nro_<?= (int)$t['id_tramite'] ?>">N.º de resolución <span class="req">*</span></label>
        <input type="text" id="nro_<?= (int)$t['id_tramite'] ?>" name="nro_resolucion" maxlength="50" required>
      </div>
      <div class="campo">
        <label for="fr_<?= (int)$t['id_tramite'] ?>">Fecha de la resolución <span class="req">*</span></label>
        <input type="date" id="fr_<?= (int)$t['id_tramite'] ?>" name="fecha_resolucion" max="<?= e(date('Y-m-d')) ?>" required>
      </div>
    </div>
    <div class="botones"><button type="submit" class="btn">Resolver trámite</button></div>
  </form>
<?php endif; ?>
</section>
<?php endforeach; ?>

<?php if ($puedeEditar): ?>
<section class="tarjeta">
  <h2>Iniciar un trámite</h2>
<?php if ($errores): ?>
  <div class="alerta error" role="alert"><strong>No se guardó. Revise:</strong><ul>
<?php foreach ($errores as $m): ?><li><?= e($m) ?></li><?php endforeach; ?>
  </ul></div>
<?php endif; ?>
  <form method="post" action="<?= e($url) ?>" class="formulario">
    <?= csrf_campo() ?>
    <input type="hidden" name="accion" value="crear">
    <div class="fila">
      <div class="campo<?= isset($errores['tipo']) ? ' campo-error' : '' ?>">
        <label for="n_tipo">Tipo de trámite <span class="req">*</span></label>
        <select id="n_tipo" name="tipo" required>
          <option value="">— Seleccione —</option>
<?php foreach (TRAMITE_TIPOS as $k => $etq): ?>
          <option value="<?= e($k) ?>"<?= $vals['tipo'] === $k ? ' selected' : '' ?>><?= e($etq) ?></option>
<?php endforeach; ?>
        </select>
      </div>
      <div class="campo<?= isset($errores['fecha_solicitud']) ? ' campo-error' : '' ?>">
        <label for="n_fs">Fecha de solicitud <span class="req">*</span></label>
        <input type="date" id="n_fs" name="fecha_solicitud" value="<?= e($vals['fecha_solicitud']) ?>" max="<?= e(date('Y-m-d')) ?>" required>
      </div>
      <div class="campo<?= isset($errores['fecha_limite']) ? ' campo-error' : '' ?>">
        <label for="n_fl">Fecha límite</label>
        <input type="date" id="n_fl" name="fecha_limite" value="<?= e($vals['fecha_limite']) ?>">
        <small class="ayuda">Si la deja vacía, asimilaciones y equivalencias se fijan a 60 días de la solicitud.</small>
      </div>
    </div>
    <div class="fila">
      <div class="campo<?= isset($errores['id_carrera_destino']) ? ' campo-error' : '' ?>">
        <label for="n_dest">Carrera de destino (solo pases)</label>
        <select id="n_dest" name="id_carrera_destino">
          <option value="">— No corresponde —</option>
<?php foreach ($carreras as $c): if ((int)$c['id_carrera'] === (int)$alumno['id_carrera']) { continue; } ?>
          <option value="<?= (int)$c['id_carrera'] ?>"<?= (string)$vals['id_carrera_destino'] === (string)$c['id_carrera'] ? ' selected' : '' ?>><?= e($c['nombre']) ?> (<?= e($c['turno']) ?>)</option>
<?php endforeach; ?>
        </select>
      </div>
    </div>
    <div class="campo<?= isset($errores['detalle']) ? ' campo-error' : '' ?>">
      <label for="n_det">Detalle</label>
      <textarea id="n_det" name="detalle" rows="3" maxlength="2000"><?= e($vals['detalle']) ?></textarea>
    </div>
    <div class="botones"><button type="submit" class="btn">Registrar trámite</button></div>
  </form>
</section>
<?php endif; ?>
<?php render_footer(); ?>
