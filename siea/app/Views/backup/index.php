<?= $this->extend('layouts/base') ?>

<?= $this->section('contenido') ?>

<div class="tarjeta">
    <div style="display:flex;flex-wrap:wrap;justify-content:space-between;align-items:center;gap:.5rem;">
        <h2 style="margin:0;">Backups de la base</h2>
        <form method="post" action="<?= site_url('backup/generar') ?>" style="display:inline;">
            <?= csrf_field() ?>
            <button type="submit" class="btn btn-primario">+ Generar backup ahora</button>
        </form>
    </div>
    <p class="ayuda">
        Los backups se guardan en <code>writable/backups/</code> (fuera de la carpeta pública).
        Se conservan los últimos 10.
    </p>
</div>

<?php if (empty($archivos)) : ?>
    <div class="mensaje mensaje-info">No hay backups generados todavía.</div>
<?php else : ?>
    <div class="tabla-wrapper">
        <table class="tabla">
            <thead>
                <tr>
                    <th>Archivo</th>
                    <th>Fecha</th>
                    <th>Tamaño</th>
                    <th class="acciones">Acciones</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($archivos as $a) : ?>
                    <tr>
                        <td><code><?= esc($a['nombre']) ?></code></td>
                        <td><?= esc($a['fecha']) ?></td>
                        <td><?= esc($a['tamano']) ?></td>
                        <td class="acciones">
                            <a href="<?= site_url('backup/descargar/' . $a['nombre']) ?>" class="btn btn-secundario">Descargar</a>
                            <form method="post" action="<?= site_url('backup/eliminar/' . $a['nombre']) ?>" style="display:inline;">
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