# S.I.E.A.: Sistema Integral de Expedientes Académicos

Sistema de expedientes de alumnos para el **I.E.S. N.º 4 «Raúl Scalabrini Ortiz»** (Palpalá).

**Alcance actual: Profesorado de Educación Física con orientación en Recreación y Tiempo Libre, turno tarde (Res. 2281-E-20).**
La carrera del turno mañana existe en la base pero queda **inactiva** (`activa = 0`) y así permanecerá: no se cargan alumnos de ese turno.

Proyecto de Prácticas Profesionalizantes I · Tecnicatura Superior en Desarrollo de Software · I.E.S. N.º 11 · Grupo **Arcumbral Devs** · Ciclo lectivo 2026.

## Qué hace

**Expedientes**
- Expediente digital por alumno con número de legajo, búsqueda por apellido, DNI o legajo y control de duplicados (DNI, legajo, y apellido + nombre + fecha de nacimiento).
- Certificación del expediente por la Vicerrectora (queda registrado quién y cuándo).

**Documentación**
- Documentación obligatoria: DNI, título en trámite, apto físico y seguro SEMED (los dos últimos vencen cada año).
- Semáforo (rojo, amarillo, verde) y alertas de documentos vencidos, por vencer o faltantes.
- Carga del listado del SEMED: se pegan los DNI y el sistema marca el seguro y muestra quién sigue sin seguro.
- No permite inscribir a materias si falta la documentación anual.

**Situación académica**
- Inscripciones al curso, cursadas y exámenes finales (con libro y folio).
- Verificación de correlatividades según la Res. 2281-E-20, al inscribir a cursar y al rendir.
- Regularidad de 2 años, 3 intentos como Regular y 3 como Libre; libre solo en las materias permitidas.
- Evita el doble cursado: no deja inscribir a una materia que el alumno ya aprobó (promoción, final, equivalencia o asimilación).

**Trámites**
- Pases, asimilaciones, equivalencias y notas de aprobación, con plazo de 60 días, alertas y resolución (número y fecha).

**Seguridad y gestión**
- Usuarios y roles; contraseña temporal con cambio obligatorio y solicitud de «¿Olvidó su contraseña?».
- Bloqueo de 15 minutos tras 5 intentos fallidos de ingreso.
- Registro de auditoría (quién cambió qué y cuándo).
- Reportes e impresión (se guardan como PDF desde el navegador) y copias de seguridad.

## Tecnologías

PHP 8 (PDO) · MariaDB/MySQL (administrada con MySQL Workbench) · HTML5 y CSS3 · Apache (XAMPP) · Git y GitHub. Sin frameworks ni servicios externos: funciona en red local, sin internet.

## Roles

| Rol | Qué puede hacer |
| --- | --- |
| Administrador | Usuarios y permisos, auditoría, respaldos, trámites. No ve expedientes. |
| Vicerrectora | Consulta expedientes, notas, reportes, semáforo y alertas. Certifica expedientes. Edita trámites. |
| Coordinadora | Consulta expedientes, notas, reportes, semáforo y alertas. Edita trámites. No modifica expedientes. |
| Preceptora | Crea y modifica expedientes y notas, trámites, listado SEMED, semáforo, alertas y reportes. Modifica solo alumnos de su carrera. |

Los permisos se leen de las tablas `permisos` y `rol_permiso`.

## Estructura del proyecto

```
sistema_expediente/
├── config/config.php        conexión y parámetros
├── includes/                auth, db, layout, estudiantes, academico, doble_cursado,
│                            tramites, reportes, semaforo, semed, login_guard
├── css/  js/  img/
├── database/                dump de la base, parches SQL y respaldo_diario.bat
├── backups/                 copias de seguridad (no se suben a Git)
├── login.php  olvide_clave.php  cambiar_clave.php  logout.php  bienvenida.php  index.php
├── nuevo.php  editar.php  buscar.php  ver.php  academico.php  certificar.php
├── seguro_semed.php
├── tramites.php  tramites_alumno.php
├── reportes.php  imprimir.php  imprimir_listado.php
├── semaforo.php  alertas.php
└── usuarios.php  auditoria.php  respaldos.php
```

## Base de datos

Base `ies4_expedientes_v2`: 20 tablas, 9 vistas y 9 disparadores (con los parches 04 y 05 aplicados).

Archivos de `database/`:

| Archivo | Para qué sirve |
| --- | --- |
| `ies4_expedientes_v2.sql` | Base completa: estructura, catálogo (carreras, plan, materias, correlatividades, permisos) y 4 usuarios de prueba. |
| `04_certificacion_semed_login.sql` | Permiso de certificar, semáforo y alertas para Coordinadora y Vicerrectora, y tabla `intentos_login`. |
| `05_permisos_y_mesas.sql` | La Vicerrectora edita trámites y tabla `inscripciones_mesa` (todavía sin pantalla). |
| `respaldo_diario.bat` | Copia de seguridad programable en Windows. |

Si el dump del repositorio ya incluye los parches, no hace falta ejecutarlos de nuevo; si no, ejecutarlos en orden (04 y luego 05). Son seguros de repetir.

## Instalación (XAMPP + MySQL Workbench)

1. Copie la carpeta `sistema_expediente` a `C:\xampp\htdocs\`.
2. En el Panel de XAMPP, inicie **Apache** y **MySQL**.
3. Importe la base (ver «Cómo importar la base de datos» más abajo).
4. Revise `config/config.php`: `DB_NAME` = `ies4_expedientes_v2`, `DB_USER` = `root`, `DB_PASS` vacía (valores por defecto de XAMPP).
5. Abra `http://localhost/sistema_expediente/`.

### Usuarios de prueba

Contraseña inicial de todos: `Cambiar2026!` (el sistema obliga a cambiarla en el primer ingreso).

| Usuario | Rol |
| --- | --- |
| admin | Administrador |
| vicerrectora | Vicerrectora |
| coordinadora | Coordinadora |
| preceptora.tarde | Preceptora (turno tarde) |

Antes de cargar datos reales, cree las cuentas verdaderas desde **Usuarios** y desactive las de prueba.

Si una cuenta quedó bloqueada por intentos fallidos, en Workbench: `DELETE FROM intentos_login;`

## Cómo importar la base de datos (para el equipo)

**Quien tiene la base completa (exportar):**
1. En MySQL Workbench: menú **Server → Data Export**.
2. Marque el esquema `ies4_expedientes_v2` y todas sus tablas.
3. Elija **Dump Structure and Data** (con datos) o **Dump Structure Only** (sin datos).
4. Marque **Export to Self-Contained File**, elija dónde guardarlo (por ejemplo `ies4_expedientes_v2_equipo.sql`) y marque **Include Create Schema**.
5. Verifique que estén tildadas las opciones de procedimientos/funciones y **disparadores** (triggers).
6. Presione **Start Export**.

**Cada compañero (importar):**
1. Inicie MySQL en XAMPP y conéctese desde Workbench con `root`.
2. Menú **Server → Data Import**.
3. Elija **Import from Self-Contained File** y seleccione el archivo `.sql`.
4. En **Default Target Schema** deje `ies4_expedientes_v2` (si no existe, el archivo lo crea).
5. Presione **Start Import**. Al terminar, actualice la lista de esquemas y verifique que estén las 20 tablas.
6. Otra forma: **File → Open SQL Script**, abrir el archivo y ejecutarlo completo con el rayo.

Notas:
- Si importan sobre una base existente, el archivo reemplaza las tablas (`DROP TABLE IF EXISTS`): se pierden los datos que tuvieran.
- Todos deben usar el mismo motor (el de XAMPP, MariaDB). El dump trae `DEFINER=root@localhost`: si el usuario no es `root`, dará error en las vistas y disparadores.
- Los datos de alumnos son personales y sensibles: no suban a GitHub volcados con datos reales.
- El repositorio guarda solo la estructura y el catálogo (`ies4_expedientes_v2.sql`); los respaldos con datos van en `backups/`, que Git ignora.

## Cómo eliminar un alumno

El sistema **no tiene botón para eliminar** alumnos, a propósito: un expediente tiene historial y auditoría. Lo normal es cambiar su **estado** (editar expediente): Abandono, Con pase, Egresado, Libre o Fallecido.

Si se cargó por error (por ejemplo, duplicado) y **no tiene notas, exámenes ni trámites**, se puede borrar desde Workbench:

```sql
USE ies4_expedientes_v2;
SET @id_usuario = 1;                     -- id de quien borra (queda en auditoría)
SET @motivo_baja = 'Carga duplicada';    -- motivo (queda en auditoría)

SELECT id_estudiante, dni, apellido, nombre FROM estudiantes WHERE dni = '12345678';  -- verificar

DELETE FROM estudiantes WHERE id_estudiante = 123;   -- usar el id verificado arriba
```

- Si el alumno tiene cursadas, exámenes o trámites, la base **rechaza** el borrado con el mensaje «El alumno tiene historial académico: no se elimina».
- Se borran también su documentación e inscripciones al curso; queda un registro en la auditoría.
- Hacer un respaldo antes de borrar.

## Copias de seguridad

Desde el panel del administrador, **Respaldos**, se genera una copia de la base con un botón. Para programarlas se usa `database/respaldo_diario.bat` con el comando `schtasks` que muestra esa pantalla. Las copias contienen datos personales: no se suben al repositorio y conviene guardar una copia fuera del servidor. Para **restaurar** una copia, importar el archivo `.sql` desde Workbench (Server → Data Import).

## Uso desde otras computadoras de la red

El sistema se instala en **una sola PC** (el servidor) y las demás entran por el navegador.

1. Deje al servidor con **IP fija** en la red del instituto.
2. En el firewall de Windows del servidor, permita el puerto 80 (Apache) para la red privada.
3. Desde las otras PCs abra `http://IP_DEL_SERVIDOR/sistema_expediente/`.
4. No exponga MySQL ni phpMyAdmin a la red.

## Pendiente / mejoras futuras

- Adjuntar documentos escaneados (previsto en el Informe N.º 1).
- Pantalla para inscripción y baja a mesas de examen (la tabla ya existe; el plazo de 72 horas está por confirmar con la institución).
- Ampliar la lista de documentación (carnet sanitario, planilla prontuarial).
- Pantalla de restauración de copias de seguridad.
- Consulta de otras carreras y turnos (hoy solo la carrera de la tarde está activa).
- Mejoras futuras acordadas: asistencia y deserción, firma digital, acceso de estudiantes.

## Trabajo en equipo

Antes de subir cambios: `git pull`, revisar los cambios en VS Code, confirmar (commit) y sincronizar (push). No subir archivos de `backups/`.

## Equipo

Avalos, Luciano · Cruz, Franco Omar · Paredes, Noelia Aylén · Rueda, Silvina Lucía · Yurquina, Francisco Nahuel Gonzalo

Docente: Mamani David