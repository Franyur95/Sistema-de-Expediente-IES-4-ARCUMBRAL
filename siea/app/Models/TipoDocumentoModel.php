<?php

namespace App\Models;

use CodeIgniter\Model;

/**
 * Modelo de tipos de documento del checklist.
 *
 * Seeds: DNI, Título o constancia, Carnet sanitario,
 * Planilla prontuarial, Apto físico, Seguro SEMED.
 */
class TipoDocumentoModel extends Model
{
    protected $table            = 'tipos_documento';
    protected $primaryKey       = 'id_tipo';
    protected $useAutoIncrement = true;
    protected $returnType       = 'array';
    protected $useSoftDeletes   = false;
    protected $allowedFields    = ['nombre', 'obligatorio', 'vence', 'orden'];
    protected $useTimestamps    = false;

    /**
     * Devuelve todos los tipos ordenados.
     */
    public function ordenados(): array
    {
        return $this->orderBy('orden', 'ASC')->findAll();
    }
}