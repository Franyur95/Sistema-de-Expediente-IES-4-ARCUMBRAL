<?php

namespace App\Controllers;

use App\Models\AuditoriaModel;
use CodeIgniter\Controller;
use Config\Backup as BackupConfig;

/**
 * Módulo de backup — SOLO admin.
 */
class Backup extends Controller
{
    public function index()
    {
        $config = config(BackupConfig::class);

        $archivos = [];
        if (is_dir($config->outputDir)) {
            foreach (glob($config->outputDir . '*.sql') as $path) {
                $archivos[] = [
                    'nombre' => basename($path),
                    'fecha'  => date('Y-m-d H:i:s', filemtime($path)),
                    'tamano' => $this->formatearTamano(filesize($path)),
                ];
            }
            usort($archivos, static fn ($a, $b) => strcmp($b['fecha'], $a['fecha']));
        }

        return view('backup/index', [
            'titulo'   => 'Backups',
            'archivos' => $archivos,
        ]);
    }

    public function generar()
    {
        $config = config(BackupConfig::class);

        if (! is_dir($config->outputDir)) {
            if (! @mkdir($config->outputDir, 0775, true) && ! is_dir($config->outputDir)) {
                session()->setFlashdata('error', 'No se pudo crear la carpeta de backups.');
                return redirect()->to(site_url('backup'));
            }
        }

        $nombre = 'backup_' . date('Ymd_His') . '.sql';
        $ruta   = rtrim($config->outputDir, DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . $nombre;

        $db = \Config\Database::connect();
        $host    = $db->hostname;
        $usuario = $db->username;
        $clave   = $db->password;
        $base    = $db->database;

        $cmd = sprintf(
            '%s --user=%s --host=%s --single-transaction --routines --triggers %s > %s 2>&1',
            escapeshellarg($config->mysqldumpPath),
            escapeshellarg($usuario),
            escapeshellarg($host),
            escapeshellarg($base),
            escapeshellarg($ruta)
        );

        if (! empty($clave)) {
            putenv('MYSQL_PWD=' . $clave);
        }

        $salida = [];
        $codigo = 0;
        exec($cmd, $salida, $codigo);

        putenv('MYSQL_PWD');

        if ($codigo !== 0 || ! is_file($ruta) || filesize($ruta) === 0) {
            @unlink($ruta);
            log_message('error', 'Backup falló. Código: ' . $codigo . ' Salida: ' . implode("\n", $salida));
            session()->setFlashdata('error', 'No se pudo generar el backup. Revisá la ruta de mysqldump en .env.');
            return redirect()->to(site_url('backup'));
        }

        $this->rotar($config);

        (new AuditoriaModel())->registrar(
            (int) session()->get('id_usuario'),
            'backup',
            null,
            'INSERT',
            null,
            ['archivo' => $nombre, 'tamano' => filesize($ruta)]
        );

        session()->setFlashdata('exito', 'Backup generado: ' . $nombre);
        return redirect()->to(site_url('backup'));
    }

    public function descargar(string $archivo)
    {
        if (! preg_match('/^[A-Za-z0-9_.-]+\.sql$/', $archivo)) {
            session()->setFlashdata('error', 'Archivo inválido.');
            return redirect()->to(site_url('backup'));
        }

        $config = config(BackupConfig::class);
        $ruta = rtrim($config->outputDir, DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . $archivo;

        if (! is_file($ruta)) {
            session()->setFlashdata('error', 'Archivo no encontrado.');
            return redirect()->to(site_url('backup'));
        }

        return $this->response->download($ruta, null);
    }

    public function eliminar(string $archivo)
    {
        if (! preg_match('/^[A-Za-z0-9_.-]+\.sql$/', $archivo)) {
            session()->setFlashdata('error', 'Archivo inválido.');
            return redirect()->to(site_url('backup'));
        }

        $config = config(BackupConfig::class);
        $ruta = rtrim($config->outputDir, DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . $archivo;

        if (is_file($ruta)) {
            @unlink($ruta);
            (new AuditoriaModel())->registrar(
                (int) session()->get('id_usuario'),
                'backup',
                null,
                'DELETE',
                ['archivo' => $archivo],
                null
            );
            session()->setFlashdata('exito', 'Backup eliminado.');
        } else {
            session()->setFlashdata('error', 'Archivo no encontrado.');
        }

        return redirect()->to(site_url('backup'));
    }

    private function rotar(BackupConfig $config): void
    {
        $archivos = glob($config->outputDir . '*.sql') ?: [];
        if (count($archivos) <= $config->maxBackups) {
            return;
        }
        usort($archivos, static fn ($a, $b) => filemtime($a) - filemtime($b));
        $sobrantes = array_slice($archivos, 0, count($archivos) - $config->maxBackups);
        foreach ($sobrantes as $viejo) {
            @unlink($viejo);
        }
    }

    private function formatearTamano(int $bytes): string
    {
        if ($bytes < 1024) return $bytes . ' B';
        if ($bytes < 1048576) return round($bytes / 1024, 1) . ' KB';
        return round($bytes / 1048576, 2) . ' MB';
    }
}