<?= $this->extend('layouts/base') ?>

<?= $this->section('contenido') ?>

<div class="tarjeta">
    <h2>Auditoría</h2>
    <p class="ayuda">Últimos 200 movimientos registrados en el sistema.</p>

    <form method="get" action="<?= site_url('auditoria') ?>" class="formulario">
        <div class="campo">
            <label for="tabla">Tabla</label>
            <select id="tabla" name="tabla">
                <option value="">— Todas —</option>
                <?php foreach ($tablas as $t) : ?>
                    <option value="<?= esc($t) ?>" <?= $filtroTabla === $t ? 'selected' : '' ?>>
                        <?= esc($t) ?>
                    </option>
                <?php endforeach; ?>
            </select>
        </div>

        <div class="campo">
            <label for="accion">Acción</label>
            <select id="accion" name="accion">
                <option value="">— Todas —</option>
                <?php foreach (['INSERT','UPDATE','DELETE','LOGIN','LOGOUT'] as $a) : ?>
                    <option value="<?= esc($a) ?>" <?= $filtroAccion === $a ? 'selected' : '' ?>>
                        <?= esc($a) ?>
                    </option>
                <?php endforeach; ?>
            </select>
        </div>

        <div class="campo">
            <label for="usuario">Usuario</label>
            <input type="text" id="usuario" name="usuario"
                   value="<?= esc($filtroUsuario) ?>" placeholder="usuario o nombre">
        </div>

        <div class="acciones-form" style="align-self:flex-end;">
            <button type="submit" class="btn btn-primario">Filtrar</button>
            <a href="<?= site_url('auditoria') ?>" class="btn btn-secundario">Limpiar</a>
        </div>
    </form>
</div>

<?php if (empty($registros)) : ?>
    <div class="mensaje mensaje-info">No hay movimientos registrados.</div>
<?php else : ?>
    <div class="tabla-wrapper">
        <table class="tabla">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Fecha</th>
                    <th>Usuario</th>
                    <th>Tabla</th>
                    <th>Registro</th>
                    <th>Acción</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($registros as $r) : ?>
                    <tr>
                        <td><?= esc($r['id_auditoria']) ?></td>
                        <td><?= esc($r['fecha']) ?></td>
                        <td>
                            <?= esc($r['usuario_nombre'] ?? '—') ?>
                            <?php if (! empty($r['usuario'])) : ?>
                                <br><small>(<?= esc($r['usuario']) ?>)</small>
                            <?php endif; ?>
                        </td>
                        <td><?= esc($r['tabla']) ?></td>
                        <td><?= esc($r['registro_id'] ?? '—') ?></td>
                        <td><?= esc($r['accion']) ?></td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
<?php endif; ?>

<?= $this->endSection() ?>