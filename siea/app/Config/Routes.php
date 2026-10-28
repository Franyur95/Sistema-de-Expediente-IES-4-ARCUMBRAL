<?php

namespace Config;

$routes = Services::routes();

$routes->setDefaultNamespace('App\Controllers');
$routes->setDefaultController('Auth');
$routes->setDefaultMethod('login');
$routes->setTranslateURIDashes(false);
$routes->set404Override();
$routes->setAutoRoute(false);

/* Públicas */
$routes->get('/',      'Auth::login');
$routes->get('login',  'Auth::login');
$routes->post('login', 'Auth::login');
$routes->get('logout', 'Auth::logout');

/* Privadas (auth) */
$routes->group('', ['filter' => 'auth'], static function ($routes) {
    $routes->get('dashboard', 'Dashboard::index');
});

/* Admin (auth + role:admin) */
$routes->group('', ['filter' => ['auth', 'role:admin']], static function ($routes) {
    /* Usuarios */
    $routes->get('usuarios',                   'Usuarios::index');
    $routes->get('usuarios/nuevo',             'Usuarios::nuevo');
    $routes->post('usuarios/nuevo',            'Usuarios::guardarNuevo');
    $routes->get('usuarios/editar/(:num)',     'Usuarios::editar/$1');
    $routes->post('usuarios/editar/(:num)',    'Usuarios::guardarEdicion/$1');
    $routes->post('usuarios/eliminar/(:num)',  'Usuarios::eliminar/$1');
    $routes->post('usuarios/reactivar/(:num)', 'Usuarios::reactivar/$1');

    /* Backup */
    $routes->get('backup',                      'Backup::index');
    $routes->post('backup/generar',             'Backup::generar');
    $routes->get('backup/descargar/(:segment)', 'Backup::descargar/$1');
    $routes->post('backup/eliminar/(:segment)', 'Backup::eliminar/$1');

    /* Resoluciones */
    $routes->get('resoluciones',                  'Resoluciones::index');
    $routes->get('resoluciones/nuevo',            'Resoluciones::nuevo');
    $routes->post('resoluciones/nuevo',           'Resoluciones::guardarNuevo');
    $routes->get('resoluciones/editar/(:num)',    'Resoluciones::editar/$1');
    $routes->post('resoluciones/editar/(:num)',   'Resoluciones::guardarEdicion/$1');
    $routes->post('resoluciones/eliminar/(:num)', 'Resoluciones::eliminar/$1');

    /* Auditoría */
    $routes->get('auditoria', 'Auditoria::index');
});

/* Estudiantes — consulta (todos los roles) */
$routes->group('', ['filter' => ['auth', 'role:admin,preceptora,coordinadora,vicerrectora']], static function ($routes) {
    $routes->get('estudiantes',             'Estudiantes::index');
    $routes->get('estudiantes/buscar',      'Estudiantes::search');
    $routes->get('estudiantes/(:num)',      'Estudiantes::show/$1');
});

/* Estudiantes — alta y edición (admin + preceptora + turno) */
$routes->group('', ['filter' => ['auth', 'role:admin,preceptora', 'turno']], static function ($routes) {
    $routes->get('estudiantes/nuevo',                 'Estudiantes::create');
    $routes->post('estudiantes/nuevo',                'Estudiantes::store');
    $routes->get('estudiantes/editar/(:num)',         'Estudiantes::edit/$1');
    $routes->post('estudiantes/editar/(:num)',        'Estudiantes::update/$1');
    $routes->post('estudiantes/(:num)/documento',     'Estudiantes::actualizarDocumento/$1');
});

/* Estudiantes — certificación (admin + coordinadora + vicerrectora) */
$routes->group('', ['filter' => ['auth', 'role:admin,coordinadora,vicerrectora']], static function ($routes) {
    $routes->post('estudiantes/(:num)/certificar', 'Estudiantes::certificar/$1');
});

/* Trámites — ver (todos los roles) */
$routes->group('', ['filter' => ['auth', 'role:admin,preceptora,coordinadora,vicerrectora']], static function ($routes) {
    $routes->get('tramites', 'Tramites::index');
});

/* Trámites — cargar (admin + preceptora + turno) */
$routes->group('', ['filter' => ['auth', 'role:admin,preceptora', 'turno']], static function ($routes) {
    $routes->get('tramites/nuevo',                 'Tramites::nuevo');
    $routes->get('tramites/nuevo/(:num)',          'Tramites::nuevo/$1');
    $routes->post('tramites/nuevo',                'Tramites::guardarNuevo');
});

/* Trámites — resolver (admin + coordinadora + vicerrectora) */
$routes->group('', ['filter' => ['auth', 'role:admin,coordinadora,vicerrectora']], static function ($routes) {
    $routes->get('tramites/resolver/(:num)',  'Tramites::resolver/$1');
    $routes->post('tramites/resolver/(:num)', 'Tramites::guardarResolucion/$1');
});

if (is_file(APPPATH . 'Config/' . ENVIRONMENT . '/Routes.php')) {
    require APPPATH . 'Config/' . ENVIRONMENT . '/Routes.php';
}