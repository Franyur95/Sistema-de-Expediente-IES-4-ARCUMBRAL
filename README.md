# S.I.E.A.: Sistema Integral de Expedientes Académicos

Sistema de expedientes de alumnos para el **I.E.S. N.º 4 «Raúl Scalabrini Ortiz»** (Palpalá).

**Alcance actual: Profesorado de Educación Física con orientación en Recreación y Tiempo Libre, turno tarde.**
El turno mañana no carga alumnos en este sistema: su carrera existe en la base pero queda inactiva (`activa = 0`) y solo sirve como origen o destino de pases. Se la activa recién si la institución lo pide.

Proyecto de Prácticas Profesionalizantes I · Tecnicatura Superior en Desarrollo de Software · I.E.S. N.º 11 · Grupo **Arcumbral Devs** · Ciclo lectivo 2026.

## Qué hace

- Expediente digital por alumno con **número de legajo** (identifica la carpeta física, ej. `Z152`), búsqueda por apellido, DNI o legajo y control de duplicados por DNI, legajo y apellido + nombre + fecha de nacimiento.
- Documentación obligatoria (DNI, título en trámite, apto físico, seguro SEMED) con vencimiento anual.
- **Semáforo** de documentación (rojo, amarillo, verde) y **alertas** de documentos vencidos, por vencer o faltantes.
- Situación académica: inscripciones, cursadas y exámenes finales (con libro y folio), verificación de correlatividades y límite de 3 intentos como Regular y 3 como Libre.
- Trámites: pases, asimilaciones, equivalencias y notas de aprobación, con plazo de 60 días.
- Reportes y listados imprimibles (se guardan como PDF desde el navegador).
- Usuarios, roles y permisos; contraseña temporal con cambio obligatorio en el primer ingreso y solicitud de «¿Olvidó su contraseña?».
- Registro de auditoría (historial de cambios por alumno) y copias de seguridad de la base.

## Tecnologías

PHP 8 (PDO) · MariaDB/MySQL · HTML5 y CSS3 · Apache (XAMPP) · Git y GitHub. Sin frameworks ni servicios externos: funciona en red local, sin internet.

## Roles

| Rol | Qué puede hacer |
| --- | --- |
| Administrador | Usuarios y permisos, auditoría, respaldos, trámites, reportes. No ve expedientes. |
| Coordinadora | Consulta expedientes y notas, reportes y trámites. No modifica expedientes. |
| Vicerrectora | Igual que la coordinadora. |
| Preceptora | Crea y modifica expedientes y notas, trámites, semáforo, alertas y reportes. Modifica solo alumnos de su carrera. |

Los permisos se leen de las tablas `permisos` y `rol_permiso`.

## Estructura del proyecto

```
sistema_expediente/
├── config/config.php        conexión y parámetros
├── includes/                auth, db, layout, estudiantes, academico, tramites, reportes, semaforo
├── css/  js/  img/
├── database/                dump de la base, parches SQL y respaldo_diario.bat
├── backups/                 copias de seguridad (no se suben a Git)
├── login.php  olvide_clave.php  cambiar_clave.php  logout.php  bienvenida.php  index.php
├── nuevo.php  editar.php  buscar.php  ver.php  academico.php
├── tramites.php  tramites_alumno.php
├── reportes.php  imprimir.php  imprimir_listado.php
├── semaforo.php  alertas.php
└── usuarios.php  auditoria.php  respaldos.php
```

## Base de datos

Base `ies4_expedientes_v2`: **18 tablas, 8 vistas y 9 disparadores**.

- Estructura académica: carreras, planes, materias, submaterias, correlatividades.
- Estudiante y trayectoria: estudiantes, inscripciones_curso, cursadas, examenes_finales.
- Documentación y trámites: tipos_documento, documentacion_estudiante, tramites, tramite_materias.
- Seguridad: usuarios, permisos, rol_permiso, auditoria, solicitud_clave.

Archivos de `database/`:

| Archivo | Para qué sirve |
| --- | --- |
| `ies4_expedientes_v2.sql` | Dump completo y limpio (estructura, catálogo y 4 usuarios de prueba; **sin alumnos**). Es lo único que hace falta para instalar. |
| `02_carrera_manana_y_tramites.sql` | Parche histórico: carrera de la mañana inactiva. Ya está incluido en el dump. |
| `03_legajo_y_alertas.sql` | Parche histórico: agrega `legajo`, el estado `fallecido` y la vista `v_alertas`. Ya está incluido en el dump; sirve para actualizar una base vieja. |
| `respaldo_diario.bat` | Copia de seguridad programable en Windows. |

## Instalación (XAMPP en Windows)

1. Copie la carpeta `sistema_expediente` a `C:\xampp\htdocs\`.
2. En el Panel de XAMPP, inicie **Apache** y **MySQL**.
3. En `http://localhost/phpmyadmin` cree la base `ies4_expedientes_v2` con cotejamiento `utf8mb4_general_ci`.
4. Seleccione la base, pestaña **Importar**, y cargue `database/ies4_expedientes_v2.sql`.
5. Revise `config/config.php`: `DB_NAME` = `ies4_expedientes_v2`, `DB_USER` = `root`, `DB_PASS` vacía (valores por defecto de XAMPP).
6. Abra `http://localhost/sistema_expediente/`.

Si ya tenía la base instalada de antes, en lugar de reimportar ejecute (pestaña SQL) `database/03_legajo_y_alertas.sql`. Haga un respaldo antes.

### Usuarios de prueba

Contraseña inicial de todos: `Cambiar2026!` (el sistema obliga a cambiarla en el primer ingreso).

| Usuario | Rol |
| --- | --- |
| admin | Administrador |
| vicerrectora | Vicerrectora |
| coordinadora | Coordinadora |
| preceptora.tarde | Preceptora (turno tarde) |

Antes de cargar datos reales, cree las cuentas verdaderas desde **Usuarios** y desactive las de prueba.

## Uso desde otras computadoras de la red

El sistema se instala en **una sola PC** (el servidor) y las demás entran por el navegador.

1. Deje al servidor con **IP fija** en la red del instituto.
2. En el firewall de Windows del servidor, permita el puerto 80 (Apache) para la red privada.
3. Desde las otras PCs abra `http://IP_DEL_SERVIDOR/sistema_expediente/`.
4. No exponga MySQL ni phpMyAdmin a la red: el sistema los usa solo desde el propio servidor.

## Copias de seguridad

Desde el panel del administrador, **Respaldos**, se genera una copia de la base con un botón. Para programarlas se usa `database/respaldo_diario.bat` con el comando `schtasks` que muestra esa pantalla. Las copias contienen datos personales: no se suben al repositorio (`backups/` está ignorado por Git) y conviene guardar una copia fuera del servidor.

## Estado del proyecto

Implementado: expedientes con legajo, documentación y vencimientos anuales, semáforo y alertas, situación académica con correlatividades y límite de intentos, trámites, roles y permisos, auditoría, respaldos.

Pendiente (ver `PENDIENTES.md`): listado SEMED, certificación de expedientes, límite de intentos de inicio de sesión, adjuntar documentos escaneados, ampliar la lista de documentación, entre otros.

## Trabajo en equipo

Rama de desarrollo: `desarrollo-noelia`. Antes de subir cambios: `git pull origin desarrollo-noelia`.

## Equipo

Avalos, Luciano · Cruz, Franco Omar · Paredes, Noelia Aylén · Rueda, Silvina Lucía · Yurquina, Francisco Nahuel Gonzalo

Docente: Mamani David