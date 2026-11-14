-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 14-11-2026 a las 22:36:39
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
  `ip` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `auditoria`
--

INSERT INTO `auditoria` (`id_auditoria`, `id_usuario`, `tabla`, `registro_id`, `accion`, `datos_anteriores`, `datos_nuevos`, `motivo`, `ip`, `user_agent`, `fecha`) VALUES
(1, 1, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-03 18:48:14'),
(2, 1, 'estudiantes', 1, 'INSERT', NULL, NULL, 'Alta de expediente: Expediente creado', NULL, NULL, '2026-11-03 18:49:18'),
(3, 1, 'cursadas', 1, 'INSERT', NULL, NULL, 'Carga de cursada: Didáctica General (2026)', NULL, NULL, '2026-11-03 18:49:44'),
(4, 1, 'estudiantes', 2, 'INSERT', NULL, NULL, 'Alta de expediente: Expediente creado', NULL, NULL, '2026-11-03 19:02:05'),
(5, 1, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-05 17:57:07'),
(6, 1, 'cursadas', 2, 'INSERT', NULL, NULL, 'Alta de inscripción: Prácticas Deportivas II y su Enseñanza - Handbol (Cursar 2026)', NULL, NULL, '2026-11-05 18:25:55'),
(7, 1, 'cursadas', 2, 'INSERT', NULL, NULL, 'Alta de inscripción: Prácticas Deportivas III y su Enseñanza - Rugby (Cursar 2026)', NULL, NULL, '2026-11-05 18:26:40'),
(8, 1, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-05 19:10:13'),
(9, 1, 'estudiantes', 3, 'INSERT', NULL, NULL, 'Alta de expediente: Expediente creado', NULL, NULL, '2026-11-05 19:18:42'),
(10, 1, 'estudiantes', 3, 'UPDATE', NULL, NULL, 'Modificación de expediente: Sin cambios', NULL, NULL, '2026-11-05 19:19:43'),
(11, 1, 'cursadas', 3, 'INSERT', NULL, NULL, 'Alta de inscripción: Prácticas Deportivas II y su Enseñanza - Handbol (Cursar 2026)', NULL, NULL, '2026-11-05 20:23:53'),
(12, 1, 'cursadas', 3, 'INSERT', NULL, NULL, 'Alta de inscripción: Pedagogía (Cursar 2026)', NULL, NULL, '2026-11-05 20:24:02'),
(13, 1, 'cursadas', 3, 'INSERT', NULL, NULL, 'Carga de cursada: Pedagogía (cursada #5)', NULL, NULL, '2026-11-05 20:24:26'),
(14, 1, 'cursadas', 3, 'INSERT', NULL, NULL, 'Carga de cursada: Pedagogía (cursada #5)', NULL, NULL, '2026-11-05 20:27:48'),
(15, 1, 'cursadas', 3, 'INSERT', NULL, NULL, 'Alta de inscripción: Sujeto de la Educación (Cursar 2026)', NULL, NULL, '2026-11-05 20:32:17'),
(16, 1, 'estudiantes', 3, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Inscripción: Sujeto de la Educación (cursar 2026)', NULL, NULL, '2026-11-05 20:38:58'),
(17, 1, 'estudiantes', 3, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Inscripción: Prácticas Deportivas II y su Enseñanza - Handbol (cursar 2026)', NULL, NULL, '2026-11-05 20:39:03'),
(18, 1, 'cursadas', 3, 'INSERT', NULL, NULL, 'Alta de inscripción: Filosofía (Cursar 2026)', NULL, NULL, '2026-11-05 20:40:08'),
(19, 1, 'cursadas', 3, 'INSERT', NULL, NULL, 'Alta de examen: Pedagogía (cursada #5, intento 1)', NULL, NULL, '2026-11-05 20:46:40'),
(20, 1, 'estudiantes', 3, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Examen: Pedagogía (11/02/2026, nota 10)', NULL, NULL, '2026-11-05 21:03:05'),
(21, 1, 'cursadas', 3, 'INSERT', NULL, NULL, 'Alta de examen: Pedagogía (cursada #5, intento 1)', NULL, NULL, '2026-11-05 21:03:37'),
(22, 1, 'cursadas', 3, 'INSERT', NULL, NULL, 'Carga de cursada: Filosofía (cursada #7)', NULL, NULL, '2026-11-05 21:05:20'),
(23, 1, 'cursadas', 3, 'INSERT', NULL, NULL, 'Alta de examen: Filosofía (cursada #7, intento 1)', NULL, NULL, '2026-11-05 21:05:50'),
(24, 1, 'estudiantes', 3, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Examen: Filosofía (29/09/2026, nota 10)', NULL, NULL, '2026-11-05 21:29:14'),
(25, 1, 'cursadas', 3, 'INSERT', NULL, NULL, 'Alta de inscripción: Práctica I - Práctica en terreno (Cursar 2026)', NULL, NULL, '2026-11-05 21:36:05'),
(26, 1, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-05 22:39:27'),
(27, 1, 'estudiantes', 3, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Inscripción: Práctica I - Práctica en terreno (cursar 2026)', NULL, NULL, '2026-11-05 22:46:26'),
(28, 2, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-05 22:51:05'),
(29, 1, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-05 22:51:43'),
(30, 3, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-05 22:52:07'),
(31, 4, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-05 22:53:38'),
(32, 1, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-06 09:55:19'),
(33, 1, 'estudiantes', 2, 'UPDATE', NULL, NULL, 'Modificación de expediente: Campos: documentacion', NULL, NULL, '2026-11-06 09:56:33'),
(34, 1, 'estudiantes', 2, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Inscripción: Prácticas Deportivas II y su Enseñanza - Handbol (cursar 2026)', NULL, NULL, '2026-11-06 09:56:52'),
(35, 1, 'estudiantes', 2, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Inscripción: Prácticas Deportivas III y su Enseñanza - Rugby (cursar 2026)', NULL, NULL, '2026-11-06 09:56:56'),
(36, 1, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-06 11:44:56'),
(37, 1, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-06 12:20:19'),
(38, 1, 'estudiantes', 3, 'UPDATE', NULL, NULL, 'Modificación de expediente: Campos: dni, apellido, fecha_nacimiento, domicilio', NULL, NULL, '2026-11-06 12:20:55'),
(39, 1, 'estudiantes', 1, 'UPDATE', NULL, NULL, 'Modificación de expediente: Campos: domicilio', NULL, NULL, '2026-11-06 12:22:14'),
(40, 1, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-06 16:57:13'),
(41, 1, 'estudiantes', 4, 'INSERT', NULL, NULL, 'Alta de expediente: Expediente creado', NULL, NULL, '2026-11-06 17:05:59'),
(42, 4, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-06 17:12:26'),
(43, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Pedagogía (Cursar 2026)', NULL, NULL, '2026-11-06 17:15:19'),
(44, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Pedagogía (cursada #8)', NULL, NULL, '2026-11-06 17:17:23'),
(45, 1, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-06 17:18:20'),
(46, 2, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-06 17:24:04'),
(47, 4, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-06 22:05:34'),
(48, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Pedagogía (cursada #8)', NULL, NULL, '2026-11-06 22:24:27'),
(49, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de examen: Pedagogía (cursada #8, intento 1)', NULL, NULL, '2026-11-06 22:25:46'),
(50, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Examen: Pedagogía (15/07/2026, nota 8)', NULL, NULL, '2026-11-06 22:37:23'),
(51, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de examen: Pedagogía (cursada #8, intento 1)', NULL, NULL, '2026-11-06 22:38:38'),
(52, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de examen: Pedagogía (cursada #8, intento 2)', NULL, NULL, '2026-11-06 22:39:18'),
(53, 4, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-07 11:38:50'),
(54, 4, 'estudiantes', 5, 'INSERT', NULL, NULL, 'Alta de expediente: Expediente creado', NULL, NULL, '2026-11-07 11:56:33'),
(55, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Examen: Pedagogía (01/11/2026, nota 3)', NULL, NULL, '2026-11-07 12:02:43'),
(56, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Examen: Pedagogía (04/11/2026, nota 5)', NULL, NULL, '2026-11-07 12:02:47'),
(57, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Cursada: Pedagogía (año 2026)', NULL, NULL, '2026-11-07 12:03:05'),
(58, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Inscripción: Pedagogía (cursar 2026)', NULL, NULL, '2026-11-07 12:03:09'),
(59, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Pedagogía (Cursar 2026)', NULL, NULL, '2026-11-07 12:03:30'),
(60, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Pedagogía (cursada #9)', NULL, NULL, '2026-11-07 12:24:59'),
(61, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Psicología Educacional (Cursar 2026)', NULL, NULL, '2026-11-07 12:27:04'),
(62, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Psicología Educacional (cursada #10)', NULL, NULL, '2026-11-07 12:27:27'),
(63, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Alfabetización Académica (Cursar 2026)', NULL, NULL, '2026-11-07 12:35:10'),
(64, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Alfabetización Académica (cursada #11)', NULL, NULL, '2026-11-07 12:38:39'),
(65, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Didáctica General (Cursar 2026)', NULL, NULL, '2026-11-07 12:40:05'),
(66, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Didáctica General (cursada #12)', NULL, NULL, '2026-11-07 12:40:35'),
(67, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Cursada: Didáctica General (año 2026)', NULL, NULL, '2026-11-07 12:43:29'),
(68, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Didáctica General (cursada #12)', NULL, NULL, '2026-11-07 12:44:12'),
(69, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de examen: Didáctica General (cursada #12, intento 1)', NULL, NULL, '2026-11-07 12:44:57'),
(70, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Anatomía y Fisiología (Cursar 2026)', NULL, NULL, '2026-11-07 12:47:53'),
(71, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Anatomía y Fisiología (cursada #13)', NULL, NULL, '2026-11-07 12:48:30'),
(72, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Prácticas Ludomotrices y su Enseñanza (Cursar 2026)', NULL, NULL, '2026-11-07 12:51:22'),
(73, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Ludomotrices y su Enseñanza (cursada #14)', NULL, NULL, '2026-11-07 12:53:39'),
(74, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Cursada: Prácticas Ludomotrices y su Enseñanza (año 2026)', NULL, NULL, '2026-11-07 12:54:31'),
(75, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Inscripción: Prácticas Ludomotrices y su Enseñanza (cursar 2026)', NULL, NULL, '2026-11-07 12:54:37'),
(76, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Prácticas Ludomotrices y su Enseñanza (Cursar 2026)', NULL, NULL, '2026-11-07 12:54:52'),
(77, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Ludomotrices y su Enseñanza (cursada #15)', NULL, NULL, '2026-11-07 12:55:05'),
(78, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Prácticas Gimnásticas y su Enseñanza (Cursar 2026)', NULL, NULL, '2026-11-07 12:56:35'),
(79, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Gimnásticas y su Enseñanza (cursada #16)', NULL, NULL, '2026-11-07 13:01:53'),
(80, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de examen: Prácticas Gimnásticas y su Enseñanza (cursada #16, intento 1)', NULL, NULL, '2026-11-07 13:03:04'),
(81, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Prácticas Atléticas y su Enseñanza (Cursar 2026)', NULL, NULL, '2026-11-07 13:05:00'),
(82, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Atléticas y su Enseñanza (cursada #17)', NULL, NULL, '2026-11-07 13:06:46'),
(83, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Prácticas de Recreación y Tiempo Libre y su Enseñanza (Cursar 2026)', NULL, NULL, '2026-11-07 13:07:13'),
(84, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas de Recreación y Tiempo Libre y su Enseñanza (cursada #18)', NULL, NULL, '2026-11-07 13:08:19'),
(85, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Atléticas y su Enseñanza (cursada #17)', NULL, NULL, '2026-11-07 13:09:00'),
(86, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Práctica I (Cursar 2026)', NULL, NULL, '2026-11-07 13:12:58'),
(87, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Práctica I (cursada #19)', NULL, NULL, '2026-11-07 13:13:34'),
(88, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Filosofía (Cursar 2026)', NULL, NULL, '2026-11-07 13:18:34'),
(89, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Filosofía (cursada #20)', NULL, NULL, '2026-11-07 13:18:54'),
(90, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Filosofía (cursada #20)', NULL, NULL, '2026-11-07 13:19:29'),
(91, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Anatomía y Fisiología (cursada #13)', NULL, NULL, '2026-11-07 13:20:29'),
(92, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Historia de las Políticas Educativas en la Argentina (Cursar 2026)', NULL, NULL, '2026-11-07 13:21:26'),
(93, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Historia de las Políticas Educativas en la Argentina (cursada #21)', NULL, NULL, '2026-11-07 13:21:51'),
(94, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Prácticas Acuáticas y su Enseñanza (Cursar 2026)', NULL, NULL, '2026-11-07 13:31:52'),
(95, 4, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-07 15:27:03'),
(96, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Acuáticas y su Enseñanza (cursada #22)', NULL, NULL, '2026-11-07 15:28:51'),
(97, 4, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-07 16:13:34'),
(98, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Prácticas Motrices Expresivas y su Enseñanza (Cursar 2026)', NULL, NULL, '2026-11-07 16:14:39'),
(99, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)', NULL, NULL, '2026-11-07 16:15:49'),
(100, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Cursada: Prácticas Motrices Expresivas y su Enseñanza (año 2026)', NULL, NULL, '2026-11-07 16:48:10'),
(101, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)', NULL, NULL, '2026-11-07 16:48:54'),
(102, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Cursada: Prácticas Motrices Expresivas y su Enseñanza (año 2026)', NULL, NULL, '2026-11-07 16:54:30'),
(103, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)', NULL, NULL, '2026-11-07 17:01:47'),
(104, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Cursada: Prácticas Motrices Expresivas y su Enseñanza (año 2026)', NULL, NULL, '2026-11-07 17:09:18'),
(105, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)', NULL, NULL, '2026-11-07 17:09:34'),
(106, 4, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-07 17:34:16'),
(107, 1, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-07 17:35:11'),
(108, 4, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-07 17:35:47'),
(109, 4, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-07 17:44:06'),
(110, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Cursada: Prácticas Motrices Expresivas y su Enseñanza (año 2026)', NULL, NULL, '2026-11-07 17:44:14'),
(111, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)', NULL, NULL, '2026-11-07 17:44:37'),
(112, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Cursada: Prácticas Motrices Expresivas y su Enseñanza (año 2026)', NULL, NULL, '2026-11-07 17:46:36'),
(113, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)', NULL, NULL, '2026-11-07 17:47:43'),
(114, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de examen: Prácticas Motrices Expresivas y su Enseñanza (cursada #23, intento 1)', NULL, NULL, '2026-11-07 17:48:52'),
(115, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Examen: Prácticas Motrices Expresivas y su Enseñanza (07/07/2026, nota 7)', NULL, NULL, '2026-11-07 18:05:07'),
(116, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Cursada: Prácticas Motrices Expresivas y su Enseñanza (año 2026)', NULL, NULL, '2026-11-07 18:05:13'),
(117, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)', NULL, NULL, '2026-11-07 18:06:44'),
(118, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Cursada: Prácticas Motrices Expresivas y su Enseñanza (año 2026)', NULL, NULL, '2026-11-07 18:27:38'),
(119, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)', NULL, NULL, '2026-11-07 18:28:37'),
(120, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Cursada: Prácticas Motrices Expresivas y su Enseñanza (año 2026)', NULL, NULL, '2026-11-07 18:28:43'),
(121, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)', NULL, NULL, '2026-11-07 18:56:45'),
(122, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Cursada: Prácticas Motrices Expresivas y su Enseñanza (año 2026)', NULL, NULL, '2026-11-07 18:57:42'),
(123, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)', NULL, NULL, '2026-11-07 18:58:03'),
(124, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Cursada: Prácticas Motrices Expresivas y su Enseñanza (año 2026)', NULL, NULL, '2026-11-07 18:59:07'),
(125, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)', NULL, NULL, '2026-11-07 19:00:05'),
(126, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de examen: Prácticas Motrices Expresivas y su Enseñanza (cursada #23, intento 1)', NULL, NULL, '2026-11-07 19:00:39'),
(127, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Examen: Prácticas Motrices Expresivas y su Enseñanza (07/07/2026, nota 6)', NULL, NULL, '2026-11-07 19:05:35'),
(128, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de examen: Prácticas Motrices Expresivas y su Enseñanza (cursada #23, intento 1)', NULL, NULL, '2026-11-07 19:05:52'),
(129, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Examen: Prácticas Motrices Expresivas y su Enseñanza (07/07/2026, nota 5)', NULL, NULL, '2026-11-07 19:06:04'),
(130, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de examen: Prácticas Motrices Expresivas y su Enseñanza (cursada #23, intento 1)', NULL, NULL, '2026-11-07 19:06:50'),
(131, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Examen: Prácticas Motrices Expresivas y su Enseñanza (07/07/2026, nota 9)', NULL, NULL, '2026-11-07 19:26:26'),
(132, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Cursada: Prácticas Motrices Expresivas y su Enseñanza (año 2026)', NULL, NULL, '2026-11-07 19:26:40'),
(133, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)', NULL, NULL, '2026-11-07 19:28:21'),
(134, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Cursada: Prácticas Motrices Expresivas y su Enseñanza (año 2026)', NULL, NULL, '2026-11-07 19:29:04'),
(135, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)', NULL, NULL, '2026-11-07 19:29:23'),
(136, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de examen: Prácticas Motrices Expresivas y su Enseñanza (cursada #23, intento 1)', NULL, NULL, '2026-11-07 19:29:48'),
(137, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Examen: Prácticas Motrices Expresivas y su Enseñanza (04/08/2026, nota 5)', NULL, NULL, '2026-11-07 19:42:10'),
(138, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Cursada: Prácticas Motrices Expresivas y su Enseñanza (año 2026)', NULL, NULL, '2026-11-07 19:42:16'),
(139, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)', NULL, NULL, '2026-11-07 19:48:25'),
(140, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de examen: Prácticas Motrices Expresivas y su Enseñanza (cursada #23, intento 1)', NULL, NULL, '2026-11-07 19:48:54'),
(141, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Examen: Prácticas Motrices Expresivas y su Enseñanza (06/06/2026, nota 7)', NULL, NULL, '2026-11-07 19:49:35'),
(142, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Cursada: Prácticas Motrices Expresivas y su Enseñanza (año 2026)', NULL, NULL, '2026-11-07 19:49:44'),
(143, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Motrices Expresivas y su Enseñanza (cursada #23)', NULL, NULL, '2026-11-07 19:50:05'),
(144, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Prácticas Deportivas II y su Enseñanza (Cursar 2026)', NULL, NULL, '2026-11-07 19:54:04'),
(145, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Deportivas II y su Enseñanza (cursada #24)', NULL, NULL, '2026-11-07 19:54:22'),
(146, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Cursada: Prácticas Deportivas II y su Enseñanza (año 2026)', NULL, NULL, '2026-11-07 19:55:05'),
(147, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Inscripción: Prácticas Deportivas II y su Enseñanza (cursar 2026)', NULL, NULL, '2026-11-07 19:55:15'),
(148, 4, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-07 21:33:20'),
(149, 4, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-08 02:33:47'),
(150, 4, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-08 13:17:56'),
(151, 1, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-08 13:20:31'),
(152, 4, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-08 13:21:00'),
(153, 1, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-08 13:22:49'),
(154, 4, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-08 13:23:51'),
(155, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Prácticas Deportivas I y su Enseñanza: Vóley (Cursar 2026)', NULL, NULL, '2026-11-08 13:26:52'),
(156, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Deportivas I y su Enseñanza: Vóley (cursada #25)', NULL, NULL, '2026-11-08 13:28:17'),
(157, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Prácticas Deportivas II y su Enseñanza - Handbol (Cursar 2026)', NULL, NULL, '2026-11-08 13:29:42'),
(158, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Deportivas II y su Enseñanza - Handbol (cursada #26)', NULL, NULL, '2026-11-08 13:30:11'),
(159, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Prácticas Deportivas II y su Enseñanza - Básquet (Cursar 2026)', NULL, NULL, '2026-11-08 13:30:45'),
(160, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Deportivas II y su Enseñanza - Básquet (cursada #27)', NULL, NULL, '2026-11-08 13:31:01'),
(161, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Didáctica de la Educación Física (Cursar 2026)', NULL, NULL, '2026-11-08 13:31:59'),
(162, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Didáctica de la Educación Física (cursada #28)', NULL, NULL, '2026-11-08 13:32:18'),
(163, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Didáctica de las Prácticas Recreativas y el Tiempo Libre (Cursar 2026)', NULL, NULL, '2026-11-08 13:33:10'),
(164, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Didáctica de las Prácticas Recreativas y el Tiempo Libre (cursada #29)', NULL, NULL, '2026-11-08 13:33:45'),
(165, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de examen: Didáctica de las Prácticas Recreativas y el Tiempo Libre (cursada #29, intento 1)', NULL, NULL, '2026-11-08 13:36:13'),
(166, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Práctica II (Cursar 2026)', NULL, NULL, '2026-11-08 13:38:18'),
(167, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Práctica II (cursada #30)', NULL, NULL, '2026-11-08 13:38:54'),
(168, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de examen: Práctica II (cursada #30, intento 1)', NULL, NULL, '2026-11-08 13:39:34'),
(169, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Examen: Práctica II (08/08/2026, nota 6)', NULL, NULL, '2026-11-08 13:43:31'),
(170, 4, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-08 16:20:06'),
(171, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Cursada: Práctica II (año 2026)', NULL, NULL, '2026-11-08 16:29:42'),
(172, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Práctica II (cursada #30)', NULL, NULL, '2026-11-08 16:30:26'),
(173, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Práctica II (cursada #30)', NULL, NULL, '2026-11-08 16:30:53'),
(174, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de examen: Práctica II (cursada #30, intento 1)', NULL, NULL, '2026-11-08 16:31:30'),
(175, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Examen: Práctica II (07/07/2026, nota 7)', NULL, NULL, '2026-11-08 16:32:12'),
(176, 4, 'estudiantes', 4, 'DELETE', NULL, NULL, 'Eliminación de registro académico: Cursada: Práctica II (año 2026)', NULL, NULL, '2026-11-08 16:32:19'),
(177, 4, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-09 11:45:14'),
(178, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Práctica II (cursada #30)', NULL, NULL, '2026-11-09 11:46:06'),
(179, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Práctica II (cursada #30)', NULL, NULL, '2026-11-09 11:46:41'),
(180, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Práctica II (cursada #30)', NULL, NULL, '2026-11-09 11:48:08'),
(181, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Educación Sexual Integral (Cursar 2026)', NULL, NULL, '2026-11-09 11:52:49'),
(182, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Educación Sexual Integral (cursada #31)', NULL, NULL, '2026-11-09 11:53:02'),
(183, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Integración de las TIC en la Enseñanza (Cursar 2026)', NULL, NULL, '2026-11-09 11:53:54'),
(184, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Integración de las TIC en la Enseñanza (cursada #32)', NULL, NULL, '2026-11-09 11:54:16'),
(185, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Sociología de la Educación (Cursar 2026)', NULL, NULL, '2026-11-09 11:54:35'),
(186, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Sociología de la Educación (cursada #33)', NULL, NULL, '2026-11-09 11:55:32'),
(187, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Prácticas Deportivas III y su Enseñanza - Hockey (Cursar 2026)', NULL, NULL, '2026-11-09 11:57:32'),
(188, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Deportivas III y su Enseñanza - Hockey (cursada #34)', NULL, NULL, '2026-11-09 12:03:46'),
(189, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Prácticas Deportivas III y su Enseñanza - Rugby (Cursar 2026)', NULL, NULL, '2026-11-09 12:04:01'),
(190, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Deportivas III y su Enseñanza - Rugby (cursada #35)', NULL, NULL, '2026-11-09 12:04:27'),
(191, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Prácticas Deportivas III y su Enseñanza - Fútbol (Cursar 2026)', NULL, NULL, '2026-11-09 12:04:49'),
(192, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Deportivas III y su Enseñanza - Fútbol (cursada #36)', NULL, NULL, '2026-11-09 12:05:17'),
(193, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de examen: Prácticas Deportivas III y su Enseñanza - Fútbol (cursada #36, intento 1)', NULL, NULL, '2026-11-09 12:06:04'),
(194, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Prácticas Deportivas IV y su Enseñanza - Gimnasia (Cursar 2026)', NULL, NULL, '2026-11-09 12:07:37'),
(195, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Deportivas IV y su Enseñanza - Gimnasia (cursada #37)', NULL, NULL, '2026-11-09 12:08:03'),
(196, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Prácticas Deportivas IV y su Enseñanza - Atletismo (Cursar 2026)', NULL, NULL, '2026-11-09 12:08:21'),
(197, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Prácticas Deportivas IV y su Enseñanza - Atletismo (cursada #38)', NULL, NULL, '2026-11-09 12:08:41'),
(198, 4, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-09 18:06:05'),
(199, 1, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-09 18:07:48'),
(200, 4, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-09 18:08:16'),
(201, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Anatomía y Fisiología (cursada #13)', NULL, NULL, '2026-11-09 18:24:44'),
(202, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Sujeto de la Educación (Cursar 2026)', NULL, NULL, '2026-11-09 18:32:17'),
(203, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Sujeto de la Educación (cursada #39)', NULL, NULL, '2026-11-09 18:32:39'),
(204, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Alta de inscripción: Práctica en la Naturaleza y al Aire Libre y su Enseñanza (Cursar 2026)', NULL, NULL, '2026-11-09 18:33:26'),
(205, 4, 'cursadas', 4, 'INSERT', NULL, NULL, 'Carga de cursada: Práctica en la Naturaleza y al Aire Libre y su Enseñanza (cursada #40)', NULL, NULL, '2026-11-09 18:33:57'),
(206, 1, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-10 21:00:05'),
(207, 1, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-10 21:00:11'),
(208, 1, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-10 21:00:31'),
(209, 4, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-10 23:50:17'),
(210, 4, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-14 17:48:53'),
(211, 1, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-14 18:15:36'),
(212, 1, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-14 18:29:25'),
(213, 4, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-14 18:30:55'),
(214, 1, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-14 18:31:25'),
(215, 1, 'usuarios', 4, 'UPDATE', NULL, '{\"usuario\":\"preceptora.tarde\",\"rol\":\"preceptora\",\"activo\":1}', 'Actualización de usuario desde administración', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-14 18:34:12'),
(216, 1, 'usuarios', 4, 'UPDATE', NULL, '{\"usuario\":\"preceptora.tarde\",\"rol\":\"preceptora\",\"activo\":1}', 'Actualización de usuario desde administración', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', '2026-11-14 18:34:23'),
(217, 4, 'estudiantes', NULL, 'LOGIN', NULL, NULL, 'Inicio de sesión', NULL, NULL, '2026-11-14 18:34:51'),
(218, 4, 'usuarios', NULL, 'UPDATE', NULL, NULL, 'Cambio de contraseña', NULL, NULL, '2026-11-14 18:35:36');

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

--
-- Volcado de datos para la tabla `carreras`
--

INSERT INTO `carreras` (`id_carrera`, `nombre`, `turno`, `resolucion`, `activa`) VALUES
(1, 'Profesorado de Educación Física con orientación en Tiempo Libre y Recreación', 'tarde', 'Decreto-Resolución N° 13929-E-19', 1);

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

--
-- Volcado de datos para la tabla `correlatividades`
--

INSERT INTO `correlatividades` (`id_materia`, `id_requerida`, `tipo_requisito`, `condicion`) VALUES
(11, 1, 'cursar', 'regular'),
(11, 1, 'rendir', 'aprobada'),
(13, 2, 'cursar', 'regular'),
(13, 2, 'rendir', 'aprobada'),
(13, 5, 'cursar', 'regular'),
(13, 5, 'rendir', 'aprobada'),
(14, 4, 'cursar', 'regular'),
(14, 4, 'rendir', 'aprobada'),
(14, 6, 'cursar', 'regular'),
(14, 6, 'rendir', 'aprobada'),
(15, 4, 'cursar', 'regular'),
(15, 4, 'rendir', 'aprobada'),
(15, 6, 'cursar', 'regular'),
(15, 6, 'rendir', 'aprobada'),
(16, 4, 'cursar', 'regular'),
(16, 4, 'rendir', 'aprobada'),
(16, 6, 'cursar', 'regular'),
(16, 6, 'rendir', 'aprobada'),
(17, 4, 'cursar', 'regular'),
(17, 4, 'rendir', 'aprobada'),
(17, 6, 'cursar', 'regular'),
(17, 6, 'rendir', 'aprobada'),
(18, 1, 'cursar', 'regular'),
(18, 1, 'rendir', 'aprobada'),
(18, 2, 'cursar', 'regular'),
(18, 2, 'rendir', 'aprobada'),
(18, 4, 'cursar', 'regular'),
(18, 4, 'rendir', 'aprobada'),
(19, 4, 'cursar', 'regular'),
(19, 4, 'rendir', 'aprobada'),
(19, 9, 'cursar', 'regular'),
(19, 9, 'rendir', 'aprobada'),
(20, 10, 'cursar', 'aprobada'),
(20, 10, 'rendir', 'aprobada'),
(22, 4, 'cursar', 'aprobada'),
(22, 4, 'rendir', 'aprobada'),
(23, 1, 'cursar', 'aprobada'),
(23, 1, 'rendir', 'aprobada'),
(23, 12, 'cursar', 'regular'),
(23, 12, 'rendir', 'aprobada'),
(24, 7, 'cursar', 'aprobada'),
(24, 7, 'rendir', 'aprobada'),
(24, 8, 'cursar', 'aprobada'),
(24, 8, 'rendir', 'aprobada'),
(24, 15, 'cursar', 'regular'),
(24, 15, 'rendir', 'aprobada'),
(24, 16, 'cursar', 'regular'),
(24, 16, 'rendir', 'aprobada'),
(24, 17, 'cursar', 'regular'),
(24, 17, 'rendir', 'aprobada'),
(25, 7, 'cursar', 'aprobada'),
(25, 7, 'rendir', 'aprobada'),
(25, 8, 'cursar', 'aprobada'),
(25, 8, 'rendir', 'aprobada'),
(25, 15, 'cursar', 'regular'),
(25, 15, 'rendir', 'aprobada'),
(25, 16, 'cursar', 'regular'),
(25, 16, 'rendir', 'aprobada'),
(25, 17, 'cursar', 'regular'),
(25, 17, 'rendir', 'aprobada'),
(26, 6, 'cursar', 'aprobada'),
(26, 6, 'rendir', 'aprobada'),
(26, 9, 'cursar', 'aprobada'),
(26, 9, 'rendir', 'aprobada'),
(26, 13, 'cursar', 'regular'),
(26, 14, 'cursar', 'regular'),
(26, 14, 'rendir', 'aprobada'),
(26, 19, 'cursar', 'regular'),
(27, 5, 'cursar', 'aprobada'),
(27, 5, 'rendir', 'aprobada'),
(27, 7, 'cursar', 'aprobada'),
(27, 7, 'rendir', 'aprobada'),
(27, 8, 'cursar', 'aprobada'),
(27, 8, 'rendir', 'aprobada'),
(27, 15, 'cursar', 'regular'),
(27, 15, 'rendir', 'aprobada'),
(27, 16, 'cursar', 'regular'),
(27, 16, 'rendir', 'aprobada'),
(28, 11, 'cursar', 'regular'),
(28, 11, 'rendir', 'aprobada'),
(28, 12, 'cursar', 'regular'),
(28, 12, 'rendir', 'aprobada'),
(29, 6, 'cursar', 'aprobada'),
(29, 6, 'rendir', 'aprobada'),
(29, 7, 'cursar', 'aprobada'),
(29, 7, 'rendir', 'aprobada'),
(29, 8, 'cursar', 'aprobada'),
(29, 8, 'rendir', 'aprobada'),
(29, 13, 'cursar', 'regular'),
(29, 13, 'rendir', 'aprobada'),
(29, 14, 'cursar', 'regular'),
(29, 14, 'rendir', 'aprobada'),
(29, 15, 'cursar', 'regular'),
(29, 15, 'rendir', 'aprobada'),
(29, 16, 'cursar', 'regular'),
(29, 16, 'rendir', 'aprobada'),
(29, 17, 'cursar', 'aprobada'),
(29, 17, 'rendir', 'aprobada'),
(29, 20, 'cursar', 'aprobada'),
(29, 20, 'rendir', 'aprobada'),
(30, 11, 'cursar', 'aprobada'),
(30, 11, 'rendir', 'aprobada'),
(31, 5, 'cursar', 'aprobada'),
(31, 5, 'rendir', 'aprobada'),
(31, 6, 'cursar', 'aprobada'),
(31, 6, 'rendir', 'aprobada'),
(31, 14, 'cursar', 'aprobada'),
(31, 14, 'rendir', 'aprobada'),
(31, 21, 'cursar', 'regular'),
(31, 21, 'rendir', 'aprobada'),
(32, 6, 'cursar', 'aprobada'),
(32, 6, 'rendir', 'aprobada'),
(32, 24, 'cursar', 'regular'),
(32, 24, 'rendir', 'aprobada'),
(33, 25, 'cursar', 'regular'),
(33, 25, 'rendir', 'aprobada'),
(34, 26, 'cursar', 'regular'),
(34, 26, 'rendir', 'aprobada'),
(35, 1, 'cursar', 'aprobada'),
(35, 1, 'rendir', 'aprobada'),
(35, 2, 'cursar', 'aprobada'),
(35, 2, 'rendir', 'aprobada'),
(35, 3, 'cursar', 'aprobada'),
(35, 3, 'rendir', 'aprobada'),
(35, 4, 'cursar', 'aprobada'),
(35, 4, 'rendir', 'aprobada'),
(35, 5, 'cursar', 'aprobada'),
(35, 5, 'rendir', 'aprobada'),
(35, 6, 'cursar', 'aprobada'),
(35, 6, 'rendir', 'aprobada'),
(35, 7, 'cursar', 'aprobada'),
(35, 7, 'rendir', 'aprobada'),
(35, 8, 'cursar', 'aprobada'),
(35, 8, 'rendir', 'aprobada'),
(35, 9, 'cursar', 'aprobada'),
(35, 9, 'rendir', 'aprobada'),
(35, 10, 'cursar', 'aprobada'),
(35, 10, 'rendir', 'aprobada'),
(36, 1, 'cursar', 'aprobada'),
(36, 1, 'rendir', 'aprobada'),
(36, 2, 'cursar', 'aprobada'),
(36, 2, 'rendir', 'aprobada'),
(36, 3, 'cursar', 'aprobada'),
(36, 3, 'rendir', 'aprobada'),
(36, 4, 'cursar', 'aprobada'),
(36, 4, 'rendir', 'aprobada'),
(36, 5, 'cursar', 'aprobada'),
(36, 5, 'rendir', 'aprobada'),
(36, 6, 'cursar', 'aprobada'),
(36, 6, 'rendir', 'aprobada'),
(36, 7, 'cursar', 'aprobada'),
(36, 7, 'rendir', 'aprobada'),
(36, 8, 'cursar', 'aprobada'),
(36, 8, 'rendir', 'aprobada'),
(36, 9, 'cursar', 'aprobada'),
(36, 9, 'rendir', 'aprobada'),
(36, 10, 'cursar', 'aprobada'),
(36, 10, 'rendir', 'aprobada'),
(36, 11, 'cursar', 'aprobada'),
(36, 11, 'rendir', 'aprobada'),
(36, 12, 'cursar', 'aprobada'),
(36, 12, 'rendir', 'aprobada'),
(36, 13, 'cursar', 'aprobada'),
(36, 13, 'rendir', 'aprobada'),
(36, 14, 'cursar', 'aprobada'),
(36, 14, 'rendir', 'aprobada'),
(36, 15, 'cursar', 'aprobada'),
(36, 15, 'rendir', 'aprobada'),
(36, 16, 'cursar', 'aprobada'),
(36, 16, 'rendir', 'aprobada'),
(36, 17, 'cursar', 'aprobada'),
(36, 17, 'rendir', 'aprobada'),
(36, 18, 'cursar', 'aprobada'),
(36, 18, 'rendir', 'aprobada'),
(36, 19, 'cursar', 'aprobada'),
(36, 19, 'rendir', 'aprobada'),
(36, 20, 'cursar', 'aprobada'),
(36, 20, 'rendir', 'aprobada'),
(36, 21, 'cursar', 'regular'),
(36, 21, 'rendir', 'aprobada'),
(36, 22, 'cursar', 'regular'),
(36, 22, 'rendir', 'aprobada'),
(36, 23, 'cursar', 'regular'),
(36, 23, 'rendir', 'aprobada'),
(36, 24, 'cursar', 'regular'),
(36, 24, 'rendir', 'aprobada'),
(36, 25, 'cursar', 'regular'),
(36, 25, 'rendir', 'aprobada'),
(36, 26, 'cursar', 'regular'),
(36, 26, 'rendir', 'aprobada'),
(36, 27, 'cursar', 'regular'),
(36, 27, 'rendir', 'aprobada'),
(36, 28, 'cursar', 'regular'),
(36, 28, 'rendir', 'aprobada'),
(36, 29, 'cursar', 'aprobada'),
(36, 29, 'rendir', 'aprobada');

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
-- Volcado de datos para la tabla `cursadas`
--

INSERT INTO `cursadas` (`id_cursada`, `id_estudiante`, `id_materia`, `id_submateria`, `anio_cursada`, `fecha_inscripcion`, `tipo_inscripcion`, `caracter`, `asistencia`, `tp`, `promedio`, `nota_general`, `nota_definitiva`, `estado`, `observaciones`) VALUES
(1, 1, 4, NULL, '2026', NULL, 'cursar', 'regular', 40.00, 60.00, 4.00, NULL, NULL, 'cursando', NULL),
(5, 3, 1, NULL, '2026', '2026-11-05', 'cursar', 'promocional', 70.00, 80.00, 8.00, NULL, NULL, 'promocional', ''),
(7, 3, 11, NULL, '2026', '2026-11-05', 'cursar', 'promocional', 90.00, 90.00, 9.00, NULL, NULL, 'promocional', ''),
(9, 4, 1, NULL, '2026', '2026-04-01', 'cursar', 'promocional', 90.00, 80.00, 8.00, NULL, NULL, 'promocional', ''),
(10, 4, 2, NULL, '2026', '2026-04-01', 'cursar', 'promocional', 81.00, 90.00, 7.00, NULL, NULL, 'promocional', ''),
(11, 4, 3, NULL, '2026', '2026-04-01', 'cursar', 'promocional', 80.00, 77.00, 7.00, NULL, NULL, 'promocional', ''),
(12, 4, 4, NULL, '2026', '2026-04-02', 'cursar', 'regular', 54.00, 45.00, 5.00, NULL, NULL, 'regular', ''),
(13, 4, 5, NULL, '2026', '2026-04-01', 'cursar', 'regular', 77.00, 77.00, 5.00, NULL, NULL, 'regular', ''),
(15, 4, 6, NULL, '2026', '2026-04-01', 'cursar', 'promocional', 77.00, 89.00, 9.00, NULL, NULL, 'promocional', ''),
(16, 4, 7, NULL, '2026', '2026-04-01', 'cursar', 'libre', 25.00, 20.00, 2.00, NULL, NULL, 'libre', ''),
(17, 4, 8, NULL, '2026', '2026-04-01', 'cursar', 'promocional', 90.00, 90.00, 10.00, NULL, NULL, 'promocional', ''),
(18, 4, 9, NULL, '2026', '2026-04-02', 'cursar', 'promocional', 70.00, 82.00, 8.00, NULL, NULL, 'promocional', ''),
(19, 4, 10, NULL, '2026', '2026-04-04', 'cursar', 'promocional', 90.00, 90.00, 8.00, NULL, NULL, 'promocional', ''),
(20, 4, 11, NULL, '2026', '2026-05-05', 'cursar', 'promocional', 77.00, 77.00, 8.00, NULL, NULL, 'promocional', ''),
(21, 4, 12, NULL, '2026', '2026-05-05', 'cursar', 'promocional', 78.00, 78.00, 9.00, NULL, NULL, 'promocional', ''),
(22, 4, 14, NULL, '2026', '2026-05-05', 'cursar', 'promocional', 77.00, 88.00, 7.00, NULL, NULL, 'promocional', ''),
(23, 4, 15, NULL, '2026', '2026-05-05', 'cursar', 'promocional', 77.00, 77.00, 7.00, NULL, NULL, 'promocional', ''),
(25, 4, 16, NULL, '2026', '2026-05-05', 'cursar', 'promocional', 88.00, 78.00, 7.00, NULL, NULL, 'promocional', ''),
(26, 4, 17, 1, '2026', '2026-05-05', 'cursar', 'promocional', 78.00, 78.00, 9.00, NULL, NULL, 'promocional', ''),
(27, 4, 17, 2, '2026', '2026-06-06', 'cursar', 'promocional', 90.00, 90.00, 10.00, NULL, NULL, 'promocional', ''),
(28, 4, 18, NULL, '2026', '2026-06-06', 'cursar', 'promocional', 78.00, 90.00, 7.00, NULL, NULL, 'promocional', ''),
(29, 4, 19, NULL, '2026', '2026-06-06', 'cursar', 'regular', 55.00, 40.00, 5.00, NULL, NULL, 'regular', ''),
(30, 4, 20, NULL, '2026', '2026-06-06', 'cursar', 'libre', 55.00, 77.00, 4.00, NULL, NULL, 'libre', ''),
(31, 4, 21, NULL, '2026', '2026-07-07', 'cursar', 'promocional', 88.00, 88.00, 9.00, NULL, NULL, 'promocional', ''),
(32, 4, 22, NULL, '2026', '2026-09-09', 'cursar', 'promocional', 77.00, 77.00, 8.00, NULL, NULL, 'promocional', ''),
(33, 4, 23, NULL, '2026', '2026-08-08', 'cursar', 'promocional', 77.00, 88.00, 9.00, NULL, NULL, 'promocional', ''),
(34, 4, 24, 3, '2026', '2026-09-09', 'cursar', 'promocional', 88.00, 88.00, 8.00, NULL, NULL, 'promocional', ''),
(35, 4, 24, 4, '2026', '2026-09-09', 'cursar', 'promocional', 88.00, 77.00, 8.00, NULL, NULL, 'promocional', ''),
(36, 4, 24, 5, '2026', '2026-09-08', 'cursar', 'regular', 55.00, 43.00, 5.00, NULL, NULL, 'regular', ''),
(37, 4, 25, 6, '2026', '2026-09-09', 'cursar', 'regular', 66.00, 66.00, 6.00, NULL, NULL, 'regular', ''),
(38, 4, 25, 7, '2026', '2026-09-09', 'cursar', 'promocional', 77.00, 89.00, 8.00, NULL, NULL, 'promocional', ''),
(39, 4, 13, NULL, '2026', '2026-05-05', 'cursar', 'regular', 55.00, 66.00, 6.00, NULL, NULL, 'regular', ''),
(40, 4, 26, NULL, '2026', '2026-09-09', 'cursar', 'promocional', 77.00, 77.00, 7.00, NULL, NULL, 'promocional', '');

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

--
-- Volcado de datos para la tabla `documentacion_estudiante`
--

INSERT INTO `documentacion_estudiante` (`id_documento`, `id_estudiante`, `id_tipo`, `anio_lectivo`, `presentado`, `fecha_presentacion`, `archivo`, `observaciones`) VALUES
(1, 1, 1, '2026', 1, '2026-11-03', NULL, NULL),
(2, 1, 2, '2026', 1, '2026-11-03', NULL, NULL),
(3, 1, 3, '2026', 0, NULL, NULL, NULL),
(4, 1, 4, '2026', 0, NULL, NULL, NULL),
(5, 2, 1, '2026', 1, '2026-11-06', NULL, NULL),
(6, 2, 2, '2026', 1, '2026-11-03', NULL, NULL),
(7, 2, 3, '2026', 1, '2026-11-06', NULL, NULL),
(8, 2, 4, '2026', 0, NULL, NULL, NULL),
(9, 3, 1, '2026', 1, '2026-11-05', NULL, NULL),
(10, 3, 2, '2026', 0, NULL, NULL, NULL),
(11, 3, 3, '2026', 1, '2026-11-05', NULL, NULL),
(12, 3, 4, '2026', 1, '2026-11-05', NULL, NULL),
(29, 4, 1, '2026', 1, '2026-11-06', NULL, NULL),
(30, 4, 2, '2026', 1, '2026-11-06', NULL, NULL),
(31, 4, 3, '2026', 1, '2026-11-06', NULL, NULL),
(32, 4, 4, '2026', 1, '2026-11-06', NULL, NULL),
(33, 5, 1, '2026', 1, '2026-04-05', NULL, NULL),
(34, 5, 2, '2026', 1, '2026-04-05', NULL, NULL),
(35, 5, 3, '2026', 1, '2026-04-05', NULL, NULL),
(36, 5, 4, '2026', 1, '2026-04-06', NULL, NULL);

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
-- Volcado de datos para la tabla `estudiantes`
--

INSERT INTO `estudiantes` (`id_estudiante`, `tipo_documento`, `dni`, `apellido`, `nombre`, `fecha_nacimiento`, `lugar_nacimiento`, `domicilio`, `telefono`, `titulo_ingreso`, `establecimiento`, `anio_ingreso`, `id_carrera`, `id_plan`, `estado`, `observaciones`, `certificado_por`, `fecha_certificacion`, `created_at`) VALUES
(1, 'DNI', '42529898', 'Paredes', 'Noelia', '2001-02-26', 'Palpala', 'Avenida Congreso n 201', '3885249855', 'Tecnica en informatica', 'EET 1', '2026', 1, 1, 'activo', NULL, NULL, NULL, '2026-11-03 18:49:18'),
(2, 'DNI', '42324451', 'Flores', 'Lujan', '2004-03-20', 'Palpala', 'Avenida Congreso n 444', '3884728301', 'Tecnica en informatica', 'EET 1', '2026', 1, 1, 'activo', NULL, NULL, NULL, '2026-11-03 19:02:05'),
(3, 'DNI', '392380103', 'Perez', 'Gerardo', '1997-06-12', 'Palpala', 'Avenida Congreso n 432', '3885249858', 'Tecnica en electromecanica', 'EET 1', '2026', 1, 1, 'activo', NULL, NULL, NULL, '2026-11-05 19:18:42'),
(4, 'DNI', '40927770', 'Cruz', 'Franco Omar', '1998-01-25', 'Palpala', 'puesto viejo 12', '3884682114', 'computacion', 'Enet n°1', '2026', 1, 1, 'activo', NULL, NULL, NULL, '2026-11-06 17:05:59'),
(5, 'DNI', '381234567', 'Cruz', 'Omar Carlos', '1991-09-30', 'Palpala', 'Pilar bermudez 12', '3884332343', 'Perito mercantil', 'Escuela Comercial n1 \"Dr. Manuel Belgrano\"', '2026', 1, 1, 'activo', NULL, NULL, NULL, '2026-11-07 11:56:33');

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
-- Volcado de datos para la tabla `examenes_finales`
--

INSERT INTO `examenes_finales` (`id_examen`, `id_estudiante`, `id_materia`, `id_submateria`, `id_cursada`, `numero_intento`, `condicion_alumno`, `fecha`, `nota`, `estado`, `libro`, `folio`, `observacion`) VALUES
(4, 4, 4, NULL, 12, 1, 'regular', '2026-06-05', 5.00, 'presente', '3', '34', NULL),
(5, 4, 7, NULL, 16, 1, 'libre', '2026-06-05', 4.00, 'presente', '3', '35', NULL),
(12, 4, 19, NULL, 29, 1, 'regular', '2026-08-08', 7.00, 'presente', '3', '33', NULL),
(15, 4, 24, 5, 36, 1, 'regular', '2026-10-10', 7.00, 'presente', '3', '33', NULL);

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

--
-- Volcado de datos para la tabla `inscripciones_curso`
--

INSERT INTO `inscripciones_curso` (`id_inscripcion`, `id_estudiante`, `fecha_inscripcion`, `curso`, `condicion`, `observaciones`) VALUES
(1, 3, '2026-11-05', 1, 'cursar', NULL),
(2, 4, '2026-11-06', 1, 'cursar', NULL),
(3, 5, '2026-04-04', 1, 'cursar', NULL);

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

--
-- Volcado de datos para la tabla `materias`
--

INSERT INTO `materias` (`id_materia`, `id_plan`, `codigo`, `nombre`, `anio`, `orden`, `regimen_acreditacion`, `permite_libre`, `activa`) VALUES
(1, 1, '01', 'Pedagogía', 1, 1, 'promocion_o_examen_final', 1, 1),
(2, 1, '02', 'Psicología Educacional', 1, 2, 'promocion_o_examen_final', 1, 1),
(3, 1, '03', 'Alfabetización Académica', 1, 3, 'promocion_o_examen_final', 0, 1),
(4, 1, '04', 'Didáctica General', 1, 4, 'promocion_o_examen_final', 0, 1),
(5, 1, '11', 'Anatomía y Fisiología', 1, 5, 'promocion_o_examen_final', 0, 1),
(6, 1, '12', 'Prácticas Ludomotrices y su Enseñanza', 1, 6, 'promocion_o_examen_final', 0, 1),
(7, 1, '13', 'Prácticas Gimnásticas y su Enseñanza', 1, 7, 'promocion_o_examen_final', 0, 1),
(8, 1, '14', 'Prácticas Atléticas y su Enseñanza', 1, 8, 'promocion_o_examen_final', 0, 1),
(9, 1, '15', 'Prácticas de Recreación y Tiempo Libre y su Enseñanza', 1, 9, 'promocion_o_examen_final', 0, 1),
(10, 1, '32', 'Práctica I', 1, 10, 'promocion', 0, 1),
(11, 1, '05', 'Filosofía', 2, 1, 'promocion_o_examen_final', 1, 1),
(12, 1, '06', 'Historia de las Políticas Educativas en la Argentina', 2, 2, 'promocion_o_examen_final', 1, 1),
(13, 1, '16', 'Sujeto de la Educación', 2, 3, 'examen_final', 0, 1),
(14, 1, '17', 'Prácticas Acuáticas y su Enseñanza', 2, 4, 'promocion_o_examen_final', 0, 1),
(15, 1, '18', 'Prácticas Motrices Expresivas y su Enseñanza', 2, 5, 'promocion_o_examen_final', 0, 1),
(16, 1, '19', 'Prácticas Deportivas I y su Enseñanza: Vóley', 2, 6, 'promocion_o_examen_final', 0, 1),
(17, 1, '20', 'Prácticas Deportivas II y su Enseñanza', 2, 7, 'promocion_o_examen_final', 0, 1),
(18, 1, '21', 'Didáctica de la Educación Física', 2, 8, 'examen_final', 0, 1),
(19, 1, '22', 'Didáctica de las Prácticas Recreativas y el Tiempo Libre', 2, 9, 'promocion_o_examen_final', 0, 1),
(20, 1, '33', 'Práctica II', 2, 10, 'promocion', 0, 1),
(21, 1, '07', 'Educación Sexual Integral', 3, 1, 'promocion_o_examen_final', 0, 1),
(22, 1, '08', 'Integración de las TIC en la Enseñanza', 3, 2, 'promocion_o_examen_final', 0, 1),
(23, 1, '09', 'Sociología de la Educación', 3, 3, 'promocion_o_examen_final', 0, 1),
(24, 1, '23', 'Prácticas Deportivas III y su Enseñanza', 3, 4, 'promocion_o_examen_final', 0, 1),
(25, 1, '24', 'Prácticas Deportivas IV y su Enseñanza', 3, 5, 'promocion_o_examen_final', 0, 1),
(26, 1, '25', 'Práctica en la Naturaleza y al Aire Libre y su Enseñanza', 3, 6, 'promocion_o_examen_final', 0, 1),
(27, 1, '26', 'Entrenamiento para la Actividad Física', 3, 7, 'examen_final', 0, 1),
(28, 1, '27', 'Historia y Epistemología de la Educación Física', 3, 8, 'promocion_o_examen_final', 0, 1),
(29, 1, '34', 'Práctica III', 3, 9, 'promocion', 0, 1),
(30, 1, '10', 'Ética Profesional Docente', 4, 1, 'promocion_o_examen_final', 0, 1),
(31, 1, '28', 'Educación Física Inclusiva', 4, 2, 'promocion_o_examen_final', 0, 1),
(32, 1, '29', 'Proyectos de Recreación y Tiempo Libre y su Enseñanza', 4, 3, 'promocion_o_examen_final', 0, 1),
(33, 1, '30', 'Educación Física y Salud', 4, 4, 'promocion_o_examen_final', 0, 1),
(34, 1, '31', 'Gestión de Espacios y Organizaciones Deportivas', 4, 5, 'promocion_o_examen_final', 0, 1),
(35, 1, '36', 'Unidad Curricular de Definición Institucional', 4, 6, 'promocion', 0, 1),
(36, 1, '35', 'Residencia Pedagógica', 4, 7, 'promocion', 0, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos`
--

CREATE TABLE `permisos` (
  `id_permiso` int(10) UNSIGNED NOT NULL,
  `codigo` varchar(60) NOT NULL,
  `descripcion` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `permisos`
--

INSERT INTO `permisos` (`id_permiso`, `codigo`, `descripcion`) VALUES
(1, 'expedientes.ver', 'Ver expedientes y datos personales'),
(2, 'expedientes.editar', 'Crear, editar y certificar expedientes'),
(3, 'tramites.ver', 'Ver trámites y su estado'),
(4, 'tramites.editar', 'Iniciar, modificar y resolver trámites'),
(5, 'notas.ver', 'Ver notas y situación académica'),
(6, 'notas.editar', 'Cargar y modificar notas'),
(7, 'usuarios.ver', 'Ver usuarios'),
(8, 'usuarios.editar', 'Crear y modificar usuarios'),
(9, 'auditoria.ver', 'Ver el historial de cambios'),
(10, 'reportes.ver', 'Ver e imprimir/exportar expedientes'),
(11, 'backups.ejecutar', 'Generar copias de seguridad');

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

--
-- Volcado de datos para la tabla `planes`
--

INSERT INTO `planes` (`id_plan`, `id_carrera`, `nombre`, `anio_vigencia`, `resolucion`, `activo`) VALUES
(1, 1, 'Plan de Estudios 2020 — Profesorado de Educación Física con orientación en Tiempo Libre y Recreación', '2020', 'Resolución N° 2281-E-20', 1);

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

--
-- Volcado de datos para la tabla `rol_permiso`
--

INSERT INTO `rol_permiso` (`rol`, `id_permiso`, `puede_ver`, `puede_editar`) VALUES
('admin', 1, 1, 1),
('admin', 2, 1, 1),
('admin', 3, 1, 1),
('admin', 4, 1, 1),
('admin', 5, 1, 1),
('admin', 6, 1, 1),
('admin', 7, 1, 1),
('admin', 8, 1, 1),
('admin', 9, 1, 1),
('admin', 10, 1, 1),
('admin', 11, 1, 1),
('coordinadora', 1, 1, 0),
('coordinadora', 2, 1, 1),
('coordinadora', 3, 1, 0),
('coordinadora', 4, 1, 1),
('coordinadora', 5, 1, 0),
('coordinadora', 6, 1, 1),
('coordinadora', 9, 1, 0),
('coordinadora', 10, 1, 0),
('coordinadora', 11, 1, 0),
('preceptora', 1, 1, 0),
('preceptora', 2, 1, 1),
('preceptora', 3, 1, 0),
('preceptora', 4, 1, 1),
('preceptora', 5, 1, 0),
('preceptora', 6, 1, 1),
('preceptora', 9, 1, 0),
('preceptora', 10, 1, 0),
('preceptora', 11, 1, 0),
('vicerrectora', 1, 1, 0),
('vicerrectora', 2, 1, 0),
('vicerrectora', 3, 1, 0),
('vicerrectora', 4, 1, 0),
('vicerrectora', 5, 1, 0),
('vicerrectora', 6, 1, 0),
('vicerrectora', 7, 1, 0),
('vicerrectora', 9, 1, 0),
('vicerrectora', 10, 1, 0),
('vicerrectora', 11, 1, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `solicitud_clave`
--

CREATE TABLE `solicitud_clave` (
  `id_solicitud` int(11) NOT NULL,
  `id_usuario` int(10) UNSIGNED NOT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `atendida` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `solicitud_clave`
--

INSERT INTO `solicitud_clave` (`id_solicitud`, `id_usuario`, `fecha`, `atendida`) VALUES
(1, 4, '2026-11-14 18:15:25', 1);

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

--
-- Volcado de datos para la tabla `submaterias`
--

INSERT INTO `submaterias` (`id_submateria`, `id_materia`, `nombre`, `orden`) VALUES
(1, 17, 'Handbol', 1),
(2, 17, 'Básquet', 2),
(3, 24, 'Hockey', 1),
(4, 24, 'Rugby', 2),
(5, 24, 'Fútbol', 3),
(6, 25, 'Gimnasia', 1),
(7, 25, 'Atletismo', 2);

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

--
-- Volcado de datos para la tabla `tipos_documento`
--

INSERT INTO `tipos_documento` (`id_tipo`, `nombre`, `obligatorio`, `vence`, `dias_alerta`, `orden`, `activo`) VALUES
(1, 'DNI', 1, 0, 0, 1, 1),
(2, 'Título o constancia de título en trámite', 1, 0, 0, 2, 1),
(3, 'Apto físico', 1, 1, 30, 3, 1),
(4, 'Seguro SEMED', 1, 1, 30, 4, 1);

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

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `nombre`, `usuario`, `clave_hash`, `rol`, `id_carrera`, `activo`, `debe_cambiar_clave`) VALUES
(1, 'Administrador del Sistema', 'admin', '$2y$12$BP/S9HmM73ciw3tpibuqGebwKkH5zBLZ1mSIC/bJ.iJ.mck1jGb1G', 'admin', NULL, 1, 0),
(2, 'Vicerrectora', 'vicerrectora', '$2y$12$K/XmT/LPLeijnuTSE5EZue2PCP5vaSpeGS4NQ80SEgg6tQttk3EpO', 'vicerrectora', NULL, 1, 0),
(3, 'Coordinadora de Educación Física', 'coordinadora', '$2y$12$hrnzwW2mhB0lmgeFb.TfKOjUDdWVeTM/o.I3dRb9DhiUtPy8a4q22', 'coordinadora', NULL, 1, 0),
(4, 'Preceptora Turno Tarde', 'preceptora.tarde', '$2y$12$z8vUPlyaVoRuev4TdlKEWe/zVNg/iuOSVjwQWUnAMN.Q5SBIRijVS', 'preceptora', 1, 1, 0);

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
-- Indices de la tabla `solicitud_clave`
--
ALTER TABLE `solicitud_clave`
  ADD PRIMARY KEY (`id_solicitud`),
  ADD KEY `id_usuario` (`id_usuario`);

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
  MODIFY `id_auditoria` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=219;

--
-- AUTO_INCREMENT de la tabla `carreras`
--
ALTER TABLE `carreras`
  MODIFY `id_carrera` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `cursadas`
--
ALTER TABLE `cursadas`
  MODIFY `id_cursada` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT de la tabla `documentacion_estudiante`
--
ALTER TABLE `documentacion_estudiante`
  MODIFY `id_documento` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT de la tabla `estudiantes`
--
ALTER TABLE `estudiantes`
  MODIFY `id_estudiante` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `examenes_finales`
--
ALTER TABLE `examenes_finales`
  MODIFY `id_examen` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `inscripciones_curso`
--
ALTER TABLE `inscripciones_curso`
  MODIFY `id_inscripcion` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `materias`
--
ALTER TABLE `materias`
  MODIFY `id_materia` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT de la tabla `permisos`
--
ALTER TABLE `permisos`
  MODIFY `id_permiso` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `planes`
--
ALTER TABLE `planes`
  MODIFY `id_plan` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `solicitud_clave`
--
ALTER TABLE `solicitud_clave`
  MODIFY `id_solicitud` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `submaterias`
--
ALTER TABLE `submaterias`
  MODIFY `id_submateria` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `tipos_documento`
--
ALTER TABLE `tipos_documento`
  MODIFY `id_tipo` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `tramites`
--
ALTER TABLE `tramites`
  MODIFY `id_tramite` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

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
-- Filtros para la tabla `solicitud_clave`
--
ALTER TABLE `solicitud_clave`
  ADD CONSTRAINT `solicitud_clave_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE;

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
