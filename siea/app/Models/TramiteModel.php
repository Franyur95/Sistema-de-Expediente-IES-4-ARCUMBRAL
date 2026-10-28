<?php

namespace App\Models;

use CodeIgniter\Model;

/**
 * Modelo de trámites.
 */
class TramiteModel extends Model
{
    protected $table            = 'tramites';
    protected $primaryKey       = 'id_tramite';
    protected $useAutoIncrement = true;
    protected $returnType       = 'array';
    protected $useSoftDeletes   = false;

    protected $allowedFields = [
        'id_estudiante',
        'tipo',
        'fecha_solicitud',
        'fecha_limite',
        'estado',
        'id_resolucion',
        'detalle',
    ];

    protected $useTimestamps = false;

    protected $validationRules = [
        'id_estudiante'   => 'required|is_natural_no_zero',
        'tipo'            => 'required|in_list[pase,asimilacion,equivalencia,nota_aprobacion]',
        'fecha_solicitud' => 'required|valid_date[Y-m-d]',
        'fecha_limite'    => 'permit_empty|valid_date[Y-m-d]',
    ];

    public function listar(?string $turnoRestringido = null, int $limit = 100): array
    {
        $builder = $this->db->table('tramites t')
            ->select('t.id_tramite, t.tipo, t.fecha_solicitud, t.fecha_limite,
                     t.estado, t.detalle, t.id_resolucion,
                     e.apellido, e.nombre, e.dni, e.id_estudiante,
                     c.turno, r.nro AS resolucion_nro')
            ->join('estudiantes e', 'e.id_estudiante = t.id_estudiante', 'inner')
            ->join('carreras c', 'c.id_carrera = e.id_carrera', 'inner')
            ->join('resoluciones r', 'r.id_resolucion = t.id_resolucion', 'left')
            ->orderBy('t.fecha_solicitud', 'DESC')
            ->limit($limit);

        if ($turnoRestringido !== null && $turnoRestringido !== 'ambos') {
            $builder->where('c.turno', $turnoRestringido);
        }

        return $builder->get()->getResultArray();
    }

    public function conEstudiante(int $id): ?array
    {
        return $this->db->table('tramites t')
            ->select('t.*, e.apellido, e.nombre, e.dni, e.id_carrera, e.estado AS estado_estudiante,
                     c.turno, c.nombre AS carrera_nombre')
            ->join('estudiantes e', 'e.id_estudiante = t.id_estudiante', 'inner')
            ->join('carreras c', 'c.id_carrera = e.id_carrera', 'inner')
            ->where('t.id_tramite', $id)
            ->get()
            ->getRowArray();
    }

    public function contarPorVencer(int $dias = 7): int
    {
        $hoy = date('Y-m-d');
        $limite = date('Y-m-d', strtotime("+{$dias} days"));

        return (int) $this->where('estado', 'en_curso')
            ->where('fecha_limite IS NOT NULL')
            ->where('fecha_limite >=', $hoy)
            ->where('fecha_limite <=', $limite)
            ->countAllResults();
    }
}