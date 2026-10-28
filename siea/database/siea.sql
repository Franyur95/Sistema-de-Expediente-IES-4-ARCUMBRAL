-- ============================================================================
-- S.I.E.A. — Sistema Integral de Expedientes Académicos
-- Instituto de Educación Superior N.º 4 "Raúl Scalabrini Ortiz" — Palpalá
-- Profesorado de Educación Física con orientación en Tiempo Libre y Recreación
-- Decreto-Resolución N° 13929-E-19
-- ----------------------------------------------------------------------------
-- Motor: MySQL 8 / MariaDB 10.4+
-- Charset: utf8mb4_general_ci
-- ============================================================================

CREATE DATABASE IF NOT EXISTS ies4_expedientes
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;

USE ies4_expedientes;

-- ----------------------------------------------------------------------------
-- 1. CARRERAS
-- ----------------------------------------------------------------------------
CREATE TABLE carreras (
  id_carrera   INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre       VARCHAR(150) NOT NULL,
  turno        ENUM('mañana','tarde') NOT NULL,
  sede         VARCHAR(100) NOT NULL DEFAULT 'Palpalá',
  resolucion   VARCHAR(100) NOT NULL,
  activa       TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (id_carrera)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------------------------------------------------------
-- 2. PLANES DE ESTUDIO
-- ----------------------------------------------------------------------------
CREATE TABLE planes (
  id_plan        INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_carrera     INT UNSIGNED NOT NULL,
  anio_vigencia  YEAR NOT NULL,
  resolucion     VARCHAR(100) NOT NULL,
  PRIMARY KEY (id_plan),
  UNIQUE KEY uq_plan (id_carrera, anio_vigencia),
  CONSTRAINT fk_planes_carrera FOREIGN KEY (id_carrera)
    REFERENCES carreras(id_carrera) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------------------------------------------------------
-- 3. MATERIAS
-- grupo_calificacion agrupa materias que comparten nota definitiva.
-- ----------------------------------------------------------------------------
CREATE TABLE materias (
  id_materia          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_plan             INT UNSIGNED NOT NULL,
  nombre              VARCHAR(150) NOT NULL,
  anio                TINYINT NOT NULL COMMENT '1 a 4',
  orden               SMALLINT NOT NULL DEFAULT 0,
  grupo_calificacion  VARCHAR(50) NULL,
  PRIMARY KEY (id_materia),
  KEY idx_materias_plan (id_plan),
  KEY idx_materias_grupo (id_plan, grupo_calificacion),
  CONSTRAINT fk_materias_plan FOREIGN KEY (id_plan)
    REFERENCES planes(id_plan) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_materias_anio CHECK (anio BETWEEN 1 AND 4)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------------------------------------------------------
-- 4. CORRELATIVIDADES
-- ----------------------------------------------------------------------------
CREATE TABLE correlatividades (
  id_materia    INT UNSIGNED NOT NULL,
  id_requerida  INT UNSIGNED NOT NULL,
  condicion     ENUM('regular','aprobada') NOT NULL,
  PRIMARY KEY (id_materia, id_requerida),
  CONSTRAINT fk_corr_materia   FOREIGN KEY (id_materia)
    REFERENCES materias(id_materia) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_corr_requerida FOREIGN KEY (id_requerida)
    REFERENCES materias(id_materia) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------------------------------------------------------
-- 5. ESTUDIANTES (un registro = un expediente)
-- ----------------------------------------------------------------------------
CREATE TABLE estudiantes (
  id_estudiante      INT UNSIGNED NOT NULL AUTO_INCREMENT,
  dni                VARCHAR(15) NOT NULL COMMENT 'DNI, L.E. o L.C.',
  apellido           VARCHAR(100) NOT NULL,
  nombre             VARCHAR(100) NOT NULL,
  fecha_nacimiento   DATE NOT NULL,
  lugar_nacimiento   VARCHAR(150) NULL,
  domicilio          VARCHAR(200) NULL,
  telefono           VARCHAR(50)  NULL,
  email              VARCHAR(120) NULL,
  titulo_ingreso     VARCHAR(150) NULL,
  tipo_titulo        VARCHAR(100) NULL,
  establecimiento    VARCHAR(150) NULL,
  anio_ingreso       YEAR NULL,
  observaciones      TEXT NULL,
  estado             ENUM('activo','libre','egresado','abandono','pase')
                     NOT NULL DEFAULT 'activo',
  id_carrera         INT UNSIGNED NOT NULL,
  created_at         DATETIME NULL,
  updated_at         DATETIME NULL,
  PRIMARY KEY (id_estudiante),
  UNIQUE KEY uq_estudiantes_dni (dni),
  KEY idx_estudiantes_apellido (apellido),
  KEY idx_estudiantes_dni (dni),
  CONSTRAINT fk_estudiantes_carrera FOREIGN KEY (id_carrera)
    REFERENCES carreras(id_carrera) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------------------------------------------------------
-- 6. TIPOS DE DOCUMENTO (checklist del expediente)
-- ----------------------------------------------------------------------------
CREATE TABLE tipos_documento (
  id_tipo      INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre       VARCHAR(100) NOT NULL,
  obligatorio  TINYINT(1) NOT NULL DEFAULT 1,
  vence        TINYINT(1) NOT NULL DEFAULT 0,
  orden        SMALLINT NOT NULL DEFAULT 0,
  PRIMARY KEY (id_tipo),
  UNIQUE KEY uq_tipos_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------------------------------------------------------
-- 7. DOCUMENTACIÓN DEL ESTUDIANTE
-- ----------------------------------------------------------------------------
CREATE TABLE documentacion_estudiante (
  id_estudiante      INT UNSIGNED NOT NULL,
  id_tipo            INT UNSIGNED NOT NULL,
  presentado         TINYINT(1) NOT NULL DEFAULT 0,
  fecha_presentacion DATE NULL,
  fecha_vencimiento  DATE NULL,
  observaciones      VARCHAR(255) NULL,
  PRIMARY KEY (id_estudiante, id_tipo),
  CONSTRAINT fk_doc_estudiante FOREIGN KEY (id_estudiante)
    REFERENCES estudiantes(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_doc_tipo FOREIGN KEY (id_tipo)
    REFERENCES tipos_documento(id_tipo) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------------------------------------------------------
-- 8. CURSADAS
-- ----------------------------------------------------------------------------
CREATE TABLE cursadas (
  id_cursada        INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_estudiante     INT UNSIGNED NOT NULL,
  id_materia        INT UNSIGNED NOT NULL,
  anio_cursada      YEAR NOT NULL,
  fecha_inscripcion DATE NULL,
  condicion         ENUM('cursar','recursar') NOT NULL DEFAULT 'cursar',
  caracter          ENUM('regular','libre','promocional') NULL,
  asistencia        TINYINT NULL COMMENT '% de asistencia',
  tp                TINYINT NULL COMMENT '% de trabajos prácticos',
  promedio          DECIMAL(4,2) NULL,
  nota_definitiva   DECIMAL(4,2) NULL,
  observaciones     TEXT NULL,
  PRIMARY KEY (id_cursada),
  UNIQUE KEY uq_cursada (id_estudiante, id_materia, anio_cursada),
  KEY idx_cursadas_estudiante (id_estudiante),
  CONSTRAINT fk_cursadas_estudiante FOREIGN KEY (id_estudiante)
    REFERENCES estudiantes(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_cursadas_materia FOREIGN KEY (id_materia)
    REFERENCES materias(id_materia) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------------------------------------------------------
-- 9. PARCIALES / UNIDADES / TP DE LA CURSADA
-- ----------------------------------------------------------------------------
CREATE TABLE cursadas_parciales (
  id_parcial     INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_cursada     INT UNSIGNED NOT NULL,
  numero         TINYINT NOT NULL,
  tipo           ENUM('parcial','recuperatorio','tp','unidad') NOT NULL,
  nota           DECIMAL(4,2) NULL,
  fecha          DATE NULL,
  observaciones  VARCHAR(255) NULL,
  PRIMARY KEY (id_parcial),
  UNIQUE KEY uq_parcial (id_cursada, tipo, numero),
  CONSTRAINT fk_parcial_cursada FOREIGN KEY (id_cursada)
    REFERENCES cursadas(id_cursada) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------------------------------------------------------
-- 10. EXÁMENES FINALES
-- ----------------------------------------------------------------------------
CREATE TABLE examenes_finales (
  id_examen        INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_estudiante    INT UNSIGNED NOT NULL,
  id_materia       INT UNSIGNED NOT NULL,
  condicion_alumno ENUM('regular','libre','promocion') NOT NULL,
  fecha            DATE NOT NULL,
  nota             DECIMAL(4,2) NOT NULL,
  libro            VARCHAR(20) NULL,
  folio            VARCHAR(20) NULL,
  observacion      VARCHAR(255) NULL,
  PRIMARY KEY (id_examen),
  KEY idx_examenes_estudiante (id_estudiante),
  CONSTRAINT fk_examenes_estudiante FOREIGN KEY (id_estudiante)
    REFERENCES estudiantes(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_examenes_materia FOREIGN KEY (id_materia)
    REFERENCES materias(id_materia) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------------------------------------------------------
-- 11. RESOLUCIONES
-- ----------------------------------------------------------------------------
CREATE TABLE resoluciones (
  id_resolucion  INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nro            VARCHAR(50) NOT NULL,
  fecha          DATE NOT NULL,
  tipo           ENUM('asimilacion','equivalencia','pase','nota_aprobacion') NOT NULL,
  observaciones  TEXT NULL,
  PRIMARY KEY (id_resolucion),
  UNIQUE KEY uq_resolucion (nro, tipo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------------------------------------------------------
-- 12. TRÁMITES
-- ----------------------------------------------------------------------------
CREATE TABLE tramites (
  id_tramite      INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_estudiante   INT UNSIGNED NOT NULL,
  tipo            ENUM('pase','asimilacion','equivalencia','nota_aprobacion') NOT NULL,
  fecha_solicitud DATE NOT NULL,
  fecha_limite    DATE NULL,
  estado          ENUM('en_curso','resuelto','rechazado') NOT NULL DEFAULT 'en_curso',
  id_resolucion   INT UNSIGNED NULL,
  detalle         TEXT NULL,
  PRIMARY KEY (id_tramite),
  KEY idx_tramites_estudiante (id_estudiante),
  CONSTRAINT fk_tramites_estudiante FOREIGN KEY (id_estudiante)
    REFERENCES estudiantes(id_estudiante) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_tramites_resolucion FOREIGN KEY (id_resolucion)
    REFERENCES resoluciones(id_resolucion) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------------------------------------------------------
-- 13. USUARIOS
-- ----------------------------------------------------------------------------
CREATE TABLE usuarios (
  id_usuario  INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre      VARCHAR(120) NOT NULL,
  usuario     VARCHAR(60) NOT NULL,
  clave_hash  VARCHAR(255) NOT NULL,
  rol         ENUM('admin','preceptora','coordinadora','vicerrectora') NOT NULL,
  turno       ENUM('mañana','tarde','ambos') NOT NULL DEFAULT 'ambos',
  activo      TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (id_usuario),
  UNIQUE KEY uq_usuarios_usuario (usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------------------------------------------------------
-- 14. AUDITORÍA
-- ----------------------------------------------------------------------------
CREATE TABLE auditoria (
  id_auditoria     BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_usuario       INT UNSIGNED NULL,
  tabla            VARCHAR(50) NOT NULL,
  registro_id      INT UNSIGNED NULL,
  accion           ENUM('INSERT','UPDATE','DELETE','LOGIN','LOGOUT') NOT NULL,
  datos_anteriores JSON NULL,
  datos_nuevos     JSON NULL,
  fecha            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_auditoria),
  KEY idx_auditoria_tabla (tabla, registro_id),
  KEY idx_auditoria_usuario (id_usuario),
  CONSTRAINT fk_auditoria_usuario FOREIGN KEY (id_usuario)
    REFERENCES usuarios(id_usuario) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ============================================================================
-- SEEDS
-- ============================================================================

-- Carrera (sede Palpalá)
INSERT INTO carreras (nombre, turno, sede, resolucion, activa) VALUES
('Profesorado de Educación Física con orientación en Tiempo Libre y Recreación',
 'mañana', 'Palpalá', 'Decreto-Resolución N° 13929-E-19', 1);

-- Plan 2019
INSERT INTO planes (id_carrera, anio_vigencia, resolucion) VALUES
(1, 2019, 'Decreto-Resolución N° 13929-E-19');

-- Tipos de documento (checklist)
INSERT INTO tipos_documento (nombre, obligatorio, vence, orden) VALUES
('DNI',                       1, 0, 1),
('Título o constancia',       1, 0, 2),
('Carnet sanitario',          1, 1, 3),
('Planilla prontuarial',      1, 0, 4),
('Apto físico',               1, 1, 5),
('Seguro SEMED',              1, 1, 6);

-- Usuario admin inicial — CAMBIAR EL HASH
-- Generar con:  php -r "echo password_hash('TuClaveSegura', PASSWORD_DEFAULT);"
INSERT INTO usuarios (nombre, usuario, clave_hash, rol, turno, activo) VALUES
('Administrador', 'admin',
 '$2y$10$CAMBIA_ESTE_HASH_POR_UNO_REAL_USANDO_PASSWORD_HASH',
 'admin', 'ambos', 1);

-- ----------------------------------------------------------------------------
-- MATERIAS DEL PLAN 13929-E-19 (38 materias)
-- grupo_calificacion: agrupa materias que comparten nota definitiva.
-- Nota: las "Prácticas Deportivas N" agrupan sus sub-deportes; Práctica I/II/III
-- agrupa el Taller Integrador. Se registra la fila del grupo con su nombre.
-- ----------------------------------------------------------------------------
INSERT INTO materias (id_plan, nombre, anio, orden, grupo_calificacion) VALUES
-- 1° año
(1, 'Pedagogía',                                      1,  1, NULL),
(1, 'Psicología Educacional',                         1,  2, NULL),
(1, 'Alfabetización Académica',                       1,  3, NULL),
(1, 'Didáctica General',                              1,  4, NULL),
(1, 'Anatomía y Fisiología',                          1,  5, NULL),
(1, 'Prácticas Ludomotrices',                         1,  6, NULL),
(1, 'Prácticas Gimnásticas',                          1,  7, NULL),
(1, 'Prácticas Atléticas',                            1,  8, NULL),
(1, 'Prácticas de Recreación',                        1,  9, NULL),
(1, 'Práctica I',                                     1, 10, 'Practica I'),
(1, 'Taller Integrador I',                            1, 11, 'Practica I'),
-- 2° año
(1, 'Filosofía',                                      2,  1, NULL),
(1, 'Historia Política y Educativa Argentina',        2,  2, NULL),
(1, 'Sujeto de la Educación',                         2,  3, NULL),
(1, 'Prácticas Acuáticas',                            2,  4, NULL),
(1, 'Prácticas Motrices Expresivas',                  2,  5, NULL),
(1, 'Prácticas Deportivas 1: Vóley',                  2,  6, 'Practicas Deportivas 1'),
(1, 'Prácticas Deportivas 2: Básquet',                2,  7, 'Practicas Deportivas 2'),
(1, 'Prácticas Deportivas 2: Handbol',                2,  8, 'Practicas Deportivas 2'),
(1, 'Didáctica de la Educación Física',               2,  9, NULL),
(1, 'Didáctica de las Prácticas Recreativas',         2, 10, NULL),
(1, 'Práctica II',                                    2, 11, 'Practica II'),
(1, 'Taller Integrador II',                           2, 12, 'Practica II'),
-- 3° año
(1, 'Educación Sexual Integral',                      3,  1, NULL),
(1, 'Integración de las TICs',                        3,  2, NULL),
(1, 'Sociología de la Educación',                     3,  3, NULL),
(1, 'Prácticas Deportivas 3: Hockey',                 3,  4, 'Practicas Deportivas 3'),
(1, 'Prácticas Deportivas 3: Rugby',                  3,  5, 'Practicas Deportivas 3'),
(1, 'Prácticas Deportivas 3: Fútbol',                 3,  6, 'Practicas Deportivas 3'),
(1, 'Prácticas Deportivas 4: Gimnasia',               3,  7, 'Practicas Deportivas 4'),
(1, 'Prácticas Deportivas 4: Atletismo',              3,  8, 'Practicas Deportivas 4'),
(1, 'Prácticas en la Naturaleza',                     3,  9, NULL),
(1, 'Entrenamiento para la Actividad Física',         3, 10, NULL),
(1, 'Historia y Epistemología de la Educación Física',3, 11, NULL),
(1, 'Práctica III',                                   3, 12, 'Practica III'),
(1, 'Taller Integrador III',                          3, 13, 'Practica III'),
-- 4° año
(1, 'Ética Profesional Docente',                      4,  1, NULL),
(1, 'Educación Física Inclusiva',                     4,  2, NULL),
(1, 'Educación Física y Salud',                       4,  3, NULL),
(1, 'Gestión de Espacios y Organizaciones Deportivas',4,  4, NULL),
(1, 'Unidad de Definición Institucional',             4,  5, NULL),
(1, 'Residencia Pedagógica',                          4,  6, NULL),
(1, 'Proyecto de Recreación y Tiempo Libre',          4,  7, NULL);

-- Nota: son 40 filas por la separación de sub-deportes y Talleres.
-- Si la institución los considera "un solo espacio", ajustar los nombres
-- y grupo_calificacion en un UPDATE durante la entrevista.