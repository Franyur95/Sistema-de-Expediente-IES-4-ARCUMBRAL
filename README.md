# S.I.E.A.: Sistema Integral de Expedientes Académicos

Sistema de expedientes de alumnos para el **I.E.S. N.º 4 «Raúl Scalabrini Ortiz»**, sede Palpalá (Profesorado de Educación Física y Profesorado de Educación Física con Orientación en Recreación y Tiempo Libre).

Proyecto de Prácticas Profesionalizantes I · Tecnicatura Superior en Desarrollo de Software · I.E.S. N.º 11 · Grupo **Arcumbral Devs** · Ciclo lectivo 2026.

## Qué hace

- Expediente digital por alumno, con búsqueda por apellido o DNI y control de duplicados por DNI.
- Documentación obligatoria (DNI, título en trámite, apto físico, seguro SEMED), con vencimiento anual.
- **Semáforo** de documentación (rojo, amarillo, verde) y **alertas** de documentos vencidos, por vencer o faltantes.
- Situación académica: inscripciones, cursadas y exámenes finales (con libro y folio), y verificación de correlatividades.
- Reportes y listados imprimibles.
- Usuarios, roles y permisos, con contraseña temporal y solicitud de «¿Olvidó su contraseña?».
- Registro de auditoría de operaciones y copias de seguridad de la base.

## Tecnologías

PHP 8 (PDO) · MySQL/MariaDB · HTML5 y CSS3, sin JavaScript de terceros ni frameworks · Apache (XAMPP) · Git y GitHub.

## Roles y menú

| Rol | Opciones | Modifica expedientes |
| --- | --- | --- |
| Administrador | Usuarios y permisos, Registro de auditoría, Respaldos, Mi contraseña | No |
| Coordinadora | Buscar alumnos, Reportes | No (solo consulta) |
| Vicerrectora | Buscar alumnos, Reportes | No (solo consulta) |
| Preceptora | Nuevo expediente, Buscar alumnos, Reportes, Semáforo, Alertas | Sí, solo en su carrera |

Todos los roles de consulta ven ambos turnos. Los permisos se leen de las tablas `permisos` y `rol_permiso`.

## Estructura del proyecto

```
sistema_expediente/
├── config/config.php        conexión y parámetros
├── includes/                auth, db, layout, estudiantes, academico, reportes, semaforo
├── css/  js/  img/
├── database/                scripts SQL y respaldo_diario.bat
├── backups/                 copias de seguridad (no se suben a Git)
├── login.php  olvide_clave.php  cambiar_clave.php  logout.php  index.php
├── nuevo.php  editar.php  buscar.php  ver.php  academico.php
├── reportes.php  imprimir.php  imprimir_listado.php
├── semaforo.php  alertas.php
└── usuarios.php  auditoria.php  respaldos.php
```

## Base de datos

Base `ies4_expedientes_v2`: **17 tablas, 8 vistas y 9 disparadores**.

- Estructura académica: carreras, planes, materias, submaterias, correlatividades.
- Estudiante y trayectoria: estudiantes, inscripciones_curso, cursadas, examenes_finales.
- Documentación y trámites: tipos_documento, documentacion_estudiante, tramites, tramite_materias.
- Seguridad: usuarios, permisos, rol_permiso, auditoria, solicitud_clave.

La vista `v_alertas` quedó pendiente de corregir (error de cotejamiento); el sistema no la usa, las alertas se arman con `v_documentacion_estado` y `v_tramites_pendientes`.

## Instalación (XAMPP en Windows)

1. Copie la carpeta `sistema_expediente` a `C:\xampp\htdocs\`.
2. En el Panel de XAMPP, inicie **Apache** y **MySQL**.
3. En `http://localhost/phpmyadmin` cree la base `ies4_expedientes_v2` con cotejamiento `utf8mb4_general_ci`.
4. Seleccione la base e importe, **en este orden**, los archivos de `database/` (pestaña Importar):
   1. `ies4_expedientes_v2_estructura.sql` (tablas, vistas y disparadores)
5. Revise `config/config.php`: `DB_NAME` debe ser `ies4_expedientes_v2`, `DB_USER` `root` y `DB_PASS` vacía (valores por defecto de XAMPP).
6. Abra `http://localhost/sistema_expediente/`.

### Usuarios de prueba

Contraseña de todos: `Cambiar2026!`

| Usuario | Rol |
| --- | --- |
| admin | Administrador |
| vicerrectora | Vicerrectora |
| coordinadora | Coordinadora |
| preceptora | Preceptora (turno mañana) |
| preceptora_tarde | Preceptora (turno tarde) |

Cámbielas o elimine estos usuarios antes de cargar datos reales.

## Copias de seguridad

Desde el panel del administrador, **Respaldos**, se genera una copia de la base con un botón. Para programarlas, `database/respaldo_diario.bat` junto con el comando de Windows `schtasks` que muestra esa pantalla. Las copias contienen datos personales: no se suben al repositorio.

## Estado del proyecto

Implementado: expedientes, documentación y vencimientos anuales, semáforo y alertas, situación académica con correlatividades, roles y permisos, auditoría, respaldos.

Pendiente (próximas etapas):

- Pantallas de trámites (pases, asimilaciones y equivalencias); la base ya valida sus reglas y el plazo de 60 días.
- Certificación de documentación y carga del listado SEMED por la vicerrectora.
- Corrección de la vista `v_alertas`.
- Límite de 3 intentos de examen como regular y 3 como libre.
- Límite de intentos de inicio de sesión.

## Trabajo en equipo

Rama de la base de datos y el sistema: `desarrollo-noelia`. Antes de subir cambios: `git pull origin desarrollo-noelia`.

## Equipo

Avalos, Luciano · Cruz, Franco Omar · Paredes, Noelia Aylén · Rueda, Silvina Lucía · Yurquina, Francisco Nahuel Gonzalo

Docente: Mamani David
