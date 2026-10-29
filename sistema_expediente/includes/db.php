<?php
/*
 * Conexión a MySQL mediante PDO (consultas preparadas).
 */

function db(): PDO
{
    static $pdo = null;

    if ($pdo === null) {
        $dsn = 'mysql:host=' . DB_HOST . ';port=' . DB_PORT . ';dbname=' . DB_NAME . ';charset=' . DB_CHARSET;
        try {
            $pdo = new PDO($dsn, DB_USER, DB_PASS, [
                PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES   => false,
            ]);
        } catch (PDOException $ex) {
            error_log('Error de conexión: ' . $ex->getMessage());
            http_response_code(500);
            echo 'No se pudo conectar con la base de datos. '
               . 'Verifique que MySQL esté iniciado en XAMPP y revise config/config.php.';
            if (DEBUG) {
                echo '<br><small>' . htmlspecialchars($ex->getMessage(), ENT_QUOTES, 'UTF-8') . '</small>';
            }
            exit;
        }
    }

    return $pdo;
}
