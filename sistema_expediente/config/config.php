<?php
/*
 * Configuración general del sistema.
 * Ajuste estos valores según su instalación de XAMPP / MySQL.
 */

// --- Base de datos ---
define('DB_HOST', 'localhost');
define('DB_PORT', '3306');
define('DB_NAME', 'sistema_expediente');
define('DB_USER', 'root');   // En XAMPP por defecto: root
define('DB_PASS', '');       // En XAMPP por defecto: vacía
define('DB_CHARSET', 'utf8mb4');

// --- Aplicación ---
define('APP_NOMBRE', 'Instituto de Educación Superior N.º 4');
define('APP_SIGLA', 'IES N.º 4');
define('SESION_MINUTOS', 30);   // Cierre automático por inactividad
define('POR_PAGINA', 15);       // Filas por página en la búsqueda

// Poner en true SOLO mientras se desarrolla, para ver detalles de errores.
define('DEBUG', false);

date_default_timezone_set('America/Argentina/Jujuy');
