# Sistema de expedientes de alumnos – IES N.º 4

PHP + MySQL + HTML5 + CSS3 (sin JavaScript, sin Bootstrap, sin bibliotecas).

---

## 1. Estructura del proyecto

Carpeta destino: `C:\xampp\htdocs\sistema_expediente\`

```
sistema_expediente/
├── config/
│   ├── config.php               ← datos de conexión y parámetros
│   └── .htaccess                ← bloquea el acceso web directo
├── includes/
│   ├── db.php                   ← conexión PDO
│   ├── auth.php                 ← sesión, login, permisos, CSRF, auditoría
│   ├── layout.php               ← cabecera, pie y página de error
│   ├── estudiantes.php          ← validaciones y consultas de expedientes
│   ├── academico.php            ← situación académica (grilla por año, validaciones)
│   ├── form_estudiante.php      ← formulario compartido (alta y edición)
│   └── .htaccess
├── css/
│   └── estilos.css              ← estilos propios
├── database/
│   ├── sistema_expediente.sql   ← estructura (la que usted subió)
│   ├── datos_iniciales.sql      ← carreras, documentación y usuarios de prueba
│   ├── materias_ed_fisica.sql   ← espacios curriculares de la ficha Word
│   └── .htaccess
├── login.php   logout.php   index.php
├── nuevo.php   buscar.php   ver.php   editar.php
├── academico.php                ← carga de inscripciones, cursadas y exámenes
└── cambiar_clave.php
```

## 2. Base de datos

Se usa **su archivo SQL sin modificarlo**. Tablas que utiliza el sistema:

| Tabla | Uso |
|---|---|
| `estudiante` | Datos de la ficha (DNI único) |
| `carrera` | Carrera a la que pertenece el alumno |
| `tipo_documento` / `documentacion_estudiante` | Lista de documentación y qué presentó cada alumno |
| `usuario` | Inicio de sesión y roles |
| `auditoria` | Registra inicios de sesión, altas y modificaciones |

| `materia` | Los espacios curriculares de los 4 años (cargados desde la ficha Word) |
| `inscripcion` | «Nuevos registros de inscripción para cursar y recursar» |
| `cursada` | Año que cursó, % asistencia, % T.P., carácter y promedio de cada espacio |
| `examen` | Cada intento de examen final: fecha, calificación, libro, folio y observación |

Las tablas `correlatividad` y `tramite` quedan en la base pero **no se usan** todavía.

### Correspondencia con la ficha Word («Modelo de situación académica»)

| En la ficha | En el sistema |
|---|---|
| Profesorado, Decreto-Resolución | `carrera` (se muestra en el expediente) |
| Apellidos, Nombres, DNI, Fecha de nacimiento, Nació en, Domicilio, Teléfono, Título con el que ingresó, Establecimiento, Año de ingreso, Observaciones | `estudiante` (formulario de alta/modificación) |
| Fecha de inscripción, Curso, Condición, Observaciones | `inscripcion` |
| Espacios curriculares (1.º a 4.º año) | `materia` |
| Año que cursó, % Asistencia, % T.P., Carácter, Promedio | `cursada` |
| Examen final: fechas y calificaciones, Libro, Folio, Observación | `examen` |
| Calificación definitiva | Se calcula: último intento aprobado (nota ≥ 4) |

**Columna sin equivalente:** la ficha tiene «Parciales o unidades», pero la tabla `cursada` no tiene un campo para eso, por lo que no se muestra. Si lo necesitan: `ALTER TABLE cursada ADD COLUMN parciales VARCHAR(50) NULL;` y se agrega al formulario y a la grilla.

### Reglas de validación

- **Obligatorios:** apellido, nombre, DNI, fecha de nacimiento, título de ingreso, establecimiento, año de ingreso, carrera y estado.
- **Opcionales:** lugar de nacimiento, domicilio, teléfono, observaciones y la documentación (el expediente puede abrirse incompleto).
- **Duplicados:** se bloquea el mismo DNI (también lo garantiza la base con `UNIQUE`) y el mismo apellido + nombre + fecha de nacimiento.

### Roles

| Rol | Consultar | Crear / modificar | Alcance |
|---|---|---|---|
| Administradora | Sí | Sí | Todas las carreras |
| Vicerrectora | Sí | **No** | Todas las carreras |
| Coordinadora | Sí (ambos turnos) | Sí | Solo su carrera (`usuario.id_carrera`) |
| Preceptora | Sí (ambos turnos) | Sí | Solo su carrera (`usuario.id_carrera`) |

Todos consultan todos los expedientes (consulta entre turnos, como pide el informe). Solo se **modifica** dentro de la carrera/turno asignada; un usuario con `id_carrera` vacío (Administradora) modifica todas.

## 3. Configurar XAMPP y MySQL

1. Abra el **Panel de XAMPP** y presione **Start** en **Apache** y **MySQL**.
2. Entre a `http://localhost/phpmyadmin`.
3. Pestaña **Bases de datos** → nombre `sistema_expediente`, cotejamiento `utf8mb4_general_ci` → **Crear**.
4. Seleccione esa base → pestaña **Importar** → elija `database/sistema_expediente.sql` → **Importar**.
5. Importe luego `database/datos_iniciales.sql` de la misma forma.
6. Importe por último `database/materias_ed_fisica.sql` (los espacios curriculares de la ficha).
7. **Comprobación:** en phpMyAdmin deben verse 11 tablas; `usuario` con 5 filas, `carrera` con 2, `tipo_documento` con 4 y `materia` con 86 (43 por carrera: 11 + 12 + 13 + 7).

> **Si la importación da el error `Unknown collation: 'utf8mb4_0900_ai_ci'`:** su XAMPP trae MariaDB, que no conoce ese cotejamiento (su dump salió de MySQL 8). Abra `sistema_expediente.sql` con el Bloc de notas, use *Reemplazar todo* de `utf8mb4_0900_ai_ci` por `utf8mb4_unicode_ci`, guarde e importe de nuevo.

> **Contraseña de root:** `config.php` asume usuario `root` sin contraseña (XAMPP por defecto). Si su MySQL tiene contraseña, colóquela en `DB_PASS`. Para un entorno más seguro puede crear un usuario propio:
> ```sql
> CREATE USER 'expedientes'@'localhost' IDENTIFIED BY 'una_clave_segura';
> GRANT SELECT, INSERT, UPDATE ON sistema_expediente.* TO 'expedientes'@'localhost';
> ```
> y poner ese usuario y clave en `config/config.php`.

## 4. Copiar el sistema y probar por etapas

Copie toda la carpeta `sistema_expediente` a `C:\xampp\htdocs\`. No avance a la siguiente etapa si la anterior falla.

### Etapa 1 – Conexión y estilos
Abra `http://localhost/sistema_expediente/login.php`.
- ✔ Se ve la pantalla de acceso con barra azul y formulario centrado.
- ✘ Mensaje «No se pudo conectar con la base de datos»: MySQL no está iniciado, o `DB_USER`/`DB_PASS`/`DB_NAME` en `config/config.php` son incorrectos. Ponga `DEBUG` en `true` temporalmente para ver el detalle.
- ✘ Página sin estilos: verifique que existe `css/estilos.css`.

### Etapa 2 – Inicio de sesión
- Ingrese `admin` / `Cambiar2026!` → ✔ entra a **Inicio**.
- Pruebe una clave errónea → ✔ «Usuario o contraseña incorrectos.»
- Abra `http://localhost/sistema_expediente/index.php` en otra ventana sin sesión → ✔ lo envía a `login.php`.
- Presione **Salir** → ✔ vuelve al login con aviso.
- Abra `http://localhost/sistema_expediente/config/config.php` → ✔ debe dar **403 Prohibido**.

### Etapa 3 – Crear expediente
En **Nuevo expediente**:
1. Deje todo vacío y guarde → ✔ el navegador marca los campos obligatorios.
2. Complete con DNI `123` → ✔ el sistema rechaza (el DNI debe tener 6 a 9 dígitos).
3. Complete un alumno válido (por ejemplo DNI `40123456`, nacido en el 2000) y marque algunos documentos → ✔ mensaje «Expediente creado correctamente» y se abre la vista del expediente.
4. En phpMyAdmin: ✔ una fila en `estudiante`, filas en `documentacion_estudiante` y una en `auditoria`.

### Etapa 4 – Duplicados
- Cree otro expediente con el **mismo DNI** → ✔ error «Ya existe un expediente con ese DNI».
- Cree otro con distinto DNI pero **mismo apellido, nombre y fecha de nacimiento** → ✔ error de posible duplicado.

### Etapa 5 – Buscar y consultar
En **Buscar alumnos**:
- Busque por apellido (completo o parcial) → ✔ aparece en la tabla.
- Busque por DNI → ✔ aparece.
- Busque algo inexistente → ✔ aviso «No se encontraron alumnos».
- Presione **Ver** → ✔ se muestran datos, ingreso, documentación y observaciones.

### Etapa 6 – Modificar
- **Modificar** → cambie el teléfono y guarde → ✔ mensaje de confirmación y dato actualizado.
- Intente poner el DNI de otro alumno → ✔ lo rechaza.
- En `auditoria` ✔ queda «Modificación de expediente» con los campos cambiados.

### Etapa 7 – Permisos
- Cierre sesión e ingrese como `vicerrectora` → ✔ puede buscar y ver, **no** aparecen «Nuevo expediente» ni «Modificar».
- Con esa sesión abra `http://localhost/sistema_expediente/nuevo.php` → ✔ «Acceso denegado» (403).
- Ingrese como `preceptora` → ✔ puede crear y modificar.
- Cree un alumno en la carrera «Tarde» con `admin`. Ingrese como `preceptora` (turno Mañana) → ✔ lo encuentra y lo puede **ver**, pero **no** aparece «Modificar», y abrir `editar.php?id=N` a mano da «Acceso denegado».
- Ingrese como `preceptora_tarde` → ✔ puede modificar a ese alumno.

### Etapa 8 – Situación académica (réplica de la ficha)
Abra un expediente con `admin` o `preceptora` y presione **Cargar situación académica**.
1. **Inscripción:** registre una inscripción (fecha, espacio, año, «Cursar») → ✔ aparece en la tabla y en el expediente, en «Nuevos registros de inscripción».
2. **Cursada:** cargue Pedagogía, año 2026, asistencia 85, T.P. 90, Regular, promedio 7,5 → ✔ en el expediente, bajo **PRIMER AÑO**, la fila de Pedagogía muestra esos valores. Pruebe asistencia 150 → ✔ lo rechaza.
3. **Exámenes:** cargue un examen de Pedagogía con nota 2 (libro y folio obligatorios) y otro posterior con nota 6 → ✔ la grilla muestra los dos intentos y la **calificación definitiva 6** con su libro y folio.
4. **Recursada:** cargue otra cursada de Pedagogía con otro año → ✔ aparece una segunda fila bajo el mismo espacio.
5. **Eliminar:** use «Eliminar» en un registro → ✔ pide confirmación antes de borrar.
6. Con `vicerrectora` ✔ ve la grilla pero no tiene botones de carga.

### Etapa 9 – Contraseñas
Con cada usuario: **Mi contraseña** → cambie la clave inicial → ✔ confirmación y el nuevo ingreso funciona.
**Haga esto antes de usar datos reales**, o elimine los usuarios de prueba y cree los verdaderos.

## 5. Crear usuarios reales

No hay pantalla de usuarios (no se pidió). Genere el hash en la consola de Windows:

```
C:\xampp\php\php.exe -r "echo password_hash('ClaveInicial123', PASSWORD_DEFAULT);"
```

y en phpMyAdmin (pestaña SQL):

```sql
INSERT INTO usuario (nombre, usuario, clave, rol, activo, id_carrera)
VALUES ('Nombre Apellido', 'napellido', 'PEGAR_AQUI_EL_HASH', 'Preceptora', 1, 1);
```

Para dar de baja a alguien: `UPDATE usuario SET activo = 0 WHERE usuario = 'napellido';` (la sesión se cierra en su próxima acción).

## 6. Seguridad implementada

- Consultas preparadas (PDO) en todo el acceso a datos → sin inyección SQL.
- Contraseñas con `password_hash` / `password_verify`; nunca se muestran ni se guardan en sesión.
- Token CSRF en todos los formularios que modifican datos (incluido «Salir»).
- Toda salida HTML escapada (`e()`) → sin XSS; política CSP estricta (no hay scripts ni estilos en línea).
- Sesión con cookie `HttpOnly`, regeneración del id al ingresar y cierre por 30 min de inactividad.
- Usuario y rol se revalidan en la base en cada petición.
- Mensaje de login genérico (no revela si el usuario existe).
- Carpetas `config/`, `includes/` y `database/` bloqueadas por `.htaccess`.

## 7. Supuestos que debe revisar

- **Turno de la carrera:** la ficha no lo indica; se cargó «Mañana» en `datos_iniciales.sql`.
- **Lista de documentación:** DNI, título en trámite, apto físico y seguro SEMED, tomados del informe de relevamiento (el informe escribe «CEMED» una vez y «SEMED» el resto; se usó SEMED). Se edita en `tipo_documento`.
- **Turnos:** se cargaron dos filas en `carrera` (Mañana y Tarde) para el mismo profesorado, porque la tabla guarda el turno. Ajústelo si lo manejan distinto.
- **Obligatorios:** si la institución exige también domicilio o teléfono, agregue `required` y una regla en `validar_estudiante()` (`includes/estudiantes.php`).
- **Edad mínima:** se exige 16 años; ajuste en la misma función.
- **Nota de aprobación:** se tomó 4 como mínimo para considerar aprobado un final (constante `NOTA_APROBACION` en `includes/academico.php`).
- **Grilla de exámenes:** muestra hasta 3 intentos por espacio (como la ficha); si hay más, se avisa en «Observación» y el listado completo está en «Cargar situación académica».
- **Espacios con subdivisiones** (Práct. Deport. 2, 3 y 4, Práctica I a III con Taller Integrador): cada subdivisión es un espacio curricular propio; no se calcula el «Promedio» de grupo que figura en la ficha.
- **Sin límite de intentos de login:** para uso institucional real convendría agregarlo.
