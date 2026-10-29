<?php
/*
 * Formulario de expediente (compartido por nuevo.php y editar.php).
 */

function campo_texto(string $name, string $label, array $d, array $err, array $o = []): void
{
    $tipo = $o['type'] ?? 'text';
    $id = 'f_' . ($o['prefijo'] ?? '') . $name;
    $clase = 'campo' . (isset($err[$name]) ? ' campo-error' : '');

    echo '<div class="' . $clase . '">';
    echo '<label for="' . $id . '">' . e($label) . (!empty($o['required']) ? ' <span class="req" title="Obligatorio">*</span>' : '') . '</label>';
    echo '<input type="' . e($tipo) . '" id="' . $id . '" name="' . e($name) . '" value="' . e($d[$name] ?? '') . '"';
    if (!empty($o['required']))  { echo ' required'; }
    if (isset($o['maxlength']))  { echo ' maxlength="' . (int)$o['maxlength'] . '"'; }
    if (isset($o['inputmode']))  { echo ' inputmode="' . e($o['inputmode']) . '"'; }
    if (isset($o['min']))        { echo ' min="' . e($o['min']) . '"'; }
    if (isset($o['max']))        { echo ' max="' . e($o['max']) . '"'; }
    if (isset($o['autocomplete'])) { echo ' autocomplete="' . e($o['autocomplete']) . '"'; }
    echo '>';
    if (!empty($o['ayuda'])) {
        echo '<small class="ayuda">' . e($o['ayuda']) . '</small>';
    }
    if (isset($err[$name])) {
        echo '<small class="error-campo">' . e($err[$name]) . '</small>';
    }
    echo '</div>';
}

function render_form_estudiante(array $d, array $err, array $carreras, array $tipos, array $docs, string $action, string $boton, string $cancelar): void
{
    if ($err) {
        echo '<div class="alerta error" role="alert"><strong>No se guardó el expediente. Revise lo siguiente:</strong><ul>';
        foreach ($err as $mensaje) {
            echo '<li>' . e($mensaje) . '</li>';
        }
        echo '</ul></div>';
    }
    ?>
<form method="post" action="<?= e($action) ?>" class="formulario">
  <?= csrf_campo() ?>
  <p class="nota">Los campos marcados con <span class="req">*</span> son obligatorios.</p>

  <fieldset>
    <legend>Datos personales</legend>
    <div class="fila">
      <?php campo_texto('apellido', 'Apellidos', $d, $err, ['required' => true, 'maxlength' => 50, 'autocomplete' => 'off']); ?>
      <?php campo_texto('nombre', 'Nombres', $d, $err, ['required' => true, 'maxlength' => 50, 'autocomplete' => 'off']); ?>
    </div>
    <div class="fila">
      <?php campo_texto('dni', 'L.E. / L.C. / D.N.I. N.º', $d, $err, ['required' => true, 'maxlength' => 12, 'inputmode' => 'numeric', 'ayuda' => 'Solo números, sin puntos.', 'autocomplete' => 'off']); ?>
      <?php campo_texto('fecha_nacimiento', 'Fecha de nacimiento', $d, $err, ['type' => 'date', 'required' => true, 'max' => date('Y-m-d')]); ?>
    </div>
    <div class="fila">
      <?php campo_texto('lugar_nacimiento', 'Nació en', $d, $err, ['maxlength' => 80]); ?>
      <?php campo_texto('telefono', 'Teléfono', $d, $err, ['type' => 'tel', 'maxlength' => 40, 'inputmode' => 'tel']); ?>
    </div>
    <div class="fila">
      <?php campo_texto('domicilio', 'Domicilio', $d, $err, ['maxlength' => 120]); ?>
    </div>
  </fieldset>

  <fieldset>
    <legend>Ingreso</legend>
    <div class="fila">
      <?php campo_texto('titulo_ingreso', 'Título con el que ingresó', $d, $err, ['required' => true, 'maxlength' => 100]); ?>
      <?php campo_texto('establecimiento', 'Establecimiento que lo otorga', $d, $err, ['required' => true, 'maxlength' => 100]); ?>
    </div>
    <div class="fila">
      <?php campo_texto('anio_ingreso', 'Año de ingreso', $d, $err, ['type' => 'number', 'required' => true, 'min' => '1980', 'max' => (string)((int)date('Y') + 1), 'inputmode' => 'numeric']); ?>

      <div class="campo<?= isset($err['id_carrera']) ? ' campo-error' : '' ?>">
        <label for="f_id_carrera">Carrera <span class="req" title="Obligatorio">*</span></label>
        <select id="f_id_carrera" name="id_carrera" required>
          <option value="">— Seleccione —</option>
<?php foreach ($carreras as $c): ?>
          <option value="<?= (int)$c['id_carrera'] ?>"<?= (string)$c['id_carrera'] === (string)$d['id_carrera'] ? ' selected' : '' ?>><?= e($c['nombre']) ?> (<?= e($c['turno']) ?>)</option>
<?php endforeach; ?>
        </select>
        <?php if (isset($err['id_carrera'])): ?><small class="error-campo"><?= e($err['id_carrera']) ?></small><?php endif; ?>
      </div>

      <div class="campo<?= isset($err['estado']) ? ' campo-error' : '' ?>">
        <label for="f_estado">Estado del alumno <span class="req" title="Obligatorio">*</span></label>
        <select id="f_estado" name="estado" required>
<?php foreach (ESTADOS as $est): ?>
          <option value="<?= e($est) ?>"<?= $est === $d['estado'] ? ' selected' : '' ?>><?= e($est) ?></option>
<?php endforeach; ?>
        </select>
        <?php if (isset($err['estado'])): ?><small class="error-campo"><?= e($err['estado']) ?></small><?php endif; ?>
      </div>
    </div>
  </fieldset>

<?php if ($tipos): ?>
  <fieldset>
    <legend>Documentación presentada</legend>
    <div class="tabla-wrap">
      <table class="tabla">
        <thead>
          <tr><th>Documento</th><th>Presentado</th><th>Fecha de presentación</th><th>Observaciones</th></tr>
        </thead>
        <tbody>
<?php foreach ($tipos as $t): $id = (int)$t['id_tipo']; $x = $docs[$id]; ?>
          <tr class="<?= isset($err['doc_' . $id]) ? 'fila-error' : '' ?>">
            <td><?= e($t['nombre']) ?><?= $t['obligatorio'] ? ' <span class="badge">Obligatorio</span>' : '' ?></td>
            <td class="centro">
              <input type="checkbox" id="dp_<?= $id ?>" name="doc_presentado[<?= $id ?>]" value="1"<?= $x['presentado'] ? ' checked' : '' ?>>
              <label for="dp_<?= $id ?>" class="oculto">Presentado: <?= e($t['nombre']) ?></label>
            </td>
            <td>
              <label for="df_<?= $id ?>" class="oculto">Fecha: <?= e($t['nombre']) ?></label>
              <input type="date" id="df_<?= $id ?>" name="doc_fecha[<?= $id ?>]" value="<?= e($x['fecha']) ?>" max="<?= e(date('Y-m-d')) ?>">
            </td>
            <td>
              <label for="do_<?= $id ?>" class="oculto">Observaciones: <?= e($t['nombre']) ?></label>
              <input type="text" id="do_<?= $id ?>" name="doc_obs[<?= $id ?>]" value="<?= e($x['obs']) ?>" maxlength="255">
            </td>
          </tr>
<?php endforeach; ?>
        </tbody>
      </table>
    </div>
    <small class="ayuda">Si marca un documento como presentado y deja la fecha vacía, se usa la fecha de hoy.</small>
  </fieldset>
<?php endif; ?>

  <fieldset>
    <legend>Observaciones</legend>
    <div class="campo<?= isset($err['observaciones']) ? ' campo-error' : '' ?>">
      <label for="f_observaciones" class="oculto">Observaciones</label>
      <textarea id="f_observaciones" name="observaciones" rows="4" maxlength="2000"><?= e($d['observaciones']) ?></textarea>
      <?php if (isset($err['observaciones'])): ?><small class="error-campo"><?= e($err['observaciones']) ?></small><?php endif; ?>
    </div>
  </fieldset>

  <div class="botones">
    <button type="submit" class="btn"><?= e($boton) ?></button>
    <a class="btn btn-sec" href="<?= e($cancelar) ?>">Cancelar</a>
  </div>
</form>
<?php
}
