<?php
require_once __DIR__ . '/includes/auth.php';
require_once __DIR__ . '/includes/estudiantes.php';
require_once __DIR__ . '/includes/form_estudiante.php';

$usuario = require_login();
exigir_edicion($usuario);

$id = id_desde_get();
$alumno = $id > 0 ? obtener_estudiante($id) : null;
if (!$alumno) {
    pagina_error(404, 'Expediente no encontrado', 'El expediente solicitado no existe.', $usuario);
}
if (!carrera_permitida($usuario, (int)$alumno['id_carrera'])) {
    pagina_error(403, 'Acceso denegado', 'No tiene permiso para modificar expedientes de esta carrera.', $usuario);
}

$carreras = carreras_permitidas($usuario);
$tipos    = cargar_tipos();
$errores  = [];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $datos = datos_desde_post($_POST);
    $docs  = docs_desde_post($_POST, $tipos);

    if (!csrf_valido()) {
        $errores['general'] = 'El formulario venció. Revise los datos y vuelva a guardar.';
    } else {
        $errores = validar_estudiante($datos, $usuario, $id) + validar_docs($docs, $tipos);
        if (!$errores) {
            try {
                actualizar_estudiante($id, $datos, $docs, $usuario['id_usuario']);
                flash('ok', 'Expediente actualizado correctamente.');
                redirigir('ver.php?id=' . $id);
            } catch (PDOException $ex) {
                if (es_duplicado($ex)) {
                    $errores['dni'] = 'Ya existe otro expediente con ese DNI.';
                } else {
                    error_log('Error al actualizar expediente: ' . $ex->getMessage());
                    $errores['general'] = 'Ocurrió un error al guardar. No se modificó el expediente; intente nuevamente.';
                }
            }
        }
    }
} else {
    $datos = datos_desde_fila($alumno);
    $docs  = docs_desde_db($tipos, $id);
}

render_header('Modificar expediente', $usuario);
render_form_estudiante($datos, $errores, $carreras, $tipos, $docs, 'editar.php?id=' . $id, 'Guardar cambios', 'ver.php?id=' . $id);
render_footer();
