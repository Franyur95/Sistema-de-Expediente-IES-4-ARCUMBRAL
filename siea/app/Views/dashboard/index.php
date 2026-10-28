<?= $this->extend('layouts/base') ?>

<?= $this->section('contenido') ?>

<div class="tarjeta">
    <h2>Panel principal</h2>
    <p>
        Bienvenido/a, <strong><?= esc(session()->get('nombre')) ?></strong>.
        Tu rol es <strong><?= esc(session()->get('rol')) ?></strong>
        <?php if (session()->get('turno') && session()->get('turno') !== 'ambos') : ?>
            y tu turno es <strong><?= esc(session()->get('turno')) ?></strong>
        <?php endif; ?>.
    </p>
    <p class="ayuda">Seleccioná una opción del menú para comenzar.</p>
</div>

<?php if (! empty($alertas)) : ?>
    <?php foreach ($alertas as $a) : ?>
        <div class="mensaje <?= $a['tipo'] === 'error' ? 'mensaje-error' : 'mensaje-alerta' ?>">
            <?= esc($a['texto']) ?>
            <a href="<?= site_url($a['url']) ?>" style="margin-left:.5rem;">Ver →</a>
        </div>
    <?php endforeach; ?>
<?php endif; ?>

<?php if (empty($menu)) : ?>
    <div class="mensaje mensaje-alerta">
        No hay opciones de menú disponibles para tu rol. Contactá al administrador.
    </div>
<?php else : ?>
    <nav class="menu-grid" aria-label="Menú principal">
        <?php foreach ($menu as $item) : ?>
            <a class="menu-item" href="<?= site_url($item['url']) ?>">
                <span class="titulo"><?= esc($item['titulo']) ?></span>
                <span class="descripcion"><?= esc($item['descripcion']) ?></span>
            </a>
        <?php endforeach; ?>
    </nav>
<?php endif; ?>

<?= $this->endSection() ?>