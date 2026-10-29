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
    'inscripcion' => ['cursadas', 'id_cursada', 'Inscripción'],
    'cursada'     => ['cursadas', 'id_cursada', 'Cursada'],
    'examen'      => ['examenes_finales', 'id_examen', 'Examen'],
];

/* ---------- Lectura ---------- */

function materias_de_carrera(int $idCarrera): array
{
    $st = db()->prepare('SELECT m.id_materia, m.anio, m.nombre FROM materias m JOIN planes p ON p.id_plan=m.id_plan WHERE p.id_carrera=? AND p.activo=1 AND m.activa=1 ORDER BY m.anio,m.orden,m.id_materia');
    $st->execute([$idCarrera]);
    return $st->fetchAll();
}

function nombre_materia(int $idMateria): string
{
    $st = db()->prepare('SELECT nombre FROM materias WHERE id_materia = ?');
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
    $st=db()->prepare("SELECT c.id_cursada AS id_inscripcion,c.fecha_inscripcion AS fecha,c.anio_cursada,CASE c.tipo_inscripcion WHEN 'recursar' THEN 'Recursar' WHEN 'libre' THEN 'Libre' ELSE 'Cursar' END AS condicion,c.observaciones,m.nombre AS materia FROM cursadas c JOIN materias m ON m.id_materia=c.id_materia WHERE c.id_estudiante=? AND c.fecha_inscripcion IS NOT NULL ORDER BY c.fecha_inscripcion,c.id_cursada");
    $st->execute([$idEst]); return $st->fetchAll();
}
function listar_cursadas(int $idEst): array
{
    $st=db()->prepare("SELECT c.id_cursada,c.anio_cursada,c.asistencia,c.tp,CASE c.caracter WHEN 'regular' THEN 'Regular' WHEN 'libre' THEN 'Libre' WHEN 'promocional' THEN 'Promocion' ELSE '' END AS caracter,c.promedio,m.nombre AS materia,m.anio FROM cursadas c JOIN materias m ON m.id_materia=c.id_materia WHERE c.id_estudiante=? AND (c.caracter IS NOT NULL OR c.asistencia IS NOT NULL OR c.tp IS NOT NULL OR c.promedio IS NOT NULL) ORDER BY m.anio,m.orden,c.anio_cursada");
    $st->execute([$idEst]); return $st->fetchAll();
}
function listar_examenes(int $idEst): array
{
    $st=db()->prepare("SELECT x.id_examen,CASE x.condicion_alumno WHEN 'libre' THEN 'Libre' WHEN 'promocion' THEN 'Promoción' ELSE 'Regular' END AS tipo,x.fecha,x.nota,x.libro,x.folio,x.observacion,m.nombre AS materia,m.anio FROM examenes_finales x JOIN materias m ON m.id_materia=x.id_materia WHERE x.id_estudiante=? ORDER BY m.anio,m.orden,x.fecha,x.id_examen");
    $st->execute([$idEst]); return $st->fetchAll();
}

/** Reúne materias, cursadas y exámenes del alumno para armar la grilla por año. */
function situacion_academica(int $idEst, int $idCarrera): array
{
    $cursadas=[];$st=db()->prepare("SELECT c.*,CASE c.caracter WHEN 'regular' THEN 'Regular' WHEN 'libre' THEN 'Libre' WHEN 'promocional' THEN 'Promocion' ELSE '' END AS caracter FROM cursadas c WHERE c.id_estudiante=? AND (c.caracter IS NOT NULL OR c.asistencia IS NOT NULL OR c.tp IS NOT NULL OR c.promedio IS NOT NULL) ORDER BY c.id_materia,c.anio_cursada");$st->execute([$idEst]);
    foreach($st->fetchAll() as $r)$cursadas[(int)$r['id_materia']][]=$r;
    $examenes=[];$st=db()->prepare("SELECT x.*,CASE x.condicion_alumno WHEN 'libre' THEN 'Libre' WHEN 'promocion' THEN 'Promoción' ELSE 'Regular' END AS tipo FROM examenes_finales x WHERE x.id_estudiante=? AND x.estado='presente' ORDER BY x.id_materia,x.fecha,x.id_examen");$st->execute([$idEst]);
    foreach($st->fetchAll() as $r)$examenes[(int)$r['id_materia']][]=$r;
    return ['materias'=>materias_de_carrera($idCarrera),'cursadas'=>$cursadas,'examenes'=>$examenes];
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
        echo '<p>La carrera no tiene espacios curriculares activos asociados a un plan vigente en la base de datos.</p>';
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
        } elseif (mb_strlen($d[$k]) > 20) {
            $e[$k] = $etq . ' no puede superar 20 caracteres.';
        }
    }
    if (mb_strlen($d['observacion']) > 200) { $e['observacion'] = 'La observación no puede superar 200 caracteres.'; }

    if (!$e) {
        $st = db()->prepare('SELECT 1 FROM examenes_finales WHERE id_estudiante = ? AND id_materia = ? AND fecha = ?');
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

function guardar_inscripcion(int $idEst,array $d,int $idUsuario): void
{
    en_transaccion(function(PDO $pdo) use($idEst,$d,$idUsuario){
        $tipo=$d['condicion']==='Recursar'?'recursar':'cursar';
        $st=$pdo->prepare("INSERT INTO cursadas (id_estudiante,id_materia,anio_cursada,fecha_inscripcion,tipo_inscripcion,estado,observaciones) VALUES (?,?,?,?,?,'cursando',?) ON DUPLICATE KEY UPDATE fecha_inscripcion=VALUES(fecha_inscripcion),tipo_inscripcion=VALUES(tipo_inscripcion),observaciones=VALUES(observaciones)");
        $st->execute([$idEst,(int)$d['id_materia'],(int)$d['anio_cursada'],$d['fecha'],$tipo,$d['observaciones']!==''?$d['observaciones']:null]);
        auditar('Alta de inscripción',nombre_materia((int)$d['id_materia']).' ('.$d['condicion'].' '.$d['anio_cursada'].')',$idEst,$idUsuario);
    });
}
function guardar_cursada(int $idEst,array $d,int $idUsuario): void
{
    en_transaccion(function(PDO $pdo) use($idEst,$d,$idUsuario){
        $nulo=static fn($v)=>$v===''?null:$v;$caracter=['Regular'=>'regular','Libre'=>'libre','Promocion'=>'promocional'][$d['caracter']]??'regular';
        $st=$pdo->prepare("INSERT INTO cursadas (id_estudiante,id_materia,anio_cursada,asistencia,tp,caracter,promedio,estado) VALUES (?,?,?,?,?,?,?,'cursando') ON DUPLICATE KEY UPDATE asistencia=VALUES(asistencia),tp=VALUES(tp),caracter=VALUES(caracter),promedio=VALUES(promedio),estado=CASE WHEN VALUES(caracter)='promocional' THEN 'promocional' WHEN VALUES(caracter)='libre' THEN 'libre' ELSE 'regular' END");
        $st->execute([$idEst,(int)$d['id_materia'],(int)$d['anio_cursada'],$nulo($d['asistencia']),$nulo($d['tp']),$caracter,$nulo(str_replace(',','.',$d['promedio']))]);
        auditar('Carga de cursada',nombre_materia((int)$d['id_materia']).' ('.$d['anio_cursada'].')',$idEst,$idUsuario);
    });
}
function guardar_examen(int $idEst,array $d,int $idUsuario): void
{
    en_transaccion(function(PDO $pdo) use($idEst,$d,$idUsuario){
        $cond=$d['tipo']==='Libre'?'libre':'regular';
        $st=$pdo->prepare('SELECT id_cursada FROM cursadas WHERE id_estudiante=? AND id_materia=? ORDER BY anio_cursada DESC LIMIT 1');$st->execute([$idEst,(int)$d['id_materia']]);$idCursada=$st->fetchColumn();
        $st=$pdo->prepare('SELECT COALESCE(MAX(numero_intento),0)+1 FROM examenes_finales WHERE id_estudiante=? AND id_materia=?');$st->execute([$idEst,(int)$d['id_materia']]);$intento=min(10,(int)$st->fetchColumn());
        $st=$pdo->prepare("INSERT INTO examenes_finales (id_estudiante,id_materia,id_cursada,numero_intento,condicion_alumno,fecha,nota,estado,libro,folio,observacion) VALUES (?,?,?,?,?,?,?,'presente',?,?,?)");
        $st->execute([$idEst,(int)$d['id_materia'],$idCursada?:null,$intento,$cond,$d['fecha'],$d['nota'],$d['libro']!==''?$d['libro']:null,$d['folio']!==''?$d['folio']:null,$d['observacion']!==''?$d['observacion']:null]);
        auditar('Alta de examen',nombre_materia((int)$d['id_materia']).' ('.$d['fecha'].')',$idEst,$idUsuario);
    });
}
function descripcion_registro(string $tipo,int $idReg,int $idEst): ?string
{
    if(!isset(TABLAS_REGISTRO[$tipo]))return null;
    if($tipo==='examen'){$st=db()->prepare("SELECT m.nombre,x.fecha,x.nota,x.id_examen FROM examenes_finales x JOIN materias m ON m.id_materia=x.id_materia WHERE x.id_examen=? AND x.id_estudiante=?");$st->execute([$idReg,$idEst]);$r=$st->fetch();if(!$r)return null;return 'Examen: '.$r['nombre'].' ('.fecha_ar($r['fecha']).', nota '.nota_fmt($r['nota']).')';}
    $st=db()->prepare('SELECT m.nombre,c.id_cursada,c.anio_cursada,c.fecha_inscripcion,c.tipo_inscripcion FROM cursadas c JOIN materias m ON m.id_materia=c.id_materia WHERE c.id_cursada=? AND c.id_estudiante=?');$st->execute([$idReg,$idEst]);$r=$st->fetch();if(!$r)return null;
    if($tipo==='inscripcion'){if(!$r['fecha_inscripcion'])return null;return 'Inscripción: '.$r['nombre'].' ('.$r['tipo_inscripcion'].' '.$r['anio_cursada'].')';}
    return 'Cursada: '.$r['nombre'].' (año '.$r['anio_cursada'].')';
}
function eliminar_registro(string $tipo,int $idReg,int $idEst,int $idUsuario): bool
{
    $desc=descripcion_registro($tipo,$idReg,$idEst);if($desc===null)return false;
    en_transaccion(function(PDO $pdo)use($tipo,$idReg,$idEst,$idUsuario,$desc){
        if($tipo==='examen'){$st=$pdo->prepare('DELETE FROM examenes_finales WHERE id_examen=? AND id_estudiante=?');$st->execute([$idReg,$idEst]);}
        elseif($tipo==='inscripcion'){$st=$pdo->prepare('UPDATE cursadas SET fecha_inscripcion=NULL WHERE id_cursada=? AND id_estudiante=?');$st->execute([$idReg,$idEst]);$chk=$pdo->prepare('SELECT caracter,asistencia,tp,promedio,nota_general,nota_definitiva FROM cursadas WHERE id_cursada=? AND id_estudiante=?');$chk->execute([$idReg,$idEst]);$r=$chk->fetch();if($r&&array_filter($r,static fn($v)=>$v!==null&&$v!=='' )===[]){$del=$pdo->prepare('DELETE FROM cursadas WHERE id_cursada=? AND id_estudiante=?');$del->execute([$idReg,$idEst]);}}
        else{$st=$pdo->prepare('DELETE FROM cursadas WHERE id_cursada=? AND id_estudiante=?');$st->execute([$idReg,$idEst]);}
        auditar('Eliminación de registro académico',$desc,$idEst,$idUsuario);
    });return true;
}
