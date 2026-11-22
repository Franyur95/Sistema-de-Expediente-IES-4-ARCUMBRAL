CREATE DATABASE  IF NOT EXISTS `ies4_expedientes_v2` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `ies4_expedientes_v2`;
-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: ies4_expedientes_v2
-- ------------------------------------------------------
-- Server version	5.5.5-10.11.16-MariaDB

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
-- Table structure for table `auditoria`
--

DROP TABLE IF EXISTS `auditoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=262 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditoria`
--

LOCK TABLES `auditoria` WRITE;
/*!40000 ALTER TABLE `auditoria` DISABLE KEYS */;
INSERT INTO `auditoria` VALUES (1,1,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-03 18:48:14'),(2,1,'estudiantes',1,'INSERT',NULL,NULL,'Alta de expediente: Expediente creado',NULL,NULL,'2026-11-03 18:49:18'),(3,1,'cursadas',1,'INSERT',NULL,NULL,'Carga de cursada: Didáctica General (2026)',NULL,NULL,'2026-11-03 18:49:44'),(4,1,'estudiantes',2,'INSERT',NULL,NULL,'Alta de expediente: Expediente creado',NULL,NULL,'2026-11-03 19:02:05'),(5,1,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-05 17:57:07'),(6,1,'cursadas',2,'INSERT',NULL,NULL,'Alta de inscripción: Prácticas Deportivas II y su Enseñanza - Handbol (Cursar 2026)',NULL,NULL,'2026-11-05 18:25:55'),(7,1,'cursadas',2,'INSERT',NULL,NULL,'Alta de inscripción: Prácticas Deportivas III y su Enseñanza - Rugby (Cursar 2026)',NULL,NULL,'2026-11-05 18:26:40'),(8,1,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-05 19:10:13'),(9,1,'estudiantes',3,'INSERT',NULL,NULL,'Alta de expediente: Expediente creado',NULL,NULL,'2026-11-05 19:18:42'),(10,1,'estudiantes',3,'UPDATE',NULL,NULL,'Modificación de expediente: Sin cambios',NULL,NULL,'2026-11-05 19:19:43'),(11,1,'cursadas',3,'INSERT',NULL,NULL,'Alta de inscripción: Prácticas Deportivas II y su Enseñanza - Handbol (Cursar 2026)',NULL,NULL,'2026-11-05 20:23:53'),(12,1,'cursadas',3,'INSERT',NULL,NULL,'Alta de inscripción: Pedagogía (Cursar 2026)',NULL,NULL,'2026-11-05 20:24:02'),(13,1,'cursadas',3,'INSERT',NULL,NULL,'Carga de cursada: Pedagogía (cursada #5)',NULL,NULL,'2026-11-05 20:24:26'),(14,1,'cursadas',3,'INSERT',NULL,NULL,'Carga de cursada: Pedagogía (cursada #5)',NULL,NULL,'2026-11-05 20:27:48'),(15,1,'cursadas',3,'INSERT',NULL,NULL,'Alta de inscripción: Sujeto de la Educación (Cursar 2026)',NULL,NULL,'2026-11-05 20:32:17'),(16,1,'estudiantes',3,'DELETE',NULL,NULL,'Eliminación de registro académico: Inscripción: Sujeto de la Educación (cursar 2026)',NULL,NULL,'2026-11-05 20:38:58'),(17,1,'estudiantes',3,'DELETE',NULL,NULL,'Eliminación de registro académico: Inscripción: Prácticas Deportivas II y su Enseñanza - Handbol (cursar 2026)',NULL,NULL,'2026-11-05 20:39:03'),(18,1,'cursadas',3,'INSERT',NULL,NULL,'Alta de inscripción: Filosofía (Cursar 2026)',NULL,NULL,'2026-11-05 20:40:08'),(19,1,'cursadas',3,'INSERT',NULL,NULL,'Alta de examen: Pedagogía (cursada #5, intento 1)',NULL,NULL,'2026-11-05 20:46:40'),(20,1,'estudiantes',3,'DELETE',NULL,NULL,'Eliminación de registro académico: Examen: Pedagogía (11/02/2026, nota 10)',NULL,NULL,'2026-11-05 21:03:05'),(21,1,'cursadas',3,'INSERT',NULL,NULL,'Alta de examen: Pedagogía (cursada #5, intento 1)',NULL,NULL,'2026-11-05 21:03:37'),(22,1,'cursadas',3,'INSERT',NULL,NULL,'Carga de cursada: Filosofía (cursada #7)',NULL,NULL,'2026-11-05 21:05:20'),(23,1,'cursadas',3,'INSERT',NULL,NULL,'Alta de examen: Filosofía (cursada #7, intento 1)',NULL,NULL,'2026-11-05 21:05:50'),(24,1,'estudiantes',3,'DELETE',NULL,NULL,'Eliminación de registro académico: Examen: Filosofía (29/09/2026, nota 10)',NULL,NULL,'2026-11-05 21:29:14'),(25,1,'cursadas',3,'INSERT',NULL,NULL,'Alta de inscripción: Práctica I - Práctica en terreno (Cursar 2026)',NULL,NULL,'2026-11-05 21:36:05'),(26,1,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-05 22:39:27'),(27,1,'estudiantes',3,'DELETE',NULL,NULL,'Eliminación de registro académico: Inscripción: Práctica I - Práctica en terreno (cursar 2026)',NULL,NULL,'2026-11-05 22:46:26'),(28,2,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-05 22:51:05'),(29,1,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-05 22:51:43'),(30,3,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-05 22:52:07'),(31,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-05 22:53:38'),(32,1,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-06 09:55:19'),(33,1,'estudiantes',2,'UPDATE',NULL,NULL,'Modificación de expediente: Campos: documentacion',NULL,NULL,'2026-11-06 09:56:33'),(34,1,'estudiantes',2,'DELETE',NULL,NULL,'Eliminación de registro académico: Inscripción: Prácticas Deportivas II y su Enseñanza - Handbol (cursar 2026)',NULL,NULL,'2026-11-06 09:56:52'),(35,1,'estudiantes',2,'DELETE',NULL,NULL,'Eliminación de registro académico: Inscripción: Prácticas Deportivas III y su Enseñanza - Rugby (cursar 2026)',NULL,NULL,'2026-11-06 09:56:56'),(36,1,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-06 11:44:56'),(37,1,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-06 12:20:19'),(38,1,'estudiantes',3,'UPDATE',NULL,NULL,'Modificación de expediente: Campos: dni, apellido, fecha_nacimiento, domicilio',NULL,NULL,'2026-11-06 12:20:55'),(39,1,'estudiantes',1,'UPDATE',NULL,NULL,'Modificación de expediente: Campos: domicilio',NULL,NULL,'2026-11-06 12:22:14'),(40,1,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-06 16:57:13'),(41,1,'estudiantes',4,'INSERT',NULL,NULL,'Alta de expediente: Expediente creado',NULL,NULL,'2026-11-06 17:05:59'),(42,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-06 17:12:26'),(43,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Pedagogía (Cursar 2026)',NULL,NULL,'2026-11-06 17:15:19'),(44,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Pedagogía (cursada #8)',NULL,NULL,'2026-11-06 17:17:23'),(45,1,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-06 17:18:20'),(46,2,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-06 17:24:04'),(47,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-06 22:05:34'),(48,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Pedagogía (cursada #8)',NULL,NULL,'2026-11-06 22:24:27'),(49,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de examen: Pedagogía (cursada #8, intento 1)',NULL,NULL,'2026-11-06 22:25:46'),(50,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Examen: Pedagogía (15/07/2026, nota 8)',NULL,NULL,'2026-11-06 22:37:23'),(51,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de examen: Pedagogía (cursada #8, intento 1)',NULL,NULL,'2026-11-06 22:38:38'),(52,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de examen: Pedagogía (cursada #8, intento 2)',NULL,NULL,'2026-11-06 22:39:18'),(53,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-07 11:38:50'),(54,4,'estudiantes',5,'INSERT',NULL,NULL,'Alta de expediente: Expediente creado',NULL,NULL,'2026-11-07 11:56:33'),(55,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Examen: Pedagogía (01/11/2026, nota 3)',NULL,NULL,'2026-11-07 12:02:43'),(56,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Examen: Pedagogía (04/11/2026, nota 5)',NULL,NULL,'2026-11-07 12:02:47'),(57,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Cursada: Pedagogía (año 2026)',NULL,NULL,'2026-11-07 12:03:05'),(58,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Inscripción: Pedagogía (cursar 2026)',NULL,NULL,'2026-11-07 12:03:09'),(59,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Pedagogía (Cursar 2026)',NULL,NULL,'2026-11-07 12:03:30'),(60,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Pedagogía (cursada #9)',NULL,NULL,'2026-11-07 12:24:59'),(61,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Psicología Educacional (Cursar 2026)',NULL,NULL,'2026-11-07 12:27:04'),(62,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Psicología Educacional (cursada #10)',NULL,NULL,'2026-11-07 12:27:27'),(63,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Alfabetización Académica (Cursar 2026)',NULL,NULL,'2026-11-07 12:35:10'),(64,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Alfabetización Académica (cursada #11)',NULL,NULL,'2026-11-07 12:38:39'),(65,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Didáctica General (Cursar 2026)',NULL,NULL,'2026-11-07 12:40:05'),(66,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Didáctica General (cursada #12)',NULL,NULL,'2026-11-07 12:40:35'),(67,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Cursada: Didáctica General (año 2026)',NULL,NULL,'2026-11-07 12:43:29'),(68,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Didáctica General (cursada #12)',NULL,NULL,'2026-11-07 12:44:12'),(69,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de examen: Didáctica General (cursada #12, intento 1)',NULL,NULL,'2026-11-07 12:44:57'),(70,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Anatomía y Fisiología (Cursar 2026)',NULL,NULL,'2026-11-07 12:47:53'),(71,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Anatomía y Fisiología (cursada #13)',NULL,NULL,'2026-11-07 12:48:30'),(72,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Prácticas Ludomotrices y su Enseñanza (Cursar 2026)',NULL,NULL,'2026-11-07 12:51:22'),(73,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Ludomotrices y su Enseñanza (cursada #14)',NULL,NULL,'2026-11-07 12:53:39'),(74,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Cursada: Prácticas Ludomotrices y su Enseñanza (año 2026)',NULL,NULL,'2026-11-07 12:54:31'),(75,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Inscripción: Prácticas Ludomotrices y su Enseñanza (cursar 2026)',NULL,NULL,'2026-11-07 12:54:37'),(76,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Prácticas Ludomotrices y su Enseñanza (Cursar 2026)',NULL,NULL,'2026-11-07 12:54:52'),(77,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Ludomotrices y su Enseñanza (cursada #15)',NULL,NULL,'2026-11-07 12:55:05'),(78,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Prácticas Gimnásticas y su Enseñanza (Cursar 2026)',NULL,NULL,'2026-11-07 12:56:35'),(79,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Gimnásticas y su Enseñanza (cursada #16)',NULL,NULL,'2026-11-07 13:01:53'),(80,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de examen: Prácticas Gimnásticas y su Enseñanza (cursada #16, intento 1)',NULL,NULL,'2026-11-07 13:03:04'),(81,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Prácticas Atléticas y su Enseñanza (Cursar 2026)',NULL,NULL,'2026-11-07 13:05:00'),(82,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Atléticas y su Enseñanza (cursada #17)',NULL,NULL,'2026-11-07 13:06:46'),(83,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Prácticas de Recreación y Tiempo Libre y su Enseñanza (Cursar 2026)',NULL,NULL,'2026-11-07 13:07:13'),(84,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas de Recreación y Tiempo Libre y su Enseñanza (cursada #18)',NULL,NULL,'2026-11-07 13:08:19'),(85,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Atléticas y su Enseñanza (cursada #17)',NULL,NULL,'2026-11-07 13:09:00'),(86,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Práctica I (Cursar 2026)',NULL,NULL,'2026-11-07 13:12:58'),(87,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Práctica I (cursada #19)',NULL,NULL,'2026-11-07 13:13:34'),(88,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Filosofía (Cursar 2026)',NULL,NULL,'2026-11-07 13:18:34'),(89,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Filosofía (cursada #20)',NULL,NULL,'2026-11-07 13:18:54'),(90,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Filosofía (cursada #20)',NULL,NULL,'2026-11-07 13:19:29'),(91,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Anatomía y Fisiología (cursada #13)',NULL,NULL,'2026-11-07 13:20:29'),(92,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Historia de las Políticas Educativas en la Argentina (Cursar 2026)',NULL,NULL,'2026-11-07 13:21:26'),(93,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Historia de las Políticas Educativas en la Argentina (cursada #21)',NULL,NULL,'2026-11-07 13:21:51'),(94,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Prácticas Acuáticas y su Enseñanza (Cursar 2026)',NULL,NULL,'2026-11-07 13:31:52'),(95,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-07 15:27:03'),(96,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Acuáticas y su Enseñanza (cursada #22)',NULL,NULL,'2026-11-07 15:28:51'),(97,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-07 16:13:34'),(98,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Prácticas Motrices Expresivas y su Enseñanza (Cursar 2026)',NULL,NULL,'2026-11-07 16:14:39'),(99,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)',NULL,NULL,'2026-11-07 16:15:49'),(100,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Cursada: Prácticas Motrices Expresivas y su Enseñanza (año 2026)',NULL,NULL,'2026-11-07 16:48:10'),(101,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)',NULL,NULL,'2026-11-07 16:48:54'),(102,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Cursada: Prácticas Motrices Expresivas y su Enseñanza (año 2026)',NULL,NULL,'2026-11-07 16:54:30'),(103,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)',NULL,NULL,'2026-11-07 17:01:47'),(104,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Cursada: Prácticas Motrices Expresivas y su Enseñanza (año 2026)',NULL,NULL,'2026-11-07 17:09:18'),(105,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)',NULL,NULL,'2026-11-07 17:09:34'),(106,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-07 17:34:16'),(107,1,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-07 17:35:11'),(108,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-07 17:35:47'),(109,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-07 17:44:06'),(110,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Cursada: Prácticas Motrices Expresivas y su Enseñanza (año 2026)',NULL,NULL,'2026-11-07 17:44:14'),(111,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)',NULL,NULL,'2026-11-07 17:44:37'),(112,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Cursada: Prácticas Motrices Expresivas y su Enseñanza (año 2026)',NULL,NULL,'2026-11-07 17:46:36'),(113,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)',NULL,NULL,'2026-11-07 17:47:43'),(114,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de examen: Prácticas Motrices Expresivas y su Enseñanza (cursada #23, intento 1)',NULL,NULL,'2026-11-07 17:48:52'),(115,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Examen: Prácticas Motrices Expresivas y su Enseñanza (07/07/2026, nota 7)',NULL,NULL,'2026-11-07 18:05:07'),(116,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Cursada: Prácticas Motrices Expresivas y su Enseñanza (año 2026)',NULL,NULL,'2026-11-07 18:05:13'),(117,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)',NULL,NULL,'2026-11-07 18:06:44'),(118,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Cursada: Prácticas Motrices Expresivas y su Enseñanza (año 2026)',NULL,NULL,'2026-11-07 18:27:38'),(119,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)',NULL,NULL,'2026-11-07 18:28:37'),(120,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Cursada: Prácticas Motrices Expresivas y su Enseñanza (año 2026)',NULL,NULL,'2026-11-07 18:28:43'),(121,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)',NULL,NULL,'2026-11-07 18:56:45'),(122,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Cursada: Prácticas Motrices Expresivas y su Enseñanza (año 2026)',NULL,NULL,'2026-11-07 18:57:42'),(123,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)',NULL,NULL,'2026-11-07 18:58:03'),(124,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Cursada: Prácticas Motrices Expresivas y su Enseñanza (año 2026)',NULL,NULL,'2026-11-07 18:59:07'),(125,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)',NULL,NULL,'2026-11-07 19:00:05'),(126,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de examen: Prácticas Motrices Expresivas y su Enseñanza (cursada #23, intento 1)',NULL,NULL,'2026-11-07 19:00:39'),(127,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Examen: Prácticas Motrices Expresivas y su Enseñanza (07/07/2026, nota 6)',NULL,NULL,'2026-11-07 19:05:35'),(128,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de examen: Prácticas Motrices Expresivas y su Enseñanza (cursada #23, intento 1)',NULL,NULL,'2026-11-07 19:05:52'),(129,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Examen: Prácticas Motrices Expresivas y su Enseñanza (07/07/2026, nota 5)',NULL,NULL,'2026-11-07 19:06:04'),(130,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de examen: Prácticas Motrices Expresivas y su Enseñanza (cursada #23, intento 1)',NULL,NULL,'2026-11-07 19:06:50'),(131,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Examen: Prácticas Motrices Expresivas y su Enseñanza (07/07/2026, nota 9)',NULL,NULL,'2026-11-07 19:26:26'),(132,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Cursada: Prácticas Motrices Expresivas y su Enseñanza (año 2026)',NULL,NULL,'2026-11-07 19:26:40'),(133,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)',NULL,NULL,'2026-11-07 19:28:21'),(134,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Cursada: Prácticas Motrices Expresivas y su Enseñanza (año 2026)',NULL,NULL,'2026-11-07 19:29:04'),(135,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)',NULL,NULL,'2026-11-07 19:29:23'),(136,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de examen: Prácticas Motrices Expresivas y su Enseñanza (cursada #23, intento 1)',NULL,NULL,'2026-11-07 19:29:48'),(137,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Examen: Prácticas Motrices Expresivas y su Enseñanza (04/08/2026, nota 5)',NULL,NULL,'2026-11-07 19:42:10'),(138,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Cursada: Prácticas Motrices Expresivas y su Enseñanza (año 2026)',NULL,NULL,'2026-11-07 19:42:16'),(139,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)',NULL,NULL,'2026-11-07 19:48:25'),(140,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de examen: Prácticas Motrices Expresivas y su Enseñanza (cursada #23, intento 1)',NULL,NULL,'2026-11-07 19:48:54'),(141,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Examen: Prácticas Motrices Expresivas y su Enseñanza (06/06/2026, nota 7)',NULL,NULL,'2026-11-07 19:49:35'),(142,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Cursada: Prácticas Motrices Expresivas y su Enseñanza (año 2026)',NULL,NULL,'2026-11-07 19:49:44'),(143,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)',NULL,NULL,'2026-11-07 19:50:05'),(144,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Prácticas Deportivas II y su Enseñanza (Cursar 2026)',NULL,NULL,'2026-11-07 19:54:04'),(145,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Deportivas II y su Enseñanza (cursada #24)',NULL,NULL,'2026-11-07 19:54:22'),(146,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Cursada: Prácticas Deportivas II y su Enseñanza (año 2026)',NULL,NULL,'2026-11-07 19:55:05'),(147,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Inscripción: Prácticas Deportivas II y su Enseñanza (cursar 2026)',NULL,NULL,'2026-11-07 19:55:15'),(148,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-07 21:33:20'),(149,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-08 02:33:47'),(150,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-08 13:17:56'),(151,1,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-08 13:20:31'),(152,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-08 13:21:00'),(153,1,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-08 13:22:49'),(154,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-08 13:23:51'),(155,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Prácticas Deportivas I y su Enseñanza: Vóley (Cursar 2026)',NULL,NULL,'2026-11-08 13:26:52'),(156,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Deportivas I y su Enseñanza: Vóley (cursada #25)',NULL,NULL,'2026-11-08 13:28:17'),(157,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Prácticas Deportivas II y su Enseñanza - Handbol (Cursar 2026)',NULL,NULL,'2026-11-08 13:29:42'),(158,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Deportivas II y su Enseñanza - Handbol (cursada #26)',NULL,NULL,'2026-11-08 13:30:11'),(159,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Prácticas Deportivas II y su Enseñanza - Básquet (Cursar 2026)',NULL,NULL,'2026-11-08 13:30:45'),(160,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Deportivas II y su Enseñanza - Básquet (cursada #27)',NULL,NULL,'2026-11-08 13:31:01'),(161,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Didáctica de la Educación Física (Cursar 2026)',NULL,NULL,'2026-11-08 13:31:59'),(162,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Didáctica de la Educación Física (cursada #28)',NULL,NULL,'2026-11-08 13:32:18'),(163,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Didáctica de las Prácticas Recreativas y el Tiempo Libre (Cursar 2026)',NULL,NULL,'2026-11-08 13:33:10'),(164,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Didáctica de las Prácticas Recreativas y el Tiempo Libre (cursada #29)',NULL,NULL,'2026-11-08 13:33:45'),(165,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de examen: Didáctica de las Prácticas Recreativas y el Tiempo Libre (cursada #29, intento 1)',NULL,NULL,'2026-11-08 13:36:13'),(166,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Práctica II (Cursar 2026)',NULL,NULL,'2026-11-08 13:38:18'),(167,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Práctica II (cursada #30)',NULL,NULL,'2026-11-08 13:38:54'),(168,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de examen: Práctica II (cursada #30, intento 1)',NULL,NULL,'2026-11-08 13:39:34'),(169,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Examen: Práctica II (08/08/2026, nota 6)',NULL,NULL,'2026-11-08 13:43:31'),(170,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-08 16:20:06'),(171,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Cursada: Práctica II (año 2026)',NULL,NULL,'2026-11-08 16:29:42'),(172,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Práctica II (cursada #30)',NULL,NULL,'2026-11-08 16:30:26'),(173,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Práctica II (cursada #30)',NULL,NULL,'2026-11-08 16:30:53'),(174,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de examen: Práctica II (cursada #30, intento 1)',NULL,NULL,'2026-11-08 16:31:30'),(175,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Examen: Práctica II (07/07/2026, nota 7)',NULL,NULL,'2026-11-08 16:32:12'),(176,4,'estudiantes',4,'DELETE',NULL,NULL,'Eliminación de registro académico: Cursada: Práctica II (año 2026)',NULL,NULL,'2026-11-08 16:32:19'),(177,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-09 11:45:14'),(178,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Práctica II (cursada #30)',NULL,NULL,'2026-11-09 11:46:06'),(179,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Práctica II (cursada #30)',NULL,NULL,'2026-11-09 11:46:41'),(180,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Práctica II (cursada #30)',NULL,NULL,'2026-11-09 11:48:08'),(181,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Educación Sexual Integral (Cursar 2026)',NULL,NULL,'2026-11-09 11:52:49'),(182,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Educación Sexual Integral (cursada #31)',NULL,NULL,'2026-11-09 11:53:02'),(183,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Integración de las TIC en la Enseñanza (Cursar 2026)',NULL,NULL,'2026-11-09 11:53:54'),(184,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Integración de las TIC en la Enseñanza (cursada #32)',NULL,NULL,'2026-11-09 11:54:16'),(185,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Sociología de la Educación (Cursar 2026)',NULL,NULL,'2026-11-09 11:54:35'),(186,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Sociología de la Educación (cursada #33)',NULL,NULL,'2026-11-09 11:55:32'),(187,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Prácticas Deportivas III y su Enseñanza - Hockey (Cursar 2026)',NULL,NULL,'2026-11-09 11:57:32'),(188,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Deportivas III y su Enseñanza - Hockey (cursada #34)',NULL,NULL,'2026-11-09 12:03:46'),(189,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Prácticas Deportivas III y su Enseñanza - Rugby (Cursar 2026)',NULL,NULL,'2026-11-09 12:04:01'),(190,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Deportivas III y su Enseñanza - Rugby (cursada #35)',NULL,NULL,'2026-11-09 12:04:27'),(191,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Prácticas Deportivas III y su Enseñanza - Fútbol (Cursar 2026)',NULL,NULL,'2026-11-09 12:04:49'),(192,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Deportivas III y su Enseñanza - Fútbol (cursada #36)',NULL,NULL,'2026-11-09 12:05:17'),(193,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de examen: Prácticas Deportivas III y su Enseñanza - Fútbol (cursada #36, intento 1)',NULL,NULL,'2026-11-09 12:06:04'),(194,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Prácticas Deportivas IV y su Enseñanza - Gimnasia (Cursar 2026)',NULL,NULL,'2026-11-09 12:07:37'),(195,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Deportivas IV y su Enseñanza - Gimnasia (cursada #37)',NULL,NULL,'2026-11-09 12:08:03'),(196,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Prácticas Deportivas IV y su Enseñanza - Atletismo (Cursar 2026)',NULL,NULL,'2026-11-09 12:08:21'),(197,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Prácticas Deportivas IV y su Enseñanza - Atletismo (cursada #38)',NULL,NULL,'2026-11-09 12:08:41'),(198,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-09 18:06:05'),(199,1,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-09 18:07:48'),(200,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-09 18:08:16'),(201,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Anatomía y Fisiología (cursada #13)',NULL,NULL,'2026-11-09 18:24:44'),(202,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Sujeto de la Educación (Cursar 2026)',NULL,NULL,'2026-11-09 18:32:17'),(203,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Sujeto de la Educación (cursada #39)',NULL,NULL,'2026-11-09 18:32:39'),(204,4,'cursadas',4,'INSERT',NULL,NULL,'Alta de inscripción: Práctica en la Naturaleza y al Aire Libre y su Enseñanza (Cursar 2026)',NULL,NULL,'2026-11-09 18:33:26'),(205,4,'cursadas',4,'INSERT',NULL,NULL,'Carga de cursada: Práctica en la Naturaleza y al Aire Libre y su Enseñanza (cursada #40)',NULL,NULL,'2026-11-09 18:33:57'),(206,1,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-10 21:00:05'),(207,1,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-10 21:00:11'),(208,1,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-10 21:00:31'),(209,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-10 23:50:17'),(210,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-14 17:48:53'),(211,1,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-14 18:15:36'),(212,1,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-14 18:29:25'),(213,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-14 18:30:55'),(214,1,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-14 18:31:25'),(215,1,'usuarios',4,'UPDATE',NULL,'{\"usuario\":\"preceptora.tarde\",\"rol\":\"preceptora\",\"activo\":1}','Actualización de usuario desde administración','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36','2026-11-14 18:34:12'),(216,1,'usuarios',4,'UPDATE',NULL,'{\"usuario\":\"preceptora.tarde\",\"rol\":\"preceptora\",\"activo\":1}','Actualización de usuario desde administración','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36','2026-11-14 18:34:23'),(217,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-14 18:34:51'),(218,4,'usuarios',NULL,'UPDATE',NULL,NULL,'Cambio de contraseña',NULL,NULL,'2026-11-14 18:35:36'),(219,1,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-16 13:19:58'),(220,1,'estudiantes',6,'INSERT',NULL,NULL,'Alta de expediente: Expediente creado',NULL,NULL,'2026-11-16 13:56:11'),(221,1,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-16 13:59:59'),(222,3,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-16 14:02:16'),(223,1,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-16 14:04:23'),(224,3,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-16 14:07:45'),(225,1,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-16 14:10:03'),(226,2,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-16 14:10:25'),(227,2,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-16 14:14:37'),(228,3,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-16 14:14:43'),(229,1,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-16 14:16:51'),(230,1,'usuarios',4,'UPDATE',NULL,'{\"usuario\":\"preceptora.tarde\",\"rol\":\"preceptora\",\"activo\":1}','Actualización de usuario desde administración','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36','2026-11-16 14:17:07'),(231,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-16 14:17:13'),(232,4,'usuarios',NULL,'UPDATE',NULL,NULL,'Cambio de contraseña',NULL,NULL,'2026-11-16 14:21:01'),(233,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-16 14:22:38'),(234,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-16 14:46:52'),(235,1,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-16 14:48:02'),(236,3,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-16 14:50:56'),(237,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-16 14:56:25'),(238,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-16 19:47:44'),(239,1,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-16 19:48:12'),(240,1,'sistema',NULL,'BACKUP',NULL,NULL,'Copia de seguridad manual: respaldo_20261116_194847.sql',NULL,NULL,'2026-11-16 19:48:48'),(241,1,'sistema',NULL,'EXPORT',NULL,NULL,'Descarga de la copia respaldo_20261116_194847.sql',NULL,NULL,'2026-11-16 19:48:57'),(242,1,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-16 23:20:38'),(243,3,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-16 23:22:05'),(244,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-16 23:22:28'),(245,2,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-16 23:23:10'),(246,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-17 20:26:40'),(247,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-20 09:45:29'),(248,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-20 10:20:23'),(249,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-21 12:26:06'),(250,4,'estudiantes',6,'INSERT',NULL,NULL,'Alta de trámite: Pase #1',NULL,NULL,'2026-11-21 12:32:49'),(251,2,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-21 12:33:15'),(252,1,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-21 12:44:06'),(253,1,'sistema',NULL,'BACKUP',NULL,NULL,'Copia de seguridad manual: respaldo_20261121_124413.sql',NULL,NULL,'2026-11-21 12:44:13'),(254,1,'sistema',NULL,'EXPORT',NULL,NULL,'Descarga de la copia respaldo_20261121_124413.sql',NULL,NULL,'2026-11-21 12:44:23'),(255,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-21 13:05:07'),(256,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-21 14:00:03'),(257,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-21 15:56:06'),(258,4,'estudiantes',7,'INSERT',NULL,NULL,'Alta de expediente: Expediente creado',NULL,NULL,'2026-11-21 15:57:51'),(259,4,'estudiantes',8,'INSERT',NULL,NULL,'Alta de expediente: Expediente creado',NULL,NULL,'2026-11-21 16:26:46'),(260,4,'estudiantes',NULL,'LOGIN',NULL,NULL,'Inicio de sesión',NULL,NULL,'2026-11-21 17:08:44'),(261,4,'estudiantes',9,'INSERT',NULL,NULL,'Alta de expediente: Expediente creado',NULL,NULL,'2026-11-21 17:11:18');
/*!40000 ALTER TABLE `auditoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `carreras`
--

DROP TABLE IF EXISTS `carreras`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
INSERT INTO `carreras` VALUES (1,'Profesorado de Educación Física con orientación en Tiempo Libre y Recreación','tarde','Decreto-Resolución N° 13929-E-19',1),(2,'Profesorado de Educación Física','mañana',NULL,1);
/*!40000 ALTER TABLE `carreras` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `correlatividades`
--

DROP TABLE IF EXISTS `correlatividades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
INSERT INTO `correlatividades` VALUES (11,1,'cursar','regular'),(11,1,'rendir','aprobada'),(13,2,'cursar','regular'),(13,2,'rendir','aprobada'),(13,5,'cursar','regular'),(13,5,'rendir','aprobada'),(14,4,'cursar','regular'),(14,4,'rendir','aprobada'),(14,6,'cursar','regular'),(14,6,'rendir','aprobada'),(15,4,'cursar','regular'),(15,4,'rendir','aprobada'),(15,6,'cursar','regular'),(15,6,'rendir','aprobada'),(16,4,'cursar','regular'),(16,4,'rendir','aprobada'),(16,6,'cursar','regular'),(16,6,'rendir','aprobada'),(17,4,'cursar','regular'),(17,4,'rendir','aprobada'),(17,6,'cursar','regular'),(17,6,'rendir','aprobada'),(18,1,'cursar','regular'),(18,1,'rendir','aprobada'),(18,2,'cursar','regular'),(18,2,'rendir','aprobada'),(18,4,'cursar','regular'),(18,4,'rendir','aprobada'),(19,4,'cursar','regular'),(19,4,'rendir','aprobada'),(19,9,'cursar','regular'),(19,9,'rendir','aprobada'),(20,10,'cursar','aprobada'),(20,10,'rendir','aprobada'),(22,4,'cursar','aprobada'),(22,4,'rendir','aprobada'),(23,1,'cursar','aprobada'),(23,1,'rendir','aprobada'),(23,12,'cursar','regular'),(23,12,'rendir','aprobada'),(24,7,'cursar','aprobada'),(24,7,'rendir','aprobada'),(24,8,'cursar','aprobada'),(24,8,'rendir','aprobada'),(24,15,'cursar','regular'),(24,15,'rendir','aprobada'),(24,16,'cursar','regular'),(24,16,'rendir','aprobada'),(24,17,'cursar','regular'),(24,17,'rendir','aprobada'),(25,7,'cursar','aprobada'),(25,7,'rendir','aprobada'),(25,8,'cursar','aprobada'),(25,8,'rendir','aprobada'),(25,15,'cursar','regular'),(25,15,'rendir','aprobada'),(25,16,'cursar','regular'),(25,16,'rendir','aprobada'),(25,17,'cursar','regular'),(25,17,'rendir','aprobada'),(26,6,'cursar','aprobada'),(26,6,'rendir','aprobada'),(26,9,'cursar','aprobada'),(26,9,'rendir','aprobada'),(26,13,'cursar','regular'),(26,14,'cursar','regular'),(26,14,'rendir','aprobada'),(26,19,'cursar','regular'),(27,5,'cursar','aprobada'),(27,5,'rendir','aprobada'),(27,7,'cursar','aprobada'),(27,7,'rendir','aprobada'),(27,8,'cursar','aprobada'),(27,8,'rendir','aprobada'),(27,15,'cursar','regular'),(27,15,'rendir','aprobada'),(27,16,'cursar','regular'),(27,16,'rendir','aprobada'),(28,11,'cursar','regular'),(28,11,'rendir','aprobada'),(28,12,'cursar','regular'),(28,12,'rendir','aprobada'),(29,6,'cursar','aprobada'),(29,6,'rendir','aprobada'),(29,7,'cursar','aprobada'),(29,7,'rendir','aprobada'),(29,8,'cursar','aprobada'),(29,8,'rendir','aprobada'),(29,13,'cursar','regular'),(29,13,'rendir','aprobada'),(29,14,'cursar','regular'),(29,14,'rendir','aprobada'),(29,15,'cursar','regular'),(29,15,'rendir','aprobada'),(29,16,'cursar','regular'),(29,16,'rendir','aprobada'),(29,17,'cursar','aprobada'),(29,17,'rendir','aprobada'),(29,20,'cursar','aprobada'),(29,20,'rendir','aprobada'),(30,11,'cursar','aprobada'),(30,11,'rendir','aprobada'),(31,5,'cursar','aprobada'),(31,5,'rendir','aprobada'),(31,6,'cursar','aprobada'),(31,6,'rendir','aprobada'),(31,14,'cursar','aprobada'),(31,14,'rendir','aprobada'),(31,21,'cursar','regular'),(31,21,'rendir','aprobada'),(32,6,'cursar','aprobada'),(32,6,'rendir','aprobada'),(32,24,'cursar','regular'),(32,24,'rendir','aprobada'),(33,25,'cursar','regular'),(33,25,'rendir','aprobada'),(34,26,'cursar','regular'),(34,26,'rendir','aprobada'),(35,1,'cursar','aprobada'),(35,1,'rendir','aprobada'),(35,2,'cursar','aprobada'),(35,2,'rendir','aprobada'),(35,3,'cursar','aprobada'),(35,3,'rendir','aprobada'),(35,4,'cursar','aprobada'),(35,4,'rendir','aprobada'),(35,5,'cursar','aprobada'),(35,5,'rendir','aprobada'),(35,6,'cursar','aprobada'),(35,6,'rendir','aprobada'),(35,7,'cursar','aprobada'),(35,7,'rendir','aprobada'),(35,8,'cursar','aprobada'),(35,8,'rendir','aprobada'),(35,9,'cursar','aprobada'),(35,9,'rendir','aprobada'),(35,10,'cursar','aprobada'),(35,10,'rendir','aprobada'),(36,1,'cursar','aprobada'),(36,1,'rendir','aprobada'),(36,2,'cursar','aprobada'),(36,2,'rendir','aprobada'),(36,3,'cursar','aprobada'),(36,3,'rendir','aprobada'),(36,4,'cursar','aprobada'),(36,4,'rendir','aprobada'),(36,5,'cursar','aprobada'),(36,5,'rendir','aprobada'),(36,6,'cursar','aprobada'),(36,6,'rendir','aprobada'),(36,7,'cursar','aprobada'),(36,7,'rendir','aprobada'),(36,8,'cursar','aprobada'),(36,8,'rendir','aprobada'),(36,9,'cursar','aprobada'),(36,9,'rendir','aprobada'),(36,10,'cursar','aprobada'),(36,10,'rendir','aprobada'),(36,11,'cursar','aprobada'),(36,11,'rendir','aprobada'),(36,12,'cursar','aprobada'),(36,12,'rendir','aprobada'),(36,13,'cursar','aprobada'),(36,13,'rendir','aprobada'),(36,14,'cursar','aprobada'),(36,14,'rendir','aprobada'),(36,15,'cursar','aprobada'),(36,15,'rendir','aprobada'),(36,16,'cursar','aprobada'),(36,16,'rendir','aprobada'),(36,17,'cursar','aprobada'),(36,17,'rendir','aprobada'),(36,18,'cursar','aprobada'),(36,18,'rendir','aprobada'),(36,19,'cursar','aprobada'),(36,19,'rendir','aprobada'),(36,20,'cursar','aprobada'),(36,20,'rendir','aprobada'),(36,21,'cursar','regular'),(36,21,'rendir','aprobada'),(36,22,'cursar','regular'),(36,22,'rendir','aprobada'),(36,23,'cursar','regular'),(36,23,'rendir','aprobada'),(36,24,'cursar','regular'),(36,24,'rendir','aprobada'),(36,25,'cursar','regular'),(36,25,'rendir','aprobada'),(36,26,'cursar','regular'),(36,26,'rendir','aprobada'),(36,27,'cursar','regular'),(36,27,'rendir','aprobada'),(36,28,'cursar','regular'),(36,28,'rendir','aprobada'),(36,29,'cursar','aprobada'),(36,29,'rendir','aprobada'),(46,37,'cursar','regular'),(46,37,'rendir','aprobada'),(48,38,'cursar','regular'),(48,38,'rendir','aprobada'),(48,41,'cursar','regular'),(48,41,'rendir','aprobada'),(49,40,'cursar','regular'),(49,40,'rendir','aprobada'),(49,42,'cursar','regular'),(49,42,'rendir','aprobada'),(50,40,'cursar','regular'),(50,40,'rendir','aprobada'),(50,42,'cursar','regular'),(50,42,'rendir','aprobada'),(51,40,'cursar','regular'),(51,40,'rendir','aprobada'),(51,42,'cursar','regular'),(51,42,'rendir','aprobada'),(52,40,'cursar','regular'),(52,40,'rendir','aprobada'),(52,42,'cursar','regular'),(52,42,'rendir','aprobada'),(53,37,'cursar','regular'),(53,37,'rendir','aprobada'),(53,38,'cursar','regular'),(53,38,'rendir','aprobada'),(53,40,'cursar','regular'),(53,40,'rendir','aprobada'),(54,45,'cursar','aprobada'),(54,45,'rendir','aprobada'),(56,40,'cursar','aprobada'),(56,40,'rendir','aprobada'),(56,53,'cursar','regular'),(56,53,'rendir','aprobada'),(57,37,'cursar','aprobada'),(57,37,'rendir','aprobada'),(57,47,'cursar','regular'),(57,47,'rendir','aprobada'),(58,43,'cursar','aprobada'),(58,43,'rendir','aprobada'),(58,44,'cursar','aprobada'),(58,44,'rendir','aprobada'),(58,51,'cursar','regular'),(58,51,'rendir','aprobada'),(58,52,'cursar','regular'),(58,52,'rendir','aprobada'),(58,53,'cursar','regular'),(58,53,'rendir','aprobada'),(59,43,'cursar','aprobada'),(59,43,'rendir','aprobada'),(59,44,'cursar','aprobada'),(59,44,'rendir','aprobada'),(59,51,'cursar','regular'),(59,51,'rendir','aprobada'),(59,52,'cursar','regular'),(59,52,'rendir','aprobada'),(59,53,'cursar','regular'),(59,53,'rendir','aprobada'),(60,42,'cursar','aprobada'),(60,42,'rendir','aprobada'),(60,48,'cursar','aprobada'),(60,48,'rendir','aprobada'),(60,49,'cursar','regular'),(60,49,'rendir','aprobada'),(60,50,'cursar','regular'),(60,50,'rendir','aprobada'),(61,41,'cursar','aprobada'),(61,41,'rendir','aprobada'),(61,43,'cursar','aprobada'),(61,43,'rendir','aprobada'),(61,44,'cursar','aprobada'),(61,44,'rendir','aprobada'),(61,51,'cursar','regular'),(61,51,'rendir','aprobada'),(61,52,'cursar','regular'),(61,52,'rendir','aprobada'),(62,46,'cursar','regular'),(62,46,'rendir','aprobada'),(62,47,'cursar','regular'),(62,47,'rendir','aprobada'),(63,42,'cursar','aprobada'),(63,42,'rendir','aprobada'),(63,43,'cursar','aprobada'),(63,43,'rendir','aprobada'),(63,44,'cursar','aprobada'),(63,44,'rendir','aprobada'),(63,49,'cursar','regular'),(63,49,'rendir','aprobada'),(63,50,'cursar','regular'),(63,50,'rendir','aprobada'),(63,51,'cursar','regular'),(63,51,'rendir','aprobada'),(63,52,'cursar','regular'),(63,52,'rendir','aprobada'),(63,53,'cursar','aprobada'),(63,53,'rendir','aprobada'),(63,54,'cursar','aprobada'),(63,54,'rendir','aprobada'),(64,46,'cursar','aprobada'),(64,46,'rendir','aprobada'),(65,41,'cursar','aprobada'),(65,41,'rendir','aprobada'),(65,42,'cursar','aprobada'),(65,42,'rendir','aprobada'),(65,50,'cursar','aprobada'),(65,50,'rendir','aprobada'),(65,55,'cursar','regular'),(65,55,'rendir','aprobada'),(66,42,'cursar','aprobada'),(66,42,'rendir','aprobada'),(66,60,'cursar','regular'),(66,60,'rendir','aprobada'),(67,61,'cursar','regular'),(67,61,'rendir','aprobada'),(68,62,'cursar','regular'),(68,62,'rendir','aprobada'),(69,37,'cursar','aprobada'),(69,37,'rendir','aprobada'),(69,38,'cursar','aprobada'),(69,38,'rendir','aprobada'),(69,39,'cursar','aprobada'),(69,39,'rendir','aprobada'),(69,40,'cursar','aprobada'),(69,40,'rendir','aprobada'),(69,41,'cursar','aprobada'),(69,41,'rendir','aprobada'),(69,42,'cursar','aprobada'),(69,42,'rendir','aprobada'),(69,43,'cursar','aprobada'),(69,43,'rendir','aprobada'),(69,44,'cursar','aprobada'),(69,44,'rendir','aprobada'),(69,45,'cursar','aprobada'),(69,45,'rendir','aprobada'),(70,37,'cursar','aprobada'),(70,37,'rendir','aprobada'),(70,38,'cursar','aprobada'),(70,38,'rendir','aprobada'),(70,39,'cursar','aprobada'),(70,39,'rendir','aprobada'),(70,40,'cursar','aprobada'),(70,40,'rendir','aprobada'),(70,41,'cursar','aprobada'),(70,41,'rendir','aprobada'),(70,42,'cursar','aprobada'),(70,42,'rendir','aprobada'),(70,43,'cursar','aprobada'),(70,43,'rendir','aprobada'),(70,44,'cursar','aprobada'),(70,44,'rendir','aprobada'),(70,45,'cursar','aprobada'),(70,45,'rendir','aprobada'),(70,46,'cursar','aprobada'),(70,46,'rendir','aprobada'),(70,47,'cursar','aprobada'),(70,47,'rendir','aprobada'),(70,48,'cursar','aprobada'),(70,48,'rendir','aprobada'),(70,49,'cursar','aprobada'),(70,49,'rendir','aprobada'),(70,50,'cursar','aprobada'),(70,50,'rendir','aprobada'),(70,51,'cursar','aprobada'),(70,51,'rendir','aprobada'),(70,52,'cursar','aprobada'),(70,52,'rendir','aprobada'),(70,53,'cursar','aprobada'),(70,53,'rendir','aprobada'),(70,54,'cursar','aprobada'),(70,54,'rendir','aprobada'),(70,55,'cursar','regular'),(70,55,'rendir','aprobada'),(70,56,'cursar','regular'),(70,56,'rendir','aprobada'),(70,57,'cursar','regular'),(70,57,'rendir','aprobada'),(70,58,'cursar','regular'),(70,58,'rendir','aprobada'),(70,59,'cursar','regular'),(70,59,'rendir','aprobada'),(70,60,'cursar','regular'),(70,60,'rendir','aprobada'),(70,61,'cursar','regular'),(70,61,'rendir','aprobada'),(70,62,'cursar','regular'),(70,62,'rendir','aprobada'),(70,63,'cursar','aprobada'),(70,63,'rendir','aprobada');
/*!40000 ALTER TABLE `correlatividades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cursadas`
--

DROP TABLE IF EXISTS `cursadas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cursadas`
--

LOCK TABLES `cursadas` WRITE;
/*!40000 ALTER TABLE `cursadas` DISABLE KEYS */;
INSERT INTO `cursadas` VALUES (1,1,4,NULL,2026,NULL,'cursar','regular',40.00,60.00,4.00,NULL,NULL,'cursando',NULL),(5,3,1,NULL,2026,'2026-11-05','cursar','promocional',70.00,80.00,8.00,NULL,NULL,'promocional',''),(7,3,11,NULL,2026,'2026-11-05','cursar','promocional',90.00,90.00,9.00,NULL,NULL,'promocional',''),(9,4,1,NULL,2026,'2026-04-01','cursar','promocional',90.00,80.00,8.00,NULL,NULL,'promocional',''),(10,4,2,NULL,2026,'2026-04-01','cursar','promocional',81.00,90.00,7.00,NULL,NULL,'promocional',''),(11,4,3,NULL,2026,'2026-04-01','cursar','promocional',80.00,77.00,7.00,NULL,NULL,'promocional',''),(12,4,4,NULL,2026,'2026-04-02','cursar','regular',54.00,45.00,5.00,NULL,NULL,'regular',''),(13,4,5,NULL,2026,'2026-04-01','cursar','regular',77.00,77.00,5.00,NULL,NULL,'regular',''),(15,4,6,NULL,2026,'2026-04-01','cursar','promocional',77.00,89.00,9.00,NULL,NULL,'promocional',''),(16,4,7,NULL,2026,'2026-04-01','cursar','libre',25.00,20.00,2.00,NULL,NULL,'libre',''),(17,4,8,NULL,2026,'2026-04-01','cursar','promocional',90.00,90.00,10.00,NULL,NULL,'promocional',''),(18,4,9,NULL,2026,'2026-04-02','cursar','promocional',70.00,82.00,8.00,NULL,NULL,'promocional',''),(19,4,10,NULL,2026,'2026-04-04','cursar','promocional',90.00,90.00,8.00,NULL,NULL,'promocional',''),(20,4,11,NULL,2026,'2026-05-05','cursar','promocional',77.00,77.00,8.00,NULL,NULL,'promocional',''),(21,4,12,NULL,2026,'2026-05-05','cursar','promocional',78.00,78.00,9.00,NULL,NULL,'promocional',''),(22,4,14,NULL,2026,'2026-05-05','cursar','promocional',77.00,88.00,7.00,NULL,NULL,'promocional',''),(23,4,15,NULL,2026,'2026-05-05','cursar','promocional',77.00,77.00,7.00,NULL,NULL,'promocional',''),(25,4,16,NULL,2026,'2026-05-05','cursar','promocional',88.00,78.00,7.00,NULL,NULL,'promocional',''),(26,4,17,1,2026,'2026-05-05','cursar','promocional',78.00,78.00,9.00,NULL,NULL,'promocional',''),(27,4,17,2,2026,'2026-06-06','cursar','promocional',90.00,90.00,10.00,NULL,NULL,'promocional',''),(28,4,18,NULL,2026,'2026-06-06','cursar','promocional',78.00,90.00,7.00,NULL,NULL,'promocional',''),(29,4,19,NULL,2026,'2026-06-06','cursar','regular',55.00,40.00,5.00,NULL,NULL,'regular',''),(30,4,20,NULL,2026,'2026-06-06','cursar','libre',55.00,77.00,4.00,NULL,NULL,'libre',''),(31,4,21,NULL,2026,'2026-07-07','cursar','promocional',88.00,88.00,9.00,NULL,NULL,'promocional',''),(32,4,22,NULL,2026,'2026-09-09','cursar','promocional',77.00,77.00,8.00,NULL,NULL,'promocional',''),(33,4,23,NULL,2026,'2026-08-08','cursar','promocional',77.00,88.00,9.00,NULL,NULL,'promocional',''),(34,4,24,3,2026,'2026-09-09','cursar','promocional',88.00,88.00,8.00,NULL,NULL,'promocional',''),(35,4,24,4,2026,'2026-09-09','cursar','promocional',88.00,77.00,8.00,NULL,NULL,'promocional',''),(36,4,24,5,2026,'2026-09-08','cursar','regular',55.00,43.00,5.00,NULL,NULL,'regular',''),(37,4,25,6,2026,'2026-09-09','cursar','regular',66.00,66.00,6.00,NULL,NULL,'regular',''),(38,4,25,7,2026,'2026-09-09','cursar','promocional',77.00,89.00,8.00,NULL,NULL,'promocional',''),(39,4,13,NULL,2026,'2026-05-05','cursar','regular',55.00,66.00,6.00,NULL,NULL,'regular',''),(40,4,26,NULL,2026,'2026-09-09','cursar','promocional',77.00,77.00,7.00,NULL,NULL,'promocional','');
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
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documentacion_estudiante`
--

LOCK TABLES `documentacion_estudiante` WRITE;
/*!40000 ALTER TABLE `documentacion_estudiante` DISABLE KEYS */;
INSERT INTO `documentacion_estudiante` VALUES (1,1,1,2026,1,'2026-11-03',NULL,NULL),(2,1,2,2026,1,'2026-11-03',NULL,NULL),(3,1,3,2026,0,NULL,NULL,NULL),(4,1,4,2026,0,NULL,NULL,NULL),(5,2,1,2026,1,'2026-11-06',NULL,NULL),(6,2,2,2026,1,'2026-11-03',NULL,NULL),(7,2,3,2026,1,'2026-11-06',NULL,NULL),(8,2,4,2026,0,NULL,NULL,NULL),(9,3,1,2026,1,'2026-11-05',NULL,NULL),(10,3,2,2026,0,NULL,NULL,NULL),(11,3,3,2026,1,'2026-11-05',NULL,NULL),(12,3,4,2026,1,'2026-11-05',NULL,NULL),(29,4,1,2026,1,'2026-11-06',NULL,NULL),(30,4,2,2026,1,'2026-11-06',NULL,NULL),(31,4,3,2026,1,'2026-11-06',NULL,NULL),(32,4,4,2026,1,'2026-11-06',NULL,NULL),(33,5,1,2026,1,'2026-04-05',NULL,NULL),(34,5,2,2026,1,'2026-04-05',NULL,NULL),(35,5,3,2026,1,'2026-04-05',NULL,NULL),(36,5,4,2026,1,'2026-04-06',NULL,NULL),(37,6,1,2026,1,'2026-11-16',NULL,NULL),(38,6,2,2026,1,'2026-11-16',NULL,NULL),(39,6,3,2026,1,'2026-11-16',NULL,NULL),(40,6,4,2026,1,'2026-11-16',NULL,NULL),(41,7,1,2026,1,'2026-02-02',NULL,NULL),(42,7,2,2026,1,'2026-02-02',NULL,NULL),(43,7,3,2026,1,'2026-02-02',NULL,NULL),(44,7,4,2026,1,'2026-02-02',NULL,NULL),(45,7,5,2026,1,'2026-02-02',NULL,NULL),(46,7,6,2026,1,'2026-02-02',NULL,NULL),(47,7,7,2026,1,'2026-02-02',NULL,NULL),(48,8,1,2026,1,'2026-11-21',NULL,NULL),(49,8,2,2026,1,'2026-11-21',NULL,NULL),(50,8,3,2026,1,'2026-11-21',NULL,NULL),(51,8,4,2026,1,'2026-11-21',NULL,NULL),(52,8,5,2026,1,'2026-11-21',NULL,NULL),(53,8,6,2026,1,'2026-11-21',NULL,NULL),(54,8,7,2026,1,'2026-11-21',NULL,NULL),(55,9,1,2026,1,'2023-04-02',NULL,NULL),(56,9,2,2026,1,'2023-04-02',NULL,NULL),(57,9,3,2026,1,'2023-04-02',NULL,NULL),(58,9,4,2026,1,'2023-04-02',NULL,NULL),(59,9,5,2026,1,'2023-04-02',NULL,NULL),(60,9,6,2026,1,'2023-04-02',NULL,NULL),(61,9,7,2026,1,'2023-04-02',NULL,NULL);
/*!40000 ALTER TABLE `documentacion_estudiante` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estudiantes`
--

DROP TABLE IF EXISTS `estudiantes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estudiantes` (
  `id_estudiante` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tipo_documento` enum('DNI','LC','LE') NOT NULL DEFAULT 'DNI',
  `dni` varchar(15) NOT NULL,
  `legajo` varchar(20) DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estudiantes`
--

LOCK TABLES `estudiantes` WRITE;
/*!40000 ALTER TABLE `estudiantes` DISABLE KEYS */;
INSERT INTO `estudiantes` VALUES (1,'DNI','42529898',NULL,'Paredes','Noelia','2001-02-26','Palpala','Avenida Congreso n 201','3885249855','Tecnica en informatica','EET 1',2026,1,1,'activo',NULL,NULL,NULL,'2026-11-03 18:49:18'),(2,'DNI','42324451',NULL,'Flores','Lujan','2004-03-20','Palpala','Avenida Congreso n 444','3884728301','Tecnica en informatica','EET 1',2026,1,1,'activo',NULL,NULL,NULL,'2026-11-03 19:02:05'),(3,'DNI','392380103',NULL,'Perez','Gerardo','1997-06-12','Palpala','Avenida Congreso n 432','3885249858','Tecnica en electromecanica','EET 1',2026,1,1,'activo',NULL,NULL,NULL,'2026-11-05 19:18:42'),(4,'DNI','40927770',NULL,'Cruz','Franco Omar','1998-01-25','Palpala','puesto viejo 12','3884682114','computacion','Enet n°1',2026,1,1,'activo',NULL,NULL,NULL,'2026-11-06 17:05:59'),(5,'DNI','381234567',NULL,'Cruz','Omar Carlos','1991-09-30','Palpala','Pilar bermudez 12','3884332343','Perito mercantil','Escuela Comercial n1 \"Dr. Manuel Belgrano\"',2026,1,1,'activo',NULL,NULL,NULL,'2026-11-07 11:56:33'),(6,'DNI','343434134',NULL,'sdfgf','dasd','1998-12-12','Plapala','refdfsdf','434234','42432fsfsdfsd','sdfsdfsdfsd',2026,1,1,'activo',NULL,NULL,NULL,'2026-11-16 13:56:11'),(7,'DNI','4343434',NULL,'maria','maria','2000-01-01','fsdfsd','fsdfsdf','3999478343434','sdfsdfdsf','fgsdfsdfsdf',2026,1,1,'activo',NULL,NULL,NULL,'2026-11-21 15:57:51'),(8,'DNI','434343434',NULL,'tiag','fddsf','2000-02-02','dasdsa','fdsfsf','343434344','fdfdf','fsdfsdf',2020,1,1,'activo',NULL,NULL,NULL,'2026-11-21 16:26:46'),(9,'DNI','4343434334',NULL,'Martinez','Marta','2001-01-25','dadasdasd','tyasdfg','3434343434','afffdsfdsfsd','enet',2023,1,1,'activo',NULL,NULL,NULL,'2026-11-21 17:11:18');
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
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `examenes_finales`
--

LOCK TABLES `examenes_finales` WRITE;
/*!40000 ALTER TABLE `examenes_finales` DISABLE KEYS */;
INSERT INTO `examenes_finales` VALUES (4,4,4,NULL,12,1,'regular','2026-06-05',5.00,'presente','3','34',NULL),(5,4,7,NULL,16,1,'libre','2026-06-05',4.00,'presente','3','35',NULL),(12,4,19,NULL,29,1,'regular','2026-08-08',7.00,'presente','3','33',NULL),(15,4,24,5,36,1,'regular','2026-10-10',7.00,'presente','3','33',NULL);
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
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inscripciones_curso`
--

LOCK TABLES `inscripciones_curso` WRITE;
/*!40000 ALTER TABLE `inscripciones_curso` DISABLE KEYS */;
INSERT INTO `inscripciones_curso` VALUES (1,3,'2026-11-05',1,'cursando',NULL),(2,4,'2026-11-06',1,'cursando',NULL),(3,5,'2026-04-04',1,'cursando',NULL),(4,6,'2026-11-16',1,'cursando',NULL),(5,7,'2026-04-01',1,'cursando',NULL),(6,8,'2024-11-21',1,'cursando',NULL),(7,9,'2023-04-04',1,'cursando',NULL);
/*!40000 ALTER TABLE `inscripciones_curso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inscripciones_mesa`
--

DROP TABLE IF EXISTS `inscripciones_mesa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inscripciones_mesa` (
  `id_inscripcion_mesa` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_estudiante` int(10) unsigned NOT NULL,
  `id_materia` int(10) unsigned NOT NULL,
  `id_submateria` int(10) unsigned DEFAULT NULL,
  `fecha_mesa` datetime NOT NULL COMMENT 'Día y hora de la mesa de examen',
  `tipo_examen` enum('Regular','Libre') NOT NULL,
  `estado` enum('inscripto','baja','presente','ausente') NOT NULL DEFAULT 'inscripto',
  `fecha_inscripcion` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_baja` datetime DEFAULT NULL,
  `id_usuario` int(10) unsigned DEFAULT NULL COMMENT 'Quién registró',
  `observaciones` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_inscripcion_mesa`),
  UNIQUE KEY `uq_mesa_alumno` (`id_estudiante`,`id_materia`,`id_submateria`,`fecha_mesa`),
  KEY `idx_mesa_fecha` (`fecha_mesa`),
  KEY `fk_mesa_materia` (`id_materia`),
  KEY `fk_mesa_submateria` (`id_submateria`),
  KEY `fk_mesa_usuario` (`id_usuario`),
  CONSTRAINT `fk_mesa_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON UPDATE CASCADE,
  CONSTRAINT `fk_mesa_materia` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON UPDATE CASCADE,
  CONSTRAINT `fk_mesa_submateria` FOREIGN KEY (`id_submateria`) REFERENCES `submaterias` (`id_submateria`) ON UPDATE CASCADE,
  CONSTRAINT `fk_mesa_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE
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
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `materias`
--

LOCK TABLES `materias` WRITE;
/*!40000 ALTER TABLE `materias` DISABLE KEYS */;
INSERT INTO `materias` VALUES (1,1,'01','Pedagogía',1,1,'promocion_o_examen_final',1,1),(2,1,'02','Psicología Educacional',1,2,'promocion_o_examen_final',1,1),(3,1,'03','Alfabetización Académica',1,3,'promocion_o_examen_final',0,1),(4,1,'04','Didáctica General',1,4,'promocion_o_examen_final',0,1),(5,1,'11','Anatomía y Fisiología',1,5,'promocion_o_examen_final',0,1),(6,1,'12','Prácticas Ludomotrices y su Enseñanza',1,6,'promocion_o_examen_final',0,1),(7,1,'13','Prácticas Gimnásticas y su Enseñanza',1,7,'promocion_o_examen_final',0,1),(8,1,'14','Prácticas Atléticas y su Enseñanza',1,8,'promocion_o_examen_final',0,1),(9,1,'15','Prácticas de Recreación y Tiempo Libre y su Enseñanza',1,9,'promocion_o_examen_final',0,1),(10,1,'32','Práctica I',1,10,'promocion',0,1),(11,1,'05','Filosofía',2,1,'promocion_o_examen_final',1,1),(12,1,'06','Historia de las Políticas Educativas en la Argentina',2,2,'promocion_o_examen_final',1,1),(13,1,'16','Sujeto de la Educación',2,3,'examen_final',0,1),(14,1,'17','Prácticas Acuáticas y su Enseñanza',2,4,'promocion_o_examen_final',0,1),(15,1,'18','Prácticas Motrices Expresivas y su Enseñanza',2,5,'promocion_o_examen_final',0,1),(16,1,'19','Prácticas Deportivas I y su Enseñanza: Vóley',2,6,'promocion_o_examen_final',0,1),(17,1,'20','Prácticas Deportivas II y su Enseñanza',2,7,'promocion_o_examen_final',0,1),(18,1,'21','Didáctica de la Educación Física',2,8,'examen_final',0,1),(19,1,'22','Didáctica de las Prácticas Recreativas y el Tiempo Libre',2,9,'promocion_o_examen_final',0,1),(20,1,'33','Práctica II',2,10,'promocion',0,1),(21,1,'07','Educación Sexual Integral',3,1,'promocion_o_examen_final',0,1),(22,1,'08','Integración de las TIC en la Enseñanza',3,2,'promocion_o_examen_final',0,1),(23,1,'09','Sociología de la Educación',3,3,'promocion_o_examen_final',0,1),(24,1,'23','Prácticas Deportivas III y su Enseñanza',3,4,'promocion_o_examen_final',0,1),(25,1,'24','Prácticas Deportivas IV y su Enseñanza',3,5,'promocion_o_examen_final',0,1),(26,1,'25','Práctica en la Naturaleza y al Aire Libre y su Enseñanza',3,6,'promocion_o_examen_final',0,1),(27,1,'26','Entrenamiento para la Actividad Física',3,7,'examen_final',0,1),(28,1,'27','Historia y Epistemología de la Educación Física',3,8,'promocion_o_examen_final',0,1),(29,1,'34','Práctica III',3,9,'promocion',0,1),(30,1,'10','Ética Profesional Docente',4,1,'promocion_o_examen_final',0,1),(31,1,'28','Educación Física Inclusiva',4,2,'promocion_o_examen_final',0,1),(32,1,'29','Proyectos de Recreación y Tiempo Libre y su Enseñanza',4,3,'promocion_o_examen_final',0,1),(33,1,'30','Educación Física y Salud',4,4,'promocion_o_examen_final',0,1),(34,1,'31','Gestión de Espacios y Organizaciones Deportivas',4,5,'promocion_o_examen_final',0,1),(35,1,'36','Unidad Curricular de Definición Institucional',4,6,'promocion',0,1),(36,1,'35','Residencia Pedagógica',4,7,'promocion',0,1),(37,2,'01','Pedagogía',1,1,'promocion_o_examen_final',1,1),(38,2,'02','Psicología Educacional',1,2,'promocion_o_examen_final',1,1),(39,2,'03','Alfabetización Académica',1,3,'promocion_o_examen_final',0,1),(40,2,'04','Didáctica General',1,4,'promocion_o_examen_final',0,1),(41,2,'11','Anatomía y Fisiología',1,5,'promocion_o_examen_final',0,1),(42,2,'12','Prácticas Ludomotrices y su Enseñanza',1,6,'promocion_o_examen_final',0,1),(43,2,'13','Prácticas Gimnásticas y su Enseñanza',1,7,'promocion_o_examen_final',0,1),(44,2,'14','Prácticas Atléticas y su Enseñanza',1,8,'promocion_o_examen_final',0,1),(45,2,'30','Práctica I',1,9,'promocion',0,1),(46,2,'05','Filosofía',2,1,'promocion_o_examen_final',1,1),(47,2,'06','Historia de las Políticas Educativas en la Argentina',2,2,'promocion_o_examen_final',1,1),(48,2,'15','Sujeto de la Educación',2,3,'examen_final',0,1),(49,2,'16','Prácticas Acuáticas y su Enseñanza',2,4,'promocion_o_examen_final',0,1),(50,2,'17','Prácticas Motrices Expresivas y su Enseñanza',2,5,'promocion_o_examen_final',0,1),(51,2,'18','Prácticas Deportivas I y su Enseñanza',2,6,'promocion_o_examen_final',0,1),(52,2,'19','Prácticas Deportivas II y su Enseñanza',2,7,'promocion_o_examen_final',0,1),(53,2,'20','Didáctica de la Educación Física',2,8,'examen_final',0,1),(54,2,'31','Práctica II',2,9,'promocion',0,1),(55,2,'07','Educación Sexual Integral',3,1,'promocion_o_examen_final',0,1),(56,2,'08','Integración de las TIC en la Enseñanza',3,2,'promocion_o_examen_final',0,1),(57,2,'09','Sociología de la Educación',3,3,'promocion_o_examen_final',0,1),(58,2,'21','Prácticas Deportivas III y su Enseñanza',3,4,'promocion_o_examen_final',0,1),(59,2,'22','Prácticas Deportivas IV y su Enseñanza',3,5,'promocion_o_examen_final',0,1),(60,2,'23','Práctica en la Naturaleza y al Aire Libre y su Enseñanza',3,6,'promocion_o_examen_final',0,1),(61,2,'24','Entrenamiento para la Actividad Física',3,7,'examen_final',0,1),(62,2,'25','Historia y Epistemología de la Educación Física',3,8,'promocion_o_examen_final',0,1),(63,2,'32','Práctica III',3,9,'promocion',0,1),(64,2,'10','Ética Profesional Docente',4,1,'promocion_o_examen_final',0,1),(65,2,'26','Educación Física Inclusiva',4,2,'promocion_o_examen_final',0,1),(66,2,'27','Prácticas de Recreación y Tiempo Libre y su Enseñanza',4,3,'promocion_o_examen_final',0,1),(67,2,'28','Educación Física y Salud',4,4,'promocion_o_examen_final',0,1),(68,2,'29','Gestión de Espacios y Organizaciones Deportivas',4,5,'promocion_o_examen_final',0,1),(69,2,'34','Unidad Curricular de Definición Institucional',4,6,'promocion',0,1),(70,2,'33','Residencia Pedagógica',4,7,'promocion',0,1);
/*!40000 ALTER TABLE `materias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permisos`
--

DROP TABLE IF EXISTS `permisos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
INSERT INTO `permisos` VALUES (1,'expedientes.ver','Ver expedientes y datos personales'),(2,'expedientes.editar','Crear, editar y certificar expedientes'),(3,'tramites.ver','Ver trámites y su estado'),(4,'tramites.editar','Iniciar, modificar y resolver trámites'),(5,'notas.ver','Ver notas y situación académica'),(6,'notas.editar','Cargar y modificar notas'),(7,'usuarios.ver','Ver usuarios'),(8,'usuarios.editar','Crear y modificar usuarios'),(9,'auditoria.ver','Ver el historial de cambios'),(10,'reportes.ver','Ver e imprimir/exportar expedientes'),(11,'backups.ejecutar','Generar copias de seguridad'),(13,'semaforo.ver','Ver el semáforo de documentación'),(14,'alertas.ver','Ver alertas'),(15,'respaldos.ver','Ver copias de seguridad'),(16,'respaldos.editar','Generar copias de seguridad'),(17,'cuenta.clave','Mostrar «Mi contraseña» en el menú');
/*!40000 ALTER TABLE `permisos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `planes`
--

DROP TABLE IF EXISTS `planes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planes`
--

LOCK TABLES `planes` WRITE;
/*!40000 ALTER TABLE `planes` DISABLE KEYS */;
INSERT INTO `planes` VALUES (1,1,'Plan de Estudios 2020 — Profesorado de Educación Física con orientación en Tiempo Libre y Recreación',2020,'Resolución N° 2281-E-20',1),(2,2,'Plan de Estudios 2020 — Profesorado de Educación Física',2020,'Resolución N° 2286-E-20',1);
/*!40000 ALTER TABLE `planes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rol_permiso`
--

DROP TABLE IF EXISTS `rol_permiso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
INSERT INTO `rol_permiso` VALUES ('admin',3,1,1),('admin',4,1,1),('admin',7,1,0),('admin',8,1,1),('admin',9,1,0),('admin',10,1,1),('admin',11,1,1),('admin',15,1,0),('admin',16,1,1),('admin',17,1,0),('coordinadora',1,1,0),('coordinadora',3,1,0),('coordinadora',4,1,1),('coordinadora',5,1,0),('coordinadora',10,1,0),('coordinadora',11,1,0),('coordinadora',13,1,0),('coordinadora',14,1,0),('preceptora',1,1,0),('preceptora',2,1,1),('preceptora',3,1,0),('preceptora',4,1,1),('preceptora',5,1,0),('preceptora',6,1,1),('preceptora',10,1,0),('preceptora',11,1,0),('preceptora',13,1,0),('preceptora',14,1,0),('vicerrectora',1,1,0),('vicerrectora',3,1,0),('vicerrectora',4,1,1),('vicerrectora',5,1,0),('vicerrectora',10,1,0),('vicerrectora',11,1,0),('vicerrectora',13,1,0),('vicerrectora',14,1,0);
/*!40000 ALTER TABLE `rol_permiso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `solicitud_clave`
--

DROP TABLE IF EXISTS `solicitud_clave`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `solicitud_clave` (
  `id_solicitud` int(11) NOT NULL AUTO_INCREMENT,
  `id_usuario` int(10) unsigned NOT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `atendida` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_solicitud`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `solicitud_clave_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solicitud_clave`
--

LOCK TABLES `solicitud_clave` WRITE;
/*!40000 ALTER TABLE `solicitud_clave` DISABLE KEYS */;
INSERT INTO `solicitud_clave` VALUES (1,4,'2026-11-14 18:15:25',1),(2,4,'2026-11-16 14:16:45',1);
/*!40000 ALTER TABLE `solicitud_clave` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `submaterias`
--

DROP TABLE IF EXISTS `submaterias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `submaterias` (
  `id_submateria` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_materia` int(10) unsigned NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `orden` smallint(5) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_submateria`),
  UNIQUE KEY `uq_submaterias` (`id_materia`,`nombre`),
  CONSTRAINT `fk_submaterias_materia` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submaterias`
--

LOCK TABLES `submaterias` WRITE;
/*!40000 ALTER TABLE `submaterias` DISABLE KEYS */;
INSERT INTO `submaterias` VALUES (1,17,'Handbol',1),(2,17,'Básquet',2),(3,24,'Hockey',1),(4,24,'Rugby',2),(5,24,'Fútbol',3),(6,25,'Gimnasia',1),(7,25,'Atletismo',2),(14,51,'Vóley',1),(15,52,'Handbol',1),(16,52,'Básquet',2),(17,58,'Hockey',1),(18,58,'Rugby',2),(19,58,'Fútbol',3),(20,59,'Gimnasia',1),(21,59,'Atletismo',2);
/*!40000 ALTER TABLE `submaterias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipos_documento`
--

DROP TABLE IF EXISTS `tipos_documento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_documento`
--

LOCK TABLES `tipos_documento` WRITE;
/*!40000 ALTER TABLE `tipos_documento` DISABLE KEYS */;
INSERT INTO `tipos_documento` VALUES (1,'DNI',1,0,0,1,1),(2,'Título o constancia de título en trámite',1,0,0,2,1),(3,'Apto físico',1,1,30,3,1),(4,'Seguro SEMED',1,1,30,4,1),(5,'Partida de nacimiento',1,0,0,5,1),(6,'Planilla prontuarial',1,0,0,6,1),(7,'Carnet sanitario',1,0,0,7,1);
/*!40000 ALTER TABLE `tipos_documento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tramite_materias`
--

DROP TABLE IF EXISTS `tramite_materias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tramites`
--

LOCK TABLES `tramites` WRITE;
/*!40000 ALTER TABLE `tramites` DISABLE KEYS */;
INSERT INTO `tramites` VALUES (1,6,'pase','2026-05-05','2026-12-12','en_curso',NULL,NULL,NULL,4,1,2);
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
  -- NUEVO: sus materias se cargan despues de crearlo, asi que no puede nacer resuelto
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
  -- NUEVO: una equivalencia/asimilacion resuelta tiene que reconocer al menos una materia
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
/*!50503 SET character_set_client = utf8mb4 */;
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
INSERT INTO `usuarios` VALUES (1,'Administrador del Sistema','admin','$2y$12$BP/S9HmM73ciw3tpibuqGebwKkH5zBLZ1mSIC/bJ.iJ.mck1jGb1G','admin',NULL,1,0),(2,'Vicerrectora','vicerrectora','$2y$12$K/XmT/LPLeijnuTSE5EZue2PCP5vaSpeGS4NQ80SEgg6tQttk3EpO','vicerrectora',NULL,1,0),(3,'Coordinadora de Educación Física','coordinadora','$2y$12$hrnzwW2mhB0lmgeFb.TfKOjUDdWVeTM/o.I3dRb9DhiUtPy8a4q22','coordinadora',NULL,1,0),(4,'Preceptora Turno Tarde','preceptora.tarde','$2y$12$Pj7WiN23xHQqq4XnVLwbx.1y.3H9K61ozzFealPnp.KuhAlNqgBKW','preceptora',1,1,0);
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
 1 AS `id_carrera`,
 1 AS `mensaje`,
 1 AS `semaforo`,
 1 AS `fecha_referencia`,
 1 AS `critico`*/;
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
 1 AS `materia_objetivo`,
 1 AS `tipo_requisito`,
 1 AS `condicion`,
 1 AS `id_materia_requerida`,
 1 AS `materia_requerida`,
 1 AS `estado_requerida`,
 1 AS `cumple`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_documentacion_estado`
--

DROP TABLE IF EXISTS `v_documentacion_estado`;
/*!50001 DROP VIEW IF EXISTS `v_documentacion_estado`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
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
 1 AS `vence_el`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_documentacion_pendiente`
--

DROP TABLE IF EXISTS `v_documentacion_pendiente`;
/*!50001 DROP VIEW IF EXISTS `v_documentacion_pendiente`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_documentacion_pendiente` AS SELECT 
 1 AS `id_estudiante`,
 1 AS `apellido`,
 1 AS `nombre`,
 1 AS `dni`,
 1 AS `id_carrera`,
 1 AS `id_tipo`,
 1 AS `documento`,
 1 AS `situacion`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_inscripciones_mesa`
--

DROP TABLE IF EXISTS `v_inscripciones_mesa`;
/*!50001 DROP VIEW IF EXISTS `v_inscripciones_mesa`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_inscripciones_mesa` AS SELECT 
 1 AS `id_inscripcion_mesa`,
 1 AS `id_estudiante`,
 1 AS `id_materia`,
 1 AS `id_submateria`,
 1 AS `fecha_mesa`,
 1 AS `tipo_examen`,
 1 AS `estado`,
 1 AS `fecha_inscripcion`,
 1 AS `fecha_baja`,
 1 AS `id_usuario`,
 1 AS `observaciones`,
 1 AS `baja_en_plazo`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_materia_aprobada`
--

DROP TABLE IF EXISTS `v_materia_aprobada`;
/*!50001 DROP VIEW IF EXISTS `v_materia_aprobada`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_materia_aprobada` AS SELECT 
 1 AS `id_estudiante`,
 1 AS `id_materia`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_semaforo_documentacion`
--

DROP TABLE IF EXISTS `v_semaforo_documentacion`;
/*!50001 DROP VIEW IF EXISTS `v_semaforo_documentacion`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
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
 1 AS `semaforo`*/;
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
 1 AS `id_materia`,
 1 AS `anio`,
 1 AS `orden`,
 1 AS `materia`,
 1 AS `estado_materia`,
 1 AS `aplazos_regular`,
 1 AS `aplazos_libre`*/;
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
 1 AS `id_carrera`*/;
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
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_alertas` AS select 'documentacion' AS `tipo`,`x`.`id_estudiante` AS `id_estudiante`,`x`.`apellido` AS `apellido`,`x`.`nombre` AS `nombre`,`x`.`dni` AS `dni`,`x`.`id_carrera` AS `id_carrera`,case `x`.`estado` when 'falta' then concat('Falta presentar: ',`x`.`documento`) when 'vencido' then concat('Renovar (venció al cierre del ciclo anterior): ',`x`.`documento`) else concat('Vence el ',date_format(`x`.`vence_el`,'%d/%m/%Y'),': ',`x`.`documento`) end AS `mensaje`,case when `x`.`estado` = 'por_vencer' then 'amarillo' else 'rojo' end AS `semaforo`,`x`.`vence_el` AS `fecha_referencia`,case when `x`.`estado` in ('falta','vencido') and (`x`.`anio_ingreso` = year(curdate()) and curdate() > str_to_date(concat(year(curdate()),'-05-31'),'%Y-%m-%d') or month(curdate()) >= 9) then 1 else 0 end AS `critico` from `v_documentacion_estado` `x` where `x`.`estado` in ('falta','vencido','por_vencer') union all select 'tramite' AS `tramite`,`t`.`id_estudiante` AS `id_estudiante`,`t`.`apellido` AS `apellido`,`t`.`nombre` AS `nombre`,`t`.`dni` AS `dni`,`t`.`id_carrera` AS `id_carrera`,concat(case `t`.`situacion` when 'vencido' then 'Plazo vencido: ' else 'Plazo por vencer: ' end,`t`.`tipo`,' (límite ',date_format(`t`.`fecha_limite`,'%d/%m/%Y'),')') AS `Name_exp_7`,case `t`.`situacion` when 'vencido' then 'rojo' else 'amarillo' end AS `CASE t.situacion WHEN 'vencido' THEN 'rojo' ELSE 'amarillo' END`,`t`.`fecha_limite` AS `fecha_limite`,case `t`.`situacion` when 'vencido' then 1 else 0 end AS `CASE t.situacion WHEN 'vencido' THEN 1 ELSE 0 END` from `v_tramites_pendientes` `t` where `t`.`situacion` in ('vencido','por_vencer') union all select 'regularidad' AS `regularidad`,`e`.`id_estudiante` AS `id_estudiante`,`e`.`apellido` AS `apellido`,`e`.`nombre` AS `nombre`,`e`.`dni` AS `dni`,`e`.`id_carrera` AS `id_carrera`,concat(case when `c`.`anio_cursada` + 2 < year(curdate()) then 'Regularidad vencida: ' else 'Último año de regularidad: ' end,`m`.`nombre`,coalesce(concat(' - ',`s`.`nombre`),'')) AS `Name_exp_7`,case when `c`.`anio_cursada` + 2 < year(curdate()) then 'rojo' else 'amarillo' end AS `Name_exp_8`,str_to_date(concat(`c`.`anio_cursada` + 2,'-12-31'),'%Y-%m-%d') AS `STR_TO_DATE(CONCAT(c.anio_cursada + 2, '-12-31'), '%Y-%m-%d')`,case when `c`.`anio_cursada` + 2 < year(curdate()) then 1 else 0 end AS `CASE WHEN c.anio_cursada + 2 < YEAR(CURDATE()) THEN 1 ELSE 0 END` from (((`cursadas` `c` join `estudiantes` `e` on(`e`.`id_estudiante` = `c`.`id_estudiante`)) join `materias` `m` on(`m`.`id_materia` = `c`.`id_materia`)) left join `submaterias` `s` on(`s`.`id_submateria` = `c`.`id_submateria`)) where `c`.`caracter` in ('regular','promocional') and `c`.`anio_cursada` + 2 <= year(curdate()) and `e`.`estado` = 'activo' and !exists(select 1 from `v_materia_aprobada` `a` where `a`.`id_estudiante` = `c`.`id_estudiante` and `a`.`id_materia` = `c`.`id_materia` limit 1) */;
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
-- Final view structure for view `v_inscripciones_mesa`
--

/*!50001 DROP VIEW IF EXISTS `v_inscripciones_mesa`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_inscripciones_mesa` AS select `m`.`id_inscripcion_mesa` AS `id_inscripcion_mesa`,`m`.`id_estudiante` AS `id_estudiante`,`m`.`id_materia` AS `id_materia`,`m`.`id_submateria` AS `id_submateria`,`m`.`fecha_mesa` AS `fecha_mesa`,`m`.`tipo_examen` AS `tipo_examen`,`m`.`estado` AS `estado`,`m`.`fecha_inscripcion` AS `fecha_inscripcion`,`m`.`fecha_baja` AS `fecha_baja`,`m`.`id_usuario` AS `id_usuario`,`m`.`observaciones` AS `observaciones`,case when `m`.`estado` = 'baja' and `m`.`fecha_baja` is not null then if(`m`.`fecha_baja` <= `m`.`fecha_mesa` - interval 72 hour,1,0) else NULL end AS `baja_en_plazo` from `inscripciones_mesa` `m` */;
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

-- Dump completed on 2026-11-22 12:58:21
