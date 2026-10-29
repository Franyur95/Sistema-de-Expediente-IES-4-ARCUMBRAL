-- ============================================================
-- Espacios curriculares del Profesorado de Educación Física con Orientación
-- en Tiempo Libre y Recreación, tomados de la ficha "Modelo de situación académica".
-- Ejecutar con la base sistema_expediente seleccionada y DESPUÉS de datos_iniciales.sql
-- (necesita que exista la carrera 1). Se puede ejecutar más de una vez.
-- Se corrigieron errores de tipeo del modelo (ESPACIS, EDUACION, ENSEÑANAZA).
-- ============================================================

SET NAMES utf8mb4;

INSERT IGNORE INTO materia (id_carrera, anio, orden, nombre) VALUES
-- PRIMER AÑO
(1, 1, 1,  'Pedagogía'),
(1, 1, 2,  'Psicología Educacional'),
(1, 1, 3,  'Alfabetización Académica'),
(1, 1, 4,  'Didáctica General'),
(1, 1, 5,  'Anatomía y Fisiología'),
(1, 1, 6,  'Prácticas Ludomotrices y su Enseñanza'),
(1, 1, 7,  'Prácticas Gimnásticas y su Enseñanza'),
(1, 1, 8,  'Prácticas Atléticas y su Enseñanza'),
(1, 1, 9,  'Prácticas de Recreación y Tiempo Libre y su Enseñanza'),
(1, 1, 10, 'Práctica I'),
(1, 1, 11, 'Práctica I: Taller Integrador'),
-- SEGUNDO AÑO
(1, 2, 1,  'Filosofía'),
(1, 2, 2,  'Hist. Políticas Ed. en la Arg.'),
(1, 2, 3,  'Sujeto de la Educación'),
(1, 2, 4,  'Práct. Acuáticas y su Enseñanza'),
(1, 2, 5,  'Práct. Motrices Expresivas y su Ens.'),
(1, 2, 6,  'Práct. Deport. 1 y su Enseñanza: Vóley'),
(1, 2, 7,  'Práct. Deport. 2 y su Enseñanza: Básquet'),
(1, 2, 8,  'Práct. Deport. 2 y su Enseñanza: Handbol'),
(1, 2, 9,  'Didáctica de la Educación Física'),
(1, 2, 10, 'Didáctica de las Prácticas Recreativas y el Tiempo Libre'),
(1, 2, 11, 'Práctica II'),
(1, 2, 12, 'Práctica II: Taller Integrador'),
-- TERCER AÑO
(1, 3, 1,  'Educación Sexual Integral'),
(1, 3, 2,  'Integración de las TICs en la Enseñanza'),
(1, 3, 3,  'Sociología de la Educación'),
(1, 3, 4,  'Práct. Deport. 3 y su Enseñanza: Hockey'),
(1, 3, 5,  'Práct. Deport. 3 y su Enseñanza: Rugby'),
(1, 3, 6,  'Práct. Deport. 3 y su Enseñanza: Fútbol'),
(1, 3, 7,  'Práct. Deport. 4 y su Enseñanza: Gimnasia'),
(1, 3, 8,  'Práct. Deport. 4 y su Enseñanza: Atletismo'),
(1, 3, 9,  'Prácticas en la Naturaleza y al Aire Libre, y su Enseñanza'),
(1, 3, 10, 'Entrenamiento para la Actividad Física'),
(1, 3, 11, 'Historia y Epistemología de la Educación Física'),
(1, 3, 12, 'Práctica III'),
(1, 3, 13, 'Práctica III: Taller Integrador'),
-- CUARTO AÑO
(1, 4, 1,  'Ética Profesional Docente'),
(1, 4, 2,  'Educación Física Inclusiva'),
(1, 4, 3,  'Educación Física y Salud'),
(1, 4, 4,  'Gestión de Espacios y Organizaciones Deportivas'),
(1, 4, 5,  'Unidad de Definición Institucional'),
(1, 4, 6,  'Residencia Pedagógica'),
(1, 4, 7,  'Proyecto de Recreación y Tiempo Libre');

-- Copia del plan para la carrera 2 (turno Tarde), solo si esa carrera existe.
INSERT IGNORE INTO materia (id_carrera, anio, orden, nombre)
SELECT 2, anio, orden, nombre FROM materia
WHERE id_carrera = 1 AND EXISTS (SELECT 1 FROM carrera WHERE id_carrera = 2);
