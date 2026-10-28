<?php

namespace App\Controllers;

use App\Models\TramiteModel;
use App\Models\DocumentacionModel;
use CodeIgniter\Controller;

class Dashboard extends Controller
{
    public function index()
    {
        $rol = session()->get('rol');

        $menuCompleto = [
            ['titulo' => 'Estudiantes', 'descripcion' => 'Buscar, alta y consulta de expedientes.', 'url' => 'estudiantes', 'roles' => ['admin', 'preceptora', 'coordinadora', 'vicerrectora']],
            ['titulo' => 'Cursadas', 'descripcion' => 'Registrar cursadas y parciales.', 'url' => 'cursadas', 'roles' => ['admin', 'preceptora']],
            ['titulo' => 'Exámenes finales', 'descripcion' => 'Alta de exámenes y calificaciones.', 'url' => 'examenes', 'roles' => ['admin', 'preceptora']],
            ['titulo' => 'Trámites', 'descripcion' => 'Pases, equivalencias, asimilaciones.', 'url' => 'tramites', 'roles' => ['admin', 'preceptora', 'coordinadora', 'vicerrectora']],
            ['titulo' => 'Usuarios', 'descripcion' => 'ABM de usuarios del sistema.', 'url' => 'usuarios', 'roles' => ['admin']],
            ['titulo' => 'Resoluciones', 'descripcion' => 'ABM de resoluciones.', 'url' => 'resoluciones', 'roles' => ['admin']],
            ['titulo' => 'Backup', 'descripcion' => 'Copias de seguridad de la base.', 'url' => 'backup', 'roles' => ['admin']],
            ['titulo' => 'Auditoría', 'descripcion' => 'Historial de acciones del sistema.', 'url' => 'auditoria', 'roles' => ['admin']],
        ];

        $menu = array_filter($menuCompleto, static function (array $item) use ($rol): bool {
            return in_array($rol, $item['roles'], true);
        });

        // Alertas
        $alertas = $this->calcularAlertas($rol);

        return view('dashboard/index', [
            'titulo' => 'Panel principal',
            'menu'   => $menu,
            'alertas'=> $alertas,
        ]);
    }

    private function calcularAlertas(string $rol): array
    {
        $alertas = [];
        $db = \Config\Database::connect();
        $hoy = date('Y-m-d');

        // Solo admin, preceptora, coordinadora y vicerrectora ven alertas de expedientes.
        if (in_array($rol, ['admin', 'preceptora', 'coordinadora', 'vicerrectora'], true)) {
            // Documentos obligatorios vencidos.
            $vencidos = (int) $db->table('documentacion_estudiante de')
                ->join('tipos_documento td', 'td.id_tipo = de.id_tipo', 'inner')
                ->where('td.obligatorio', 1)
                ->where('de.presentado', 1)
                ->where('de.fecha_vencimiento IS NOT NULL')
                ->where('de.fecha_vencimiento <', $hoy)
                ->countAllResults();

            if ($vencidos > 0) {
                $alertas[] = [
                    'tipo'  => 'error',
                    'texto' => $vencidos . ' documento(s) obligatorio(s) vencido(s).',
                    'url'   => 'estudiantes',
                ];
            }

            // Trámites por vencer (próximos 7 días).
            $tramiteModel = new TramiteModel();
            $porVencer = $tramiteModel->contarPorVencer(7);
            if ($porVencer > 0) {
                $alertas[] = [
                    'tipo'  => 'alerta',
                    'texto' => $porVencer . ' trámite(s) por vencer en los próximos 7 días.',
                    'url'   => 'tramites',
                ];
            }
        }

        return $alertas;
    }
}