<?php
/*
 * Plantilla común (cabecera, pie y página de error).
 * Las funciones e(), flash_html(), csrf_campo() y puede_editar() están en auth.php.
 */

function render_header(string $titulo, ?array $usuario = null): void
{
    $paginaActual = basename(parse_url($_SERVER['REQUEST_URI'] ?? '', PHP_URL_PATH) ?: '');
    ?>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><?= e($titulo) ?> · <?= e(APP_SIGLA) ?></title>
<link rel="stylesheet" href="css/estilos.css">
</head>
<body class="<?= $usuario ? 'layout-sistema' : 'pagina-login' ?>">
<?php if ($usuario): ?>
<aside class="menu-lateral">
  <div class="titulo-sistema">Sistema de expedientes de Alumnos</div>
  <nav class="menu" aria-label="Menú principal">
    <a href="index.php" <?= in_array($paginaActual, ['', 'index.php'], true) ? 'class="activo" aria-current="page"' : '' ?>><span class="nav-icon" aria-hidden="true">⌂</span>Inicio</a>
<?php if (puede_ver_expedientes($usuario) && puede_editar($usuario)): ?>
    <a href="nuevo.php" <?= $paginaActual === 'nuevo.php' ? 'class="activo" aria-current="page"' : '' ?>><span class="nav-icon" aria-hidden="true">＋</span>Nuevo expediente</a>
<?php endif; ?>
<?php if (puede_ver_expedientes($usuario)): ?>
    <a href="buscar.php" <?= $paginaActual === 'buscar.php' ? 'class="activo" aria-current="page"' : '' ?>><span class="nav-icon" aria-hidden="true">⌕</span>Buscar alumnos</a>
    <a href="reportes.php" <?= $paginaActual === 'reportes.php' ? 'class="activo" aria-current="page"' : '' ?>><span class="nav-icon" aria-hidden="true">▤</span>Reportes</a>
<?php endif; ?>
<?php if (tiene_permiso($usuario, 'usuarios.ver')): ?>
    <a href="usuarios.php" <?= $paginaActual === 'usuarios.php' ? 'class="activo" aria-current="page"' : '' ?>><span class="nav-icon" aria-hidden="true">♙</span>Usuarios</a>
<?php endif; ?>
    <a href="cambiar_clave.php" <?= $paginaActual === 'cambiar_clave.php' ? 'class="activo" aria-current="page"' : '' ?>><span class="nav-icon" aria-hidden="true">♧</span>Mi contraseña</a>
    <form method="post" action="logout.php" class="form-inline">
      <?= csrf_campo() ?>
      <button type="submit" class="btn-link"><span class="nav-icon" aria-hidden="true">⇥</span>Salir</button>
    </form>
  </nav>
</aside>
<?php endif; ?>
<header class="barra">
  <div class="contenedor barra-interna">
    <a class="marca" href="index.php">
      <span class="marca-emblema"><img src="img/logo-institucional.png" alt="Logo institucional"></span>
      <span class="marca-nombre"><?= e(APP_NOMBRE) ?><small></small></span>
    </a>
<?php if ($usuario): ?>
<span class="usuario">
  <span aria-hidden="true">●</span>
  <span>Usuario: <?= e($usuario['nombre']) ?></span>
  <span aria-hidden="true">⌄</span>
</span><?php endif; ?>
  </div>
</header>
<main class="contenedor">
<?php if ($titulo !== 'Inicio'): ?>
    <h1><?= e($titulo) ?></h1>
<?php endif; ?><?= flash_html() ?>
<?php
}

function render_footer(): void
{
    ?>
</main>
<footer class="pie">
  <div class="contenedor"><?= e(APP_NOMBRE) ?> · Sistema de expedientes · Proyecto académico</div>
</footer>
</body>
</html>
<?php
}

/** Muestra una página de error (403, 404…) y termina la ejecución. */
function pagina_error(int $codigo, string $titulo, string $mensaje, ?array $usuario = null): void
{
    http_response_code($codigo);
    render_header($titulo, $usuario);
    echo '<div class="alerta error">' . e($mensaje) . '</div>';
    echo '<p><a class="btn btn-sec" href="index.php">Volver al inicio</a></p>';
    render_footer();
    exit;
}
