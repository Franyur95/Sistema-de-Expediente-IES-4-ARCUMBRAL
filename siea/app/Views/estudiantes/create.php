<?= $this->extend('layouts/base') ?>

<?= $this->section('contenido') ?>

<div class="tarjeta">
    <h2>Nuevo expediente</h2>
    <p class="ayuda">Al guardar se crean automáticamente las 6 filas del checklist documental en estado pendiente.</p>
</div>

<?= view('estudiantes/_form', [
    'est'       => null,
    'carreras'  => $carreras,
    'accion'    => site_url('estudiantes/nuevo'),
    'esEdicion' => false,
]) ?>

<?= $this->endSection() ?>