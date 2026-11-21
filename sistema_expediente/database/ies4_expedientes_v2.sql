/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.14-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: ies4_expedientes_v2
-- ------------------------------------------------------
-- Server version	10.11.14-MariaDB-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auditoria`
--

DROP TABLE IF EXISTS `auditoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditoria` (
  `id_auditoria` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_usuario` int(10) unsigned DEFAULT NULL,
  `tabla` varchar(64) NOT NULL,
  `registro_id` bigint(20) unsigned DEFAULT NULL,
  `accion` enum('INSERT','UPDATE','DELETE','LOGIN','LOGOUT','EXPORT','BACKUP') NOT NULL,
  `datos_anteriores` text DEFAULT NULL,
  `datos_nuevos` text DEFAULT NULL,
  `motivo` varchar(255) DEFAULT NULL,
  `ip` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_auditoria`),
  KEY `idx_auditoria_tabla` (`tabla`,`registro_id`),
  KEY `idx_auditoria_usuario` (`id_usuario`),
  KEY `idx_auditoria_fecha` (`fecha`),
  CONSTRAINT `fk_auditoria_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditoria`
--

LOCK TABLES `auditoria` WRITE;
/*!40000 ALTER TABLE `auditoria` DISABLE KEYS */;
/*!40000 ALTER TABLE `auditoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `carreras`
--

DROP TABLE IF EXISTS `carreras`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `carreras` (
  `id_carrera` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(180) NOT NULL,
  `turno` enum('mañana','tarde') NOT NULL,
  `resolucion` varchar(150) DEFAULT NULL COMMENT 'Decreto-Resolución que figura en la ficha',
  `activa` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_carrera`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carreras`
--

LOCK TABLES `carreras` WRITE;
/*!40000 ALTER TABLE `carreras` DISABLE KEYS */;
INSERT INTO `carreras` VALUES
(1,'Profesorado de Educación Física con orientación en Tiempo Libre y Recreación','tarde','Decreto-Resolución N° 13929-E-19',1),
(2,'Profesorado de Educación Física','mañana',NULL,0);
/*!40000 ALTER TABLE `carreras` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `correlatividades`
--

DROP TABLE IF EXISTS `correlatividades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `correlatividades` (
  `id_materia` int(10) unsigned NOT NULL COMMENT 'Materia que se quiere cursar o rendir',
  `id_requerida` int(10) unsigned NOT NULL COMMENT 'Materia que debe estar regular o aprobada',
  `tipo_requisito` enum('cursar','rendir') NOT NULL,
  `condicion` enum('regular','aprobada') NOT NULL,
  PRIMARY KEY (`id_materia`,`id_requerida`,`tipo_requisito`),
  KEY `idx_corr_requerida` (`id_requerida`),
  CONSTRAINT `fk_corr_materia` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_corr_requerida` FOREIGN KEY (`id_requerida`) REFERENCES `materias` (`id_materia`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `correlatividades`
--

LOCK TABLES `correlatividades` WRITE;
/*!40000 ALTER TABLE `correlatividades` DISABLE KEYS */;
INSERT INTO `correlatividades` VALUES
(11,1,'cursar','regular'),
(11,1,'rendir','aprobada'),
(13,2,'cursar','regular'),
(13,2,'rendir','aprobada'),
(13,5,'cursar','regular'),
(13,5,'rendir','aprobada'),
(14,4,'cursar','regular'),
(14,4,'rendir','aprobada'),
(14,6,'cursar','regular'),
(14,6,'rendir','aprobada'),
(15,4,'cursar','regular'),
(15,4,'rendir','aprobada'),
(15,6,'cursar','regular'),
(15,6,'rendir','aprobada'),
(16,4,'cursar','regular'),
(16,4,'rendir','aprobada'),
(16,6,'cursar','regular'),
(16,6,'rendir','aprobada'),
(17,4,'cursar','regular'),
(17,4,'rendir','aprobada'),
(17,6,'cursar','regular'),
(17,6,'rendir','aprobada'),
(18,1,'cursar','regular'),
(18,1,'rendir','aprobada'),
(18,2,'cursar','regular'),
(18,2,'rendir','aprobada'),
(18,4,'cursar','regular'),
(18,4,'rendir','aprobada'),
(19,4,'cursar','regular'),
(19,4,'rendir','aprobada'),
(19,9,'cursar','regular'),
(19,9,'rendir','aprobada'),
(20,10,'cursar','aprobada'),
(20,10,'rendir','aprobada'),
(22,4,'cursar','aprobada'),
(22,4,'rendir','aprobada'),
(23,1,'cursar','aprobada'),
(23,1,'rendir','aprobada'),
(23,12,'cursar','regular'),
(23,12,'rendir','aprobada'),
(24,7,'cursar','aprobada'),
(24,7,'rendir','aprobada'),
(24,8,'cursar','aprobada'),
(24,8,'rendir','aprobada'),
(24,15,'cursar','regular'),
(24,15,'rendir','aprobada'),
(24,16,'cursar','regular'),
(24,16,'rendir','aprobada'),
(24,17,'cursar','regular'),
(24,17,'rendir','aprobada'),
(25,7,'cursar','aprobada'),
(25,7,'rendir','aprobada'),
(25,8,'cursar','aprobada'),
(25,8,'rendir','aprobada'),
(25,15,'cursar','regular'),
(25,15,'rendir','aprobada'),
(25,16,'cursar','regular'),
(25,16,'rendir','aprobada'),
(25,17,'cursar','regular'),
(25,17,'rendir','aprobada'),
(26,6,'cursar','aprobada'),
(26,6,'rendir','aprobada'),
(26,9,'cursar','aprobada'),
(26,9,'rendir','aprobada'),
(26,13,'cursar','regular'),
(26,14,'cursar','regular'),
(26,14,'rendir','aprobada'),
(26,19,'cursar','regular'),
(27,5,'cursar','aprobada'),
(27,5,'rendir','aprobada'),
(27,7,'cursar','aprobada'),
(27,7,'rendir','aprobada'),
(27,8,'cursar','aprobada'),
(27,8,'rendir','aprobada'),
(27,15,'cursar','regular'),
(27,15,'rendir','aprobada'),
(27,16,'cursar','regular'),
(27,16,'rendir','aprobada'),
(28,11,'cursar','regular'),
(28,11,'rendir','aprobada'),
(28,12,'cursar','regular'),
(28,12,'rendir','aprobada'),
(29,6,'cursar','aprobada'),
(29,6,'rendir','aprobada'),
(29,7,'cursar','aprobada'),
(29,7,'rendir','aprobada'),
(29,8,'cursar','aprobada'),
(29,8,'rendir','aprobada'),
(29,13,'cursar','regular'),
(29,13,'rendir','aprobada'),
(29,14,'cursar','regular'),
(29,14,'rendir','aprobada'),
(29,15,'cursar','regular'),
(29,15,'rendir','aprobada'),
(29,16,'cursar','regular'),
(29,16,'rendir','aprobada'),
(29,17,'cursar','aprobada'),
(29,17,'rendir','aprobada'),
(29,20,'cursar','aprobada'),
(29,20,'rendir','aprobada'),
(30,11,'cursar','aprobada'),
(30,11,'rendir','aprobada'),
(31,5,'cursar','aprobada'),
(31,5,'rendir','aprobada'),
(31,6,'cursar','aprobada'),
(31,6,'rendir','aprobada'),
(31,14,'cursar','aprobada'),
(31,14,'rendir','aprobada'),
(31,21,'cursar','regular'),
(31,21,'rendir','aprobada'),
(32,6,'cursar','aprobada'),
(32,6,'rendir','aprobada'),
(32,24,'cursar','regular'),
(32,24,'rendir','aprobada'),
(33,25,'cursar','regular'),
(33,25,'rendir','aprobada'),
(34,26,'cursar','regular'),
(34,26,'rendir','aprobada'),
(35,1,'cursar','aprobada'),
(35,1,'rendir','aprobada'),
(35,2,'cursar','aprobada'),
(35,2,'rendir','aprobada'),
(35,3,'cursar','aprobada'),
(35,3,'rendir','aprobada'),
(35,4,'cursar','aprobada'),
(35,4,'rendir','aprobada'),
(35,5,'cursar','aprobada'),
(35,5,'rendir','aprobada'),
(35,6,'cursar','aprobada'),
(35,6,'rendir','aprobada'),
(35,7,'cursar','aprobada'),
(35,7,'rendir','aprobada'),
(35,8,'cursar','aprobada'),
(35,8,'rendir','aprobada'),
(35,9,'cursar','aprobada'),
(35,9,'rendir','aprobada'),
(35,10,'cursar','aprobada'),
(35,10,'rendir','aprobada'),
(36,1,'cursar','aprobada'),
(36,1,'rendir','aprobada'),
(36,2,'cursar','aprobada'),
(36,2,'rendir','aprobada'),
(36,3,'cursar','aprobada'),
(36,3,'rendir','aprobada'),
(36,4,'cursar','aprobada'),
(36,4,'rendir','aprobada'),
(36,5,'cursar','aprobada'),
(36,5,'rendir','aprobada'),
(36,6,'cursar','aprobada'),
(36,6,'rendir','aprobada'),
(36,7,'cursar','aprobada'),
(36,7,'rendir','aprobada'),
(36,8,'cursar','aprobada'),
(36,8,'rendir','aprobada'),
(36,9,'cursar','aprobada'),
(36,9,'rendir','aprobada'),
(36,10,'cursar','aprobada'),
(36,10,'rendir','aprobada'),
(36,11,'cursar','aprobada'),
(36,11,'rendir','aprobada'),
(36,12,'cursar','aprobada'),
(36,12,'rendir','aprobada'),
(36,13,'cursar','aprobada'),
(36,13,'rendir','aprobada'),
(36,14,'cursar','aprobada'),
(36,14,'rendir','aprobada'),
(36,15,'cursar','aprobada'),
(36,15,'rendir','aprobada'),
(36,16,'cursar','aprobada'),
(36,16,'rendir','aprobada'),
(36,17,'cursar','aprobada'),
(36,17,'rendir','aprobada'),
(36,18,'cursar','aprobada'),
(36,18,'rendir','aprobada'),
(36,19,'cursar','aprobada'),
(36,19,'rendir','aprobada'),
(36,20,'cursar','aprobada'),
(36,20,'rendir','aprobada'),
(36,21,'cursar','regular'),
(36,21,'rendir','aprobada'),
(36,22,'cursar','regular'),
(36,22,'rendir','aprobada'),
(36,23,'cursar','regular'),
(36,23,'rendir','aprobada'),
(36,24,'cursar','regular'),
(36,24,'rendir','aprobada'),
(36,25,'cursar','regular'),
(36,25,'rendir','aprobada'),
(36,26,'cursar','regular'),
(36,26,'rendir','aprobada'),
(36,27,'cursar','regular'),
(36,27,'rendir','aprobada'),
(36,28,'cursar','regular'),
(36,28,'rendir','aprobada'),
(36,29,'cursar','aprobada'),
(36,29,'rendir','aprobada');
/*!40000 ALTER TABLE `correlatividades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cursadas`
--

DROP TABLE IF EXISTS `cursadas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cursadas` (
  `id_cursada` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_estudiante` int(10) unsigned NOT NULL,
  `id_materia` int(10) unsigned NOT NULL,
  `id_submateria` int(10) unsigned DEFAULT NULL,
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
  `observaciones` text DEFAULT NULL,
  PRIMARY KEY (`id_cursada`),
  UNIQUE KEY `uq_cursadas` (`id_estudiante`,`id_materia`,`id_submateria`,`anio_cursada`),
  KEY `idx_cursadas_materia` (`id_materia`,`anio_cursada`),
  KEY `idx_cursadas_submateria` (`id_submateria`),
  CONSTRAINT `fk_cursadas_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cursadas_materia` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON UPDATE CASCADE,
  CONSTRAINT `fk_cursadas_submateria` FOREIGN KEY (`id_submateria`) REFERENCES `submaterias` (`id_submateria`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cursadas`
--

LOCK TABLES `cursadas` WRITE;
/*!40000 ALTER TABLE `cursadas` DISABLE KEYS */;
/*!40000 ALTER TABLE `cursadas` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_cursadas_submateria_bi BEFORE INSERT ON cursadas
FOR EACH ROW
BEGIN
  IF NEW.id_submateria IS NULL AND EXISTS (SELECT 1 FROM submaterias WHERE id_materia = NEW.id_materia) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esta materia se cursa por submateria (deporte): indique cual.';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_cursadas_regimen_bi BEFORE INSERT ON cursadas
FOR EACH ROW
BEGIN
  IF NEW.caracter = 'regular' AND (SELECT regimen_acreditacion FROM materias WHERE id_materia = NEW.id_materia) = 'promocion' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esta materia solo se acredita por promocion: use Promocion, o Libre si no promociono (debe recursar).';
  END IF;
  IF NEW.caracter = 'promocional' AND (SELECT regimen_acreditacion FROM materias WHERE id_materia = NEW.id_materia) = 'examen_final' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esta materia no admite promocion: se acredita solo con examen final.';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_cursadas_regimen_bu BEFORE UPDATE ON cursadas
FOR EACH ROW
BEGIN
  IF NOT (NEW.caracter <=> OLD.caracter) THEN
    IF NEW.caracter = 'regular' AND (SELECT regimen_acreditacion FROM materias WHERE id_materia = NEW.id_materia) = 'promocion' THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esta materia solo se acredita por promocion: use Promocion, o Libre si no promociono (debe recursar).';
    END IF;
    IF NEW.caracter = 'promocional' AND (SELECT regimen_acreditacion FROM materias WHERE id_materia = NEW.id_materia) = 'examen_final' THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esta materia no admite promocion: se acredita solo con examen final.';
    END IF;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `documentacion_estudiante`
--

DROP TABLE IF EXISTS `documentacion_estudiante`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentacion_estudiante` (
  `id_documento` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_estudiante` int(10) unsigned NOT NULL,
  `id_tipo` int(10) unsigned NOT NULL,
  `anio_lectivo` year(4) DEFAULT NULL COMMENT 'Año al que corresponde (documentos anuales)',
  `presentado` tinyint(4) NOT NULL DEFAULT 0,
  `fecha_presentacion` date DEFAULT NULL,
  `archivo` varchar(255) DEFAULT NULL COMMENT 'Ruta del documento escaneado',
  `observaciones` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_documento`),
  UNIQUE KEY `uq_doc_estudiante_tipo_anio` (`id_estudiante`,`id_tipo`,`anio_lectivo`),
  KEY `idx_doc_tipo` (`id_tipo`),
  CONSTRAINT `fk_doc_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_doc_tipo` FOREIGN KEY (`id_tipo`) REFERENCES `tipos_documento` (`id_tipo`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documentacion_estudiante`
--

LOCK TABLES `documentacion_estudiante` WRITE;
/*!40000 ALTER TABLE `documentacion_estudiante` DISABLE KEYS */;
/*!40000 ALTER TABLE `documentacion_estudiante` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estudiantes`
--

DROP TABLE IF EXISTS `estudiantes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `estudiantes` (
  `id_estudiante` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `legajo` varchar(30) DEFAULT NULL,
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
  `id_carrera` int(10) unsigned NOT NULL,
  `id_plan` int(10) unsigned DEFAULT NULL,
  `estado` enum('activo','libre','egresado','abandono','pase','fallecido') NOT NULL DEFAULT 'activo',
  `observaciones` text DEFAULT NULL,
  `certificado_por` int(10) unsigned DEFAULT NULL COMMENT 'Autoridad que certificó el expediente',
  `fecha_certificacion` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_estudiante`),
  UNIQUE KEY `uq_estudiantes_dni` (`dni`),
  UNIQUE KEY `uq_estudiantes_legajo` (`legajo`),
  KEY `idx_estudiantes_apellido` (`apellido`,`nombre`),
  KEY `idx_estudiantes_carrera` (`id_carrera`),
  KEY `idx_estudiantes_plan` (`id_plan`),
  KEY `idx_estudiantes_estado` (`estado`),
  KEY `fk_estudiantes_certificador` (`certificado_por`),
  CONSTRAINT `fk_estudiantes_carrera` FOREIGN KEY (`id_carrera`) REFERENCES `carreras` (`id_carrera`) ON UPDATE CASCADE,
  CONSTRAINT `fk_estudiantes_certificador` FOREIGN KEY (`certificado_por`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_estudiantes_plan` FOREIGN KEY (`id_plan`) REFERENCES `planes` (`id_plan`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estudiantes`
--

LOCK TABLES `estudiantes` WRITE;
/*!40000 ALTER TABLE `estudiantes` DISABLE KEYS */;
/*!40000 ALTER TABLE `estudiantes` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_estudiantes_bd BEFORE DELETE ON estudiantes
FOR EACH ROW
BEGIN
  IF EXISTS (SELECT 1 FROM cursadas WHERE id_estudiante = OLD.id_estudiante)
     OR EXISTS (SELECT 1 FROM examenes_finales WHERE id_estudiante = OLD.id_estudiante)
     OR EXISTS (SELECT 1 FROM tramites WHERE id_estudiante = OLD.id_estudiante) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El alumno tiene historial academico: no se elimina. Darlo de baja cambiando su estado a Abandono.';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_estudiantes_ad AFTER DELETE ON estudiantes
FOR EACH ROW
BEGIN
  INSERT INTO auditoria (id_usuario, tabla, registro_id, accion, datos_anteriores, motivo, fecha)
  VALUES (@id_usuario, 'estudiantes', OLD.id_estudiante, 'DELETE',
          CONCAT('DNI ', OLD.dni, ' - ', OLD.apellido, ', ', OLD.nombre, ' - estado ', OLD.estado, ' - carrera ', OLD.id_carrera),
          @motivo_baja, NOW());
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `examenes_finales`
--

DROP TABLE IF EXISTS `examenes_finales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `examenes_finales` (
  `id_examen` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_estudiante` int(10) unsigned NOT NULL,
  `id_materia` int(10) unsigned NOT NULL,
  `id_submateria` int(10) unsigned DEFAULT NULL COMMENT 'Solo en materias compuestas (cada deporte con su nota, libro y folio)',
  `id_cursada` bigint(20) unsigned DEFAULT NULL,
  `numero_intento` tinyint(3) unsigned NOT NULL DEFAULT 1,
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
  CONSTRAINT `fk_examenes_cursada` FOREIGN KEY (`id_cursada`) REFERENCES `cursadas` (`id_cursada`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_examenes_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_examenes_materia` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON UPDATE CASCADE,
  CONSTRAINT `fk_examenes_submateria` FOREIGN KEY (`id_submateria`) REFERENCES `submaterias` (`id_submateria`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `examenes_finales`
--

LOCK TABLES `examenes_finales` WRITE;
/*!40000 ALTER TABLE `examenes_finales` DISABLE KEYS */;
/*!40000 ALTER TABLE `examenes_finales` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_examenes_submateria_bi BEFORE INSERT ON examenes_finales
FOR EACH ROW
BEGIN
  IF NEW.id_submateria IS NULL AND EXISTS (SELECT 1 FROM submaterias WHERE id_materia = NEW.id_materia) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esta materia se rinde por submateria (deporte): indique cual.';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_examenes_regimen_bi BEFORE INSERT ON examenes_finales
FOR EACH ROW
BEGIN
  IF (SELECT regimen_acreditacion FROM materias WHERE id_materia = NEW.id_materia) = 'promocion' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esta materia solo se acredita por promocion: no tiene examen final. Si no promociono, debe recursar.';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `inscripciones_curso`
--

DROP TABLE IF EXISTS `inscripciones_curso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `inscripciones_curso` (
  `id_inscripcion` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_estudiante` int(10) unsigned NOT NULL,
  `fecha_inscripcion` date NOT NULL,
  `curso` tinyint(3) unsigned NOT NULL,
  `condicion` enum('cursando','recursando') NOT NULL,
  `observaciones` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`id_inscripcion`),
  KEY `fk_inscripcion_estudiante` (`id_estudiante`),
  CONSTRAINT `fk_inscripcion_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inscripciones_curso`
--

LOCK TABLES `inscripciones_curso` WRITE;
/*!40000 ALTER TABLE `inscripciones_curso` DISABLE KEYS */;
/*!40000 ALTER TABLE `inscripciones_curso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `materias`
--

DROP TABLE IF EXISTS `materias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `materias` (
  `id_materia` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_plan` int(10) unsigned NOT NULL,
  `codigo` varchar(10) NOT NULL COMMENT 'N.º de orden en la resolución',
  `nombre` varchar(180) NOT NULL,
  `anio` tinyint(3) unsigned NOT NULL,
  `orden` smallint(5) unsigned NOT NULL DEFAULT 0,
  `regimen_acreditacion` enum('promocion','examen_final','promocion_o_examen_final') NOT NULL DEFAULT 'promocion_o_examen_final',
  `permite_libre` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'Las marcadas con (*) en la resolución',
  `activa` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_materia`),
  UNIQUE KEY `uq_materias_plan_codigo` (`id_plan`,`codigo`),
  KEY `idx_materias_plan_anio` (`id_plan`,`anio`,`orden`),
  CONSTRAINT `fk_materias_plan` FOREIGN KEY (`id_plan`) REFERENCES `planes` (`id_plan`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `materias`
--

LOCK TABLES `materias` WRITE;
/*!40000 ALTER TABLE `materias` DISABLE KEYS */;
INSERT INTO `materias` VALUES
(1,1,'01','Pedagogía',1,1,'promocion_o_examen_final',1,1),
(2,1,'02','Psicología Educacional',1,2,'promocion_o_examen_final',1,1),
(3,1,'03','Alfabetización Académica',1,3,'promocion_o_examen_final',0,1),
(4,1,'04','Didáctica General',1,4,'promocion_o_examen_final',0,1),
(5,1,'11','Anatomía y Fisiología',1,5,'promocion_o_examen_final',0,1),
(6,1,'12','Prácticas Ludomotrices y su Enseñanza',1,6,'promocion_o_examen_final',0,1),
(7,1,'13','Prácticas Gimnásticas y su Enseñanza',1,7,'promocion_o_examen_final',0,1),
(8,1,'14','Prácticas Atléticas y su Enseñanza',1,8,'promocion_o_examen_final',0,1),
(9,1,'15','Prácticas de Recreación y Tiempo Libre y su Enseñanza',1,9,'promocion_o_examen_final',0,1),
(10,1,'32','Práctica I',1,10,'promocion',0,1),
(11,1,'05','Filosofía',2,1,'promocion_o_examen_final',1,1),
(12,1,'06','Historia de las Políticas Educativas en la Argentina',2,2,'promocion_o_examen_final',1,1),
(13,1,'16','Sujeto de la Educación',2,3,'examen_final',0,1),
(14,1,'17','Prácticas Acuáticas y su Enseñanza',2,4,'promocion_o_examen_final',0,1),
(15,1,'18','Prácticas Motrices Expresivas y su Enseñanza',2,5,'promocion_o_examen_final',0,1),
(16,1,'19','Prácticas Deportivas I y su Enseñanza: Vóley',2,6,'promocion_o_examen_final',0,1),
(17,1,'20','Prácticas Deportivas II y su Enseñanza',2,7,'promocion_o_examen_final',0,1),
(18,1,'21','Didáctica de la Educación Física',2,8,'examen_final',0,1),
(19,1,'22','Didáctica de las Prácticas Recreativas y el Tiempo Libre',2,9,'promocion_o_examen_final',0,1),
(20,1,'33','Práctica II',2,10,'promocion',0,1),
(21,1,'07','Educación Sexual Integral',3,1,'promocion_o_examen_final',0,1),
(22,1,'08','Integración de las TIC en la Enseñanza',3,2,'promocion_o_examen_final',0,1),
(23,1,'09','Sociología de la Educación',3,3,'promocion_o_examen_final',0,1),
(24,1,'23','Prácticas Deportivas III y su Enseñanza',3,4,'promocion_o_examen_final',0,1),
(25,1,'24','Prácticas Deportivas IV y su Enseñanza',3,5,'promocion_o_examen_final',0,1),
(26,1,'25','Práctica en la Naturaleza y al Aire Libre y su Enseñanza',3,6,'promocion_o_examen_final',0,1),
(27,1,'26','Entrenamiento para la Actividad Física',3,7,'examen_final',0,1),
(28,1,'27','Historia y Epistemología de la Educación Física',3,8,'promocion_o_examen_final',0,1),
(29,1,'34','Práctica III',3,9,'promocion',0,1),
(30,1,'10','Ética Profesional Docente',4,1,'promocion_o_examen_final',0,1),
(31,1,'28','Educación Física Inclusiva',4,2,'promocion_o_examen_final',0,1),
(32,1,'29','Proyectos de Recreación y Tiempo Libre y su Enseñanza',4,3,'promocion_o_examen_final',0,1),
(33,1,'30','Educación Física y Salud',4,4,'promocion_o_examen_final',0,1),
(34,1,'31','Gestión de Espacios y Organizaciones Deportivas',4,5,'promocion_o_examen_final',0,1),
(35,1,'36','Unidad Curricular de Definición Institucional',4,6,'promocion',0,1),
(36,1,'35','Residencia Pedagógica',4,7,'promocion',0,1);
/*!40000 ALTER TABLE `materias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permisos`
--

DROP TABLE IF EXISTS `permisos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `permisos` (
  `id_permiso` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `codigo` varchar(60) NOT NULL,
  `descripcion` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id_permiso`),
  UNIQUE KEY `uq_permisos_codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permisos`
--

LOCK TABLES `permisos` WRITE;
/*!40000 ALTER TABLE `permisos` DISABLE KEYS */;
INSERT INTO `permisos` VALUES
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
(11,'backups.ejecutar','Generar copias de seguridad'),
(13,'semaforo.ver','Ver el semáforo de documentación'),
(14,'alertas.ver','Ver alertas'),
(15,'respaldos.ver','Ver copias de seguridad'),
(16,'respaldos.editar','Generar copias de seguridad'),
(17,'cuenta.clave','Mostrar «Mi contraseña» en el menú');
/*!40000 ALTER TABLE `permisos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `planes`
--

DROP TABLE IF EXISTS `planes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `planes` (
  `id_plan` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_carrera` int(10) unsigned NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `anio_vigencia` year(4) NOT NULL,
  `resolucion` varchar(150) DEFAULT NULL,
  `activo` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_plan`),
  UNIQUE KEY `uq_planes_carrera_anio` (`id_carrera`,`anio_vigencia`),
  CONSTRAINT `fk_planes_carrera` FOREIGN KEY (`id_carrera`) REFERENCES `carreras` (`id_carrera`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planes`
--

LOCK TABLES `planes` WRITE;
/*!40000 ALTER TABLE `planes` DISABLE KEYS */;
INSERT INTO `planes` VALUES
(1,1,'Plan de Estudios 2020 — Profesorado de Educación Física con orientación en Tiempo Libre y Recreación',2020,'Resolución N° 2281-E-20',1),
(2,2,'Plan de Estudios 2020 — Profesorado de Educación Física',2020,'Resolución N° 2286-E-20',1);
/*!40000 ALTER TABLE `planes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rol_permiso`
--

DROP TABLE IF EXISTS `rol_permiso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `rol_permiso` (
  `rol` varchar(30) NOT NULL,
  `id_permiso` int(10) unsigned NOT NULL,
  `puede_ver` tinyint(4) NOT NULL DEFAULT 1,
  `puede_editar` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`rol`,`id_permiso`),
  KEY `fk_rolpermiso_permiso` (`id_permiso`),
  CONSTRAINT `fk_rolpermiso_permiso` FOREIGN KEY (`id_permiso`) REFERENCES `permisos` (`id_permiso`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rol_permiso`
--

LOCK TABLES `rol_permiso` WRITE;
/*!40000 ALTER TABLE `rol_permiso` DISABLE KEYS */;
INSERT INTO `rol_permiso` VALUES
('admin',3,1,1),
('admin',4,1,1),
('admin',7,1,0),
('admin',8,1,1),
('admin',9,1,0),
('admin',10,1,1),
('admin',11,1,1),
('admin',15,1,0),
('admin',16,1,1),
('admin',17,1,0),
('coordinadora',1,1,0),
('coordinadora',3,1,0),
('coordinadora',4,1,1),
('coordinadora',5,1,0),
('coordinadora',10,1,0),
('coordinadora',11,1,0),
('preceptora',1,1,0),
('preceptora',2,1,1),
('preceptora',3,1,0),
('preceptora',4,1,1),
('preceptora',5,1,0),
('preceptora',6,1,1),
('preceptora',10,1,0),
('preceptora',11,1,0),
('preceptora',13,1,0),
('preceptora',14,1,0),
('vicerrectora',1,1,0),
('vicerrectora',3,1,0),
('vicerrectora',4,1,0),
('vicerrectora',5,1,0),
('vicerrectora',10,1,0),
('vicerrectora',11,1,0);
/*!40000 ALTER TABLE `rol_permiso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `solicitud_clave`
--

DROP TABLE IF EXISTS `solicitud_clave`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `solicitud_clave` (
  `id_solicitud` int(11) NOT NULL AUTO_INCREMENT,
  `id_usuario` int(10) unsigned NOT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `atendida` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_solicitud`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `solicitud_clave_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solicitud_clave`
--

LOCK TABLES `solicitud_clave` WRITE;
/*!40000 ALTER TABLE `solicitud_clave` DISABLE KEYS */;
/*!40000 ALTER TABLE `solicitud_clave` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `submaterias`
--

DROP TABLE IF EXISTS `submaterias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `submaterias` (
  `id_submateria` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_materia` int(10) unsigned NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `orden` smallint(5) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_submateria`),
  UNIQUE KEY `uq_submaterias` (`id_materia`,`nombre`),
  CONSTRAINT `fk_submaterias_materia` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submaterias`
--

LOCK TABLES `submaterias` WRITE;
/*!40000 ALTER TABLE `submaterias` DISABLE KEYS */;
INSERT INTO `submaterias` VALUES
(1,17,'Handbol',1),
(2,17,'Básquet',2),
(3,24,'Hockey',1),
(4,24,'Rugby',2),
(5,24,'Fútbol',3),
(6,25,'Gimnasia',1),
(7,25,'Atletismo',2);
/*!40000 ALTER TABLE `submaterias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipos_documento`
--

DROP TABLE IF EXISTS `tipos_documento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipos_documento` (
  `id_tipo` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(120) NOT NULL,
  `obligatorio` tinyint(4) NOT NULL DEFAULT 1,
  `vence` tinyint(4) NOT NULL DEFAULT 0 COMMENT '1 = se renueva cada año (apto físico y seguro SEMED)',
  `dias_alerta` smallint(5) unsigned NOT NULL DEFAULT 30,
  `orden` smallint(6) NOT NULL DEFAULT 0,
  `activo` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_tipo`),
  UNIQUE KEY `uq_tipos_nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_documento`
--

LOCK TABLES `tipos_documento` WRITE;
/*!40000 ALTER TABLE `tipos_documento` DISABLE KEYS */;
INSERT INTO `tipos_documento` VALUES
(1,'DNI',1,0,0,1,1),
(2,'Título o constancia de título en trámite',1,0,0,2,1),
(3,'Apto físico',1,1,30,3,1),
(4,'Seguro SEMED',1,1,30,4,1);
/*!40000 ALTER TABLE `tipos_documento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tramite_materias`
--

DROP TABLE IF EXISTS `tramite_materias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tramite_materias` (
  `id_tramite` bigint(20) unsigned NOT NULL,
  `id_materia` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id_tramite`,`id_materia`),
  KEY `idx_tm_materia` (`id_materia`),
  CONSTRAINT `fk_tm_materia` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON UPDATE CASCADE,
  CONSTRAINT `fk_tm_tramite` FOREIGN KEY (`id_tramite`) REFERENCES `tramites` (`id_tramite`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tramite_materias`
--

LOCK TABLES `tramite_materias` WRITE;
/*!40000 ALTER TABLE `tramite_materias` DISABLE KEYS */;
/*!40000 ALTER TABLE `tramite_materias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tramites`
--

DROP TABLE IF EXISTS `tramites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tramites` (
  `id_tramite` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_estudiante` int(10) unsigned NOT NULL,
  `tipo` enum('pase','asimilacion','equivalencia','nota_aprobacion') NOT NULL,
  `fecha_solicitud` date NOT NULL,
  `fecha_limite` date DEFAULT NULL COMMENT 'Plazo para resolver (60 días)',
  `estado` enum('en_curso','en_revision','observado','resuelto','rechazado') NOT NULL DEFAULT 'en_curso',
  `nro_resolucion` varchar(50) DEFAULT NULL,
  `fecha_resolucion` date DEFAULT NULL,
  `detalle` text DEFAULT NULL,
  `id_usuario_inicia` int(10) unsigned DEFAULT NULL,
  `id_carrera_origen` int(10) unsigned DEFAULT NULL,
  `id_carrera_destino` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id_tramite`),
  KEY `idx_tramites_estudiante` (`id_estudiante`),
  KEY `idx_tramites_estado` (`estado`,`fecha_limite`),
  KEY `fk_tramites_usuario` (`id_usuario_inicia`),
  KEY `fk_tramites_carrera_origen` (`id_carrera_origen`),
  KEY `fk_tramites_carrera_destino` (`id_carrera_destino`),
  CONSTRAINT `fk_tramites_carrera_destino` FOREIGN KEY (`id_carrera_destino`) REFERENCES `carreras` (`id_carrera`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_tramites_carrera_origen` FOREIGN KEY (`id_carrera_origen`) REFERENCES `carreras` (`id_carrera`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_tramites_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_tramites_usuario` FOREIGN KEY (`id_usuario_inicia`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tramites`
--

LOCK TABLES `tramites` WRITE;
/*!40000 ALTER TABLE `tramites` DISABLE KEYS */;
/*!40000 ALTER TABLE `tramites` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_tramites_bi BEFORE INSERT ON tramites
FOR EACH ROW
BEGIN
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
  
  IF NEW.estado = 'resuelto' AND NEW.tipo IN ('equivalencia', 'asimilacion') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cree el tramite en curso, cargue las materias reconocidas y recien despues resuelvalo.';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_tramites_bu BEFORE UPDATE ON tramites
FOR EACH ROW
BEGIN
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
  
  IF NEW.estado = 'resuelto' AND NEW.tipo IN ('equivalencia', 'asimilacion')
     AND NOT EXISTS (SELECT 1 FROM tramite_materias WHERE id_tramite = NEW.id_tramite) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Una equivalencia o asimilacion resuelta necesita al menos una materia reconocida.';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id_usuario` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(120) NOT NULL,
  `usuario` varchar(60) NOT NULL,
  `clave_hash` varchar(255) NOT NULL COMMENT 'Hash bcrypt (password_hash de PHP); nunca la clave en texto',
  `rol` enum('admin','vicerrectora','coordinadora','preceptora') NOT NULL,
  `id_carrera` int(10) unsigned DEFAULT NULL COMMENT 'Carrera que puede MODIFICAR. NULL = todas. Consultar pueden todos.',
  `activo` tinyint(4) NOT NULL DEFAULT 1,
  `debe_cambiar_clave` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `uq_usuarios_usuario` (`usuario`),
  KEY `idx_usuarios_carrera` (`id_carrera`),
  CONSTRAINT `fk_usuarios_carrera` FOREIGN KEY (`id_carrera`) REFERENCES `carreras` (`id_carrera`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES
(1,'Administrador del Sistema','admin','$2y$10$5TjQV6VMX2WtGPVXRrNP4OQHyoLySYimyxfDkzSSIYXZCKf5fDzT2','admin',NULL,1,1),
(2,'Vicerrectora','vicerrectora','$2y$10$5TjQV6VMX2WtGPVXRrNP4OQHyoLySYimyxfDkzSSIYXZCKf5fDzT2','vicerrectora',NULL,1,1),
(3,'Coordinadora de Educación Física','coordinadora','$2y$10$5TjQV6VMX2WtGPVXRrNP4OQHyoLySYimyxfDkzSSIYXZCKf5fDzT2','coordinadora',NULL,1,1),
(4,'Preceptora Turno Tarde','preceptora.tarde','$2y$10$5TjQV6VMX2WtGPVXRrNP4OQHyoLySYimyxfDkzSSIYXZCKf5fDzT2','preceptora',1,1,1);
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `v_alertas`
--

DROP TABLE IF EXISTS `v_alertas`;
/*!50001 DROP VIEW IF EXISTS `v_alertas`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `v_alertas` AS SELECT
 1 AS `tipo`,
  1 AS `id_estudiante`,
  1 AS `apellido`,
  1 AS `nombre`,
  1 AS `dni`,
  1 AS `id_carrera`,
  1 AS `mensaje`,
  1 AS `semaforo`,
  1 AS `fecha_referencia`,
  1 AS `critico` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_correlatividades_estado`
--

DROP TABLE IF EXISTS `v_correlatividades_estado`;
/*!50001 DROP VIEW IF EXISTS `v_correlatividades_estado`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `v_correlatividades_estado` AS SELECT
 1 AS `id_estudiante`,
  1 AS `apellido`,
  1 AS `nombre`,
  1 AS `dni`,
  1 AS `id_materia_objetivo`,
  1 AS `materia_objetivo`,
  1 AS `tipo_requisito`,
  1 AS `condicion`,
  1 AS `id_materia_requerida`,
  1 AS `materia_requerida`,
  1 AS `estado_requerida`,
  1 AS `cumple` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_documentacion_estado`
--

DROP TABLE IF EXISTS `v_documentacion_estado`;
/*!50001 DROP VIEW IF EXISTS `v_documentacion_estado`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `v_documentacion_estado` AS SELECT
 1 AS `id_estudiante`,
  1 AS `apellido`,
  1 AS `nombre`,
  1 AS `dni`,
  1 AS `id_carrera`,
  1 AS `anio_ingreso`,
  1 AS `id_tipo`,
  1 AS `documento`,
  1 AS `vence`,
  1 AS `estado`,
  1 AS `vence_el` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_documentacion_pendiente`
--

DROP TABLE IF EXISTS `v_documentacion_pendiente`;
/*!50001 DROP VIEW IF EXISTS `v_documentacion_pendiente`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `v_documentacion_pendiente` AS SELECT
 1 AS `id_estudiante`,
  1 AS `apellido`,
  1 AS `nombre`,
  1 AS `dni`,
  1 AS `id_carrera`,
  1 AS `id_tipo`,
  1 AS `documento`,
  1 AS `situacion` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_materia_aprobada`
--

DROP TABLE IF EXISTS `v_materia_aprobada`;
/*!50001 DROP VIEW IF EXISTS `v_materia_aprobada`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `v_materia_aprobada` AS SELECT
 1 AS `id_estudiante`,
  1 AS `id_materia` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_semaforo_documentacion`
--

DROP TABLE IF EXISTS `v_semaforo_documentacion`;
/*!50001 DROP VIEW IF EXISTS `v_semaforo_documentacion`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `v_semaforo_documentacion` AS SELECT
 1 AS `id_estudiante`,
  1 AS `apellido`,
  1 AS `nombre`,
  1 AS `dni`,
  1 AS `id_carrera`,
  1 AS `obligatorios`,
  1 AS `presentados`,
  1 AS `faltan`,
  1 AS `vencidos`,
  1 AS `por_vencer`,
  1 AS `semaforo` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_situacion_academica`
--

DROP TABLE IF EXISTS `v_situacion_academica`;
/*!50001 DROP VIEW IF EXISTS `v_situacion_academica`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `v_situacion_academica` AS SELECT
 1 AS `id_estudiante`,
  1 AS `apellido`,
  1 AS `nombre`,
  1 AS `dni`,
  1 AS `id_carrera`,
  1 AS `id_materia`,
  1 AS `anio`,
  1 AS `orden`,
  1 AS `materia`,
  1 AS `estado_materia`,
  1 AS `aplazos_regular`,
  1 AS `aplazos_libre` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_tramites_pendientes`
--

DROP TABLE IF EXISTS `v_tramites_pendientes`;
/*!50001 DROP VIEW IF EXISTS `v_tramites_pendientes`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `v_tramites_pendientes` AS SELECT
 1 AS `id_tramite`,
  1 AS `id_estudiante`,
  1 AS `apellido`,
  1 AS `nombre`,
  1 AS `dni`,
  1 AS `tipo`,
  1 AS `fecha_solicitud`,
  1 AS `fecha_limite`,
  1 AS `estado`,
  1 AS `dias_restantes`,
  1 AS `situacion`,
  1 AS `id_carrera` */;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'ies4_expedientes_v2'
--

--
-- Final view structure for view `v_alertas`
--

/*!50001 DROP VIEW IF EXISTS `v_alertas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_alertas` AS select 'documentacion' AS `tipo`,`x`.`id_estudiante` AS `id_estudiante`,`x`.`apellido` AS `apellido`,`x`.`nombre` AS `nombre`,`x`.`dni` AS `dni`,`x`.`id_carrera` AS `id_carrera`,case `x`.`estado` when 'falta' then concat('Falta presentar: ',`x`.`documento`) when 'vencido' then concat('Renovar (venció al cierre del ciclo anterior): ',`x`.`documento`) else concat('Vence el ',date_format(`x`.`vence_el`,'%d/%m/%Y'),': ',`x`.`documento`) end AS `mensaje`,case when `x`.`estado` = 'por_vencer' then 'amarillo' else 'rojo' end AS `semaforo`,`x`.`vence_el` AS `fecha_referencia`,case when `x`.`estado` in ('falta','vencido') and (`x`.`anio_ingreso` = year(curdate()) and curdate() > str_to_date(concat(year(curdate()),'-05-31'),'%Y-%m-%d') or month(curdate()) >= 9) then 1 else 0 end AS `critico` from `v_documentacion_estado` `x` where `x`.`estado` in ('falta','vencido','por_vencer') union all select 'tramite' AS `tramite`,`t`.`id_estudiante` AS `id_estudiante`,`t`.`apellido` AS `apellido`,`t`.`nombre` AS `nombre`,`t`.`dni` AS `dni`,`t`.`id_carrera` AS `id_carrera`,concat(case `t`.`situacion` when 'vencido' then 'Plazo vencido: ' else 'Plazo por vencer: ' end,`t`.`tipo`,' (límite ',date_format(`t`.`fecha_limite`,'%d/%m/%Y'),')') AS `Name_exp_7`,case `t`.`situacion` when 'vencido' then 'rojo' else 'amarillo' end AS `CASE t.situacion WHEN 'vencido' THEN 'rojo' ELSE 'amarillo' END`,`t`.`fecha_limite` AS `fecha_limite`,case `t`.`situacion` when 'vencido' then 1 else 0 end AS `CASE t.situacion WHEN 'vencido' THEN 1 ELSE 0 END` from `v_tramites_pendientes` `t` where `t`.`situacion` in ('vencido','por_vencer') union all select 'regularidad' AS `regularidad`,`e`.`id_estudiante` AS `id_estudiante`,`e`.`apellido` AS `apellido`,`e`.`nombre` AS `nombre`,`e`.`dni` AS `dni`,`e`.`id_carrera` AS `id_carrera`,concat(case when `c`.`anio_cursada` + 2 < year(curdate()) then 'Regularidad vencida: ' else 'Último año de regularidad: ' end,`m`.`nombre`,coalesce(concat(' - ',`s`.`nombre`),'')) AS `Name_exp_7`,case when `c`.`anio_cursada` + 2 < year(curdate()) then 'rojo' else 'amarillo' end AS `Name_exp_8`,str_to_date(concat(`c`.`anio_cursada` + 2,'-12-31'),'%Y-%m-%d') AS `STR_TO_DATE(CONCAT(c.anio_cursada + 2, '-12-31'), '%Y-%m-%d')`,case when `c`.`anio_cursada` + 2 < year(curdate()) then 1 else 0 end AS `CASE WHEN c.anio_cursada + 2 < YEAR(CURDATE()) THEN 1 ELSE 0 END` from (((`cursadas` `c` join `estudiantes` `e` on(`e`.`id_estudiante` = `c`.`id_estudiante`)) join `materias` `m` on(`m`.`id_materia` = `c`.`id_materia`)) left join `submaterias` `s` on(`s`.`id_submateria` = `c`.`id_submateria`)) where `c`.`caracter` in ('regular','promocional') and `c`.`anio_cursada` + 2 <= year(curdate()) and `e`.`estado` = 'activo' and !exists(select 1 from `v_materia_aprobada` `a` where `a`.`id_estudiante` = `c`.`id_estudiante` and `a`.`id_materia` = `c`.`id_materia` limit 1) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_correlatividades_estado`
--

/*!50001 DROP VIEW IF EXISTS `v_correlatividades_estado`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_correlatividades_estado` AS select `s`.`id_estudiante` AS `id_estudiante`,`s`.`apellido` AS `apellido`,`s`.`nombre` AS `nombre`,`s`.`dni` AS `dni`,`co`.`id_materia` AS `id_materia_objetivo`,`m`.`nombre` AS `materia_objetivo`,`co`.`tipo_requisito` AS `tipo_requisito`,`co`.`condicion` AS `condicion`,`co`.`id_requerida` AS `id_materia_requerida`,`r`.`nombre` AS `materia_requerida`,`s`.`estado_materia` AS `estado_requerida`,case when `co`.`condicion` = 'aprobada' and `s`.`estado_materia` = 'aprobada' then 1 when `co`.`condicion` = 'regular' and `s`.`estado_materia` in ('regular','aprobada') then 1 else 0 end AS `cumple` from (((`v_situacion_academica` `s` join `correlatividades` `co` on(`co`.`id_requerida` = `s`.`id_materia`)) join `materias` `m` on(`m`.`id_materia` = `co`.`id_materia`)) join `materias` `r` on(`r`.`id_materia` = `co`.`id_requerida`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_documentacion_estado`
--

/*!50001 DROP VIEW IF EXISTS `v_documentacion_estado`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_documentacion_estado` AS select `e`.`id_estudiante` AS `id_estudiante`,`e`.`apellido` AS `apellido`,`e`.`nombre` AS `nombre`,`e`.`dni` AS `dni`,`e`.`id_carrera` AS `id_carrera`,`e`.`anio_ingreso` AS `anio_ingreso`,`t`.`id_tipo` AS `id_tipo`,`t`.`nombre` AS `documento`,`t`.`vence` AS `vence`,case when coalesce(`d`.`cualquiera`,0) = 0 then 'falta' when `t`.`vence` = 0 then 'vigente' when `d`.`este_anio` = 1 then case when curdate() >= str_to_date(concat(year(curdate()),'-12-31'),'%Y-%m-%d') - interval `t`.`dias_alerta` day then 'por_vencer' else 'vigente' end else 'vencido' end AS `estado`,case when `t`.`vence` = 1 and `d`.`este_anio` = 1 then str_to_date(concat(year(curdate()),'-12-31'),'%Y-%m-%d') end AS `vence_el` from ((`estudiantes` `e` join `tipos_documento` `t` on(`t`.`obligatorio` = 1 and `t`.`activo` = 1)) left join (select `documentacion_estudiante`.`id_estudiante` AS `id_estudiante`,`documentacion_estudiante`.`id_tipo` AS `id_tipo`,max(`documentacion_estudiante`.`presentado` = 1) AS `cualquiera`,max(`documentacion_estudiante`.`presentado` = 1 and `documentacion_estudiante`.`anio_lectivo` = year(curdate())) AS `este_anio` from `documentacion_estudiante` group by `documentacion_estudiante`.`id_estudiante`,`documentacion_estudiante`.`id_tipo`) `d` on(`d`.`id_estudiante` = `e`.`id_estudiante` and `d`.`id_tipo` = `t`.`id_tipo`)) where `e`.`estado` = 'activo' */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_documentacion_pendiente`
--

/*!50001 DROP VIEW IF EXISTS `v_documentacion_pendiente`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_documentacion_pendiente` AS select `e`.`id_estudiante` AS `id_estudiante`,`e`.`apellido` AS `apellido`,`e`.`nombre` AS `nombre`,`e`.`dni` AS `dni`,`e`.`id_carrera` AS `id_carrera`,`t`.`id_tipo` AS `id_tipo`,`t`.`nombre` AS `documento`,case when exists(select 1 from `documentacion_estudiante` `d2` where `d2`.`id_estudiante` = `e`.`id_estudiante` and `d2`.`id_tipo` = `t`.`id_tipo` and `d2`.`presentado` = 1 limit 1) then 'vencido' else 'falta' end AS `situacion` from ((`estudiantes` `e` join `tipos_documento` `t` on(`t`.`obligatorio` = 1 and `t`.`activo` = 1)) left join `documentacion_estudiante` `d` on(`d`.`id_estudiante` = `e`.`id_estudiante` and `d`.`id_tipo` = `t`.`id_tipo` and (`t`.`vence` = 0 or `d`.`anio_lectivo` = year(curdate())))) where `e`.`estado` = 'activo' and (`d`.`id_documento` is null or `d`.`presentado` = 0) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_materia_aprobada`
--

/*!50001 DROP VIEW IF EXISTS `v_materia_aprobada`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_materia_aprobada` AS select `x`.`id_estudiante` AS `id_estudiante`,`x`.`id_materia` AS `id_materia` from `examenes_finales` `x` where `x`.`id_submateria` is null and `x`.`estado` = 'presente' and `x`.`nota` >= 4 group by `x`.`id_estudiante`,`x`.`id_materia` union select `x`.`id_estudiante` AS `id_estudiante`,`x`.`id_materia` AS `id_materia` from `examenes_finales` `x` where `x`.`id_submateria` is not null and `x`.`estado` = 'presente' and `x`.`nota` >= 4 group by `x`.`id_estudiante`,`x`.`id_materia` having count(distinct `x`.`id_submateria`) = (select count(0) from `submaterias` `s` where `s`.`id_materia` = `x`.`id_materia`) union select `t`.`id_estudiante` AS `id_estudiante`,`tm`.`id_materia` AS `id_materia` from (`tramites` `t` join `tramite_materias` `tm` on(`tm`.`id_tramite` = `t`.`id_tramite`)) where `t`.`estado` = 'resuelto' and `t`.`tipo` in ('equivalencia','asimilacion') union select `c`.`id_estudiante` AS `id_estudiante`,`c`.`id_materia` AS `id_materia` from `cursadas` `c` where `c`.`caracter` = 'promocional' and `c`.`id_submateria` is null union select `c`.`id_estudiante` AS `id_estudiante`,`c`.`id_materia` AS `id_materia` from `cursadas` `c` where `c`.`caracter` = 'promocional' and `c`.`id_submateria` is not null group by `c`.`id_estudiante`,`c`.`id_materia` having count(distinct `c`.`id_submateria`) = (select count(0) from `submaterias` `s` where `s`.`id_materia` = `c`.`id_materia`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_semaforo_documentacion`
--

/*!50001 DROP VIEW IF EXISTS `v_semaforo_documentacion`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_semaforo_documentacion` AS select `v_documentacion_estado`.`id_estudiante` AS `id_estudiante`,`v_documentacion_estado`.`apellido` AS `apellido`,`v_documentacion_estado`.`nombre` AS `nombre`,`v_documentacion_estado`.`dni` AS `dni`,`v_documentacion_estado`.`id_carrera` AS `id_carrera`,count(0) AS `obligatorios`,sum(`v_documentacion_estado`.`estado` in ('vigente','por_vencer')) AS `presentados`,sum(`v_documentacion_estado`.`estado` = 'falta') AS `faltan`,sum(`v_documentacion_estado`.`estado` = 'vencido') AS `vencidos`,sum(`v_documentacion_estado`.`estado` = 'por_vencer') AS `por_vencer`,case when sum(`v_documentacion_estado`.`estado` in ('falta','vencido')) > 0 then 'rojo' when sum(`v_documentacion_estado`.`estado` = 'por_vencer') > 0 then 'amarillo' else 'verde' end AS `semaforo` from `v_documentacion_estado` group by `v_documentacion_estado`.`id_estudiante`,`v_documentacion_estado`.`apellido`,`v_documentacion_estado`.`nombre`,`v_documentacion_estado`.`dni`,`v_documentacion_estado`.`id_carrera` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_situacion_academica`
--

/*!50001 DROP VIEW IF EXISTS `v_situacion_academica`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_situacion_academica` AS select `e`.`id_estudiante` AS `id_estudiante`,`e`.`apellido` AS `apellido`,`e`.`nombre` AS `nombre`,`e`.`dni` AS `dni`,`e`.`id_carrera` AS `id_carrera`,`m`.`id_materia` AS `id_materia`,`m`.`anio` AS `anio`,`m`.`orden` AS `orden`,`m`.`nombre` AS `materia`,case when exists(select 1 from `v_materia_aprobada` `a` where `a`.`id_estudiante` = `e`.`id_estudiante` and `a`.`id_materia` = `m`.`id_materia` limit 1) then 'aprobada' when exists(select 1 from `cursadas` `c` where `c`.`id_estudiante` = `e`.`id_estudiante` and `c`.`id_materia` = `m`.`id_materia` and `c`.`caracter` in ('regular','promocional') and `c`.`anio_cursada` + 2 >= year(curdate()) limit 1) then 'regular' when exists(select 1 from `cursadas` `c` where `c`.`id_estudiante` = `e`.`id_estudiante` and `c`.`id_materia` = `m`.`id_materia` and `c`.`caracter` is null and `c`.`estado` = 'cursando' limit 1) then 'cursando' when exists(select 1 from `cursadas` `c` where `c`.`id_estudiante` = `e`.`id_estudiante` and `c`.`id_materia` = `m`.`id_materia` and `c`.`caracter` is not null limit 1) then 'libre' else 'pendiente' end AS `estado_materia`,(select count(0) from `examenes_finales` `x` where `x`.`id_estudiante` = `e`.`id_estudiante` and `x`.`id_materia` = `m`.`id_materia` and `x`.`condicion_alumno` = 'regular' and `x`.`estado` = 'presente' and `x`.`nota` < 4) AS `aplazos_regular`,(select count(0) from `examenes_finales` `x` where `x`.`id_estudiante` = `e`.`id_estudiante` and `x`.`id_materia` = `m`.`id_materia` and `x`.`condicion_alumno` = 'libre' and `x`.`estado` = 'presente' and `x`.`nota` < 4) AS `aplazos_libre` from (`estudiantes` `e` join `materias` `m` on(`m`.`id_plan` = `e`.`id_plan` and `m`.`activa` = 1)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_tramites_pendientes`
--

/*!50001 DROP VIEW IF EXISTS `v_tramites_pendientes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_tramites_pendientes` AS select `t`.`id_tramite` AS `id_tramite`,`t`.`id_estudiante` AS `id_estudiante`,`e`.`apellido` AS `apellido`,`e`.`nombre` AS `nombre`,`e`.`dni` AS `dni`,`t`.`tipo` AS `tipo`,`t`.`fecha_solicitud` AS `fecha_solicitud`,`t`.`fecha_limite` AS `fecha_limite`,`t`.`estado` AS `estado`,to_days(`t`.`fecha_limite`) - to_days(curdate()) AS `dias_restantes`,case when `t`.`fecha_limite` is null then 'sin_plazo' when `t`.`fecha_limite` < curdate() then 'vencido' when `t`.`fecha_limite` <= curdate() + interval 7 day then 'por_vencer' else 'en_plazo' end AS `situacion`,`e`.`id_carrera` AS `id_carrera` from (`tramites` `t` join `estudiantes` `e` on(`e`.`id_estudiante` = `t`.`id_estudiante`)) where `t`.`estado` in ('en_curso','en_revision','observado') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-21 16:45:52
