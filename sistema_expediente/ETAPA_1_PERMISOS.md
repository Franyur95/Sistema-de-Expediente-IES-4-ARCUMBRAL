# Etapa 1 — permisos y seguridad

Esta entrega conecta las pantallas existentes con `permisos` y `rol_permiso` de `ies4_expedientes_v2`. No contiene instrucciones SQL ni modifica tablas.

## Cambios
- Se centraliza la consulta de permisos en `tiene_permiso()` y se agrega `exigir_permiso()` para bloquear accesos directos no autorizados (HTTP 403).
- El menú y el inicio muestran opciones de expedientes según `expedientes.ver` y `expedientes.editar`.
- `buscar.php` y `ver.php` requieren `expedientes.ver`; `nuevo.php` y `editar.php` exigen `expedientes.editar` para escribir.
- `ver.php` muestra la información académica solo a roles con `notas.ver`.
- `academico.php` permite lectura con `notas.ver`; las operaciones POST requieren `notas.editar`. Roles sin permiso de edición reciben una vista de solo lectura.
- Se quitó el modo de demostración y el botón de acceso ficticio del login.
- La comprobación de permisos se cachea solo dentro de la petición actual, no en la sesión.

## Alcance y pruebas pendientes
- Validar en XAMPP contra la base local real cada uno de los siete usuarios y probar accesos permitidos/denegados.
- La tabla `rol_permiso` del SQL incluye el rol `preceptora`, mientras que el código usa el valor guardado en `usuarios.rol`; verificar que los dos usuarios de preceptoría tengan ese rol exacto (en el volcado v2 lo tienen).
- No se agregaron páginas para módulos que aún no existen (trámites, resoluciones, usuarios, mesas, auditoría y reportes).
- Los archivos SQL se conservan sin cambios.
