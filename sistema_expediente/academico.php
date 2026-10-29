<?php
require_once __DIR__ . '/includes/auth.php';

require_once __DIR__ . '/includes/estudiantes.php';
require_once __DIR__ . '/includes/academico.php';
require_once __DIR__ . '/includes/form_estudiante.php';

$usuario = require_login();
exigir_permiso($usuario, 'expedientes.ver');
exigir_permiso($usuario, 'notas.ver');
$puedeEditarAcademico = puede_editar_academico($usuario);

$id = id_desde_get();
$alumno = $id > 0 ? obtener_estudiante($id) : null;
if (!$alumno) {
    pagina_error(404, 'Expediente no encontrado', 'El expediente solicitado no existe.', $usuario);
}
if (!carrera_permitida($usuario, (int)$alumno['id_carrera'])) {
    pagina_error(403, 'Acceso denegado', 'No tiene permiso para consultar la situación académica de esta carrera.', $usuario);
}

// Los roles con notas.ver pero sin notas.editar acceden a una vista estrictamente de lectura.
if (!$puedeEditarAcademico) {
    render_header('Situación académica: ' . $alumno['apellido'] . ', ' . $alumno['nombre'], $usuario);
    echo '<div class="botones botones-arriba"><a class="btn btn-sec" href="ver.php?id=' . (int)$id . '">Volver al expediente</a></div>';
    echo '<p>DNI ' . e($alumno['dni']) . ' · ' . e($alumno['carrera']) . ' (turno ' . e($alumno['turno']) . ')</p>';
    echo '<section class="tarjeta"><h2>Inscripciones para cursar y recursar</h2>';
    render_inscripciones(listar_inscripciones($id));
    echo '</section><section class="tarjeta"><h2>Situación académica</h2>';
    render_situacion_academica(situacion_academica($id, (int)$alumno['id_carrera']));
    echo '</section>';
    render_footer();
    exit;
}

$materias = materias_de_carrera((int)$alumno['id_carrera']);
$idsMaterias = array_map(static fn($m) => (int)$m['id_materia'], $materias);
$url = 'academico.php?id=' . $id;

$errores = ['inscripcion' => [], 'cursada' => [], 'examen' => []];
$vals = ['inscripcion' => [], 'cursada' => [], 'examen' => []];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    exigir_permiso($usuario, 'notas.editar', true);
    if (!csrf_valido()) {
        flash('error', 'El formulario venció. Intente nuevamente.');
        redirigir($url);
    }
    $accion = campo($_POST, 'accion');

    try {
        if ($accion === 'inscripcion') {
            [$err, $d] = validar_inscripcion($_POST, $idsMaterias, $id);
            if (!$err) {
                guardar_inscripcion($id, $d, $usuario['id_usuario']);
                flash('ok', 'Inscripción registrada.');
                redirigir($url);
            }
            $errores['inscripcion'] = $err; $vals['inscripcion'] = $d;
        } elseif ($accion === 'cursada') {
            [$err, $d] = validar_cursada($_POST, $idsMaterias);
            if (!$err) {
                guardar_cursada($id, $d, $usuario['id_usuario']);
                flash('ok', 'Cursada guardada.');
                redirigir($url);
            }
            $errores['cursada'] = $err; $vals['cursada'] = $d;
        } elseif ($accion === 'examen') {
            [$err, $d] = validar_examen($_POST, $idsMaterias, $id);
            if (!$err) {
                guardar_examen($id, $d, $usuario['id_usuario']);
                flash('ok', 'Examen registrado.');
                redirigir($url);
            }
            $errores['examen'] = $err; $vals['examen'] = $d;
        } elseif ($accion === 'eliminar') {
            $tipo = campo($_POST, 'tipo');
            $idReg = ctype_digit(campo($_POST, 'id_reg')) ? (int)campo($_POST, 'id_reg') : 0;
            if ($idReg > 0 && eliminar_registro($tipo, $idReg, $id, $usuario['id_usuario'])) {
                flash('ok', 'Registro eliminado.');
            } else {
                flash('error', 'No se encontró el registro a eliminar.');
            }
            redirigir($url);
        }
    } catch (PDOException $ex) {
        error_log('Error en situación académica: ' . $ex->getMessage());
        flash('error', 'Ocurrió un error al guardar. No se realizaron cambios; intente nuevamente.');
        redirigir($url);
    }
}

$defaults = [
    'inscripcion' => ['id_materia' => '', 'fecha' => date('Y-m-d'), 'anio_cursada' => date('Y'), 'condicion' => 'Cursar', 'observaciones' => ''],
    'cursada'     => ['id_materia' => '', 'anio_cursada' => date('Y'), 'asistencia' => '', 'tp' => '', 'caracter' => 'Regular', 'promedio' => ''],
    'examen'      => ['id_materia' => '', 'tipo' => 'Regular', 'fecha' => '', 'nota' => '', 'libro' => '', 'folio' => '', 'observacion' => ''],
];
foreach ($defaults as $k => $def) {
    $vals[$k] = array_merge($def, $vals[$k]);
}

// Confirmación de eliminación (paso previo, sin JavaScript).
$confirmar = null;
if (isset($_GET['del']) && is_string($_GET['del']) && preg_match('/^(inscripcion|cursada|examen):(\d{1,9})$/', $_GET['del'], $mm)) {
    $desc = descripcion_registro($mm[1], (int)$mm[2], $id);
    if ($desc !== null) {
        $confirmar = ['tipo' => $mm[1], 'id' => (int)$mm[2], 'desc' => $desc];
    }
}

function select_materia(string $prefijo, array $materias, string $sel, array $err): void
{
    $id = 'f_' . $prefijo . 'id_materia';
    echo '<div class="campo' . (isset($err['id_materia']) ? ' campo-error' : '') . '">';
    echo '<label for="' . $id . '">Espacio curricular <span class="req">*</span></label>';
    echo '<select id="' . $id . '" name="id_materia" required><option value="">— Seleccione —</option>';
    $anioActual = 0;
    foreach ($materias as $m) {
        if ((int)$m['anio'] !== $anioActual) {
            if ($anioActual) { echo '</optgroup>'; }
            $anioActual = (int)$m['anio'];
            echo '<optgroup label="' . e(NOMBRES_ANIO[$anioActual] ?? ($anioActual . '.º AÑO')) . '">';
        }
        echo '<option value="' . (int)$m['id_materia'] . '"' . ((string)$m['id_materia'] === $sel ? ' selected' : '') . '>' . e($m['nombre']) . '</option>';
    }
    if ($anioActual) { echo '</optgroup>'; }
    echo '</select>';
    if (isset($err['id_materia'])) { echo '<small class="error-campo">' . e($err['id_materia']) . '</small>'; }
    echo '</div>';
}

function select_simple(string $prefijo, string $name, string $label, array $opciones, string $sel, array $err): void
{
    $id = 'f_' . $prefijo . $name;
    echo '<div class="campo' . (isset($err[$name]) ? ' campo-error' : '') . '">';
    echo '<label for="' . $id . '">' . e($label) . ' <span class="req">*</span></label>';
    echo '<select id="' . $id . '" name="' . e($name) . '" required>';
    foreach ($opciones as $o) {
        echo '<option value="' . e($o) . '"' . ($o === $sel ? ' selected' : '') . '>' . e($o) . '</option>';
    }
    echo '</select>';
    if (isset($err[$name])) { echo '<small class="error-campo">' . e($err[$name]) . '</small>'; }
    echo '</div>';
}

function resumen_errores(array $err): void
{
    if ($err) {
        echo '<div class="alerta error" role="alert"><strong>No se guardó. Revise:</strong><ul>';
        foreach ($err as $m) { echo '<li>' . e($m) . '</li>'; }
        echo '</ul></div>';
    }
}

function enlace_eliminar(int $id, string $tipo, int $idReg): string
{
    return '<a href="academico.php?id=' . $id . '&amp;del=' . e($tipo) . ':' . $idReg . '#confirmar">Eliminar</a>';
}

render_header('Situación académica: ' . $alumno['apellido'] . ', ' . $alumno['nombre'], $usuario);
?>
<div class="botones botones-arriba">
  <a class="btn btn-sec" href="ver.php?id=<?= $id ?>">Volver al expediente</a>
</div>
<p>DNI <?= e($alumno['dni']) ?> · <?= e($alumno['carrera']) ?> (<?= e($alumno['turno']) ?>)</p>

<?php if ($confirmar): ?>
<div class="alerta aviso" id="confirmar">
  <p><strong>¿Eliminar este registro?</strong> <?= e($confirmar['desc']) ?></p>
  <form method="post" action="<?= e($url) ?>" class="botones">
    <?= csrf_campo() ?>
    <input type="hidden" name="accion" value="eliminar">
    <input type="hidden" name="tipo" value="<?= e($confirmar['tipo']) ?>">
    <input type="hidden" name="id_reg" value="<?= (int)$confirmar['id'] ?>">
    <button type="submit" class="btn">Sí, eliminar</button>
    <a class="btn btn-sec" href="<?= e($url) ?>">Cancelar</a>
  </form>
</div>
<?php endif; ?>

<!-- ============ INSCRIPCIONES ============ -->
<section class="tarjeta">
  <h2>Registro de inscripciones para cursar y recursar</h2>
<?php $ins = listar_inscripciones($id); if ($ins): ?>
  <div class="tabla-wrap"><table class="tabla">
    <thead><tr><th>Fecha</th><th>Curso</th><th>Año</th><th>Condición</th><th>Observaciones</th><th></th></tr></thead>
    <tbody>
<?php foreach ($ins as $f): ?>
      <tr><td><?= e(fecha_ar($f['fecha'])) ?></td><td><?= e($f['materia']) ?></td><td><?= (int)$f['anio_cursada'] ?></td>
          <td><?= e($f['condicion']) ?></td><td><?= e($f['observaciones'] ?? '') ?></td>
          <td><?= enlace_eliminar($id, 'inscripcion', (int)$f['id_inscripcion']) ?></td></tr>
<?php endforeach; ?>
    </tbody></table></div>
<?php else: ?><p>Sin inscripciones registradas.</p><?php endif; ?>

  <h3>Agregar inscripción</h3>
  <?php resumen_errores($errores['inscripcion']); $v = $vals['inscripcion']; $er = $errores['inscripcion']; ?>
  <form method="post" action="<?= e($url) ?>" class="formulario">
    <?= csrf_campo() ?><input type="hidden" name="accion" value="inscripcion">
    <div class="fila">
      <?php campo_texto('fecha', 'Fecha de inscripción', $v, $er, ['prefijo' => 'ins_', 'type' => 'date', 'required' => true, 'max' => date('Y-m-d')]); ?>
      <?php select_materia('ins_', $materias, (string)$v['id_materia'], $er); ?>
    </div>
    <div class="fila">
      <?php campo_texto('anio_cursada', 'Año de cursada', $v, $er, ['prefijo' => 'ins_', 'type' => 'number', 'required' => true, 'min' => '2000', 'max' => (string)((int)date('Y') + 1)]); ?>
      <?php select_simple('ins_', 'condicion', 'Condición', CONDICIONES, (string)$v['condicion'], $er); ?>
      <?php campo_texto('observaciones', 'Observaciones', $v, $er, ['prefijo' => 'ins_', 'maxlength' => 200]); ?>
    </div>
    <div class="botones"><button type="submit" class="btn">Registrar inscripción</button></div>
  </form>
</section>

<!-- ============ CURSADAS ============ -->
<section class="tarjeta">
  <h2>Cursada por espacio curricular</h2>
<?php $cur = listar_cursadas($id); if ($cur): ?>
  <div class="tabla-wrap"><table class="tabla">
    <thead><tr><th>Espacio curricular</th><th>Año que cursó</th><th>% Asist.</th><th>% T.P.</th><th>Carácter</th><th>Promedio</th><th></th></tr></thead>
    <tbody>
<?php foreach ($cur as $f): ?>
      <tr><td><?= e($f['materia']) ?></td><td><?= (int)$f['anio_cursada'] ?></td>
          <td><?= e($f['asistencia'] ?? '') ?></td><td><?= e($f['tp'] ?? '') ?></td>
          <td><?= e($f['caracter']) ?></td><td><?= e(nota_fmt($f['promedio'])) ?></td>
          <td><?= enlace_eliminar($id, 'cursada', (int)$f['id_cursada']) ?></td></tr>
<?php endforeach; ?>
    </tbody></table></div>
<?php else: ?><p>Sin cursadas registradas.</p><?php endif; ?>

  <h3>Agregar o actualizar cursada</h3>
  <p class="ayuda">Si ya existe la cursada de ese espacio en ese año, se actualizan sus datos.</p>
  <?php resumen_errores($errores['cursada']); $v = $vals['cursada']; $er = $errores['cursada']; ?>
  <form method="post" action="<?= e($url) ?>" class="formulario">
    <?= csrf_campo() ?><input type="hidden" name="accion" value="cursada">
    <div class="fila">
      <?php select_materia('cur_', $materias, (string)$v['id_materia'], $er); ?>
      <?php campo_texto('anio_cursada', 'Año que cursó', $v, $er, ['prefijo' => 'cur_', 'type' => 'number', 'required' => true, 'min' => '2000', 'max' => (string)((int)date('Y') + 1)]); ?>
    </div>
    <div class="fila">
      <?php campo_texto('asistencia', '% Asistencia', $v, $er, ['prefijo' => 'cur_', 'type' => 'number', 'min' => '0', 'max' => '100']); ?>
      <?php campo_texto('tp', '% Trabajos prácticos', $v, $er, ['prefijo' => 'cur_', 'type' => 'number', 'min' => '0', 'max' => '100']); ?>
      <?php select_simple('cur_', 'caracter', 'Carácter', CARACTERES, (string)$v['caracter'], $er); ?>
      <?php campo_texto('promedio', 'Promedio', $v, $er, ['prefijo' => 'cur_', 'maxlength' => 5, 'inputmode' => 'decimal', 'ayuda' => 'De 0 a 10.']); ?>
    </div>
    <div class="botones"><button type="submit" class="btn">Guardar cursada</button></div>
  </form>
</section>

<!-- ============ EXÁMENES ============ -->
<section class="tarjeta">
  <h2>Exámenes finales</h2>
<?php $exs = listar_examenes($id); if ($exs): ?>
  <div class="tabla-wrap"><table class="tabla">
    <thead><tr><th>Espacio curricular</th><th>Tipo</th><th>Fecha</th><th>Calificación</th><th>Libro</th><th>Folio</th><th>Observación</th><th></th></tr></thead>
    <tbody>
<?php foreach ($exs as $f): ?>
      <tr><td><?= e($f['materia']) ?></td><td><?= e($f['tipo']) ?></td><td><?= e(fecha_ar($f['fecha'])) ?></td>
          <td><?= e(nota_fmt($f['nota'])) ?></td><td><?= e($f['libro']) ?></td><td><?= e($f['folio']) ?></td>
          <td><?= e($f['observacion'] ?? '') ?></td>
          <td><?= enlace_eliminar($id, 'examen', (int)$f['id_examen']) ?></td></tr>
<?php endforeach; ?>
    </tbody></table></div>
<?php else: ?><p>Sin exámenes registrados.</p><?php endif; ?>

  <h3>Agregar examen (un registro por intento)</h3>
  <p class="ayuda">Se considera aprobado desde <?= NOTA_APROBACION ?>. La ficha muestra hasta tres intentos por espacio y toma como definitivo el último aprobado.</p>
  <?php resumen_errores($errores['examen']); $v = $vals['examen']; $er = $errores['examen']; ?>
  <form method="post" action="<?= e($url) ?>" class="formulario">
    <?= csrf_campo() ?><input type="hidden" name="accion" value="examen">
    <div class="fila">
      <?php select_materia('exa_', $materias, (string)$v['id_materia'], $er); ?>
      <?php select_simple('exa_', 'tipo', 'Tipo de examen', TIPOS_EXAMEN, (string)$v['tipo'], $er); ?>
    </div>
    <div class="fila">
      <?php campo_texto('fecha', 'Fecha', $v, $er, ['prefijo' => 'exa_', 'type' => 'date', 'required' => true, 'max' => date('Y-m-d')]); ?>
      <?php campo_texto('nota', 'Calificación', $v, $er, ['prefijo' => 'exa_', 'required' => true, 'maxlength' => 5, 'inputmode' => 'decimal', 'ayuda' => 'De 0 a 10.']); ?>
      <?php campo_texto('libro', 'Libro', $v, $er, ['prefijo' => 'exa_', 'required' => true, 'maxlength' => 20]); ?>
      <?php campo_texto('folio', 'Folio', $v, $er, ['prefijo' => 'exa_', 'required' => true, 'maxlength' => 20]); ?>
    </div>
    <div class="fila">
      <?php campo_texto('observacion', 'Observación', $v, $er, ['prefijo' => 'exa_', 'maxlength' => 200]); ?>
    </div>
    <div class="botones"><button type="submit" class="btn">Registrar examen</button></div>
  </form>
</section>
<?php render_footer(); ?>
