<?php
/*
 * Semáforo de documentación (solo lectura).
 * Usa la vista v_semaforo_documentacion; si la vista falla, el sistema sigue funcionando sin semáforo.
 */

const SEMAFORO_ETIQUETAS = ['rojo' => 'Rojo', 'amarillo' => 'Amarillo', 'verde' => 'Verde'];

/** Devuelve la fila del semáforo del alumno o null (alumno no activo, o vista no disponible). */
function semaforo_estudiante(int $idEstudiante): ?array
{
    try {
        $st = db()->prepare(
            'SELECT obligatorios, presentados, faltan, vencidos, por_vencer, semaforo
             FROM v_semaforo_documentacion WHERE id_estudiante = ?'
        );
        $st->execute([$idEstudiante]);
        $fila = $st->fetch(PDO::FETCH_ASSOC);
        return $fila ?: null;
    } catch (Throwable $ex) {
        error_log('No se pudo leer v_semaforo_documentacion: ' . $ex->getMessage());
        return null;
    }
}

/** Insignia con texto y color (no depende solo del color). */
function semaforo_insignia(string $color): string
{
    if (!isset(SEMAFORO_ETIQUETAS[$color])) {
        return '';
    }
    return '<span class="semaforo semaforo-' . e($color) . '">'
         . '<span class="semaforo-punto" aria-hidden="true"></span>'
         . e(SEMAFORO_ETIQUETAS[$color]) . '</span>';
}

function semaforo_detalle(array $f): string
{
    return 'Faltan ' . (int)$f['faltan'] . ' · Vencidos ' . (int)$f['vencidos'] . ' · Por vencer ' . (int)$f['por_vencer'];
}

function pagina_desde_get(): int
{
    $p = $_GET['pagina'] ?? '';
    return (is_string($p) && ctype_digit($p) && (int)$p >= 1) ? min((int)$p, 100000) : 1;
}
