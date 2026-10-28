<?php

namespace App\Filters;

use CodeIgniter\Filters\FilterInterface;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;

/**
 * Filtro de autenticación.
 *
 * Verifica que haya sesión iniciada. Si no, redirige al login con un
 * mensaje flash. Se aplica a todo el grupo de rutas privadas.
 */
class AuthFilter implements FilterInterface
{
    public function before(RequestInterface $request, $arguments = null)
    {
        if (! session()->get('id_usuario')) {
            session()->setFlashdata('error', 'Debés iniciar sesión para acceder.');
            return redirect()->to(site_url('login'));
        }
    }

    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null)
    {
        // No hace nada después del controlador.
    }
}