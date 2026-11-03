

DROP DATABASE IF EXISTS `ies4_expedientes_v2`;
CREATE DATABASE `ies4_expedientes_v2` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `ies4_expedientes_v2`;
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- 1. PLAN DE ESTUDIOS
CREATE TABLE `carreras` (
  `id_carrera` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(180) NOT NULL,
  `turno` enum('mañana','tarde') NOT NULL,
  `resolucion` varchar(150) DEFAULT NULL COMMENT 'Decreto-Resolución que figura en la ficha',
  `activa` tinyint NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_carrera`)
) ENGINE=InnoDB;

CREATE TABLE `planes` (
  `id_plan` int unsigned NOT NULL AUTO_INCREMENT,
  `id_carrera` int unsigned NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `anio_vigencia` year NOT NULL,
  `resolucion` varchar(150) DEFAULT NULL,
  `activo` tinyint NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_plan`),
  UNIQUE KEY `uq_planes_carrera_anio` (`id_carrera`,`anio_vigencia`),
  CONSTRAINT `fk_planes_carrera` FOREIGN KEY (`id_carrera`) REFERENCES `carreras` (`id_carrera`) ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `materias` (                      -- espacio curricular
  `id_materia` int unsigned NOT NULL AUTO_INCREMENT,
  `id_plan` int unsigned NOT NULL,
  `codigo` varchar(10) NOT NULL COMMENT 'N.º de orden en la resolución',
  `nombre` varchar(180) NOT NULL,
  `anio` tinyint unsigned NOT NULL,
  `orden` smallint unsigned NOT NULL DEFAULT 0,
  `regimen_acreditacion` enum('promocion','examen_final','promocion_o_examen_final') NOT NULL DEFAULT 'promocion_o_examen_final',
  `permite_libre` tinyint NOT NULL DEFAULT 0 COMMENT 'Las marcadas con (*) en la resolución',
  `activa` tinyint NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_materia`),
  UNIQUE KEY `uq_materias_plan_codigo` (`id_plan`,`codigo`),
  KEY `idx_materias_plan_anio` (`id_plan`,`anio`,`orden`),
  CONSTRAINT `fk_materias_plan` FOREIGN KEY (`id_plan`) REFERENCES `planes` (`id_plan`) ON UPDATE CASCADE,
  CONSTRAINT `chk_materias_anio` CHECK (`anio` BETWEEN 1 AND 4)
) ENGINE=InnoDB;

CREATE TABLE `submaterias` (                  
  `id_submateria` int unsigned NOT NULL AUTO_INCREMENT,
  `id_materia` int unsigned NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `orden` smallint unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_submateria`),
  UNIQUE KEY `uq_submaterias` (`id_materia`,`nombre`),
  CONSTRAINT `fk_submaterias_materia` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `correlatividades` (
  `id_materia` int unsigned NOT NULL COMMENT 'Materia que se quiere cursar o rendir',
  `id_requerida` int unsigned NOT NULL COMMENT 'Materia que debe estar regular o aprobada',
  `tipo_requisito` enum('cursar','rendir') NOT NULL,
  `condicion` enum('regular','aprobada') NOT NULL,
  PRIMARY KEY (`id_materia`,`id_requerida`,`tipo_requisito`),
  KEY `idx_corr_requerida` (`id_requerida`),
  CONSTRAINT `fk_corr_materia` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_corr_requerida` FOREIGN KEY (`id_requerida`) REFERENCES `materias` (`id_materia`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_corr_rendir` CHECK (`tipo_requisito` = 'cursar' OR `condicion` = 'aprobada')
) ENGINE=InnoDB;

-- 2. USUARIOS, PERMISOS Y HISTORIAL

CREATE TABLE `usuarios` (
  `id_usuario` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(120) NOT NULL,
  `usuario` varchar(60) NOT NULL,
  `clave_hash` varchar(255) NOT NULL COMMENT 'Hash bcrypt (password_hash de PHP); nunca la clave en texto',
  `rol` enum('admin','vicerrectora','coordinadora','preceptora') NOT NULL,
  `id_carrera` int unsigned DEFAULT NULL COMMENT 'Carrera que puede MODIFICAR. NULL = todas. Consultar pueden todos.',
  `activo` tinyint NOT NULL DEFAULT 1,
  `debe_cambiar_clave` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `uq_usuarios_usuario` (`usuario`),
  KEY `idx_usuarios_carrera` (`id_carrera`),
  CONSTRAINT `fk_usuarios_carrera` FOREIGN KEY (`id_carrera`) REFERENCES `carreras` (`id_carrera`) ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `permisos` (
  `id_permiso` int unsigned NOT NULL AUTO_INCREMENT,
  `codigo` varchar(60) NOT NULL,
  `descripcion` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id_permiso`),
  UNIQUE KEY `uq_permisos_codigo` (`codigo`)
) ENGINE=InnoDB;

CREATE TABLE `rol_permiso` (
  `rol` varchar(30) NOT NULL,
  `id_permiso` int unsigned NOT NULL,
  `puede_ver` tinyint NOT NULL DEFAULT 1,
  `puede_editar` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`rol`,`id_permiso`),
  CONSTRAINT `fk_rolpermiso_permiso` FOREIGN KEY (`id_permiso`) REFERENCES `permisos` (`id_permiso`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `auditoria` (                     -- quién cambió qué y cuándo
  `id_auditoria` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_usuario` int unsigned DEFAULT NULL,
  `tabla` varchar(64) NOT NULL,
  `registro_id` bigint unsigned DEFAULT NULL,
  `accion` enum('INSERT','UPDATE','DELETE','LOGIN','LOGOUT','EXPORT','BACKUP') NOT NULL,
  `datos_anteriores` text DEFAULT NULL,
  `datos_nuevos` text DEFAULT NULL,
  `motivo` varchar(255) DEFAULT NULL,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_auditoria`),
  KEY `idx_auditoria_tabla` (`tabla`,`registro_id`),
  KEY `idx_auditoria_usuario` (`id_usuario`),
  KEY `idx_auditoria_fecha` (`fecha`),
  CONSTRAINT `fk_auditoria_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;


-- 3. ESTUDIANTE Y DOCUMENTACIÓN  (campos de la ficha en papel)
CREATE TABLE `estudiantes` (
  `id_estudiante` int unsigned NOT NULL AUTO_INCREMENT,
  `tipo_documento` enum('DNI','LC','LE') NOT NULL DEFAULT 'DNI',
  `dni` varchar(15) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `lugar_nacimiento` varchar(150) DEFAULT NULL,
  `domicilio` varchar(200) DEFAULT NULL,
  `telefono` varchar(50) DEFAULT NULL,
  `titulo_ingreso` varchar(150) DEFAULT NULL,
  `establecimiento` varchar(150) DEFAULT NULL,
  `anio_ingreso` year DEFAULT NULL,
  `id_carrera` int unsigned NOT NULL,
  `id_plan` int unsigned DEFAULT NULL,
  `estado` enum('activo','libre','egresado','abandono','pase') NOT NULL DEFAULT 'activo',
  `observaciones` text DEFAULT NULL,
  `certificado_por` int unsigned DEFAULT NULL COMMENT 'Autoridad que certificó el expediente',
  `fecha_certificacion` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_estudiante`),
  UNIQUE KEY `uq_estudiantes_dni` (`dni`),
  KEY `idx_estudiantes_apellido` (`apellido`,`nombre`),
  KEY `idx_estudiantes_carrera` (`id_carrera`),
  KEY `idx_estudiantes_plan` (`id_plan`),
  KEY `idx_estudiantes_estado` (`estado`),
  KEY `fk_estudiantes_certificador` (`certificado_por`),
  CONSTRAINT `fk_estudiantes_carrera` FOREIGN KEY (`id_carrera`) REFERENCES `carreras` (`id_carrera`) ON UPDATE CASCADE,
  CONSTRAINT `fk_estudiantes_plan` FOREIGN KEY (`id_plan`) REFERENCES `planes` (`id_plan`) ON UPDATE CASCADE,
  CONSTRAINT `fk_estudiantes_certificador` FOREIGN KEY (`certificado_por`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_estudiantes_anio` CHECK (`anio_ingreso` IS NULL OR `anio_ingreso` BETWEEN 1950 AND 2100)
) ENGINE=InnoDB;

CREATE TABLE `tipos_documento` (
  `id_tipo` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(120) NOT NULL,
  `obligatorio` tinyint NOT NULL DEFAULT 1,
  `vence` tinyint NOT NULL DEFAULT 0 COMMENT '1 = se renueva cada año (apto físico y seguro SEMED)',
  `dias_alerta` smallint unsigned NOT NULL DEFAULT 30,
  `orden` smallint NOT NULL DEFAULT 0,
  `activo` tinyint NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_tipo`),
  UNIQUE KEY `uq_tipos_nombre` (`nombre`)
) ENGINE=InnoDB;

CREATE TABLE `documentacion_estudiante` (
  `id_documento` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_estudiante` int unsigned NOT NULL,
  `id_tipo` int unsigned NOT NULL,
  `anio_lectivo` year DEFAULT NULL COMMENT 'Año al que corresponde (documentos anuales)',
  `presentado` tinyint NOT NULL DEFAULT 0,
  `fecha_presentacion` date DEFAULT NULL,
  `archivo` varchar(255) DEFAULT NULL COMMENT 'Ruta del documento escaneado',
  `observaciones` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_documento`),
  UNIQUE KEY `uq_doc_estudiante_tipo_anio` (`id_estudiante`,`id_tipo`,`anio_lectivo`),
  KEY `idx_doc_tipo` (`id_tipo`),
  CONSTRAINT `fk_doc_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_doc_tipo` FOREIGN KEY (`id_tipo`) REFERENCES `tipos_documento` (`id_tipo`) ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 4. SITUACIÓN ACADÉMICA (réplica de la ficha / Vademécum)
--    cursadas guarda también el "registro de inscripciones para cursar y recursar".
-- ---------------------------------------------------------------------
CREATE TABLE `cursadas` (
  `id_cursada` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_estudiante` int unsigned NOT NULL,
  `id_materia` int unsigned NOT NULL,
  `anio_cursada` year NOT NULL,
  `fecha_inscripcion` date DEFAULT NULL,
  `tipo_inscripcion` enum('cursar','recursar','libre') NOT NULL DEFAULT 'cursar',
  `caracter` enum('regular','libre','promocional') DEFAULT NULL COMMENT 'NULL = todavía cursando',
  `asistencia` decimal(5,2) DEFAULT NULL COMMENT '% de asistencia',
  `tp` decimal(5,2) DEFAULT NULL COMMENT '% de trabajos prácticos',
  `promedio` decimal(4,2) DEFAULT NULL,
  `nota_general` decimal(4,2) DEFAULT NULL,
  `nota_definitiva` decimal(4,2) DEFAULT NULL,
  `estado` enum('cursando','regular','libre','promocional','aprobada','desaprobada','abandonada') NOT NULL DEFAULT 'cursando',
  `observaciones` text DEFAULT NULL,
  PRIMARY KEY (`id_cursada`),
  UNIQUE KEY `uq_cursadas` (`id_estudiante`,`id_materia`,`anio_cursada`),
  KEY `idx_cursadas_materia` (`id_materia`,`anio_cursada`),
  CONSTRAINT `fk_cursadas_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cursadas_materia` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON UPDATE CASCADE,
  CONSTRAINT `chk_cursadas_asistencia` CHECK (`asistencia` IS NULL OR `asistencia` BETWEEN 0 AND 100),
  CONSTRAINT `chk_cursadas_tp` CHECK (`tp` IS NULL OR `tp` BETWEEN 0 AND 100),
  CONSTRAINT `chk_cursadas_promedio` CHECK (`promedio` IS NULL OR `promedio` BETWEEN 0 AND 10),
  CONSTRAINT `chk_cursadas_nota_general` CHECK (`nota_general` IS NULL OR `nota_general` BETWEEN 0 AND 10),
  CONSTRAINT `chk_cursadas_nota_definitiva` CHECK (`nota_definitiva` IS NULL OR `nota_definitiva` BETWEEN 0 AND 10)
) ENGINE=InnoDB;

CREATE TABLE `examenes_finales` (              -- un registro por intento (3 como regular + 3 como libre)
  `id_examen` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_estudiante` int unsigned NOT NULL,
  `id_materia` int unsigned NOT NULL,
  `id_submateria` int unsigned DEFAULT NULL COMMENT 'Solo en materias compuestas (cada deporte con su nota, libro y folio)',
  `id_cursada` bigint unsigned DEFAULT NULL,
  `numero_intento` tinyint unsigned NOT NULL DEFAULT 1,
  `condicion_alumno` enum('regular','libre','promocion') NOT NULL,
  `fecha` date NOT NULL,
  `nota` decimal(4,2) DEFAULT NULL,
  `estado` enum('presente','ausente') NOT NULL DEFAULT 'presente',
  `libro` varchar(20) DEFAULT NULL,
  `folio` varchar(20) DEFAULT NULL,
  `observacion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_examen`),
  UNIQUE KEY `uq_examen` (`id_estudiante`,`id_materia`,`id_submateria`,`fecha`),
  KEY `idx_examenes_materia` (`id_materia`,`fecha`),
  KEY `fk_examenes_cursada` (`id_cursada`),
  KEY `fk_examenes_submateria` (`id_submateria`),
  CONSTRAINT `fk_examenes_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_examenes_materia` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON UPDATE CASCADE,
  CONSTRAINT `fk_examenes_submateria` FOREIGN KEY (`id_submateria`) REFERENCES `submaterias` (`id_submateria`) ON UPDATE CASCADE,
  CONSTRAINT `fk_examenes_cursada` FOREIGN KEY (`id_cursada`) REFERENCES `cursadas` (`id_cursada`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_examenes_intento` CHECK (`numero_intento` BETWEEN 1 AND 10),
  CONSTRAINT `chk_examenes_nota` CHECK (`nota` IS NULL OR `nota` BETWEEN 0 AND 10)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 5. TRÁMITES (notas de aprobación, pases, asimilaciones, equivalencias)
--    La resolución la emite Secretaría Académica: acá solo se registra N.º y fecha.
-- ---------------------------------------------------------------------
CREATE TABLE `tramites` (
  `id_tramite` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_estudiante` int unsigned NOT NULL,
  `tipo` enum('pase','asimilacion','equivalencia','nota_aprobacion') NOT NULL,
  `fecha_solicitud` date NOT NULL,
  `fecha_limite` date DEFAULT NULL COMMENT 'Plazo para resolver (60 días)',
  `estado` enum('en_curso','en_revision','observado','resuelto','rechazado') NOT NULL DEFAULT 'en_curso',
  `nro_resolucion` varchar(50) DEFAULT NULL,
  `fecha_resolucion` date DEFAULT NULL,
  `detalle` text DEFAULT NULL,
  `id_usuario_inicia` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id_tramite`),
  KEY `idx_tramites_estudiante` (`id_estudiante`),
  KEY `idx_tramites_estado` (`estado`,`fecha_limite`),
  CONSTRAINT `fk_tramites_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_tramites_usuario` FOREIGN KEY (`id_usuario_inicia`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_tramites_fechas` CHECK (`fecha_limite` IS NULL OR `fecha_limite` >= `fecha_solicitud`)
) ENGINE=InnoDB;

CREATE TABLE `tramite_materias` (            
  `id_tramite` bigint unsigned NOT NULL,
  `id_materia` int unsigned NOT NULL,
  PRIMARY KEY (`id_tramite`,`id_materia`),
  KEY `idx_tm_materia` (`id_materia`),
  CONSTRAINT `fk_tm_tramite` FOREIGN KEY (`id_tramite`) REFERENCES `tramites` (`id_tramite`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_tm_materia` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON UPDATE CASCADE
) ENGINE=InnoDB;

SET FOREIGN_KEY_CHECKS = 1;

-- ---------------------------------------------------------------------
-- 6. DATOS INICIALES
-- ---------------------------------------------------------------------
INSERT INTO `carreras` (`id_carrera`,`nombre`,`turno`,`resolucion`) VALUES
(1,'Profesorado de Educación Física con orientación en Tiempo Libre y Recreación','tarde','Decreto-Resolución N° 13929-E-19');

INSERT INTO `planes` (`id_plan`,`id_carrera`,`nombre`,`anio_vigencia`,`resolucion`) VALUES
(1,1,'Plan de Estudios 2020 — Profesorado de Educación Física con orientación en Tiempo Libre y Recreación',2020,'Resolución N° 2281-E-20');

-- Espacios curriculares (Res. 2281-E-20)
INSERT INTO `materias` (`id_materia`,`id_plan`,`codigo`,`nombre`,`anio`,`orden`,`regimen_acreditacion`,`permite_libre`) VALUES
(1,1,'01','Pedagogía',1,1,'promocion_o_examen_final',1),
(2,1,'02','Psicología Educacional',1,2,'promocion_o_examen_final',1),
(3,1,'03','Alfabetización Académica',1,3,'promocion_o_examen_final',0),
(4,1,'04','Didáctica General',1,4,'promocion_o_examen_final',0),
(5,1,'11','Anatomía y Fisiología',1,5,'promocion_o_examen_final',0),
(6,1,'12','Prácticas Ludomotrices y su Enseñanza',1,6,'promocion_o_examen_final',0),
(7,1,'13','Prácticas Gimnásticas y su Enseñanza',1,7,'promocion_o_examen_final',0),
(8,1,'14','Prácticas Atléticas y su Enseñanza',1,8,'promocion_o_examen_final',0),
(9,1,'15','Prácticas de Recreación y Tiempo Libre y su Enseñanza',1,9,'promocion_o_examen_final',0),
(10,1,'32','Práctica I',1,10,'promocion',0),
(11,1,'05','Filosofía',2,1,'promocion_o_examen_final',1),
(12,1,'06','Historia de las Políticas Educativas en la Argentina',2,2,'promocion_o_examen_final',1),
(13,1,'16','Sujeto de la Educación',2,3,'examen_final',0),
(14,1,'17','Prácticas Acuáticas y su Enseñanza',2,4,'promocion_o_examen_final',0),
(15,1,'18','Prácticas Motrices Expresivas y su Enseñanza',2,5,'promocion_o_examen_final',0),
(16,1,'19','Prácticas Deportivas I y su Enseñanza',2,6,'promocion_o_examen_final',0),
(17,1,'20','Prácticas Deportivas II y su Enseñanza',2,7,'promocion_o_examen_final',0),
(18,1,'21','Didáctica de la Educación Física',2,8,'examen_final',0),
(19,1,'22','Didáctica de las Prácticas Recreativas y el Tiempo Libre',2,9,'promocion_o_examen_final',0),
(20,1,'33','Práctica II',2,10,'promocion',0),
(21,1,'07','Educación Sexual Integral',3,1,'promocion_o_examen_final',0),
(22,1,'08','Integración de las TIC en la Enseñanza',3,2,'promocion_o_examen_final',0),
(23,1,'09','Sociología de la Educación',3,3,'promocion_o_examen_final',0),
(24,1,'23','Prácticas Deportivas III y su Enseñanza',3,4,'promocion_o_examen_final',0),
(25,1,'24','Prácticas Deportivas IV y su Enseñanza',3,5,'promocion_o_examen_final',0),
(26,1,'25','Práctica en la Naturaleza y al Aire Libre y su Enseñanza',3,6,'promocion_o_examen_final',0),
(27,1,'26','Entrenamiento para la Actividad Física',3,7,'examen_final',0),
(28,1,'27','Historia y Epistemología de la Educación Física',3,8,'promocion_o_examen_final',0),
(29,1,'34','Práctica III',3,9,'promocion',0),
(30,1,'10','Ética Profesional Docente',4,1,'promocion_o_examen_final',0),
(31,1,'28','Educación Física Inclusiva',4,2,'promocion_o_examen_final',0),
(32,1,'29','Proyectos de Recreación y Tiempo Libre y su Enseñanza',4,3,'promocion_o_examen_final',0),
(33,1,'30','Educación Física y Salud',4,4,'promocion_o_examen_final',0),
(34,1,'31','Gestión de Espacios y Organizaciones Deportivas',4,5,'promocion_o_examen_final',0),
(35,1,'36','Unidad de Definición Institucional',4,6,'promocion',0),
(36,1,'35','Residencia Pedagógica',4,7,'promocion',0);

INSERT INTO `submaterias` (`id_materia`,`nombre`,`orden`) VALUES
(17,'Handbol',1),
(17,'Básquet',2),
(24,'Hockey',1),
(24,'Rugby',2),
(24,'Fútbol',3),
(25,'Gimnasia',1),
(25,'Atletismo',2),
(10,'Práctica en terreno',1),
(10,'Taller Integrador I',2),
(20,'Práctica en terreno',1),
(20,'Taller Integrador II',2),
(29,'Práctica en terreno',1),
(29,'Taller Integrador III',2);

-- Correlatividades (una línea por materia)
INSERT INTO `correlatividades` (`id_materia`,`id_requerida`,`tipo_requisito`,`condicion`) VALUES
  (11,1,'cursar','regular'),(11,1,'rendir','aprobada'),
  (13,2,'cursar','regular'),(13,2,'rendir','aprobada'),(13,5,'cursar','regular'),(13,5,'rendir','aprobada'),
  (14,4,'cursar','regular'),(14,4,'rendir','aprobada'),(14,6,'cursar','regular'),(14,6,'rendir','aprobada'),
  (15,4,'cursar','regular'),(15,4,'rendir','aprobada'),(15,6,'cursar','regular'),(15,6,'rendir','aprobada'),
  (16,4,'cursar','regular'),(16,4,'rendir','aprobada'),(16,6,'cursar','regular'),(16,6,'rendir','aprobada'),
  (17,4,'cursar','regular'),(17,4,'rendir','aprobada'),(17,6,'cursar','regular'),(17,6,'rendir','aprobada'),
  (18,1,'cursar','regular'),(18,1,'rendir','aprobada'),(18,2,'cursar','regular'),(18,2,'rendir','aprobada'),(18,4,'cursar','regular'),(18,4,'rendir','aprobada'),
  (19,4,'cursar','regular'),(19,4,'rendir','aprobada'),(19,9,'cursar','regular'),(19,9,'rendir','aprobada'),
  (20,10,'cursar','aprobada'),(20,10,'rendir','aprobada'),
  (22,4,'cursar','aprobada'),(22,4,'rendir','aprobada'),
  (23,1,'cursar','aprobada'),(23,1,'rendir','aprobada'),(23,12,'cursar','regular'),(23,12,'rendir','aprobada'),
  (24,7,'cursar','aprobada'),(24,7,'rendir','aprobada'),(24,8,'cursar','aprobada'),(24,8,'rendir','aprobada'),(24,15,'cursar','regular'),(24,15,'rendir','aprobada'),(24,16,'cursar','regular'),(24,16,'rendir','aprobada'),(24,17,'cursar','regular'),(24,17,'rendir','aprobada'),
  (25,7,'cursar','aprobada'),(25,7,'rendir','aprobada'),(25,8,'cursar','aprobada'),(25,8,'rendir','aprobada'),(25,15,'cursar','regular'),(25,15,'rendir','aprobada'),(25,16,'cursar','regular'),(25,16,'rendir','aprobada'),(25,17,'cursar','regular'),(25,17,'rendir','aprobada'),
  (26,6,'cursar','aprobada'),(26,6,'rendir','aprobada'),(26,9,'cursar','aprobada'),(26,9,'rendir','aprobada'),(26,13,'cursar','regular'),(26,14,'cursar','regular'),(26,14,'rendir','aprobada'),(26,19,'cursar','regular'),
  (27,5,'cursar','aprobada'),(27,5,'rendir','aprobada'),(27,7,'cursar','aprobada'),(27,7,'rendir','aprobada'),(27,8,'cursar','aprobada'),(27,8,'rendir','aprobada'),(27,15,'cursar','regular'),(27,15,'rendir','aprobada'),(27,16,'cursar','regular'),(27,16,'rendir','aprobada'),
  (28,11,'cursar','regular'),(28,11,'rendir','aprobada'),(28,12,'cursar','regular'),(28,12,'rendir','aprobada'),
  (29,6,'cursar','aprobada'),(29,6,'rendir','aprobada'),(29,7,'cursar','aprobada'),(29,7,'rendir','aprobada'),(29,8,'cursar','aprobada'),(29,8,'rendir','aprobada'),(29,13,'cursar','regular'),(29,13,'rendir','aprobada'),(29,14,'cursar','regular'),(29,14,'rendir','aprobada'),(29,15,'cursar','regular'),(29,15,'rendir','aprobada'),(29,16,'cursar','regular'),(29,16,'rendir','aprobada'),(29,17,'cursar','aprobada'),(29,17,'rendir','aprobada'),(29,20,'cursar','aprobada'),(29,20,'rendir','aprobada'),
  (30,11,'cursar','aprobada'),(30,11,'rendir','aprobada'),
  (31,5,'cursar','aprobada'),(31,5,'rendir','aprobada'),(31,6,'cursar','aprobada'),(31,6,'rendir','aprobada'),(31,14,'cursar','aprobada'),(31,14,'rendir','aprobada'),(31,21,'cursar','regular'),(31,21,'rendir','aprobada'),
  (32,6,'cursar','aprobada'),(32,6,'rendir','aprobada'),(32,24,'cursar','regular'),(32,24,'rendir','aprobada'),
  (33,25,'cursar','regular'),(33,25,'rendir','aprobada'),
  (34,26,'cursar','regular'),(34,26,'rendir','aprobada'),
  (35,1,'cursar','aprobada'),(35,1,'rendir','aprobada'),(35,2,'cursar','aprobada'),(35,2,'rendir','aprobada'),(35,3,'cursar','aprobada'),(35,3,'rendir','aprobada'),(35,4,'cursar','aprobada'),(35,4,'rendir','aprobada'),(35,5,'cursar','aprobada'),(35,5,'rendir','aprobada'),(35,6,'cursar','aprobada'),(35,6,'rendir','aprobada'),(35,7,'cursar','aprobada'),(35,7,'rendir','aprobada'),(35,8,'cursar','aprobada'),(35,8,'rendir','aprobada'),(35,9,'cursar','aprobada'),(35,9,'rendir','aprobada'),(35,10,'cursar','aprobada'),(35,10,'rendir','aprobada'),
  (36,1,'cursar','aprobada'),(36,1,'rendir','aprobada'),(36,2,'cursar','aprobada'),(36,2,'rendir','aprobada'),(36,3,'cursar','aprobada'),(36,3,'rendir','aprobada'),(36,4,'cursar','aprobada'),(36,4,'rendir','aprobada'),(36,5,'cursar','aprobada'),(36,5,'rendir','aprobada'),(36,6,'cursar','aprobada'),(36,6,'rendir','aprobada'),(36,7,'cursar','aprobada'),(36,7,'rendir','aprobada'),(36,8,'cursar','aprobada'),(36,8,'rendir','aprobada'),(36,9,'cursar','aprobada'),(36,9,'rendir','aprobada'),(36,10,'cursar','aprobada'),(36,10,'rendir','aprobada'),(36,11,'cursar','aprobada'),(36,11,'rendir','aprobada'),(36,12,'cursar','aprobada'),(36,12,'rendir','aprobada'),(36,13,'cursar','aprobada'),(36,13,'rendir','aprobada'),(36,14,'cursar','aprobada'),(36,14,'rendir','aprobada'),(36,15,'cursar','aprobada'),(36,15,'rendir','aprobada'),(36,16,'cursar','aprobada'),(36,16,'rendir','aprobada'),(36,17,'cursar','aprobada'),(36,17,'rendir','aprobada'),(36,18,'cursar','aprobada'),(36,18,'rendir','aprobada'),(36,19,'cursar','aprobada'),(36,19,'rendir','aprobada'),(36,20,'cursar','aprobada'),(36,20,'rendir','aprobada'),(36,21,'cursar','regular'),(36,21,'rendir','aprobada'),(36,22,'cursar','regular'),(36,22,'rendir','aprobada'),(36,23,'cursar','regular'),(36,23,'rendir','aprobada'),(36,24,'cursar','regular'),(36,24,'rendir','aprobada'),(36,25,'cursar','regular'),(36,25,'rendir','aprobada'),(36,26,'cursar','regular'),(36,26,'rendir','aprobada'),(36,27,'cursar','regular'),(36,27,'rendir','aprobada'),(36,28,'cursar','regular'),(36,28,'rendir','aprobada'),(36,29,'cursar','aprobada'),(36,29,'rendir','aprobada');

INSERT INTO `tipos_documento` (`id_tipo`,`nombre`,`obligatorio`,`vence`,`dias_alerta`,`orden`) VALUES
(1,'DNI',1,0,0,1),
(2,'Título o constancia de título en trámite',1,0,0,2),
(3,'Apto físico',1,1,30,3),
(4,'Seguro SEMED',1,1,30,4);

INSERT INTO `permisos` (`id_permiso`,`codigo`,`descripcion`) VALUES
(1,'expedientes.ver','Ver expedientes y datos personales'),
(2,'expedientes.editar','Crear, editar y certificar expedientes'),
(3,'tramites.ver','Ver trámites y su estado'),
(4,'tramites.editar','Iniciar, modificar y resolver trámites'),
(5,'notas.ver','Ver notas y situación académica'),
(6,'notas.editar','Cargar y modificar notas'),
(7,'usuarios.ver','Ver usuarios'),
(8,'usuarios.editar','Crear y modificar usuarios'),
(9,'auditoria.ver','Ver el historial de cambios'),
(10,'reportes.ver','Ver e imprimir/exportar expedientes'),
(11,'backups.ejecutar','Generar copias de seguridad');

-- Preceptora: carga y modifica. Vicerrectora y Coordinadora: solo consulta. Administradora: todo.
INSERT INTO `rol_permiso` (`rol`,`id_permiso`,`puede_ver`,`puede_editar`) VALUES
('admin',1,1,1),
('admin',2,1,1),
('admin',3,1,1),
('admin',4,1,1),
('admin',5,1,1),
('admin',6,1,1),
('admin',7,1,1),
('admin',8,1,1),
('admin',9,1,1),
('admin',10,1,1),
('admin',11,1,1),
('vicerrectora',1,1,0),
('vicerrectora',3,1,0),
('vicerrectora',5,1,0),
('vicerrectora',7,1,0),
('vicerrectora',9,1,0),
('vicerrectora',10,1,0),
('coordinadora',1,1,0),
('coordinadora',3,1,0),
('coordinadora',5,1,0),
('coordinadora',10,1,0),
('preceptora',1,1,0),
('preceptora',2,1,1),
('preceptora',3,1,0),
('preceptora',4,1,1),
('preceptora',5,1,0),
('preceptora',6,1,1),
('preceptora',10,1,0);

-- Usuarios iniciales. CLAVE de todos: Cambiar2026!  (cambiarla antes de usar datos reales)
INSERT INTO `usuarios` (`id_usuario`,`nombre`,`usuario`,`clave_hash`,`rol`,`id_carrera`,`activo`,`debe_cambiar_clave`) VALUES
(1,'Administrador del Sistema','admin','$2y$10$4HiE0ppCUxUm.0hYcmbGNOnY9FeQE.HIF0NKxrCpxM927bo7U9OP6','admin',NULL,1,0),
(2,'Vicerrectora','vicerrectora','$2y$10$4HiE0ppCUxUm.0hYcmbGNOnY9FeQE.HIF0NKxrCpxM927bo7U9OP6','vicerrectora',NULL,1,0),
(3,'Coordinadora de Educación Física','coordinadora','$2y$10$4HiE0ppCUxUm.0hYcmbGNOnY9FeQE.HIF0NKxrCpxM927bo7U9OP6','coordinadora',NULL,1,0),
(4,'Preceptora Turno Tarde','preceptora.tarde','$2y$10$4HiE0ppCUxUm.0hYcmbGNOnY9FeQE.HIF0NKxrCpxM927bo7U9OP6','preceptora',1,1,0);

-- NOTA: para sumar la carrera de la mañana (Res. 2286-E-20) alcanza con INSERT en carreras, planes,
-- materias y correlatividades; la estructura no cambia.

-- ---------------------------------------------------------------------
-- 7. VISTAS (las alertas y verificaciones se calculan, no se guardan)
-- ---------------------------------------------------------------------

-- Materias aprobadas: final aprobado (nota >= 4) o reconocida por una equivalencia/asimilación resuelta.
-- En materias compuestas hacen falta aprobadas TODAS las submaterias.
CREATE VIEW `v_materia_aprobada` AS
SELECT x.id_estudiante, x.id_materia
FROM examenes_finales x
WHERE x.id_submateria IS NULL AND x.estado = 'presente' AND x.nota >= 4
GROUP BY x.id_estudiante, x.id_materia
UNION
SELECT x.id_estudiante, x.id_materia
FROM examenes_finales x
WHERE x.id_submateria IS NOT NULL AND x.estado = 'presente' AND x.nota >= 4
GROUP BY x.id_estudiante, x.id_materia
HAVING COUNT(DISTINCT x.id_submateria) = (SELECT COUNT(*) FROM submaterias s WHERE s.id_materia = x.id_materia)
UNION
SELECT t.id_estudiante, tm.id_materia
FROM tramites t JOIN tramite_materias tm ON tm.id_tramite = t.id_tramite
WHERE t.estado = 'resuelto' AND t.tipo IN ('equivalencia','asimilacion');

-- Estado de cada materia del plan para cada estudiante. Regularidad: 2 años (año de cursada + 2).
CREATE VIEW `v_situacion_academica` AS
SELECT e.id_estudiante, e.apellido, e.nombre, e.dni, e.id_carrera,
       m.id_materia, m.anio, m.orden, m.nombre AS materia,
       CASE
         WHEN EXISTS (SELECT 1 FROM v_materia_aprobada a
                      WHERE a.id_estudiante = e.id_estudiante AND a.id_materia = m.id_materia) THEN 'aprobada'
         WHEN EXISTS (SELECT 1 FROM cursadas c
                      WHERE c.id_estudiante = e.id_estudiante AND c.id_materia = m.id_materia
                        AND c.caracter IN ('regular','promocional')
                        AND c.anio_cursada + 2 >= YEAR(CURDATE())) THEN 'regular'
         WHEN EXISTS (SELECT 1 FROM cursadas c
                      WHERE c.id_estudiante = e.id_estudiante AND c.id_materia = m.id_materia
                        AND c.caracter IS NULL AND c.estado = 'cursando') THEN 'cursando'
         WHEN EXISTS (SELECT 1 FROM cursadas c
                      WHERE c.id_estudiante = e.id_estudiante AND c.id_materia = m.id_materia
                        AND c.caracter IS NOT NULL) THEN 'libre'
         ELSE 'pendiente'
       END AS estado_materia,
       (SELECT COUNT(*) FROM examenes_finales x WHERE x.id_estudiante = e.id_estudiante AND x.id_materia = m.id_materia
          AND x.condicion_alumno = 'regular' AND x.estado = 'presente' AND x.nota < 4) AS aplazos_regular,
       (SELECT COUNT(*) FROM examenes_finales x WHERE x.id_estudiante = e.id_estudiante AND x.id_materia = m.id_materia
          AND x.condicion_alumno = 'libre' AND x.estado = 'presente' AND x.nota < 4)   AS aplazos_libre
FROM estudiantes e
JOIN materias m ON m.id_plan = e.id_plan AND m.activa = 1;

-- ¿Cumple las correlatividades? (cumple = 1 / 0). Filtrar por estudiante y materia.
CREATE VIEW `v_correlatividades_estado` AS
SELECT s.id_estudiante, s.apellido, s.nombre, s.dni,
       co.id_materia AS id_materia_objetivo, m.nombre AS materia_objetivo,
       co.tipo_requisito, co.condicion,
       co.id_requerida AS id_materia_requerida, r.nombre AS materia_requerida,
       s.estado_materia AS estado_requerida,
       CASE WHEN co.condicion = 'aprobada' AND s.estado_materia = 'aprobada' THEN 1
            WHEN co.condicion = 'regular'  AND s.estado_materia IN ('regular','aprobada') THEN 1
            ELSE 0 END AS cumple
FROM v_situacion_academica s
JOIN correlatividades co ON co.id_requerida = s.id_materia
JOIN materias m ON m.id_materia = co.id_materia
JOIN materias r ON r.id_materia = co.id_requerida;

-- Documentación obligatoria que falta, o que venció (apto físico y seguro: se renuevan cada año).
CREATE VIEW `v_documentacion_pendiente` AS
SELECT e.id_estudiante, e.apellido, e.nombre, e.dni, e.id_carrera,
       t.id_tipo, t.nombre AS documento,
       CASE WHEN EXISTS (SELECT 1 FROM documentacion_estudiante d2
                         WHERE d2.id_estudiante = e.id_estudiante AND d2.id_tipo = t.id_tipo AND d2.presentado = 1)
            THEN 'vencido' ELSE 'falta' END AS situacion
FROM estudiantes e
JOIN tipos_documento t ON t.obligatorio = 1 AND t.activo = 1
LEFT JOIN documentacion_estudiante d
       ON d.id_estudiante = e.id_estudiante AND d.id_tipo = t.id_tipo
      AND (t.vence = 0 OR d.anio_lectivo = YEAR(CURDATE()))
WHERE e.estado = 'activo' AND (d.id_documento IS NULL OR d.presentado = 0);

-- Trámites abiertos con los días que quedan (negativo = plazo vencido).
CREATE VIEW `v_tramites_pendientes` AS
SELECT t.id_tramite, t.id_estudiante, e.apellido, e.nombre, e.dni,
       t.tipo, t.fecha_solicitud, t.fecha_limite, t.estado,
       DATEDIFF(t.fecha_limite, CURDATE()) AS dias_restantes
FROM tramites t JOIN estudiantes e ON e.id_estudiante = t.id_estudiante
WHERE t.estado IN ('en_curso','en_revision','observado');
