# Sistema de expedientes de alumnos — IES N.º 4

Aplicación PHP + MySQL preparada para utilizar la base existente `ies4_expedientes_v2`.

## 1. Instalación local

1. Haga una copia de seguridad de la carpeta actual del proyecto.
2. Copie la carpeta `sistema_expediente` dentro de `C:\xampp\htdocs\`.
3. Abra XAMPP e inicie Apache y MySQL.
4. En `config/config.php`, compruebe `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER` y `DB_PASS`. El nombre configurado es `ies4_expedientes_v2`; el valor inicial `root` sin contraseña corresponde a una instalación habitual de XAMPP.
5. Abra `http://localhost/sistema_expediente/login.php` si la carpeta `sistema_expediente` está directamente dentro de `htdocs`. Si conservó la carpeta contenedora del repositorio, use la ruta equivalente que incluya esa carpeta.

**No importe nuevamente `ies4_expedientes_v2.sql` ni ejecute scripts SQL adicionales para instalar estas correcciones.** Las correcciones están en PHP y el esquema SQL se mantiene intacto.

## 2. Pantallas disponibles

- Inicio y resumen de expedientes.
- Buscar estudiantes por apellido o DNI.
- Ver expediente, carrera, documentación y situación académica.
- Registrar un expediente.
- Modificar los datos y la documentación de un expediente.
- Cargar inscripciones, cursadas y exámenes finales.
- Cambiar contraseña.
- Cerrar sesión.

Los permisos de edición dependen del rol y de la carrera asignada al usuario.

## 3. Acceso y contraseñas

Se deben usar las cuentas y contraseñas que ya estén guardadas en la tabla `usuarios` de `ies4_expedientes_v2`. El código no cambia las contraseñas de esa tabla automáticamente ni crea usuarios nuevos. Si no recuerda una contraseña, no cambie el SQL: primero verifique la cuenta existente y gestione su recuperación de forma controlada.

## 4. Problemas frecuentes

- **No se pudo conectar con la base de datos:** confirme que MySQL esté iniciado, que exista `ies4_expedientes_v2` y que las credenciales de `config/config.php` correspondan a su instalación.
- **Usuario o contraseña incorrectos:** el usuario debe existir en `usuarios`, estar activo y la contraseña debe coincidir con `clave_hash`.
- **No hay materias en situación académica:** revise que la base ya tenga filas activas en `planes` y `materias` para la carrera del estudiante. No importe `materias_ed_fisica.sql` sin revisar su compatibilidad con el esquema v2.
- **Error al guardar:** revise el registro de errores de PHP/Apache. No ejecute cambios manuales en la base para resolver un error de código.

## 5. Vista previa

En un entorno local se puede abrir `login.php?demo=1` para recorrer pantallas con datos ficticios. Esa modalidad no lee ni guarda información en MySQL. Para probar el sistema real, salga de la vista previa y use `login.php` sin el parámetro `demo=1`.
