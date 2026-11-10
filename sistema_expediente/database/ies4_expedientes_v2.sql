-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 10-11-2026 a las 13:01:41
-- Versión del servidor: 10.11.16-MariaDB
-- Versión de PHP: 8.5.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `ies4_expedientes_v2`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria`
--

CREATE TABLE `auditoria` (
  `id_auditoria` bigint(20) UNSIGNED NOT NULL,
  `id_usuario` int(10) UNSIGNED DEFAULT NULL,
  `tabla` varchar(64) NOT NULL,
  `registro_id` bigint(20) UNSIGNED DEFAULT NULL,
  `accion` enum('INSERT','UPDATE','DELETE','LOGIN','LOGOUT','EXPORT','BACKUP') NOT NULL,
  `datos_anteriores` text DEFAULT NULL,
  `datos_nuevos` text DEFAULT NULL,
  `motivo` varchar(255) DEFAULT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `carreras`
--

CREATE TABLE `carreras` (
  `id_carrera` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(180) NOT NULL,
  `turno` enum('mañana','tarde') NOT NULL,
  `resolucion` varchar(150) DEFAULT NULL COMMENT 'Decreto-Resolución que figura en la ficha',
  `activa` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `correlatividades`
--

CREATE TABLE `correlatividades` (
  `id_materia` int(10) UNSIGNED NOT NULL COMMENT 'Materia que se quiere cursar o rendir',
  `id_requerida` int(10) UNSIGNED NOT NULL COMMENT 'Materia que debe estar regular o aprobada',
  `tipo_requisito` enum('cursar','rendir') NOT NULL,
  `condicion` enum('regular','aprobada') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cursadas`
--

CREATE TABLE `cursadas` (
  `id_cursada` bigint(20) UNSIGNED NOT NULL,
  `id_estudiante` int(10) UNSIGNED NOT NULL,
  `id_materia` int(10) UNSIGNED NOT NULL,
  `id_submateria` int(10) UNSIGNED DEFAULT NULL,
  `anio_cursada` year(4) NOT NULL,
  `fecha_inscripcion` date DEFAULT NULL,
  `tipo_inscripcion` enum('cursar','recursar','libre') NOT NULL DEFAULT 'cursar',
  `caracter` enum('regular','libre','promocional') DEFAULT NULL COMMENT 'NULL = todavía cursando',
  `asistencia` decimal(5,2) DEFAULT NULL COMMENT '% de asistencia',
  `tp` decimal(5,2) DEFAULT NULL COMMENT '% de trabajos prácticos',
  `promedio` decimal(4,2) DEFAULT NULL,
  `nota_general` decimal(4,2) DEFAULT NULL,
  `nota_definitiva` decimal(4,2) DEFAULT NULL,
  `estado` enum('cursando','regular','libre','promocional','aprobada','desaprobada','abandonada') NOT NULL DEFAULT 'cursando',
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Disparadores `cursadas`
--
DELIMITER $$
CREATE TRIGGER `trg_cursadas_regimen_bi` BEFORE INSERT ON `cursadas` FOR EACH ROW BEGIN
  IF NEW.caracter = 'regular' AND (SELECT regimen_acreditacion FROM materias WHERE id_materia = NEW.id_materia) = 'promocion' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esta materia solo se acredita por promocion: use Promocion, o Libre si no promociono (debe recursar).';
  END IF;
  IF NEW.caracter = 'promocional' AND (SELECT regimen_acreditacion FROM materias WHERE id_materia = NEW.id_materia) = 'examen_final' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esta materia no admite promocion: se acredita solo con examen final.';
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_cursadas_regimen_bu` BEFORE UPDATE ON `cursadas` FOR EACH ROW BEGIN
  IF NOT (NEW.caracter <=> OLD.caracter) THEN
    IF NEW.caracter = 'regular' AND (SELECT regimen_acreditacion FROM materias WHERE id_materia = NEW.id_materia) = 'promocion' THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esta materia solo se acredita por promocion: use Promocion, o Libre si no promociono (debe recursar).';
    END IF;
    IF NEW.caracter = 'promocional' AND (SELECT regimen_acreditacion FROM materias WHERE id_materia = NEW.id_materia) = 'examen_final' THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esta materia no admite promocion: se acredita solo con examen final.';
    END IF;
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_cursadas_submateria_bi` BEFORE INSERT ON `cursadas` FOR EACH ROW BEGIN
  IF NEW.id_submateria IS NULL AND EXISTS (SELECT 1 FROM submaterias WHERE id_materia = NEW.id_materia) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esta materia se cursa por submateria (deporte): indique cual.';
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `documentacion_estudiante`
--

CREATE TABLE `documentacion_estudiante` (
  `id_documento` bigint(20) UNSIGNED NOT NULL,
  `id_estudiante` int(10) UNSIGNED NOT NULL,
  `id_tipo` int(10) UNSIGNED NOT NULL,
  `anio_lectivo` year(4) DEFAULT NULL COMMENT 'Año al que corresponde (documentos anuales)',
  `presentado` tinyint(4) NOT NULL DEFAULT 0,
  `fecha_presentacion` date DEFAULT NULL,
  `archivo` varchar(255) DEFAULT NULL COMMENT 'Ruta del documento escaneado',
  `observaciones` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estudiantes`
--

CREATE TABLE `estudiantes` (
  `id_estudiante` int(10) UNSIGNED NOT NULL,
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
  `anio_ingreso` year(4) DEFAULT NULL,
  `id_carrera` int(10) UNSIGNED NOT NULL,
  `id_plan` int(10) UNSIGNED DEFAULT NULL,
  `estado` enum('activo','libre','egresado','abandono','pase') NOT NULL DEFAULT 'activo',
  `observaciones` text DEFAULT NULL,
  `certificado_por` int(10) UNSIGNED DEFAULT NULL COMMENT 'Autoridad que certificó el expediente',
  `fecha_certificacion` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Disparadores `estudiantes`
--
DELIMITER $$
CREATE TRIGGER `trg_estudiantes_ad` AFTER DELETE ON `estudiantes` FOR EACH ROW BEGIN
  INSERT INTO auditoria (id_usuario, tabla, registro_id, accion, datos_anteriores, motivo, fecha)
  VALUES (@id_usuario, 'estudiantes', OLD.id_estudiante, 'DELETE',
          CONCAT('DNI ', OLD.dni, ' - ', OLD.apellido, ', ', OLD.nombre, ' - estado ', OLD.estado, ' - carrera ', OLD.id_carrera),
          @motivo_baja, NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_estudiantes_bd` BEFORE DELETE ON `estudiantes` FOR EACH ROW BEGIN
  IF EXISTS (SELECT 1 FROM cursadas WHERE id_estudiante = OLD.id_estudiante)
     OR EXISTS (SELECT 1 FROM examenes_finales WHERE id_estudiante = OLD.id_estudiante)
     OR EXISTS (SELECT 1 FROM tramites WHERE id_estudiante = OLD.id_estudiante) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El alumno tiene historial academico: no se elimina. Darlo de baja cambiando su estado a Abandono.';
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `examenes_finales`
--

CREATE TABLE `examenes_finales` (
  `id_examen` bigint(20) UNSIGNED NOT NULL,
  `id_estudiante` int(10) UNSIGNED NOT NULL,
  `id_materia` int(10) UNSIGNED NOT NULL,
  `id_submateria` int(10) UNSIGNED DEFAULT NULL COMMENT 'Solo en materias compuestas (cada deporte con su nota, libro y folio)',
  `id_cursada` bigint(20) UNSIGNED DEFAULT NULL,
  `numero_intento` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `condicion_alumno` enum('regular','libre','promocion') NOT NULL,
  `fecha` date NOT NULL,
  `nota` decimal(4,2) DEFAULT NULL,
  `estado` enum('presente','ausente') NOT NULL DEFAULT 'presente',
  `libro` varchar(20) DEFAULT NULL,
  `folio` varchar(20) DEFAULT NULL,
  `observacion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Disparadores `examenes_finales`
--
DELIMITER $$
CREATE TRIGGER `trg_examenes_regimen_bi` BEFORE INSERT ON `examenes_finales` FOR EACH ROW BEGIN
  IF (SELECT regimen_acreditacion FROM materias WHERE id_materia = NEW.id_materia) = 'promocion' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esta materia solo se acredita por promocion: no tiene examen final. Si no promociono, debe recursar.';
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_examenes_submateria_bi` BEFORE INSERT ON `examenes_finales` FOR EACH ROW BEGIN
  IF NEW.id_submateria IS NULL AND EXISTS (SELECT 1 FROM submaterias WHERE id_materia = NEW.id_materia) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esta materia se rinde por submateria (deporte): indique cual.';
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inscripciones_curso`
--

CREATE TABLE `inscripciones_curso` (
  `id_inscripcion` int(10) UNSIGNED NOT NULL,
  `id_estudiante` int(10) UNSIGNED NOT NULL,
  `fecha_inscripcion` date NOT NULL,
  `curso` tinyint(3) UNSIGNED NOT NULL,
  `condicion` enum('cursar','recursar') NOT NULL,
  `observaciones` varchar(1000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `materias`
--

CREATE TABLE `materias` (
  `id_materia` int(10) UNSIGNED NOT NULL,
  `id_plan` int(10) UNSIGNED NOT NULL,
  `codigo` varchar(10) NOT NULL COMMENT 'N.º de orden en la resolución',
  `nombre` varchar(180) NOT NULL,
  `anio` tinyint(3) UNSIGNED NOT NULL,
  `orden` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `regimen_acreditacion` enum('promocion','examen_final','promocion_o_examen_final') NOT NULL DEFAULT 'promocion_o_examen_final',
  `permite_libre` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'Las marcadas con (*) en la resolución',
  `activa` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos`
--

CREATE TABLE `permisos` (
  `id_permiso` int(10) UNSIGNED NOT NULL,
  `codigo` varchar(60) NOT NULL,
  `descripcion` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `planes`
--

CREATE TABLE `planes` (
  `id_plan` int(10) UNSIGNED NOT NULL,
  `id_carrera` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `anio_vigencia` year(4) NOT NULL,
  `resolucion` varchar(150) DEFAULT NULL,
  `activo` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol_permiso`
--

CREATE TABLE `rol_permiso` (
  `rol` varchar(30) NOT NULL,
  `id_permiso` int(10) UNSIGNED NOT NULL,
  `puede_ver` tinyint(4) NOT NULL DEFAULT 1,
  `puede_editar` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `submaterias`
--

CREATE TABLE `submaterias` (
  `id_submateria` int(10) UNSIGNED NOT NULL,
  `id_materia` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `orden` smallint(5) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos_documento`
--

CREATE TABLE `tipos_documento` (
  `id_tipo` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `obligatorio` tinyint(4) NOT NULL DEFAULT 1,
  `vence` tinyint(4) NOT NULL DEFAULT 0 COMMENT '1 = se renueva cada año (apto físico y seguro SEMED)',
  `dias_alerta` smallint(5) UNSIGNED NOT NULL DEFAULT 30,
  `orden` smallint(6) NOT NULL DEFAULT 0,
  `activo` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tramites`
--

CREATE TABLE `tramites` (
  `id_tramite` bigint(20) UNSIGNED NOT NULL,
  `id_estudiante` int(10) UNSIGNED NOT NULL,
  `tipo` enum('pase','asimilacion','equivalencia','nota_aprobacion') NOT NULL,
  `fecha_solicitud` date NOT NULL,
  `fecha_limite` date DEFAULT NULL COMMENT 'Plazo para resolver (60 días)',
  `estado` enum('en_curso','en_revision','observado','resuelto','rechazado') NOT NULL DEFAULT 'en_curso',
  `nro_resolucion` varchar(50) DEFAULT NULL,
  `fecha_resolucion` date DEFAULT NULL,
  `detalle` text DEFAULT NULL,
  `id_usuario_inicia` int(10) UNSIGNED DEFAULT NULL,
  `id_carrera_origen` int(10) UNSIGNED DEFAULT NULL,
  `id_carrera_destino` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Disparadores `tramites`
--
DELIMITER $$
CREATE TRIGGER `trg_tramites_bi` BEFORE INSERT ON `tramites` FOR EACH ROW BEGIN
  IF NEW.fecha_limite IS NULL AND NEW.tipo IN ('asimilacion', 'equivalencia') THEN
    SET NEW.fecha_limite = DATE_ADD(NEW.fecha_solicitud, INTERVAL 60 DAY);
  END IF;
  IF NEW.fecha_limite IS NOT NULL AND NEW.fecha_limite < NEW.fecha_solicitud THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha limite no puede ser anterior a la fecha de solicitud.';
  END IF;
  IF NEW.fecha_resolucion IS NOT NULL AND NEW.fecha_resolucion < NEW.fecha_solicitud THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha de resolucion no puede ser anterior a la solicitud.';
  END IF;
  IF NEW.estado = 'resuelto' AND (NEW.nro_resolucion IS NULL OR TRIM(NEW.nro_resolucion) = '' OR NEW.fecha_resolucion IS NULL) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Para resolver un tramite hay que registrar numero y fecha de la resolucion.';
  END IF;
  IF NEW.estado = 'resuelto' AND NEW.tipo = 'pase'
     AND (NEW.id_carrera_origen IS NULL OR NEW.id_carrera_destino IS NULL OR NEW.id_carrera_origen = NEW.id_carrera_destino) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un pase necesita carrera de origen y de destino distintas.';
  END IF;
  -- NUEVO: sus materias se cargan despues de crearlo, asi que no puede nacer resuelto
  IF NEW.estado = 'resuelto' AND NEW.tipo IN ('equivalencia', 'asimilacion') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cree el tramite en curso, cargue las materias reconocidas y recien despues resuelvalo.';
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_tramites_bu` BEFORE UPDATE ON `tramites` FOR EACH ROW BEGIN
  IF NEW.fecha_limite IS NOT NULL AND NEW.fecha_limite < NEW.fecha_solicitud THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha limite no puede ser anterior a la fecha de solicitud.';
  END IF;
  IF NEW.fecha_resolucion IS NOT NULL AND NEW.fecha_resolucion < NEW.fecha_solicitud THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha de resolucion no puede ser anterior a la solicitud.';
  END IF;
  IF NEW.estado = 'resuelto' AND (NEW.nro_resolucion IS NULL OR TRIM(NEW.nro_resolucion) = '' OR NEW.fecha_resolucion IS NULL) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Para resolver un tramite hay que registrar numero y fecha de la resolucion.';
  END IF;
  IF NEW.estado = 'resuelto' AND NEW.tipo = 'pase'
     AND (NEW.id_carrera_origen IS NULL OR NEW.id_carrera_destino IS NULL OR NEW.id_carrera_origen = NEW.id_carrera_destino) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un pase necesita carrera de origen y de destino distintas.';
  END IF;
  -- NUEVO: una equivalencia/asimilacion resuelta tiene que reconocer al menos una materia
  IF NEW.estado = 'resuelto' AND NEW.tipo IN ('equivalencia', 'asimilacion')
     AND NOT EXISTS (SELECT 1 FROM tramite_materias WHERE id_tramite = NEW.id_tramite) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Una equivalencia o asimilacion resuelta necesita al menos una materia reconocida.';
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tramite_materias`
--

CREATE TABLE `tramite_materias` (
  `id_tramite` bigint(20) UNSIGNED NOT NULL,
  `id_materia` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `usuario` varchar(60) NOT NULL,
  `clave_hash` varchar(255) NOT NULL COMMENT 'Hash bcrypt (password_hash de PHP); nunca la clave en texto',
  `rol` enum('admin','vicerrectora','coordinadora','preceptora') NOT NULL,
  `id_carrera` int(10) UNSIGNED DEFAULT NULL COMMENT 'Carrera que puede MODIFICAR. NULL = todas. Consultar pueden todos.',
  `activo` tinyint(4) NOT NULL DEFAULT 1,
  `debe_cambiar_clave` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_alertas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_alertas` (
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_correlatividades_estado`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_correlatividades_estado` (
`id_estudiante` int(10) unsigned
,`apellido` varchar(100)
,`nombre` varchar(100)
,`dni` varchar(15)
,`id_materia_objetivo` int(10) unsigned
,`materia_objetivo` varchar(180)
,`tipo_requisito` enum('cursar','rendir')
,`condicion` enum('regular','aprobada')
,`id_materia_requerida` int(10) unsigned
,`materia_requerida` varchar(180)
,`estado_requerida` varchar(9)
,`cumple` int(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_documentacion_estado`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_documentacion_estado` (
`id_estudiante` int(10) unsigned
,`apellido` varchar(100)
,`nombre` varchar(100)
,`dni` varchar(15)
,`id_carrera` int(10) unsigned
,`anio_ingreso` year(4)
,`id_tipo` int(10) unsigned
,`documento` varchar(120)
,`vence` tinyint(4)
,`estado` varchar(10)
,`vence_el` date
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_documentacion_pendiente`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_documentacion_pendiente` (
`id_estudiante` int(10) unsigned
,`apellido` varchar(100)
,`nombre` varchar(100)
,`dni` varchar(15)
,`id_carrera` int(10) unsigned
,`id_tipo` int(10) unsigned
,`documento` varchar(120)
,`situacion` varchar(7)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_materia_aprobada`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_materia_aprobada` (
`id_estudiante` int(10) unsigned
,`id_materia` int(10) unsigned
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_semaforo_documentacion`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_semaforo_documentacion` (
`id_estudiante` int(10) unsigned
,`apellido` varchar(100)
,`nombre` varchar(100)
,`dni` varchar(15)
,`id_carrera` int(10) unsigned
,`obligatorios` bigint(21)
,`presentados` decimal(23,0)
,`faltan` decimal(23,0)
,`vencidos` decimal(23,0)
,`por_vencer` decimal(23,0)
,`semaforo` varchar(8)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_situacion_academica`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_situacion_academica` (
`id_estudiante` int(10) unsigned
,`apellido` varchar(100)
,`nombre` varchar(100)
,`dni` varchar(15)
,`id_carrera` int(10) unsigned
,`id_materia` int(10) unsigned
,`anio` tinyint(3) unsigned
,`orden` smallint(5) unsigned
,`materia` varchar(180)
,`estado_materia` varchar(9)
,`aplazos_regular` bigint(21)
,`aplazos_libre` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_tramites_pendientes`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_tramites_pendientes` (
`id_tramite` bigint(20) unsigned
,`id_estudiante` int(10) unsigned
,`apellido` varchar(100)
,`nombre` varchar(100)
,`dni` varchar(15)
,`tipo` enum('pase','asimilacion','equivalencia','nota_aprobacion')
,`fecha_solicitud` date
,`fecha_limite` date
,`estado` enum('en_curso','en_revision','observado','resuelto','rechazado')
,`dias_restantes` int(8)
,`situacion` varchar(10)
,`id_carrera` int(10) unsigned
);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `auditoria`
--
ALTER TABLE `auditoria`
  ADD PRIMARY KEY (`id_auditoria`),
  ADD KEY `idx_auditoria_tabla` (`tabla`,`registro_id`),
  ADD KEY `idx_auditoria_usuario` (`id_usuario`),
  ADD KEY `idx_auditoria_fecha` (`fecha`);

--
-- Indices de la tabla `carreras`
--
ALTER TABLE `carreras`
  ADD PRIMARY KEY (`id_carrera`);

--
-- Indices de la tabla `correlatividades`
--
ALTER TABLE `correlatividades`
  ADD PRIMARY KEY (`id_materia`,`id_requerida`,`tipo_requisito`),
  ADD KEY `idx_corr_requerida` (`id_requerida`);

--
-- Indices de la tabla `cursadas`
--
ALTER TABLE `cursadas`
  ADD PRIMARY KEY (`id_cursada`),
  ADD UNIQUE KEY `uq_cursadas` (`id_estudiante`,`id_materia`,`id_submateria`,`anio_cursada`),
  ADD KEY `idx_cursadas_materia` (`id_materia`,`anio_cursada`),
  ADD KEY `idx_cursadas_submateria` (`id_submateria`);

--
-- Indices de la tabla `documentacion_estudiante`
--
ALTER TABLE `documentacion_estudiante`
  ADD PRIMARY KEY (`id_documento`),
  ADD UNIQUE KEY `uq_doc_estudiante_tipo_anio` (`id_estudiante`,`id_tipo`,`anio_lectivo`),
  ADD KEY `idx_doc_tipo` (`id_tipo`);

--
-- Indices de la tabla `estudiantes`
--
ALTER TABLE `estudiantes`
  ADD PRIMARY KEY (`id_estudiante`),
  ADD UNIQUE KEY `uq_estudiantes_dni` (`dni`),
  ADD KEY `idx_estudiantes_apellido` (`apellido`,`nombre`),
  ADD KEY `idx_estudiantes_carrera` (`id_carrera`),
  ADD KEY `idx_estudiantes_plan` (`id_plan`),
  ADD KEY `idx_estudiantes_estado` (`estado`),
  ADD KEY `fk_estudiantes_certificador` (`certificado_por`);

--
-- Indices de la tabla `examenes_finales`
--
ALTER TABLE `examenes_finales`
  ADD PRIMARY KEY (`id_examen`),
  ADD UNIQUE KEY `uq_examen` (`id_estudiante`,`id_materia`,`id_submateria`,`fecha`),
  ADD KEY `idx_examenes_materia` (`id_materia`,`fecha`),
  ADD KEY `fk_examenes_cursada` (`id_cursada`),
  ADD KEY `fk_examenes_submateria` (`id_submateria`);

--
-- Indices de la tabla `inscripciones_curso`
--
ALTER TABLE `inscripciones_curso`
  ADD PRIMARY KEY (`id_inscripcion`),
  ADD KEY `fk_inscripcion_estudiante` (`id_estudiante`);

--
-- Indices de la tabla `materias`
--
ALTER TABLE `materias`
  ADD PRIMARY KEY (`id_materia`),
  ADD UNIQUE KEY `uq_materias_plan_codigo` (`id_plan`,`codigo`),
  ADD KEY `idx_materias_plan_anio` (`id_plan`,`anio`,`orden`);

--
-- Indices de la tabla `permisos`
--
ALTER TABLE `permisos`
  ADD PRIMARY KEY (`id_permiso`),
  ADD UNIQUE KEY `uq_permisos_codigo` (`codigo`);

--
-- Indices de la tabla `planes`
--
ALTER TABLE `planes`
  ADD PRIMARY KEY (`id_plan`),
  ADD UNIQUE KEY `uq_planes_carrera_anio` (`id_carrera`,`anio_vigencia`);

--
-- Indices de la tabla `rol_permiso`
--
ALTER TABLE `rol_permiso`
  ADD PRIMARY KEY (`rol`,`id_permiso`),
  ADD KEY `fk_rolpermiso_permiso` (`id_permiso`);

--
-- Indices de la tabla `submaterias`
--
ALTER TABLE `submaterias`
  ADD PRIMARY KEY (`id_submateria`),
  ADD UNIQUE KEY `uq_submaterias` (`id_materia`,`nombre`);

--
-- Indices de la tabla `tipos_documento`
--
ALTER TABLE `tipos_documento`
  ADD PRIMARY KEY (`id_tipo`),
  ADD UNIQUE KEY `uq_tipos_nombre` (`nombre`);

--
-- Indices de la tabla `tramites`
--
ALTER TABLE `tramites`
  ADD PRIMARY KEY (`id_tramite`),
  ADD KEY `idx_tramites_estudiante` (`id_estudiante`),
  ADD KEY `idx_tramites_estado` (`estado`,`fecha_limite`),
  ADD KEY `fk_tramites_usuario` (`id_usuario_inicia`),
  ADD KEY `fk_tramites_carrera_origen` (`id_carrera_origen`),
  ADD KEY `fk_tramites_carrera_destino` (`id_carrera_destino`);

--
-- Indices de la tabla `tramite_materias`
--
ALTER TABLE `tramite_materias`
  ADD PRIMARY KEY (`id_tramite`,`id_materia`),
  ADD KEY `idx_tm_materia` (`id_materia`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `uq_usuarios_usuario` (`usuario`),
  ADD KEY `idx_usuarios_carrera` (`id_carrera`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `auditoria`
--
ALTER TABLE `auditoria`
  MODIFY `id_auditoria` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `carreras`
--
ALTER TABLE `carreras`
  MODIFY `id_carrera` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cursadas`
--
ALTER TABLE `cursadas`
  MODIFY `id_cursada` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `documentacion_estudiante`
--
ALTER TABLE `documentacion_estudiante`
  MODIFY `id_documento` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `estudiantes`
--
ALTER TABLE `estudiantes`
  MODIFY `id_estudiante` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `examenes_finales`
--
ALTER TABLE `examenes_finales`
  MODIFY `id_examen` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `inscripciones_curso`
--
ALTER TABLE `inscripciones_curso`
  MODIFY `id_inscripcion` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `materias`
--
ALTER TABLE `materias`
  MODIFY `id_materia` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `permisos`
--
ALTER TABLE `permisos`
  MODIFY `id_permiso` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `planes`
--
ALTER TABLE `planes`
  MODIFY `id_plan` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `submaterias`
--
ALTER TABLE `submaterias`
  MODIFY `id_submateria` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tipos_documento`
--
ALTER TABLE `tipos_documento`
  MODIFY `id_tipo` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tramites`
--
ALTER TABLE `tramites`
  MODIFY `id_tramite` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_alertas`
--
DROP TABLE IF EXISTS `v_alertas`;
-- Error leyendo la estructura de la tabla ies4_expedientes_v2.v_alertas: #1271 - Mezcla ilegal de cotejos (collations) para la operación &#039;UNION&#039;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_correlatividades_estado`
--
DROP TABLE IF EXISTS `v_correlatividades_estado`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_correlatividades_estado`  AS SELECT `s`.`id_estudiante` AS `id_estudiante`, `s`.`apellido` AS `apellido`, `s`.`nombre` AS `nombre`, `s`.`dni` AS `dni`, `co`.`id_materia` AS `id_materia_objetivo`, `m`.`nombre` AS `materia_objetivo`, `co`.`tipo_requisito` AS `tipo_requisito`, `co`.`condicion` AS `condicion`, `co`.`id_requerida` AS `id_materia_requerida`, `r`.`nombre` AS `materia_requerida`, `s`.`estado_materia` AS `estado_requerida`, CASE WHEN `co`.`condicion` = 'aprobada' AND `s`.`estado_materia` = 'aprobada' THEN 1 WHEN `co`.`condicion` = 'regular' AND `s`.`estado_materia` in ('regular','aprobada') THEN 1 ELSE 0 END AS `cumple` FROM (((`v_situacion_academica` `s` join `correlatividades` `co` on(`co`.`id_requerida` = `s`.`id_materia`)) join `materias` `m` on(`m`.`id_materia` = `co`.`id_materia`)) join `materias` `r` on(`r`.`id_materia` = `co`.`id_requerida`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_documentacion_estado`
--
DROP TABLE IF EXISTS `v_documentacion_estado`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_documentacion_estado`  AS SELECT `e`.`id_estudiante` AS `id_estudiante`, `e`.`apellido` AS `apellido`, `e`.`nombre` AS `nombre`, `e`.`dni` AS `dni`, `e`.`id_carrera` AS `id_carrera`, `e`.`anio_ingreso` AS `anio_ingreso`, `t`.`id_tipo` AS `id_tipo`, `t`.`nombre` AS `documento`, `t`.`vence` AS `vence`, CASE WHEN coalesce(`d`.`cualquiera`,0) = 0 THEN 'falta' WHEN `t`.`vence` = 0 THEN 'vigente' WHEN `d`.`este_anio` = 1 THEN CASE WHEN curdate() >= str_to_date(concat(year(curdate()),'-12-31'),'%Y-%m-%d') - interval `t`.`dias_alerta` day THEN 'por_vencer' ELSE 'vigente' END ELSE 'vencido' END AS `estado`, CASE WHEN `t`.`vence` = 1 AND `d`.`este_anio` = 1 THEN str_to_date(concat(year(curdate()),'-12-31'),'%Y-%m-%d') END AS `vence_el` FROM ((`estudiantes` `e` join `tipos_documento` `t` on(`t`.`obligatorio` = 1 and `t`.`activo` = 1)) left join (select `documentacion_estudiante`.`id_estudiante` AS `id_estudiante`,`documentacion_estudiante`.`id_tipo` AS `id_tipo`,max(`documentacion_estudiante`.`presentado` = 1) AS `cualquiera`,max(`documentacion_estudiante`.`presentado` = 1 and `documentacion_estudiante`.`anio_lectivo` = year(curdate())) AS `este_anio` from `documentacion_estudiante` group by `documentacion_estudiante`.`id_estudiante`,`documentacion_estudiante`.`id_tipo`) `d` on(`d`.`id_estudiante` = `e`.`id_estudiante` and `d`.`id_tipo` = `t`.`id_tipo`)) WHERE `e`.`estado` = 'activo' ;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_documentacion_pendiente`
--
DROP TABLE IF EXISTS `v_documentacion_pendiente`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_documentacion_pendiente`  AS SELECT `e`.`id_estudiante` AS `id_estudiante`, `e`.`apellido` AS `apellido`, `e`.`nombre` AS `nombre`, `e`.`dni` AS `dni`, `e`.`id_carrera` AS `id_carrera`, `t`.`id_tipo` AS `id_tipo`, `t`.`nombre` AS `documento`, CASE WHEN exists(select 1 from `documentacion_estudiante` `d2` where `d2`.`id_estudiante` = `e`.`id_estudiante` AND `d2`.`id_tipo` = `t`.`id_tipo` AND `d2`.`presentado` = 1 limit 1) THEN 'vencido' ELSE 'falta' END AS `situacion` FROM ((`estudiantes` `e` join `tipos_documento` `t` on(`t`.`obligatorio` = 1 and `t`.`activo` = 1)) left join `documentacion_estudiante` `d` on(`d`.`id_estudiante` = `e`.`id_estudiante` and `d`.`id_tipo` = `t`.`id_tipo` and (`t`.`vence` = 0 or `d`.`anio_lectivo` = year(curdate())))) WHERE `e`.`estado` = 'activo' AND (`d`.`id_documento` is null OR `d`.`presentado` = 0) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_materia_aprobada`
--
DROP TABLE IF EXISTS `v_materia_aprobada`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_materia_aprobada`  AS SELECT `x`.`id_estudiante` AS `id_estudiante`, `x`.`id_materia` AS `id_materia` FROM `examenes_finales` AS `x` WHERE `x`.`id_submateria` is null AND `x`.`estado` = 'presente' AND `x`.`nota` >= 4 GROUP BY `x`.`id_estudiante`, `x`.`id_materia`union select `x`.`id_estudiante` AS `id_estudiante`,`x`.`id_materia` AS `id_materia` from `examenes_finales` `x` where `x`.`id_submateria` is not null and `x`.`estado` = 'presente' and `x`.`nota` >= 4 group by `x`.`id_estudiante`,`x`.`id_materia` having count(distinct `x`.`id_submateria`) = (select count(0) from `submaterias` `s` where `s`.`id_materia` = `x`.`id_materia`) union select `t`.`id_estudiante` AS `id_estudiante`,`tm`.`id_materia` AS `id_materia` from (`tramites` `t` join `tramite_materias` `tm` on(`tm`.`id_tramite` = `t`.`id_tramite`)) where `t`.`estado` = 'resuelto' and `t`.`tipo` in ('equivalencia','asimilacion') union select `c`.`id_estudiante` AS `id_estudiante`,`c`.`id_materia` AS `id_materia` from `cursadas` `c` where `c`.`caracter` = 'promocional' and `c`.`id_submateria` is null union select `c`.`id_estudiante` AS `id_estudiante`,`c`.`id_materia` AS `id_materia` from `cursadas` `c` where `c`.`caracter` = 'promocional' and `c`.`id_submateria` is not null group by `c`.`id_estudiante`,`c`.`id_materia` having count(distinct `c`.`id_submateria`) = (select count(0) from `submaterias` `s` where `s`.`id_materia` = `c`.`id_materia`)  ;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_semaforo_documentacion`
--
DROP TABLE IF EXISTS `v_semaforo_documentacion`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_semaforo_documentacion`  AS SELECT `v_documentacion_estado`.`id_estudiante` AS `id_estudiante`, `v_documentacion_estado`.`apellido` AS `apellido`, `v_documentacion_estado`.`nombre` AS `nombre`, `v_documentacion_estado`.`dni` AS `dni`, `v_documentacion_estado`.`id_carrera` AS `id_carrera`, count(0) AS `obligatorios`, sum(`v_documentacion_estado`.`estado` in ('vigente','por_vencer')) AS `presentados`, sum(`v_documentacion_estado`.`estado` = 'falta') AS `faltan`, sum(`v_documentacion_estado`.`estado` = 'vencido') AS `vencidos`, sum(`v_documentacion_estado`.`estado` = 'por_vencer') AS `por_vencer`, CASE WHEN sum(`v_documentacion_estado`.`estado` in ('falta','vencido')) > 0 THEN 'rojo' WHEN sum(`v_documentacion_estado`.`estado` = 'por_vencer') > 0 THEN 'amarillo' ELSE 'verde' END AS `semaforo` FROM `v_documentacion_estado` GROUP BY `v_documentacion_estado`.`id_estudiante`, `v_documentacion_estado`.`apellido`, `v_documentacion_estado`.`nombre`, `v_documentacion_estado`.`dni`, `v_documentacion_estado`.`id_carrera` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_situacion_academica`
--
DROP TABLE IF EXISTS `v_situacion_academica`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_situacion_academica`  AS SELECT `e`.`id_estudiante` AS `id_estudiante`, `e`.`apellido` AS `apellido`, `e`.`nombre` AS `nombre`, `e`.`dni` AS `dni`, `e`.`id_carrera` AS `id_carrera`, `m`.`id_materia` AS `id_materia`, `m`.`anio` AS `anio`, `m`.`orden` AS `orden`, `m`.`nombre` AS `materia`, CASE WHEN exists(select 1 from `v_materia_aprobada` `a` where `a`.`id_estudiante` = `e`.`id_estudiante` AND `a`.`id_materia` = `m`.`id_materia` limit 1) THEN 'aprobada' WHEN exists(select 1 from `cursadas` `c` where `c`.`id_estudiante` = `e`.`id_estudiante` AND `c`.`id_materia` = `m`.`id_materia` AND `c`.`caracter` in ('regular','promocional') AND `c`.`anio_cursada` + 2 >= year(curdate()) limit 1) THEN 'regular' WHEN exists(select 1 from `cursadas` `c` where `c`.`id_estudiante` = `e`.`id_estudiante` AND `c`.`id_materia` = `m`.`id_materia` AND `c`.`caracter` is null AND `c`.`estado` = 'cursando' limit 1) THEN 'cursando' WHEN exists(select 1 from `cursadas` `c` where `c`.`id_estudiante` = `e`.`id_estudiante` AND `c`.`id_materia` = `m`.`id_materia` AND `c`.`caracter` is not null limit 1) THEN 'libre' ELSE 'pendiente' END AS `estado_materia`, (select count(0) from `examenes_finales` `x` where `x`.`id_estudiante` = `e`.`id_estudiante` and `x`.`id_materia` = `m`.`id_materia` and `x`.`condicion_alumno` = 'regular' and `x`.`estado` = 'presente' and `x`.`nota` < 4) AS `aplazos_regular`, (select count(0) from `examenes_finales` `x` where `x`.`id_estudiante` = `e`.`id_estudiante` and `x`.`id_materia` = `m`.`id_materia` and `x`.`condicion_alumno` = 'libre' and `x`.`estado` = 'presente' and `x`.`nota` < 4) AS `aplazos_libre` FROM (`estudiantes` `e` join `materias` `m` on(`m`.`id_plan` = `e`.`id_plan` and `m`.`activa` = 1)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_tramites_pendientes`
--
DROP TABLE IF EXISTS `v_tramites_pendientes`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_tramites_pendientes`  AS SELECT `t`.`id_tramite` AS `id_tramite`, `t`.`id_estudiante` AS `id_estudiante`, `e`.`apellido` AS `apellido`, `e`.`nombre` AS `nombre`, `e`.`dni` AS `dni`, `t`.`tipo` AS `tipo`, `t`.`fecha_solicitud` AS `fecha_solicitud`, `t`.`fecha_limite` AS `fecha_limite`, `t`.`estado` AS `estado`, to_days(`t`.`fecha_limite`) - to_days(curdate()) AS `dias_restantes`, CASE WHEN `t`.`fecha_limite` is null THEN 'sin_plazo' WHEN `t`.`fecha_limite` < curdate() THEN 'vencido' WHEN `t`.`fecha_limite` <= curdate() + interval 7 day THEN 'por_vencer' ELSE 'en_plazo' END AS `situacion`, `e`.`id_carrera` AS `id_carrera` FROM (`tramites` `t` join `estudiantes` `e` on(`e`.`id_estudiante` = `t`.`id_estudiante`)) WHERE `t`.`estado` in ('en_curso','en_revision','observado') ;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `auditoria`
--
ALTER TABLE `auditoria`
  ADD CONSTRAINT `fk_auditoria_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `correlatividades`
--
ALTER TABLE `correlatividades`
  ADD CONSTRAINT `fk_corr_materia` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_corr_requerida` FOREIGN KEY (`id_requerida`) REFERENCES `materias` (`id_materia`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `cursadas`
--
ALTER TABLE `cursadas`
  ADD CONSTRAINT `fk_cursadas_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cursadas_materia` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cursadas_submateria` FOREIGN KEY (`id_submateria`) REFERENCES `submaterias` (`id_submateria`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `documentacion_estudiante`
--
ALTER TABLE `documentacion_estudiante`
  ADD CONSTRAINT `fk_doc_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_doc_tipo` FOREIGN KEY (`id_tipo`) REFERENCES `tipos_documento` (`id_tipo`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `estudiantes`
--
ALTER TABLE `estudiantes`
  ADD CONSTRAINT `fk_estudiantes_carrera` FOREIGN KEY (`id_carrera`) REFERENCES `carreras` (`id_carrera`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_estudiantes_certificador` FOREIGN KEY (`certificado_por`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_estudiantes_plan` FOREIGN KEY (`id_plan`) REFERENCES `planes` (`id_plan`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `examenes_finales`
--
ALTER TABLE `examenes_finales`
  ADD CONSTRAINT `fk_examenes_cursada` FOREIGN KEY (`id_cursada`) REFERENCES `cursadas` (`id_cursada`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_examenes_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_examenes_materia` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_examenes_submateria` FOREIGN KEY (`id_submateria`) REFERENCES `submaterias` (`id_submateria`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `inscripciones_curso`
--
ALTER TABLE `inscripciones_curso`
  ADD CONSTRAINT `fk_inscripcion_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `materias`
--
ALTER TABLE `materias`
  ADD CONSTRAINT `fk_materias_plan` FOREIGN KEY (`id_plan`) REFERENCES `planes` (`id_plan`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `planes`
--
ALTER TABLE `planes`
  ADD CONSTRAINT `fk_planes_carrera` FOREIGN KEY (`id_carrera`) REFERENCES `carreras` (`id_carrera`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `rol_permiso`
--
ALTER TABLE `rol_permiso`
  ADD CONSTRAINT `fk_rolpermiso_permiso` FOREIGN KEY (`id_permiso`) REFERENCES `permisos` (`id_permiso`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `submaterias`
--
ALTER TABLE `submaterias`
  ADD CONSTRAINT `fk_submaterias_materia` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `tramites`
--
ALTER TABLE `tramites`
  ADD CONSTRAINT `fk_tramites_carrera_destino` FOREIGN KEY (`id_carrera_destino`) REFERENCES `carreras` (`id_carrera`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tramites_carrera_origen` FOREIGN KEY (`id_carrera_origen`) REFERENCES `carreras` (`id_carrera`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tramites_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tramites_usuario` FOREIGN KEY (`id_usuario_inicia`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `tramite_materias`
--
ALTER TABLE `tramite_materias`
  ADD CONSTRAINT `fk_tm_materia` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tm_tramite` FOREIGN KEY (`id_tramite`) REFERENCES `tramites` (`id_tramite`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_usuarios_carrera` FOREIGN KEY (`id_carrera`) REFERENCES `carreras` (`id_carrera`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
