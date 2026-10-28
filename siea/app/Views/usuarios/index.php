<?= $this->extend('layouts/base') ?>

<?= $this->section('contenido') ?>

<div class="tarjeta">
    <div style="display:flex;flex-wrap:wrap;justify-content:space-between;align-items:center;gap:.5rem;">
        <h2 style="margin:0;">Usuarios del sistema</h2>
        <a href="<?= site_url('usuarios/nuevo') ?>" class="btn btn-primario">+ Nuevo usuario</a>
    </div>
</div>

<?php if (empty($usuarios)) : ?>
    <div class="mensaje mensaje-info">No hay usuarios cargados.</div>
<?php else : ?>
    <div class="tabla-wrapper">
        <table class="tabla">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Nombre</th>
                    <th>Usuario</th>
                    <th>Rol</th>
                    <th>Turno</th>
                    <th>Estado</th>
                    <th class="acciones">Acciones</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($usuarios as $u) : ?>
                    <tr>
                        <td><?= esc($u['id_usuario']) ?></td>
                        <td><?= esc($u['nombre']) ?></td>
                        <td><?= esc($u['usuario']) ?></td>
                        <td><?= esc($u['rol']) ?></td>
                        <td><?= esc($u['turno']) ?></td>
                        <td>
                            <?php if ((int) $u['activo'] === 1) : ?>
                                <span class="etiqueta etiqueta-ok">Activo</span>
                            <?php else : ?>
                                <span class="etiqueta etiqueta-pend">Inactivo</span>
                            <?php endif; ?>
                        </td>
                        <td class="acciones">
                            <a href="<?= site_url('usuarios/editar/' . $u['id_usuario']) ?>" class="btn btn-secundario">Editar</a>
                            <?php if ((int) $u['activo'] === 1) : ?>
                                <form method="post" action="<?= site_url('usuarios/eliminar/' . $u['id_usuario']) ?>" style="display:inline;">
                                    <?= csrf_field() ?>
                                    <button type="submit" class="btn btn-peligro">Desactivar</button>
                                </form>
                            <?php else : ?>
                                <form method="post" action="<?= site_url('usuarios/reactivar/' . $u['id_usuario']) ?>" style="display:inline;">
                                    <?= csrf_field() ?>
                                    <button type="submit" class="btn btn-exito">Reactivar</button>
                                </form>
                            <?php endif; ?>
                        </td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
<?php endif; ?>

<?= $this->endSection() ?>