<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ingreso — S.I.E.A.</title>
    <link rel="stylesheet" href="<?= base_url('css/estilo.css') ?>">
</head>
<body>
<div class="login-wrapper">
    <div class="login-card">
        <h2>S.I.E.A.</h2>
        <p class="subtitulo">Instituto de Educación Superior N.º 4<br>“Raúl Scalabrini Ortiz” — Palpalá</p>

        <?php if (session()->getFlashdata('error')) : ?>
            <div class="mensaje mensaje-error">
                <?= esc(session()->getFlashdata('error')) ?>
            </div>
        <?php endif; ?>

        <?php if (session()->getFlashdata('exito')) : ?>
            <div class="mensaje mensaje-exito">
                <?= esc(session()->getFlashdata('exito')) ?>
            </div>
        <?php endif; ?>

        <?php if (isset($errors) && ! empty($errors)) : ?>
            <div class="mensaje mensaje-error">
                <ul style="margin:0;padding-left:1rem;">
                    <?php foreach ($errors as $err) : ?>
                        <li><?= esc($err) ?></li>
                    <?php endforeach; ?>
                </ul>
            </div>
        <?php endif; ?>

        <form method="post" action="<?= site_url('login') ?>" class="formulario" novalidate>
            <?= csrf_field() ?>

            <div class="campo ancho-completo">
                <label for="usuario">Usuario</label>
                <input type="text" id="usuario" name="usuario" required autofocus
                       value="<?= esc(old('usuario')) ?>">
            </div>

            <div class="campo ancho-completo">
                <label for="clave">Contraseña</label>
                <input type="password" id="clave" name="clave" required>
            </div>

            <div class="acciones-form" style="width:100%;">
                <button type="submit" class="btn btn-primario btn-bloque">Ingresar</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>