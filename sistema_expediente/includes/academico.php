<?php
/*
 * Situación académica según el "Modelo de situación académica" de la institución:
 *  - Registro de inscripciones para cursar y recursar  -> tabla inscripcion
 *  - Cursada por espacio curricular                    -> tabla cursada
 *  - Exámenes finales (intentos, libro, folio)         -> tabla examen
 */

const CARACTERES   = ['Regular', 'Libre', 'Promocion'];
const CONDICIONES  = ['Cursar', 'Recursar'];
const TIPOS_EXAMEN = ['Regular', 'Libre'];
const NOTA_APROBACION = 4; // Nota mínima para considerar aprobado un final.
const NOMBRES_ANIO = [1 => 'PRIMER AÑO', 2 => '2.º AÑO', 3 => '3.er AÑO', 4 => '4.º AÑO'];

const TABLAS_REGISTRO = [
    'inscripcion' => ['inscripcion', 'id_inscripcion', 'Inscripción'],
    'cursada'     => ['cursada', 'id_cursada', 'Cursada'],
    'examen'      => ['examen', 'id_examen', 'Examen'],
];

/* ---------- Lectura ---------- */

function materias_de_carrera(int $idCarrera): array
{
    $st = db()->prepare('SELECT id_materia, anio, nombre FROM materia WHERE id_carrera = ? ORDER BY anio, orden, id_materia');
    $st->execute([$idCarrera]);
    return $st->fetchAll();
}

function nombre_materia(int $idMateria): string
{
    $st = db()->prepare('SELECT nombre FROM materia WHERE id_materia = ?');
    $st->execute([$idMateria]);
    return (string)$st->fetchColumn();
}

function nota_fmt($n): string
{
    if ($n === null || $n === '') {
        return '';
    }
    return rtrim(rtrim(number_format((float)$n, 2, ',', ''), '0'), ',');
}

function listar_inscripciones(int $idEst): array
{
    $st = db()->prepare(
        'SELECT i.id_inscripcion, i.fecha, i.anio_cursada, i.condicion, i.observaciones, m.nombre AS materia
         FROM inscripcion i JOIN materia m ON m.id_materia = i.id_materia
         WHERE i.id_estudiante = ? ORDER BY i.fecha, i.id_inscripcion'
    );
    $st->execute([$idEst]);
    return $st->fetchAll();
}

function listar_cursadas(int $idEst): array
{
    $st = db()->prepare(
        'SELECT c.id_cursada, c.anio_cursada, c.asistencia, c.tp, c.caracter, c.promedio, m.nombre AS materia, m.anio
         FROM cursada c JOIN materia m ON m.id_materia = c.id_materia
         WHERE c.id_estudiante = ? ORDER BY m.anio, m.orden, c.anio_cursada'
    );
    $st->execute([$idEst]);
    return $st->fetchAll();
}

function listar_examenes(int $idEst): array
{
    $st = db()->prepare(
        'SELECT x.id_examen, x.tipo, x.fecha, x.nota, x.libro, x.folio, x.observacion, m.nombre AS materia, m.anio
         FROM examen x JOIN materia m ON m.id_materia = x.id_materia
         WHERE x.id_estudiante = ? ORDER BY m.anio, m.orden, x.fecha, x.id_examen'
    );
    $st->execute([$idEst]);
    return $st->fetchAll();
}

/** Reúne materias, cursadas y exámenes del alumno para armar la grilla por año. */
function situacion_academica(int $idEst, int $idCarrera): array
{
    $cursadas = [];
    $st = db()->prepare('SELECT * FROM cursada WHERE id_estudiante = ? ORDER BY id_materia, anio_cursada');
    $st->execute([$idEst]);
    foreach ($st->fetchAll() as $r) {
        $cursadas[(int)$r['id_materia']][] = $r;
    }

    $examenes = [];
    $st = db()->prepare('SELECT * FROM examen WHERE id_estudiante = ? ORDER BY id_materia, fecha, id_examen');
    $st->execute([$idEst]);
    foreach ($st->fetchAll() as $r) {
        $examenes[(int)$r['id_materia']][] = $r;
    }

    return ['materias' => materias_de_carrera($idCarrera), 'cursadas' => $cursadas, 'examenes' => $examenes];
}

/* ---------- Presentación (réplica de la ficha en papel) ---------- */

function render_inscripciones(array $filas): void
{
    if (!$filas) {
        echo '<p>No hay inscripciones registradas.</p>';
        return;
    }
    echo '<div class="tabla-wrap"><table class="tabla"><thead><tr>'
       . '<th>Fecha de inscripción</th><th>Curso</th><th>Año de cursada</th><th>Condición</th><th>Observaciones</th>'
       . '</tr></thead><tbody>';
    foreach ($filas as $f) {
        echo '<tr><td>' . e(fecha_ar($f['fecha'])) . '</td><td>' . e($f['materia']) . '</td><td>' . (int)$f['anio_cursada']
           . '</td><td>' . e($f['condicion']) . '</td><td>' . e($f['observaciones'] ?? '') . '</td></tr>';
    }
    echo '</tbody></table></div>';
}

function celda($valor, string $clase = ''): string
{
    return '<td' . ($clase !== '' ? ' class="' . $clase . '"' : '') . '>' . e($valor) . '</td>';
}

function celda_examen(?array $x): string
{
    if (!$x) {
        return '<td></td><td></td>';
    }
    $marca = $x['tipo'] === 'Libre' ? ' <small>(Libre)</small>' : '';
    return '<td>' . e(fecha_ar($x['fecha'])) . $marca . '</td><td class="centro">' . e(nota_fmt($x['nota'])) . '</td>';
}

function render_situacion_academica(array $sit): void
{
    $porAnio = [];
    foreach ($sit['materias'] as $m) {
        $porAnio[(int)$m['anio']][] = $m;
    }
    if (!$porAnio) {
        echo '<p>La carrera no tiene espacios curriculares cargados. Ejecute <code>database/materias_ed_fisica.sql</code>.</p>';
        return;
    }

    foreach (NOMBRES_ANIO as $anio => $titulo) {
        if (empty($porAnio[$anio])) {
            continue;
        }
        echo '<h3>' . e($titulo) . '</h3><div class="tabla-wrap"><table class="tabla tabla-acad"><thead>'
           . '<tr><th colspan="6"></th><th colspan="10">EXAMEN FINAL</th></tr>'
           . '<tr><th>Espacios curriculares</th><th>Año que cursó</th><th>% Asistencia</th><th>% T.P.</th><th>Carácter</th><th>Promedio</th>'
           . '<th>Fecha</th><th>Calif.</th><th>Fecha</th><th>Calif.</th><th>Fecha</th><th>Calif.</th>'
           . '<th>Calificación definitiva</th><th>Libro</th><th>Folio</th><th>Observación</th></tr></thead><tbody>';

        foreach ($porAnio[$anio] as $m) {
            $idm = (int)$m['id_materia'];
            $cursadas = $sit['cursadas'][$idm] ?? [];
            $exs = $sit['examenes'][$idm] ?? [];

            // Calificación definitiva: el último intento aprobado.
            $def = null;
            foreach ($exs as $x) {
                if ((float)$x['nota'] >= NOTA_APROBACION) {
                    $def = $x;
                }
            }
            $obs = $def ? (string)($def['observacion'] ?? '') : '';
            if (count($exs) > 3) {
                $obs = trim($obs . ' (+' . (count($exs) - 3) . ' intento/s más: ver Situación académica)');
            }

            $filas = max(1, count($cursadas));
            for ($i = 0; $i < $filas; $i++) {
                $c = $cursadas[$i] ?? null;
                echo '<tr>' . celda($i === 0 ? $m['nombre'] : '', 'espacio');
                echo celda($c ? $c['anio_cursada'] : '', 'centro');
                echo celda($c && $c['asistencia'] !== null && $c['asistencia'] !== '' ? $c['asistencia'] . '%' : '', 'centro');
                echo celda($c && $c['tp'] !== null ? $c['tp'] . '%' : '', 'centro');
                echo celda($c ? $c['caracter'] : '', 'centro');
                echo celda($c ? nota_fmt($c['promedio']) : '', 'centro');
                if ($i === 0) {
                    echo celda_examen($exs[0] ?? null) . celda_examen($exs[1] ?? null) . celda_examen($exs[2] ?? null);
                    echo celda($def ? nota_fmt($def['nota']) : '', 'centro definitiva');
                    echo celda($def ? $def['libro'] : '', 'centro') . celda($def ? $def['folio'] : '', 'centro') . celda($obs);
                } else {
                    echo str_repeat('<td></td>', 10);
                }
                echo '</tr>';
            }
        }
        echo '</tbody></table></div>';
    }
}

/* ---------- Validaciones ---------- */

function err_materia(string $v, array $idsMaterias): ?string
{
    if ($v === '' || !ctype_digit($v)) {
        return 'Seleccione el espacio curricular.';
    }
    return in_array((int)$v, $idsMaterias, true) ? null : 'El espacio curricular no corresponde a la carrera del alumno.';
}

function err_fecha_pasada(string $v, string $etq): ?string
{
    if ($v === '') {
        return $etq . ' es obligatoria.';
    }
    $f = fecha_valida($v);
    if (!$f) {
        return $etq . ' no es válida.';
    }
    return $f > new DateTimeImmutable('today') ? $etq . ' no puede ser futura.' : null;
}

function err_anio_cursada(string $v): ?string
{
    $max = (int)date('Y') + 1;
    if ($v === '' || !ctype_digit($v) || (int)$v < 2000 || (int)$v > $max) {
        return 'El año de cursada debe estar entre 2000 y ' . $max . '.';
    }
    return null;
}

function err_porcentaje(string $v, string $etq): ?string
{
    if ($v === '') {
        return null;
    }
    return (ctype_digit($v) && (int)$v <= 100) ? null : $etq . ' debe ser un número entero entre 0 y 100.';
}

/** Devuelve la nota normalizada ("7.5") o null si no es válida (0 a 10, hasta 2 decimales). */
function normalizar_nota(string $v): ?string
{
    $v = str_replace(',', '.', trim($v));
    if (!preg_match('/^\d{1,2}(\.\d{1,2})?$/', $v) || (float)$v > 10) {
        return null;
    }
    return $v;
}

function validar_inscripcion(array $p, array $idsMaterias, int $idEst): array
{
    $d = [
        'id_materia'    => campo($p, 'id_materia'),
        'fecha'         => campo($p, 'fecha'),
        'anio_cursada'  => campo($p, 'anio_cursada'),
        'condicion'     => campo($p, 'condicion'),
        'observaciones' => limpiar_espacios(campo($p, 'observaciones')),
    ];
    $e = [];
    if ($m = err_materia($d['id_materia'], $idsMaterias)) { $e['id_materia'] = $m; }
    if ($m = err_fecha_pasada($d['fecha'], 'La fecha de inscripción')) { $e['fecha'] = $m; }
    if ($m = err_anio_cursada($d['anio_cursada'])) { $e['anio_cursada'] = $m; }
    if (!in_array($d['condicion'], CONDICIONES, true)) { $e['condicion'] = 'Seleccione la condición.'; }
    if (mb_strlen($d['observaciones']) > 200) { $e['observaciones'] = 'Las observaciones no pueden superar 200 caracteres.'; }

    if (!$e) {
        $st = db()->prepare('SELECT 1 FROM inscripcion WHERE id_estudiante = ? AND id_materia = ? AND anio_cursada = ? AND condicion = ?');
        $st->execute([$idEst, (int)$d['id_materia'], (int)$d['anio_cursada'], $d['condicion']]);
        if ($st->fetchColumn()) {
            $e['id_materia'] = 'Ya existe esa inscripción (mismo espacio, año y condición).';
        }
    }
    return [$e, $d];
}

function validar_cursada(array $p, array $idsMaterias): array
{
    $d = [
        'id_materia'   => campo($p, 'id_materia'),
        'anio_cursada' => campo($p, 'anio_cursada'),
        'asistencia'   => campo($p, 'asistencia'),
        'tp'           => campo($p, 'tp'),
        'caracter'     => campo($p, 'caracter'),
        'promedio'     => campo($p, 'promedio'),
    ];
    $e = [];
    if ($m = err_materia($d['id_materia'], $idsMaterias)) { $e['id_materia'] = $m; }
    if ($m = err_anio_cursada($d['anio_cursada'])) { $e['anio_cursada'] = $m; }
    if ($m = err_porcentaje($d['asistencia'], 'El % de asistencia')) { $e['asistencia'] = $m; }
    if ($m = err_porcentaje($d['tp'], 'El % de trabajos prácticos')) { $e['tp'] = $m; }
    if (!in_array($d['caracter'], CARACTERES, true)) { $e['caracter'] = 'Seleccione el carácter.'; }
    if ($d['promedio'] !== '') {
        $n = normalizar_nota($d['promedio']);
        if ($n === null) {
            $e['promedio'] = 'El promedio debe ser un número entre 0 y 10 (hasta 2 decimales).';
        } else {
            $d['promedio'] = $n;
        }
    }
    return [$e, $d];
}

function validar_examen(array $p, array $idsMaterias, int $idEst): array
{
    $d = [
        'id_materia'  => campo($p, 'id_materia'),
        'tipo'        => campo($p, 'tipo'),
        'fecha'       => campo($p, 'fecha'),
        'nota'        => campo($p, 'nota'),
        'libro'       => limpiar_espacios(campo($p, 'libro')),
        'folio'       => limpiar_espacios(campo($p, 'folio')),
        'observacion' => limpiar_espacios(campo($p, 'observacion')),
    ];
    $e = [];
    if ($m = err_materia($d['id_materia'], $idsMaterias)) { $e['id_materia'] = $m; }
    if (!in_array($d['tipo'], TIPOS_EXAMEN, true)) { $e['tipo'] = 'Seleccione el tipo de examen.'; }
    if ($m = err_fecha_pasada($d['fecha'], 'La fecha del examen')) { $e['fecha'] = $m; }
    $n = normalizar_nota($d['nota']);
    if ($d['nota'] === '') {
        $e['nota'] = 'La calificación es obligatoria.';
    } elseif ($n === null) {
        $e['nota'] = 'La calificación debe ser un número entre 0 y 10.';
    } else {
        $d['nota'] = $n;
    }
    foreach (['libro' => 'El libro', 'folio' => 'El folio'] as $k => $etq) {
        if ($d[$k] === '') {
            $e[$k] = $etq . ' es obligatorio.';
        } elseif (mb_strlen($d[$k]) > 50) {
            $e[$k] = $etq . ' no puede superar 50 caracteres.';
        }
    }
    if (mb_strlen($d['observacion']) > 200) { $e['observacion'] = 'La observación no puede superar 200 caracteres.'; }

    if (!$e) {
        $st = db()->prepare('SELECT 1 FROM examen WHERE id_estudiante = ? AND id_materia = ? AND fecha = ?');
        $st->execute([$idEst, (int)$d['id_materia'], $d['fecha']]);
        if ($st->fetchColumn()) {
            $e['fecha'] = 'Ya hay un examen cargado de ese espacio en esa fecha.';
        }
    }
    return [$e, $d];
}

/* ---------- Escritura ---------- */

function en_transaccion(callable $fn)
{
    $pdo = db();
    $pdo->beginTransaction();
    try {
        $r = $fn($pdo);
        $pdo->commit();
        return $r;
    } catch (Throwable $ex) {
        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }
        throw $ex;
    }
}

function guardar_inscripcion(int $idEst, array $d, int $idUsuario): void
{
    en_transaccion(function (PDO $pdo) use ($idEst, $d, $idUsuario) {
        $st = $pdo->prepare('INSERT INTO inscripcion (fecha, anio_cursada, condicion, observaciones, id_estudiante, id_materia) VALUES (?, ?, ?, ?, ?, ?)');
        $st->execute([$d['fecha'], (int)$d['anio_cursada'], $d['condicion'], $d['observaciones'] !== '' ? $d['observaciones'] : null, $idEst, (int)$d['id_materia']]);
        auditar('Alta de inscripción', nombre_materia((int)$d['id_materia']) . ' (' . $d['condicion'] . ' ' . $d['anio_cursada'] . ')', $idEst, $idUsuario);
    });
}

/** Si ya existe la cursada de ese espacio y año, se actualiza. */
function guardar_cursada(int $idEst, array $d, int $idUsuario): void
{
    en_transaccion(function (PDO $pdo) use ($idEst, $d, $idUsuario) {
        $nulo = static fn(string $v) => $v === '' ? null : $v;
        $st = $pdo->prepare(
            'INSERT INTO cursada (anio_cursada, asistencia, tp, caracter, promedio, id_estudiante, id_materia)
             VALUES (?, ?, ?, ?, ?, ?, ?)
             ON DUPLICATE KEY UPDATE asistencia = VALUES(asistencia), tp = VALUES(tp),
                                     caracter = VALUES(caracter), promedio = VALUES(promedio)'
        );
        $st->execute([(int)$d['anio_cursada'], $nulo($d['asistencia']), $d['tp'] === '' ? null : (int)$d['tp'],
                      $d['caracter'], $nulo($d['promedio']), $idEst, (int)$d['id_materia']]);
        auditar('Carga de cursada', nombre_materia((int)$d['id_materia']) . ' (' . $d['anio_cursada'] . ')', $idEst, $idUsuario);
    });
}

function guardar_examen(int $idEst, array $d, int $idUsuario): void
{
    en_transaccion(function (PDO $pdo) use ($idEst, $d, $idUsuario) {
        $st = $pdo->prepare('INSERT INTO examen (tipo, fecha, nota, libro, folio, observacion, id_estudiante, id_materia) VALUES (?, ?, ?, ?, ?, ?, ?, ?)');
        $st->execute([$d['tipo'], $d['fecha'], $d['nota'], $d['libro'], $d['folio'], $d['observacion'] !== '' ? $d['observacion'] : null, $idEst, (int)$d['id_materia']]);
        auditar('Alta de examen', nombre_materia((int)$d['id_materia']) . ' (' . $d['fecha'] . ')', $idEst, $idUsuario);
    });
}

/** Devuelve una descripción del registro (solo si pertenece al alumno) o null. */
function descripcion_registro(string $tipo, int $idReg, int $idEst): ?string
{
    if (!isset(TABLAS_REGISTRO[$tipo])) {
        return null;
    }
    [$tabla, $pk, $etq] = TABLAS_REGISTRO[$tipo];
    $st = db()->prepare("SELECT m.nombre, t.* FROM $tabla t JOIN materia m ON m.id_materia = t.id_materia WHERE t.$pk = ? AND t.id_estudiante = ?");
    $st->execute([$idReg, $idEst]);
    $r = $st->fetch();
    if (!$r) {
        return null;
    }
    $extra = $tipo === 'examen' ? fecha_ar($r['fecha']) . ', nota ' . nota_fmt($r['nota'])
           : ($tipo === 'inscripcion' ? $r['condicion'] . ' ' . $r['anio_cursada'] : 'año ' . $r['anio_cursada']);
    return $etq . ': ' . $r['nombre'] . ' (' . $extra . ')';
}

function eliminar_registro(string $tipo, int $idReg, int $idEst, int $idUsuario): bool
{
    $desc = descripcion_registro($tipo, $idReg, $idEst);
    if ($desc === null) {
        return false;
    }
    [$tabla, $pk] = TABLAS_REGISTRO[$tipo];
    en_transaccion(function (PDO $pdo) use ($tabla, $pk, $idReg, $idEst, $idUsuario, $desc) {
        $st = $pdo->prepare("DELETE FROM $tabla WHERE $pk = ? AND id_estudiante = ?");
        $st->execute([$idReg, $idEst]);
        auditar('Eliminación de registro académico', $desc, $idEst, $idUsuario);
    });
    return true;
}
