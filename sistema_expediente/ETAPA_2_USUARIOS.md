# Etapa 2 — Administración de usuarios

Este módulo añade la pantalla `usuarios.php` al proyecto PHP recibido y trabaja con la base de datos configurada `ies4_expedientes_v2`.

## Funciones

- Listar y buscar usuarios existentes.
- Crear usuarios con rol, turno, carrera opcional, correo y teléfono.
- Editar los datos de una cuenta y restablecer su contraseña sin mostrar el hash actual.
- Activar o desactivar cuentas (no se borran usuarios).
- Evitar desactivar la propia cuenta desde la lista y evitar desactivar/quitar el rol del último administrador activo.
- Validar los roles permitidos por la columna `usuarios.rol` y los turnos del esquema.
- Registrar altas y cambios en `auditoria` sin almacenar contraseñas en el detalle de auditoría.
- Controlar el acceso con `usuarios.ver` y `usuarios.editar` de las tablas `permisos` y `rol_permiso`.
- Las cuentas creadas o con contraseña restablecida quedan marcadas `debe_cambiar_clave=1`; el backend las dirige al formulario de cambio obligatorio antes de usar los demás módulos.

## Importante

- No se incluye SQL de migración ni se modifica el archivo SQL del proyecto.
- La aplicación solo usa `DB_NAME` definido en `config/config.php`; debe seguir siendo `ies4_expedientes_v2`.
- El permiso de editar usuarios se evalúa como `rol_permiso.puede_editar` para el código `usuarios.editar`.
- Los valores válidos se restringen al `ENUM` de `usuarios.rol` y el formulario solo ofrece los roles que tienen asignaciones en `rol_permiso`; no se crea una tabla de roles nueva.
- Se debe probar en el XAMPP local con las cuentas reales. La validación de sintaxis PHP no sustituye una prueba de integración con MySQL.

## Prueba recomendada

1. Entrar como `admin` y abrir **Usuarios**.
2. Buscar los siete usuarios actuales y comprobar que no se muestra ninguna contraseña ni hash.
3. Crear un usuario de prueba con un nombre único, rol `consulta`, contraseña inicial de al menos 12 caracteres y cuenta activa.
4. Cerrar sesión e ingresar con esa cuenta: debe solicitar cambiar la contraseña antes de mostrar el sistema.
5. Volver como `admin`, desactivar la cuenta de prueba y verificar que ya no pueda iniciar sesión.
6. Verificar que `consulta` no pueda abrir `usuarios.php` si su rol no tiene `usuarios.ver`.

No hagas pruebas de alta/desactivación con cuentas reales importantes si no quieres cambiar datos de usuarios. Para una práctica segura, crea primero una cuenta de prueba y luego desactívala.
