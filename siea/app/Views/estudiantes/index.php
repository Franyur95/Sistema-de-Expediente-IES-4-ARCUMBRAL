<?= $this->extend('layouts/base') ?>

<?= $this->section('contenido') ?>

<div class="tarjeta">
    <div style="display:flex;flex-wrap:wrap;justify-content:space-between;align-items:center;gap:.5rem;">
        <h2 style="margin:0;">Estudiantes</h2>
        <div style="display:flex;gap:.5rem;flex-wrap:wrap;">
            <a href="<?= site_url('estudiantes/buscar') ?>" class="btn btn-secundario">Buscar</a>
            <?php if ($puedeEditar) : ?>
                <a href="<?= site_url('estudiantes/nuevo') ?>" class="btn btn-primario">+ Nuevo expediente</a>
            <?php endif; ?>
        </div>
    </div>
</div>

<?php if (empty($estudiantes)) : ?>
    <div class="mensaje mensaje-info">No hay expedientes cargados.</div>
<?php else : ?>
    <div class="tabla-wrapper">
        <table class="tabla">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Apellido y nombre</th>
                    <th>DNI</th>
                    <th>Carrera / Turno</th>
                    <th>Estado</th>
                    <th class="acciones">Acciones</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($estudiantes as $e) : ?>
                    <tr>
                        <td><?= esc($e['id_estudiante']) ?></td>
                        <td><?= esc($e['apellido'] . ', ' . $e['nombre']) ?></td>
                        <td><?= esc($e['dni']) ?></td>
                        <td><?= esc($e['carrera']) ?><br><small>(<?= esc($e['turno']) ?>)</small></td>
                        <td><?= esc($e['estado']) ?></td>
                        <td class="acciones">
                            <a href="<?= site_url('estudiantes/' . $e['id_estudiante']) ?>"
                               class="btn btn-secundario">Ver</a>
                        </td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
<?php endif; ?>

<?= $this->endSection() ?>