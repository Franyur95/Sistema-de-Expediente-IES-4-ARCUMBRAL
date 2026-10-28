<?php

namespace App\Models;

use CodeIgniter\Model;

/**
 * Modelo de documentación presentada por estudiante.
 *
 * Cada estudiante tiene una fila por tipo de documento (6 filas al crear).
 * PK compuesta: (id_estudiante, id_tipo). Por eso no usamos el
 * autoincrement estándar de CI4.
 */
class DocumentacionModel extends Model
{
    protected $table            = 'documentacion_estudiante';
    protected $primaryKey       = ['id_estudiante', 'id_tipo'];
    protected $useAutoIncrement = false;
    protected $returnType       = 'array';
    protected $useSoftDeletes   = false;
    protected $allowedFields    = [
        'id_estudiante',
        'id_tipo',
        'presentado',
        'fecha_presentacion',
        'fecha_vencimiento',
        'observaciones',
    ];
    protected $useTimestamps = false;

    /**
     * Devuelve el checklist completo de un estudiante, con el nombre
     * del tipo de documento, ordenado, y con estado calculado:
     *   - 'ok'      → presentado y no vencido
     *   - 'pendiente' → no presentado
     *   - 'vencido'   → presentado pero fecha_vencimiento < hoy
     *
     * @return array<int, array<string,mixed>>
     */
    public function checklistDe(int $idEstudiante): array
    {
        $hoy = date('Y-m-d');

        $filas = $this->db->table('documentacion_estudiante de')
            ->select('de.id_tipo, de.presentado, de.fecha_presentacion,
                     de.fecha_vencimiento, de.observaciones,
                     td.nombre, td.obligatorio, td.vence, td.orden')
            ->join('tipos_documento td', 'td.id_tipo = de.id_tipo', 'inner')
            ->where('de.id_estudiante', $idEstudiante)
            ->orderBy('td.orden', 'ASC')
            ->get()
            ->getResultArray();

        foreach ($filas as &$f) {
            $f['estado'] = 'pendiente';
            if ((int) $f['presentado'] === 1) {
                if (! empty($f['fecha_vencimiento']) && $f['fecha_vencimiento'] < $hoy) {
                    $f['estado'] = 'vencido';
                } else {
                    $f['estado'] = 'ok';
                }
            }
        }
        unset($f);

        return $filas;
    }

    /**
     * Crea las 6 filas del checklist en estado pendiente.
     * Se llama DENTRO de la transacción del alta de estudiante.
     */
    public function crearChecklistInicial(int $idEstudiante, array $tipos): void
    {
        $data = [];
        foreach ($tipos as $tipo) {
            $data[] = [
                'id_estudiante'      => $idEstudiante,
                'id_tipo'            => (int) $tipo['id_tipo'],
                'presentado'         => 0,
                'fecha_presentacion' => null,
                'fecha_vencimiento'  => null,
                'observaciones'      => null,
            ];
        }
        if ($data !== []) {
            $this->insertBatch($data);
        }
    }

    /**
     * Actualiza una fila del checklist.
     */
    public function actualizarFila(int $idEstudiante, int $idTipo, array $datos): void
    {
        $this->db->table('documentacion_estudiante')
            ->where('id_estudiante', $idEstudiante)
            ->where('id_tipo', $idTipo)
            ->update($datos);
    }

    /**
     * Devuelve una fila puntual.
     */
    public function fila(int $idEstudiante, int $idTipo): ?array
    {
        return $this->db->table('documentacion_estudiante')
            ->where('id_estudiante', $idEstudiante)
            ->where('id_tipo', $idTipo)
            ->get()
            ->getRowArray();
    }

    /**
     * Cuenta cuántos documentos obligatorios NO están presentados
     * o están vencidos. Sirve para alertas en el listado.
     */
    public function pendientesObligatorios(int $idEstudiante): int
    {
        $hoy = date('Y-m-d');

        return (int) $this->db->table('documentacion_estudiante de')
            ->join('tipos_documento td', 'td.id_tipo = de.id_tipo', 'inner')
            ->where('de.id_estudiante', $idEstudiante)
            ->where('td.obligatorio', 1)
            ->groupStart()
                ->where('de.presentado', 0)
                ->orWhere('de.fecha_vencimiento <', $hoy)
            ->groupEnd()
            ->countAllResults();
    }
}