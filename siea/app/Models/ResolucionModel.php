<?php

namespace App\Models;

use CodeIgniter\Model;

/**
 * Modelo de resoluciones.
 */
class ResolucionModel extends Model
{
    protected $table            = 'resoluciones';
    protected $primaryKey       = 'id_resolucion';
    protected $useAutoIncrement = true;
    protected $returnType       = 'array';
    protected $useSoftDeletes   = false;

    protected $allowedFields = [
        'nro',
        'fecha',
        'tipo',
        'observaciones',
    ];

    protected $useTimestamps = false;

    protected $validationRules = [
        'nro'   => 'required|max_length[50]',
        'fecha' => 'required|valid_date[Y-m-d]',
        'tipo'  => 'required|in_list[asimilacion,equivalencia,pase,nota_aprobacion]',
    ];

    protected $validationMessages = [
        'nro' => [
            'required' => 'El número de resolución es obligatorio.',
        ],
    ];

    public function listarTodas(): array
    {
        return $this->orderBy('fecha', 'DESC')
                    ->orderBy('id_resolucion', 'DESC')
                    ->findAll();
    }

    public function existe(string $nro, string $tipo, ?int $excluirId = null): bool
    {
        $builder = $this->where('nro', $nro)->where('tipo', $tipo);
        if ($excluirId !== null) {
            $builder->where('id_resolucion !=', $excluirId);
        }
        return $builder->countAllResults() > 0;
    }
}