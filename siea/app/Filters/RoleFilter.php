<?php

namespace App\Filters;

use CodeIgniter\Filters\FilterInterface;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;

/**
 * Filtro de rol.
 *
 * Uso en Routes.php:
 *   ['filter' => 'role:admin']
 *   ['filter' => 'role:admin,coordinadora']
 *
 * Si el usuario logueado no tiene uno de los roles permitidos,
 * lo redirige al dashboard con mensaje de error.
 */
class RoleFilter implements FilterInterface
{
    public function before(RequestInterface $request, $arguments = null)
    {
        $rolActual = session()->get('rol');

        if (empty($rolActual)) {
            // Sin sesión: que lo maneje AuthFilter.
            return redirect()->to(site_url('login'));
        }

        // $arguments es el array de roles permitidos, ej: ['admin']
        $permitidos = is_array($arguments) ? $arguments : [];

        if (! empty($permitidos) && ! in_array($rolActual, $permitidos, true)) {
            session()->setFlashdata('error', 'No tenés permiso para acceder a esa sección.');
            return redirect()->to(site_url('dashboard'));
        }
    }

    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null)
    {
    }
}