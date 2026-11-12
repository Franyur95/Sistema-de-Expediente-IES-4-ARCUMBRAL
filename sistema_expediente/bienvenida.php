<?php
/* Pantalla pública de presentación. No modifica sesiones ni autenticación. */
require_once __DIR__ . '/includes/auth.php';
?>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Bienvenida · <?= e(APP_SIGLA) ?></title>
<link rel="stylesheet" href="css/estilos.css">
</head>
<body class="pagina-bienvenida">
<main class="bienvenida-contenido">
  <section class="bienvenida-panel" aria-labelledby="bienvenida-titulo">
    <img class="bienvenida-logo" src="img/logo-institucional.png" alt="Emblema institucional de Educación Física, Palpalá, Jujuy">
    <p class="bienvenida-institucion"><?= e(APP_NOMBRE) ?></p>
    <span class="bienvenida-separador" aria-hidden="true"></span>
    <h1 id="bienvenida-titulo">Sistema de Expedientes de Alumnos</h1>
    <p class="bienvenida-descripcion"></p>
    <a class="bienvenida-ingresar" href="login.php">Ingresar al sistema <span aria-hidden="true">→</span></a>
  </section>
</main>
<footer class="bienvenida-pie">Sistema de expedientes · Proyecto académico</footer>
</body>
</html>
