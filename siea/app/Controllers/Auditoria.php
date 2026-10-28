<?php

namespace App\Controllers;

use CodeIgniter\Controller;

/**
 * Vista de auditoría — SOLO admin.
 *
 * Lista los últimos N registros de la tabla `auditoria`,
 * con filtros por tabla, acción y usuario.
 */
class Auditoria extends Controller
{
    public function index()
    {
        $db = \Config\Database::connect();

        $tabla  = trim((string) ($this->request->getGet('tabla') ?? ''));
        $accion = trim((string) ($this->request->getGet('accion') ?? ''));
        $usuario = trim((string) ($this->request->getGet('usuario') ?? ''));

        $builder = $db->table('auditoria a')
            ->select('a.id_auditoria, a.tabla, a.registro_id, a.accion,
                     a.fecha, u.nombre AS usuario_nombre, u.usuario')
            ->join('usuarios u', 'u.id_usuario = a.id_usuario', 'left')
            ->orderBy('a.id_auditoria', 'DESC')
            ->limit(200);

        if ($tabla !== '') {
            $builder->where('a.tabla', $tabla);
        }
        if ($accion !== '' && in_array($accion, ['INSERT','UPDATE','DELETE','LOGIN','LOGOUT'], true)) {
            $builder->where('a.accion', $accion);
        }
        if ($usuario !== '') {
            $builder->groupStart()
                ->like('u.usuario', $usuario)
                ->orLike('u.nombre', $usuario)
                ->groupEnd();
        }

        $registros = $builder->get()->getResultArray();

        // Lista de tablas distintas para el select de filtro.
        $tablas = $db->table('auditoria')
            ->select('tabla')
            ->distinct()
            ->orderBy('tabla', 'ASC')
            ->get()
            ->getResultArray();

        return view('auditoria/index', [
            'titulo'    => 'Auditoría',
            'registros' => $registros,
            'tablas'    => array_column($tablas, 'tabla'),
            'filtroTabla'   => $tabla,
            'filtroAccion'  => $accion,
            'filtroUsuario' => $usuario,
        ]);
    }
}