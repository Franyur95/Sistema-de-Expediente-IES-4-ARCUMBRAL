# S.I.E.A. — Sistema de Expedientes de Alumnos · IES N.º 4 "Raúl Scalabrini Ortiz"

Sistema web **local** (una PC con XAMPP) para gestionar los expedientes académicos del **Profesorado de Educación Física** de la sede Palpalá. Proyecto de Prácticas Profesionalizantes I — Tecnicatura Superior en Desarrollo de Software.

**Problema que resuelve** (relevamiento con Vicerrectoría y preceptorías): los expedientes están en carpetas, libros de actas y planillas de Excel; no hay una fuente única de la situación académica, se pierde documentación, las preceptoras tienen información distinta y no se sabe quién modificó un dato.

## Qué hace hoy

- Ficha del estudiante con búsqueda por apellido o DNI, y control de documentación obligatoria.
- Situación académica: inscripciones, cursadas, exámenes finales con libro y folio; materias con deportes (Prácticas Deportivas II, III y IV) con nota por deporte.
- Verificación automática de correlativas (cursar y rendir/promocionar) según las resoluciones 2281-E-20 (tarde) y 2286-E-20 (mañana).
- Usuarios con roles y permisos; consulta libre y modificación restringida a la carrera de cada usuario.
- Auditoría de cambios, con historial por alumno dentro del expediente.

## Lo que garantiza la base de datos

La base aplica las reglas del instituto aunque la interfaz no las muestre todavía:

- Una materia promocionada cuenta como aprobada; una materia con deportes se aprueba solo con todos los deportes.
- Las materias solo promocionales (Práctica I, II, III, Residencia, UDI) no admiten examen final; las que son solo examen final no admiten promoción.
- Trámites: plazo de 60 días para asimilaciones y equivalencias, resolución con número y fecha, pase con carrera de origen y destino, equivalencia con materias reconocidas.
- Alertas y semáforo de documentación, trámites con plazo y regularidad (vistas `v_alertas` y `v_semaforo_documentacion`).
- Un alumno con historial académico no se elimina: se da de baja (estado Abandono). Toda eliminación queda en auditoría.

Lo que falta mostrar en la interfaz está en `docs/Pendientes_de_interfaz_PHP.pdf`.

---

## 1. Requisitos

XAMPP con Apache y MySQL/MariaDB (MariaDB 10.2.3 o superior, o MySQL 5.7.2 o superior). PHP 8.x. No necesita internet.

## 2. Instalación paso a paso (Windows + XAMPP)

1. Copie la carpeta **`sistema_expediente`** dentro de `C:\xampp\htdocs\`.
2. Abra el Panel de XAMPP y presione **Start** en **Apache** y **MySQL**.
3. Entre a `http://localhost/phpmyadmin` → **Bases de datos** → nombre `ies4_expedientes_v2`, cotejamiento `utf8mb4_general_ci` → **Crear**.
4. Haga clic en esa base → **Importar** → `sistema_expediente/database/ies4_expedientes_v2.sql` → **Importar**.
5. Importe los **parches** de `sistema_expediente/database/parches/`, uno por uno y **en este orden**:
   `01`, `02`, `03`, `04`, `05`, `07`, `08`, `09`.
   (Si en el futuro el dump se exporta con los parches ya aplicados, este paso se omite.)
6. Revise `sistema_expediente/config/config.php`: `DB_NAME = ies4_expedientes_v2`, `DB_USER = root`, `DB_PASS` vacío.
7. Abra **http://localhost/sistema_expediente/login.php**.

| Parche | Qué hace |
|---|---|
| 01 | Una materia promocionada cuenta como aprobada |
| 02 | Nombres como en la resolución y control de deportes (submaterias) |
| 03 | Trámites: plazos, resoluciones y pases |
| 04 | Alertas y semáforo de documentación |
| 05 | Equivalencia o asimilación resuelta con materias reconocidas |
| 06 | Carga la carrera de la **mañana**, **oculta** (opcional) |
| 06b | **Activa** la carrera de la mañana y crea la usuaria `preceptora.manana` (opcional) |
| 07 | Régimen de acreditación (solo promoción / solo examen final) |
| 08 | Baja y eliminación de alumnos |
| 09 | Vista que explica qué correlativa falta |

El parche 03 se ejecuta **una sola vez** (modifica una tabla). Los demás se pueden repetir.

## 3. Carrera de la mañana (opcional)

La base de tarde queda lista sin hacer nada más. Cuando pidan la carrera de la mañana:

1. Importar `06_carrera_manana.sql`: la carga completa (34 materias, deportes y 188 correlativas de la resolución 2286-E-20), pero **oculta**: la interfaz solo lista carreras activas.
2. Para mostrarla, importar `06b_activar_carrera_manana.sql`. Hace visible la carrera y crea la usuaria `preceptora.manana`.

Cada carrera tiene su propio plan: las materias de la tarde y de la mañana **no se mezclan**. Para volver a ocultarla: `UPDATE carreras SET activa = 0 WHERE id_carrera = 2;`

## 4. Usuarios y accesos

Contraseña inicial de **todos**: `Cambiar2026!`

| Usuario | Rol | Qué puede hacer |
|---|---|---|
| `admin` | Administrador | Todo, incluida la pantalla **Usuarios** |
| `vicerrectora` | Vicerrectora | Consultar expedientes y notas, ver la lista de usuarios |
| `coordinadora` | Coordinadora | Solo consulta |
| `preceptora.tarde` | Preceptora (carrera de la tarde) | Crear y modificar expedientes de su carrera, cargar notas |
| `preceptora.manana` | Preceptora (carrera de la mañana) | Solo existe tras ejecutar el parche 06b. Pide cambiar la clave al ingresar |

> Cambie las contraseñas desde **Mi contraseña** antes de usar datos reales.

## 5. Prueba guiada de carga de datos

Use datos **ficticios**. Entre como `preceptora.tarde`.

1. **Nuevo expediente:** apellido y nombre, DNI `40123456` (solo números), fecha de nacimiento, título y establecimiento de ingreso, año de ingreso, carrera, estado Activo, inscripción de 1.º año y los 4 documentos presentados.
2. **Buscar alumnos:** escriba el apellido o el DNI.
3. **Cargar situación académica:** inscribir a Pedagogía, completar la cursada (asistencia, T.P., carácter y promedio) y cargar el examen final (fecha, nota, libro y folio).

**Reglas que conviene comprobar**

| Prueba | Resultado esperado |
|---|---|
| Mismo DNI en otro alumno | Rechazado |
| Inscribir con documentación obligatoria pendiente | Rechazado, indica qué falta |
| Inscribir sin las correlativas | Rechazado, indica cuáles |
| Examen final en Práctica II | Bloqueado (solo promoción) |
| Prácticas Deportivas II sin elegir deporte | Bloqueado |
| Eliminar un alumno que tiene cursadas | Bloqueado: se da de baja (estado Abandono) |
| `coordinadora` o `vicerrectora` | Ven el expediente; no pueden modificar |

Cuando la base bloquea una regla, la pantalla hoy muestra «Ocurrió un error al guardar»; el mensaje claro está definido en la base (ver el PDF de pendientes).

## 6. Problemas frecuentes

| Síntoma | Solución |
|---|---|
| «No se pudo conectar con la base de datos» | Inicie MySQL en XAMPP y revise `config/config.php`. |
| «Usuario o contraseña incorrectos» | Use `Cambiar2026!` y confirme que la base se importó completa. |
| Error al importar un parche con `DELIMITER` | Use la pestaña **Importar** (no la pestaña SQL), o escriba `$$` en el cuadro **Delimitador**. |
| Aviso `#1360 El disparador no existe` | Es normal al ejecutar por primera vez un parche con triggers. |
| `Duplicate column` al repetir el parche 03 | Es normal: ese parche se ejecuta una sola vez. |
| Error 1175 (modo seguro de Workbench) | Los parches ya están preparados para ese modo; revise que use la versión de la carpeta `parches`. |
| 403 al abrir `config/`, `includes/` o `database/` | Es lo correcto: los `.htaccess` los bloquean. No los borre. |

## 7. Estructura

```
sistema_expediente/
├── config/config.php        ← conexión y parámetros
├── includes/                ← lógica (auth, estudiantes, academico, formularios, layout, db)
├── css/estilos.css
├── database/
│   ├── ies4_expedientes_v2.sql
│   └── parches/             ← 01 a 09 (ver la tabla de la sección 2)
├── login.php  logout.php  index.php  cambiar_clave.php
├── nuevo.php  buscar.php  ver.php  editar.php     ← expedientes
├── academico.php                                  ← inscripciones, cursadas y exámenes
└── usuarios.php                                   ← administración de usuarios
docs/
└── Pendientes_de_interfaz_PHP.pdf
```

## 8. Reglas del instituto relevadas

Aprobación de final: 4 o más · regularidad de 2 años · 3 intentos como regular y 3 como libre (el ausente no cuenta) · apto físico y seguro SEMED con renovación anual (vencen el 31/12) · un estudiante no cursa las dos carreras a la vez · en materias con deportes se conserva la nota de cada deporte aprobado y la materia se aprueba con todos · planes vigentes: 2020 (Res. 2281-E-20 tarde y 2286-E-20 mañana), cambio previsto para 2027.