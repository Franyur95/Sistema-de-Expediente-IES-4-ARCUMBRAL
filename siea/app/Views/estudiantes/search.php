<?= $this->extend('layouts/base') ?>

<?= $this->section('contenido') ?>

<div class="tarjeta">
    <h2>Buscar estudiante</h2>
    <form method="get" action="<?= site_url('estudiantes/buscar') ?>" class="formulario">
        <div class="campo" style="flex:1 1 300px;">
            <label for="q">Apellido o DNI</label>
            <input type="text" id="q" name="q" value="<?= esc($termino) ?>" autofocus>
        </div>
        <div class="acciones-form" style="align-self:flex-end;">
            <button type="submit" class="btn btn-primario">Buscar</button>
        </div>
    </form>
</div>

<?php if ($termino !== '') : ?>
    <?php if (empty($resultados)) : ?>
        <div class="mensaje mensaje-info">No se encontraron resultados para “<?= esc($termino) ?>”.</div>
    <?php else : ?>
        <div class="tabla-wrapper">
            <table class="tabla">
                <thead>
                    <tr>
                        <th>Apellido y nombre</th>
                        <th>DNI</th>
                        <th>Carrera / Turno</th>
                        <th>Estado</th>
                        <th class="acciones">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($resultados as $r) : ?>
                        <tr>
                            <td><?= esc($r['apellido'] . ', ' . $r['nombre']) ?></td>
                            <td><?= esc($r['dni']) ?></td>
                            <td><?= esc($r['carrera']) ?> <small>(<?= esc($r['turno']) ?>)</small></td>
                            <td><?= esc($r['estado']) ?></td>
                            <td class="acciones">
                                <a href="<?= site_url('estudiantes/' . $r['id_estudiante']) ?>"
                                   class="btn btn-secundario">Ver</a>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>
    <?php endif; ?>
<?php endif; ?>

<?= $this->endSection() ?>