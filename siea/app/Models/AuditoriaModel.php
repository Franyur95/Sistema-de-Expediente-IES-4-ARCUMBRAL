<?php

namespace App\Models;

use CodeIgniter\Model;

/**
 * Modelo de auditoría.
 *
 * Registra cada acción sensible del sistema:
 *   INSERT / UPDATE / DELETE / LOGIN / LOGOUT
 * con snapshot anterior y nuevo en JSON.
 *
 * REGLA: NO se registran contraseñas ni datos sensibles en los JSON.
 * El controlador es responsable de filtrar esos campos antes de llamar.
 */
class AuditoriaModel extends Model
{
    protected $table            = 'auditoria';
    protected $primaryKey       = 'id_auditoria';
    protected $useAutoIncrement = true;
    protected $returnType       = 'array';
    protected $useSoftDeletes   = false;

    protected $allowedFields = [
        'id_usuario',
        'tabla',
        'registro_id',
        'accion',
        'datos_anteriores',
        'datos_nuevos',
        'fecha',
    ];

    // fecha la maneja la DB con DEFAULT CURRENT_TIMESTAMP, pero igual
    // la seteamos desde PHP para asegurar consistencia.
    protected $useTimestamps = false;

    /**
     * Registra una acción de auditoría.
     *
     * @param int|null    $idUsuario       Usuario que ejecuta la acción.
     * @param string      $tabla           Tabla afectada (o 'auth' para login/logout).
     * @param int|null    $registroId      PK del registro afectado.
     * @param string      $accion          INSERT|UPDATE|DELETE|LOGIN|LOGOUT
     * @param array|null  $datosAnteriores Snapshot previo (o null).
     * @param array|null  $datosNuevos     Snapshot nuevo (o null).
     */
    public function registrar(
        ?int $idUsuario,
        string $tabla,
        ?int $registroId,
        string $accion,
        ?array $datosAnteriores = null,
        ?array $datosNuevos = null
    ): void {
        $this->insert([
            'id_usuario'       => $idUsuario,
            'tabla'            => $tabla,
            'registro_id'      => $registroId,
            'accion'           => $accion,
            'datos_anteriores' => $datosAnteriores !== null
                                    ? json_encode($datosAnteriores, JSON_UNESCAPED_UNICODE)
                                    : null,
            'datos_nuevos'     => $datosNuevos !== null
                                    ? json_encode($datosNuevos, JSON_UNESCAPED_UNICODE)
                                    : null,
            'fecha'            => date('Y-m-d H:i:s'),
        ]);
    }
}