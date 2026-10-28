<?php

namespace App\Controllers;

use App\Models\UsuarioModel;
use App\Models\AuditoriaModel;
use CodeIgniter\Controller;

class Usuarios extends Controller
{
    protected UsuarioModel $usuarioModel;
    protected AuditoriaModel $auditoriaModel;

    public function __construct()
    {
        $this->usuarioModel   = new UsuarioModel();
        $this->auditoriaModel = new AuditoriaModel();
    }

    public function index()
    {
        $usuarios = $this->usuarioModel->listarTodos();
        return view('usuarios/index', [
            'titulo'   => 'Usuarios',
            'usuarios' => $usuarios,
        ]);
    }

    public function nuevo()
    {
        return view('usuarios/form', [
            'titulo'    => 'Nuevo usuario',
            'usuario'   => null,
            'accion'    => site_url('usuarios/nuevo'),
            'esEdicion' => false,
        ]);
    }

    public function guardarNuevo()
    {
        $datos = [
            'nombre'  => trim((string) $this->request->getPost('nombre')),
            'usuario' => trim((string) $this->request->getPost('usuario')),
            'rol'     => (string) $this->request->getPost('rol'),
            'turno'   => (string) $this->request->getPost('turno'),
            'activo'  => (int) $this->request->getPost('activo'),
            'clave'   => (string) $this->request->getPost('clave'),
        ];

        $rules = [
            'nombre'  => 'required|min_length[3]|max_length[120]',
            'usuario' => 'required|min_length[3]|max_length[60]|is_unique[usuarios.usuario]',
            'rol'     => 'required|in_list[admin,preceptora,coordinadora,vicerrectora]',
            'turno'   => 'required|in_list[mañana,tarde,ambos]',
            'activo'  => 'required|in_list[0,1]',
            'clave'   => 'required|min_length[6]',
        ];

        if (! $this->validate($rules)) {
            return redirect()->back()->withInput()->with('errors', $this->validator->getErrors());
        }

        $hash = password_hash($datos['clave'], PASSWORD_DEFAULT);

        $idNuevo = $this->usuarioModel->insert([
            'nombre'     => $datos['nombre'],
            'usuario'    => $datos['usuario'],
            'clave_hash' => $hash,
            'rol'        => $datos['rol'],
            'turno'      => $datos['turno'],
            'activo'     => $datos['activo'],
        ]);

        $this->auditoriaModel->registrar(
            (int) session()->get('id_usuario'),
            'usuarios',
            (int) $idNuevo,
            'INSERT',
            null,
            [
                'nombre'  => $datos['nombre'],
                'usuario' => $datos['usuario'],
                'rol'     => $datos['rol'],
                'turno'   => $datos['turno'],
                'activo'  => $datos['activo'],
            ]
        );

        session()->setFlashdata('exito', 'Usuario creado correctamente.');
        return redirect()->to(site_url('usuarios'));
    }

    public function editar(int $id)
    {
        $usuario = $this->usuarioModel
            ->select('id_usuario, nombre, usuario, rol, turno, activo')
            ->find($id);

        if ($usuario === null) {
            session()->setFlashdata('error', 'Usuario no encontrado.');
            return redirect()->to(site_url('usuarios'));
        }

        return view('usuarios/form', [
            'titulo'    => 'Editar usuario',
            'usuario'   => $usuario,
            'accion'    => site_url('usuarios/editar/' . $id),
            'esEdicion' => true,
        ]);
    }

    public function guardarEdicion(int $id)
    {
        $usuarioActual = $this->usuarioModel->find($id);
        if ($usuarioActual === null) {
            session()->setFlashdata('error', 'Usuario no encontrado.');
            return redirect()->to(site_url('usuarios'));
        }

        $datos = [
            'nombre'  => trim((string) $this->request->getPost('nombre')),
            'usuario' => trim((string) $this->request->getPost('usuario')),
            'rol'     => (string) $this->request->getPost('rol'),
            'turno'   => (string) $this->request->getPost('turno'),
            'activo'  => (int) $this->request->getPost('activo'),
            'clave'   => (string) $this->request->getPost('clave'),
        ];

        $rules = [
            'nombre'  => 'required|min_length[3]|max_length[120]',
            'usuario' => "required|min_length[3]|max_length[60]|is_unique[usuarios.usuario,id_usuario,{$id}]",
            'rol'     => 'required|in_list[admin,preceptora,coordinadora,vicerrectora]',
            'turno'   => 'required|in_list[mañana,tarde,ambos]',
            'activo'  => 'required|in_list[0,1]',
        ];

        if ($datos['clave'] !== '') {
            $rules['clave'] = 'min_length[6]';
        }

        if (! $this->validate($rules)) {
            return redirect()->back()->withInput()->with('errors', $this->validator->getErrors());
        }

        $nuevosDatos = [
            'nombre'  => $datos['nombre'],
            'usuario' => $datos['usuario'],
            'rol'     => $datos['rol'],
            'turno'   => $datos['turno'],
            'activo'  => $datos['activo'],
        ];

        if ($datos['clave'] !== '') {
            $nuevosDatos['clave_hash'] = password_hash($datos['clave'], PASSWORD_DEFAULT);
        }

        $this->usuarioModel->update($id, $nuevosDatos);

        $anterioresParaAuditar = [
            'nombre'  => $usuarioActual['nombre'],
            'usuario' => $usuarioActual['usuario'],
            'rol'     => $usuarioActual['rol'],
            'turno'   => $usuarioActual['turno'],
            'activo'  => (int) $usuarioActual['activo'],
        ];
        $nuevosParaAuditar = $nuevosDatos;
        unset($nuevosParaAuditar['clave_hash']);

        $this->auditoriaModel->registrar(
            (int) session()->get('id_usuario'),
            'usuarios',
            $id,
            'UPDATE',
            $anterioresParaAuditar,
            $nuevosParaAuditar
        );

        session()->setFlashdata('exito', 'Usuario actualizado correctamente.');
        return redirect()->to(site_url('usuarios'));
    }

    public function eliminar(int $id)
    {
        $usuario = $this->usuarioModel->find($id);
        if ($usuario === null) {
            session()->setFlashdata('error', 'Usuario no encontrado.');
            return redirect()->to(site_url('usuarios'));
        }

        if ($id === (int) session()->get('id_usuario')) {
            session()->setFlashdata('error', 'No podés desactivar tu propio usuario.');
            return redirect()->to(site_url('usuarios'));
        }

        if ($usuario['rol'] === 'admin' && (int) $usuario['activo'] === 1) {
            $adminsActivos = $this->usuarioModel
                ->where('rol', 'admin')
                ->where('activo', 1)
                ->countAllResults();

            if ($adminsActivos <= 1) {
                session()->setFlashdata('error', 'No podés desactivar al último administrador activo.');
                return redirect()->to(site_url('usuarios'));
            }
        }

        $this->usuarioModel->update($id, ['activo' => 0]);

        $this->auditoriaModel->registrar(
            (int) session()->get('id_usuario'),
            'usuarios',
            $id,
            'UPDATE',
            ['activo' => (int) $usuario['activo']],
            ['activo' => 0]
        );

        session()->setFlashdata('exito', 'Usuario desactivado.');
        return redirect()->to(site_url('usuarios'));
    }

    public function reactivar(int $id)
    {
        $usuario = $this->usuarioModel->find($id);
        if ($usuario === null) {
            session()->setFlashdata('error', 'Usuario no encontrado.');
            return redirect()->to(site_url('usuarios'));
        }

        $this->usuarioModel->update($id, ['activo' => 1]);

        $this->auditoriaModel->registrar(
            (int) session()->get('id_usuario'),
            'usuarios',
            $id,
            'UPDATE',
            ['activo' => (int) $usuario['activo']],
            ['activo' => 1]
        );

        session()->setFlashdata('exito', 'Usuario reactivado.');
        return redirect()->to(site_url('usuarios'));
    }
}