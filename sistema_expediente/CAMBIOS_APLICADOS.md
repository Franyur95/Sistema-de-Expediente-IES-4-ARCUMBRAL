# Correcciones para `ies4_expedientes_v2`

Se adaptó el código PHP de las pantallas existentes a los nombres de tablas y columnas del esquema `ies4_expedientes_v2`. El archivo `database/ies4_expedientes_v2.sql` se conserva sin cambios.

## Adaptaciones realizadas

- Inicio de sesión y cambio de contraseña: usan `usuarios` y `clave_hash`.
- Inicio, búsqueda, consulta, alta y edición de estudiantes: usan `estudiantes` y `carreras`.
- Documentación: usa `tipos_documento` y `documentacion_estudiante`, incluyendo `anio_lectivo` para respetar la clave única del esquema.
- Planes y espacios curriculares: las materias se consultan a través de `materias` y `planes`.
- Inscripciones y cursadas: se guardan en `cursadas`, según la estructura v2, que combina esos datos en un registro único por estudiante, materia y año.
- Exámenes finales: usan `examenes_finales`, con las columnas y valores de enumeración definidos en v2.
- Auditoría: usa los valores permitidos por la columna `auditoria.accion`.
- La configuración de conexión queda en `config/config.php`; el valor inicial es `root` sin contraseña, habitual en XAMPP. Si MySQL tiene otra configuración, hay que ajustar únicamente esas constantes.

## Límites de verificación

Se verificó la sintaxis de todos los archivos PHP con `php -l` y se revisaron las consultas frente a los nombres de tablas del esquema. En este entorno no está disponible el controlador `pdo_mysql` ni una instancia de la base del usuario, por lo que no fue posible ejecutar pruebas de integración contra su servidor MySQL. La primera ejecución local debe confirmar credenciales, contraseñas de los usuarios existentes y compatibilidad de la versión MySQL/MariaDB.

La vista previa `login.php?demo=1` sigue siendo solo demostrativa y no escribe en MySQL. Para probar funciones reales, entre por `login.php` sin `demo=1`.

**No importar ni ejecutar ningún SQL adicional para aplicar estos cambios.**
