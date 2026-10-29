<?php
require_once __DIR__ . '/includes/auth.php';

require_once __DIR__ . '/includes/estudiantes.php';
require_once __DIR__ . '/includes/form_estudiante.php';

$usuario = require_login();
exigir_edicion($usuario);

$carreras = carreras_permitidas($usuario);
$tipos    = cargar_tipos();
$datos    = datos_vacios($usuario);
$docs     = docs_vacios($tipos);
$errores  = [];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $datos = datos_desde_post($_POST);
    $docs  = docs_desde_post($_POST, $tipos);

    if (!csrf_valido()) {
        $errores['general'] = 'El formulario venció. Revise los datos y vuelva a guardar.';
    } else {
        $errores = validar_estudiante($datos, $usuario, 0) + validar_docs($docs, $tipos);
        if (!$errores) {
            try {
                $id = crear_estudiante($datos, $docs, $usuario['id_usuario']);
                flash('ok', 'Expediente creado correctamente.');
                redirigir('ver.php?id=' . $id);
            } catch (PDOException $ex) {
                if (es_duplicado($ex)) {
                    $errores['dni'] = 'Ya existe un expediente con ese DNI. Búsquelo en "Buscar alumnos".';
                } else {
                    error_log('Error al crear expediente: ' . $ex->getMessage());
                    $errores['general'] = 'Ocurrió un error al guardar. No se creó el expediente; intente nuevamente.';
                }
            }
        }
    }
}

render_header('Nuevo expediente', $usuario);
render_form_estudiante($datos, $errores, $carreras, $tipos, $docs, 'nuevo.php', 'Guardar expediente', 'index.php');
render_footer();
