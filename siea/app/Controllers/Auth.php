<?php

namespace App\Controllers;

use App\Models\UsuarioModel;
use App\Models\AuditoriaModel;
use CodeIgniter\Controller;

/**
 * Controlador de autenticación.
 *
 * - GET  /login   → muestra el formulario.
 * - POST /login   → verifica credenciales y crea sesión.
 * - GET  /logout  → destruye la sesión y audita.
 *
 * Seguridad:
 *   - password_verify contra clave_hash.
 *   - session()->regenerate() después del login.
 *   - Auditoría de LOGIN y LOGOUT.
 *   - Mensajes flash para feedback.
 */
class Auth extends Controller
{
    public function login()
    {
        // Si ya está logueado, al dashboard.
        if (session()->get('id_usuario')) {
            return redirect()->to(site_url('dashboard'));
        }

        // Si viene por POST, procesamos.
        if ($this->request->getMethod() === 'POST') {
            return $this->attempt();
        }

        return view('auth/login');
    }

    /**
     * Procesa el POST del formulario de login.
     */
    private function attempt()
    {
        $rules = [
            'usuario' => 'required|min_length[3]|max_length[60]',
            'clave'   => 'required|min_length[4]',
        ];

        if (! $this->validate($rules)) {
            return redirect()->back()->withInput()->with('errors', $this->validator->getErrors());
        }

        $usuarioInput = trim((string) $this->request->getPost('usuario'));
        $claveInput   = (string) $this->request->getPost('clave');

        $usuarioModel = new UsuarioModel();
        $usuario      = $usuarioModel->buscarActivoPorUsuario($usuarioInput);

        // Credenciales inválidas: mismo mensaje genérico para no filtrar
        // si el usuario existe o no.
        if ($usuario === null || ! password_verify($claveInput, $usuario['clave_hash'])) {
            session()->setFlashdata('error', 'Usuario o contraseña incorrectos.');
            return redirect()->back()->withInput();
        }

        // Regenerar ID de sesión (previene session fixation).
        session()->regenerate();

        // Guardar datos de sesión (NUNCA la contraseña).
        session()->set([
            'id_usuario' => (int) $usuario['id_usuario'],
            'nombre'     => $usuario['nombre'],
            'usuario'    => $usuario['usuario'],
            'rol'        => $usuario['rol'],
            'turno'      => $usuario['turno'],
        ]);

        // Auditar LOGIN.
        (new AuditoriaModel())->registrar(
            (int) $usuario['id_usuario'],
            'usuarios',
            (int) $usuario['id_usuario'],
            'LOGIN',
            null,
            ['usuario' => $usuario['usuario'], 'rol' => $usuario['rol']]
        );

        session()->setFlashdata('exito', 'Bienvenido/a, ' . $usuario['nombre'] . '.');
        return redirect()->to(site_url('dashboard'));
    }

    /**
     * Cierra la sesión.
     */
    public function logout()
    {
        $idUsuario = session()->get('id_usuario');
        $usuario   = session()->get('usuario');
        $rol       = session()->get('rol');

        if ($idUsuario) {
            (new AuditoriaModel())->registrar(
                (int) $idUsuario,
                'usuarios',
                (int) $idUsuario,
                'LOGOUT',
                ['usuario' => $usuario, 'rol' => $rol],
                null
            );
        }

        session()->destroy();

        // Regeneramos una sesión limpia para el flashdata de despedida.
        session()->start();
        session()->setFlashdata('exito', 'Sesión cerrada correctamente.');

        return redirect()->to(site_url('login'));
    }
}