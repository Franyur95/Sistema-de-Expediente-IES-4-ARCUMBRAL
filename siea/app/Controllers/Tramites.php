<?php

namespace App\Controllers;

use App\Models\TramiteModel;
use App\Models\EstudianteModel;
use App\Models\ResolucionModel;
use App\Models\CarreraModel;
use App\Models\AuditoriaModel;
use App\Filters\TurnoFilter;
use CodeIgniter\Controller;

/**
 * Módulo de Trámites.
 *
 * Reglas:
 *   - Preceptora: crea/edita trámites SOLO de su turno.
 *   - Coordinadora/vicerrectora/admin: pueden resolver/rechazar.
 *   - Trámite "pase" resuelto: actualiza id_carrera del estudiante.
 *   - Cada cambio se audita.
 */
class Tramites extends Controller
{
    protected TramiteModel     $tramiteModel;
    protected EstudianteModel  $estudianteModel;
    protected ResolucionModel  $resolucionModel;
    protected CarreraModel     $carreraModel;
    protected AuditoriaModel   $auditoriaModel;

    public function __construct()
    {
        $this->tramiteModel    = new TramiteModel();
        $this->estudianteModel = new EstudianteModel();
        $this->resolucionModel = new ResolucionModel();
        $this->carreraModel    = new CarreraModel();
        $this->auditoriaModel  = new AuditoriaModel();
    }

    private function turnoRestringido(): ?string
    {
        if (session()->get('rol') === 'preceptora') {
            return session()->get('turno');
        }
        return null;
    }

    private function puedeCargar(): bool
    {
        return in_array(session()->get('rol'), ['admin', 'preceptora'], true);
    }

    private function puedeResolver(): bool
    {
        return in_array(session()->get('rol'), ['admin', 'coordinadora', 'vicerrectora'], true);
    }

    public function index()
    {
        $turno = $this->turnoRestringido();
        $tramites = $this->tramiteModel->listar($turno);

        return view('tramites/index', [
            'titulo'        => 'Trámites',
            'tramites'      => $tramites,
            'puedeCargar'   => $this->puedeCargar(),
            'puedeResolver' => $this->puedeResolver(),
        ]);
    }

    public function nuevo(int $idEstudiante = 0)
    {
        if (! $this->puedeCargar()) {
            session()->setFlashdata('error', 'No tenés permiso para cargar trámites.');
            return redirect()->to(site_url('tramites'));
        }

        $est = null;
        if ($idEstudiante > 0) {
            $est = $this->estudianteModel->conCarrera($idEstudiante);
            if ($est === null || ! TurnoFilter::puedeAcceder($est['carrera_turno'] ?? null)) {
                session()->setFlashdata('error', 'Estudiante no encontrado o de otro turno.');
                return redirect()->to(site_url('tramites'));
            }
        }

        return view('tramites/form', [
            'titulo'    => 'Nuevo trámite',
            'tramite'   => null,
            'est'       => $est,
            'accion'    => site_url('tramites/nuevo'),
            'esEdicion' => false,
        ]);
    }

    public function guardarNuevo()
    {
        if (! $this->puedeCargar()) {
            session()->setFlashdata('error', 'No tenés permiso para cargar trámites.');
            return redirect()->to(site_url('tramites'));
        }

        $datos = $this->datosDesdePost();
        $datos['estado'] = 'en_curso';

        // Validar turno del estudiante para preceptora.
        $est = $this->estudianteModel->conCarrera((int) $datos['id_estudiante']);
        if ($est === null || ! TurnoFilter::puedeAcceder($est['carrera_turno'] ?? null)) {
            session()->setFlashdata('error', 'Estudiante no encontrado o de otro turno.');
            return redirect()->back()->withInput();
        }

        if (! $this->tramiteModel->validate($datos)) {
            return redirect()->back()->withInput()->with('errors', $this->tramiteModel->errors());
        }

        $idNuevo = $this->tramiteModel->insert($datos, true);

        $this->auditoriaModel->registrar(
            (int) session()->get('id_usuario'),
            'tramites',
            (int) $idNuevo,
            'INSERT',
            null,
            $datos
        );

        session()->setFlashdata('exito', 'Trámite registrado.');
        return redirect()->to(site_url('tramites'));
    }

    public function resolver(int $id)
    {
        if (! $this->puedeResolver()) {
            session()->setFlashdata('error', 'No tenés permiso para resolver trámites.');
            return redirect()->to(site_url('tramites'));
        }

        $tramite = $this->tramiteModel->conEstudiante($id);
        if ($tramite === null) {
            session()->setFlashdata('error', 'Trámite no encontrado.');
            return redirect()->to(site_url('tramites'));
        }

        return view('tramites/resolver', [
            'titulo'       => 'Resolver trámite',
            'tramite'      => $tramite,
            'resoluciones' => $this->resolucionModel->listarTodas(),
            'carreras'     => $this->carreraModel->activas(),
            'accion'       => site_url('tramites/resolver/' . $id),
        ]);
    }

    public function guardarResolucion(int $id)
    {
        if (! $this->puedeResolver()) {
            session()->setFlashdata('error', 'No tenés permiso para resolver trámites.');
            return redirect()->to(site_url('tramites'));
        }

        $tramite = $this->tramiteModel->conEstudiante($id);
        if ($tramite === null) {
            session()->setFlashdata('error', 'Trámite no encontrado.');
            return redirect()->to(site_url('tramites'));
        }

        $estado = (string) $this->request->getPost('estado');
        if (! in_array($estado, ['resuelto', 'rechazado'], true)) {
            session()->setFlashdata('error', 'Estado inválido.');
            return redirect()->to(site_url('tramites/resolver/' . $id));
        }

        $idResolucion = (int) $this->request->getPost('id_resolucion') ?: null;

        if ($estado === 'resuelto' && empty($idResolucion)) {
            session()->setFlashdata('error', 'Para marcar como resuelto tenés que asociar una resolución.');
            return redirect()->to(site_url('tramites/resolver/' . $id));
        }

        $datos = [
            'estado'        => $estado,
            'id_resolucion' => $idResolucion,
            'detalle'       => trim((string) $this->request->getPost('detalle')),
        ];

        $db = $this->tramiteModel->db;
        $db->transBegin();

        try {
            $this->tramiteModel->update($id, $datos);

            // Regla: trámite "pase" resuelto → actualiza id_carrera del estudiante.
            if ($estado === 'resuelto' && $tramite['tipo'] === 'pase') {
                $nuevaCarrera = (int) $this->request->getPost('id_carrera_destino');
                if ($nuevaCarrera > 0 && $nuevaCarrera !== (int) $tramite['id_carrera']) {
                    $this->estudianteModel->update($tramite['id_estudiante'], [
                        'id_carrera' => $nuevaCarrera,
                        'estado'     => 'pase',
                    ]);
                    $this->auditoriaModel->registrar(
                        (int) session()->get('id_usuario'),
                        'estudiantes',
                        (int) $tramite['id_estudiante'],
                        'UPDATE',
                        ['id_carrera' => $tramite['id_carrera'], 'estado' => $tramite['estado_estudiante'] ?? null],
                        ['id_carrera' => $nuevaCarrera, 'estado' => 'pase']
                    );
                }
            }

            $this->auditoriaModel->registrar(
                (int) session()->get('id_usuario'),
                'tramites',
                $id,
                'UPDATE',
                ['estado' => $tramite['estado']],
                $datos
            );

            $db->transCommit();
        } catch (\Throwable $e) {
            $db->transRollback();
            log_message('error', 'Error al resolver trámite: ' . $e->getMessage());
            session()->setFlashdata('error', 'No se pudo resolver el trámite.');
            return redirect()->to(site_url('tramites/resolver/' . $id));
        }

        session()->setFlashdata('exito', 'Trámite actualizado.');
        return redirect()->to(site_url('tramites'));
    }

    private function datosDesdePost(): array
    {
        return [
            'id_estudiante'   => (int) $this->request->getPost('id_estudiante'),
            'tipo'            => (string) $this->request->getPost('tipo'),
            'fecha_solicitud' => (string) $this->request->getPost('fecha_solicitud'),
            'fecha_limite'    => $this->request->getPost('fecha_limite') ?: null,
            'detalle'         => trim((string) $this->request->getPost('detalle')),
        ];
    }
}