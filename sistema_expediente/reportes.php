<?php
require_once __DIR__ . '/includes/auth.php';
require_once __DIR__ . '/includes/estudiantes.php';
require_once __DIR__ . '/includes/reportes.php';

$usuario = require_login();
exigir_permiso($usuario, 'expedientes.ver');

$filtros = reporte_filtros($usuario);
$carreras = carreras_permitidas($usuario);
$alumnos = reporte_alumnos($filtros, REPORTE_MAX_SELECCION);
$urlListado = reporte_url_listado($filtros);
$resumen = reporte_resumen_filtros($filtros);

render_header('Reportes e impresión', $usuario);
?>

<section class="tarjeta">
  <h2>Filtros del reporte</h2>

  <form method="get" action="reportes.php" class="formulario">
    <div class="fila">
      <div class="campo">
        <label for="q">Apellido, nombre o DNI</label>
        <input type="search" id="q" name="q" value="<?= e($filtros['q']) ?>" maxlength="50">
      </div>

      <div class="campo">
        <label for="carrera">Carrera</label>
        <select id="carrera" name="carrera">
          <option value="">Todas las carreras</option>
          <?php foreach ($carreras as $c): ?>
            <option value="<?= (int)$c['id_carrera'] ?>"
              <?= $filtros['id_carrera'] === (int)$c['id_carrera'] ? 'selected' : '' ?>>
              <?= e($c['nombre']) ?> (<?= e($c['turno']) ?>)
            </option>
          <?php endforeach; ?>
        </select>
        <?php if (($usuario['id_carrera'] ?? null) !== null): ?>
          <small class="ayuda">Su usuario está limitado a su carrera asignada.</small>
        <?php endif; ?>
      </div>

      <div class="campo">
        <label for="estado">Estado</label>
        <select id="estado" name="estado">
          <option value="">Todos</option>
          <?php foreach (ESTADOS as $estado): ?>
            <option value="<?= e($estado) ?>"
              <?= $filtros['estado'] === $estado ? 'selected' : '' ?>>
              <?= e(ucfirst($estado)) ?>
            </option>
          <?php endforeach; ?>
        </select>
      </div>

      <div class="campo">
        <label for="anio">Año de ingreso</label>
        <input type="number" id="anio" name="anio" min="1980"
               max="<?= (int)date('Y') + 1 ?>"
               value="<?= $filtros['anio'] ?: '' ?>" inputmode="numeric">
      </div>
    </div>

    <div class="botones">
      <button type="submit" class="btn">Aplicar filtros</button>
      <a class="btn btn-sec" href="<?= e($urlListado) ?>" target="_blank" rel="noopener">
        Listado imprimible
      </a>
    </div>
  </form>

  <p class="ayuda">
    Filtros actuales: <?= e($resumen) ?>.
  </p>
</section>

<section class="tarjeta">
  <h2>Planillas individuales</h2>

  <p class="ayuda">
    Seleccione uno o más alumnos y presione <strong>Imprimir planillas seleccionadas</strong>.
    Cada planilla se imprime en una hoja horizontal y, si elige varios alumnos,
    cada uno comienza en una página nueva.
  </p>

  <?php if ($alumnos): ?>
    <form method="get" action="imprimir.php" target="_blank">
      <div class="tabla-wrap">
        <table class="tabla">
          <thead>
            <tr>
              <th class="centro"><span class="oculto">Seleccionar</span></th>
              <th>Apellido y nombre</th>
              <th>DNI</th>
              <th>Carrera</th>
              <th>Año ingreso</th>
              <th>Estado</th>
              <th>Documentación</th>
              <th>Planilla</th>
            </tr>
          </thead>
          <tbody>
            <?php foreach ($alumnos as $a): ?>
              <tr>
                <td class="centro">
                  <input type="checkbox" name="ids[]"
                         value="<?= (int)$a['id_estudiante'] ?>"
                         aria-label="Seleccionar a <?= e($a['apellido'] . ', ' . $a['nombre']) ?>">
                </td>
                <td><?= e($a['apellido']) ?>, <?= e($a['nombre']) ?></td>
                <td><?= e($a['dni']) ?></td>
                <td><?= e($a['carrera']) ?> (<?= e($a['turno']) ?>)</td>
                <td><?= (int)$a['anio_ingreso'] ?></td>
                <td><?= e(ucfirst($a['estado'])) ?></td>
                <td>
                  <?= (int)$a['faltan'] === 0
                      ? 'Completa'
                      : 'Faltan ' . (int)$a['faltan'] ?>
                </td>
                <td>
                  <a href="imprimir.php?id=<?= (int)$a['id_estudiante'] ?>"
                     target="_blank" rel="noopener">Ver</a>
                </td>
              </tr>
            <?php endforeach; ?>
          </tbody>
        </table>
      </div>

      <div class="botones">
        <button type="submit" class="btn">Imprimir planillas seleccionadas</button>
        <button type="button" class="btn btn-sec"
                data-seleccionar-todos data-estado="ninguno">Seleccionar todos</button>
      </div>
    </form>
  <?php else: ?>
    <div class="alerta aviso">No se encontraron alumnos con esos filtros.</div>
  <?php endif; ?>

  <p class="ayuda">
    <?= count($alumnos) ?> alumno(s) mostrado(s) con los filtros actuales.
    <?php if (count($alumnos) >= REPORTE_MAX_SELECCION): ?>
      Se muestran hasta <?= REPORTE_MAX_SELECCION ?> alumnos; refine la búsqueda para ver el resto.
    <?php endif; ?>
  </p>
</section>

<script src="js/reportes.js"></script>
<?php render_footer(); ?>
