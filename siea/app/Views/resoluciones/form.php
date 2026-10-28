<?= $this->extend('layouts/base') ?>

<?= $this->section('contenido') ?>

<?php
$errores = session()->getFlashdata('errors') ?? [];
$old     = session()->getFlashdata('_ci_old_input')['old'] ?? [];
$valor = static function (string $campo) use ($old, $resolucion) {
    return $old[$campo] ?? $resolucion[$campo] ?? '';
};
?>
<div class="tarjeta">
    <h2><?= $esEdicion ? 'Editar resolución' : 'Nueva resolución' ?></h2>
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
            <label for="nro">Número *</label>
            <input type="text" id="nro" name="nro" required
                   value="<?= esc($valor('nro')) ?>">
            <span class="ayuda">Ej: 13929-E-19</span>
        </div>

        <div class="campo">
            <label for="fecha">Fecha *</label>
            <input type="date" id="fecha" name="fecha" required
                   value="<?= esc($valor('fecha') ?: date('Y-m-d')) ?>">
        </div>

        <div class="campo">
            <label for="tipo">Tipo *</label>
            <select id="tipo" name="tipo" required>
                <?php
                $tipos = ['asimilacion', 'equivalencia', 'pase', 'nota_aprobacion'];
                $tipoActual = $valor('tipo');
                foreach ($tipos as $t) :
                ?>
                    <option value="<?= esc($t) ?>" <?= $tipoActual === $t ? 'selected' : '' ?>>
                        <?= esc($t) ?>
                    </option>
                <?php endforeach; ?>
            </select>
        </div>

        <div class="campo ancho-completo">
            <label for="observaciones">Observaciones</label>
            <textarea id="observaciones" name="observaciones"><?= esc($valor('observaciones')) ?></textarea>
        </div>

        <div class="acciones-form" style="width:100%;">
            <button type="submit" class="btn btn-primario">
                <?= $esEdicion ? 'Guardar cambios' : 'Crear resolución' ?>
            </button>
            <a href="<?= site_url('resoluciones') ?>" class="btn btn-secundario">Cancelar</a>
        </div>
    </form>
</div>

<?= $this->endSection() ?>