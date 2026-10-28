<?php

namespace App\Models;

use CodeIgniter\Model;

/**
 * Modelo de estudiantes (expedientes).
 *
 * Cada estudiante es un expediente único. El DNI es único en la DB.
 *
 * IMPORTANTE (CI 4.7):
 *   - En insert(), la regla is_unique NO puede llevar el tercer parámetro
 *     {id_estudiante} porque el placeholder no se reemplaza en insert.
 *   - En update(), sí se puede usar {id_estudiante} porque el framework
 *     lo reemplaza con el valor del campo en $datos.
 *   - Por eso definimos $validationRules (insert) y $validationRulesUpdate
 *     (update) por separado, y elegimos según corresponda.
 */
class EstudianteModel extends Model
{
    protected $table            = 'estudiantes';
    protected $primaryKey       = 'id_estudiante';
    protected $useAutoIncrement = true;
    protected $returnType       = 'array';
    protected $useSoftDeletes   = false;

    protected $allowedFields = [
    'dni', 'apellido', 'nombre', 'fecha_nacimiento', 'lugar_nacimiento',
    'domicilio', 'telefono', 'email', 'titulo_ingreso', 'tipo_titulo',
    'establecimiento', 'anio_ingreso', 'observaciones', 'estado', 'id_carrera',
    'certificado_por', 'fecha_certificacion',
];

    protected $useTimestamps = true;
    protected $createdField  = 'created_at';
    protected $updatedField  = 'updated_at';

    /**
     * Reglas para INSERT.
     * is_unique SIN tercer parámetro.
     */
    protected $validationRules = [
        'dni'              => 'required|max_length[15]|is_unique[estudiantes.dni]',
        'apellido'         => 'required|min_length[2]|max_length[100]',
        'nombre'           => 'required|min_length[2]|max_length[100]',
        'fecha_nacimiento' => 'required|valid_date[Y-m-d]',
        'id_carrera'       => 'required|is_natural_no_zero',
        'estado'           => 'required|in_list[activo,libre,egresado,abandono,pase]',
        'email'            => 'permit_empty|valid_email|max_length[120]',
        'anio_ingreso'     => 'permit_empty|integer',
    ];

    /**
     * Reglas para UPDATE.
     * is_unique CON tercer parámetro (excluye el propio id).
     * Se aplican solo desde el controlador con ->setValidationRules().
     */
    public function reglasParaUpdate(int $id): array
    {
        return [
            'dni'              => "required|max_length[15]|is_unique[estudiantes.dni,id_estudiante,{$id}]",
            'apellido'         => 'required|min_length[2]|max_length[100]',
            'nombre'           => 'required|min_length[2]|max_length[100]',
            'fecha_nacimiento' => 'required|valid_date[Y-m-d]',
            'id_carrera'       => 'required|is_natural_no_zero',
            'estado'           => 'required|in_list[activo,libre,egresado,abandono,pase]',
            'email'            => 'permit_empty|valid_email|max_length[120]',
            'anio_ingreso'     => 'permit_empty|integer',
        ];
    }

    protected $validationMessages = [
        'dni' => [
            'is_unique' => 'Ya existe un expediente con ese DNI.',
        ],
    ];

    /**
     * Búsqueda por apellido o DNI.
     */
    public function buscar(string $termino): array
    {
        $termino = trim($termino);
        if ($termino === '') {
            return [];
        }

        return $this->db->table('estudiantes e')
            ->select('e.id_estudiante, e.dni, e.apellido, e.nombre, e.estado,
                     e.id_carrera, c.nombre AS carrera, c.turno')
            ->join('carreras c', 'c.id_carrera = e.id_carrera', 'inner')
            ->groupStart()
                ->like('e.apellido', $termino)
                ->orLike('e.dni', $termino)
            ->groupEnd()
            ->orderBy('e.apellido', 'ASC')
            ->orderBy('e.nombre', 'ASC')
            ->limit(100)
            ->get()
            ->getResultArray();
    }
    /**
 * Devuelve el nombre del usuario que certificó el expediente,
 * o null si no fue certificado.
 */
public function certificadorDe(int $idEstudiante): ?array
{
    $row = $this->db->table('estudiantes e')
        ->select('e.certificado_por, e.fecha_certificacion, u.nombre AS certificador_nombre, u.rol AS certificador_rol')
        ->join('usuarios u', 'u.id_usuario = e.certificado_por', 'left')
        ->where('e.id_estudiante', $idEstudiante)
        ->get()
        ->getRowArray();

    if ($row === null || empty($row['certificado_por'])) {
        return null;
    }

    return $row;
}
    /**
     * Listado general con paginación simple.
     */
    public function listar(?string $turnoRestringido = null, int $limit = 50): array
    {
        $builder = $this->db->table('estudiantes e')
            ->select('e.id_estudiante, e.dni, e.apellido, e.nombre, e.estado,
                     e.id_carrera, c.nombre AS carrera, c.turno')
            ->join('carreras c', 'c.id_carrera = e.id_carrera', 'inner')
            ->orderBy('e.apellido', 'ASC')
            ->orderBy('e.nombre', 'ASC')
            ->limit($limit);

        if ($turnoRestringido !== null && $turnoRestringido !== 'ambos') {
            $builder->where('c.turno', $turnoRestringido);
        }

        return $builder->get()->getResultArray();
    }

    /**
     * Devuelve un expediente con datos de la carrera.
     */
    public function conCarrera(int $id): ?array
{
    return $this->db->table('estudiantes e')
        ->select('e.*, c.nombre AS carrera_nombre, c.turno AS carrera_turno,
                 c.resolucion AS carrera_resolucion, c.sede,
                 u.nombre AS certificador_nombre, u.rol AS certificador_rol')
        ->join('carreras c', 'c.id_carrera = e.id_carrera', 'inner')
        ->join('usuarios u', 'u.id_usuario = e.certificado_por', 'left')
        ->where('e.id_estudiante', $id)
        ->get()
        ->getRowArray();
}

    /**
     * Devuelve el turno de la carrera del estudiante.
     */
    public function turnoDeEstudiante(int $id): ?string
    {
        $row = $this->db->table('estudiantes e')
            ->select('c.turno')
            ->join('carreras c', 'c.id_carrera = e.id_carrera', 'inner')
            ->where('e.id_estudiante', $id)
            ->get()
            ->getRowArray();

        return $row['turno'] ?? null;
    }
}