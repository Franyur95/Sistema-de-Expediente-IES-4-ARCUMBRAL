<?php

namespace App\Controllers;

use App\Models\EstudianteModel;
use App\Models\CarreraModel;
use App\Models\TipoDocumentoModel;
use App\Models\DocumentacionModel;
use App\Models\AuditoriaModel;
use App\Filters\TurnoFilter;
use CodeIgniter\Controller;

/**
 * ABM de estudiantes (expedientes académicos).
 *
 * OJO: "estudiantes" son los alumnos, NO los usuarios del sistema.
 * Los usuarios del sistema se gestionan en Usuarios.php.
 */
class Estudiantes extends Controller
{
    protected EstudianteModel     $estudianteModel;
    protected CarreraModel        $carreraModel;
    protected TipoDocumentoModel  $tipoModel;
    protected DocumentacionModel  $docModel;
    protected AuditoriaModel      $auditoriaModel;

    public function __construct()
    {
        $this->estudianteModel = new EstudianteModel();
        $this->carreraModel    = new CarreraModel();
        $this->tipoModel       = new TipoDocumentoModel();
        $this->docModel        = new DocumentacionModel();
        $this->auditoriaModel  = new AuditoriaModel();
    }

    private function turnoRestringido(): ?string
    {
        if (session()->get('rol') === 'preceptora') {
            return session()->get('turno');
        }
        return null;
    }

    private function puedeEditar(): bool
    {
        return in_array(session()->get('rol'), ['admin', 'preceptora'], true);
    }

    private function puedeCertificar(): bool
    {
        return in_array(session()->get('rol'), ['admin', 'coordinadora', 'vicerrectora'], true);
    }

    public function index()
    {
        $turno = $this->turnoRestringido();
        $estudiantes = $this->estudianteModel->listar($turno, 50);

        return view('estudiantes/index', [
            'titulo'      => 'Estudiantes',
            'estudiantes' => $estudiantes,
            'puedeEditar' => $this->puedeEditar(),
        ]);
    }

    public function search()
    {
        $termino = trim((string) ($this->request->getGet('q') ?? ''));
        $resultados = $termino !== '' ? $this->estudianteModel->buscar($termino) : [];

        if ($termino !== '' && session()->get('rol') === 'preceptora') {
            $turno = session()->get('turno');
            if ($turno !== 'ambos') {
                $resultados = array_values(array_filter($resultados, static function ($r) use ($turno) {
                    return ($r['turno'] ?? null) === $turno;
                }));
            }
        }

        return view('estudiantes/search', [
            'titulo'     => 'Buscar estudiante',
            'termino'    => $termino,
            'resultados' => $resultados,
        ]);
    }

    public function create()
    {
        if (! $this->puedeEditar()) {
            session()->setFlashdata('error', 'No tenés permiso para crear expedientes.');
            return redirect()->to(site_url('estudiantes'));
        }

        return view('estudiantes/create', [
            'titulo'   => 'Nuevo expediente',
            'carreras' => $this->carreraModel->activas(),
        ]);
    }

   public function store()
{
    if (! $this->puedeEditar()) {
        session()->setFlashdata('error', 'No tenés permiso para crear expedientes.');
        return redirect()->to(site_url('estudiantes'));
    }

    $datos = $this->datosDesdePost();
    $idCarrera = (int) ($datos['id_carrera'] ?? 0);
    $turnoCarrera = $this->carreraModel->turnoDe($idCarrera);

    if (session()->get('rol') === 'preceptora'
        && session()->get('turno') !== 'ambos'
        && $turnoCarrera !== session()->get('turno')) {
        session()->setFlashdata('error', 'No podés crear expedientes de una carrera de otro turno.');
        return redirect()->back()->withInput();
    }

    // Validación con las reglas del modelo (is_unique sin placeholder).
    if (! $this->estudianteModel->validate($datos)) {
        return redirect()->back()->withInput()->with('errors', $this->estudianteModel->errors());
    }

    // Usamos la conexión del modelo para que todos los INSERT compartan
    // la misma transacción.
    $db = $this->estudianteModel->db;
    $db->transBegin();

    try {
        // INSERT directo por Query Builder (evita el bug de doInsert en CI 4.7).
        $db->table('estudiantes')->insert([
            'dni'              => $datos['dni'],
            'apellido'         => $datos['apellido'],
            'nombre'           => $datos['nombre'],
            'fecha_nacimiento' => $datos['fecha_nacimiento'],
            'lugar_nacimiento' => $datos['lugar_nacimiento'] ?: null,
            'domicilio'        => $datos['domicilio'] ?: null,
            'telefono'         => $datos['telefono'] ?: null,
            'email'            => $datos['email'] ?: null,
            'titulo_ingreso'   => $datos['titulo_ingreso'] ?: null,
            'tipo_titulo'      => $datos['tipo_titulo'] ?: null,
            'establecimiento'  => $datos['establecimiento'] ?: null,
            'anio_ingreso'     => $datos['anio_ingreso'] ?: null,
            'observaciones'    => $datos['observaciones'] ?: null,
            'estado'           => $datos['estado'],
            'id_carrera'       => (int) $datos['id_carrera'],
            'created_at'       => date('Y-m-d H:i:s'),
            'updated_at'       => date('Y-m-d H:i:s'),
        ]);

        $idNuevo = (int) $db->insertID();

        if ($idNuevo <= 0) {
            throw new \RuntimeException('No se pudo obtener el ID del estudiante insertado.');
        }

        $tipos = $this->tipoModel->ordenados();
        if (empty($tipos)) {
            throw new \RuntimeException('No hay tipos de documento definidos. Revisar seed de tipos_documento.');
        }

        foreach ($tipos as $tipo) {
            $db->table('documentacion_estudiante')->insert([
                'id_estudiante'      => $idNuevo,
                'id_tipo'            => (int) $tipo['id_tipo'],
                'presentado'         => 0,
                'fecha_presentacion' => null,
                'fecha_vencimiento'  => null,
                'observaciones'      => null,
            ]);
        }

        $this->auditoriaModel->registrar(
            (int) session()->get('id_usuario'),
            'estudiantes',
            $idNuevo,
            'INSERT',
            null,
            $datos
        );

        $db->transCommit();
    } catch (\Throwable $e) {
        $db->transRollback();
        log_message('error', 'Error al crear expediente: ' . $e->getMessage());
        log_message('error', 'Trace: ' . $e->getTraceAsString());
        log_message('error', 'Datos enviados: ' . json_encode($datos));

        session()->setFlashdata('error', 'No se pudo crear el expediente. Intentá de nuevo.');
        return redirect()->back()->withInput();
    }

    session()->setFlashdata('exito', 'Expediente creado correctamente.');
    return redirect()->to(site_url('estudiantes/' . $idNuevo));
}

    public function show(int $id)
    {
        $est = $this->estudianteModel->conCarrera($id);
        if ($est === null) {
            session()->setFlashdata('error', 'Expediente no encontrado.');
            return redirect()->to(site_url('estudiantes'));
        }

        if (! TurnoFilter::puedeAcceder($est['carrera_turno'] ?? null)) {
            session()->setFlashdata('error', 'No tenés acceso a expedientes de otro turno.');
            return redirect()->to(site_url('estudiantes'));
        }

        return view('estudiantes/show', [
            'titulo'          => 'Expediente ' . $est['apellido'] . ', ' . $est['nombre'],
            'est'             => $est,
            'checklist'       => $this->docModel->checklistDe($id),
            'puedeEditar'     => $this->puedeEditar(),
            'puedeCertificar' => $this->puedeCertificar(),
        ]);
    }

    public function edit(int $id)
    {
        if (! $this->puedeEditar()) {
            session()->setFlashdata('error', 'No tenés permiso para editar expedientes.');
            return redirect()->to(site_url('estudiantes'));
        }

        $est = $this->estudianteModel->conCarrera($id);
        if ($est === null) {
            session()->setFlashdata('error', 'Expediente no encontrado.');
            return redirect()->to(site_url('estudiantes'));
        }

        if (! TurnoFilter::puedeAcceder($est['carrera_turno'] ?? null)) {
            session()->setFlashdata('error', 'No tenés acceso a expedientes de otro turno.');
            return redirect()->to(site_url('estudiantes'));
        }

        return view('estudiantes/edit', [
            'titulo'   => 'Editar expediente',
            'est'      => $est,
            'carreras' => $this->carreraModel->activas(),
        ]);
    }

    public function update(int $id)
{
    if (! $this->puedeEditar()) {
        session()->setFlashdata('error', 'No tenés permiso para editar expedientes.');
        return redirect()->to(site_url('estudiantes'));
    }

    $anterior = $this->estudianteModel->conCarrera($id);
    if ($anterior === null) {
        session()->setFlashdata('error', 'Expediente no encontrado.');
        return redirect()->to(site_url('estudiantes'));
    }

    if (! TurnoFilter::puedeAcceder($anterior['carrera_turno'] ?? null)) {
        session()->setFlashdata('error', 'No tenés acceso a expedientes de otro turno.');
        return redirect()->to(site_url('estudiantes'));
    }

    $datos = $this->datosDesdePost();

    // Preceptora no puede cambiar la carrera a una de otro turno.
    $idCarrera = (int) ($datos['id_carrera'] ?? 0);
    $turnoCarrera = $this->carreraModel->turnoDe($idCarrera);
    if (session()->get('rol') === 'preceptora'
        && session()->get('turno') !== 'ambos'
        && $turnoCarrera !== session()->get('turno')) {
        session()->setFlashdata('error', 'No podés mover el expediente a una carrera de otro turno.');
        return redirect()->back()->withInput();
    }

    // Aplicamos las reglas de UPDATE (con is_unique excluyendo el propio id).
    $this->estudianteModel->setValidationRules($this->estudianteModel->reglasParaUpdate($id));

    if (! $this->estudianteModel->validate($datos)) {
        return redirect()->back()->withInput()->with('errors', $this->estudianteModel->errors());
    }

    $this->estudianteModel->update($id, $datos);

    $this->auditoriaModel->registrar(
        (int) session()->get('id_usuario'),
        'estudiantes',
        $id,
        'UPDATE',
        $anterior,
        $datos
    );

    session()->setFlashdata('exito', 'Expediente actualizado.');
    return redirect()->to(site_url('estudiantes/' . $id));
}

    public function actualizarDocumento(int $id)
    {
        if (! $this->puedeEditar()) {
            session()->setFlashdata('error', 'No tenés permiso para cargar documentación.');
            return redirect()->to(site_url('estudiantes/' . $id));
        }

        $est = $this->estudianteModel->conCarrera($id);
        if ($est === null) {
            session()->setFlashdata('error', 'Expediente no encontrado.');
            return redirect()->to(site_url('estudiantes'));
        }
        if (! TurnoFilter::puedeAcceder($est['carrera_turno'] ?? null)) {
            session()->setFlashdata('error', 'No tenés acceso a expedientes de otro turno.');
            return redirect()->to(site_url('estudiantes'));
        }

        $idTipo = (int) $this->request->getPost('id_tipo');
        $fila   = $this->docModel->fila($id, $idTipo);
        if ($fila === null) {
            session()->setFlashdata('error', 'Tipo de documento inválido.');
            return redirect()->to(site_url('estudiantes/' . $id));
        }

        $datos = [
            'presentado'         => (int) $this->request->getPost('presentado'),
            'fecha_presentacion' => $this->request->getPost('fecha_presentacion') ?: null,
            'fecha_vencimiento'  => $this->request->getPost('fecha_vencimiento') ?: null,
            'observaciones'      => $this->request->getPost('observaciones') ?: null,
        ];

        $this->docModel->actualizarFila($id, $idTipo, $datos);

        $this->auditoriaModel->registrar(
            (int) session()->get('id_usuario'),
            'documentacion_estudiante',
            $id,
            'UPDATE',
            $fila,
            $datos
        );

        session()->setFlashdata('exito', 'Documentación actualizada.');
        return redirect()->to(site_url('estudiantes/' . $id));
    }

    public function certificar(int $id)
{
    if (! $this->puedeCertificar()) {
        session()->setFlashdata('error', 'No tenés permiso para certificar expedientes.');
        return redirect()->to(site_url('estudiantes/' . $id));
    }

    $est = $this->estudianteModel->conCarrera($id);
    if ($est === null) {
        session()->setFlashdata('error', 'Expediente no encontrado.');
        return redirect()->to(site_url('estudiantes'));
    }

    if (! TurnoFilter::puedeAcceder($est['carrera_turno'] ?? null)) {
        session()->setFlashdata('error', 'No tenés acceso a expedientes de otro turno.');
        return redirect()->to(site_url('estudiantes'));
    }

    $datos = [
        'certificado_por'    => (int) session()->get('id_usuario'),
        'fecha_certificacion'=> date('Y-m-d H:i:s'),
    ];

    $this->estudianteModel->update($id, $datos);

    $this->auditoriaModel->registrar(
        (int) session()->get('id_usuario'),
        'estudiantes',
        $id,
        'UPDATE',
        ['certificado_por' => $est['certificado_por'] ?? null,
         'fecha_certificacion' => $est['fecha_certificacion'] ?? null],
        $datos
    );

    session()->setFlashdata('exito', 'Expediente certificado.');
    return redirect()->to(site_url('estudiantes/' . $id));
}

    private function datosDesdePost(): array
    {
        return [
            'dni'              => trim((string) $this->request->getPost('dni')),
            'apellido'         => trim((string) $this->request->getPost('apellido')),
            'nombre'           => trim((string) $this->request->getPost('nombre')),
            'fecha_nacimiento' => (string) $this->request->getPost('fecha_nacimiento'),
            'lugar_nacimiento' => trim((string) $this->request->getPost('lugar_nacimiento')),
            'domicilio'        => trim((string) $this->request->getPost('domicilio')),
            'telefono'         => trim((string) $this->request->getPost('telefono')),
            'email'            => trim((string) $this->request->getPost('email')),
            'titulo_ingreso'   => trim((string) $this->request->getPost('titulo_ingreso')),
            'tipo_titulo'      => trim((string) $this->request->getPost('tipo_titulo')),
            'establecimiento'  => trim((string) $this->request->getPost('establecimiento')),
            'anio_ingreso'     => $this->request->getPost('anio_ingreso') ?: null,
            'observaciones'    => trim((string) $this->request->getPost('observaciones')),
            'estado'           => (string) ($this->request->getPost('estado') ?: 'activo'),
            'id_carrera'       => (int) $this->request->getPost('id_carrera'),
        ];
    }
}