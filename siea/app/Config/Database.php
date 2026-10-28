<?php

namespace Config;

use CodeIgniter\Database\Config;

/**
 * Configuración de la base de datos.
 *
 * Los valores reales se definen en el archivo .env (que NO se sube al repo).
 * Aquí solo dejamos la estructura y un "default" apuntando a MySQLi porque
 * XAMPP usa MySQL/MariaDB. Esto lo lee CI4 automáticamente.
 */
class Database extends Config
{
    /**
     * Grupo de conexión por defecto.
     */
    public string $defaultGroup = 'default';

    /**
     * Conexión principal (XAMPP local).
     * Los valores reales vienen del .env; estos son apenas el fallback.
     */
    public array $default = [
        'DSN'          => '',
        'hostname'     => 'localhost',
        'username'     => 'root',
        'password'     => '',
        'database'     => 'ies4_expedientes',
        'DBDriver'     => 'MySQLi',
        'DBPrefix'     => '',
        'pConnect'     => false,
        'DBDebug'      => true,
        'charset'      => 'utf8mb4',
        'DBCollat'     => 'utf8mb4_general_ci',
        'swapPre'      => '',
        'encrypt'      => false,
        'compress'     => false,
        'strictOn'     => false,
        'failover'     => [],
        'port'         => 3306,
        'numberNative' => false,
        'foundRows'    => false,
        'dateFormat'   => [
            'date'     => 'Y-m-d',
            'datetime' => 'Y-m-d H:i:s',
            'time'     => 'H:i:s',
        ],
    ];

    /**
     * Conexión de tests (no usada en XAMPP, pero CI4 la requiere).
     */
    public array $tests = [
        'DSN'      => '',
        'hostname' => '127.0.0.1',
        'username' => '',
        'password' => '',
        'database' => 'ci4',
        'DBDriver' => 'SQLite3',
        'DBPrefix' => 'db_',
        'pConnect' => false,
        'DBDebug'  => true,
        'charset'  => 'utf8',
        'DBCollat' => 'utf8_general_ci',
        'swapPre'  => '',
        'encrypt'  => false,
        'compress' => false,
        'strictOn' => false,
        'failover' => [],
        'port'     => 3306,
    ];
}