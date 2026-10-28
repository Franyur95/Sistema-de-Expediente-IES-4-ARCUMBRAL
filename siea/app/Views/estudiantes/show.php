<?= $this->extend('layouts/base') ?>

<?= $this->section('contenido') ?>

<?php
$id = $est['id_estudiante'];
?>
<div class="tarjeta">
    <div style="display:flex;flex-wrap:wrap;justify-content:space-between;align-items:center;gap:.5rem;">
        <h2 style="margin:0;">
            <?= esc($est['apellido'] . ', ' . $est['nombre']) ?>
            <small style="font-size:.8rem;color:#5d6d7e;">DNI <?= esc($est['dni']) ?></small>
        </h2>
        <div style="display:flex;gap:.5rem;flex-wrap:wrap;">
            <a href="<?= site_url('estudiantes') ?>" class="btn btn-secundario">Volver</a>
            <?php if ($puedeEditar) : ?>
                <a href="<?= site_url('estudiantes/editar/' . $id) ?>" class="btn btn-primario">Editar</a>
            <?php endif; ?>
            <?php if ($puedeCertificar) : ?>
                <form method="post" action="<?= site_url('estudiantes/' . $id . '/certificar') ?>" style="display:inline;">
                    <?= csrf_field() ?>
                    <button type="submit" class="btn btn-exito">
                        <?= ! empty($est['certificado_por']) ? 'Volver a certificar' : 'Certificar' ?>
                    </button>
                </form>
            <?php endif; ?>
        </div>
    </div>
</div>

<div class="tarjeta">
    <h3>Datos personales y académicos</h3>
    <table class="tabla">
        <tbody>
            <tr><th style="width:220px;">DNI</th><td><?= esc($est['dni']) ?></td></tr>
            <tr><th>Fecha de nacimiento</th><td><?= esc($est['fecha_nacimiento']) ?></td></tr>
            <tr><th>Lugar de nacimiento</th><td><?= esc($est['lugar_nacimiento'] ?? '—') ?></td></tr>
            <tr><th>Domicilio</th><td><?= esc($est['domicilio'] ?? '—') ?></td></tr>
            <tr><th>Teléfono</th><td><?= esc($est['telefono'] ?? '—') ?></td></tr>
            <tr><th>Email</th><td><?= esc($est['email'] ?? '—') ?></td></tr>
            <tr><th>Título de ingreso</th><td><?= esc($est['titulo_ingreso'] ?? '—') ?> (<?= esc($est['tipo_titulo'] ?? '—') ?>)</td></tr>
            <tr><th>Establecimiento</th><td><?= esc($est['establecimiento'] ?? '—') ?></td></tr>
            <tr><th>Año de ingreso</th><td><?= esc($est['anio_ingreso'] ?? '—') ?></td></tr>
            <tr><th>Carrera</th><td><?= esc($est['carrera_nombre']) ?> <small>(<?= esc($est['carrera_turno']) ?>)</small></td></tr>
            <tr><th>Estado</th><td><?= esc($est['estado']) ?></td></tr>
            <tr><th>Observaciones</th><td><?= nl2br(esc($est['observaciones'] ?? '—')) ?></td></tr>
        </tbody>
    </table>
</div>

<?php if (! empty($est['certificado_por'])) : ?>
    <div class="tarjeta">
        <h3>Certificación</h3>
        <p>
            Expediente certificado por
            <strong><?= esc($est['certificador_nombre'] ?? 'usuario eliminado') ?></strong>
            (<?= esc($est['certificador_rol'] ?? '—') ?>)
            el <strong><?= esc($est['fecha_certificacion']) ?></strong>.
        </p>
    </div>
<?php endif; ?>

<div class="tarjeta">
    <h3>Checklist documental</h3>
    <?php if (empty($checklist)) : ?>
        <div class="mensaje mensaje-alerta">No hay documentación registrada. Revisá la carga inicial.</div>
    <?php else : ?>
        <ul class="checklist">
            <?php foreach ($checklist as $fila) : ?>
                <?php
                $estado = $fila['estado'];
                $etiqueta = match ($estado) {
                    'ok'      => ['etiqueta-ok', 'Presentado'],
                    'vencido' => ['etiqueta-vencida', 'Vencido'],
                    default   => ['etiqueta-pend', 'Pendiente'],
                };
                ?>
                <li>
                    <div>
                        <strong><?= esc($fila['nombre']) ?></strong>
                        <?php if ((int) $fila['obligatorio'] === 1) : ?>
                            <small style="color:#e74c3c;">(obligatorio)</small>
                        <?php endif; ?>
                        <?php if (! empty($fila['fecha_vencimiento'])) : ?>
                            <br><small>Vence: <?= esc($fila['fecha_vencimiento']) ?></small>
                        <?php endif; ?>
                        <?php if (! empty($fila['observaciones'])) : ?>
                            <br><small><?= esc($fila['observaciones']) ?></small>
                        <?php endif; ?>
                    </div>
                    <span class="etiqueta <?= esc($etiqueta[0]) ?>"><?= esc($etiqueta[1]) ?></span>
                </li>
            <?php endforeach; ?>
        </ul>
    <?php endif; ?>

    <?php if ($puedeEditar) : ?>
        <h4 class="mt-3">Actualizar documento</h4>
        <form method="post" action="<?= site_url('estudiantes/' . $id . '/documento') ?>" class="formulario">
            <?= csrf_field() ?>
            <div class="campo">
                <label for="id_tipo">Documento</label>
                <select id="id_tipo" name="id_tipo" required>
                    <?php foreach ($checklist as $fila) : ?>
                        <option value="<?= esc($fila['id_tipo']) ?>"><?= esc($fila['nombre']) ?></option>
                    <?php endforeach; ?>
                </select>
            </div>
            <div class="campo">
                <label for="presentado">Estado</label>
                <select id="presentado" name="presentado">
                    <option value="1">Presentado</option>
                    <option value="0">Pendiente</option>
                </select>
            </div>
            <div class="campo">
                <label for="fecha_presentacion">Fecha presentación</label>
                <input type="date" id="fecha_presentacion" name="fecha_presentacion">
            </div>
            <div class="campo">
                <label for="fecha_vencimiento">Fecha vencimiento</label>
                <input type="date" id="fecha_vencimiento" name="fecha_vencimiento">
            </div>
            <div class="campo ancho-completo">
                <label for="observaciones">Observaciones</label>
                <input type="text" id="observaciones" name="observaciones">
            </div>
            <div class="acciones-form" style="width:100%;">
                <button type="submit" class="btn btn-primario">Guardar documento</button>
            </div>
        </form>
    <?php endif; ?>
</div>

<?= $this->endSection() ?>