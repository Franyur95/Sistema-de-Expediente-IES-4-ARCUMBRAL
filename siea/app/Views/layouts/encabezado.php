<?php
/**
 * Encabezado común para todas las vistas privadas.
 *
 * Se incluye desde layouts/base.php con:
 *   <?= $this->include('layouts/encabezado') ?>
 *
 * Muestra: título del sistema, nombre del usuario, rol y botón de salir.
 */
?>
<header class="encabezado">
    <div class="contenedor">
        <h1>S.I.E.A. — IES N.º 4 “Raúl Scalabrini Ortiz”</h1>
        <div class="usuario">
            <span>
                <?= esc(session()->get('nombre') ?? '') ?>
                <small>(<?= esc(session()->get('rol') ?? '') ?>)</small>
            </span>
            <a href="<?= site_url('logout') ?>" class="btn btn-peligro">Salir</a>
        </div>
    </div>
</header>