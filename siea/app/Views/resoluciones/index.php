<?= $this->extend('layouts/base') ?>

<?= $this->section('contenido') ?>

<div class="tarjeta">
    <div style="display:flex;flex-wrap:wrap;justify-content:space-between;align-items:center;gap:.5rem;">
        <h2 style="margin:0;">Resoluciones</h2>
        <a href="<?= site_url('resoluciones/nuevo') ?>" class="btn btn-primario">+ Nueva resolución</a>
    </div>
</div>

<?php if (empty($resoluciones)) : ?>
    <div class="mensaje mensaje-info">No hay resoluciones cargadas.</div>
<?php else : ?>
    <div class="tabla-wrapper">
        <table class="tabla">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Número</th>
                    <th>Fecha</th>
                    <th>Tipo</th>
                    <th>Observaciones</th>
                    <th class="acciones">Acciones</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($resoluciones as $r) : ?>
                    <tr>
                        <td><?= esc($r['id_resolucion']) ?></td>
                        <td><strong><?= esc($r['nro']) ?></strong></td>
                        <td><?= esc($r['fecha']) ?></td>
                        <td><?= esc($r['tipo']) ?></td>
                        <td><?= esc($r['observaciones'] ?? '—') ?></td>
                        <td class="acciones">
                            <a href="<?= site_url('resoluciones/editar/' . $r['id_resolucion']) ?>" class="btn btn-secundario">Editar</a>
                            <form method="post" action="<?= site_url('resoluciones/eliminar/' . $r['id_resolucion']) ?>" style="display:inline;">
                                <?= csrf_field() ?>
                                <button type="submit" class="btn btn-peligro">Eliminar</button>
                            </form>
                        </td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
<?php endif; ?>

<?= $this->endSection() ?>