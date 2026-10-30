
CREATE DATABASE IF NOT EXISTS ies4_expedientes_v2
  DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ies4_expedientes_v2;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
DROP VIEW  IF EXISTS v_tramites_pendientes, v_legajo, v_documentacion_pendiente,
                     v_correlatividad_estado, v_situacion_academica, v_materia_aprobada;
DROP TABLE IF EXISTS auditoria, tramite_materia, tramite, examen, cursada, inscripcion,
                     documentacion_estudiante, tipo_documento, estudiante, usuario,
                     correlatividad, submateria, materia, carrera;
SET FOREIGN_KEY_CHECKS = 1;


-- 1. plan de estudios

CREATE TABLE carrera (
  id_carrera  INT NOT NULL AUTO_INCREMENT,
  nombre      VARCHAR(120) NOT NULL,
  turno       ENUM('Mañana','Tarde') NOT NULL,
  resolucion  VARCHAR(80) NULL COMMENT 'Resolución del plan vigente',
  PRIMARY KEY (id_carrera),
  UNIQUE KEY uq_carrera_turno (turno)
) ENGINE=InnoDB;

CREATE TABLE materia (                       
  id_materia  INT NOT NULL AUTO_INCREMENT,
  id_carrera  INT NOT NULL,
  codigo      VARCHAR(10) NOT NULL COMMENT 'N.º de orden que figura en la resolución',
  nombre      VARCHAR(120) NOT NULL,
  anio        TINYINT NOT NULL,
  orden       SMALLINT NOT NULL DEFAULT 0,
  periodo     ENUM('Anual','1C','2C') NOT NULL DEFAULT 'Anual',
  regimen     ENUM('Promocion','Examen final','Promocion o examen final') NOT NULL DEFAULT 'Promocion o examen final',
  permite_libre TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Las marcadas con (*) en la resolución',
  PRIMARY KEY (id_materia),
  UNIQUE KEY uq_materia (id_carrera, codigo),
  CONSTRAINT fk_materia_carrera FOREIGN KEY (id_carrera) REFERENCES carrera (id_carrera),
  CONSTRAINT chk_materia_anio CHECK (anio BETWEEN 1 AND 4)
) ENGINE=InnoDB;

CREATE TABLE submateria (                   
  id_submateria INT NOT NULL AUTO_INCREMENT,
  id_materia    INT NOT NULL,
  nombre        VARCHAR(100) NOT NULL,
  orden         TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (id_submateria),
  UNIQUE KEY uq_submateria (id_materia, nombre),
  CONSTRAINT fk_sub_materia FOREIGN KEY (id_materia) REFERENCES materia (id_materia) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE correlatividad (
  id_materia      INT NOT NULL COMMENT 'Materia que se quiere cursar o rendir',
  id_requerida    INT NOT NULL COMMENT 'Materia que debe estar regular o aprobada',
  tipo_requisito  ENUM('Cursar','Rendir') NOT NULL,
  condicion       ENUM('Regular','Aprobada') NOT NULL,
  PRIMARY KEY (id_materia, id_requerida, tipo_requisito),
  CONSTRAINT fk_corr_materia   FOREIGN KEY (id_materia)   REFERENCES materia (id_materia) ON DELETE CASCADE,
  CONSTRAINT fk_corr_requerida FOREIGN KEY (id_requerida) REFERENCES materia (id_materia) ON DELETE CASCADE,
  CONSTRAINT chk_corr_distinta CHECK (id_materia <> id_requerida),
  CONSTRAINT chk_corr_rendir   CHECK (tipo_requisito = 'Cursar' OR condicion = 'Aprobada')
) ENGINE=InnoDB;


-- 2. Usuarios

CREATE TABLE usuario (
  id_usuario  INT NOT NULL AUTO_INCREMENT,
  nombre      VARCHAR(80) NOT NULL,
  usuario     VARCHAR(50) NOT NULL,
  clave       VARCHAR(255) NOT NULL COMMENT 'Hash bcrypt (password_hash de PHP), nunca la clave en texto',
  rol         ENUM('Preceptora','Coordinadora','Vicerrectora','Administradora') NOT NULL,
  id_carrera  INT NULL COMMENT 'Turno que puede MODIFICAR. NULL = todos. Consultar pueden todos.',
  activo      TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (id_usuario),
  UNIQUE KEY uq_usuario (usuario),
  CONSTRAINT fk_usuario_carrera FOREIGN KEY (id_carrera) REFERENCES carrera (id_carrera)
) ENGINE=InnoDB;


-- 3. Estudiantes y documentacion

CREATE TABLE estudiante (
  id_estudiante    INT NOT NULL AUTO_INCREMENT,
  legajo           VARCHAR(20) NULL,
  dni              VARCHAR(15) NOT NULL,
  apellido         VARCHAR(60) NOT NULL,
  nombre           VARCHAR(60) NOT NULL,
  fecha_nacimiento DATE NOT NULL,
  lugar_nacimiento VARCHAR(80) NULL,
  domicilio        VARCHAR(120) NULL,
  localidad        VARCHAR(80) NULL,
  telefono         VARCHAR(40) NULL,
  email            VARCHAR(120) NULL,
  titulo_ingreso   VARCHAR(100) NULL,
  establecimiento  VARCHAR(100) NULL,
  anio_ingreso     SMALLINT NOT NULL,
  id_carrera       INT NOT NULL,
  estado           ENUM('Regular','Libre','Con pase','Abandono','Egresado') NOT NULL DEFAULT 'Regular',
  observaciones    TEXT NULL,
  certificado_por  INT NULL COMMENT 'Usuario que certificó el expediente (vicerrectora)',
  fecha_certificacion DATETIME NULL,
  creado_en        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_estudiante),
  UNIQUE KEY uq_estudiante_dni (dni),            -- un alumno no puede estar en los dos turnos
  UNIQUE KEY uq_estudiante_legajo (legajo),
  KEY idx_estudiante_apellido (apellido, nombre),
  KEY idx_estudiante_carrera (id_carrera),
  CONSTRAINT fk_est_carrera FOREIGN KEY (id_carrera) REFERENCES carrera (id_carrera),
  CONSTRAINT fk_est_certificador FOREIGN KEY (certificado_por) REFERENCES usuario (id_usuario) ON DELETE SET NULL,
  CONSTRAINT chk_est_anio CHECK (anio_ingreso BETWEEN 1980 AND 2100)
) ENGINE=InnoDB;

CREATE TABLE tipo_documento (
  id_tipo     INT NOT NULL AUTO_INCREMENT,
  nombre      VARCHAR(80) NOT NULL,
  obligatorio TINYINT(1) NOT NULL DEFAULT 1,
  vence_anual TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 = se renueva cada año (apto físico, seguro)',
  orden       SMALLINT NOT NULL DEFAULT 0,
  PRIMARY KEY (id_tipo),
  UNIQUE KEY uq_tipo_documento (nombre)
) ENGINE=InnoDB;

CREATE TABLE documentacion_estudiante (
  id_estudiante      INT NOT NULL,
  id_tipo            INT NOT NULL,
  presentado         TINYINT(1) NOT NULL DEFAULT 0,
  fecha_presentacion DATE NULL,
  anio_lectivo       SMALLINT NULL COMMENT 'Año al que corresponde (para los documentos anuales)',
  archivo            VARCHAR(255) NULL COMMENT 'Ruta del escaneo dentro de la carpeta uploads/',
  observaciones      VARCHAR(255) NULL,
  PRIMARY KEY (id_estudiante, id_tipo),
  CONSTRAINT fk_doc_estudiante FOREIGN KEY (id_estudiante) REFERENCES estudiante (id_estudiante) ON DELETE CASCADE,
  CONSTRAINT fk_doc_tipo       FOREIGN KEY (id_tipo)       REFERENCES tipo_documento (id_tipo)
) ENGINE=InnoDB;


-- 4. Situación académica 

CREATE TABLE inscripcion (                   
  id_inscripcion INT NOT NULL AUTO_INCREMENT,
  id_estudiante  INT NOT NULL,
  id_materia     INT NOT NULL,
  fecha          DATE NOT NULL,
  anio_cursada   SMALLINT NOT NULL,
  condicion      ENUM('Cursar','Recursar') NOT NULL,
  observaciones  VARCHAR(200) NULL,
  PRIMARY KEY (id_inscripcion),
  UNIQUE KEY uq_inscripcion (id_estudiante, id_materia, anio_cursada, condicion),
  CONSTRAINT fk_ins_estudiante FOREIGN KEY (id_estudiante) REFERENCES estudiante (id_estudiante) ON DELETE CASCADE,
  CONSTRAINT fk_ins_materia    FOREIGN KEY (id_materia)    REFERENCES materia (id_materia)
) ENGINE=InnoDB;

CREATE TABLE cursada (
  id_cursada    INT NOT NULL AUTO_INCREMENT,
  id_estudiante INT NOT NULL,
  id_materia    INT NOT NULL,
  anio_cursada  SMALLINT NOT NULL,
  asistencia    DECIMAL(5,2) NULL COMMENT '% de asistencia',
  tp            DECIMAL(5,2) NULL COMMENT '% de trabajos prácticos',
  caracter      ENUM('Regular','Libre','Promocion') NULL COMMENT 'NULL = todavía cursando',
  promedio      DECIMAL(4,2) NULL,
  PRIMARY KEY (id_cursada),
  UNIQUE KEY uq_cursada (id_estudiante, id_materia, anio_cursada),
  CONSTRAINT fk_cur_estudiante FOREIGN KEY (id_estudiante) REFERENCES estudiante (id_estudiante) ON DELETE CASCADE,
  CONSTRAINT fk_cur_materia    FOREIGN KEY (id_materia)    REFERENCES materia (id_materia),
  CONSTRAINT chk_cur_asistencia CHECK (asistencia IS NULL OR asistencia BETWEEN 0 AND 100),
  CONSTRAINT chk_cur_tp         CHECK (tp IS NULL OR tp BETWEEN 0 AND 100),
  CONSTRAINT chk_cur_promedio   CHECK (promedio IS NULL OR promedio BETWEEN 0 AND 10)
) ENGINE=InnoDB;

CREATE TABLE examen (                        
  id_examen     INT NOT NULL AUTO_INCREMENT,
  id_estudiante INT NOT NULL,
  id_materia    INT NOT NULL,
  id_submateria INT NULL COMMENT 'Solo en materias compuestas (cada deporte tiene su nota, libro y folio)',
  sub_key       INT AS (IFNULL(id_submateria, 0)) STORED,
  tipo          ENUM('Regular','Libre','Promocion') NOT NULL,
  intento       TINYINT NOT NULL DEFAULT 1 COMMENT '1 a 3 como Regular y 1 a 3 como Libre',
  fecha         DATE NOT NULL,
  nota          DECIMAL(4,2) NOT NULL,
  libro         VARCHAR(30) NOT NULL,
  folio         VARCHAR(30) NOT NULL,
  observacion   VARCHAR(200) NULL,
  PRIMARY KEY (id_examen),
  UNIQUE KEY uq_examen_intento (id_estudiante, id_materia, sub_key, tipo, intento),
  KEY idx_examen_materia (id_materia),
  CONSTRAINT fk_exa_estudiante FOREIGN KEY (id_estudiante) REFERENCES estudiante (id_estudiante) ON DELETE CASCADE,
  CONSTRAINT fk_exa_materia    FOREIGN KEY (id_materia)    REFERENCES materia (id_materia),
  CONSTRAINT fk_exa_submateria FOREIGN KEY (id_submateria) REFERENCES submateria (id_submateria),
  CONSTRAINT chk_exa_nota   CHECK (nota BETWEEN 0 AND 10),
  CONSTRAINT chk_exa_intento CHECK (intento BETWEEN 1 AND 3)
) ENGINE=InnoDB;


-- 5. Tramites

CREATE TABLE tramite (
  id_tramite       INT NOT NULL AUTO_INCREMENT,
  id_estudiante    INT NOT NULL,
  tipo             ENUM('Pase','Asimilacion','Equivalencia','Nota de aprobacion') NOT NULL,
  fecha_solicitud  DATE NOT NULL,
  fecha_limite     DATE NULL COMMENT 'Plazo para resolver (60 días desde abril, según la vicerrectora)',
  estado           ENUM('En curso','En revision','Observado','Resuelto','Rechazado') NOT NULL DEFAULT 'En curso',
  nro_resolucion   VARCHAR(50) NULL,
  fecha_resolucion DATE NULL,
  detalle          TEXT NULL,
  id_usuario       INT NULL COMMENT 'Quién lo cargó',
  PRIMARY KEY (id_tramite),
  KEY idx_tramite_estudiante (id_estudiante),
  KEY idx_tramite_estado (estado, fecha_limite),
  CONSTRAINT fk_tra_estudiante FOREIGN KEY (id_estudiante) REFERENCES estudiante (id_estudiante) ON DELETE CASCADE,
  CONSTRAINT fk_tra_usuario    FOREIGN KEY (id_usuario)    REFERENCES usuario (id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE tramite_materia (               -- materias reconocidas por una equivalencia o asimilación
  id_tramite INT NOT NULL,
  id_materia INT NOT NULL,
  PRIMARY KEY (id_tramite, id_materia),
  CONSTRAINT fk_tm_tramite FOREIGN KEY (id_tramite) REFERENCES tramite (id_tramite) ON DELETE CASCADE,
  CONSTRAINT fk_tm_materia FOREIGN KEY (id_materia) REFERENCES materia (id_materia)
) ENGINE=InnoDB;


-- 6. Historia de cambios
CREATE TABLE auditoria (
  id_auditoria  INT NOT NULL AUTO_INCREMENT,
  fecha         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  id_usuario    INT NOT NULL,
  id_estudiante INT NULL,
  accion        VARCHAR(100) NOT NULL,
  detalle       TEXT NULL,
  PRIMARY KEY (id_auditoria),
  KEY idx_aud_estudiante (id_estudiante, fecha),
  KEY idx_aud_usuario (id_usuario),
  CONSTRAINT fk_aud_usuario    FOREIGN KEY (id_usuario)    REFERENCES usuario (id_usuario),
  CONSTRAINT fk_aud_estudiante FOREIGN KEY (id_estudiante) REFERENCES estudiante (id_estudiante) ON DELETE SET NULL
) ENGINE=InnoDB;


-- 8. DATOS INICIALES

INSERT INTO carrera (id_carrera, nombre, turno, resolucion) VALUES
(1, 'Profesorado de Educación Física', 'Mañana', 'Res. 2286-E-20'),
(2, 'Profesorado de Educación Física con Orientación en Tiempo Libre y Recreación', 'Tarde', 'Res. 2281-E-20');

INSERT INTO tipo_documento (id_tipo, nombre, obligatorio, vence_anual, orden) VALUES
(1, 'Fotocopia de DNI', 1, 0, 1),
(2, 'Partida de nacimiento', 1, 0, 2),
(3, 'Título secundario autenticado o constancia de título en trámite', 1, 0, 3),
(4, 'Carnet sanitario', 1, 0, 4),
(5, 'Planilla prontuarial', 1, 0, 5),
(6, 'CUIL', 1, 0, 6),
(7, 'Fotos 4x4 (2)', 1, 0, 7),
(8, 'Carpeta de 3 solapas', 1, 0, 8),
(9, 'Apto físico: espirometría', 1, 1, 9),
(10, 'Apto físico: electrocardiograma / ergometría', 1, 1, 10),
(11, 'Apto físico: análisis clínicos', 1, 1, 11),
(12, 'Seguro SEMED', 1, 1, 12);


INSERT INTO materia (id_materia, id_carrera, codigo, nombre, anio, orden, periodo, regimen, permite_libre) VALUES
(1, 1, '01', 'Pedagogía', 1, 1, 'Anual', 'Promocion o examen final', 1),
(2, 1, '02', 'Psicología Educacional', 1, 2, 'Anual', 'Promocion o examen final', 1),
(3, 1, '03', 'Alfabetización Académica', 1, 3, '1C', 'Promocion o examen final', 0),
(4, 1, '04', 'Didáctica General', 1, 4, 'Anual', 'Promocion o examen final', 0),
(5, 1, '11', 'Anatomía y Fisiología', 1, 5, 'Anual', 'Promocion o examen final', 0),
(6, 1, '12', 'Prácticas Ludomotrices y su Enseñanza', 1, 6, 'Anual', 'Promocion o examen final', 0),
(7, 1, '13', 'Prácticas Gimnásticas y su Enseñanza', 1, 7, 'Anual', 'Promocion o examen final', 0),
(8, 1, '14', 'Prácticas Atléticas y su Enseñanza', 1, 8, 'Anual', 'Promocion o examen final', 0),
(9, 1, '30', 'Práctica I', 1, 9, 'Anual', 'Promocion', 0),
(10, 1, '05', 'Filosofía', 2, 1, 'Anual', 'Promocion o examen final', 1),
(11, 1, '06', 'Historia de las Políticas Educativas en la Argentina', 2, 2, 'Anual', 'Promocion o examen final', 1),
(12, 1, '15', 'Sujeto de la Educación', 2, 3, 'Anual', 'Examen final', 0),
(13, 1, '16', 'Prácticas Acuáticas y su Enseñanza', 2, 4, '1C', 'Promocion o examen final', 0),
(14, 1, '17', 'Prácticas Motrices Expresivas y su Enseñanza', 2, 5, '1C', 'Promocion o examen final', 0),
(15, 1, '18', 'Prácticas Deportivas I y su Enseñanza', 2, 6, 'Anual', 'Promocion o examen final', 0),
(16, 1, '19', 'Prácticas Deportivas II y su Enseñanza', 2, 7, 'Anual', 'Promocion o examen final', 0),
(17, 1, '20', 'Didáctica de la Educación Física', 2, 8, 'Anual', 'Examen final', 0),
(18, 1, '31', 'Práctica II', 2, 9, 'Anual', 'Promocion', 0),
(19, 1, '07', 'Educación Sexual Integral', 3, 1, '1C', 'Promocion o examen final', 0),
(20, 1, '08', 'Integración de las TIC en la Enseñanza', 3, 2, '1C', 'Promocion o examen final', 0),
(21, 1, '09', 'Sociología de la Educación', 3, 3, 'Anual', 'Promocion o examen final', 0),
(22, 1, '21', 'Prácticas Deportivas III y su Enseñanza', 3, 4, 'Anual', 'Promocion o examen final', 0),
(23, 1, '22', 'Prácticas Deportivas IV y su Enseñanza', 3, 5, 'Anual', 'Promocion o examen final', 0),
(24, 1, '23', 'Práctica en la Naturaleza y al Aire Libre y su Enseñanza', 3, 6, 'Anual', 'Promocion o examen final', 0),
(25, 1, '24', 'Entrenamiento para la Actividad Física', 3, 7, 'Anual', 'Examen final', 0),
(26, 1, '25', 'Historia y Epistemología de la Educación Física', 3, 8, 'Anual', 'Promocion o examen final', 0),
(27, 1, '32', 'Práctica III', 3, 9, 'Anual', 'Promocion', 0),
(28, 1, '10', 'Ética Profesional Docente', 4, 1, 'Anual', 'Promocion o examen final', 0),
(29, 1, '26', 'Educación Física Inclusiva', 4, 2, 'Anual', 'Promocion o examen final', 0),
(30, 1, '27', 'Prácticas de Recreación y Tiempo Libre y su Enseñanza', 4, 3, 'Anual', 'Promocion o examen final', 0),
(31, 1, '28', 'Educación Física y Salud', 4, 4, 'Anual', 'Promocion o examen final', 0),
(32, 1, '29', 'Gestión de Espacios y Organizaciones Deportivas', 4, 5, 'Anual', 'Promocion o examen final', 0),
(33, 1, '34', 'Unidad de Definición Institucional', 4, 6, 'Anual', 'Promocion', 0),
(34, 1, '33', 'Residencia Pedagógica', 4, 7, 'Anual', 'Promocion', 0),
(35, 2, '01', 'Pedagogía', 1, 1, 'Anual', 'Promocion o examen final', 1),
(36, 2, '02', 'Psicología Educacional', 1, 2, 'Anual', 'Promocion o examen final', 1),
(37, 2, '03', 'Alfabetización Académica', 1, 3, '1C', 'Promocion o examen final', 0),
(38, 2, '04', 'Didáctica General', 1, 4, 'Anual', 'Promocion o examen final', 0),
(39, 2, '11', 'Anatomía y Fisiología', 1, 5, 'Anual', 'Promocion o examen final', 0),
(40, 2, '12', 'Prácticas Ludomotrices y su Enseñanza', 1, 6, 'Anual', 'Promocion o examen final', 0),
(41, 2, '13', 'Prácticas Gimnásticas y su Enseñanza', 1, 7, 'Anual', 'Promocion o examen final', 0),
(42, 2, '14', 'Prácticas Atléticas y su Enseñanza', 1, 8, 'Anual', 'Promocion o examen final', 0),
(43, 2, '15', 'Prácticas de Recreación y Tiempo Libre y su Enseñanza', 1, 9, 'Anual', 'Promocion o examen final', 0),
(44, 2, '32', 'Práctica I', 1, 10, 'Anual', 'Promocion', 0),
(45, 2, '05', 'Filosofía', 2, 1, 'Anual', 'Promocion o examen final', 1),
(46, 2, '06', 'Historia de las Políticas Educativas en la Argentina', 2, 2, 'Anual', 'Promocion o examen final', 1),
(47, 2, '16', 'Sujeto de la Educación', 2, 3, 'Anual', 'Examen final', 0),
(48, 2, '17', 'Prácticas Acuáticas y su Enseñanza', 2, 4, '1C', 'Promocion o examen final', 0),
(49, 2, '18', 'Prácticas Motrices Expresivas y su Enseñanza', 2, 5, '1C', 'Promocion o examen final', 0),
(50, 2, '19', 'Prácticas Deportivas I y su Enseñanza', 2, 6, 'Anual', 'Promocion o examen final', 0),
(51, 2, '20', 'Prácticas Deportivas II y su Enseñanza', 2, 7, 'Anual', 'Promocion o examen final', 0),
(52, 2, '21', 'Didáctica de la Educación Física', 2, 8, 'Anual', 'Examen final', 0),
(53, 2, '22', 'Didáctica de las Prácticas Recreativas y el Tiempo Libre', 2, 9, 'Anual', 'Promocion o examen final', 0),
(54, 2, '33', 'Práctica II', 2, 10, 'Anual', 'Promocion', 0),
(55, 2, '07', 'Educación Sexual Integral', 3, 1, '1C', 'Promocion o examen final', 0),
(56, 2, '08', 'Integración de las TIC en la Enseñanza', 3, 2, '1C', 'Promocion o examen final', 0),
(57, 2, '09', 'Sociología de la Educación', 3, 3, 'Anual', 'Promocion o examen final', 0),
(58, 2, '23', 'Prácticas Deportivas III y su Enseñanza', 3, 4, 'Anual', 'Promocion o examen final', 0),
(59, 2, '24', 'Prácticas Deportivas IV y su Enseñanza', 3, 5, 'Anual', 'Promocion o examen final', 0),
(60, 2, '25', 'Práctica en la Naturaleza y al Aire Libre y su Enseñanza', 3, 6, 'Anual', 'Promocion o examen final', 0),
(61, 2, '26', 'Entrenamiento para la Actividad Física', 3, 7, 'Anual', 'Examen final', 0),
(62, 2, '27', 'Historia y Epistemología de la Educación Física', 3, 8, 'Anual', 'Promocion o examen final', 0),
(63, 2, '34', 'Práctica III', 3, 9, 'Anual', 'Promocion', 0),
(64, 2, '10', 'Ética Profesional Docente', 4, 1, 'Anual', 'Promocion o examen final', 0),
(65, 2, '28', 'Educación Física Inclusiva', 4, 2, 'Anual', 'Promocion o examen final', 0),
(66, 2, '29', 'Proyectos de Recreación y Tiempo Libre y su Enseñanza', 4, 3, 'Anual', 'Promocion o examen final', 0),
(67, 2, '30', 'Educación Física y Salud', 4, 4, 'Anual', 'Promocion o examen final', 0),
(68, 2, '31', 'Gestión de Espacios y Organizaciones Deportivas', 4, 5, 'Anual', 'Promocion o examen final', 0),
(69, 2, '36', 'Unidad de Definición Institucional', 4, 6, 'Anual', 'Promocion', 0),
(70, 2, '35', 'Residencia Pedagógica', 4, 7, 'Anual', 'Promocion', 0);

INSERT INTO submateria (id_materia, nombre, orden) VALUES
(16, 'Handbol', 1),
(16, 'Básquet', 2),
(22, 'Hockey', 1),
(22, 'Rugby', 2),
(22, 'Fútbol', 3),
(23, 'Gimnasia', 1),
(23, 'Atletismo', 2),
(9, 'Práctica en terreno', 1),
(9, 'Taller Integrador I', 2),
(18, 'Práctica en terreno', 1),
(18, 'Taller Integrador II', 2),
(27, 'Práctica en terreno', 1),
(27, 'Taller Integrador III', 2),
(51, 'Handbol', 1),
(51, 'Básquet', 2),
(58, 'Hockey', 1),
(58, 'Rugby', 2),
(58, 'Fútbol', 3),
(59, 'Gimnasia', 1),
(59, 'Atletismo', 2),
(44, 'Práctica en terreno', 1),
(44, 'Taller Integrador I', 2),
(54, 'Práctica en terreno', 1),
(54, 'Taller Integrador II', 2),
(63, 'Práctica en terreno', 1),
(63, 'Taller Integrador III', 2);

-- Correlatividades
INSERT INTO correlatividad (id_materia, id_requerida, tipo_requisito, condicion) VALUES
  (10, 1, 'Cursar', 'Regular'), (10, 1, 'Rendir', 'Aprobada'),
  (12, 2, 'Cursar', 'Regular'), (12, 2, 'Rendir', 'Aprobada'), (12, 5, 'Cursar', 'Regular'), (12, 5, 'Rendir', 'Aprobada'),
  (13, 4, 'Cursar', 'Regular'), (13, 4, 'Rendir', 'Aprobada'), (13, 6, 'Cursar', 'Regular'), (13, 6, 'Rendir', 'Aprobada'),
  (14, 4, 'Cursar', 'Regular'), (14, 4, 'Rendir', 'Aprobada'), (14, 6, 'Cursar', 'Regular'), (14, 6, 'Rendir', 'Aprobada'),
  (15, 4, 'Cursar', 'Regular'), (15, 4, 'Rendir', 'Aprobada'), (15, 6, 'Cursar', 'Regular'), (15, 6, 'Rendir', 'Aprobada'),
  (16, 4, 'Cursar', 'Regular'), (16, 4, 'Rendir', 'Aprobada'), (16, 6, 'Cursar', 'Regular'), (16, 6, 'Rendir', 'Aprobada'),
  (17, 1, 'Cursar', 'Regular'), (17, 1, 'Rendir', 'Aprobada'), (17, 2, 'Cursar', 'Regular'), (17, 2, 'Rendir', 'Aprobada'), (17, 4, 'Cursar', 'Regular'), (17, 4, 'Rendir', 'Aprobada'),
  (18, 9, 'Cursar', 'Aprobada'), (18, 9, 'Rendir', 'Aprobada'),
  (20, 4, 'Cursar', 'Aprobada'), (20, 4, 'Rendir', 'Aprobada'), (20, 17, 'Cursar', 'Regular'), (20, 17, 'Rendir', 'Aprobada'),
  (21, 1, 'Cursar', 'Aprobada'), (21, 1, 'Rendir', 'Aprobada'), (21, 11, 'Cursar', 'Regular'), (21, 11, 'Rendir', 'Aprobada'),
  (22, 7, 'Cursar', 'Aprobada'), (22, 7, 'Rendir', 'Aprobada'), (22, 8, 'Cursar', 'Aprobada'), (22, 8, 'Rendir', 'Aprobada'), (22, 15, 'Cursar', 'Regular'), (22, 15, 'Rendir', 'Aprobada'), (22, 16, 'Cursar', 'Regular'), (22, 16, 'Rendir', 'Aprobada'), (22, 17, 'Cursar', 'Regular'), (22, 17, 'Rendir', 'Aprobada'),
  (23, 7, 'Cursar', 'Aprobada'), (23, 7, 'Rendir', 'Aprobada'), (23, 8, 'Cursar', 'Aprobada'), (23, 8, 'Rendir', 'Aprobada'), (23, 15, 'Cursar', 'Regular'), (23, 15, 'Rendir', 'Aprobada'), (23, 16, 'Cursar', 'Regular'), (23, 16, 'Rendir', 'Aprobada'), (23, 17, 'Cursar', 'Regular'), (23, 17, 'Rendir', 'Aprobada'),
  (24, 6, 'Cursar', 'Aprobada'), (24, 6, 'Rendir', 'Aprobada'), (24, 12, 'Cursar', 'Aprobada'), (24, 12, 'Rendir', 'Aprobada'), (24, 13, 'Cursar', 'Regular'), (24, 13, 'Rendir', 'Aprobada'), (24, 14, 'Cursar', 'Regular'), (24, 14, 'Rendir', 'Aprobada'),
  (25, 5, 'Cursar', 'Aprobada'), (25, 5, 'Rendir', 'Aprobada'), (25, 7, 'Cursar', 'Aprobada'), (25, 7, 'Rendir', 'Aprobada'), (25, 8, 'Cursar', 'Aprobada'), (25, 8, 'Rendir', 'Aprobada'), (25, 15, 'Cursar', 'Regular'), (25, 15, 'Rendir', 'Aprobada'), (25, 16, 'Cursar', 'Regular'), (25, 16, 'Rendir', 'Aprobada'),
  (26, 10, 'Cursar', 'Regular'), (26, 10, 'Rendir', 'Aprobada'), (26, 11, 'Cursar', 'Regular'), (26, 11, 'Rendir', 'Aprobada'),
  (27, 6, 'Cursar', 'Aprobada'), (27, 6, 'Rendir', 'Aprobada'), (27, 7, 'Cursar', 'Aprobada'), (27, 7, 'Rendir', 'Aprobada'), (27, 8, 'Cursar', 'Aprobada'), (27, 8, 'Rendir', 'Aprobada'), (27, 13, 'Cursar', 'Regular'), (27, 13, 'Rendir', 'Aprobada'), (27, 14, 'Cursar', 'Regular'), (27, 14, 'Rendir', 'Aprobada'), (27, 15, 'Cursar', 'Regular'), (27, 15, 'Rendir', 'Aprobada'), (27, 16, 'Cursar', 'Regular'), (27, 16, 'Rendir', 'Aprobada'), (27, 17, 'Cursar', 'Aprobada'), (27, 17, 'Rendir', 'Aprobada'), (27, 18, 'Cursar', 'Aprobada'), (27, 18, 'Rendir', 'Aprobada'),
  (28, 10, 'Cursar', 'Aprobada'), (28, 10, 'Rendir', 'Aprobada'),
  (29, 5, 'Cursar', 'Aprobada'), (29, 5, 'Rendir', 'Aprobada'), (29, 6, 'Cursar', 'Aprobada'), (29, 6, 'Rendir', 'Aprobada'), (29, 14, 'Cursar', 'Aprobada'), (29, 14, 'Rendir', 'Aprobada'), (29, 19, 'Cursar', 'Regular'), (29, 19, 'Rendir', 'Aprobada'),
  (30, 6, 'Cursar', 'Aprobada'), (30, 6, 'Rendir', 'Aprobada'), (30, 24, 'Cursar', 'Regular'), (30, 24, 'Rendir', 'Aprobada'),
  (31, 25, 'Cursar', 'Regular'), (31, 25, 'Rendir', 'Aprobada'),
  (32, 26, 'Cursar', 'Regular'), (32, 26, 'Rendir', 'Aprobada'),
  (33, 1, 'Cursar', 'Aprobada'), (33, 1, 'Rendir', 'Aprobada'), (33, 2, 'Cursar', 'Aprobada'), (33, 2, 'Rendir', 'Aprobada'), (33, 3, 'Cursar', 'Aprobada'), (33, 3, 'Rendir', 'Aprobada'), (33, 4, 'Cursar', 'Aprobada'), (33, 4, 'Rendir', 'Aprobada'), (33, 5, 'Cursar', 'Aprobada'), (33, 5, 'Rendir', 'Aprobada'), (33, 6, 'Cursar', 'Aprobada'), (33, 6, 'Rendir', 'Aprobada'), (33, 7, 'Cursar', 'Aprobada'), (33, 7, 'Rendir', 'Aprobada'), (33, 8, 'Cursar', 'Aprobada'), (33, 8, 'Rendir', 'Aprobada'), (33, 9, 'Cursar', 'Aprobada'), (33, 9, 'Rendir', 'Aprobada'),
  (34, 1, 'Cursar', 'Aprobada'), (34, 1, 'Rendir', 'Aprobada'), (34, 2, 'Cursar', 'Aprobada'), (34, 2, 'Rendir', 'Aprobada'), (34, 3, 'Cursar', 'Aprobada'), (34, 3, 'Rendir', 'Aprobada'), (34, 4, 'Cursar', 'Aprobada'), (34, 4, 'Rendir', 'Aprobada'), (34, 5, 'Cursar', 'Aprobada'), (34, 5, 'Rendir', 'Aprobada'), (34, 6, 'Cursar', 'Aprobada'), (34, 6, 'Rendir', 'Aprobada'), (34, 7, 'Cursar', 'Aprobada'), (34, 7, 'Rendir', 'Aprobada'), (34, 8, 'Cursar', 'Aprobada'), (34, 8, 'Rendir', 'Aprobada'), (34, 9, 'Cursar', 'Aprobada'), (34, 9, 'Rendir', 'Aprobada'), (34, 10, 'Cursar', 'Aprobada'), (34, 10, 'Rendir', 'Aprobada'), (34, 11, 'Cursar', 'Aprobada'), (34, 11, 'Rendir', 'Aprobada'), (34, 12, 'Cursar', 'Aprobada'), (34, 12, 'Rendir', 'Aprobada'), (34, 13, 'Cursar', 'Aprobada'), (34, 13, 'Rendir', 'Aprobada'), (34, 14, 'Cursar', 'Aprobada'), (34, 14, 'Rendir', 'Aprobada'), (34, 15, 'Cursar', 'Aprobada'), (34, 15, 'Rendir', 'Aprobada'), (34, 16, 'Cursar', 'Aprobada'), (34, 16, 'Rendir', 'Aprobada'), (34, 17, 'Cursar', 'Aprobada'), (34, 17, 'Rendir', 'Aprobada'), (34, 18, 'Cursar', 'Aprobada'), (34, 18, 'Rendir', 'Aprobada'), (34, 19, 'Cursar', 'Regular'), (34, 19, 'Rendir', 'Aprobada'), (34, 20, 'Cursar', 'Regular'), (34, 20, 'Rendir', 'Aprobada'), (34, 21, 'Cursar', 'Regular'), (34, 21, 'Rendir', 'Aprobada'), (34, 22, 'Cursar', 'Regular'), (34, 22, 'Rendir', 'Aprobada'), (34, 23, 'Cursar', 'Regular'), (34, 23, 'Rendir', 'Aprobada'), (34, 24, 'Cursar', 'Regular'), (34, 24, 'Rendir', 'Aprobada'), (34, 25, 'Cursar', 'Regular'), (34, 25, 'Rendir', 'Aprobada'), (34, 26, 'Cursar', 'Regular'), (34, 26, 'Rendir', 'Aprobada'), (34, 27, 'Cursar', 'Aprobada'), (34, 27, 'Rendir', 'Aprobada'),
  (45, 35, 'Cursar', 'Regular'), (45, 35, 'Rendir', 'Aprobada'),
  (47, 36, 'Cursar', 'Regular'), (47, 36, 'Rendir', 'Aprobada'), (47, 39, 'Cursar', 'Regular'), (47, 39, 'Rendir', 'Aprobada'),
  (48, 38, 'Cursar', 'Regular'), (48, 38, 'Rendir', 'Aprobada'), (48, 40, 'Cursar', 'Regular'), (48, 40, 'Rendir', 'Aprobada'),
  (49, 38, 'Cursar', 'Regular'), (49, 38, 'Rendir', 'Aprobada'), (49, 40, 'Cursar', 'Regular'), (49, 40, 'Rendir', 'Aprobada'),
  (50, 38, 'Cursar', 'Regular'), (50, 38, 'Rendir', 'Aprobada'), (50, 40, 'Cursar', 'Regular'), (50, 40, 'Rendir', 'Aprobada'),
  (51, 38, 'Cursar', 'Regular'), (51, 38, 'Rendir', 'Aprobada'), (51, 40, 'Cursar', 'Regular'), (51, 40, 'Rendir', 'Aprobada'),
  (52, 35, 'Cursar', 'Regular'), (52, 35, 'Rendir', 'Aprobada'), (52, 36, 'Cursar', 'Regular'), (52, 36, 'Rendir', 'Aprobada'), (52, 38, 'Cursar', 'Regular'), (52, 38, 'Rendir', 'Aprobada'),
  (53, 38, 'Cursar', 'Regular'), (53, 38, 'Rendir', 'Aprobada'), (53, 43, 'Cursar', 'Regular'), (53, 43, 'Rendir', 'Aprobada'),
  (54, 44, 'Cursar', 'Aprobada'), (54, 44, 'Rendir', 'Aprobada'),
  (56, 38, 'Cursar', 'Aprobada'), (56, 38, 'Rendir', 'Aprobada'),
  (57, 35, 'Cursar', 'Aprobada'), (57, 35, 'Rendir', 'Aprobada'), (57, 46, 'Cursar', 'Regular'), (57, 46, 'Rendir', 'Aprobada'),
  (58, 41, 'Cursar', 'Aprobada'), (58, 41, 'Rendir', 'Aprobada'), (58, 42, 'Cursar', 'Aprobada'), (58, 42, 'Rendir', 'Aprobada'), (58, 49, 'Cursar', 'Regular'), (58, 49, 'Rendir', 'Aprobada'), (58, 50, 'Cursar', 'Regular'), (58, 50, 'Rendir', 'Aprobada'), (58, 51, 'Cursar', 'Regular'), (58, 51, 'Rendir', 'Aprobada'),
  (59, 41, 'Cursar', 'Aprobada'), (59, 41, 'Rendir', 'Aprobada'), (59, 42, 'Cursar', 'Aprobada'), (59, 42, 'Rendir', 'Aprobada'), (59, 49, 'Cursar', 'Regular'), (59, 49, 'Rendir', 'Aprobada'), (59, 50, 'Cursar', 'Regular'), (59, 50, 'Rendir', 'Aprobada'), (59, 51, 'Cursar', 'Regular'), (59, 51, 'Rendir', 'Aprobada'),
  (60, 40, 'Cursar', 'Aprobada'), (60, 40, 'Rendir', 'Aprobada'), (60, 43, 'Cursar', 'Aprobada'), (60, 43, 'Rendir', 'Aprobada'), (60, 47, 'Cursar', 'Regular'), (60, 48, 'Cursar', 'Regular'), (60, 48, 'Rendir', 'Aprobada'), (60, 53, 'Cursar', 'Regular'),
  (61, 39, 'Cursar', 'Aprobada'), (61, 39, 'Rendir', 'Aprobada'), (61, 41, 'Cursar', 'Aprobada'), (61, 41, 'Rendir', 'Aprobada'), (61, 42, 'Cursar', 'Aprobada'), (61, 42, 'Rendir', 'Aprobada'), (61, 49, 'Cursar', 'Regular'), (61, 49, 'Rendir', 'Aprobada'), (61, 50, 'Cursar', 'Regular'), (61, 50, 'Rendir', 'Aprobada'),
  (62, 45, 'Cursar', 'Regular'), (62, 45, 'Rendir', 'Aprobada'), (62, 46, 'Cursar', 'Regular'), (62, 46, 'Rendir', 'Aprobada'),
  (63, 40, 'Cursar', 'Aprobada'), (63, 40, 'Rendir', 'Aprobada'), (63, 41, 'Cursar', 'Aprobada'), (63, 41, 'Rendir', 'Aprobada'), (63, 42, 'Cursar', 'Aprobada'), (63, 42, 'Rendir', 'Aprobada'), (63, 47, 'Cursar', 'Regular'), (63, 47, 'Rendir', 'Aprobada'), (63, 48, 'Cursar', 'Regular'), (63, 48, 'Rendir', 'Aprobada'), (63, 49, 'Cursar', 'Regular'), (63, 49, 'Rendir', 'Aprobada'), (63, 50, 'Cursar', 'Regular'), (63, 50, 'Rendir', 'Aprobada'), (63, 51, 'Cursar', 'Aprobada'), (63, 51, 'Rendir', 'Aprobada'), (63, 54, 'Cursar', 'Aprobada'), (63, 54, 'Rendir', 'Aprobada'),
  (64, 45, 'Cursar', 'Aprobada'), (64, 45, 'Rendir', 'Aprobada'),
  (65, 39, 'Cursar', 'Aprobada'), (65, 39, 'Rendir', 'Aprobada'), (65, 40, 'Cursar', 'Aprobada'), (65, 40, 'Rendir', 'Aprobada'), (65, 48, 'Cursar', 'Aprobada'), (65, 48, 'Rendir', 'Aprobada'), (65, 55, 'Cursar', 'Regular'), (65, 55, 'Rendir', 'Aprobada'),
  (66, 40, 'Cursar', 'Aprobada'), (66, 40, 'Rendir', 'Aprobada'), (66, 58, 'Cursar', 'Regular'), (66, 58, 'Rendir', 'Aprobada'),
  (67, 59, 'Cursar', 'Regular'), (67, 59, 'Rendir', 'Aprobada'),
  (68, 60, 'Cursar', 'Regular'), (68, 60, 'Rendir', 'Aprobada'),
  (69, 35, 'Cursar', 'Aprobada'), (69, 35, 'Rendir', 'Aprobada'), (69, 36, 'Cursar', 'Aprobada'), (69, 36, 'Rendir', 'Aprobada'), (69, 37, 'Cursar', 'Aprobada'), (69, 37, 'Rendir', 'Aprobada'), (69, 38, 'Cursar', 'Aprobada'), (69, 38, 'Rendir', 'Aprobada'), (69, 39, 'Cursar', 'Aprobada'), (69, 39, 'Rendir', 'Aprobada'), (69, 40, 'Cursar', 'Aprobada'), (69, 40, 'Rendir', 'Aprobada'), (69, 41, 'Cursar', 'Aprobada'), (69, 41, 'Rendir', 'Aprobada'), (69, 42, 'Cursar', 'Aprobada'), (69, 42, 'Rendir', 'Aprobada'), (69, 43, 'Cursar', 'Aprobada'), (69, 43, 'Rendir', 'Aprobada'), (69, 44, 'Cursar', 'Aprobada'), (69, 44, 'Rendir', 'Aprobada'),
  (70, 35, 'Cursar', 'Aprobada'), (70, 35, 'Rendir', 'Aprobada'), (70, 36, 'Cursar', 'Aprobada'), (70, 36, 'Rendir', 'Aprobada'), (70, 37, 'Cursar', 'Aprobada'), (70, 37, 'Rendir', 'Aprobada'), (70, 38, 'Cursar', 'Aprobada'), (70, 38, 'Rendir', 'Aprobada'), (70, 39, 'Cursar', 'Aprobada'), (70, 39, 'Rendir', 'Aprobada'), (70, 40, 'Cursar', 'Aprobada'), (70, 40, 'Rendir', 'Aprobada'), (70, 41, 'Cursar', 'Aprobada'), (70, 41, 'Rendir', 'Aprobada'), (70, 42, 'Cursar', 'Aprobada'), (70, 42, 'Rendir', 'Aprobada'), (70, 43, 'Cursar', 'Aprobada'), (70, 43, 'Rendir', 'Aprobada'), (70, 44, 'Cursar', 'Aprobada'), (70, 44, 'Rendir', 'Aprobada'), (70, 45, 'Cursar', 'Aprobada'), (70, 45, 'Rendir', 'Aprobada'), (70, 46, 'Cursar', 'Aprobada'), (70, 46, 'Rendir', 'Aprobada'), (70, 47, 'Cursar', 'Aprobada'), (70, 47, 'Rendir', 'Aprobada'), (70, 48, 'Cursar', 'Aprobada'), (70, 48, 'Rendir', 'Aprobada'), (70, 49, 'Cursar', 'Aprobada'), (70, 49, 'Rendir', 'Aprobada'), (70, 50, 'Cursar', 'Aprobada'), (70, 50, 'Rendir', 'Aprobada'), (70, 51, 'Cursar', 'Aprobada'), (70, 51, 'Rendir', 'Aprobada'), (70, 52, 'Cursar', 'Aprobada'), (70, 52, 'Rendir', 'Aprobada'), (70, 53, 'Cursar', 'Aprobada'), (70, 53, 'Rendir', 'Aprobada'), (70, 54, 'Cursar', 'Aprobada'), (70, 54, 'Rendir', 'Aprobada'), (70, 55, 'Cursar', 'Regular'), (70, 55, 'Rendir', 'Aprobada'), (70, 56, 'Cursar', 'Regular'), (70, 56, 'Rendir', 'Aprobada'), (70, 57, 'Cursar', 'Regular'), (70, 57, 'Rendir', 'Aprobada'), (70, 58, 'Cursar', 'Regular'), (70, 58, 'Rendir', 'Aprobada'), (70, 59, 'Cursar', 'Regular'), (70, 59, 'Rendir', 'Aprobada'), (70, 60, 'Cursar', 'Regular'), (70, 60, 'Rendir', 'Aprobada'), (70, 61, 'Cursar', 'Regular'), (70, 61, 'Rendir', 'Aprobada'), (70, 62, 'Cursar', 'Regular'), (70, 62, 'Rendir', 'Aprobada'), (70, 63, 'Cursar', 'Aprobada'), (70, 63, 'Rendir', 'Aprobada');

-- Usuarios 
-- Preceptoras: modifican solo su turno y consultan todo. Coordinadora y Vicerrectora: solo consulta.
INSERT INTO usuario (id_usuario, nombre, usuario, clave, rol, id_carrera, activo) VALUES
(1, 'Administración',       'admin',            '$2y$10$4HiE0ppCUxUm.0hYcmbGNOnY9FeQE.HIF0NKxrCpxM927bo7U9OP6', 'Administradora', NULL, 1),
(2, 'Vicerrectoría',        'vicerrectora',     '$2y$10$4HiE0ppCUxUm.0hYcmbGNOnY9FeQE.HIF0NKxrCpxM927bo7U9OP6', 'Vicerrectora',   NULL, 1),
(3, 'Coordinación',         'coordinadora',     '$2y$10$4HiE0ppCUxUm.0hYcmbGNOnY9FeQE.HIF0NKxrCpxM927bo7U9OP6', 'Coordinadora',   NULL, 1),
(4, 'Preceptoría Mañana',   'preceptora_manana','$2y$10$4HiE0ppCUxUm.0hYcmbGNOnY9FeQE.HIF0NKxrCpxM927bo7U9OP6', 'Preceptora',     1,    1),
(5, 'Preceptoría Tarde',    'preceptora_tarde', '$2y$10$4HiE0ppCUxUm.0hYcmbGNOnY9FeQE.HIF0NKxrCpxM927bo7U9OP6', 'Preceptora',     2,    1);


-- 7. Vistas (las alertas y verificaciones se calculan, no se guardan)


-- Materias aprobadas: final aprobado (nota >= 4) o reconocida por equivalencia/asimilación resuelta.
-- En materias compuestas hace falta tener aprobadas TODAS las submaterias.
CREATE VIEW v_materia_aprobada AS
SELECT x.id_estudiante, x.id_materia
FROM examen x
WHERE x.id_submateria IS NULL AND x.nota >= 4
GROUP BY x.id_estudiante, x.id_materia
UNION
SELECT x.id_estudiante, x.id_materia
FROM examen x
WHERE x.id_submateria IS NOT NULL AND x.nota >= 4
GROUP BY x.id_estudiante, x.id_materia
HAVING COUNT(DISTINCT x.id_submateria) = (SELECT COUNT(*) FROM submateria s WHERE s.id_materia = x.id_materia)
UNION
SELECT t.id_estudiante, tm.id_materia
FROM tramite t JOIN tramite_materia tm ON tm.id_tramite = t.id_tramite
WHERE t.estado = 'Resuelto' AND t.tipo IN ('Equivalencia','Asimilacion');

-- Estado de cada materia de la carrera para cada estudiante.
-- Regularidad: 2 años
CREATE VIEW v_situacion_academica AS
SELECT e.id_estudiante, e.apellido, e.nombre, e.dni, e.id_carrera,
       m.id_materia, m.anio, m.orden, m.nombre AS materia,
       CASE
         WHEN EXISTS (SELECT 1 FROM v_materia_aprobada a
                      WHERE a.id_estudiante = e.id_estudiante AND a.id_materia = m.id_materia) THEN 'Aprobada'
         WHEN EXISTS (SELECT 1 FROM cursada c
                      WHERE c.id_estudiante = e.id_estudiante AND c.id_materia = m.id_materia
                        AND c.caracter IN ('Regular','Promocion')
                        AND c.anio_cursada + 2 >= YEAR(CURDATE())) THEN 'Regular'
         WHEN EXISTS (SELECT 1 FROM cursada c
                      WHERE c.id_estudiante = e.id_estudiante AND c.id_materia = m.id_materia
                        AND c.caracter IS NULL) THEN 'Cursando'
         WHEN EXISTS (SELECT 1 FROM cursada c
                      WHERE c.id_estudiante = e.id_estudiante AND c.id_materia = m.id_materia) THEN 'Libre'
         ELSE 'Pendiente'
       END AS estado,
       (SELECT COUNT(*) FROM examen x WHERE x.id_estudiante = e.id_estudiante
          AND x.id_materia = m.id_materia AND x.tipo = 'Regular' AND x.nota < 4) AS aplazos_regular,
       (SELECT COUNT(*) FROM examen x WHERE x.id_estudiante = e.id_estudiante
          AND x.id_materia = m.id_materia AND x.tipo = 'Libre' AND x.nota < 4)   AS aplazos_libre
FROM estudiante e
JOIN materia m ON m.id_carrera = e.id_carrera;


CREATE VIEW v_correlatividad_estado AS
SELECT s.id_estudiante, s.apellido, s.nombre, s.dni,
       co.id_materia, m.nombre AS materia, co.tipo_requisito, co.condicion,
       co.id_requerida, r.nombre AS materia_requerida, s.estado AS estado_requerida,
       CASE WHEN co.condicion = 'Aprobada' AND s.estado = 'Aprobada' THEN 1
            WHEN co.condicion = 'Regular'  AND s.estado IN ('Regular','Aprobada') THEN 1
            ELSE 0 END AS cumple
FROM v_situacion_academica s
JOIN correlatividad co ON co.id_requerida = s.id_materia
JOIN materia m ON m.id_materia = co.id_materia AND m.id_carrera = s.id_carrera
JOIN materia r ON r.id_materia = co.id_requerida;

-- Documentación obligatoria que falta (o que se venció: apto físico y seguro cada año).
CREATE VIEW v_documentacion_pendiente AS
SELECT e.id_estudiante, e.apellido, e.nombre, e.dni, e.id_carrera,
       t.id_tipo, t.nombre AS documento,
       CASE WHEN d.id_estudiante IS NOT NULL AND d.presentado = 1 THEN 'Vencido' ELSE 'Falta' END AS situacion
FROM estudiante e
JOIN tipo_documento t ON t.obligatorio = 1
LEFT JOIN documentacion_estudiante d ON d.id_estudiante = e.id_estudiante AND d.id_tipo = t.id_tipo
WHERE e.estado = 'Regular'
  AND ( d.id_estudiante IS NULL
        OR d.presentado = 0
        OR (t.vence_anual = 1 AND (d.anio_lectivo IS NULL OR d.anio_lectivo < YEAR(CURDATE()))) );


CREATE VIEW v_legajo AS
SELECT e.id_estudiante, e.apellido, e.nombre, e.dni, e.id_carrera,
       (SELECT COUNT(*) FROM v_documentacion_pendiente p WHERE p.id_estudiante = e.id_estudiante) AS pendientes,
       CASE WHEN (SELECT COUNT(*) FROM v_documentacion_pendiente p WHERE p.id_estudiante = e.id_estudiante) = 0
            THEN 'Legajo completo' ELSE 'Legajo incompleto' END AS legajo
FROM estudiante e;

-- Trámites abiertos con los días que quedan (negativo = plazo vencido).
CREATE VIEW v_tramites_pendientes AS
SELECT t.id_tramite, t.id_estudiante, e.apellido, e.nombre, e.dni, e.id_carrera,
       t.tipo, t.fecha_solicitud, t.fecha_limite, t.estado,
       DATEDIFF(t.fecha_limite, CURDATE()) AS dias_restantes
FROM tramite t JOIN estudiante e ON e.id_estudiante = t.id_estudiante
WHERE t.estado IN ('En curso','En revision','Observado');
