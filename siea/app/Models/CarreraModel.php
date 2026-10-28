<?php

namespace App\Models;

use CodeIgniter\Model;

/**
 * Modelo de carreras.
 *
 * En este sistema (Palpalá) solo hay una carrera activa, pero el modelo
 * está preparado para futuras sedes. El turno de la carrera es lo que
 * usa TurnoFilter para validar a las preceptoras.
 */
class CarreraModel extends Model
{
    protected $table            = 'carreras';
    protected $primaryKey       = 'id_carrera';
    protected $useAutoIncrement = true;
    protected $returnType       = 'array';
    protected $useSoftDeletes   = false;
    protected $allowedFields    = ['nombre', 'turno', 'sede', 'resolucion', 'activa'];
    protected $useTimestamps    = false;

    /**
     * Devuelve las carreras activas.
     */
    public function activas(): array
    {
        return $this->where('activa', 1)
                    ->orderBy('nombre', 'ASC')
                    ->findAll();
    }

    /**
     * Devuelve el turno ('mañana'|'tarde'|null) de una carrera.
     */
    public function turnoDe(int $idCarrera): ?string
    {
        $c = $this->select('turno')->find($idCarrera);
        return $c['turno'] ?? null;
    }
}