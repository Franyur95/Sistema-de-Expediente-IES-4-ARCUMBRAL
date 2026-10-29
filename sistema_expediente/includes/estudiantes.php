<?php
/* Acceso a datos y validaciones compatibles con ies4_expedientes_v2. */
const ESTADOS = ['activo', 'libre', 'egresado', 'abandono', 'pase', 'fallecido'];

function campo(array $origen, string $clave): string {
    $v=$origen[$clave]??''; return is_string($v)?trim($v):'';
}
function limpiar_espacios(string $v): string { return trim((string)preg_replace('/\s+/u',' ',$v)); }
function datos_desde_post(array $p): array {
    return [
        'dni'=>(string)preg_replace('/[\s.]/','',campo($p,'dni')),
        'apellido'=>limpiar_espacios(campo($p,'apellido')),
        'nombre'=>limpiar_espacios(campo($p,'nombre')),
        'fecha_nacimiento'=>campo($p,'fecha_nacimiento'),
        'lugar_nacimiento'=>limpiar_espacios(campo($p,'lugar_nacimiento')),
        'domicilio'=>limpiar_espacios(campo($p,'domicilio')),
        'telefono'=>limpiar_espacios(campo($p,'telefono')),
        'titulo_ingreso'=>limpiar_espacios(campo($p,'titulo_ingreso')),
        'establecimiento'=>limpiar_espacios(campo($p,'establecimiento')),
        'anio_ingreso'=>campo($p,'anio_ingreso'),
        'observaciones'=>str_replace("\r\n","\n",campo($p,'observaciones')),
        'estado'=>campo($p,'estado'),
        'id_carrera'=>campo($p,'id_carrera'),
    ];
}
function datos_vacios(array $usuario): array {
    return ['dni'=>'','apellido'=>'','nombre'=>'','fecha_nacimiento'=>'','lugar_nacimiento'=>'','domicilio'=>'','telefono'=>'','titulo_ingreso'=>'','establecimiento'=>'','anio_ingreso'=>date('Y'),'observaciones'=>'','estado'=>'activo','id_carrera'=>($usuario['id_carrera']??null)===null?'':(string)$usuario['id_carrera']];
}
function datos_desde_fila(array $fila): array {
    $d=datos_vacios(['id_carrera'=>null]); foreach($d as $k=>$v) $d[$k]=(string)($fila[$k]??''); return $d;
}
function cargar_tipos(): array {
    return db()->query('SELECT id_tipo,nombre,obligatorio,vence,dias_alerta FROM tipos_documento WHERE activo=1 ORDER BY orden,id_tipo')->fetchAll();
}
function docs_vacios(array $tipos): array { $r=[]; foreach($tipos as $t) $r[(int)$t['id_tipo']]=['presentado'=>false,'fecha'=>'','obs'=>'']; return $r; }
function docs_desde_db(array $tipos,int $idEstudiante): array {
    $r=docs_vacios($tipos); $st=db()->prepare('SELECT d.id_tipo,d.presentado,d.fecha_presentacion,d.observaciones FROM documentacion_estudiante d WHERE d.id_estudiante=? ORDER BY d.anio_lectivo DESC,d.id_documento DESC'); $st->execute([$idEstudiante]);
    foreach($st->fetchAll() as $x){$i=(int)$x['id_tipo']; if(isset($r[$i]) && !isset($seen[$i])){$r[$i]=['presentado'=>(bool)$x['presentado'],'fecha'=>(string)($x['fecha_presentacion']??''),'obs'=>(string)($x['observaciones']??'')];$seen[$i]=true;}} return $r;
}
function docs_desde_post(array $p,array $tipos): array {
    $pres=is_array($p['doc_presentado']??null)?$p['doc_presentado']:[];$fechas=is_array($p['doc_fecha']??null)?$p['doc_fecha']:[];$obs=is_array($p['doc_obs']??null)?$p['doc_obs']:[];$r=[];
    foreach($tipos as $t){$i=(int)$t['id_tipo'];$r[$i]=['presentado'=>isset($pres[$i]),'fecha'=>isset($fechas[$i])&&is_string($fechas[$i])?trim($fechas[$i]):'','obs'=>isset($obs[$i])&&is_string($obs[$i])?limpiar_espacios($obs[$i]):''];} return $r;
}
function validar_docs(array $docs,array $tipos): array {
    $err=[];$n=[];foreach($tipos as $t)$n[(int)$t['id_tipo']]=$t['nombre'];$hoy=new DateTimeImmutable('today');
    foreach($docs as $id=>$d){$et=$n[$id]??'Documento';if($d['fecha']!==''){$f=fecha_valida($d['fecha']);if(!$f)$err['doc_'.$id]=$et.': la fecha de presentación no es válida.';elseif($f>$hoy)$err['doc_'.$id]=$et.': la fecha de presentación no puede ser futura.';}if(!isset($err['doc_'.$id])&&mb_strlen($d['obs'])>255)$err['doc_'.$id]=$et.': las observaciones no pueden superar 255 caracteres.';} return $err;
}
function guardar_docs(int $idEstudiante,array $docs): void {
    $anio=(int)date('Y');
    $st=db()->prepare('INSERT INTO documentacion_estudiante (id_estudiante,id_tipo,anio_lectivo,presentado,fecha_presentacion,observaciones) VALUES (?,?,?,?,?,?) ON DUPLICATE KEY UPDATE presentado=VALUES(presentado),fecha_presentacion=VALUES(fecha_presentacion),observaciones=VALUES(observaciones)');
    foreach($docs as $id=>$d){$fecha=$d['presentado']?($d['fecha']!==''?$d['fecha']:date('Y-m-d')):null;$st->execute([$idEstudiante,$id,$anio,$d['presentado']?1:0,$fecha,$d['obs']!==''?$d['obs']:null]);}
}
function fecha_valida(string $f): ?DateTimeImmutable {
    $dt=DateTimeImmutable::createFromFormat('!Y-m-d',$f);$e=DateTimeImmutable::getLastErrors();if(!$dt||($e&&($e['warning_count']>0||$e['error_count']>0)))return null;return $dt->format('Y-m-d')===$f?$dt:null;
}
function carreras_permitidas(array $usuario): array {
    if(($usuario['id_carrera']??null)===null)return db()->query('SELECT id_carrera,nombre,turno FROM carreras WHERE activa=1 ORDER BY nombre')->fetchAll();
    $st=db()->prepare('SELECT id_carrera,nombre,turno FROM carreras WHERE activa=1 AND id_carrera=?');$st->execute([$usuario['id_carrera']]);return $st->fetchAll();
}
function validar_estudiante(array $d,array $usuario,int $idActual): array {
    $e=[];
    if($d['dni']==='')$e['dni']='El DNI es obligatorio.';elseif(!preg_match('/^[0-9]{6,15}$/',$d['dni']))$e['dni']='El documento debe contener solo números (entre 6 y 15 dígitos).';
    foreach(['apellido'=>'El apellido','nombre'=>'El nombre'] as $k=>$label){if($d[$k]==='')$e[$k]=$label.' es obligatorio.';elseif(mb_strlen($d[$k])>100)$e[$k]=$label.' no puede superar 100 caracteres.';elseif(!preg_match("/^\\p{L}[\\p{L}\\s'.\\-]*$/u",$d[$k]))$e[$k]=$label.' contiene caracteres no válidos.';}
    $hoy=new DateTimeImmutable('today');if($d['fecha_nacimiento']==='')$e['fecha_nacimiento']='La fecha de nacimiento es obligatoria.';else{$f=fecha_valida($d['fecha_nacimiento']);if(!$f)$e['fecha_nacimiento']='La fecha de nacimiento no es válida.';elseif($f>$hoy)$e['fecha_nacimiento']='La fecha de nacimiento no puede ser futura.';elseif((int)$f->format('Y')<1920)$e['fecha_nacimiento']='Revise el año de nacimiento.';}
    foreach(['lugar_nacimiento'=>150,'domicilio'=>200,'telefono'=>50,'titulo_ingreso'=>150,'establecimiento'=>150] as $k=>$max){if(mb_strlen($d[$k])>$max)$e[$k]='El campo supera el máximo de '.$max.' caracteres.';}
    if($d['telefono']!==''&&!preg_match('/^[0-9+\-\s()]{6,50}$/',$d['telefono']))$e['telefono']='El teléfono contiene caracteres no válidos.';
    $anioMax=(int)date('Y')+1;if($d['anio_ingreso']===''||!ctype_digit($d['anio_ingreso'])||(int)$d['anio_ingreso']<1980||(int)$d['anio_ingreso']>$anioMax)$e['anio_ingreso']='El año de ingreso debe estar entre 1980 y '.$anioMax.'.';
    if(mb_strlen($d['observaciones'])>10000)$e['observaciones']='Las observaciones son demasiado extensas.';
    if(!in_array($d['estado'],ESTADOS,true))$e['estado']='Seleccione un estado válido.';
    if($d['id_carrera']===''||!ctype_digit($d['id_carrera']))$e['id_carrera']='Seleccione una carrera.';else{$st=db()->prepare('SELECT 1 FROM carreras WHERE id_carrera=? AND activa=1');$st->execute([(int)$d['id_carrera']]);if(!$st->fetchColumn())$e['id_carrera']='La carrera seleccionada no existe o está inactiva.';elseif(!carrera_permitida($usuario,(int)$d['id_carrera']))$e['id_carrera']='No tiene permiso para trabajar con esa carrera.';}
    if(!isset($e['dni'])){$st=db()->prepare('SELECT 1 FROM estudiantes WHERE dni=? AND id_estudiante<>?');$st->execute([$d['dni'],$idActual]);if($st->fetchColumn())$e['dni']='Ya existe un expediente con ese DNI.';}
    if(!isset($e['dni'])&&!isset($e['apellido'])&&!isset($e['nombre'])&&!isset($e['fecha_nacimiento'])){$st=db()->prepare('SELECT 1 FROM estudiantes WHERE apellido=? AND nombre=? AND fecha_nacimiento=? AND id_estudiante<>?');$st->execute([$d['apellido'],$d['nombre'],$d['fecha_nacimiento'],$idActual]);if($st->fetchColumn())$e['apellido']='Posible expediente duplicado con el mismo nombre y fecha de nacimiento.';}
    return $e;
}
function es_duplicado(PDOException $ex): bool { return (int)($ex->errorInfo[1]??0)===1062; }
function parametros_estudiante(array $d): array { $n=static fn($v)=>$v===''?null:$v;return [$d['dni'],$d['apellido'],$d['nombre'],$d['fecha_nacimiento'],$n($d['lugar_nacimiento']),$n($d['domicilio']),$n($d['telefono']),$n($d['titulo_ingreso']),$n($d['establecimiento']),$n($d['anio_ingreso']),$n($d['observaciones']),$d['estado'],(int)$d['id_carrera']]; }
function obtener_estudiante(int $id): ?array {
    $st=db()->prepare('SELECT e.*,e.created_at AS creado_en,c.nombre AS carrera,c.turno,c.resolucion FROM estudiantes e JOIN carreras c ON c.id_carrera=e.id_carrera WHERE e.id_estudiante=?');$st->execute([$id]);$r=$st->fetch();return $r?:null;
}
function crear_estudiante(array $d,array $docs,int $idUsuario): int {
    $pdo=db();$pdo->beginTransaction();try{
        $plan=$pdo->prepare('SELECT id_plan FROM planes WHERE id_carrera=? AND activo=1 ORDER BY anio_vigencia DESC,id_plan DESC LIMIT 1');$plan->execute([(int)$d['id_carrera']]);$idPlan=$plan->fetchColumn();
        $st=$pdo->prepare('INSERT INTO estudiantes (tipo_documento,dni,apellido,nombre,fecha_nacimiento,lugar_nacimiento,domicilio,telefono,titulo_ingreso,establecimiento,anio_ingreso,observaciones,estado,id_carrera,id_plan) VALUES (\'DNI\',?,?,?,?,?,?,?,?,?,?,?,?,?,?)');
        $params=parametros_estudiante($d);$st->execute([$params[0],$params[1],$params[2],$params[3],$params[4],$params[5],$params[6],$params[7],$params[8],$params[9],$params[10],$params[11],$params[12],$idPlan?:null]);
        $id=(int)$pdo->lastInsertId();guardar_docs($id,$docs);auditar('Alta de expediente','Expediente creado',$id,$idUsuario);$pdo->commit();return $id;
    }catch(Throwable $ex){if($pdo->inTransaction())$pdo->rollBack();throw $ex;}
}
function actualizar_estudiante(int $id,array $d,array $docs,int $idUsuario): void {
    $pdo=db();$pdo->beginTransaction();try{$antes=obtener_estudiante($id);$docsAntes=docs_desde_db(cargar_tipos(),$id);$p=parametros_estudiante($d);
        $st=$pdo->prepare('UPDATE estudiantes SET dni=?,apellido=?,nombre=?,fecha_nacimiento=?,lugar_nacimiento=?,domicilio=?,telefono=?,titulo_ingreso=?,establecimiento=?,anio_ingreso=?,observaciones=?,estado=?,id_carrera=? WHERE id_estudiante=?');$st->execute(array_merge($p,[$id]));
        $planActual=$pdo->prepare('SELECT p.id_plan FROM estudiantes e JOIN planes p ON p.id_plan=e.id_plan WHERE e.id_estudiante=? AND p.id_carrera=? LIMIT 1');$planActual->execute([$id,(int)$d['id_carrera']]);$idPlan=$planActual->fetchColumn();
        if(!$idPlan){$plan=$pdo->prepare('SELECT id_plan FROM planes WHERE id_carrera=? AND activo=1 ORDER BY anio_vigencia DESC,id_plan DESC LIMIT 1');$plan->execute([(int)$d['id_carrera']]);$idPlan=$plan->fetchColumn();$up=$pdo->prepare('UPDATE estudiantes SET id_plan=? WHERE id_estudiante=?');$up->execute([$idPlan?:null,$id]);}
        guardar_docs($id,$docs);$cambios=[];foreach($d as $k=>$v)if((string)($antes[$k]??'')!==(string)$v)$cambios[]=$k;if($docsAntes!=$docs)$cambios[]='documentacion';auditar('Modificación de expediente',$cambios?'Campos: '.implode(', ',$cambios):'Sin cambios',$id,$idUsuario);$pdo->commit();
    }catch(Throwable $ex){if($pdo->inTransaction())$pdo->rollBack();throw $ex;}
}
function id_desde_get(): int { $v=$_GET['id']??'';return is_string($v)&&ctype_digit($v)&&strlen($v)<10?(int)$v:0; }
