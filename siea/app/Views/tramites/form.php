<?= $this->extend('layouts/base') ?>

<?= $this->section('contenido') ?>

<?php
$errores = session()->getFlashdata('errors') ?? [];
$old     = session()->getFlashdata('_ci_old_input')['old'] ?? [];
$valor = static function (string $campo) use ($old, $tramite, $est) {
    if (isset($old[$campo])) {
        return $old[$campo];
    }
    if (isset($tramite[$campo])) {
        return $tramite[$campo];
    }
    if ($campo === 'id_estudiante' && $est) {
        return $est['id_estudiante'];
    }
    return '';
};
?>
<div class="tarjeta">
    <h2>Nuevo trámite</h2>
    <?php if ($est) : ?>
        <p class="ayuda">
            Estudiante: <strong><?= esc($est['apellido'] . ', ' . $est['nombre']) ?></strong>
            (DNI <?= esc($est['dni']) ?>)
        </p>
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
            <label for="id_estudiante">ID Estudiante *</label>
            <input type="number" id="id_estudiante" name="id_estudiante" required
                   value="<?= esc($valor('id_estudiante')) ?>"
                   <?= $est ? 'readonly' : '' ?>>
            <span class="ayuda">Ingresá el ID del expediente. Si venías del detalle, se completa solo.</span>
        </div>

        <div class="campo">
            <label for="tipo">Tipo de trámite *</label>
            <select id="tipo" name="tipo" required>
                <?php
                $tipos = ['pase', 'asimilacion', 'equivalencia', 'nota_aprobacion'];
                $tipoActual = $valor('tipo');
                foreach ($tipos as $t) :
                ?>
                    <option value="<?= esc($t) ?>" <?= $tipoActual === $t ? 'selected' : '' ?>>
                        <?= esc($t) ?>
                    </option>
                <?php endforeach; ?>
            </select>
        </div>

        <div class="campo">
            <label for="fecha_solicitud">Fecha de solicitud *</label>
            <input type="date" id="fecha_solicitud" name="fecha_solicitud" required
                   value="<?= esc($valor('fecha_solicitud') ?: date('Y-m-d')) ?>">
        </div>

        <div class="campo">
            <label for="fecha_limite">Fecha límite</label>
            <input type="date" id="fecha_limite" name="fecha_limite"
                   value="<?= esc($valor('fecha_limite')) ?>">
            <span class="ayuda">Opcional. Para alertas del dashboard.</span>
        </div>

        <div class="campo ancho-completo">
            <label for="detalle">Detalle</label>
            <textarea id="detalle" name="detalle"><?= esc($valor('detalle')) ?></textarea>
        </div>

        <div class="acciones-form" style="width:100%;">
            <button type="submit" class="btn btn-primario">Registrar trámite</button>
            <a href="<?= site_url('tramites') ?>" class="btn btn-secundario">Cancelar</a>
        </div>
    </form>
</div>

<?= $this->endSection() ?>