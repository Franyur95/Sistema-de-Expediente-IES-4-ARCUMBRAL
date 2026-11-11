<?php
/*
 * Funciones compartidas por los reportes imprimibles.
 * Solo realizan consultas de lectura: no modifican la base de datos.
 */

const REPORTE_MAX_ALUMNOS = 1000;
const REPORTE_MAX_SELECCION = 300;

function reporte_texto_get(string $clave, int $max = 50): string
{
    $valor = $_GET[$clave] ?? null;

    return is_string($valor) ? mb_substr(trim($valor), 0, $max) : '';
}

function reporte_entero_get(string $clave): int
{
    $valor = $_GET[$clave] ?? null;

    return is_string($valor) && ctype_digit($valor) && strlen($valor) < 10
        ? (int)$valor
        : 0;
}

/**
 * Normaliza los filtros del reporte y limita las carreras permitidas
 * para el usuario que está consultando.
 */
function reporte_filtros(array $usuario): array
{
    $filtros = [
        'q' => reporte_texto_get('q', 50),
        'estado' => reporte_texto_get('estado', 20),
        'id_carrera' => reporte_entero_get('carrera'),
        'anio' => reporte_entero_get('anio'),
    ];

    if ($filtros['estado'] !== '' && !in_array($filtros['estado'], ESTADOS, true)) {
        $filtros['estado'] = '';
    }

    $anioMaximo = (int)date('Y') + 1;
    if (
        $filtros['anio'] !== 0
        && ($filtros['anio'] < 1980 || $filtros['anio'] > $anioMaximo)
    ) {
        $filtros['anio'] = 0;
    }

    $permitidas = array_map(
        static fn(array $c): int => (int)$c['id_carrera'],
        carreras_permitidas($usuario)
    );

    if (($usuario['id_carrera'] ?? null) !== null) {
        // Los usuarios con carrera asignada solo pueden reportar su carrera.
        $filtros['id_carrera'] = (int)$usuario['id_carrera'];
    } elseif (
        $filtros['id_carrera'] !== 0
        && !in_array($filtros['id_carrera'], $permitidas, true)
    ) {
        $filtros['id_carrera'] = 0;
    }

    return $filtros;
}

function reporte_sql_filtros(array $filtros, array &$parametros): string
{
    $donde = [];

    if ($filtros['q'] !== '') {
        $like = '%' . str_replace(
            ['\\', '%', '_'],
            ['\\\\', '\\%', '\\_'],
            $filtros['q']
        ) . '%';

        $donde[] = '(e.apellido LIKE :q1 OR e.nombre LIKE :q2 OR e.dni LIKE :q3)';
        $parametros[':q1'] = $like;
        $parametros[':q2'] = $like;
        $parametros[':q3'] = $like;
    }

    if ($filtros['estado'] !== '') {
        $donde[] = 'e.estado = :estado';
        $parametros[':estado'] = $filtros['estado'];
    }

    if ($filtros['id_carrera'] > 0) {
        $donde[] = 'e.id_carrera = :carrera';
        $parametros[':carrera'] = $filtros['id_carrera'];
    }

    if ($filtros['anio'] > 0) {
        $donde[] = 'e.anio_ingreso = :anio';
        $parametros[':anio'] = $filtros['anio'];
    }

    return $donde ? ' WHERE ' . implode(' AND ', $donde) : '';
}

/**
 * Devuelve los alumnos que cumplen los filtros, con la cantidad de
 * documentos obligatorios que les faltan para el año actual.
 */
function reporte_alumnos(array $filtros, int $limite = REPORTE_MAX_ALUMNOS): array
{
    $parametros = [];
    $donde = reporte_sql_filtros($filtros, $parametros);

    $sql = "SELECT
                e.id_estudiante,
                e.dni,
                e.apellido,
                e.nombre,
                e.anio_ingreso,
                e.estado,
                c.nombre AS carrera,
                c.turno,
                (
                    SELECT COUNT(*)
                    FROM tipos_documento td
                    WHERE td.obligatorio = 1
                      AND td.activo = 1
                      AND NOT EXISTS (
                          SELECT 1
                          FROM documentacion_estudiante de
                          WHERE de.id_estudiante = e.id_estudiante
                            AND de.id_tipo = td.id_tipo
                            AND de.presentado = 1
                            AND (td.vence = 0 OR de.anio_lectivo = YEAR(CURDATE()))
                      )
                ) AS faltan
            FROM estudiantes e
            INNER JOIN carreras c ON c.id_carrera = e.id_carrera"
            . $donde
            . ' ORDER BY e.apellido, e.nombre, e.id_estudiante
                LIMIT :limite';

    $st = db()->prepare($sql);

    foreach ($parametros as $clave => $valor) {
        $st->bindValue(
            $clave,
            $valor,
            is_int($valor) ? PDO::PARAM_INT : PDO::PARAM_STR
        );
    }

    $st->bindValue(':limite', $limite, PDO::PARAM_INT);
    $st->execute();

    return $st->fetchAll();
}

/**
 * Texto breve con los filtros aplicados. Se debe escapar al imprimirlo.
 */
function reporte_resumen_filtros(array $filtros): string
{
    $partes = [];

    if ($filtros['q'] !== '') {
        $partes[] = 'Búsqueda: «' . $filtros['q'] . '»';
    }

    if ($filtros['estado'] !== '') {
        $partes[] = 'Estado: ' . ucfirst($filtros['estado']);
    }

    if ($filtros['anio'] > 0) {
        $partes[] = 'Año de ingreso: ' . $filtros['anio'];
    }

    if ($filtros['id_carrera'] > 0) {
        $st = db()->prepare('SELECT nombre, turno FROM carreras WHERE id_carrera = ?');
        $st->execute([$filtros['id_carrera']]);
        $carrera = $st->fetch();

        if ($carrera) {
            $partes[] = 'Carrera: ' . $carrera['nombre']
                . ' (turno ' . $carrera['turno'] . ')';
        }
    }

    return $partes ? implode(' · ', $partes) : 'Todos los alumnos';
}

function reporte_url_listado(array $filtros): string
{
    return 'imprimir_listado.php?' . http_build_query([
        'q' => $filtros['q'],
        'estado' => $filtros['estado'],
        'carrera' => $filtros['id_carrera'] ?: '',
        'anio' => $filtros['anio'] ?: '',
    ]);
}

function reporte_url_filtros(string $pagina, array $filtros): string
{
    return $pagina . '?' . http_build_query([
        'q' => $filtros['q'],
        'estado' => $filtros['estado'],
        'carrera' => $filtros['id_carrera'] ?: '',
        'anio' => $filtros['anio'] ?: '',
    ]);
}

/**
 * Lee los identificadores enviados por la pantalla de selección.
 * Acepta ids[]=1&ids[]=2, ids=1,2 o id=1.
 */
function reporte_ids_desde_get(): array
{
    $ids = [];
    $recibidos = $_GET['ids'] ?? null;

    if (is_array($recibidos)) {
        foreach ($recibidos as $valor) {
            if (is_string($valor) && ctype_digit($valor) && strlen($valor) < 10) {
                $ids[] = (int)$valor;
            }
        }
    } elseif (is_string($recibidos)) {
        foreach (explode(',', $recibidos) as $valor) {
            $valor = trim($valor);

            if ($valor !== '' && ctype_digit($valor) && strlen($valor) < 10) {
                $ids[] = (int)$valor;
            }
        }
    }

    $id = reporte_entero_get('id');
    if ($id > 0) {
        $ids[] = $id;
    }

    $ids = array_values(array_unique($ids));

    return array_slice($ids, 0, REPORTE_MAX_SELECCION);
}
