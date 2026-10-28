<?= $this->extend('layouts/base') ?>

<?= $this->section('contenido') ?>

<div class="tarjeta">
    <h2>Editar expediente</h2>
    <p class="ayuda">
        Expediente de <strong><?= esc($est['apellido'] . ', ' . $est['nombre']) ?></strong>
        (DNI <?= esc($est['dni']) ?>).
    </p>
</div>

<?= view('estudiantes/_form', [
    'est'       => $est,
    'carreras'  => $carreras,
    'accion'    => site_url('estudiantes/editar/' . $est['id_estudiante']),
    'esEdicion' => true,
]) ?>

<?= $this->endSection() ?>