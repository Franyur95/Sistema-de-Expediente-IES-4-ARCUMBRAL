<?php
/*
 * Lógica de expedientes: lectura de datos, validaciones y acceso a la base.
 */

const ESTADOS = ['Regular', 'Libre', 'Con pase', 'Abandono', 'Egresado'];

/* ---------- Lectura de datos enviados ---------- */

function campo(array $origen, string $clave): string
{
    $v = $origen[$clave] ?? '';
    return is_string($v) ? trim($v) : '';
}

function limpiar_espacios(string $v): string
{
    return trim((string)preg_replace('/\s+/u', ' ', $v));
}

function datos_desde_post(array $p): array
{
    return [
        'dni'              => (string)preg_replace('/[\s.]/', '', campo($p, 'dni')),
        'apellido'         => limpiar_espacios(campo($p, 'apellido')),
        'nombre'           => limpiar_espacios(campo($p, 'nombre')),
        'fecha_nacimiento' => campo($p, 'fecha_nacimiento'),
        'lugar_nacimiento' => limpiar_espacios(campo($p, 'lugar_nacimiento')),
        'domicilio'        => limpiar_espacios(campo($p, 'domicilio')),
        'telefono'         => limpiar_espacios(campo($p, 'telefono')),
        'titulo_ingreso'   => limpiar_espacios(campo($p, 'titulo_ingreso')),
        'establecimiento'  => limpiar_espacios(campo($p, 'establecimiento')),
        'anio_ingreso'     => campo($p, 'anio_ingreso'),
        'observaciones'    => str_replace("\r\n", "\n", campo($p, 'observaciones')),
        'estado'           => campo($p, 'estado'),
        'id_carrera'       => campo($p, 'id_carrera'),
    ];
}

function datos_vacios(array $usuario): array
{
    return [
        'dni' => '', 'apellido' => '', 'nombre' => '', 'fecha_nacimiento' => '',
        'lugar_nacimiento' => '', 'domicilio' => '', 'telefono' => '',
        'titulo_ingreso' => '', 'establecimiento' => '',
        'anio_ingreso' => date('Y'), 'observaciones' => '', 'estado' => 'Regular',
        'id_carrera' => $usuario['id_carrera'] === null ? '' : (string)$usuario['id_carrera'],
    ];
}

function datos_desde_fila(array $fila): array
{
    $d = [];
    foreach (datos_vacios(['id_carrera' => null]) as $k => $_) {
        $d[$k] = (string)($fila[$k] ?? '');
    }
    return $d;
}

/* ---------- Documentación ---------- */

function cargar_tipos(): array
{
    return db()->query('SELECT id_tipo, nombre, obligatorio FROM tipo_documento ORDER BY orden, id_tipo')->fetchAll();
}

function docs_vacios(array $tipos): array
{
    $docs = [];
    foreach ($tipos as $t) {
        $docs[(int)$t['id_tipo']] = ['presentado' => false, 'fecha' => '', 'obs' => ''];
    }
    return $docs;
}

function docs_desde_db(array $tipos, int $idEstudiante): array
{
    $docs = docs_vacios($tipos);
    $st = db()->prepare('SELECT id_tipo, presentado, fecha_presentacion, observaciones FROM documentacion_estudiante WHERE id_estudiante = ?');
    $st->execute([$idEstudiante]);
    foreach ($st->fetchAll() as $r) {
        $id = (int)$r['id_tipo'];
        if (isset($docs[$id])) {
            $docs[$id] = [
                'presentado' => (bool)$r['presentado'],
                'fecha'      => (string)($r['fecha_presentacion'] ?? ''),
                'obs'        => (string)($r['observaciones'] ?? ''),
            ];
        }
    }
    return $docs;
}

function docs_desde_post(array $p, array $tipos): array
{
    $pres   = is_array($p['doc_presentado'] ?? null) ? $p['doc_presentado'] : [];
    $fechas = is_array($p['doc_fecha'] ?? null) ? $p['doc_fecha'] : [];
    $obs    = is_array($p['doc_obs'] ?? null) ? $p['doc_obs'] : [];
    $docs = [];
    foreach ($tipos as $t) {
        $id = (int)$t['id_tipo'];
        $docs[$id] = [
            'presentado' => isset($pres[$id]),
            'fecha'      => isset($fechas[$id]) && is_string($fechas[$id]) ? trim($fechas[$id]) : '',
            'obs'        => isset($obs[$id]) && is_string($obs[$id]) ? limpiar_espacios($obs[$id]) : '',
        ];
    }
    return $docs;
}

function validar_docs(array $docs, array $tipos): array
{
    $nombres = [];
    foreach ($tipos as $t) {
        $nombres[(int)$t['id_tipo']] = $t['nombre'];
    }
    $err = [];
    $hoy = new DateTimeImmutable('today');
    foreach ($docs as $id => $d) {
        $n = $nombres[$id] ?? 'Documento';
        if ($d['fecha'] !== '') {
            $f = fecha_valida($d['fecha']);
            if (!$f) {
                $err['doc_' . $id] = $n . ': la fecha de presentación no es válida.';
            } elseif ($f > $hoy) {
                $err['doc_' . $id] = $n . ': la fecha de presentación no puede ser futura.';
            }
        }
        if (!isset($err['doc_' . $id]) && mb_strlen($d['obs']) > 255) {
            $err['doc_' . $id] = $n . ': las observaciones no pueden superar 255 caracteres.';
        }
    }
    return $err;
}

function guardar_docs(int $idEstudiante, array $docs): void
{
    $st = db()->prepare(
        'INSERT INTO documentacion_estudiante (id_estudiante, id_tipo, presentado, fecha_presentacion, observaciones)
         VALUES (?, ?, ?, ?, ?)
         ON DUPLICATE KEY UPDATE presentado = VALUES(presentado),
                                 fecha_presentacion = VALUES(fecha_presentacion),
                                 observaciones = VALUES(observaciones)'
    );
    foreach ($docs as $idTipo => $d) {
        $fecha = null;
        if ($d['presentado']) {
            $fecha = $d['fecha'] !== '' ? $d['fecha'] : date('Y-m-d');
        }
        $st->execute([$idEstudiante, $idTipo, $d['presentado'] ? 1 : 0, $fecha, $d['obs'] !== '' ? $d['obs'] : null]);
    }
}

/* ---------- Validaciones ---------- */

function fecha_valida(string $f): ?DateTimeImmutable
{
    $dt = DateTimeImmutable::createFromFormat('!Y-m-d', $f);
    $e = DateTimeImmutable::getLastErrors();
    if (!$dt || ($e && ($e['warning_count'] > 0 || $e['error_count'] > 0))) {
        return null;
    }
    return $dt->format('Y-m-d') === $f ? $dt : null;
}

function carreras_permitidas(array $usuario): array
{
    if ($usuario['id_carrera'] === null) {
        return db()->query('SELECT id_carrera, nombre, turno FROM carrera ORDER BY nombre')->fetchAll();
    }
    $st = db()->prepare('SELECT id_carrera, nombre, turno FROM carrera WHERE id_carrera = ?');
    $st->execute([$usuario['id_carrera']]);
    return $st->fetchAll();
}

/**
 * Devuelve un arreglo campo => mensaje. Vacío si todo es correcto.
 * $idActual = 0 al crear; el id del alumno al modificar (para ignorarse a sí mismo en duplicados).
 */
function validar_estudiante(array $d, array $usuario, int $idActual): array
{
    $e = [];

    // DNI
    if ($d['dni'] === '') {
        $e['dni'] = 'El DNI es obligatorio.';
    } elseif (!preg_match('/^\d{6,9}$/', $d['dni'])) {
        $e['dni'] = 'El DNI debe tener solo números (entre 6 y 9 dígitos), sin puntos.';
    }

    // Apellido y nombre
    foreach (['apellido' => 'El apellido', 'nombre' => 'El nombre'] as $k => $etq) {
        if ($d[$k] === '') {
            $e[$k] = $etq . ' es obligatorio.';
        } elseif (mb_strlen($d[$k]) > 50) {
            $e[$k] = $etq . ' no puede superar 50 caracteres.';
        } elseif (!preg_match("/^\p{L}[\p{L}\s'.\-]*$/u", $d[$k])) {
            $e[$k] = $etq . ' solo puede contener letras, espacios, apóstrofes, puntos y guiones.';
        }
    }

    // Fecha de nacimiento
    $hoy = new DateTimeImmutable('today');
    if ($d['fecha_nacimiento'] === '') {
        $e['fecha_nacimiento'] = 'La fecha de nacimiento es obligatoria.';
    } else {
        $f = fecha_valida($d['fecha_nacimiento']);
        if (!$f) {
            $e['fecha_nacimiento'] = 'La fecha de nacimiento no es válida.';
        } elseif ($f > $hoy) {
            $e['fecha_nacimiento'] = 'La fecha de nacimiento no puede ser futura.';
        } elseif ((int)$f->format('Y') < 1920) {
            $e['fecha_nacimiento'] = 'Revise el año de nacimiento (anterior a 1920).';
        } elseif ($f->diff($hoy)->y < 16) {
            $e['fecha_nacimiento'] = 'El alumno debe tener al menos 16 años.';
        }
    }

    // Campos de texto
    if (mb_strlen($d['lugar_nacimiento']) > 80) {
        $e['lugar_nacimiento'] = 'El lugar de nacimiento no puede superar 80 caracteres.';
    }
    if (mb_strlen($d['domicilio']) > 120) {
        $e['domicilio'] = 'El domicilio no puede superar 120 caracteres.';
    }
    if ($d['telefono'] !== '' && !preg_match('/^[0-9+\-\s()]{6,40}$/', $d['telefono'])) {
        $e['telefono'] = 'El teléfono solo puede tener números, espacios, +, - y paréntesis (mínimo 6 caracteres).';
    }
    foreach (['titulo_ingreso' => 'El título con el que ingresó', 'establecimiento' => 'El establecimiento que lo otorga'] as $k => $etq) {
        if ($d[$k] === '') {
            $e[$k] = $etq . ' es obligatorio.';
        } elseif (mb_strlen($d[$k]) > 100) {
            $e[$k] = $etq . ' no puede superar 100 caracteres.';
        }
    }

    // Año de ingreso
    $anioMax = (int)date('Y') + 1;
    if ($d['anio_ingreso'] === '') {
        $e['anio_ingreso'] = 'El año de ingreso es obligatorio.';
    } elseif (!ctype_digit($d['anio_ingreso']) || (int)$d['anio_ingreso'] < 1980 || (int)$d['anio_ingreso'] > $anioMax) {
        $e['anio_ingreso'] = 'El año de ingreso debe estar entre 1980 y ' . $anioMax . '.';
    }

    if (mb_strlen($d['observaciones']) > 2000) {
        $e['observaciones'] = 'Las observaciones no pueden superar 2000 caracteres.';
    }

    // Estado
    if (!in_array($d['estado'], ESTADOS, true)) {
        $e['estado'] = 'Seleccione un estado válido.';
    }

    // Carrera
    if ($d['id_carrera'] === '' || !ctype_digit($d['id_carrera'])) {
        $e['id_carrera'] = 'Seleccione una carrera.';
    } else {
        $st = db()->prepare('SELECT 1 FROM carrera WHERE id_carrera = ?');
        $st->execute([(int)$d['id_carrera']]);
        if (!$st->fetchColumn()) {
            $e['id_carrera'] = 'La carrera seleccionada no existe.';
        } elseif (!carrera_permitida($usuario, (int)$d['id_carrera'])) {
            $e['id_carrera'] = 'No tiene permiso para trabajar con esa carrera.';
        }
    }

    // Duplicados (solo si los datos base son correctos)
    if (!isset($e['dni'])) {
        $st = db()->prepare('SELECT 1 FROM estudiante WHERE dni = ? AND id_estudiante <> ?');
        $st->execute([$d['dni'], $idActual]);
        if ($st->fetchColumn()) {
            $e['dni'] = 'Ya existe un expediente con ese DNI. Búsquelo en "Buscar alumnos".';
        }
    }
    if (!isset($e['dni']) && !isset($e['apellido']) && !isset($e['nombre']) && !isset($e['fecha_nacimiento'])) {
        $st = db()->prepare('SELECT 1 FROM estudiante WHERE apellido = ? AND nombre = ? AND fecha_nacimiento = ? AND id_estudiante <> ?');
        $st->execute([$d['apellido'], $d['nombre'], $d['fecha_nacimiento'], $idActual]);
        if ($st->fetchColumn()) {
            $e['apellido'] = 'Ya existe un expediente con el mismo apellido, nombre y fecha de nacimiento (posible duplicado con otro DNI).';
        }
    }

    return $e;
}

function es_duplicado(PDOException $ex): bool
{
    return (int)($ex->errorInfo[1] ?? 0) === 1062;
}

/* ---------- Acceso a datos ---------- */

function parametros_estudiante(array $d): array
{
    $nulo = static fn(string $v) => $v === '' ? null : $v;
    return [
        $d['dni'], $d['apellido'], $d['nombre'], $d['fecha_nacimiento'],
        $nulo($d['lugar_nacimiento']), $nulo($d['domicilio']), $nulo($d['telefono']),
        $d['titulo_ingreso'], $d['establecimiento'], (int)$d['anio_ingreso'],
        $nulo($d['observaciones']), $d['estado'], (int)$d['id_carrera'],
    ];
}

function obtener_estudiante(int $id): ?array
{
    $st = db()->prepare(
        'SELECT e.*, c.nombre AS carrera, c.turno, c.resolucion
         FROM estudiante e JOIN carrera c ON c.id_carrera = e.id_carrera
         WHERE e.id_estudiante = ?'
    );
    $st->execute([$id]);
    $fila = $st->fetch();
    return $fila ?: null;
}

function crear_estudiante(array $d, array $docs, int $idUsuario): int
{
    $pdo = db();
    $pdo->beginTransaction();
    try {
        $st = $pdo->prepare(
            'INSERT INTO estudiante (dni, apellido, nombre, fecha_nacimiento, lugar_nacimiento, domicilio, telefono,
                                     titulo_ingreso, establecimiento, anio_ingreso, observaciones, estado, id_carrera)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
        );
        $st->execute(parametros_estudiante($d));
        $id = (int)$pdo->lastInsertId();
        guardar_docs($id, $docs);
        auditar('Alta de expediente', 'Expediente creado', $id, $idUsuario);
        $pdo->commit();
        return $id;
    } catch (Throwable $ex) {
        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }
        throw $ex;
    }
}

function actualizar_estudiante(int $id, array $d, array $docs, int $idUsuario): void
{
    $pdo = db();
    $pdo->beginTransaction();
    try {
        $antes = obtener_estudiante($id);
        $docsAntes = docs_desde_db(cargar_tipos(), $id);

        $st = $pdo->prepare(
            'UPDATE estudiante SET dni = ?, apellido = ?, nombre = ?, fecha_nacimiento = ?, lugar_nacimiento = ?,
                    domicilio = ?, telefono = ?, titulo_ingreso = ?, establecimiento = ?, anio_ingreso = ?,
                    observaciones = ?, estado = ?, id_carrera = ?
             WHERE id_estudiante = ?'
        );
        $st->execute(array_merge(parametros_estudiante($d), [$id]));
        guardar_docs($id, $docs);

        // Registro de auditoría: solo nombres de campos modificados.
        $cambios = [];
        foreach ($d as $campo => $nuevo) {
            if ((string)($antes[$campo] ?? '') !== (string)$nuevo) {
                $cambios[] = $campo;
            }
        }
        if ($docsAntes != $docs) {
            $cambios[] = 'documentacion';
        }
        auditar('Modificación de expediente', $cambios ? 'Campos: ' . implode(', ', $cambios) : 'Sin cambios', $id, $idUsuario);
        $pdo->commit();
    } catch (Throwable $ex) {
        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }
        throw $ex;
    }
}

/** Lee el parámetro ?id= y devuelve un entero positivo o 0. */
function id_desde_get(): int
{
    $v = $_GET['id'] ?? '';
    return is_string($v) && ctype_digit($v) && strlen($v) < 10 ? (int)$v : 0;
}
