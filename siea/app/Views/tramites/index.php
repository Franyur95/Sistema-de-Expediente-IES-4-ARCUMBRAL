<?= $this->extend('layouts/base') ?>

<?= $this->section('contenido') ?>

<div class="tarjeta">
    <div style="display:flex;flex-wrap:wrap;justify-content:space-between;align-items:center;gap:.5rem;">
        <h2 style="margin:0;">Trámites</h2>
        <?php if ($puedeCargar) : ?>
            <a href="<?= site_url('tramites/nuevo') ?>" class="btn btn-primario">+ Nuevo trámite</a>
        <?php endif; ?>
    </div>
</div>

<?php if (empty($tramites)) : ?>
    <div class="mensaje mensaje-info">No hay trámites registrados.</div>
<?php else : ?>
    <div class="tabla-wrapper">
        <table class="tabla">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Estudiante</th>
                    <th>Tipo</th>
                    <th>Solicitud</th>
                    <th>Límite</th>
                    <th>Estado</th>
                    <th>Resolución</th>
                    <th class="acciones">Acciones</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($tramites as $t) : ?>
                    <?php
                    $estadoClase = match ($t['estado']) {
                        'resuelto'  => 'etiqueta-ok',
                        'rechazado' => 'etiqueta-vencida',
                        default     => 'etiqueta-pend',
                    };
                    ?>
                    <tr>
                        <td><?= esc($t['id_tramite']) ?></td>
                        <td>
                            <?= esc($t['apellido'] . ', ' . $t['nombre']) ?>
                            <br><small>DNI <?= esc($t['dni']) ?></small>
                        </td>
                        <td><?= esc($t['tipo']) ?></td>
                        <td><?= esc($t['fecha_solicitud']) ?></td>
                        <td>
                            <?= esc($t['fecha_limite'] ?? '—') ?>
                            <?php if (! empty($t['fecha_limite']) && $t['fecha_limite'] < date('Y-m-d') && $t['estado'] === 'en_curso') : ?>
                                <br><small style="color:#e74c3c;">vencido</small>
                            <?php endif; ?>
                        </td>
                        <td><span class="etiqueta <?= esc($estadoClase) ?>"><?= esc($t['estado']) ?></span></td>
                        <td><?= esc($t['resolucion_nro'] ?? '—') ?></td>
                        <td class="acciones">
                            <a href="<?= site_url('estudiantes/' . $t['id_estudiante']) ?>" class="btn btn-secundario">Ver</a>
                            <?php if ($puedeResolver && $t['estado'] === 'en_curso') : ?>
                                <a href="<?= site_url('tramites/resolver/' . $t['id_tramite']) ?>" class="btn btn-primario">Resolver</a>
                            <?php endif; ?>
                        </td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
<?php endif; ?>

<?= $this->endSection() ?>