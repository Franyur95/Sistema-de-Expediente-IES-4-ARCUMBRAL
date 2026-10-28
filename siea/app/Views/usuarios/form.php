<?= $this->extend('layouts/base') ?>

<?= $this->section('contenido') ?>

<?php
$errores = session()->getFlashdata('errors') ?? [];
$old = session()->getFlashdata('_ci_old_input')['old'] ?? [];
?>
<div class="tarjeta">
    <h2><?= $esEdicion ? 'Editar usuario' : 'Nuevo usuario' ?></h2>

    <?php if (! empty($errores)) : ?>
        <div class="mensaje mensaje-error">
            <ul style="margin:0;padding-left:1rem;">
                <?php foreach ($errores as $err) : ?>
                    <li><?= esc($err) ?></li>
                <?php endforeach; ?>
            </ul>
        </div>
    <?php endif; ?>

    <form method="post" action="<?= esc($accion) ?>" class="formulario" novalidate>
        <?= csrf_field() ?>

        <div class="campo">
            <label for="nombre">Nombre completo</label>
            <input type="text" id="nombre" name="nombre" required
                   value="<?= esc($old['nombre'] ?? $usuario['nombre'] ?? '') ?>">
        </div>

        <div class="campo">
            <label for="usuario">Usuario</label>
            <input type="text" id="usuario" name="usuario" required
                   value="<?= esc($old['usuario'] ?? $usuario['usuario'] ?? '') ?>">
        </div>

        <div class="campo">
            <label for="clave">Contraseña <?= $esEdicion ? '(dejar vacío para no cambiar)' : '' ?></label>
            <input type="password" id="clave" name="clave" <?= $esEdicion ? '' : 'required' ?>>
            <span class="ayuda">Mínimo 6 caracteres. Se guarda hasheada con bcrypt.</span>
        </div>

        <div class="campo">
            <label for="rol">Rol</label>
            <select id="rol" name="rol" required>
                <?php
                $roles = ['admin', 'preceptora', 'coordinadora', 'vicerrectora'];
                $rolActual = $old['rol'] ?? $usuario['rol'] ?? '';
                foreach ($roles as $r) :
                ?>
                    <option value="<?= esc($r) ?>" <?= $rolActual === $r ? 'selected' : '' ?>>
                        <?= esc($r) ?>
                    </option>
                <?php endforeach; ?>
            </select>
        </div>

        <div class="campo">
            <label for="turno">Turno</label>
            <select id="turno" name="turno" required>
                <?php
                $turnos = ['mañana', 'tarde', 'ambos'];
                $turnoActual = $old['turno'] ?? $usuario['turno'] ?? 'ambos';
                foreach ($turnos as $t) :
                ?>
                    <option value="<?= esc($t) ?>" <?= $turnoActual === $t ? 'selected' : '' ?>>
                        <?= esc($t) ?>
                    </option>
                <?php endforeach; ?>
            </select>
            <span class="ayuda">Las preceptoras solo pueden modificar expedientes de su turno.</span>
        </div>

        <div class="campo">
            <label for="activo">Estado</label>
            <select id="activo" name="activo" required>
                <?php
                $activoActual = (string) ($old['activo'] ?? $usuario['activo'] ?? 1);
                ?>
                <option value="1" <?= $activoActual === '1' ? 'selected' : '' ?>>Activo</option>
                <option value="0" <?= $activoActual === '0' ? 'selected' : '' ?>>Inactivo</option>
            </select>
        </div>

        <div class="acciones-form" style="width:100%;">
            <button type="submit" class="btn btn-primario">
                <?= $esEdicion ? 'Guardar cambios' : 'Crear usuario' ?>
            </button>
            <a href="<?= site_url('usuarios') ?>" class="btn btn-secundario">Cancelar</a>
        </div>
    </form>
</div>

<?= $this->endSection() ?>