<?php
/*
 * Plantilla común (cabecera, pie y página de error).
 * Las funciones e(), flash_html(), csrf_campo() y puede_editar() están en auth.php.
 */

function render_header(string $titulo, ?array $usuario = null): void
{
    ?>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><?= e($titulo) ?> · <?= e(APP_SIGLA) ?></title>
<link rel="stylesheet" href="css/estilos.css">
</head>
<body>
<header class="barra">
  <div class="contenedor barra-interna">
    <a class="marca" href="index.php"><?= e(APP_NOMBRE) ?><small>Sistema de expedientes de alumnos</small></a>
<?php if ($usuario): ?>
    <nav class="menu" aria-label="Menú principal">
      <a href="index.php">Inicio</a>
<?php if (puede_ver_expedientes($usuario) && puede_editar($usuario)): ?>
      <a href="nuevo.php">Nuevo expediente</a>
<?php endif; ?>
<?php if (puede_ver_expedientes($usuario)): ?>
      <a href="buscar.php">Buscar alumnos</a>
<?php endif; ?>
<?php if (tiene_permiso($usuario, 'usuarios.ver')): ?>
      <a href="usuarios.php">Usuarios</a>
<?php endif; ?>
      <a href="cambiar_clave.php">Mi contraseña</a>
      <span class="usuario"><?= e($usuario['nombre']) ?> (<?= e($usuario['rol']) ?>)</span>
      <form method="post" action="logout.php" class="form-inline">
        <?= csrf_campo() ?>
        <button type="submit" class="btn-link">Salir</button>
      </form>
    </nav>
<?php endif; ?>
  </div>
</header>
<main class="contenedor">
<h1><?= e($titulo) ?></h1>
<?= flash_html() ?>
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
