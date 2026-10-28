<?php

namespace App\Filters;

use CodeIgniter\Filters\FilterInterface;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;

/**
 * Filtro de turno para preceptoras.
 *
 * REGLA CRÍTICA:
 *   - Cada preceptora pertenece a un turno (mañana|tarde|ambos).
 *   - Solo puede ver/editar expedientes de estudiantes cuya carrera
 *     corresponda a ese turno.
 *
 * Este filtro valida que la preceptora tenga turno. La validación FINA
 * contra el estudiante la hace el controlador (necesita consultar la DB).
 * El controlador usa el helper estático TurnoFilter::puedeAcceder().
 */
class TurnoFilter implements FilterInterface
{
    public function before(RequestInterface $request, $arguments = null)
    {
        $rol   = session()->get('rol');
        $turno = session()->get('turno');

        if ($rol !== 'preceptora') {
            return; // admin/coordinadora/vicerrectora pasan siempre
        }

        if (empty($turno)) {
            session()->setFlashdata('error', 'Tu usuario no tiene turno asignado. Contactá al administrador.');
            return redirect()->to(site_url('dashboard'));
        }
    }

    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null)
    {
    }

    /**
     * Helper estático: ¿el usuario de la sesión puede acceder al
     * expediente del turno indicado?
     *
     * @param string|null $turnoEstudiante Turno de la carrera del estudiante.
     * @return bool
     */
    public static function puedeAcceder(?string $turnoEstudiante): bool
    {
        $rol   = session()->get('rol');
        $turno = session()->get('turno');

        if (in_array($rol, ['admin', 'coordinadora', 'vicerrectora'], true)) {
            return true;
        }
        if ($rol !== 'preceptora') {
            return false;
        }
        if ($turno === 'ambos') {
            return true;
        }
        if (empty($turnoEstudiante)) {
            return false;
        }
        return $turno === $turnoEstudiante;
    }
}