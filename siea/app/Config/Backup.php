<?php

namespace Config;

use CodeIgniter\Config\BaseConfig;

/**
 * Configuración del módulo de Backup.
 *
 * Lee del .env:
 *   backup.mysqldumpPath
 *   backup.outputDir
 */
class Backup extends BaseConfig
{
    /**
     * Ruta al ejecutable mysqldump.
     * XAMPP Windows: C:/xampp/mysql/bin/mysqldump.exe
     */
    public string $mysqldumpPath = 'C:/xampp/mysql/bin/mysqldump.exe';

    /**
     * Carpeta destino de los backups (fuera de public/).
     */
    public string $outputDir = WRITEPATH . 'backups/';

    /**
     * Cuántos backups conservar (rotación automática).
     */
    public int $maxBackups = 10;

    public function __construct()
    {
        parent::__construct();

        $env = env('backup.mysqldumpPath');
        if (! empty($env)) {
            $this->mysqldumpPath = (string) $env;
        }

        $env = env('backup.outputDir');
        if (! empty($env)) {
            $this->outputDir = (string) $env;
        }
    }
}