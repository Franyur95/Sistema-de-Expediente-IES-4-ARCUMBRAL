<?= $this->extend('layouts/base') ?>

<?= $this->section('contenido') ?>

<?php
$errores = session()->getFlashdata('errors') ?? [];
?>
<div class="tarjeta">
    <h2>Resolver trámite #<?= esc($tramite['id_tramite']) ?></h2>
    <p>
        <strong><?= esc($tramite['apellido'] . ', ' . $tramite['nombre']) ?></strong>
        (DNI <?= esc($tramite['dni']) ?>)<br>
        Tipo: <strong><?= esc($tramite['tipo']) ?></strong> —
        Solicitado: <?= esc($tramite['fecha_solicitud']) ?>
        <?php if (! empty($tramite['fecha_limite'])) : ?>
            — Límite: <?= esc($tramite['fecha_limite']) ?>
        <?php endif; ?>
    </p>
    <?php if (! empty($tramite['detalle'])) : ?>
        <p><em><?= nl2br(esc($tramite['detalle'])) ?></em></p>
    <?php endif; ?>
</div>

<?php if (! empty($errores)) : ?>
    <div class="mensaje mensaje-error">
        <ul style="margin:0;padding-left:1rem;">
            <?php foreach ($errores as $err) : ?>
                <li><?= esc($err) ?></li>
            <?php endforeach; ?>
        </ul>
    </div>
<?php endif; ?>

<div class="tarjeta">
    <form method="post" action="<?= esc($accion) ?>" class="formulario" novalidate>
        <?= csrf_field() ?>

        <div class="campo">
            <label for="estado">Resultado *</label>
            <select id="estado" name="estado" required>
                <option value="resuelto">Resuelto</option>
                <option value="rechazado">Rechazado</option>
            </select>
        </div>

        <div class="campo">
            <label for="id_resolucion">Resolución asociada</label>
            <select id="id_resolucion" name="id_resolucion">
                <option value="">— Sin resolución —</option>
                <?php foreach ($resoluciones as $r) : ?>
                    <option value="<?= esc($r['id_resolucion']) ?>">
                        <?= esc($r['nro']) ?> (<?= esc($r['tipo']) ?>, <?= esc($r['fecha']) ?>)
                    </option>
                <?php endforeach; ?>
            </select>
            <span class="ayuda">Obligatoria si el resultado es "Resuelto".</span>
        </div>

        <?php if ($tramite['tipo'] === 'pase') : ?>
            <div class="campo">
                <label for="id_carrera_destino">Carrera destino (pase)</label>
                <select id="id_carrera_destino" name="id_carrera_destino">
                    <option value="">— No cambiar —</option>
                    <?php foreach ($carreras as $c) : ?>
                        <option value="<?= esc($c['id_carrera']) ?>"
                            <?= (int) $c['id_carrera'] === (int) $tramite['id_carrera'] ? 'disabled' : '' ?>>
                            <?= esc($c['nombre']) ?> (<?= esc($c['turno']) ?>)
                            <?= (int) $c['id_carrera'] === (int) $tramite['id_carrera'] ? '— actual' : '' ?>
                        </option>
                    <?php endforeach; ?>
                </select>
                <span class="ayuda">Si elegís una carrera, el estudiante pasa a esa carrera y queda en estado "pase".</span>
            </div>
        <?php endif; ?>

        <div class="campo ancho-completo">
            <label for="detalle">Observaciones</label>
            <textarea id="detalle" name="detalle"><?= esc($tramite['detalle']) ?></textarea>
        </div>

        <div class="acciones-form" style="width:100%;">
            <button type="submit" class="btn btn-primario">Guardar resolución</button>
            <a href="<?= site_url('tramites') ?>" class="btn btn-secundario">Cancelar</a>
        </div>
    </form>
</div>

<?= $this->endSection() ?>