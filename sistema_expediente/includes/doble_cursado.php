<?php
/*
 * Evita el doble cursado: no se puede inscribir a una materia (o submateria)
 * que el alumno ya tiene aprobada por promoción, examen final, equivalencia o asimilación.
 */

/** true si el alumno ya aprobó ese espacio curricular. */
function espacio_ya_aprobado(int $idEst, int $idMateria, ?int $idSubmateria = null): bool
{
    $notaMinima = defined('NOTA_APROBACION') ? NOTA_APROBACION : 4;

    // Materia completa aprobada (final, promoción, equivalencia o asimilación resuelta).
    $st = db()->prepare('SELECT 1 FROM v_materia_aprobada WHERE id_estudiante = ? AND id_materia = ? LIMIT 1');
    $st->execute([$idEst, $idMateria]);
    if ($st->fetchColumn()) {
        return true;
    }

    // Materias que se cursan por submateria (deportes): puede estar aprobada solo una de ellas.
    if ($idSubmateria !== null) {
        $st = db()->prepare(
            "SELECT 1 FROM examenes_finales
             WHERE id_estudiante = ? AND id_materia = ? AND id_submateria = ? AND estado = 'presente' AND nota >= ?
             LIMIT 1"
        );
        $st->execute([$idEst, $idMateria, $idSubmateria, $notaMinima]);
        if ($st->fetchColumn()) {
            return true;
        }

        $st = db()->prepare(
            "SELECT 1 FROM cursadas
             WHERE id_estudiante = ? AND id_materia = ? AND id_submateria = ? AND caracter = 'promocional'
             LIMIT 1"
        );
        $st->execute([$idEst, $idMateria, $idSubmateria]);
        if ($st->fetchColumn()) {
            return true;
        }
    }

    return false;
}