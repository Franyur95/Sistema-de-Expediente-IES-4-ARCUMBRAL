CREATE DATABASE  IF NOT EXISTS `ies4_expedientes_v2` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `ies4_expedientes_v2`;
-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: ies4_expedientes_v2
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `actas_examen`
--

DROP TABLE IF EXISTS `actas_examen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `actas_examen` (
  `id_acta` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_mesa` bigint unsigned DEFAULT NULL,
  `id_materia` int unsigned NOT NULL,
  `fecha` date NOT NULL,
  `libro` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `folio` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nro_acta` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_usuario_carga` int unsigned DEFAULT NULL,
  `observaciones` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_acta`),
  UNIQUE KEY `uq_acta` (`id_materia`,`fecha`,`libro`,`folio`),
  KEY `idx_actas_mesa` (`id_mesa`),
  KEY `fk_actas_usuario` (`id_usuario_carga`),
  CONSTRAINT `fk_actas_materia` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_actas_mesa` FOREIGN KEY (`id_mesa`) REFERENCES `mesas_examen` (`id_mesa`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_actas_usuario` FOREIGN KEY (`id_usuario_carga`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actas_examen`
--

LOCK TABLES `actas_examen` WRITE;
/*!40000 ALTER TABLE `actas_examen` DISABLE KEYS */;
/*!40000 ALTER TABLE `actas_examen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `archivos`
--

DROP TABLE IF EXISTS `archivos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `archivos` (
  `id_archivo` bigint unsigned NOT NULL AUTO_INCREMENT,
  `entidad` enum('estudiante','documento','tramite','resolucion','acta','titulo','otro') COLLATE utf8mb4_general_ci NOT NULL,
  `id_entidad` bigint unsigned DEFAULT NULL,
  `nombre_original` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `nombre_almacenado` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ruta` varchar(500) COLLATE utf8mb4_general_ci NOT NULL,
  `mime` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tamano_bytes` bigint unsigned DEFAULT NULL,
  `hash_sha256` char(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_usuario_subida` int unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_archivo`),
  KEY `idx_archivos_entidad` (`entidad`,`id_entidad`),
  KEY `idx_archivos_hash` (`hash_sha256`),
  KEY `fk_archivos_usuario` (`id_usuario_subida`),
  CONSTRAINT `fk_archivos_usuario` FOREIGN KEY (`id_usuario_subida`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `archivos`
--

LOCK TABLES `archivos` WRITE;
/*!40000 ALTER TABLE `archivos` DISABLE KEYS */;
/*!40000 ALTER TABLE `archivos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `asistencias`
--

DROP TABLE IF EXISTS `asistencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asistencias` (
  `id_asistencia` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_clase` bigint unsigned NOT NULL,
  `id_estudiante` int unsigned NOT NULL,
  `estado` enum('presente','ausente','tarde','justificado') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'presente',
  `observacion` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_asistencia`),
  UNIQUE KEY `uq_asistencia` (`id_clase`,`id_estudiante`),
  KEY `idx_asistencias_estudiante` (`id_estudiante`),
  CONSTRAINT `fk_asistencias_clase` FOREIGN KEY (`id_clase`) REFERENCES `clases` (`id_clase`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_asistencias_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asistencias`
--

LOCK TABLES `asistencias` WRITE;
/*!40000 ALTER TABLE `asistencias` DISABLE KEYS */;
/*!40000 ALTER TABLE `asistencias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auditoria`
--

DROP TABLE IF EXISTS `auditoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditoria` (
  `id_auditoria` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_usuario` int unsigned DEFAULT NULL,
  `tabla` varchar(64) COLLATE utf8mb4_general_ci NOT NULL,
  `registro_id` bigint unsigned DEFAULT NULL,
  `accion` enum('INSERT','UPDATE','DELETE','LOGIN','LOGOUT','EXPORT','BACKUP') COLLATE utf8mb4_general_ci NOT NULL,
  `datos_anteriores` json DEFAULT NULL,
  `datos_nuevos` json DEFAULT NULL,
  `ip` varchar(45) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `user_agent` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `motivo` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
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
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carreras` (
  `id_carrera` int unsigned NOT NULL AUTO_INCREMENT,
  `codigo` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `nombre` varchar(180) COLLATE utf8mb4_general_ci NOT NULL,
  `turno` enum('mañana','tarde','ambos') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'mañana',
  `sede` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Palpalá',
  `resolucion` varchar(150) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `anio_inicio` year DEFAULT NULL,
  `duracion_anios` tinyint unsigned NOT NULL DEFAULT '4',
  `activa` tinyint NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_carrera`),
  UNIQUE KEY `uq_carreras_codigo` (`codigo`),
  KEY `idx_carreras_turno` (`turno`,`activa`),
  CONSTRAINT `chk_carreras_duracion` CHECK ((`duracion_anios` between 1 and 10))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carreras`
--

LOCK TABLES `carreras` WRITE;
/*!40000 ALTER TABLE `carreras` DISABLE KEYS */;
INSERT INTO `carreras` VALUES (1,'EF','Profesorado de Educación Física','mañana','Palpalá','Resolución N° 2286-E-20',2020,4,1,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(2,'EF-TLYR','Profesorado de Educación Física con orientación en Tiempo Libre y Recreación','tarde','Palpalá','Decreto-Resolución N° 13929-E-19',2020,4,1,'2026-10-28 22:07:27','2026-10-28 22:07:27');
/*!40000 ALTER TABLE `carreras` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clases`
--

DROP TABLE IF EXISTS `clases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clases` (
  `id_clase` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_comision` int unsigned NOT NULL,
  `fecha` date NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `tema` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_docente` int unsigned DEFAULT NULL,
  `estado` enum('programada','dictada','suspendida') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'programada',
  `observaciones` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_clase`),
  UNIQUE KEY `uq_clase` (`id_comision`,`fecha`,`hora_inicio`),
  KEY `idx_clases_fecha` (`fecha`),
  KEY `fk_clases_docente` (`id_docente`),
  CONSTRAINT `fk_clases_comision` FOREIGN KEY (`id_comision`) REFERENCES `comisiones` (`id_comision`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_clases_docente` FOREIGN KEY (`id_docente`) REFERENCES `docentes` (`id_docente`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_clases_horas` CHECK ((`hora_fin` > `hora_inicio`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clases`
--

LOCK TABLES `clases` WRITE;
/*!40000 ALTER TABLE `clases` DISABLE KEYS */;
/*!40000 ALTER TABLE `clases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comisiones`
--

DROP TABLE IF EXISTS `comisiones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comisiones` (
  `id_comision` int unsigned NOT NULL AUTO_INCREMENT,
  `id_materia` int unsigned NOT NULL,
  `anio_lectivo` year NOT NULL,
  `nombre` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `turno` enum('mañana','tarde','ambos') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'mañana',
  `aula` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `horario` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cupo` smallint unsigned DEFAULT NULL,
  `id_docente_responsable` int unsigned DEFAULT NULL,
  `activa` tinyint NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_comision`),
  UNIQUE KEY `uq_comisiones` (`id_materia`,`anio_lectivo`,`nombre`),
  KEY `idx_comisiones_materia` (`id_materia`,`anio_lectivo`),
  KEY `fk_comisiones_docente` (`id_docente_responsable`),
  CONSTRAINT `fk_comisiones_docente` FOREIGN KEY (`id_docente_responsable`) REFERENCES `docentes` (`id_docente`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_comisiones_materia` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comisiones`
--

LOCK TABLES `comisiones` WRITE;
/*!40000 ALTER TABLE `comisiones` DISABLE KEYS */;
/*!40000 ALTER TABLE `comisiones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `configuracion`
--

DROP TABLE IF EXISTS `configuracion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `configuracion` (
  `clave` varchar(60) COLLATE utf8mb4_general_ci NOT NULL,
  `valor` text COLLATE utf8mb4_general_ci,
  `tipo` enum('texto','entero','decimal','booleano','fecha') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'texto',
  `grupo` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `descripcion` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`clave`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configuracion`
--

LOCK TABLES `configuracion` WRITE;
/*!40000 ALTER TABLE `configuracion` DISABLE KEYS */;
INSERT INTO `configuracion` VALUES ('anio_lectivo_actual','2026','entero','general','Año lectivo que el sistema toma por defecto','2026-10-28 22:07:27'),('dias_alerta_documentos','30','entero','alertas','Días de anticipación para avisar vencimiento de documentación','2026-10-28 22:07:27'),('dias_alerta_regularidad','30','entero','alertas','Días de anticipación para avisar vencimiento de regularidad','2026-10-28 22:07:27'),('dias_alerta_tramites','7','entero','alertas','Días de anticipación para avisar trámites por vencer','2026-10-28 22:07:27'),('institucion_nombre','Instituto de Educación Superior N.º 4 \"Raúl Scalabrini Ortiz\"','texto','general','Nombre de la institución','2026-10-28 22:07:27'),('institucion_sede','Palpalá','texto','general','Sede que administra el sistema','2026-10-28 22:07:27'),('nota_minima_aprobacion','4','decimal','academico','Nota mínima para aprobar un examen final','2026-10-28 22:07:27'),('nota_minima_promocion','7','decimal','academico','Nota mínima para promocionar una materia','2026-10-28 22:07:27'),('version_sistema','2.0','texto','general','Versión del esquema de base de datos','2026-10-28 22:07:27');
/*!40000 ALTER TABLE `configuracion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contadores`
--

DROP TABLE IF EXISTS `contadores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contadores` (
  `nombre` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `anio` year NOT NULL,
  `ultimo` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`nombre`,`anio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contadores`
--

LOCK TABLES `contadores` WRITE;
/*!40000 ALTER TABLE `contadores` DISABLE KEYS */;
/*!40000 ALTER TABLE `contadores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `correlatividades`
--

DROP TABLE IF EXISTS `correlatividades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `correlatividades` (
  `id_materia` int unsigned NOT NULL,
  `id_requerida` int unsigned NOT NULL,
  `tipo_requisito` enum('cursar','rendir') COLLATE utf8mb4_general_ci NOT NULL,
  `condicion` enum('regular','aprobada') COLLATE utf8mb4_general_ci NOT NULL,
  `observaciones` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_materia`,`id_requerida`,`tipo_requisito`,`condicion`),
  KEY `idx_corr_requerida` (`id_requerida`),
  CONSTRAINT `fk_corr_materia` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_corr_requerida` FOREIGN KEY (`id_requerida`) REFERENCES `materias` (`id_materia`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_corr_rendir` CHECK (((`tipo_requisito` = _utf8mb4'cursar') or (`condicion` = _utf8mb4'aprobada')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `correlatividades`
--

LOCK TABLES `correlatividades` WRITE;
/*!40000 ALTER TABLE `correlatividades` DISABLE KEYS */;
INSERT INTO `correlatividades` VALUES (10,1,'cursar','regular',NULL,'2026-10-28 23:42:43'),(10,1,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(12,2,'cursar','regular',NULL,'2026-10-28 23:42:43'),(12,2,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(12,5,'cursar','regular',NULL,'2026-10-28 23:42:43'),(12,5,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(13,4,'cursar','regular',NULL,'2026-10-28 23:42:43'),(13,4,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(13,6,'cursar','regular',NULL,'2026-10-28 23:42:43'),(13,6,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(14,4,'cursar','regular',NULL,'2026-10-28 23:42:43'),(14,4,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(14,6,'cursar','regular',NULL,'2026-10-28 23:42:43'),(14,6,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(15,4,'cursar','regular',NULL,'2026-10-28 23:42:43'),(15,4,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(15,6,'cursar','regular',NULL,'2026-10-28 23:42:43'),(15,6,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(16,4,'cursar','regular',NULL,'2026-10-28 23:42:43'),(16,4,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(16,6,'cursar','regular',NULL,'2026-10-28 23:42:43'),(16,6,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(17,1,'cursar','regular',NULL,'2026-10-28 23:42:43'),(17,1,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(17,2,'cursar','regular',NULL,'2026-10-28 23:42:43'),(17,2,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(17,4,'cursar','regular',NULL,'2026-10-28 23:42:43'),(17,4,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(18,9,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(18,9,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(20,4,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(20,4,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(20,17,'cursar','regular',NULL,'2026-10-28 23:42:43'),(20,17,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(21,1,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(21,1,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(21,11,'cursar','regular',NULL,'2026-10-28 23:42:43'),(21,11,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(22,7,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(22,7,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(22,8,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(22,8,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(22,15,'cursar','regular',NULL,'2026-10-28 23:42:43'),(22,15,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(22,16,'cursar','regular',NULL,'2026-10-28 23:42:43'),(22,16,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(22,17,'cursar','regular',NULL,'2026-10-28 23:42:43'),(22,17,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(23,7,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(23,7,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(23,8,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(23,8,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(23,15,'cursar','regular',NULL,'2026-10-28 23:42:43'),(23,15,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(23,16,'cursar','regular',NULL,'2026-10-28 23:42:43'),(23,16,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(23,17,'cursar','regular',NULL,'2026-10-28 23:42:43'),(23,17,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(24,6,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(24,6,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(24,12,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(24,12,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(24,13,'cursar','regular',NULL,'2026-10-28 23:42:43'),(24,13,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(24,14,'cursar','regular',NULL,'2026-10-28 23:42:43'),(24,14,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(25,5,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(25,5,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(25,7,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(25,7,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(25,8,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(25,8,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(25,15,'cursar','regular',NULL,'2026-10-28 23:42:43'),(25,15,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(25,16,'cursar','regular',NULL,'2026-10-28 23:42:43'),(25,16,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(26,10,'cursar','regular',NULL,'2026-10-28 23:42:43'),(26,10,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(26,11,'cursar','regular',NULL,'2026-10-28 23:42:43'),(26,11,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(27,6,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(27,6,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(27,7,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(27,7,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(27,8,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(27,8,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(27,13,'cursar','regular',NULL,'2026-10-28 23:42:43'),(27,13,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(27,14,'cursar','regular',NULL,'2026-10-28 23:42:43'),(27,14,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(27,15,'cursar','regular',NULL,'2026-10-28 23:42:43'),(27,15,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(27,16,'cursar','regular',NULL,'2026-10-28 23:42:43'),(27,16,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(27,17,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(27,17,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(27,18,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(27,18,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(28,10,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(28,10,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(29,5,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(29,5,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(29,6,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(29,6,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(29,14,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(29,14,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(29,19,'cursar','regular',NULL,'2026-10-28 23:42:43'),(29,19,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(30,6,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(30,6,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(30,24,'cursar','regular',NULL,'2026-10-28 23:42:43'),(30,24,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(31,25,'cursar','regular',NULL,'2026-10-28 23:42:43'),(31,25,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(32,26,'cursar','regular',NULL,'2026-10-28 23:42:43'),(32,26,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(33,1,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(33,1,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(33,2,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(33,2,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(33,3,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(33,3,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(33,4,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(33,4,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(33,5,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(33,5,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(33,6,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(33,6,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(33,7,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(33,7,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(33,8,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(33,8,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(33,9,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(33,9,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(34,1,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(34,1,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(34,2,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(34,2,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(34,3,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(34,3,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(34,4,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(34,4,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(34,5,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(34,5,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(34,6,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(34,6,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(34,7,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(34,7,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(34,8,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(34,8,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(34,9,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(34,9,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(34,10,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(34,10,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(34,11,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(34,11,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(34,12,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(34,12,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(34,13,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(34,13,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(34,14,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(34,14,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(34,15,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(34,15,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(34,16,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(34,16,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(34,17,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(34,17,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(34,18,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(34,18,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(34,19,'cursar','regular',NULL,'2026-10-28 23:42:43'),(34,19,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(34,20,'cursar','regular',NULL,'2026-10-28 23:42:43'),(34,20,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(34,21,'cursar','regular',NULL,'2026-10-28 23:42:43'),(34,21,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(34,22,'cursar','regular',NULL,'2026-10-28 23:42:43'),(34,22,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(34,23,'cursar','regular',NULL,'2026-10-28 23:42:43'),(34,23,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(34,24,'cursar','regular',NULL,'2026-10-28 23:42:43'),(34,24,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(34,25,'cursar','regular',NULL,'2026-10-28 23:42:43'),(34,25,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(34,26,'cursar','regular',NULL,'2026-10-28 23:42:43'),(34,26,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(34,27,'cursar','regular',NULL,'2026-10-28 23:42:43'),(34,27,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(34,27,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(45,35,'cursar','regular',NULL,'2026-10-28 23:42:43'),(45,35,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(47,36,'cursar','regular',NULL,'2026-10-28 23:42:43'),(47,36,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(47,39,'cursar','regular',NULL,'2026-10-28 23:42:43'),(47,39,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(48,38,'cursar','regular',NULL,'2026-10-28 23:42:43'),(48,38,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(48,40,'cursar','regular',NULL,'2026-10-28 23:42:43'),(48,40,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(49,38,'cursar','regular',NULL,'2026-10-28 23:42:43'),(49,38,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(49,40,'cursar','regular',NULL,'2026-10-28 23:42:43'),(49,40,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(50,38,'cursar','regular',NULL,'2026-10-28 23:42:43'),(50,38,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(50,40,'cursar','regular',NULL,'2026-10-28 23:42:43'),(50,40,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(51,38,'cursar','regular',NULL,'2026-10-28 23:42:43'),(51,38,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(51,40,'cursar','regular',NULL,'2026-10-28 23:42:43'),(51,40,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(52,35,'cursar','regular',NULL,'2026-10-28 23:42:43'),(52,35,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(52,36,'cursar','regular',NULL,'2026-10-28 23:42:43'),(52,36,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(52,38,'cursar','regular',NULL,'2026-10-28 23:42:43'),(52,38,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(53,38,'cursar','regular',NULL,'2026-10-28 23:42:43'),(53,38,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(53,43,'cursar','regular',NULL,'2026-10-28 23:42:43'),(53,43,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(54,44,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(54,44,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(56,38,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(56,38,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(57,35,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(57,35,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(57,46,'cursar','regular',NULL,'2026-10-28 23:42:43'),(57,46,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(58,41,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(58,41,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(58,42,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(58,42,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(58,49,'cursar','regular',NULL,'2026-10-28 23:42:43'),(58,49,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(58,50,'cursar','regular',NULL,'2026-10-28 23:42:43'),(58,50,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(58,51,'cursar','regular',NULL,'2026-10-28 23:42:43'),(58,51,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(59,41,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(59,41,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(59,42,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(59,42,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(59,49,'cursar','regular',NULL,'2026-10-28 23:42:43'),(59,49,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(59,50,'cursar','regular',NULL,'2026-10-28 23:42:43'),(59,50,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(59,51,'cursar','regular',NULL,'2026-10-28 23:42:43'),(59,51,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(60,40,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(60,40,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(60,43,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(60,43,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(60,47,'cursar','regular',NULL,'2026-10-28 23:42:43'),(60,48,'cursar','regular',NULL,'2026-10-28 23:42:43'),(60,48,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(60,53,'cursar','regular',NULL,'2026-10-28 23:42:43'),(61,39,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(61,39,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(61,41,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(61,41,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(61,42,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(61,42,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(61,49,'cursar','regular',NULL,'2026-10-28 23:42:43'),(61,49,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(61,50,'cursar','regular',NULL,'2026-10-28 23:42:43'),(61,50,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(62,45,'cursar','regular',NULL,'2026-10-28 23:42:43'),(62,45,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(62,46,'cursar','regular',NULL,'2026-10-28 23:42:43'),(62,46,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(63,40,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(63,40,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(63,41,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(63,41,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(63,42,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(63,42,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(63,47,'cursar','regular',NULL,'2026-10-28 23:42:43'),(63,47,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(63,48,'cursar','regular',NULL,'2026-10-28 23:42:43'),(63,48,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(63,49,'cursar','regular',NULL,'2026-10-28 23:42:43'),(63,49,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(63,50,'cursar','regular',NULL,'2026-10-28 23:42:43'),(63,50,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(63,51,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(63,51,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(63,54,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(63,54,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(64,45,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(64,45,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(65,39,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(65,39,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(65,40,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(65,40,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(65,48,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(65,48,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(65,55,'cursar','regular',NULL,'2026-10-28 23:42:43'),(65,55,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(66,40,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(66,40,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(66,58,'cursar','regular',NULL,'2026-10-28 23:42:43'),(66,58,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(67,59,'cursar','regular',NULL,'2026-10-28 23:42:43'),(67,59,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(68,60,'cursar','regular',NULL,'2026-10-28 23:42:43'),(68,60,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(69,35,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(69,35,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(69,36,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(69,36,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(69,37,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(69,37,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(69,38,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(69,38,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(69,39,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(69,39,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(69,40,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(69,40,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(69,41,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(69,41,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(69,42,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(69,42,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(69,43,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(69,43,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(69,44,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(69,44,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(70,35,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(70,35,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(70,36,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(70,36,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(70,37,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(70,37,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(70,38,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(70,38,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(70,39,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(70,39,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(70,40,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(70,40,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(70,41,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(70,41,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(70,42,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(70,42,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(70,43,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(70,43,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(70,44,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(70,44,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(70,45,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(70,45,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(70,46,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(70,46,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(70,47,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(70,47,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(70,48,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(70,48,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(70,49,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(70,49,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(70,50,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(70,50,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(70,51,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(70,51,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(70,52,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(70,52,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(70,53,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(70,53,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(70,54,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(70,54,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(70,55,'cursar','regular',NULL,'2026-10-28 23:42:43'),(70,55,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(70,56,'cursar','regular',NULL,'2026-10-28 23:42:43'),(70,56,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(70,57,'cursar','regular',NULL,'2026-10-28 23:42:43'),(70,57,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(70,58,'cursar','regular',NULL,'2026-10-28 23:42:43'),(70,58,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(70,59,'cursar','regular',NULL,'2026-10-28 23:42:43'),(70,59,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(70,60,'cursar','regular',NULL,'2026-10-28 23:42:43'),(70,60,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(70,61,'cursar','regular',NULL,'2026-10-28 23:42:43'),(70,61,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(70,62,'cursar','regular',NULL,'2026-10-28 23:42:43'),(70,62,'rendir','aprobada',NULL,'2026-10-28 23:42:43'),(70,63,'cursar','regular',NULL,'2026-10-28 23:42:43'),(70,63,'cursar','aprobada',NULL,'2026-10-28 23:42:43'),(70,63,'rendir','aprobada',NULL,'2026-10-28 23:42:43');
/*!40000 ALTER TABLE `correlatividades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cursadas`
--

DROP TABLE IF EXISTS `cursadas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cursadas` (
  `id_cursada` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_estudiante` int unsigned NOT NULL,
  `id_materia` int unsigned NOT NULL,
  `id_comision` int unsigned DEFAULT NULL,
  `anio_cursada` year NOT NULL,
  `fecha` date DEFAULT NULL COMMENT 'Fecha de cursada / cierre',
  `fecha_inscripcion` date DEFAULT NULL,
  `tipo_inscripcion` enum('cursar','recursar','libre') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'cursar',
  `caracter` enum('regular','libre','promocional') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `asistencia` decimal(5,2) DEFAULT NULL COMMENT '% de asistencia',
  `tp` decimal(5,2) DEFAULT NULL COMMENT '% de trabajos prácticos',
  `parciales_cantidad` tinyint unsigned DEFAULT NULL,
  `promedio` decimal(4,2) DEFAULT NULL,
  `nota_general` decimal(4,2) DEFAULT NULL COMMENT 'Promedio ponderado de submaterias',
  `nota_definitiva` decimal(4,2) DEFAULT NULL,
  `fecha_regularidad` date DEFAULT NULL,
  `fecha_vencimiento_regularidad` date DEFAULT NULL,
  `estado` enum('cursando','regular','libre','promocional','aprobada','desaprobada','abandonada') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'cursando',
  `observaciones` text COLLATE utf8mb4_general_ci,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_cursada`),
  UNIQUE KEY `uq_cursadas` (`id_estudiante`,`id_materia`,`anio_cursada`),
  KEY `idx_cursadas_estudiante` (`id_estudiante`),
  KEY `idx_cursadas_materia` (`id_materia`,`anio_cursada`),
  KEY `idx_cursadas_comision` (`id_comision`),
  KEY `idx_cursadas_estado` (`estado`),
  CONSTRAINT `fk_cursadas_comision` FOREIGN KEY (`id_comision`) REFERENCES `comisiones` (`id_comision`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_cursadas_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cursadas_materia` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_cursadas_asistencia` CHECK (((`asistencia` is null) or (`asistencia` between 0 and 100))),
  CONSTRAINT `chk_cursadas_nota_definitiva` CHECK (((`nota_definitiva` is null) or (`nota_definitiva` between 0 and 10))),
  CONSTRAINT `chk_cursadas_nota_general` CHECK (((`nota_general` is null) or (`nota_general` between 0 and 10))),
  CONSTRAINT `chk_cursadas_promedio` CHECK (((`promedio` is null) or (`promedio` between 0 and 10))),
  CONSTRAINT `chk_cursadas_regularidad` CHECK (((`fecha_vencimiento_regularidad` is null) or (`fecha_regularidad` is null) or (`fecha_vencimiento_regularidad` >= `fecha_regularidad`))),
  CONSTRAINT `chk_cursadas_tp` CHECK (((`tp` is null) or (`tp` between 0 and 100)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cursadas`
--

LOCK TABLES `cursadas` WRITE;
/*!40000 ALTER TABLE `cursadas` DISABLE KEYS */;
/*!40000 ALTER TABLE `cursadas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cursadas_parciales`
--

DROP TABLE IF EXISTS `cursadas_parciales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cursadas_parciales` (
  `id_parcial` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_cursada` bigint unsigned NOT NULL,
  `numero` tinyint unsigned NOT NULL,
  `tipo` enum('parcial','recuperatorio','tp','unidad','examen') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'parcial',
  `nota` decimal(4,2) DEFAULT NULL,
  `peso` decimal(5,2) NOT NULL DEFAULT '1.00',
  `fecha` date DEFAULT NULL,
  `id_docente` int unsigned DEFAULT NULL,
  `observaciones` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_parcial`),
  UNIQUE KEY `uq_parcial` (`id_cursada`,`tipo`,`numero`),
  KEY `idx_parcial_cursada` (`id_cursada`),
  KEY `fk_parcial_docente` (`id_docente`),
  CONSTRAINT `fk_parcial_cursada` FOREIGN KEY (`id_cursada`) REFERENCES `cursadas` (`id_cursada`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_parcial_docente` FOREIGN KEY (`id_docente`) REFERENCES `docentes` (`id_docente`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_parcial_nota` CHECK (((`nota` is null) or (`nota` between 0 and 10))),
  CONSTRAINT `chk_parcial_peso` CHECK ((`peso` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cursadas_parciales`
--

LOCK TABLES `cursadas_parciales` WRITE;
/*!40000 ALTER TABLE `cursadas_parciales` DISABLE KEYS */;
/*!40000 ALTER TABLE `cursadas_parciales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cursadas_submaterias`
--

DROP TABLE IF EXISTS `cursadas_submaterias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cursadas_submaterias` (
  `id_cursada_sub` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_cursada` bigint unsigned NOT NULL,
  `id_submateria` int unsigned NOT NULL,
  `nota` decimal(4,2) DEFAULT NULL COMMENT 'Nota final de la sub-materia',
  `promedio` decimal(4,2) DEFAULT NULL,
  `asistencia` decimal(5,2) DEFAULT NULL,
  `tp` decimal(5,2) DEFAULT NULL,
  `condicion` enum('regular','libre','promocional') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `observaciones` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_cursada_sub`),
  UNIQUE KEY `uq_cursada_submateria` (`id_cursada`,`id_submateria`),
  KEY `idx_cs_submateria` (`id_submateria`),
  CONSTRAINT `fk_cs_cursada` FOREIGN KEY (`id_cursada`) REFERENCES `cursadas` (`id_cursada`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cs_submateria` FOREIGN KEY (`id_submateria`) REFERENCES `submaterias` (`id_submateria`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_cs_asistencia` CHECK (((`asistencia` is null) or (`asistencia` between 0 and 100))),
  CONSTRAINT `chk_cs_nota` CHECK (((`nota` is null) or (`nota` between 0 and 10))),
  CONSTRAINT `chk_cs_promedio` CHECK (((`promedio` is null) or (`promedio` between 0 and 10))),
  CONSTRAINT `chk_cs_tp` CHECK (((`tp` is null) or (`tp` between 0 and 100)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cursadas_submaterias`
--

LOCK TABLES `cursadas_submaterias` WRITE;
/*!40000 ALTER TABLE `cursadas_submaterias` DISABLE KEYS */;
/*!40000 ALTER TABLE `cursadas_submaterias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `docentes`
--

DROP TABLE IF EXISTS `docentes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `docentes` (
  `id_docente` int unsigned NOT NULL AUTO_INCREMENT,
  `apellido` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `nombre` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `dni` varchar(15) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(120) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `telefono` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `titulo` varchar(150) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `activo` tinyint NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_docente`),
  UNIQUE KEY `uq_docentes_dni` (`dni`),
  KEY `idx_docentes_apellido` (`apellido`,`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `docentes`
--

LOCK TABLES `docentes` WRITE;
/*!40000 ALTER TABLE `docentes` DISABLE KEYS */;
/*!40000 ALTER TABLE `docentes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `documentacion_estudiante`
--

DROP TABLE IF EXISTS `documentacion_estudiante`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentacion_estudiante` (
  `id_documento` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_estudiante` int unsigned NOT NULL,
  `id_tipo` int unsigned NOT NULL,
  `anio_lectivo` year DEFAULT NULL COMMENT 'Si no se envía, el trigger usa el año de ingreso',
  `presentado` tinyint NOT NULL DEFAULT '0',
  `fecha_presentacion` date DEFAULT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  `archivo_id` bigint unsigned DEFAULT NULL,
  `observaciones` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_usuario_registro` int unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_documento`),
  UNIQUE KEY `uq_doc_estudiante_tipo_anio` (`id_estudiante`,`id_tipo`,`anio_lectivo`),
  KEY `idx_doc_tipo` (`id_tipo`),
  KEY `idx_doc_vencimiento` (`fecha_vencimiento`),
  KEY `fk_doc_archivo` (`archivo_id`),
  KEY `fk_doc_usuario` (`id_usuario_registro`),
  CONSTRAINT `fk_doc_archivo` FOREIGN KEY (`archivo_id`) REFERENCES `archivos` (`id_archivo`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_doc_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_doc_tipo` FOREIGN KEY (`id_tipo`) REFERENCES `tipos_documento` (`id_tipo`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_doc_usuario` FOREIGN KEY (`id_usuario_registro`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_doc_fechas` CHECK (((`fecha_vencimiento` is null) or (`fecha_presentacion` is null) or (`fecha_vencimiento` >= `fecha_presentacion`)))
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
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estudiantes` (
  `id_estudiante` int unsigned NOT NULL AUTO_INCREMENT,
  `legajo` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipo_documento` enum('DNI','LC','LE','PASAPORTE') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'DNI',
  `dni` varchar(15) COLLATE utf8mb4_general_ci NOT NULL,
  `apellido` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `nombre` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `lugar_nacimiento` varchar(150) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nacionalidad` varchar(60) COLLATE utf8mb4_general_ci DEFAULT 'Argentina',
  `domicilio` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `localidad` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `provincia` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `codigo_postal` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `telefono` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `telefono_alternativo` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(120) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `titulo_ingreso` varchar(150) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipo_titulo` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `establecimiento` varchar(150) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `anio_ingreso` year DEFAULT NULL,
  `fecha_ingreso` date DEFAULT NULL,
  `id_carrera` int unsigned NOT NULL,
  `id_plan` int unsigned DEFAULT NULL,
  `estado` enum('activo','libre','egresado','abandono','pase','fallecido') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'activo',
  `observaciones` text COLLATE utf8mb4_general_ci,
  `certificado_por` int unsigned DEFAULT NULL,
  `fecha_certificacion` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_estudiante`),
  UNIQUE KEY `uq_estudiantes_dni` (`dni`),
  UNIQUE KEY `uq_estudiantes_legajo` (`legajo`),
  KEY `idx_estudiantes_apellido` (`apellido`,`nombre`),
  KEY `idx_estudiantes_carrera` (`id_carrera`),
  KEY `idx_estudiantes_plan` (`id_plan`),
  KEY `idx_estudiantes_estado` (`estado`),
  KEY `fk_estudiantes_certificador` (`certificado_por`),
  CONSTRAINT `fk_estudiantes_carrera` FOREIGN KEY (`id_carrera`) REFERENCES `carreras` (`id_carrera`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_estudiantes_certificador` FOREIGN KEY (`certificado_por`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_estudiantes_plan` FOREIGN KEY (`id_plan`) REFERENCES `planes` (`id_plan`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_estudiantes_anio` CHECK (((`anio_ingreso` is null) or (`anio_ingreso` between 1950 and 2100)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estudiantes`
--

LOCK TABLES `estudiantes` WRITE;
/*!40000 ALTER TABLE `estudiantes` DISABLE KEYS */;
/*!40000 ALTER TABLE `estudiantes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `examenes_finales`
--

DROP TABLE IF EXISTS `examenes_finales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `examenes_finales` (
  `id_examen` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_estudiante` int unsigned NOT NULL,
  `id_materia` int unsigned NOT NULL,
  `id_cursada` bigint unsigned DEFAULT NULL,
  `id_mesa` bigint unsigned DEFAULT NULL,
  `id_inscripcion` bigint unsigned DEFAULT NULL,
  `id_acta` bigint unsigned DEFAULT NULL,
  `numero_intento` tinyint unsigned NOT NULL DEFAULT '1',
  `condicion_alumno` enum('regular','libre','promocion') COLLATE utf8mb4_general_ci NOT NULL,
  `fecha` date NOT NULL,
  `nota` decimal(4,2) DEFAULT NULL,
  `estado` enum('presente','ausente') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'presente',
  `libro` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `folio` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `observacion` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_examen`),
  UNIQUE KEY `uq_examen` (`id_estudiante`,`id_materia`,`fecha`),
  KEY `idx_examenes_estudiante` (`id_estudiante`),
  KEY `idx_examenes_materia` (`id_materia`,`fecha`),
  KEY `fk_examenes_cursada` (`id_cursada`),
  KEY `fk_examenes_mesa` (`id_mesa`),
  KEY `fk_examenes_inscripcion` (`id_inscripcion`),
  KEY `fk_examenes_acta` (`id_acta`),
  CONSTRAINT `fk_examenes_acta` FOREIGN KEY (`id_acta`) REFERENCES `actas_examen` (`id_acta`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_examenes_cursada` FOREIGN KEY (`id_cursada`) REFERENCES `cursadas` (`id_cursada`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_examenes_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_examenes_inscripcion` FOREIGN KEY (`id_inscripcion`) REFERENCES `inscripciones_mesa` (`id_inscripcion`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_examenes_materia` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_examenes_mesa` FOREIGN KEY (`id_mesa`) REFERENCES `mesas_examen` (`id_mesa`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_examenes_intento` CHECK ((`numero_intento` between 1 and 10)),
  CONSTRAINT `chk_examenes_nota` CHECK (((`nota` is null) or (`nota` between 0 and 10)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `examenes_finales`
--

LOCK TABLES `examenes_finales` WRITE;
/*!40000 ALTER TABLE `examenes_finales` DISABLE KEYS */;
/*!40000 ALTER TABLE `examenes_finales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inscripciones_mesa`
--

DROP TABLE IF EXISTS `inscripciones_mesa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inscripciones_mesa` (
  `id_inscripcion` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_mesa` bigint unsigned NOT NULL,
  `id_estudiante` int unsigned NOT NULL,
  `condicion` enum('regular','libre','promocion') COLLATE utf8mb4_general_ci NOT NULL,
  `fecha_inscripcion` date NOT NULL,
  `estado` enum('inscripto','presente','ausente','aprobado','desaprobado') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'inscripto',
  `nota` decimal(4,2) DEFAULT NULL,
  `observaciones` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_inscripcion`),
  UNIQUE KEY `uq_inscripcion_mesa` (`id_mesa`,`id_estudiante`),
  KEY `idx_inscripciones_estudiante` (`id_estudiante`),
  CONSTRAINT `fk_inscripciones_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_inscripciones_mesa` FOREIGN KEY (`id_mesa`) REFERENCES `mesas_examen` (`id_mesa`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_inscripciones_nota` CHECK (((`nota` is null) or (`nota` between 0 and 10)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inscripciones_mesa`
--

LOCK TABLES `inscripciones_mesa` WRITE;
/*!40000 ALTER TABLE `inscripciones_mesa` DISABLE KEYS */;
/*!40000 ALTER TABLE `inscripciones_mesa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `materias`
--

DROP TABLE IF EXISTS `materias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `materias` (
  `id_materia` int unsigned NOT NULL AUTO_INCREMENT,
  `id_plan` int unsigned NOT NULL,
  `codigo` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `nombre` varchar(180) COLLATE utf8mb4_general_ci NOT NULL,
  `anio` tinyint unsigned NOT NULL,
  `orden` smallint unsigned NOT NULL DEFAULT '0',
  `tipo_espacio` enum('materia','taller','seminario','trabajo_de_campo','practica_docente') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'materia',
  `campo_formacion` enum('general','especifica','practica_profesional') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'general',
  `periodo` enum('anual','1C','2C') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'anual',
  `horas_semanales` decimal(4,1) DEFAULT NULL,
  `horas_totales` smallint unsigned DEFAULT NULL,
  `regimen_acreditacion` enum('promocion','examen_final','promocion_o_examen_final') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'promocion_o_examen_final',
  `permite_libre` tinyint NOT NULL DEFAULT '0',
  `grupo_calificacion` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'LEGACY v1: reemplazado por submaterias',
  `activa` tinyint NOT NULL DEFAULT '1',
  `observaciones` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_materia`),
  UNIQUE KEY `uq_materias_plan_codigo` (`id_plan`,`codigo`),
  KEY `idx_materias_plan_anio` (`id_plan`,`anio`,`orden`),
  CONSTRAINT `fk_materias_plan` FOREIGN KEY (`id_plan`) REFERENCES `planes` (`id_plan`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_materias_anio` CHECK ((`anio` between 1 and 4)),
  CONSTRAINT `chk_materias_horas` CHECK ((((`horas_semanales` is null) or (`horas_semanales` >= 0)) and ((`horas_totales` is null) or (`horas_totales` >= 0))))
) ENGINE=InnoDB AUTO_INCREMENT=128 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `materias`
--

LOCK TABLES `materias` WRITE;
/*!40000 ALTER TABLE `materias` DISABLE KEYS */;
INSERT INTO `materias` VALUES (1,1,'01','Pedagogía',1,1,'materia','general','anual',4.0,128,'promocion_o_examen_final',1,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(2,1,'02','Psicología Educacional',1,2,'materia','general','anual',4.0,128,'promocion_o_examen_final',1,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(3,1,'03','Alfabetización Académica',1,3,'taller','general','1C',4.0,64,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(4,1,'04','Didáctica General',1,4,'materia','general','anual',4.0,128,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(5,1,'11','Anatomía y Fisiología',1,5,'materia','especifica','anual',4.0,128,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(6,1,'12','Prácticas Ludomotrices y su Enseñanza',1,6,'taller','especifica','anual',4.0,64,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(7,1,'13','Prácticas Gimnásticas y su Enseñanza',1,7,'taller','especifica','anual',4.0,128,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(8,1,'14','Prácticas Atléticas y su Enseñanza',1,8,'taller','especifica','anual',4.0,128,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(9,1,'30','Práctica I',1,9,'trabajo_de_campo','practica_profesional','anual',4.0,128,'promocion',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(10,1,'05','Filosofía',2,1,'materia','general','anual',4.0,128,'promocion_o_examen_final',1,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(11,1,'06','Historia de las Políticas Educativas en la Argentina',2,2,'seminario','general','anual',4.0,128,'promocion_o_examen_final',1,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(12,1,'15','Sujeto de la Educación',2,3,'materia','especifica','anual',4.0,128,'examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(13,1,'16','Prácticas Acuáticas y su Enseñanza',2,4,'taller','especifica','1C',4.0,64,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(14,1,'17','Prácticas Motrices Expresivas y su Enseñanza',2,5,'taller','especifica','1C',4.0,64,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(15,1,'18','Prácticas Deportivas I y su Enseñanza',2,6,'taller','especifica','anual',4.0,128,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(16,1,'19','Prácticas Deportivas II y su Enseñanza',2,7,'taller','especifica','anual',4.0,128,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(17,1,'20','Didáctica de la Educación Física',2,8,'materia','especifica','anual',4.0,128,'examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(18,1,'31','Práctica II',2,9,'trabajo_de_campo','practica_profesional','anual',4.0,128,'promocion',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(19,1,'07','Educación Sexual Integral',3,1,'seminario','general','1C',4.0,64,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(20,1,'08','Integración de las TIC en la Enseñanza',3,2,'taller','general','1C',4.0,64,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(21,1,'09','Sociología de la Educación',3,3,'seminario','general','anual',4.0,64,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(22,1,'21','Prácticas Deportivas III y su Enseñanza',3,4,'taller','especifica','anual',4.0,128,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(23,1,'22','Prácticas Deportivas IV y su Enseñanza',3,5,'taller','especifica','anual',4.0,128,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(24,1,'23','Práctica en la Naturaleza y al Aire Libre y su Enseñanza',3,6,'taller','especifica','anual',4.0,128,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(25,1,'24','Entrenamiento para la Actividad Física',3,7,'taller','especifica','anual',4.0,128,'examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(26,1,'25','Historia y Epistemología de la Educación Física',3,8,'materia','especifica','anual',4.0,64,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(27,1,'32','Práctica III',3,9,'practica_docente','practica_profesional','anual',6.0,192,'promocion',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(28,1,'10','Ética Profesional Docente',4,1,'seminario','general','anual',4.0,64,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(29,1,'26','Educación Física Inclusiva',4,2,'taller','especifica','anual',4.0,128,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(30,1,'27','Prácticas de Recreación y Tiempo Libre y su Enseñanza',4,3,'taller','especifica','anual',4.0,128,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(31,1,'28','Educación Física y Salud',4,4,'taller','especifica','anual',4.0,128,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(32,1,'29','Gestión de Espacios y Organizaciones Deportivas',4,5,'taller','especifica','anual',4.0,64,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(33,1,'34','Unidad de Definición Institucional',4,6,'taller','general','anual',4.0,64,'promocion',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(34,1,'33','Residencia Pedagógica',4,7,'practica_docente','practica_profesional','anual',12.0,384,'promocion',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(35,2,'01','Pedagogía',1,1,'materia','general','anual',4.0,128,'promocion_o_examen_final',1,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(36,2,'02','Psicología Educacional',1,2,'materia','general','anual',4.0,128,'promocion_o_examen_final',1,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(37,2,'03','Alfabetización Académica',1,3,'taller','general','1C',4.0,64,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(38,2,'04','Didáctica General',1,4,'materia','general','anual',4.0,128,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(39,2,'11','Anatomía y Fisiología',1,5,'materia','especifica','anual',4.0,128,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(40,2,'12','Prácticas Ludomotrices y su Enseñanza',1,6,'taller','especifica','anual',4.0,64,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(41,2,'13','Prácticas Gimnásticas y su Enseñanza',1,7,'taller','especifica','anual',4.0,128,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(42,2,'14','Prácticas Atléticas y su Enseñanza',1,8,'taller','especifica','anual',4.0,128,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(43,2,'15','Prácticas de Recreación y Tiempo Libre y su Enseñanza',1,9,'taller','especifica','anual',3.0,48,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(44,2,'32','Práctica I',1,10,'trabajo_de_campo','practica_profesional','anual',4.0,128,'promocion',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(45,2,'05','Filosofía',2,1,'materia','general','anual',4.0,128,'promocion_o_examen_final',1,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(46,2,'06','Historia de las Políticas Educativas en la Argentina',2,2,'seminario','general','anual',4.0,128,'promocion_o_examen_final',1,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(47,2,'16','Sujeto de la Educación',2,3,'materia','especifica','anual',4.0,128,'examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(48,2,'17','Prácticas Acuáticas y su Enseñanza',2,4,'taller','especifica','1C',4.0,64,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(49,2,'18','Prácticas Motrices Expresivas y su Enseñanza',2,5,'taller','especifica','1C',4.0,64,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(50,2,'19','Prácticas Deportivas I y su Enseñanza',2,6,'taller','especifica','anual',4.0,128,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(51,2,'20','Prácticas Deportivas II y su Enseñanza',2,7,'taller','especifica','anual',4.0,128,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(52,2,'21','Didáctica de la Educación Física',2,8,'materia','especifica','anual',4.0,128,'examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(53,2,'22','Didáctica de las Prácticas Recreativas y el Tiempo Libre',2,9,'materia','especifica','anual',3.0,48,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(54,2,'33','Práctica II',2,10,'trabajo_de_campo','practica_profesional','anual',4.0,128,'promocion',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(55,2,'07','Educación Sexual Integral',3,1,'seminario','general','1C',4.0,64,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(56,2,'08','Integración de las TIC en la Enseñanza',3,2,'taller','general','1C',4.0,64,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(57,2,'09','Sociología de la Educación',3,3,'seminario','general','anual',4.0,64,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(58,2,'23','Prácticas Deportivas III y su Enseñanza',3,4,'taller','especifica','anual',4.0,128,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(59,2,'24','Prácticas Deportivas IV y su Enseñanza',3,5,'taller','especifica','anual',4.0,128,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(60,2,'25','Práctica en la Naturaleza y al Aire Libre y su Enseñanza',3,6,'taller','especifica','anual',4.0,128,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(61,2,'26','Entrenamiento para la Actividad Física',3,7,'taller','especifica','anual',4.0,128,'examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(62,2,'27','Historia y Epistemología de la Educación Física',3,8,'materia','especifica','anual',4.0,64,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(63,2,'34','Práctica III',3,9,'practica_docente','practica_profesional','anual',6.0,192,'promocion',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(64,2,'10','Ética Profesional Docente',4,1,'seminario','general','anual',4.0,64,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(65,2,'28','Educación Física Inclusiva',4,2,'taller','especifica','anual',4.0,128,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(66,2,'29','Proyectos de Recreación y Tiempo Libre y su Enseñanza',4,3,'taller','especifica','anual',4.0,128,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(67,2,'30','Educación Física y Salud',4,4,'taller','especifica','anual',4.0,128,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(68,2,'31','Gestión de Espacios y Organizaciones Deportivas',4,5,'taller','especifica','anual',4.0,64,'promocion_o_examen_final',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(69,2,'36','Unidad de Definición Institucional',4,6,'taller','general','anual',4.0,64,'promocion',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(70,2,'35','Residencia Pedagógica',4,7,'practica_docente','practica_profesional','anual',12.0,384,'promocion',0,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27');
/*!40000 ALTER TABLE `materias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mesas_examen`
--

DROP TABLE IF EXISTS `mesas_examen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mesas_examen` (
  `id_mesa` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_materia` int unsigned NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `periodo_mesa` enum('febrero','marzo','abril','mayo','junio','julio','agosto','septiembre','octubre','noviembre','diciembre') COLLATE utf8mb4_general_ci NOT NULL,
  `aula` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_presidente` int unsigned DEFAULT NULL,
  `id_vocal_1` int unsigned DEFAULT NULL,
  `id_vocal_2` int unsigned DEFAULT NULL,
  `estado` enum('programada','realizada','suspendida') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'programada',
  `observaciones` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_mesa`),
  UNIQUE KEY `uq_mesa` (`id_materia`,`fecha`,`hora`),
  KEY `idx_mesas_fecha` (`fecha`),
  KEY `fk_mesas_presidente` (`id_presidente`),
  KEY `fk_mesas_vocal1` (`id_vocal_1`),
  KEY `fk_mesas_vocal2` (`id_vocal_2`),
  CONSTRAINT `fk_mesas_materia` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_mesas_presidente` FOREIGN KEY (`id_presidente`) REFERENCES `docentes` (`id_docente`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_mesas_vocal1` FOREIGN KEY (`id_vocal_1`) REFERENCES `docentes` (`id_docente`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_mesas_vocal2` FOREIGN KEY (`id_vocal_2`) REFERENCES `docentes` (`id_docente`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mesas_examen`
--

LOCK TABLES `mesas_examen` WRITE;
/*!40000 ALTER TABLE `mesas_examen` DISABLE KEYS */;
/*!40000 ALTER TABLE `mesas_examen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notificaciones`
--

DROP TABLE IF EXISTS `notificaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notificaciones` (
  `id_notificacion` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tipo` enum('documentacion','vencimiento','regularidad','tramite','correlatividad','sistema') COLLATE utf8mb4_general_ci NOT NULL,
  `id_estudiante` int unsigned DEFAULT NULL,
  `id_referencia` bigint unsigned DEFAULT NULL,
  `mensaje` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `detalle` text COLLATE utf8mb4_general_ci,
  `estado` enum('pendiente','leida','resuelta','descartada') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'pendiente',
  `id_usuario_asignado` int unsigned DEFAULT NULL,
  `fecha_generacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_lectura` datetime DEFAULT NULL,
  PRIMARY KEY (`id_notificacion`),
  KEY `idx_notificaciones_estado` (`estado`,`fecha_generacion`),
  KEY `idx_notificaciones_estudiante` (`id_estudiante`),
  KEY `fk_notificaciones_usuario` (`id_usuario_asignado`),
  CONSTRAINT `fk_notificaciones_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_notificaciones_usuario` FOREIGN KEY (`id_usuario_asignado`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notificaciones`
--

LOCK TABLES `notificaciones` WRITE;
/*!40000 ALTER TABLE `notificaciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `notificaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permisos`
--

DROP TABLE IF EXISTS `permisos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permisos` (
  `id_permiso` int unsigned NOT NULL AUTO_INCREMENT,
  `codigo` varchar(60) COLLATE utf8mb4_general_ci NOT NULL,
  `descripcion` varchar(150) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `modulo` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_permiso`),
  UNIQUE KEY `uq_permisos_codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permisos`
--

LOCK TABLES `permisos` WRITE;
/*!40000 ALTER TABLE `permisos` DISABLE KEYS */;
INSERT INTO `permisos` VALUES (1,'expedientes.ver','Ver expedientes y datos personales','expedientes'),(2,'expedientes.editar','Crear, editar y certificar expedientes','expedientes'),(3,'tramites.ver','Ver trámites y su estado','tramites'),(4,'tramites.editar','Iniciar, modificar y resolver trámites','tramites'),(5,'resoluciones.ver','Ver resoluciones','resoluciones'),(6,'resoluciones.editar','Cargar y modificar resoluciones','resoluciones'),(7,'notas.ver','Ver notas y situación académica','academico'),(8,'notas.editar','Cargar y modificar notas','academico'),(9,'mesas.ver','Ver mesas de examen e inscripciones','mesas'),(10,'mesas.editar','Crear mesas y cargar resultados','mesas'),(11,'usuarios.ver','Ver usuarios','usuarios'),(12,'usuarios.editar','Crear y modificar usuarios','usuarios'),(13,'auditoria.ver','Ver el registro de auditoría','auditoria'),(14,'backups.ejecutar','Generar y restaurar copias de seguridad','backups'),(15,'reportes.ver','Ver y exportar reportes','reportes'),(16,'configuracion.editar','Modificar la configuración del sistema','configuracion');
/*!40000 ALTER TABLE `permisos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `planes`
--

DROP TABLE IF EXISTS `planes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `planes` (
  `id_plan` int unsigned NOT NULL AUTO_INCREMENT,
  `id_carrera` int unsigned NOT NULL,
  `nombre` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `anio_vigencia` year NOT NULL,
  `resolucion` varchar(150) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `resolucion_regimen` varchar(150) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `fecha_resolucion` date DEFAULT NULL,
  `horas_totales` smallint unsigned DEFAULT NULL,
  `vigente_hasta` year DEFAULT NULL,
  `activo` tinyint NOT NULL DEFAULT '1',
  `observaciones` text COLLATE utf8mb4_general_ci,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_plan`),
  UNIQUE KEY `uq_planes_carrera_anio` (`id_carrera`,`anio_vigencia`),
  KEY `idx_planes_carrera_activo` (`id_carrera`,`activo`),
  CONSTRAINT `fk_planes_carrera` FOREIGN KEY (`id_carrera`) REFERENCES `carreras` (`id_carrera`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_planes_horas` CHECK (((`horas_totales` is null) or (`horas_totales` > 0))),
  CONSTRAINT `chk_planes_vigencia` CHECK (((`vigente_hasta` is null) or (`vigente_hasta` >= `anio_vigencia`)))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planes`
--

LOCK TABLES `planes` WRITE;
/*!40000 ALTER TABLE `planes` DISABLE KEYS */;
INSERT INTO `planes` VALUES (1,1,'Plan de Estudios 2020 — Profesorado de Educación Física',2020,'Resolución N° 2286-E-20','Resolución N° 2286-E-20',NULL,3968,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(2,2,'Plan de Estudios 2020 — Profesorado de Educación Física con orientación en Tiempo Libre y Recreación',2020,'Decreto-Resolución N° 13929-E-19','Resolución N° 2281-E-20',NULL,4064,NULL,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27');
/*!40000 ALTER TABLE `planes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resoluciones`
--

DROP TABLE IF EXISTS `resoluciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resoluciones` (
  `id_resolucion` int unsigned NOT NULL AUTO_INCREMENT,
  `nro` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `anio` year DEFAULT NULL COMMENT 'Si no se envía, el trigger lo toma de la fecha',
  `fecha` date NOT NULL,
  `tipo` enum('asimilacion','equivalencia','pase','nota_aprobacion') COLLATE utf8mb4_general_ci NOT NULL,
  `id_carrera` int unsigned DEFAULT NULL,
  `id_plan` int unsigned DEFAULT NULL,
  `archivo_id` bigint unsigned DEFAULT NULL,
  `observaciones` text COLLATE utf8mb4_general_ci,
  `id_usuario_registro` int unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_resolucion`),
  UNIQUE KEY `uq_resolucion` (`nro`,`anio`,`tipo`),
  KEY `idx_resoluciones_fecha` (`fecha`),
  KEY `fk_resoluciones_carrera` (`id_carrera`),
  KEY `fk_resoluciones_plan` (`id_plan`),
  KEY `fk_resoluciones_archivo` (`archivo_id`),
  KEY `fk_resoluciones_usuario` (`id_usuario_registro`),
  CONSTRAINT `fk_resoluciones_archivo` FOREIGN KEY (`archivo_id`) REFERENCES `archivos` (`id_archivo`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_resoluciones_carrera` FOREIGN KEY (`id_carrera`) REFERENCES `carreras` (`id_carrera`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_resoluciones_plan` FOREIGN KEY (`id_plan`) REFERENCES `planes` (`id_plan`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_resoluciones_usuario` FOREIGN KEY (`id_usuario_registro`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resoluciones`
--

LOCK TABLES `resoluciones` WRITE;
/*!40000 ALTER TABLE `resoluciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `resoluciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rol_permiso`
--

DROP TABLE IF EXISTS `rol_permiso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rol_permiso` (
  `rol` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `id_permiso` int unsigned NOT NULL,
  `puede_ver` tinyint NOT NULL DEFAULT '1',
  `puede_editar` tinyint NOT NULL DEFAULT '0',
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
INSERT INTO `rol_permiso` VALUES ('admin',1,1,1),('admin',2,1,1),('admin',3,1,1),('admin',4,1,1),('admin',5,1,1),('admin',6,1,1),('admin',7,1,1),('admin',8,1,1),('admin',9,1,1),('admin',10,1,1),('admin',11,1,1),('admin',12,1,1),('admin',13,1,1),('admin',14,1,1),('admin',15,1,1),('admin',16,1,1),('consulta',1,1,0),('consulta',3,1,0),('consulta',5,1,0),('consulta',7,1,0),('consulta',9,1,0),('consulta',15,1,0),('coordinadora',1,1,0),('coordinadora',2,1,1),('coordinadora',3,1,0),('coordinadora',4,1,1),('coordinadora',5,1,0),('coordinadora',7,1,0),('coordinadora',8,1,1),('coordinadora',9,1,0),('coordinadora',10,1,1),('coordinadora',15,1,0),('docente',1,1,0),('docente',7,1,0),('docente',8,1,1),('docente',9,1,0),('preceptora',1,1,0),('preceptora',2,1,1),('preceptora',3,1,0),('preceptora',4,1,1),('preceptora',5,1,0),('preceptora',7,1,0),('preceptora',8,1,1),('preceptora',9,1,0),('preceptora',15,1,0),('secretaria_academica',1,1,0),('secretaria_academica',3,1,0),('secretaria_academica',4,1,1),('secretaria_academica',5,1,0),('secretaria_academica',6,1,1),('secretaria_academica',7,1,0),('secretaria_academica',9,1,0),('secretaria_academica',13,1,0),('secretaria_academica',15,1,0),('vicerrectora',1,1,0),('vicerrectora',2,1,1),('vicerrectora',3,1,0),('vicerrectora',4,1,1),('vicerrectora',5,1,0),('vicerrectora',6,1,1),('vicerrectora',7,1,0),('vicerrectora',8,1,1),('vicerrectora',9,1,0),('vicerrectora',10,1,1),('vicerrectora',11,1,0),('vicerrectora',12,1,1),('vicerrectora',13,1,0),('vicerrectora',15,1,0);
/*!40000 ALTER TABLE `rol_permiso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `submaterias`
--

DROP TABLE IF EXISTS `submaterias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `submaterias` (
  `id_submateria` int unsigned NOT NULL AUTO_INCREMENT,
  `id_materia` int unsigned NOT NULL,
  `nombre` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `orden` smallint unsigned NOT NULL DEFAULT '0',
  `ponderacion` decimal(5,2) NOT NULL DEFAULT '1.00',
  `activa` tinyint NOT NULL DEFAULT '1',
  `observaciones` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_submateria`),
  UNIQUE KEY `uq_submaterias_materia_nombre` (`id_materia`,`nombre`),
  KEY `idx_submaterias_materia` (`id_materia`,`activa`,`orden`),
  CONSTRAINT `fk_submaterias_materia` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_submaterias_ponderacion` CHECK ((`ponderacion` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submaterias`
--

LOCK TABLES `submaterias` WRITE;
/*!40000 ALTER TABLE `submaterias` DISABLE KEYS */;
INSERT INTO `submaterias` VALUES (1,15,'Vóley',1,1.00,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(2,16,'Handbol',1,1.00,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(3,16,'Básquet',2,1.00,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(4,22,'Hockey',1,1.00,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(5,22,'Rugby',2,1.00,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(6,22,'Fútbol',3,1.00,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(7,23,'Gimnasia',1,1.00,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(8,23,'Atletismo',2,1.00,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(9,9,'Práctica en terreno',1,1.00,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(10,9,'Taller Integrador I',2,1.00,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(11,18,'Práctica en terreno',1,1.00,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(12,18,'Taller Integrador II',2,1.00,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(13,27,'Práctica en terreno',1,1.00,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(14,27,'Taller Integrador III',2,1.00,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(15,50,'Vóley',1,1.00,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(16,51,'Handbol',1,1.00,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(17,51,'Básquet',2,1.00,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(18,58,'Hockey',1,1.00,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(19,58,'Rugby',2,1.00,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(20,58,'Fútbol',3,1.00,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(21,59,'Gimnasia',1,1.00,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(22,59,'Atletismo',2,1.00,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(23,44,'Práctica en terreno',1,1.00,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(24,44,'Taller Integrador I',2,1.00,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(25,54,'Práctica en terreno',1,1.00,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(26,54,'Taller Integrador II',2,1.00,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(27,63,'Práctica en terreno',1,1.00,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(28,63,'Taller Integrador III',2,1.00,1,NULL,'2026-10-28 22:07:27','2026-10-28 22:07:27');
/*!40000 ALTER TABLE `submaterias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipos_documento`
--

DROP TABLE IF EXISTS `tipos_documento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipos_documento` (
  `id_tipo` int unsigned NOT NULL AUTO_INCREMENT,
  `codigo` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `nombre` varchar(120) COLLATE utf8mb4_general_ci NOT NULL,
  `categoria` enum('ingreso','salud','seguro','academico','otro') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ingreso',
  `obligatorio` tinyint NOT NULL DEFAULT '1',
  `vence` tinyint NOT NULL DEFAULT '0',
  `dias_alerta` smallint unsigned NOT NULL DEFAULT '30',
  `orden` smallint NOT NULL DEFAULT '0',
  `activo` tinyint NOT NULL DEFAULT '1',
  `observaciones` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_tipo`),
  UNIQUE KEY `uq_tipos_codigo` (`codigo`),
  UNIQUE KEY `uq_tipos_nombre` (`nombre`),
  KEY `idx_tipos_orden` (`orden`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_documento`
--

LOCK TABLES `tipos_documento` WRITE;
/*!40000 ALTER TABLE `tipos_documento` DISABLE KEYS */;
INSERT INTO `tipos_documento` VALUES (1,'DNI','DNI','ingreso',1,0,0,1,1,NULL),(2,'TITULO','Título o constancia de título en trámite','ingreso',1,0,0,2,1,NULL),(3,'NO_ADEUDA','Constancia de no adeudar materias','ingreso',1,0,0,3,1,NULL),(4,'CARNET_SANITARIO','Carnet sanitario','salud',1,1,30,4,1,NULL),(5,'PRONTUARIO','Planilla prontuarial','ingreso',1,0,0,5,1,NULL),(6,'APTO_ESPIR','Apto físico — Espirometría','salud',1,1,30,6,1,NULL),(7,'APTO_ECG','Apto físico — Electrocardiograma','salud',1,1,30,7,1,NULL),(8,'APTO_CLINICO','Apto físico — Análisis clínicos','salud',1,1,30,8,1,NULL),(9,'SEGURO_SEMED','Seguro SEMED','seguro',1,1,30,9,1,NULL),(10,'OTRO','Documentación adicional','otro',0,0,0,99,1,NULL);
/*!40000 ALTER TABLE `tipos_documento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `titulos`
--

DROP TABLE IF EXISTS `titulos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `titulos` (
  `id_titulo` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_estudiante` int unsigned NOT NULL,
  `id_plan` int unsigned NOT NULL,
  `fecha_egreso` date DEFAULT NULL,
  `id_resolucion` int unsigned DEFAULT NULL,
  `libro` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `folio` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `estado` enum('en_tramite','emitido','entregado','anulado') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'en_tramite',
  `observaciones` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_titulo`),
  UNIQUE KEY `uq_titulo_estudiante_plan` (`id_estudiante`,`id_plan`),
  KEY `fk_titulos_plan` (`id_plan`),
  KEY `fk_titulos_resolucion` (`id_resolucion`),
  CONSTRAINT `fk_titulos_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_titulos_plan` FOREIGN KEY (`id_plan`) REFERENCES `planes` (`id_plan`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_titulos_resolucion` FOREIGN KEY (`id_resolucion`) REFERENCES `resoluciones` (`id_resolucion`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `titulos`
--

LOCK TABLES `titulos` WRITE;
/*!40000 ALTER TABLE `titulos` DISABLE KEYS */;
/*!40000 ALTER TABLE `titulos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tramite_historial`
--

DROP TABLE IF EXISTS `tramite_historial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tramite_historial` (
  `id_historial` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_tramite` bigint unsigned NOT NULL,
  `estado_anterior` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `estado_nuevo` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `id_usuario` int unsigned DEFAULT NULL,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `observaciones` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_historial`),
  KEY `idx_historial_tramite` (`id_tramite`,`fecha`),
  KEY `fk_historial_usuario` (`id_usuario`),
  CONSTRAINT `fk_historial_tramite` FOREIGN KEY (`id_tramite`) REFERENCES `tramites` (`id_tramite`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_historial_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tramite_historial`
--

LOCK TABLES `tramite_historial` WRITE;
/*!40000 ALTER TABLE `tramite_historial` DISABLE KEYS */;
/*!40000 ALTER TABLE `tramite_historial` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tramite_materias`
--

DROP TABLE IF EXISTS `tramite_materias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tramite_materias` (
  `id_tramite_materia` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_tramite` bigint unsigned NOT NULL,
  `id_materia` int unsigned NOT NULL,
  `tipo_resultado` enum('equivalencia','asimilacion','aprobada','rechazada','pendiente') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'pendiente',
  `materia_origen` varchar(180) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `institucion_origen` varchar(150) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `anio_origen` year DEFAULT NULL,
  `nota_origen` decimal(4,2) DEFAULT NULL,
  `id_resolucion` int unsigned DEFAULT NULL,
  `observaciones` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_tramite_materia`),
  UNIQUE KEY `uq_tramite_materia` (`id_tramite`,`id_materia`),
  KEY `idx_tm_materia` (`id_materia`),
  KEY `fk_tm_resolucion` (`id_resolucion`),
  CONSTRAINT `fk_tm_materia` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_tm_resolucion` FOREIGN KEY (`id_resolucion`) REFERENCES `resoluciones` (`id_resolucion`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_tm_tramite` FOREIGN KEY (`id_tramite`) REFERENCES `tramites` (`id_tramite`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_tm_nota` CHECK (((`nota_origen` is null) or (`nota_origen` between 0 and 10)))
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
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tramites` (
  `id_tramite` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nro_expediente` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_estudiante` int unsigned NOT NULL,
  `tipo` enum('pase','asimilacion','equivalencia','nota_aprobacion') COLLATE utf8mb4_general_ci NOT NULL,
  `fecha_solicitud` date NOT NULL,
  `fecha_limite` date DEFAULT NULL,
  `fecha_resolucion` date DEFAULT NULL,
  `estado` enum('en_curso','en_revision','observado','resuelto','rechazado','archivado') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'en_curso',
  `id_resolucion` int unsigned DEFAULT NULL,
  `id_carrera_origen` int unsigned DEFAULT NULL,
  `id_carrera_destino` int unsigned DEFAULT NULL,
  `id_plan_origen` int unsigned DEFAULT NULL,
  `id_plan_destino` int unsigned DEFAULT NULL,
  `id_usuario_inicia` int unsigned DEFAULT NULL,
  `id_usuario_resuelve` int unsigned DEFAULT NULL,
  `detalle` text COLLATE utf8mb4_general_ci,
  `observaciones` text COLLATE utf8mb4_general_ci,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_tramite`),
  UNIQUE KEY `uq_tramites_expediente` (`nro_expediente`),
  KEY `idx_tramites_estudiante` (`id_estudiante`),
  KEY `idx_tramites_estado` (`estado`,`fecha_limite`),
  KEY `idx_tramites_tipo` (`tipo`),
  KEY `fk_tramites_resolucion` (`id_resolucion`),
  KEY `fk_tramites_carrera_origen` (`id_carrera_origen`),
  KEY `fk_tramites_carrera_destino` (`id_carrera_destino`),
  KEY `fk_tramites_plan_origen` (`id_plan_origen`),
  KEY `fk_tramites_plan_destino` (`id_plan_destino`),
  KEY `fk_tramites_usuario_inicia` (`id_usuario_inicia`),
  KEY `fk_tramites_usuario_resuelve` (`id_usuario_resuelve`),
  CONSTRAINT `fk_tramites_carrera_destino` FOREIGN KEY (`id_carrera_destino`) REFERENCES `carreras` (`id_carrera`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_tramites_carrera_origen` FOREIGN KEY (`id_carrera_origen`) REFERENCES `carreras` (`id_carrera`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_tramites_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_tramites_plan_destino` FOREIGN KEY (`id_plan_destino`) REFERENCES `planes` (`id_plan`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_tramites_plan_origen` FOREIGN KEY (`id_plan_origen`) REFERENCES `planes` (`id_plan`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_tramites_resolucion` FOREIGN KEY (`id_resolucion`) REFERENCES `resoluciones` (`id_resolucion`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_tramites_usuario_inicia` FOREIGN KEY (`id_usuario_inicia`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_tramites_usuario_resuelve` FOREIGN KEY (`id_usuario_resuelve`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_tramites_fechas` CHECK (((`fecha_limite` is null) or (`fecha_limite` >= `fecha_solicitud`)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tramites`
--

LOCK TABLES `tramites` WRITE;
/*!40000 ALTER TABLE `tramites` DISABLE KEYS */;
/*!40000 ALTER TABLE `tramites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id_usuario` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(120) COLLATE utf8mb4_general_ci NOT NULL,
  `usuario` varchar(60) COLLATE utf8mb4_general_ci NOT NULL,
  `clave_hash` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `rol` enum('admin','vicerrectora','secretaria_academica','secretaria_administrativa','coordinadora','preceptora','docente','consulta') COLLATE utf8mb4_general_ci NOT NULL,
  `turno` enum('mañana','tarde','ambos') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ambos',
  `id_carrera` int unsigned DEFAULT NULL,
  `puede_ver_otras_carreras` tinyint NOT NULL DEFAULT '0',
  `email` varchar(120) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `telefono` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `activo` tinyint NOT NULL DEFAULT '1',
  `ultimo_acceso` datetime DEFAULT NULL,
  `debe_cambiar_clave` tinyint NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `uq_usuarios_usuario` (`usuario`),
  KEY `idx_usuarios_rol` (`rol`,`activo`),
  KEY `idx_usuarios_carrera` (`id_carrera`),
  CONSTRAINT `fk_usuarios_carrera` FOREIGN KEY (`id_carrera`) REFERENCES `carreras` (`id_carrera`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'Administrador del Sistema','admin','$2y$12$dFGiDWNqTHwFO/6DhoP6LeLR.hQLcFFRQ1B1jH3AO0CarnIz0XnHW','admin','ambos',NULL,1,'admin@ies4.edu.ar',NULL,1,NULL,1,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(2,'Vicerrectora','vicerrectora','$2y$12$dFGiDWNqTHwFO/6DhoP6LeLR.hQLcFFRQ1B1jH3AO0CarnIz0XnHW','vicerrectora','ambos',NULL,1,'vicerrectoria@ies4.edu.ar',NULL,1,NULL,1,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(3,'Secretaría Académica','secretaria.academica','$2y$12$dFGiDWNqTHwFO/6DhoP6LeLR.hQLcFFRQ1B1jH3AO0CarnIz0XnHW','secretaria_academica','ambos',NULL,1,'academica@ies4.edu.ar',NULL,1,NULL,1,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(4,'Coordinadora de Educación Física','coordinadora','$2y$12$dFGiDWNqTHwFO/6DhoP6LeLR.hQLcFFRQ1B1jH3AO0CarnIz0XnHW','coordinadora','mañana',1,1,'coordinacion@ies4.edu.ar',NULL,1,NULL,1,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(5,'Preceptora Turno Mañana','preceptora.manana','$2y$12$dFGiDWNqTHwFO/6DhoP6LeLR.hQLcFFRQ1B1jH3AO0CarnIz0XnHW','preceptora','mañana',1,1,'preceptoria.manana@ies4.edu.ar',NULL,1,NULL,1,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(6,'Preceptora Turno Tarde','preceptora.tarde','$2y$12$dFGiDWNqTHwFO/6DhoP6LeLR.hQLcFFRQ1B1jH3AO0CarnIz0XnHW','preceptora','tarde',2,1,'preceptoria.tarde@ies4.edu.ar',NULL,1,NULL,1,'2026-10-28 22:07:27','2026-10-28 22:07:27'),(7,'Consulta / Solo lectura','consulta','$2y$12$dFGiDWNqTHwFO/6DhoP6LeLR.hQLcFFRQ1B1jH3AO0CarnIz0XnHW','consulta','ambos',NULL,1,'consulta@ies4.edu.ar',NULL,1,NULL,1,'2026-10-28 22:07:27','2026-10-28 22:07:27');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_alertas`
--

DROP TABLE IF EXISTS `v_alertas`;
/*!50001 DROP VIEW IF EXISTS `v_alertas`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_alertas` AS SELECT 
 1 AS `tipo`,
 1 AS `id_estudiante`,
 1 AS `apellido`,
 1 AS `nombre`,
 1 AS `dni`,
 1 AS `id_referencia`,
 1 AS `mensaje`,
 1 AS `fecha_referencia`,
 1 AS `dias`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_correlatividades_estado`
--

DROP TABLE IF EXISTS `v_correlatividades_estado`;
/*!50001 DROP VIEW IF EXISTS `v_correlatividades_estado`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_correlatividades_estado` AS SELECT 
 1 AS `id_estudiante`,
 1 AS `apellido`,
 1 AS `nombre`,
 1 AS `dni`,
 1 AS `id_materia_objetivo`,
 1 AS `codigo_objetivo`,
 1 AS `materia_objetivo`,
 1 AS `tipo_requisito`,
 1 AS `condicion`,
 1 AS `id_materia_requerida`,
 1 AS `materia_requerida`,
 1 AS `estado_requerida`,
 1 AS `cumple`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_correlatividades_faltantes`
--

DROP TABLE IF EXISTS `v_correlatividades_faltantes`;
/*!50001 DROP VIEW IF EXISTS `v_correlatividades_faltantes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_correlatividades_faltantes` AS SELECT 
 1 AS `id_estudiante`,
 1 AS `apellido`,
 1 AS `nombre`,
 1 AS `dni`,
 1 AS `id_materia_objetivo`,
 1 AS `codigo_objetivo`,
 1 AS `materia_objetivo`,
 1 AS `tipo_requisito`,
 1 AS `condicion`,
 1 AS `id_materia_requerida`,
 1 AS `materia_requerida`,
 1 AS `estado_requerida`,
 1 AS `cumple`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_cursadas_resumen`
--

DROP TABLE IF EXISTS `v_cursadas_resumen`;
/*!50001 DROP VIEW IF EXISTS `v_cursadas_resumen`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_cursadas_resumen` AS SELECT 
 1 AS `id_cursada`,
 1 AS `id_estudiante`,
 1 AS `apellido`,
 1 AS `nombre`,
 1 AS `dni`,
 1 AS `id_materia`,
 1 AS `codigo`,
 1 AS `materia`,
 1 AS `anio_materia`,
 1 AS `anio_cursada`,
 1 AS `id_comision`,
 1 AS `caracter`,
 1 AS `estado`,
 1 AS `promedio`,
 1 AS `nota_general`,
 1 AS `nota_definitiva`,
 1 AS `fecha_vencimiento_regularidad`,
 1 AS `submaterias_total`,
 1 AS `submaterias_cargadas`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_documentacion_estado`
--

DROP TABLE IF EXISTS `v_documentacion_estado`;
/*!50001 DROP VIEW IF EXISTS `v_documentacion_estado`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_documentacion_estado` AS SELECT 
 1 AS `id_documento`,
 1 AS `id_estudiante`,
 1 AS `id_tipo`,
 1 AS `anio_lectivo`,
 1 AS `codigo`,
 1 AS `nombre`,
 1 AS `categoria`,
 1 AS `obligatorio`,
 1 AS `vence`,
 1 AS `presentado`,
 1 AS `fecha_presentacion`,
 1 AS `fecha_vencimiento`,
 1 AS `archivo_id`,
 1 AS `observaciones`,
 1 AS `estado`,
 1 AS `dias_para_vencer`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_estudiantes_resumen`
--

DROP TABLE IF EXISTS `v_estudiantes_resumen`;
/*!50001 DROP VIEW IF EXISTS `v_estudiantes_resumen`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_estudiantes_resumen` AS SELECT 
 1 AS `id_estudiante`,
 1 AS `legajo`,
 1 AS `dni`,
 1 AS `apellido`,
 1 AS `nombre`,
 1 AS `fecha_nacimiento`,
 1 AS `telefono`,
 1 AS `email`,
 1 AS `estado`,
 1 AS `anio_ingreso`,
 1 AS `id_carrera`,
 1 AS `carrera_nombre`,
 1 AS `carrera_turno`,
 1 AS `sede`,
 1 AS `id_plan`,
 1 AS `plan_nombre`,
 1 AS `anio_vigencia`,
 1 AS `docs_pendientes`,
 1 AS `materias_regulares`,
 1 AS `materias_aprobadas`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_materias_plan`
--

DROP TABLE IF EXISTS `v_materias_plan`;
/*!50001 DROP VIEW IF EXISTS `v_materias_plan`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_materias_plan` AS SELECT 
 1 AS `id_materia`,
 1 AS `id_plan`,
 1 AS `id_carrera`,
 1 AS `carrera`,
 1 AS `codigo`,
 1 AS `nombre`,
 1 AS `anio`,
 1 AS `orden`,
 1 AS `tipo_espacio`,
 1 AS `campo_formacion`,
 1 AS `periodo`,
 1 AS `horas_semanales`,
 1 AS `horas_totales`,
 1 AS `regimen_acreditacion`,
 1 AS `permite_libre`,
 1 AS `activa`,
 1 AS `submaterias`,
 1 AS `req_cursar`,
 1 AS `req_rendir`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_situacion_academica`
--

DROP TABLE IF EXISTS `v_situacion_academica`;
/*!50001 DROP VIEW IF EXISTS `v_situacion_academica`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_situacion_academica` AS SELECT 
 1 AS `id_estudiante`,
 1 AS `apellido`,
 1 AS `nombre`,
 1 AS `dni`,
 1 AS `id_carrera`,
 1 AS `id_plan`,
 1 AS `id_materia`,
 1 AS `codigo`,
 1 AS `materia`,
 1 AS `anio_materia`,
 1 AS `id_cursada`,
 1 AS `anio_cursada`,
 1 AS `caracter`,
 1 AS `estado_cursada`,
 1 AS `promedio`,
 1 AS `nota_general`,
 1 AS `nota_definitiva`,
 1 AS `fecha_vencimiento_regularidad`,
 1 AS `mejor_nota_final`,
 1 AS `ultima_fecha_final`,
 1 AS `estado_materia`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_submaterias_notas`
--

DROP TABLE IF EXISTS `v_submaterias_notas`;
/*!50001 DROP VIEW IF EXISTS `v_submaterias_notas`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_submaterias_notas` AS SELECT 
 1 AS `id_cursada_sub`,
 1 AS `id_cursada`,
 1 AS `id_estudiante`,
 1 AS `materia`,
 1 AS `submateria`,
 1 AS `ponderacion`,
 1 AS `nota`,
 1 AS `promedio`,
 1 AS `asistencia`,
 1 AS `tp`,
 1 AS `condicion`,
 1 AS `fecha`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_tramites_pendientes`
--

DROP TABLE IF EXISTS `v_tramites_pendientes`;
/*!50001 DROP VIEW IF EXISTS `v_tramites_pendientes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_tramites_pendientes` AS SELECT 
 1 AS `id_tramite`,
 1 AS `nro_expediente`,
 1 AS `id_estudiante`,
 1 AS `apellido`,
 1 AS `nombre`,
 1 AS `dni`,
 1 AS `turno`,
 1 AS `tipo`,
 1 AS `fecha_solicitud`,
 1 AS `fecha_limite`,
 1 AS `estado`,
 1 AS `id_resolucion`,
 1 AS `detalle`,
 1 AS `dias_restantes`*/;
SET character_set_client = @saved_cs_client;

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
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_alertas` AS select 'documentacion' AS `tipo`,`d`.`id_estudiante` AS `id_estudiante`,`e`.`apellido` AS `apellido`,`e`.`nombre` AS `nombre`,`e`.`dni` AS `dni`,`d`.`id_documento` AS `id_referencia`,concat((case when (`d`.`presentado` = 0) then 'Documento pendiente: ' when (`d`.`fecha_vencimiento` < curdate()) then 'Documento vencido: ' else 'Documento por vencer: ' end),`td`.`nombre`) AS `mensaje`,`d`.`fecha_vencimiento` AS `fecha_referencia`,(to_days(`d`.`fecha_vencimiento`) - to_days(curdate())) AS `dias` from ((`documentacion_estudiante` `d` join `tipos_documento` `td` on((`td`.`id_tipo` = `d`.`id_tipo`))) join `estudiantes` `e` on((`e`.`id_estudiante` = `d`.`id_estudiante`))) where ((`td`.`obligatorio` = 1) and ((`d`.`presentado` = 0) or ((`d`.`fecha_vencimiento` is not null) and (`d`.`fecha_vencimiento` <= (curdate() + interval 30 day))))) union all select 'regularidad' AS `tipo`,`cu`.`id_estudiante` AS `id_estudiante`,`e`.`apellido` AS `apellido`,`e`.`nombre` AS `nombre`,`e`.`dni` AS `dni`,`cu`.`id_cursada` AS `id_referencia`,concat('Regularidad por vencer: ',`m`.`nombre`) AS `mensaje`,`cu`.`fecha_vencimiento_regularidad` AS `fecha_referencia`,(to_days(`cu`.`fecha_vencimiento_regularidad`) - to_days(curdate())) AS `dias` from ((`cursadas` `cu` join `estudiantes` `e` on((`e`.`id_estudiante` = `cu`.`id_estudiante`))) join `materias` `m` on((`m`.`id_materia` = `cu`.`id_materia`))) where ((`cu`.`fecha_vencimiento_regularidad` is not null) and (`cu`.`fecha_vencimiento_regularidad` between curdate() and (curdate() + interval 30 day))) union all select 'tramite' AS `tipo`,`t`.`id_estudiante` AS `id_estudiante`,`e`.`apellido` AS `apellido`,`e`.`nombre` AS `nombre`,`e`.`dni` AS `dni`,`t`.`id_tramite` AS `id_referencia`,concat('Trámite por vencer: ',`t`.`tipo`) AS `mensaje`,`t`.`fecha_limite` AS `fecha_referencia`,(to_days(`t`.`fecha_limite`) - to_days(curdate())) AS `dias` from (`tramites` `t` join `estudiantes` `e` on((`e`.`id_estudiante` = `t`.`id_estudiante`))) where ((`t`.`fecha_limite` is not null) and (`t`.`estado` in ('en_curso','en_revision','observado')) and (`t`.`fecha_limite` <= (curdate() + interval 7 day))) */;
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
/*!50001 VIEW `v_correlatividades_estado` AS select `e`.`id_estudiante` AS `id_estudiante`,`e`.`apellido` AS `apellido`,`e`.`nombre` AS `nombre`,`e`.`dni` AS `dni`,`m`.`id_materia` AS `id_materia_objetivo`,`m`.`codigo` AS `codigo_objetivo`,`m`.`nombre` AS `materia_objetivo`,`co`.`tipo_requisito` AS `tipo_requisito`,`co`.`condicion` AS `condicion`,`r`.`id_materia` AS `id_materia_requerida`,`r`.`nombre` AS `materia_requerida`,`sa`.`estado_materia` AS `estado_requerida`,(case when ((`co`.`condicion` = 'aprobada') and (`sa`.`estado_materia` = 'aprobada')) then 1 when ((`co`.`condicion` = 'regular') and (`sa`.`estado_materia` in ('regular','aprobada'))) then 1 else 0 end) AS `cumple` from ((((`estudiantes` `e` join `materias` `m` on(((`m`.`id_plan` = `e`.`id_plan`) and (`m`.`activa` = 1)))) join `correlatividades` `co` on((`co`.`id_materia` = `m`.`id_materia`))) join `materias` `r` on((`r`.`id_materia` = `co`.`id_requerida`))) left join `v_situacion_academica` `sa` on(((`sa`.`id_estudiante` = `e`.`id_estudiante`) and (`sa`.`id_materia` = `co`.`id_requerida`)))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_correlatividades_faltantes`
--

/*!50001 DROP VIEW IF EXISTS `v_correlatividades_faltantes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_correlatividades_faltantes` AS select `v_correlatividades_estado`.`id_estudiante` AS `id_estudiante`,`v_correlatividades_estado`.`apellido` AS `apellido`,`v_correlatividades_estado`.`nombre` AS `nombre`,`v_correlatividades_estado`.`dni` AS `dni`,`v_correlatividades_estado`.`id_materia_objetivo` AS `id_materia_objetivo`,`v_correlatividades_estado`.`codigo_objetivo` AS `codigo_objetivo`,`v_correlatividades_estado`.`materia_objetivo` AS `materia_objetivo`,`v_correlatividades_estado`.`tipo_requisito` AS `tipo_requisito`,`v_correlatividades_estado`.`condicion` AS `condicion`,`v_correlatividades_estado`.`id_materia_requerida` AS `id_materia_requerida`,`v_correlatividades_estado`.`materia_requerida` AS `materia_requerida`,`v_correlatividades_estado`.`estado_requerida` AS `estado_requerida`,`v_correlatividades_estado`.`cumple` AS `cumple` from `v_correlatividades_estado` where (`v_correlatividades_estado`.`cumple` = 0) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_cursadas_resumen`
--

/*!50001 DROP VIEW IF EXISTS `v_cursadas_resumen`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_cursadas_resumen` AS select `cu`.`id_cursada` AS `id_cursada`,`cu`.`id_estudiante` AS `id_estudiante`,`e`.`apellido` AS `apellido`,`e`.`nombre` AS `nombre`,`e`.`dni` AS `dni`,`cu`.`id_materia` AS `id_materia`,`m`.`codigo` AS `codigo`,`m`.`nombre` AS `materia`,`m`.`anio` AS `anio_materia`,`cu`.`anio_cursada` AS `anio_cursada`,`cu`.`id_comision` AS `id_comision`,`cu`.`caracter` AS `caracter`,`cu`.`estado` AS `estado`,`cu`.`promedio` AS `promedio`,`cu`.`nota_general` AS `nota_general`,`cu`.`nota_definitiva` AS `nota_definitiva`,`cu`.`fecha_vencimiento_regularidad` AS `fecha_vencimiento_regularidad`,(select count(0) from `submaterias` `s` where ((`s`.`id_materia` = `m`.`id_materia`) and (`s`.`activa` = 1))) AS `submaterias_total`,(select count(0) from (`cursadas_submaterias` `cs` join `submaterias` `s` on((`s`.`id_submateria` = `cs`.`id_submateria`))) where ((`cs`.`id_cursada` = `cu`.`id_cursada`) and (`s`.`activa` = 1) and (`cs`.`nota` is not null))) AS `submaterias_cargadas` from ((`cursadas` `cu` join `estudiantes` `e` on((`e`.`id_estudiante` = `cu`.`id_estudiante`))) join `materias` `m` on((`m`.`id_materia` = `cu`.`id_materia`))) */;
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
/*!50001 VIEW `v_documentacion_estado` AS select `d`.`id_documento` AS `id_documento`,`d`.`id_estudiante` AS `id_estudiante`,`d`.`id_tipo` AS `id_tipo`,`d`.`anio_lectivo` AS `anio_lectivo`,`td`.`codigo` AS `codigo`,`td`.`nombre` AS `nombre`,`td`.`categoria` AS `categoria`,`td`.`obligatorio` AS `obligatorio`,`td`.`vence` AS `vence`,`d`.`presentado` AS `presentado`,`d`.`fecha_presentacion` AS `fecha_presentacion`,`d`.`fecha_vencimiento` AS `fecha_vencimiento`,`d`.`archivo_id` AS `archivo_id`,`d`.`observaciones` AS `observaciones`,(case when (`d`.`presentado` = 0) then 'pendiente' when ((`d`.`fecha_vencimiento` is not null) and (`d`.`fecha_vencimiento` < curdate())) then 'vencido' else 'presentado' end) AS `estado`,(case when (`d`.`fecha_vencimiento` is not null) then (to_days(`d`.`fecha_vencimiento`) - to_days(curdate())) end) AS `dias_para_vencer` from (`documentacion_estudiante` `d` join `tipos_documento` `td` on((`td`.`id_tipo` = `d`.`id_tipo`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_estudiantes_resumen`
--

/*!50001 DROP VIEW IF EXISTS `v_estudiantes_resumen`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_estudiantes_resumen` AS select `e`.`id_estudiante` AS `id_estudiante`,`e`.`legajo` AS `legajo`,`e`.`dni` AS `dni`,`e`.`apellido` AS `apellido`,`e`.`nombre` AS `nombre`,`e`.`fecha_nacimiento` AS `fecha_nacimiento`,`e`.`telefono` AS `telefono`,`e`.`email` AS `email`,`e`.`estado` AS `estado`,`e`.`anio_ingreso` AS `anio_ingreso`,`e`.`id_carrera` AS `id_carrera`,`c`.`nombre` AS `carrera_nombre`,`c`.`turno` AS `carrera_turno`,`c`.`sede` AS `sede`,`e`.`id_plan` AS `id_plan`,`p`.`nombre` AS `plan_nombre`,`p`.`anio_vigencia` AS `anio_vigencia`,(select count(0) from (`tipos_documento` `td` left join `documentacion_estudiante` `d` on((`d`.`id_documento` = (select `d2`.`id_documento` from `documentacion_estudiante` `d2` where ((`d2`.`id_estudiante` = `e`.`id_estudiante`) and (`d2`.`id_tipo` = `td`.`id_tipo`)) order by `d2`.`anio_lectivo` desc,`d2`.`id_documento` desc limit 1)))) where ((`td`.`obligatorio` = 1) and (`td`.`activo` = 1) and ((`d`.`id_documento` is null) or (`d`.`presentado` = 0) or ((`d`.`fecha_vencimiento` is not null) and (`d`.`fecha_vencimiento` < curdate()))))) AS `docs_pendientes`,(select count(distinct `cu`.`id_materia`) from `cursadas` `cu` where ((`cu`.`id_estudiante` = `e`.`id_estudiante`) and (`cu`.`caracter` in ('regular','promocional')) and ((`cu`.`fecha_vencimiento_regularidad` is null) or (`cu`.`fecha_vencimiento_regularidad` >= curdate())))) AS `materias_regulares`,(select count(distinct `m2`.`id_materia`) from `materias` `m2` where ((`m2`.`id_plan` = `e`.`id_plan`) and exists(select 1 from `examenes_finales` `ex` where ((`ex`.`id_estudiante` = `e`.`id_estudiante`) and (`ex`.`id_materia` = `m2`.`id_materia`) and (`ex`.`estado` = 'presente') and (`ex`.`nota` >= 4))))) AS `materias_aprobadas` from ((`estudiantes` `e` join `carreras` `c` on((`c`.`id_carrera` = `e`.`id_carrera`))) left join `planes` `p` on((`p`.`id_plan` = `e`.`id_plan`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_materias_plan`
--

/*!50001 DROP VIEW IF EXISTS `v_materias_plan`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_materias_plan` AS select `m`.`id_materia` AS `id_materia`,`m`.`id_plan` AS `id_plan`,`p`.`id_carrera` AS `id_carrera`,`c`.`nombre` AS `carrera`,`m`.`codigo` AS `codigo`,`m`.`nombre` AS `nombre`,`m`.`anio` AS `anio`,`m`.`orden` AS `orden`,`m`.`tipo_espacio` AS `tipo_espacio`,`m`.`campo_formacion` AS `campo_formacion`,`m`.`periodo` AS `periodo`,`m`.`horas_semanales` AS `horas_semanales`,`m`.`horas_totales` AS `horas_totales`,`m`.`regimen_acreditacion` AS `regimen_acreditacion`,`m`.`permite_libre` AS `permite_libre`,`m`.`activa` AS `activa`,(select count(0) from `submaterias` `s` where ((`s`.`id_materia` = `m`.`id_materia`) and (`s`.`activa` = 1))) AS `submaterias`,(select count(0) from `correlatividades` `co` where ((`co`.`id_materia` = `m`.`id_materia`) and (`co`.`tipo_requisito` = 'cursar'))) AS `req_cursar`,(select count(0) from `correlatividades` `co` where ((`co`.`id_materia` = `m`.`id_materia`) and (`co`.`tipo_requisito` = 'rendir'))) AS `req_rendir` from ((`materias` `m` join `planes` `p` on((`p`.`id_plan` = `m`.`id_plan`))) join `carreras` `c` on((`c`.`id_carrera` = `p`.`id_carrera`))) */;
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
/*!50001 VIEW `v_situacion_academica` AS select `e`.`id_estudiante` AS `id_estudiante`,`e`.`apellido` AS `apellido`,`e`.`nombre` AS `nombre`,`e`.`dni` AS `dni`,`e`.`id_carrera` AS `id_carrera`,`e`.`id_plan` AS `id_plan`,`m`.`id_materia` AS `id_materia`,`m`.`codigo` AS `codigo`,`m`.`nombre` AS `materia`,`m`.`anio` AS `anio_materia`,`cu`.`id_cursada` AS `id_cursada`,`cu`.`anio_cursada` AS `anio_cursada`,`cu`.`caracter` AS `caracter`,`cu`.`estado` AS `estado_cursada`,`cu`.`promedio` AS `promedio`,`cu`.`nota_general` AS `nota_general`,`cu`.`nota_definitiva` AS `nota_definitiva`,`cu`.`fecha_vencimiento_regularidad` AS `fecha_vencimiento_regularidad`,(select max(`ex`.`nota`) from `examenes_finales` `ex` where ((`ex`.`id_estudiante` = `e`.`id_estudiante`) and (`ex`.`id_materia` = `m`.`id_materia`) and (`ex`.`estado` = 'presente'))) AS `mejor_nota_final`,(select max(`ex`.`fecha`) from `examenes_finales` `ex` where ((`ex`.`id_estudiante` = `e`.`id_estudiante`) and (`ex`.`id_materia` = `m`.`id_materia`) and (`ex`.`estado` = 'presente'))) AS `ultima_fecha_final`,(case when exists(select 1 from `examenes_finales` `ex` where ((`ex`.`id_estudiante` = `e`.`id_estudiante`) and (`ex`.`id_materia` = `m`.`id_materia`) and (`ex`.`estado` = 'presente') and (`ex`.`nota` >= 4))) then 'aprobada' when (`cu`.`estado` = 'aprobada') then 'aprobada' when ((`cu`.`caracter` = 'promocional') and (coalesce(`cu`.`nota_general`,`cu`.`nota_definitiva`) >= 7)) then 'aprobada' when (`cu`.`estado` = 'cursando') then 'cursando' when ((`cu`.`caracter` in ('regular','promocional')) and ((`cu`.`fecha_vencimiento_regularidad` is null) or (`cu`.`fecha_vencimiento_regularidad` >= curdate()))) then 'regular' when exists(select 1 from `examenes_finales` `ex` where ((`ex`.`id_estudiante` = `e`.`id_estudiante`) and (`ex`.`id_materia` = `m`.`id_materia`))) then 'libre' when (`cu`.`id_cursada` is not null) then 'cursada_vencida' else 'pendiente' end) AS `estado_materia` from ((`estudiantes` `e` join `materias` `m` on(((`m`.`id_plan` = `e`.`id_plan`) and (`m`.`activa` = 1)))) left join `cursadas` `cu` on((`cu`.`id_cursada` = (select `cu2`.`id_cursada` from `cursadas` `cu2` where ((`cu2`.`id_estudiante` = `e`.`id_estudiante`) and (`cu2`.`id_materia` = `m`.`id_materia`)) order by `cu2`.`anio_cursada` desc,`cu2`.`id_cursada` desc limit 1)))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_submaterias_notas`
--

/*!50001 DROP VIEW IF EXISTS `v_submaterias_notas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_submaterias_notas` AS select `cs`.`id_cursada_sub` AS `id_cursada_sub`,`cs`.`id_cursada` AS `id_cursada`,`cu`.`id_estudiante` AS `id_estudiante`,`m`.`nombre` AS `materia`,`s`.`nombre` AS `submateria`,`s`.`ponderacion` AS `ponderacion`,`cs`.`nota` AS `nota`,`cs`.`promedio` AS `promedio`,`cs`.`asistencia` AS `asistencia`,`cs`.`tp` AS `tp`,`cs`.`condicion` AS `condicion`,`cs`.`fecha` AS `fecha` from (((`cursadas_submaterias` `cs` join `submaterias` `s` on((`s`.`id_submateria` = `cs`.`id_submateria`))) join `cursadas` `cu` on((`cu`.`id_cursada` = `cs`.`id_cursada`))) join `materias` `m` on((`m`.`id_materia` = `cu`.`id_materia`))) */;
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
/*!50001 VIEW `v_tramites_pendientes` AS select `t`.`id_tramite` AS `id_tramite`,`t`.`nro_expediente` AS `nro_expediente`,`t`.`id_estudiante` AS `id_estudiante`,`e`.`apellido` AS `apellido`,`e`.`nombre` AS `nombre`,`e`.`dni` AS `dni`,`c`.`turno` AS `turno`,`t`.`tipo` AS `tipo`,`t`.`fecha_solicitud` AS `fecha_solicitud`,`t`.`fecha_limite` AS `fecha_limite`,`t`.`estado` AS `estado`,`t`.`id_resolucion` AS `id_resolucion`,`t`.`detalle` AS `detalle`,(to_days(`t`.`fecha_limite`) - to_days(curdate())) AS `dias_restantes` from ((`tramites` `t` join `estudiantes` `e` on((`e`.`id_estudiante` = `t`.`id_estudiante`))) join `carreras` `c` on((`c`.`id_carrera` = `e`.`id_carrera`))) where (`t`.`estado` in ('en_curso','en_revision','observado')) */;
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

-- Dump completed on 2026-10-29  0:06:01
