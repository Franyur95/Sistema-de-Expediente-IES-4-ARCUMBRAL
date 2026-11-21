<?php
/*
 * Trámites académicos: pases, asimilaciones, equivalencias y notas de aprobación.
 * Usa las tablas `tramites` y `tramite_materias` y los disparadores de la base
 * (plazo de 60 días, resolución obligatoria, materias reconocidas).
 *
 * Requiere que la página ya haya incluido auth.php, estudiantes.php y academico.php.
 */

const TRAMITE_TIPOS = [
    'pase'            => 'Pase',
    'asimilacion'     => 'Asimilación',
    'equivalencia'    => 'Equivalencia',
    'nota_aprobacion' => 'Nota de aprobación',
];

const TRAMITE_ESTADOS = [
    'en_curso'    => 'En curso',
    'en_revision' => 'En revisión',
    'observado'   => 'Observado',
    'resuelto'    => 'Resuelto',
    'rechazado'   => 'Rechazado',
];

/** Estados en los que el trámite todavía se puede modificar. */
const TRAMITE_ABIERTOS = ['en_curso', 'en_revision', 'observado'];

/** Tipos que reconocen espacios curriculares (alimentan v_materia_aprobada). */
const TRAMITE_CON_MATERIAS = ['asimilacion', 'equivalencia'];

/* ---------- Utilidades ---------- */

function tramite_tipo_etq(string $tipo): string
{
    return TRAMITE_TIPOS[$tipo] ?? ucfirst(str_replace('_', ' ', $tipo));
}

function tramite_estado_etq(string $estado): string
{
    return TRAMITE_ESTADOS[$estado] ?? $estado;
}

function tramite_esta_abierto(array $t): bool
{
    return in_array($t['estado'], TRAMITE_ABIERTOS, true);
}

/** Texto del plazo (solo para trámites abiertos con fecha límite). */
function tramite_plazo_html(array $t): string
{
    if (!tramite_esta_abierto($t)) {
        return '—';
    }
    if (empty($t['fecha_limite'])) {
        return 'Sin plazo';
    }
    $dias = (int)((new DateTimeImmutable('today'))->diff(new DateTimeImmutable($t['fecha_limite']))->format('%r%a'));
    if ($dias < 0) {
        return '<span class="pendiente">Vencido hace ' . abs($dias) . ' día(s)</span>';
    }
    if ($dias <= 7) {
        return '<strong>Vence en ' . $dias . ' día(s)</strong>';
    }
    return 'En plazo (' . $dias . ' días)';
}

/** Si el error viene de un disparador de la base (SQLSTATE 45000), devuelve su mensaje. */
function tramite_mensaje_disparador(PDOException $ex): ?string
{
    if (($ex->errorInfo[0] ?? '') === '45000' && !empty($ex->errorInfo[2])) {
        return (string)$ex->errorInfo[2];
    }
    return null;
}

/** Todas las carreras (también las inactivas), para elegir el destino de un pase. */
function tramite_carreras(): array
{
    return db()->query('SELECT id_carrera, nombre, turno FROM carreras ORDER BY nombre, turno')->fetchAll(PDO::FETCH_ASSOC);
}

/* ---------- Lectura ---------- */

function listar_tramites_estudiante(int $idEst): array
{
    $st = db()->prepare(
        "SELECT t.*,
                u.nombre AS iniciado_por,
                CONCAT(co.nombre, ' (', co.turno, ')') AS carrera_origen,
                CONCAT(cd.nombre, ' (', cd.turno, ')') AS carrera_destino
         FROM tramites t
         LEFT JOIN usuarios u  ON u.id_usuario = t.id_usuario_inicia
         LEFT JOIN carreras co ON co.id_carrera = t.id_carrera_origen
         LEFT JOIN carreras cd ON cd.id_carrera = t.id_carrera_destino
         WHERE t.id_estudiante = ?
         ORDER BY (t.estado IN ('resuelto','rechazado')), t.fecha_solicitud DESC, t.id_tramite DESC"
    );
    $st->execute([$idEst]);
    $filas = $st->fetchAll(PDO::FETCH_ASSOC);

    if ($filas) {
        $ids = array_map(static fn($f) => (int)$f['id_tramite'], $filas);
        $in = implode(',', array_fill(0, count($ids), '?'));
        $sm = db()->prepare(
            "SELECT tm.id_tramite, m.id_materia, m.nombre, m.anio
             FROM tramite_materias tm
             JOIN materias m ON m.id_materia = tm.id_materia
             WHERE tm.id_tramite IN ($in)
             ORDER BY m.anio, m.orden"
        );
        $sm->execute($ids);
        $porTramite = [];
        foreach ($sm->fetchAll(PDO::FETCH_ASSOC) as $m) {
            $porTramite[(int)$m['id_tramite']][] = $m;
        }
        foreach ($filas as &$f) {
            $f['materias'] = $porTramite[(int)$f['id_tramite']] ?? [];
        }
        unset($f);
    }
    return $filas;
}

function obtener_tramite(int $idTramite, int $idEst): ?array
{
    $st = db()->prepare('SELECT * FROM tramites WHERE id_tramite = ? AND id_estudiante = ?');
    $st->execute([$idTramite, $idEst]);
    $f = $st->fetch(PDO::FETCH_ASSOC);
    return $f ?: null;
}

/* ---------- Alta ---------- */

function validar_tramite_nuevo(array $p, array $alumno): array
{
    $d = [
        'tipo'               => campo($p, 'tipo'),
        'fecha_solicitud'    => campo($p, 'fecha_solicitud'),
        'fecha_limite'       => campo($p, 'fecha_limite'),
        'id_carrera_destino' => campo($p, 'id_carrera_destino'),
        'detalle'            => str_replace("\r\n", "\n", campo($p, 'detalle')),
    ];
    $e = [];

    if (!isset(TRAMITE_TIPOS[$d['tipo']])) {
        $e['tipo'] = 'Seleccione el tipo de trámite.';
    }

    if ($m = err_fecha_pasada($d['fecha_solicitud'], 'La fecha de solicitud')) {
        $e['fecha_solicitud'] = $m;
    }

    if ($d['fecha_limite'] !== '') {
        $fl = fecha_valida($d['fecha_limite']);
        $fs = fecha_valida($d['fecha_solicitud']);
        if (!$fl) {
            $e['fecha_limite'] = 'La fecha límite no es válida.';
        } elseif ($fs && $fl < $fs) {
            $e['fecha_limite'] = 'La fecha límite no puede ser anterior a la solicitud.';
        }
    }

    if (mb_strlen($d['detalle']) > 2000) {
        $e['detalle'] = 'El detalle no puede superar 2000 caracteres.';
    }

    if ($d['tipo'] === 'pase') {
        $origen = (int)$alumno['id_carrera'];
        if ($d['id_carrera_destino'] === '' || !ctype_digit($d['id_carrera_destino'])) {
            $e['id_carrera_destino'] = 'Seleccione la carrera de destino del pase.';
        } elseif ((int)$d['id_carrera_destino'] === $origen) {
            $e['id_carrera_destino'] = 'La carrera de destino debe ser distinta de la actual.';
        } else {
            $st = db()->prepare('SELECT 1 FROM carreras WHERE id_carrera = ?');
            $st->execute([(int)$d['id_carrera_destino']]);
            if (!$st->fetchColumn()) {
                $e['id_carrera_destino'] = 'La carrera de destino no existe.';
            }
        }

        // Un solo pase abierto por alumno.
        if (!$e) {
            $st = db()->prepare("SELECT 1 FROM tramites WHERE id_estudiante = ? AND tipo = 'pase' AND estado IN ('en_curso','en_revision','observado')");
            $st->execute([(int)$alumno['id_estudiante']]);
            if ($st->fetchColumn()) {
                $e['tipo'] = 'Este alumno ya tiene un pase abierto.';
            }
        }
    }

    return [$e, $d];
}

function crear_tramite(int $idEst, array $alumno, array $d, int $idUsuario): int
{
    return en_transaccion(function (PDO $pdo) use ($idEst, $alumno, $d, $idUsuario) {
        $esPase = $d['tipo'] === 'pase';
        $st = $pdo->prepare(
            'INSERT INTO tramites
                (id_estudiante, tipo, fecha_solicitud, fecha_limite, estado, detalle,
                 id_usuario_inicia, id_carrera_origen, id_carrera_destino)
             VALUES (?, ?, ?, ?, \'en_curso\', ?, ?, ?, ?)'
        );
        $st->execute([
            $idEst,
            $d['tipo'],
            $d['fecha_solicitud'],
            $d['fecha_limite'] !== '' ? $d['fecha_limite'] : null,   // vacío: el disparador pone 60 días
            $d['detalle'] !== '' ? $d['detalle'] : null,
            $idUsuario,
            $esPase ? (int)$alumno['id_carrera'] : null,
            $esPase ? (int)$d['id_carrera_destino'] : null,
        ]);
        $id = (int)$pdo->lastInsertId();
        auditar('Alta de trámite', tramite_tipo_etq($d['tipo']) . ' #' . $id, $idEst, $idUsuario);
        return $id;
    });
}

/* ---------- Cambios sobre un trámite abierto ---------- */

function cambiar_estado_tramite(int $idEst, array $tramite, string $nuevo, string $motivo, array $usuario): ?string
{
    if (!tramite_esta_abierto($tramite)) {
        return 'El trámite ya está cerrado y no se puede modificar.';
    }
    $permitidos = ['en_curso', 'en_revision', 'observado', 'rechazado'];
    if (!in_array($nuevo, $permitidos, true)) {
        return 'Estado no válido. Para resolver use el formulario «Resolver trámite».';
    }
    if ($nuevo === 'rechazado' && $motivo === '') {
        return 'Indique el motivo del rechazo.';
    }
    if (mb_strlen($motivo) > 300) {
        return 'El motivo no puede superar 300 caracteres.';
    }
    if ($nuevo === $tramite['estado'] && $motivo === '') {
        return 'El trámite ya está en ese estado.';
    }

    en_transaccion(function (PDO $pdo) use ($idEst, $tramite, $nuevo, $motivo, $usuario) {
        $nota = '[' . date('d/m/Y') . ' ' . $usuario['nombre'] . '] ' . tramite_estado_etq($nuevo)
              . ($motivo !== '' ? ': ' . $motivo : '');
        $detalle = trim((string)($tramite['detalle'] ?? '') . "\n" . $nota);

        $st = $pdo->prepare('UPDATE tramites SET estado = ?, detalle = ? WHERE id_tramite = ? AND id_estudiante = ?');
        $st->execute([$nuevo, $detalle, (int)$tramite['id_tramite'], $idEst]);
        auditar('Modificación de trámite', '#' . $tramite['id_tramite'] . ' → ' . tramite_estado_etq($nuevo), $idEst, $usuario['id_usuario']);
    });
    return null;
}

/** Reemplaza las materias reconocidas de una equivalencia o asimilación abierta. */
function guardar_materias_tramite(int $idEst, array $tramite, array $idsPedidos, array $idsPermitidos, int $idUsuario): ?string
{
    if (!tramite_esta_abierto($tramite)) {
        return 'El trámite ya está cerrado y no se puede modificar.';
    }
    if (!in_array($tramite['tipo'], TRAMITE_CON_MATERIAS, true)) {
        return 'Este tipo de trámite no reconoce espacios curriculares.';
    }

    $ids = [];
    foreach ($idsPedidos as $v) {
        if (is_string($v) && ctype_digit($v)) {
            $ids[(int)$v] = true;
        }
    }
    $ids = array_keys($ids);
    foreach ($ids as $i) {
        if (!in_array($i, $idsPermitidos, true)) {
            return 'Hay un espacio curricular que no pertenece a la carrera del alumno.';
        }
    }

    en_transaccion(function (PDO $pdo) use ($idEst, $tramite, $ids, $idUsuario) {
        $pdo->prepare('DELETE FROM tramite_materias WHERE id_tramite = ?')->execute([(int)$tramite['id_tramite']]);
        $ins = $pdo->prepare('INSERT INTO tramite_materias (id_tramite, id_materia) VALUES (?, ?)');
        foreach ($ids as $i) {
            $ins->execute([(int)$tramite['id_tramite'], $i]);
        }
        auditar('Carga de materias reconocidas', '#' . $tramite['id_tramite'] . ': ' . count($ids) . ' espacio(s)', $idEst, $idUsuario);
    });
    return null;
}

/** Resuelve el trámite con el número y la fecha de la resolución de Secretaría Académica. */
function resolver_tramite(int $idEst, array $tramite, string $nro, string $fecha, int $idUsuario): ?string
{
    if (!tramite_esta_abierto($tramite)) {
        return 'El trámite ya está cerrado y no se puede modificar.';
    }
    if ($nro === '') {
        return 'El número de resolución es obligatorio.';
    }
    if (mb_strlen($nro) > 50) {
        return 'El número de resolución no puede superar 50 caracteres.';
    }
    if ($m = err_fecha_pasada($fecha, 'La fecha de la resolución')) {
        return $m;
    }
    $f = fecha_valida($fecha);
    $fs = fecha_valida((string)$tramite['fecha_solicitud']);
    if ($f && $fs && $f < $fs) {
        return 'La fecha de la resolución no puede ser anterior a la solicitud.';
    }

    if (in_array($tramite['tipo'], TRAMITE_CON_MATERIAS, true)) {
        $st = db()->prepare('SELECT COUNT(*) FROM tramite_materias WHERE id_tramite = ?');
        $st->execute([(int)$tramite['id_tramite']]);
        if ((int)$st->fetchColumn() === 0) {
            return 'Antes de resolver, cargue al menos un espacio curricular reconocido.';
        }
    }

    en_transaccion(function (PDO $pdo) use ($idEst, $tramite, $nro, $fecha, $idUsuario) {
        $st = $pdo->prepare(
            "UPDATE tramites SET estado = 'resuelto', nro_resolucion = ?, fecha_resolucion = ?
             WHERE id_tramite = ? AND id_estudiante = ?"
        );
        $st->execute([$nro, $fecha, (int)$tramite['id_tramite'], $idEst]);
        auditar('Resolución de trámite', '#' . $tramite['id_tramite'] . ' · res. ' . $nro, $idEst, $idUsuario);
    });
    return null;
}
