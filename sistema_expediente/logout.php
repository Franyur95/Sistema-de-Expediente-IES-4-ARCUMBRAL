<?php
require_once __DIR__ . '/includes/auth.php';

// Solo se cierra sesión con un envío POST válido (evita cierres por enlaces externos).
if ($_SERVER['REQUEST_METHOD'] === 'POST' && csrf_valido()) {
    cerrar_sesion();
    redirigir('login.php?salio=1');
}

redirigir('index.php');
