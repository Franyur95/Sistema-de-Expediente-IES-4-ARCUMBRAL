<?php

namespace App\Controllers;

use App\Models\ResolucionModel;
use App\Models\AuditoriaModel;
use CodeIgniter\Controller;

/**
 * ABM de resoluciones — SOLO admin.
 */
class Resoluciones extends Controller
{
    protected ResolucionModel $resolucionModel;
    protected AuditoriaModel  $auditoriaModel;

    public function __construct()
    {
        $this->resolucionModel = new ResolucionModel();
        $this->auditoriaModel  = new AuditoriaModel();
    }

    public function index()
    {
        return view('resoluciones/index', [
            'titulo'       => 'Resoluciones',
            'resoluciones' => $this->resolucionModel->listarTodas(),
        ]);
    }

    public function nuevo()
    {
        return view('resoluciones/form', [
            'titulo'     => 'Nueva resolución',
            'resolucion' => null,
            'accion'     => site_url('resoluciones/nuevo'),
            'esEdicion'  => false,
        ]);
    }

    public function guardarNuevo()
    {
        $datos = $this->datosDesdePost();

        if (! $this->resolucionModel->validate($datos)) {
            return redirect()->back()->withInput()->with('errors', $this->resolucionModel->errors());
        }

        if ($this->resolucionModel->existe($datos['nro'], $datos['tipo'])) {
            return redirect()->back()->withInput()
                ->with('errors', ['Ya existe una resolución con ese número y tipo.']);
        }

        $idNuevo = $this->resolucionModel->insert($datos, true);

        $this->auditoriaModel->registrar(
            (int) session()->get('id_usuario'),
            'resoluciones',
            (int) $idNuevo,
            'INSERT',
            null,
            $datos
        );

        session()->setFlashdata('exito', 'Resolución creada.');
        return redirect()->to(site_url('resoluciones'));
    }

    public function editar(int $id)
    {
        $resolucion = $this->resolucionModel->find($id);
        if ($resolucion === null) {
            session()->setFlashdata('error', 'Resolución no encontrada.');
            return redirect()->to(site_url('resoluciones'));
        }

        return view('resoluciones/form', [
            'titulo'     => 'Editar resolución',
            'resolucion' => $resolucion,
            'accion'     => site_url('resoluciones/editar/' . $id),
            'esEdicion'  => true,
        ]);
    }

    public function guardarEdicion(int $id)
    {
        $resolucionActual = $this->resolucionModel->find($id);
        if ($resolucionActual === null) {
            session()->setFlashdata('error', 'Resolución no encontrada.');
            return redirect()->to(site_url('resoluciones'));
        }

        $datos = $this->datosDesdePost();

        if (! $this->resolucionModel->validate($datos)) {
            return redirect()->back()->withInput()->with('errors', $this->resolucionModel->errors());
        }

        if ($this->resolucionModel->existe($datos['nro'], $datos['tipo'], $id)) {
            return redirect()->back()->withInput()
                ->with('errors', ['Ya existe una resolución con ese número y tipo.']);
        }

        $this->resolucionModel->update($id, $datos);

        $this->auditoriaModel->registrar(
            (int) session()->get('id_usuario'),
            'resoluciones',
            $id,
            'UPDATE',
            [
                'nro'   => $resolucionActual['nro'],
                'fecha' => $resolucionActual['fecha'],
                'tipo'  => $resolucionActual['tipo'],
            ],
            $datos
        );

        session()->setFlashdata('exito', 'Resolución actualizada.');
        return redirect()->to(site_url('resoluciones'));
    }

    public function eliminar(int $id)
    {
        $resolucion = $this->resolucionModel->find($id);
        if ($resolucion === null) {
            session()->setFlashdata('error', 'Resolución no encontrada.');
            return redirect()->to(site_url('resoluciones'));
        }

        // No eliminar si está asociada a un trámite.
        $db = $this->resolucionModel->db;
        $usos = $db->table('tramites')->where('id_resolucion', $id)->countAllResults();
        if ($usos > 0) {
            session()->setFlashdata('error', 'No se puede eliminar: la resolución está asociada a ' . $usos . ' trámite(s).');
            return redirect()->to(site_url('resoluciones'));
        }

        $this->resolucionModel->delete($id);

        $this->auditoriaModel->registrar(
            (int) session()->get('id_usuario'),
            'resoluciones',
            $id,
            'DELETE',
            ['nro' => $resolucion['nro'], 'tipo' => $resolucion['tipo']],
            null
        );

        session()->setFlashdata('exito', 'Resolución eliminada.');
        return redirect()->to(site_url('resoluciones'));
    }

    private function datosDesdePost(): array
    {
        return [
            'nro'           => trim((string) $this->request->getPost('nro')),
            'fecha'         => (string) $this->request->getPost('fecha'),
            'tipo'          => (string) $this->request->getPost('tipo'),
            'observaciones' => trim((string) $this->request->getPost('observaciones')),
        ];
    }
}