<?php
/*
 * Situación académica:
 *  - Inscripción a materias y submaterias -> tabla cursadas
 *  - Datos académicos de la cursada       -> tabla cursadas
 *  - Exámenes finales                    -> tabla examenes_finales
 *
 * Las inscripciones administrativas a 1.º, 2.º, 3.º y 4.º año
 * se gestionan por separado en inscripciones_curso.
 */

const CARACTERES = ['Regular', 'Libre', 'Promocion'];
const CONDICIONES = ['Cursando', 'Recursando'];
const TIPOS_EXAMEN = ['Regular', 'Libre'];
const NOTA_APROBACION = 4;

// Régimen académico (relevado en las entrevistas): la regularidad dura 2 años y,
// por cada cursada, hay 3 intentos como Regular y 3 como Libre. Agotados, se recursa.
const REGULARIDAD_ANIOS = 2;
const INTENTOS_MAX_POR_CONDICION = 3;

const NOMBRES_ANIO = [
    1 => 'PRIMER AÑO',
    2 => '2.º AÑO',
    3 => '3.er AÑO',
    4 => '4.º AÑO'
];

const TABLAS_REGISTRO = [
    'inscripcion' => ['cursadas', 'id_cursada', 'Inscripción'],
    'cursada' => ['cursadas', 'id_cursada', 'Cursada'],
    'examen' => ['examenes_finales', 'id_examen', 'Examen'],
        'inscripcion_curso' => ['inscripciones_curso', 'id_inscripcion', 'Inscripción al curso'],
    ];

/* =========================================================
   LECTURA
   ========================================================= */

function materias_de_carrera(int $idCarrera): array
{
    $st = db()->prepare("
        SELECT
            m.id_materia,
            m.anio,
            m.nombre
        FROM materias m
        INNER JOIN planes p ON p.id_plan = m.id_plan
        WHERE p.id_carrera = ?
          AND p.activo = 1
          AND m.activa = 1
        ORDER BY m.anio, m.orden, m.id_materia
    ");

    $st->execute([$idCarrera]);

    return $st->fetchAll(PDO::FETCH_ASSOC);
}

function nombre_materia(int $idMateria): string
{
    $st = db()->prepare("
        SELECT nombre
        FROM materias
        WHERE id_materia = ?
    ");

    $st->execute([$idMateria]);

    return (string)$st->fetchColumn();
}

function nota_fmt($n): string
{
    if ($n === null || $n === '') {
        return '';
    }

    return rtrim(
        rtrim(number_format((float)$n, 2, ',', ''), '0'),
        ','
    );
}

/*
 * Inscripciones a materias y submaterias.
 * Corresponden a la inscripción inicial de cada espacio curricular.
 */
function listar_inscripciones(int $idEst): array
{
    $st = db()->prepare("
        SELECT
            c.id_cursada,
            c.fecha_inscripcion,
            c.anio_cursada,
            c.tipo_inscripcion,
            c.observaciones,
            m.nombre AS materia,
            sm.nombre AS submateria
        FROM cursadas c
        INNER JOIN materias m ON m.id_materia = c.id_materia
        LEFT JOIN submaterias sm ON sm.id_submateria = c.id_submateria
        WHERE c.id_estudiante = ?
          AND c.fecha_inscripcion IS NOT NULL
        ORDER BY c.fecha_inscripcion DESC, c.id_cursada DESC
    ");

    $st->execute([$idEst]);

    return $st->fetchAll(PDO::FETCH_ASSOC);
}

/*
 * Inscripciones administrativas al curso (1.º a 4.º año).
 * Esta información se muestra en ver.php, no en la gestión académica.
 */
function listar_inscripciones_curso(int $idEst): array
{
    $st = db()->prepare("
        SELECT
            id_inscripcion,
            fecha_inscripcion,
            curso,
            condicion,
            observaciones
        FROM inscripciones_curso
        WHERE id_estudiante = ?
        ORDER BY fecha_inscripcion DESC, id_inscripcion DESC
    ");

    $st->execute([$idEst]);

    return $st->fetchAll(PDO::FETCH_ASSOC);
}

function render_inscripciones_curso(array $filas, bool $conAcciones = false, int $idEst = 0): void
{
    if (!$filas) {
        echo '<p>No hay registros de inscripción al curso.</p>';
        return;
    }

    echo '<div class="tabla-wrap"><table class="tabla"><thead><tr>'
        . '<th>Fecha de inscripción</th>'
        . '<th>Curso</th>'
        . '<th>Condición</th>'
        . '<th>Observaciones</th>'
        . ($conAcciones ? '<th></th>' : '')
        . '</tr></thead><tbody>';

    foreach ($filas as $f) {
        echo '<tr>'
            . '<td>' . e(fecha_ar($f['fecha_inscripcion'])) . '</td>'
            . '<td>' . (int)$f['curso'] . '.º año</td>'
            . '<td>' . e(ucfirst($f['condicion'])) . '</td>'
            . '<td>' . e($f['observaciones'] ?? '') . '</td>'
            . ($conAcciones
                ? '<td><a href="academico.php?id=' . $idEst . '&amp;del=inscripcion_curso:'
                    . (int)$f['id_inscripcion'] . '#confirmar">Eliminar</a></td>'
                : '')
            . '</tr>';
    }

    echo '</tbody></table></div>';
}
/*
 * Devuelve todas las cursadas que tienen inscripción.
 * Incluye también las que todavía no tienen asistencia,
 * trabajos prácticos, carácter ni promedio.
 *
 * Se utiliza para llenar los selectores de cursadas.
 */
function listar_cursadas_para_seleccion(int $idEst): array
{
    $st = db()->prepare("
        SELECT
            c.id_cursada,
            c.id_materia,
            c.id_submateria,
            c.anio_cursada,
            c.fecha_inscripcion,
            c.tipo_inscripcion,
            c.caracter,
            (SELECT COUNT(*) FROM examenes_finales x
              WHERE x.id_cursada = c.id_cursada AND x.estado = 'presente'
                AND x.condicion_alumno = 'regular') AS int_regular,
            (SELECT COUNT(*) FROM examenes_finales x
              WHERE x.id_cursada = c.id_cursada AND x.estado = 'presente'
                AND x.condicion_alumno = 'libre') AS int_libre,
            m.nombre AS materia,
            sm.nombre AS submateria
        FROM cursadas c
        INNER JOIN materias m ON m.id_materia = c.id_materia
        LEFT JOIN submaterias sm ON sm.id_submateria = c.id_submateria
        WHERE c.id_estudiante = ?
          AND c.fecha_inscripcion IS NOT NULL
        ORDER BY m.anio, m.orden, c.anio_cursada, c.id_cursada
    ");

    $st->execute([$idEst]);

    return $st->fetchAll(PDO::FETCH_ASSOC);
}

/*
 * Devuelve las cursadas que ya tienen algún dato académico cargado.
 */
function listar_cursadas(int $idEst): array
{
    $st = db()->prepare("
        SELECT
            c.id_cursada,
            c.id_materia,
            c.id_submateria,
            c.anio_cursada,
            c.asistencia,
            c.tp,
            CASE c.caracter
                WHEN 'regular' THEN 'Regular'
                WHEN 'libre' THEN 'Libre'
                WHEN 'promocional' THEN 'Promocion'
                ELSE ''
            END AS caracter,
            c.promedio,
            m.nombre AS materia,
            sm.nombre AS submateria,
            m.anio
        FROM cursadas c
        INNER JOIN materias m ON m.id_materia = c.id_materia
        LEFT JOIN submaterias sm ON sm.id_submateria = c.id_submateria
        WHERE c.id_estudiante = ?
          AND c.fecha_inscripcion IS NOT NULL
          AND (
              c.caracter IS NOT NULL
              OR c.asistencia IS NOT NULL
              OR c.tp IS NOT NULL
              OR c.promedio IS NOT NULL
          )
        ORDER BY m.anio, m.orden, c.anio_cursada, c.id_cursada
    ");

    $st->execute([$idEst]);

    return $st->fetchAll(PDO::FETCH_ASSOC);
}

/*
 * Devuelve los exámenes finales del estudiante.
 * El tipo se obtiene de condicion_alumno.
 */
function listar_examenes(int $idEst): array
{
    $st = db()->prepare("
        SELECT
            e.*,
            m.nombre AS materia,
            sm.nombre AS submateria,
            CASE e.condicion_alumno
                WHEN 'libre' THEN 'Libre'
                WHEN 'promocion' THEN 'Promoción'
                ELSE 'Regular'
            END AS tipo
        FROM examenes_finales e
        INNER JOIN materias m ON m.id_materia = e.id_materia
        LEFT JOIN submaterias sm ON sm.id_submateria = e.id_submateria
        WHERE e.id_estudiante = ?
        ORDER BY e.fecha DESC, e.id_examen DESC
    ");

    $st->execute([$idEst]);

    return $st->fetchAll(PDO::FETCH_ASSOC);
}

/*
 * Busca una cursada específica y comprueba que:
 * 1. Pertenece al estudiante.
 * 2. Tiene una inscripción vigente.
 *
 * Se utiliza para validar la carga de cursadas y exámenes.
 */
function obtener_cursada_estudiante(
    int $idCursada,
    int $idEst
): ?array {
    $st = db()->prepare("
        SELECT
            c.id_cursada,
            c.id_materia,
            c.id_submateria,
            c.anio_cursada,
            c.fecha_inscripcion,
            m.nombre AS materia,
            sm.nombre AS submateria
        FROM cursadas c
        INNER JOIN materias m ON m.id_materia = c.id_materia
        LEFT JOIN submaterias sm ON sm.id_submateria = c.id_submateria
        WHERE c.id_cursada = ?
          AND c.id_estudiante = ?
          AND c.fecha_inscripcion IS NOT NULL
    ");

    $st->execute([$idCursada, $idEst]);

    $r = $st->fetch(PDO::FETCH_ASSOC);

    return $r ?: null;
}

/* =========================================================
   SITUACIÓN ACADÉMICA GENERAL
   ========================================================= */

/*
 * Reúne materias, cursadas y exámenes para armar
 * la grilla académica por año.
 */
function situacion_academica(int $idEst, int $idCarrera): array
{
    $materias = materias_de_carrera($idCarrera);
    $espacios = [];

    // Expandir materias que tienen submaterias.
    $stSub = db()->prepare("
        SELECT id_submateria, nombre
        FROM submaterias
        WHERE id_materia = ?
        ORDER BY orden, id_submateria
    ");

    foreach ($materias as $m) {
        $idMateria = (int)$m['id_materia'];

        $stSub->execute([$idMateria]);
        $submaterias = $stSub->fetchAll(PDO::FETCH_ASSOC);

        if ($submaterias) {
            foreach ($submaterias as $sm) {
                $espacios[] = [
                    'id_materia' => $idMateria,
                    'id_submateria' => (int)$sm['id_submateria'],
                    'anio' => (int)$m['anio'],
                    'nombre' => $m['nombre'] . ' - ' . $sm['nombre']
                ];
            }
        } else {
            $espacios[] = [
                'id_materia' => $idMateria,
                'id_submateria' => null,
                'anio' => (int)$m['anio'],
                'nombre' => $m['nombre']
            ];
        }
    }

    // Cursadas agrupadas por materia y submateria.
    $cursadas = [];

    $st = db()->prepare("
        SELECT
            c.*,
            CASE c.caracter
                WHEN 'regular' THEN 'Regular'
                WHEN 'libre' THEN 'Libre'
                WHEN 'promocional' THEN 'Promocion'
                ELSE ''
            END AS caracter
        FROM cursadas c
        WHERE c.id_estudiante = ?
          AND c.fecha_inscripcion IS NOT NULL
          AND (
              c.caracter IS NOT NULL
              OR c.asistencia IS NOT NULL
              OR c.tp IS NOT NULL
              OR c.promedio IS NOT NULL
          )
        ORDER BY
            c.id_materia,
            c.id_submateria,
            c.anio_cursada,
            c.id_cursada
    ");

    $st->execute([$idEst]);

    foreach ($st->fetchAll(PDO::FETCH_ASSOC) as $r) {
        $clave = $r['id_materia'] . ':' . ($r['id_submateria'] ?? 0);
        $cursadas[$clave][] = $r;
    }

    // Exámenes agrupados por materia y submateria.
    $examenes = [];

    $st = db()->prepare("
        SELECT
            x.*,
            CASE x.condicion_alumno
                WHEN 'libre' THEN 'Libre'
                WHEN 'promocion' THEN 'Promoción'
                ELSE 'Regular'
            END AS tipo
        FROM examenes_finales x
        WHERE x.id_estudiante = ?
          AND x.estado = 'presente'
        ORDER BY
            x.id_materia,
            x.id_submateria,
            x.fecha,
            x.id_examen
    ");

    $st->execute([$idEst]);

    foreach ($st->fetchAll(PDO::FETCH_ASSOC) as $r) {
        $clave = $r['id_materia'] . ':' . ($r['id_submateria'] ?? 0);
        $examenes[$clave][] = $r;
    }

    return [
        'materias' => $espacios,
        'cursadas' => $cursadas,
        'examenes' => $examenes
    ];
}

/* =========================================================
   PRESENTACIÓN
   ========================================================= */

function render_inscripciones(array $filas): void
{
    if (!$filas) {
        echo '<p>No hay inscripciones registradas.</p>';
        return;
    }

    echo '<div class="tabla-wrap"><table class="tabla"><thead><tr>'
        . '<th>Fecha de inscripción</th>'
        . '<th>Espacio curricular</th>'
        . '<th>Año de cursada</th>'
        . '<th>Condición</th>'
        . '<th>Observaciones</th>'
        . '</tr></thead><tbody>';

    foreach ($filas as $f) {
        $espacio = $f['materia'];

        if (!empty($f['submateria'])) {
            $espacio .= ' - ' . $f['submateria'];
        }

        echo '<tr>'
            . '<td>' . e(fecha_ar($f['fecha_inscripcion'])) . '</td>'
            . '<td>' . e($espacio) . '</td>'
            . '<td>' . (int)$f['anio_cursada'] . '</td>'
            . '<td>' . e(ucfirst($f['tipo_inscripcion'])) . '</td>'
            . '<td>' . e($f['observaciones'] ?? '') . '</td>'
            . '</tr>';
    }

    echo '</tbody></table></div>';
}

function celda($valor, string $clase = ''): string
{
    return '<td'
        . ($clase !== '' ? ' class="' . $clase . '"' : '')
        . '>'
        . e($valor)
        . '</td>';
}

function celda_examen(?array $x): string
{
    if (!$x) {
        return '<td></td><td></td>';
    }

    $marca = ($x['tipo'] ?? '') === 'Libre'
        ? ' <small>(Libre)</small>'
        : '';

    return '<td>'
        . e(fecha_ar($x['fecha']))
        . $marca
        . '</td><td class="centro">'
        . e(nota_fmt($x['nota']))
        . '</td>';
}

function render_situacion_academica(array $sit): void
{
    $porAnio = [];

    foreach ($sit['materias'] as $m) {
        $porAnio[(int)$m['anio']][] = $m;
    }

    if (!$porAnio) {
        echo '<p>La carrera no tiene espacios curriculares activos asociados a un plan vigente en la base de datos.</p>';
        return;
    }

    foreach (NOMBRES_ANIO as $anio => $titulo) {
        if (empty($porAnio[$anio])) {
            continue;
        }

        echo '<h3>' . e($titulo) . '</h3>';
        echo '<div class="tabla-wrap"><table class="tabla tabla-acad"><thead>';
        echo '<tr><th colspan="6"></th><th colspan="10">EXAMEN FINAL</th></tr>';
        echo '<tr>'
            . '<th>Espacios curriculares</th>'
            . '<th>Año que cursó</th>'
            . '<th>% Asistencia</th>'
            . '<th>% T.P.</th>'
            . '<th>Carácter</th>'
            . '<th>Promedio</th>'
            . '<th>Fecha</th>'
            . '<th>Calif.</th>'
            . '<th>Fecha</th>'
            . '<th>Calif.</th>'
            . '<th>Fecha</th>'
            . '<th>Calif.</th>'
            . '<th>Calificación definitiva</th>'
            . '<th>Libro</th>'
            . '<th>Folio</th>'
            . '<th>Observación</th>'
            . '</tr></thead><tbody>';

        foreach ($porAnio[$anio] as $m) {
            $idm = (int)$m['id_materia'];
            $idsm = $m['id_submateria'] ?? null;

            $clave = $idm . ':' . ($idsm ?? 0);

            $cursadas = $sit['cursadas'][$clave] ?? [];
            $exs = $sit['examenes'][$clave] ?? [];

            // Calificación definitiva: último intento aprobado.
            $def = null;

            foreach ($exs as $x) {
                if ((float)$x['nota'] >= NOTA_APROBACION) {
                    $def = $x;
                }
            }

            $obs = $def ? (string)($def['observacion'] ?? '') : '';

            if (count($exs) > 3) {
                $obs = trim(
                    $obs . ' (+' . (count($exs) - 3)
                    . ' intento/s más: ver Situación académica)'
                );
            }

            $filas = max(1, count($cursadas));

            for ($i = 0; $i < $filas; $i++) {
                $c = $cursadas[$i] ?? null;

                echo '<tr>';
                echo celda($i === 0 ? $m['nombre'] : '', 'espacio');
                echo celda($c ? $c['anio_cursada'] : '', 'centro');

                echo celda(
                    $c && $c['asistencia'] !== null && $c['asistencia'] !== ''
                        ? $c['asistencia'] . '%'
                        : '',
                    'centro'
                );

                echo celda(
                    $c && $c['tp'] !== null
                        ? $c['tp'] . '%'
                        : '',
                    'centro'
                );

                echo celda($c ? $c['caracter'] : '', 'centro');
                echo celda($c ? nota_fmt($c['promedio']) : '', 'centro');

                if ($i === 0) {
                    echo celda_examen($exs[0] ?? null);
                    echo celda_examen($exs[1] ?? null);
                    echo celda_examen($exs[2] ?? null);

                    echo celda(
                        $def ? nota_fmt($def['nota']) : '',
                        'centro definitiva'
                    );

                    echo celda($def ? $def['libro'] : '', 'centro');
                    echo celda($def ? $def['folio'] : '', 'centro');
                    echo celda($obs);
                } else {
                    echo str_repeat('<td></td>', 10);
                }

                echo '</tr>';
            }
        }

        echo '</tbody></table></div>';
    }
}

/* =========================================================
   VALIDACIONES
   ========================================================= */

function err_materia(string $v, array $idsMaterias): ?string
{
    if ($v === '' || !ctype_digit($v)) {
        return 'Seleccione el espacio curricular.';
    }

    return in_array((int)$v, $idsMaterias, true) ? null : 'El espacio curricular no está habilitado para el año que cursa el alumno.';
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

    return $f > new DateTimeImmutable('today')
        ? $etq . ' no puede ser futura.'
        : null;
}

function err_anio_cursada(string $v): ?string
{
    $max = (int)date('Y') + 1;

    if (
        $v === ''
        || !ctype_digit($v)
        || (int)$v < 2000
        || (int)$v > $max
    ) {
        return 'El año de cursada debe estar entre 2000 y ' . $max . '.';
    }

    return null;
}

function err_porcentaje(string $v, string $etq): ?string
{
    if ($v === '') {
        return null;
    }

    return (ctype_digit($v) && (int)$v <= 100)
        ? null
        : $etq . ' debe ser un número entero entre 0 y 100.';
}

/*
 * Devuelve la nota normalizada o null si no es válida.
 * Rango permitido: 0 a 10, hasta dos decimales.
 */
function normalizar_nota(string $v): ?string
{
    $v = str_replace(',', '.', trim($v));

    if (!preg_match('/^\d{1,2}(\.\d{1,2})?$/', $v) || (float)$v > 10) {
        return null;
    }

    return $v;
}

/*
 * Validar inscripción a materia o submateria.
 */
/*
 * Consulta las correlativas que el estudiante todavía no cumple.
 *
 * tipoRequisito:
 * - cursar: exige tener la correlativa regular.
 * - rendir: exige tener la correlativa aprobada.
 */

function documentos_anuales_pendientes_para_cursar(
    int $idEstudiante
): array {
    $anio = (int)date('Y');

    $st = db()->prepare("
        SELECT td.id_tipo, td.nombre
        FROM tipos_documento td
        WHERE td.obligatorio = 1
          AND td.vence = 1
          AND td.activo = 1
          AND NOT EXISTS (
              SELECT 1
              FROM documentacion_estudiante de
              WHERE de.id_estudiante = ?
                AND de.id_tipo = td.id_tipo
                AND de.anio_lectivo = ?
                AND de.presentado = 1
          )
        ORDER BY td.orden, td.id_tipo
    ");

    $st->execute([$idEstudiante, $anio]);

    return $st->fetchAll(PDO::FETCH_ASSOC);
}

function correlativas_pendientes(
    int $idEst,
    int $idMateria,
    string $tipoRequisito
): array {
    $st = db()->prepare("
        SELECT materia_requerida, condicion, estado_requerida
        FROM v_correlatividades_estado
        WHERE id_estudiante = ?
          AND id_materia_objetivo = ?
          AND tipo_requisito = ?
          AND cumple = 0
        ORDER BY materia_requerida
    ");

    $st->execute([
        $idEst,
        $idMateria,
        $tipoRequisito
    ]);

    return $st->fetchAll(PDO::FETCH_ASSOC);
}

function examen_ya_aprobado(
    int $idEst,
    int $idCursada,
    ?int $idSubmateria
): bool {
    // Comprobar si la cursada fue aprobada por promoción.
    $st = db()->prepare("
        SELECT COUNT(*)
        FROM cursadas
        WHERE id_cursada = ?
          AND id_estudiante = ?
          AND caracter = 'promocional'
          AND estado = 'promocional'
    ");

    $st->execute([$idCursada, $idEst]);

    if ((int)$st->fetchColumn() > 0) {
        return true;
    }

    // Comprobar si aprobó mediante un examen final.
    $st = db()->prepare("
        SELECT COUNT(*)
        FROM examenes_finales
        WHERE id_estudiante = ?
          AND id_cursada = ?
          AND id_submateria <=> ?
          AND nota >= ?
    ");

    $st->execute([
        $idEst,
        $idCursada,
        $idSubmateria,
        NOTA_APROBACION
    ]);

    return (int)$st->fetchColumn() > 0;
}

/* =========================================================
   REGLAS DEL RÉGIMEN: REGULARIDAD E INTENTOS DE EXAMEN
   ========================================================= */

/** Exámenes rendidos (presente) en una cursada, separados por condición. */
function intentos_examen_cursada(int $idEst, int $idCursada): array
{
    $st = db()->prepare("
        SELECT condicion_alumno, COUNT(*)
        FROM examenes_finales
        WHERE id_estudiante = ?
          AND id_cursada = ?
          AND estado = 'presente'
        GROUP BY condicion_alumno
    ");

    $st->execute([$idEst, $idCursada]);

    $n = ['regular' => 0, 'libre' => 0];

    foreach ($st->fetchAll(PDO::FETCH_NUM) as $fila) {
        if (isset($n[$fila[0]])) {
            $n[$fila[0]] = (int)$fila[1];
        }
    }

    return $n;
}

/** Texto informativo para el selector de cursadas. */
function texto_intentos_cursada(array $c): string
{
    $max = INTENTOS_MAX_POR_CONDICION;

    $txt = 'Regular ' . (int)($c['int_regular'] ?? 0) . '/' . $max
        . ' · Libre ' . (int)($c['int_libre'] ?? 0) . '/' . $max
        . ' · regularidad hasta ' . ((int)$c['anio_cursada'] + REGULARIDAD_ANIOS);

    if (($c['caracter'] ?? null) === null) {
        $txt = 'carácter sin cargar · ' . $txt;
    }

    return $txt;
}

/*
 * Controla si el alumno puede rendir un examen final en esa cursada.
 * Devuelve el mensaje de error, o null si puede rendir.
 *
 *  - La cursada debe tener su carácter cargado (Regular o Libre).
 *  - Como Regular: la regularidad dura REGULARIDAD_ANIOS años desde el año de
 *    cursada y hay INTENTOS_MAX_POR_CONDICION intentos.
 *  - Como Libre: solo si la cursada quedó Libre, si venció la regularidad o si se
 *    agotaron los intentos como Regular; también con un máximo de intentos.
 *  - Agotados los intentos Libres, debe recursar (nueva cursada, nuevos intentos).
 */
function err_reglas_examen(int $idEst, int $idCursada, string $tipo, string $fecha): ?string
{
    $st = db()->prepare('SELECT anio_cursada, caracter FROM cursadas WHERE id_cursada = ? AND id_estudiante = ?');
    $st->execute([$idCursada, $idEst]);
    $c = $st->fetch(PDO::FETCH_ASSOC);

    if (!$c) {
        return null; // Los demás controles ya informan que la cursada no corresponde.
    }

    $max = INTENTOS_MAX_POR_CONDICION;
    $anioCursada = (int)$c['anio_cursada'];
    $hasta = $anioCursada + REGULARIDAD_ANIOS;
    $f = fecha_valida($fecha);
    $anioExamen = $f ? (int)$f->format('Y') : (int)date('Y');
    $vigente = $anioExamen <= $hasta;
    $n = intentos_examen_cursada($idEst, $idCursada);

    if ($c['caracter'] === null) {
        return 'La cursada ' . $anioCursada . ' todavía no tiene el carácter cargado (sigue en curso). '
             . 'Cárguelo en «Cursada por espacio curricular» antes de registrar un examen.';
    }

    if ($c['caracter'] === 'promocional') {
        return 'Esta cursada se aprobó por promoción: no corresponde registrar examen final.';
    }

    if ($tipo === 'Regular') {
        if ($c['caracter'] === 'libre') {
            return 'En esta cursada el alumno quedó en condición Libre: el examen debe registrarse como Libre.';
        }
        if (!$vigente) {
            return 'La regularidad de la cursada ' . $anioCursada . ' venció en ' . $hasta
                 . '. Corresponde rendir como Libre o recursar el espacio.';
        }
        if ($n['regular'] >= $max) {
            return 'Ya usó los ' . $max . ' intentos como Regular de esta cursada. Corresponde rendir como Libre.';
        }
        return null;
    }

    // Examen Libre.
    if ($n['libre'] >= $max) {
        return 'Ya usó los ' . $max . ' intentos como Libre de esta cursada: debe recursar el espacio curricular.';
    }

    $puedeLibre = $c['caracter'] === 'libre' || !$vigente || $n['regular'] >= $max;

    if (!$puedeLibre) {
        return 'Todavía tiene regularidad vigente (hasta ' . $hasta . ') y le quedan '
             . ($max - $n['regular']) . ' intento(s) como Regular. '
             . 'Solo puede rendir como Libre al agotarlos o al vencer la regularidad.';
    }

    return null;
}
/*
 * La inscripción a una materia exige que el alumno esté inscripto al curso
 * ese año lectivo, y que la materia no sea de un año superior a ese curso.
 */
function err_materia_vs_curso(int $idEst, int $idMateria, int $anioCursada): ?string
{
    $st = db()->prepare('SELECT anio FROM materias WHERE id_materia = ?');
    $st->execute([$idMateria]);
    $anioMateria = (int)$st->fetchColumn();

    $st = db()->prepare("
        SELECT MAX(curso)
        FROM inscripciones_curso
        WHERE id_estudiante = ?
          AND YEAR(fecha_inscripcion) = ?
    ");
    $st->execute([$idEst, $anioCursada]);
    $curso = $st->fetchColumn();

    if ($curso === false || $curso === null) {
        return 'Antes de inscribir a materias debe registrar la inscripción al curso de '
             . $anioCursada . ' en «Registro de inscripción al curso».';
    }

    if ($anioMateria > (int)$curso) {
        return 'En ' . $anioCursada . ' el alumno está inscripto a ' . (int)$curso
             . '.º año: no puede inscribirse a una materia de ' . $anioMateria . '.º año.';
    }

    return null;
}
function validar_inscripcion(
    array $p,
    array $idsMaterias,
    int $idEst
): array {
    $d = [
        'id_materia' => campo($p, 'id_materia'),
        'id_submateria' => campo($p, 'id_submateria'),
        'fecha' => campo($p, 'fecha'),
        'anio_cursada' => campo($p, 'anio_cursada'),
        'condicion' => campo($p, 'condicion'),
        'observaciones' => limpiar_espacios(campo($p, 'observaciones'))
    ];

    $e = [];

    if ($m = err_materia($d['id_materia'], $idsMaterias)) {
        $e['id_materia'] = $m;
    }

    if ($m = err_fecha_pasada($d['fecha'], 'La fecha de inscripción')) {
        $e['fecha'] = $m;
    }

    if ($m = err_anio_cursada($d['anio_cursada'])) {
        $e['anio_cursada'] = $m;
    }

    if (!in_array($d['condicion'], CONDICIONES, true)) {
        $e['condicion'] = 'Seleccione la condición.';
    }

    if (mb_strlen($d['observaciones']) > 200) {
        $e['observaciones'] = 'Máximo 200 caracteres.';
    }

    // Validar que la submateria pertenezca a la materia seleccionada.
    if ($d['id_submateria'] !== '') {
        if (!ctype_digit($d['id_submateria'])) {
            $e['id_submateria'] = 'La submateria seleccionada no es válida.';
        } else {
            $d['id_submateria'] = (int)$d['id_submateria'];

            $st = db()->prepare("
                SELECT COUNT(*)
                FROM submaterias
                WHERE id_submateria = ?
                  AND id_materia = ?
            ");

            $st->execute([
                $d['id_submateria'],
                (int)$d['id_materia']
            ]);

            if (!(int)$st->fetchColumn()) {
                $e['id_submateria'] = 'La submateria no corresponde a la materia seleccionada.';
            }
        }
    } else {
        $d['id_submateria'] = null;
    }
    // Verificar que el estudiante cumpla las correlativas para cursar.
if (!$e && $d['id_materia'] !== '') {
    $pendientes = correlativas_pendientes(
        $idEst,
        (int)$d['id_materia'],
        'cursar'
    );

    if ($pendientes) {
        $nombres = array_column(
            $pendientes,
            'materia_requerida'
        );

        $e['id_materia'] =
            'No puede inscribirse en esta materia porque todavía '
            . 'no cumple las siguientes correlativas: '
            . implode(', ', $nombres) . '.';
    }
}   
    // La materia tiene que corresponder al curso en que está inscripto ese año.
    if (!$e) {
        if ($m = err_materia_vs_curso($idEst, (int)$d['id_materia'], (int)$d['anio_cursada'])) {
            $e['id_materia'] = $m;
        }
    }
    // Evitar duplicar el mismo espacio curricular en el mismo año.
    if (!$e) {
        $st = db()->prepare("
            SELECT COUNT(*)
            FROM cursadas
            WHERE id_estudiante = ?
              AND id_materia = ?
              AND anio_cursada = ?
              AND (
                    id_submateria = ?
                    OR (id_submateria IS NULL AND ? IS NULL)
              )
        ");

        $st->execute([
            $idEst,
            (int)$d['id_materia'],
            (int)$d['anio_cursada'],
            $d['id_submateria'],
            $d['id_submateria']
        ]);

        if ((int)$st->fetchColumn() > 0) {
            $e['anio_cursada'] = 'El alumno ya tiene una inscripción o cursada registrada para este espacio curricular durante ese año.';
        }
    }
    
// Verificar que tenga los documentos anuales obligatorios.
$documentosPendientes = documentos_anuales_pendientes_para_cursar($idEst);

if ($documentosPendientes) {
    $nombres = array_column(
        $documentosPendientes,
        'nombre'
    );

    $e['documentacion'] =
        'No puede inscribirse a materias porque falta presentar '
        . 'la documentación obligatoria del año actual: '
        . implode(', ', $nombres) . '.';
}

    return [$e, $d];
}

/*
 * Validar los datos académicos de una cursada ya inscripta.
 */
function validar_cursada(array $p, int $idEst): array
{
    $d = [
        'id_cursada' => campo($p, 'id_cursada'),
        'asistencia' => campo($p, 'asistencia'),
        'tp' => campo($p, 'tp'),
        'caracter' => campo($p, 'caracter'),
        'promedio' => campo($p, 'promedio'),
        'id_materia' => null,
        'id_submateria' => null,
        'anio_cursada' => null,
        'nombre_espacio' => '',
        'submateria' => ''
    ];

    $e = [];

    if ($d['id_cursada'] === '' || !ctype_digit($d['id_cursada'])) {
        $e['id_cursada'] = 'Seleccione una cursada.';
    } else {
        $c = obtener_cursada_estudiante(
            (int)$d['id_cursada'],
            $idEst
        );

        if (!$c) {
            $e['id_cursada'] = 'La cursada seleccionada no corresponde al estudiante o no tiene inscripción.';
        } else {
            $d['id_materia'] = (int)$c['id_materia'];
            $d['id_submateria'] = $c['id_submateria'];
            $d['anio_cursada'] = (int)$c['anio_cursada'];
            $d['nombre_espacio'] = $c['materia'];
            $d['submateria'] = $c['submateria'] ?? '';
        }
    }

    if ($m = err_porcentaje($d['asistencia'], 'El % de asistencia')) {
        $e['asistencia'] = $m;
    }

    if ($m = err_porcentaje($d['tp'], 'El % de trabajos prácticos')) {
        $e['tp'] = $m;
    }

    if (!in_array($d['caracter'], CARACTERES, true)) {
        $e['caracter'] = 'Seleccione el carácter.';
    }

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

/*
 * Validar un examen final vinculado a una cursada.
 */
function validar_examen(array $p, int $idEst): array
{
    $d = [
        'id_cursada' => campo($p, 'id_cursada'),
        'id_materia' => null,
        'id_submateria' => null,
        'nombre_espacio' => '',
        'submateria' => '',
        'tipo' => campo($p, 'tipo'),
        'fecha' => campo($p, 'fecha'),
        'nota' => campo($p, 'nota'),
        'libro' => limpiar_espacios(campo($p, 'libro')),
        'folio' => limpiar_espacios(campo($p, 'folio')),
        'observacion' => limpiar_espacios(campo($p, 'observacion'))
    ];

    $e = [];

    if ($d['id_cursada'] === '' || !ctype_digit($d['id_cursada'])) {
        $e['id_cursada'] = 'Seleccione la cursada correspondiente.';
    } else {
        $c = obtener_cursada_estudiante(
            (int)$d['id_cursada'],
            $idEst
        );

        if (!$c) {
    $e['id_cursada'] = 'La cursada seleccionada no corresponde al estudiante o no tiene inscripción.';
} else {
    $d['id_materia'] = (int)$c['id_materia'];
    $d['id_submateria'] = $c['id_submateria'];
    $d['nombre_espacio'] = $c['materia'];
    $d['submateria'] = $c['submateria'] ?? '';
    // Verificar si ya aprobó el examen de esta materia o submateria.
if (examen_ya_aprobado(
    $idEst,
    (int)$c['id_cursada'],
    $d['id_submateria'] !== null
        ? (int)$d['id_submateria']
        : null
)) {
    $e['id_cursada'] =
        'No puede inscribirse nuevamente porque ya aprobó esta materia.';
}
    // Verificar que tenga aprobadas las correlativas para rendir.
    $pendientes = correlativas_pendientes(
        $idEst,
        $d['id_materia'],
        'rendir'
    );

    if ($pendientes) {
        $nombres = array_column(
            $pendientes,
            'materia_requerida'
        );

        $e['id_cursada'] =
            'No puede rendir este examen porque todavía '
            . 'no tiene aprobadas las siguientes correlativas: '
            . implode(', ', $nombres) . '.';
    }
}
    }

    if (!in_array($d['tipo'], TIPOS_EXAMEN, true)) {
        $e['tipo'] = 'Seleccione el tipo de examen.';
    }

    if ($m = err_fecha_pasada($d['fecha'], 'La fecha del examen')) {
        $e['fecha'] = $m;
    }

    $n = normalizar_nota($d['nota']);

    if ($d['nota'] === '') {
        $e['nota'] = 'La calificación es obligatoria.';
    } elseif ($n === null) {
        $e['nota'] = 'La calificación debe ser un número entre 0 y 10.';
    } else {
        $d['nota'] = $n;
    }

    foreach ([
        'libro' => 'El libro',
        'folio' => 'El folio'
    ] as $k => $etq) {
        if ($d[$k] === '') {
            $e[$k] = $etq . ' es obligatorio.';
        } elseif (mb_strlen($d[$k]) > 20) {
            $e[$k] = $etq . ' no puede superar 20 caracteres.';
        }
    }

    if (mb_strlen($d['observacion']) > 200) {
        $e['observacion'] = 'La observación no puede superar 200 caracteres.';
    }

    // Reglas del régimen: regularidad (2 años) e intentos (3 Regular + 3 Libre por cursada).
    if (
        $d['id_cursada'] !== ''
        && !isset($e['id_cursada'])
        && !isset($e['tipo'])
        && !isset($e['fecha'])
    ) {
        if ($m = err_reglas_examen($idEst, (int)$d['id_cursada'], $d['tipo'], $d['fecha'])) {
            $e['tipo'] = $m;
        }
    }

    // Evitar duplicar un examen de la misma cursada en la misma fecha.
    if (!$e) {
        $st = db()->prepare("
            SELECT 1
            FROM examenes_finales
            WHERE id_estudiante = ?
              AND id_cursada = ?
              AND fecha = ?
        ");

        $st->execute([
            $idEst,
            (int)$d['id_cursada'],
            $d['fecha']
        ]);

        if ($st->fetchColumn()) {
            $e['fecha'] = 'Ya hay un examen cargado para esa cursada en esa fecha.';
        }
    }

    return [$e, $d];
}

/* =========================================================
   ESCRITURA Y TRANSACCIONES
   ========================================================= */

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

function nombre_espacio_academico(
    int $idMateria,
    ?int $idSubmateria = null
): string {
    $nombre = nombre_materia($idMateria);

    if ($idSubmateria !== null) {
        $st = db()->prepare("
            SELECT nombre
            FROM submaterias
            WHERE id_submateria = ?
              AND id_materia = ?
        ");

        $st->execute([$idSubmateria, $idMateria]);

        $sub = $st->fetchColumn();

        if (!$sub) {
            throw new RuntimeException(
                'La submateria no corresponde a la materia seleccionada.'
            );
        }

        return $nombre . ' - ' . $sub;
    }

    return $nombre;
}

/*
 * Registrar la inscripción inicial a una materia o submateria.
 */
function guardar_inscripcion(
    int $idEst,
    array $d,
    int $idUsuario
): int {
    return en_transaccion(function (PDO $pdo) use ($idEst, $d, $idUsuario) {
        $idMateria = (int)$d['id_materia'];
        
        // Volver a comprobar los documentos antes de guardar.
        $documentosPendientes = documentos_anuales_pendientes_para_cursar($idEst);

        if ($documentosPendientes) {
            $nombres = array_column(
                $documentosPendientes,
                'nombre'
            );

            throw new RuntimeException(
                'No se puede realizar la inscripción porque falta presentar '
                . 'la documentación obligatoria del año actual: '
                . implode(', ', $nombres) . '.'
            );
        }

        // Volver a comprobar las correlativas antes de guardar.
$pendientes = correlativas_pendientes(
    $idEst,
    $idMateria,
    'cursar'
);

if ($pendientes) {
    $nombres = array_column(
        $pendientes,
        'materia_requerida'
    );

    throw new RuntimeException(
        'No se puede realizar la inscripción. '
        . 'Faltan aprobar o regularizar estas correlativas: '
        . implode(', ', $nombres) . '.'
    );
}        // Volver a comprobar que la materia corresponde al curso de ese año.
        if ($m = err_materia_vs_curso($idEst, $idMateria, (int)$d['anio_cursada'])) {
            throw new RuntimeException($m);
        }
        $idSubmateria = $d['id_submateria'] !== null
            ? (int)$d['id_submateria']
            : null;

        $anio = (int)$d['anio_cursada'];

        $nombre = nombre_espacio_academico(
            $idMateria,
            $idSubmateria
        );

        // Segunda comprobación antes de insertar.
        $st = $pdo->prepare("
            SELECT COUNT(*)
            FROM cursadas
            WHERE id_estudiante = ?
              AND id_materia = ?
              AND anio_cursada = ?
              AND (
                    id_submateria = ?
                    OR (id_submateria IS NULL AND ? IS NULL)
              )
        ");

        $st->execute([
            $idEst,
            $idMateria,
            $anio,
            $idSubmateria,
            $idSubmateria
        ]);

        if ((int)$st->fetchColumn() > 0) {
            throw new RuntimeException(
                'El alumno ya tiene una inscripción o cursada registrada para este espacio curricular durante ese año.'
            );
        }

        $tipo = $d['condicion'] === 'Recursando'
            ? 'recursar'
            : 'cursar';

        $st = $pdo->prepare("
            INSERT INTO cursadas (
                id_estudiante,
                id_materia,
                id_submateria,
                anio_cursada,
                fecha_inscripcion,
                tipo_inscripcion,
                estado,
                observaciones
            ) VALUES (?, ?, ?, ?, ?, ?, 'cursando', ?)
        ");

        $st->execute([
            $idEst,
            $idMateria,
            $idSubmateria,
            $anio,
            $d['fecha'],
            $tipo,
            $d['observaciones']
        ]);

        $idCursada = (int)$pdo->lastInsertId();

        auditar(
            'Alta de inscripción',
            $nombre . ' (' . $d['condicion'] . ' ' . $anio . ')',
            $idEst,
            $idUsuario
        );

        return $idCursada;
    });
}

/*
 * Guardar o actualizar los datos académicos de una cursada.
 */
function guardar_cursada(
    int $idEst,
    array $d,
    int $idUsuario
): void {
    en_transaccion(function (PDO $pdo) use ($idEst, $d, $idUsuario) {
        $idCursada = (int)$d['id_cursada'];

        $c = obtener_cursada_estudiante($idCursada, $idEst);

        if (!$c) {
            throw new RuntimeException(
                'La cursada seleccionada no corresponde al estudiante.'
            );
        }

        $nulo = static fn($v) => $v === '' ? null : $v;

        $caracter = [
            'Regular' => 'regular',
            'Libre' => 'libre',
            'Promocion' => 'promocional'
        ][$d['caracter']] ?? null;

        if ($caracter === null) {
            throw new RuntimeException(
                'El carácter de cursada no es válido.'
            );
        }

        $st = $pdo->prepare("
            UPDATE cursadas
            SET asistencia = ?,
                tp = ?,
                caracter = ?,
                promedio = ?,
                estado = ?
            WHERE id_cursada = ?
              AND id_estudiante = ?
              AND fecha_inscripcion IS NOT NULL
        ");

        $st->execute([
            $nulo($d['asistencia']),
            $nulo($d['tp']),
            $caracter,
            $nulo(str_replace(',', '.', $d['promedio'])),
            $caracter,
            $idCursada,
            $idEst
        ]);

        $nombre = $c['materia'];

        if (!empty($c['submateria'])) {
            $nombre .= ' - ' . $c['submateria'];
        }

        auditar(
            'Carga de cursada',
            $nombre . ' (cursada #' . $idCursada . ')',
            $idEst,
            $idUsuario
        );
    });
}

/*
 * Registrar un examen final asociado a una cursada existente.
 */

function guardar_examen(
    int $idEst,
    array $d,
    int $idUsuario
): void {
    en_transaccion(function (PDO $pdo) use ($idEst, $d, $idUsuario) {
        $idCursada = (int)$d['id_cursada'];

        $c = obtener_cursada_estudiante($idCursada, $idEst);

        if (!$c) {
            throw new RuntimeException(
                'La cursada seleccionada no corresponde al estudiante.'
            );
        }

        // Verificar que cumpla las correlativas para rendir.
        $pendientes = correlativas_pendientes(
            $idEst,
            (int)$c['id_materia'],
            'rendir'
        );

        if ($pendientes) {
            $nombres = array_column(
                $pendientes,
                'materia_requerida'
            );

            throw new RuntimeException(
                'No se puede registrar el examen. '
                . 'Faltan aprobar estas correlativas: '
                . implode(', ', $nombres) . '.'
            );
        }

        // Verificar que no haya aprobado anteriormente esta materia o submateria.
        if (examen_ya_aprobado(
            $idEst,
            $idCursada,
            $c['id_submateria'] !== null
                ? (int)$c['id_submateria']
                : null
        )) {
            throw new RuntimeException(
                'No se puede registrar el examen porque el estudiante ya aprobó esta materia.'
            );
        }

        // Regularidad e intentos (control también en el servidor al guardar).
        if ($m = err_reglas_examen($idEst, $idCursada, $d['tipo'], $d['fecha'])) {
            throw new RuntimeException($m);
        }

        $cond = $d['tipo'] === 'Libre'
            ? 'libre'
            : 'regular';

        // Número de intento dentro de la cursada seleccionada.
        $st = $pdo->prepare("
            SELECT COALESCE(MAX(numero_intento), 0) + 1
            FROM examenes_finales
            WHERE id_cursada = ?
        ");

        $st->execute([$idCursada]);

        $intento = (int)$st->fetchColumn();

        $st = $pdo->prepare("
            INSERT INTO examenes_finales (
                id_estudiante,
                id_materia,
                id_submateria,
                id_cursada,
                numero_intento,
                condicion_alumno,
                fecha,
                nota,
                estado,
                libro,
                folio,
                observacion
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'presente', ?, ?, ?)
        ");

        $st->execute([
            $idEst,
            (int)$c['id_materia'],
            $c['id_submateria'],
            $idCursada,
            $intento,
            $cond,
            $d['fecha'],
            $d['nota'],
            $d['libro'],
            $d['folio'],
            $d['observacion'] !== '' ? $d['observacion'] : null
        ]);

        $nombre = $c['materia'];

        if (!empty($c['submateria'])) {
            $nombre .= ' - ' . $c['submateria'];
        }

        auditar(
            'Alta de examen',
            $nombre . ' (cursada #' . $idCursada . ', intento ' . $intento . ')',
            $idEst,
            $idUsuario
        );
    });
}


/* =========================================================
   DESCRIPCIÓN Y ELIMINACIÓN DE REGISTROS
   ========================================================= */

function descripcion_registro(
    string $tipo,
    int $idReg,
    int $idEst
): ?string {
    if (!isset(TABLAS_REGISTRO[$tipo])) {
        return null;
    }
        if ($tipo === 'inscripcion_curso') {
        $st = db()->prepare("
            SELECT curso, fecha_inscripcion, condicion
            FROM inscripciones_curso
            WHERE id_inscripcion = ?
              AND id_estudiante = ?
        ");
        $st->execute([$idReg, $idEst]);
        $r = $st->fetch(PDO::FETCH_ASSOC);

        return $r
            ? 'Inscripción al curso: ' . (int)$r['curso'] . '.º año ('
              . $r['condicion'] . ', ' . fecha_ar($r['fecha_inscripcion']) . ')'
            : null;
    }
    if ($tipo === 'examen') {
        $st = db()->prepare("
            SELECT
                m.nombre,
                sm.nombre AS submateria,
                x.fecha,
                x.nota,
                x.id_examen
            FROM examenes_finales x
            INNER JOIN materias m ON m.id_materia = x.id_materia
            LEFT JOIN submaterias sm ON sm.id_submateria = x.id_submateria
            WHERE x.id_examen = ?
              AND x.id_estudiante = ?
        ");

        $st->execute([$idReg, $idEst]);

        $r = $st->fetch(PDO::FETCH_ASSOC);

        if (!$r) {
            return null;
        }

        $nombre = $r['nombre'];

        if (!empty($r['submateria'])) {
            $nombre .= ' - ' . $r['submateria'];
        }

        return 'Examen: ' . $nombre
            . ' (' . fecha_ar($r['fecha'])
            . ', nota ' . nota_fmt($r['nota']) . ')';
    }

    $st = db()->prepare("
        SELECT
            m.nombre,
            sm.nombre AS submateria,
            c.id_cursada,
            c.anio_cursada,
            c.fecha_inscripcion,
            c.tipo_inscripcion
        FROM cursadas c
        INNER JOIN materias m ON m.id_materia = c.id_materia
        LEFT JOIN submaterias sm ON sm.id_submateria = c.id_submateria
        WHERE c.id_cursada = ?
          AND c.id_estudiante = ?
    ");

    $st->execute([$idReg, $idEst]);

    $r = $st->fetch(PDO::FETCH_ASSOC);

    if (!$r) {
        return null;
    }

    $nombre = $r['nombre'];

    if (!empty($r['submateria'])) {
        $nombre .= ' - ' . $r['submateria'];
    }

    if ($tipo === 'inscripcion') {
        if (!$r['fecha_inscripcion']) {
            return null;
        }

        return 'Inscripción: ' . $nombre
            . ' (' . $r['tipo_inscripcion']
            . ' ' . $r['anio_cursada'] . ')';
    }

    return 'Cursada: ' . $nombre
        . ' (año ' . $r['anio_cursada'] . ')';
}

/*
 * Eliminar un registro académico.
 *
 * Una inscripción no se puede eliminar si ya tiene datos de cursada
 * o exámenes asociados. Esto evita dejar registros académicos aislados.
 */
function eliminar_registro(
    string $tipo,
    int $idReg,
    int $idEst,
    int $idUsuario
): bool {
    $desc = descripcion_registro($tipo, $idReg, $idEst);

    if ($desc === null) {
        return false;
    }

    en_transaccion(function (PDO $pdo) use (
        $tipo,
        $idReg,
        $idEst,
        $idUsuario,
        $desc
    ) {
        if ($tipo === 'examen') {
            $st = $pdo->prepare("
                DELETE FROM examenes_finales
                WHERE id_examen = ?
                  AND id_estudiante = ?
            ");

            $st->execute([$idReg, $idEst]);

        } elseif ($tipo === 'inscripcion') {
            // Comprobar que no existan datos académicos cargados.
            $st = $pdo->prepare("
                SELECT
                    caracter,
                    asistencia,
                    tp,
                    promedio,
                    nota_general,
                    nota_definitiva
                FROM cursadas
                WHERE id_cursada = ?
                  AND id_estudiante = ?
                  AND fecha_inscripcion IS NOT NULL
            ");

            $st->execute([$idReg, $idEst]);

            $r = $st->fetch(PDO::FETCH_ASSOC);

            if (!$r) {
                throw new RuntimeException(
                    'No se encontró la inscripción.'
                );
            }

            $tieneDatos = false;

            foreach ($r as $valor) {
                if ($valor !== null && $valor !== '') {
                    $tieneDatos = true;
                    break;
                }
            }

            // Comprobar si tiene exámenes asociados.
            $st = $pdo->prepare("
                SELECT COUNT(*)
                FROM examenes_finales
                WHERE id_cursada = ?
                  AND id_estudiante = ?
            ");

            $st->execute([$idReg, $idEst]);

            $tieneExamenes = (int)$st->fetchColumn() > 0;

            if ($tieneDatos || $tieneExamenes) {
                throw new RuntimeException(
                    'No se puede eliminar esta inscripción porque ya tiene datos académicos o exámenes asociados. Primero debe eliminar esos registros.'
                );
            }

            // Si todavía no tiene información académica, se elimina.
            $st = $pdo->prepare("
                DELETE FROM cursadas
                WHERE id_cursada = ?
                  AND id_estudiante = ?
                  AND fecha_inscripcion IS NOT NULL
            ");

            $st->execute([$idReg, $idEst]);
                } elseif ($tipo === 'inscripcion_curso') {
            $st = $pdo->prepare("
                SELECT curso, YEAR(fecha_inscripcion) AS anio
                FROM inscripciones_curso
                WHERE id_inscripcion = ?
                  AND id_estudiante = ?
            ");
            $st->execute([$idReg, $idEst]);
            $r = $st->fetch(PDO::FETCH_ASSOC);

            if (!$r) {
                throw new RuntimeException('No se encontró la inscripción al curso.');
            }

            $curso = (int)$r['curso'];
            $anio = (int)$r['anio'];

            // 1. No borrar si hay inscripciones posteriores que dependen de esta.
            $st = $pdo->prepare("
                SELECT COUNT(*)
                FROM inscripciones_curso
                WHERE id_estudiante = ?
                  AND id_inscripcion <> ?
                  AND YEAR(fecha_inscripcion) > ?
                  AND (curso = ? OR (curso = ? AND condicion = 'recursando'))
            ");
            $st->execute([$idEst, $idReg, $anio, $curso + 1, $curso]);

            if ((int)$st->fetchColumn() > 0) {
                throw new RuntimeException(
                    'No se puede eliminar esta inscripción porque hay inscripciones posteriores '
                    . 'que dependen de ella. Elimine primero las más recientes.'
                );
            }

            // 2. No borrar si dejaría sin respaldo a materias inscriptas ese año.
            $st = $pdo->prepare("
                SELECT MAX(curso)
                FROM inscripciones_curso
                WHERE id_estudiante = ?
                  AND id_inscripcion <> ?
                  AND YEAR(fecha_inscripcion) = ?
            ");
            $st->execute([$idEst, $idReg, $anio]);
            $restante = (int)$st->fetchColumn(); // 0 si no queda ninguna ese año

            $st = $pdo->prepare("
                SELECT COUNT(*)
                FROM cursadas c
                INNER JOIN materias m ON m.id_materia = c.id_materia
                WHERE c.id_estudiante = ?
                  AND c.anio_cursada = ?
                  AND m.anio > ?
            ");
            $st->execute([$idEst, $anio, $restante]);

            if ((int)$st->fetchColumn() > 0) {
                throw new RuntimeException(
                    'No se puede eliminar esta inscripción porque el alumno tiene materias '
                    . 'inscriptas en ' . $anio . ' que dependen de ella. Elimine primero esas materias.'
                );
            }

            $st = $pdo->prepare("
                DELETE FROM inscripciones_curso
                WHERE id_inscripcion = ?
                  AND id_estudiante = ?
            ");
            $st->execute([$idReg, $idEst]);
        } elseif ($tipo === 'cursada') {
            // No eliminar una cursada que tenga exámenes asociados.
            $st = $pdo->prepare("
                SELECT COUNT(*)
                FROM examenes_finales
                WHERE id_cursada = ?
                  AND id_estudiante = ?
            ");

            $st->execute([$idReg, $idEst]);

            if ((int)$st->fetchColumn() > 0) {
                throw new RuntimeException(
                    'No se puede eliminar la cursada porque tiene exámenes finales asociados.'
                );
            }

            // Comprobar si todavía conserva la inscripción.
            $st = $pdo->prepare("
                SELECT fecha_inscripcion
                FROM cursadas
                WHERE id_cursada = ?
                  AND id_estudiante = ?
            ");

            $st->execute([$idReg, $idEst]);

            $fecha = $st->fetchColumn();

            if ($fecha !== false && $fecha !== null) {
                // Mantener la inscripción y limpiar solamente los datos académicos.
                $st = $pdo->prepare("
                    UPDATE cursadas
                    SET caracter = NULL,
                        asistencia = NULL,
                        tp = NULL,
                        promedio = NULL,
                        nota_general = NULL,
                        nota_definitiva = NULL,
                        estado = 'cursando'
                    WHERE id_cursada = ?
                      AND id_estudiante = ?
                ");

                $st->execute([$idReg, $idEst]);

            } else {
                // Si no tiene inscripción, se elimina el registro completo.
                $st = $pdo->prepare("
                    DELETE FROM cursadas
                    WHERE id_cursada = ?
                      AND id_estudiante = ?
                ");

                $st->execute([$idReg, $idEst]);
            }
        }

        auditar(
            'Eliminación de registro académico',
            $desc,
            $idEst,
            $idUsuario
        );
    });

    return true;
}

/*
 * Reglas de la inscripción al curso:
 *  - No puede ser de un año lectivo anterior al de ingreso.
 *  - Año máximo = año de la inscripción - año de ingreso + 1 (tope 4).
 *    Ej.: ingresó en 2026 -> en 2026 solo 1.º. Ingresó en 2025 -> en 2026 hasta 2.º.
 *  - 2.º, 3.º y 4.º requieren estar inscripto al año anterior en un año lectivo previo.
 *  - No se repite el mismo curso en el mismo año lectivo.
 */
function err_secuencia_curso(int $idEst, int $curso, string $fecha, int $anioIngreso, string $condicion = ''): ?string
{
    $anio = (int)substr($fecha, 0, 4);

    if ($anio < $anioIngreso) {
        return 'La inscripción no puede ser de un año anterior al ingreso del alumno (' . $anioIngreso . ').';
    }

    $maximo = min(4, $anio - $anioIngreso + 1);

    if ($curso > $maximo) {
        return 'El alumno ingresó en ' . $anioIngreso . ': en ' . $anio
             . ' solo puede inscribirse hasta ' . $maximo . '.º año.';
    }

    // Mismo curso en el mismo año lectivo.
    $st = db()->prepare("
        SELECT COUNT(*)
        FROM inscripciones_curso
        WHERE id_estudiante = ?
          AND curso = ?
          AND YEAR(fecha_inscripcion) = ?
    ");
    $st->execute([$idEst, $curso, $anio]);

    if ((int)$st->fetchColumn() > 0) {
        return 'El alumno ya está inscripto a ' . $curso . '.º año en ' . $anio . '.';
    }
        // Cursando: solo la primera vez que se inscribe a ese curso.
    if ($condicion === 'cursando') {
        $st = db()->prepare("
            SELECT COUNT(*)
            FROM inscripciones_curso
            WHERE id_estudiante = ?
              AND curso = ?
              AND YEAR(fecha_inscripcion) < ?
        ");
        $st->execute([$idEst, $curso, $anio]);

        if ((int)$st->fetchColumn() > 0) {
            return 'El alumno ya se inscribió antes a ' . $curso . '.º año: corresponde «Recursando».';
        }

        // 1.º año por primera vez: solo en el año de ingreso.
        if ($curso === 1 && $anio !== $anioIngreso) {
            return 'El alumno ingresó en ' . $anioIngreso . ': 1.º año como «Cursando» solo corresponde en ese año. '
                 . 'Si lo está recursando, primero registre su inscripción a 1.º de ' . $anioIngreso
                 . ' y luego elija «Recursando».';
        }
    }
        // Recursar: solo si ya se había inscripto antes a ese mismo curso.
    if ($condicion === 'recursando') {
        $st = db()->prepare("
            SELECT COUNT(*)
            FROM inscripciones_curso
            WHERE id_estudiante = ?
              AND curso = ?
              AND YEAR(fecha_inscripcion) < ?
        ");
        $st->execute([$idEst, $curso, $anio]);

        if ((int)$st->fetchColumn() === 0) {
            return 'No puede recursar ' . $curso . '.º año: el alumno no tiene una inscripción '
                 . 'anterior a ese curso.';
        }
    }
    // 2.º, 3.º y 4.º: tiene que haberse inscripto al año anterior antes.
    
    if ($curso > 1) {
        $st = db()->prepare("
            SELECT COUNT(*)
            FROM inscripciones_curso
            WHERE id_estudiante = ?
              AND curso = ?
              AND YEAR(fecha_inscripcion) < ?
        ");
        $st->execute([$idEst, $curso - 1, $anio]);

        if ((int)$st->fetchColumn() === 0) {
            return 'No puede inscribirse a ' . $curso . '.º año: antes debe estar inscripto a '
                 . ($curso - 1) . '.º año en un año lectivo anterior a ' . $anio . '.';
        }
    }

    return null;
}

function validar_inscripcion_curso_secuencia(array $d, int $idEst, int $anioIngreso): array
{
    $err = validar_inscripcion_curso($d); // validaciones que ya tenías

    if (!$err) {
                if ($m = err_secuencia_curso($idEst, (int)$d['curso'], $d['fecha_inscripcion'], $anioIngreso, $d['condicion'])) {
            $err['curso'] = $m;
        }
    }

    return $err;
}