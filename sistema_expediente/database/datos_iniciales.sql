-- ============================================================
-- Datos iniciales del sistema_expediente
-- Ejecutar DESPUÉS de importar sistema_expediente.sql (estructura).
-- Se puede ejecutar más de una vez (INSERT IGNORE).
-- REVISE los valores marcados con "AJUSTAR" antes de usar datos reales.
-- ============================================================

SET NAMES utf8mb4;

-- Carrera (según el modelo de ficha: Prof. de Educación Física con Orientación
-- en Tiempo Libre y Recreación, Decreto-Resolución N.º 13929-E-19).
-- AJUSTAR: el turno no figura en la ficha; se asumió 'Mañana'.
INSERT IGNORE INTO carrera (id_carrera, nombre, turno, resolucion) VALUES
(1, 'Profesorado de Educación Física con Orientación en Tiempo Libre y Recreación', 'Mañana', '13929-E-19');

-- Segundo turno de la misma carrera (el informe indica que se centralizan ambos turnos).
-- AJUSTAR: si en la institución es una sola carrera con un solo registro, elimine esta fila.
INSERT IGNORE INTO carrera (id_carrera, nombre, turno, resolucion) VALUES
(2, 'Profesorado de Educación Física con Orientación en Tiempo Libre y Recreación', 'Tarde', '13929-E-19');

-- Documentación a controlar, según el informe de relevamiento.
INSERT IGNORE INTO tipo_documento (id_tipo, nombre, obligatorio, orden) VALUES
(1, 'DNI (fotocopia)', 1, 1),
(2, 'Título o constancia de título en trámite', 1, 2),
(3, 'Apto físico', 1, 3),
(4, 'Seguro SEMED', 1, 4);

-- Usuarios de PRUEBA. Contraseña inicial de todos: Cambiar2026!
-- IMPORTANTE: cambie las contraseñas desde "Mi contraseña" (o elimine estos usuarios)
-- antes de cargar datos reales.
--   admin         -> Administradora (todas las carreras, puede editar)
--   vicerrectora  -> Vicerrectora   (todas las carreras, solo consulta)
--   coordinadora  -> Coordinadora   (modifica solo carrera 1; consulta todo)
--   preceptora    -> Preceptora     (modifica solo carrera 1 - mañana; consulta todo)
--   preceptora_tarde -> Preceptora  (modifica solo carrera 2 - tarde; consulta todo)
INSERT IGNORE INTO usuario (id_usuario, nombre, usuario, clave, rol, activo, id_carrera) VALUES
(1, 'Administración',  'admin',        '$2y$10$MOQgTojaS1L.8hfRhdMLv.IYHEpkmh8/So7VBkVCK7So.HMDICm5y', 'Administradora', 1, NULL),
(2, 'Vicerrectoría',   'vicerrectora', '$2y$10$MOQgTojaS1L.8hfRhdMLv.IYHEpkmh8/So7VBkVCK7So.HMDICm5y', 'Vicerrectora',   1, NULL),
(3, 'Coordinación',    'coordinadora', '$2y$10$MOQgTojaS1L.8hfRhdMLv.IYHEpkmh8/So7VBkVCK7So.HMDICm5y', 'Coordinadora',   1, 1),
(4, 'Preceptoría',     'preceptora',   '$2y$10$MOQgTojaS1L.8hfRhdMLv.IYHEpkmh8/So7VBkVCK7So.HMDICm5y', 'Preceptora',     1, 1),
(5, 'Preceptoría Tarde', 'preceptora_tarde', '$2y$10$MOQgTojaS1L.8hfRhdMLv.IYHEpkmh8/So7VBkVCK7So.HMDICm5y', 'Preceptora', 1, 2);
