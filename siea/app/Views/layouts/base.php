<?php
/**
 * Layout base.
 *
 * Uso (patrón único):
 *   <?= $this->extend('layouts/base') ?>
 *   <?= $this->section('contenido') ?>...<?= $this->endSection() ?>
 */
$titulo = $titulo ?? 'S.I.E.A.';
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= esc($titulo) ?> — S.I.E.A.</title>
    <link rel="stylesheet" href="<?= base_url('css/estilo.css') ?>">
</head>
<body>

<?= $this->include('layouts/encabezado') ?>

<main class="contenido">
    <div class="contenedor">

        <?php if (session()->getFlashdata('exito')) : ?>
            <div class="mensaje mensaje-exito">
                <?= esc(session()->getFlashdata('exito')) ?>
            </div>
        <?php endif; ?>

        <?php if (session()->getFlashdata('error')) : ?>
            <div class="mensaje mensaje-error">
                <?= esc(session()->getFlashdata('error')) ?>
            </div>
        <?php endif; ?>

        <?php if (session()->getFlashdata('info')) : ?>
            <div class="mensaje mensaje-info">
                <?= esc(session()->getFlashdata('info')) ?>
            </div>
        <?php endif; ?>

        <?= $this->renderSection('contenido') ?>

    </div>
</main>

</body>
</html>