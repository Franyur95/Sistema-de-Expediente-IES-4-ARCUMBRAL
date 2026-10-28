<?php
/**
 * Partial del formulario de estudiante.
 * Variables: $est (array|null), $carreras (array), $accion (string), $esEdicion (bool)
 */
$errores = session()->getFlashdata('errors') ?? [];

// En CI 4.7, old() exige un argumento. Para traer TODO el array de datos
// viejos, se lee directo desde el flashdata interno del framework.
$old = session()->getFlashdata('_ci_old_input')['old'] ?? [];

$valor = static function (string $campo) use ($old, $est) {
    return $old[$campo] ?? $est[$campo] ?? '';
};
?>
<?php if (! empty($errores)) : ?>
    <div class="mensaje mensaje-error">
        <ul style="margin:0;padding-left:1rem;">
            <?php foreach ($errores as $err) : ?>
                <li><?= esc($err) ?></li>
            <?php endforeach; ?>
        </ul>
    </div>
<?php endif; ?>

<form method="post" action="<?= esc($accion) ?>" class="formulario" novalidate>
    <?= csrf_field() ?>

    <div class="campo">
        <label for="dni">DNI / L.E. / L.C. *</label>
        <input type="text" id="dni" name="dni" required value="<?= esc($valor('dni')) ?>">
    </div>

    <div class="campo">
        <label for="apellido">Apellido *</label>
        <input type="text" id="apellido" name="apellido" required value="<?= esc($valor('apellido')) ?>">
    </div>

    <div class="campo">
        <label for="nombre">Nombre *</label>
        <input type="text" id="nombre" name="nombre" required value="<?= esc($valor('nombre')) ?>">
    </div>

    <div class="campo">
        <label for="fecha_nacimiento">Fecha de nacimiento *</label>
        <input type="date" id="fecha_nacimiento" name="fecha_nacimiento" required
               value="<?= esc($valor('fecha_nacimiento')) ?>">
    </div>

    <div class="campo">
        <label for="lugar_nacimiento">Lugar de nacimiento</label>
        <input type="text" id="lugar_nacimiento" name="lugar_nacimiento"
               value="<?= esc($valor('lugar_nacimiento')) ?>">
    </div>

    <div class="campo">
        <label for="domicilio">Domicilio</label>
        <input type="text" id="domicilio" name="domicilio" value="<?= esc($valor('domicilio')) ?>">
    </div>

    <div class="campo">
        <label for="telefono">Teléfono</label>
        <input type="text" id="telefono" name="telefono" value="<?= esc($valor('telefono')) ?>">
    </div>

    <div class="campo">
        <label for="email">Email</label>
        <input type="email" id="email" name="email" value="<?= esc($valor('email')) ?>">
    </div>

    <div class="campo">
        <label for="titulo_ingreso">Título con el que ingresó</label>
        <input type="text" id="titulo_ingreso" name="titulo_ingreso"
               value="<?= esc($valor('titulo_ingreso')) ?>">
    </div>

    <div class="campo">
        <label for="tipo_titulo">Tipo de título</label>
        <input type="text" id="tipo_titulo" name="tipo_titulo" value="<?= esc($valor('tipo_titulo')) ?>">
    </div>

    <div class="campo">
        <label for="establecimiento">Establecimiento</label>
        <input type="text" id="establecimiento" name="establecimiento"
               value="<?= esc($valor('establecimiento')) ?>">
    </div>

    <div class="campo">
        <label for="anio_ingreso">Año de ingreso</label>
        <input type="number" id="anio_ingreso" name="anio_ingreso" min="2000" max="2100"
               value="<?= esc($valor('anio_ingreso')) ?>">
    </div>

    <div class="campo">
        <label for="id_carrera">Carrera *</label>
        <select id="id_carrera" name="id_carrera" required>
            <option value="">— Seleccionar —</option>
            <?php foreach ($carreras as $c) : ?>
                <option value="<?= esc($c['id_carrera']) ?>"
                    <?= (string) $valor('id_carrera') === (string) $c['id_carrera'] ? 'selected' : '' ?>>
                    <?= esc($c['nombre']) ?> (<?= esc($c['turno']) ?>)
                </option>
            <?php endforeach; ?>
        </select>
    </div>

    <div class="campo">
        <label for="estado">Estado *</label>
        <select id="estado" name="estado" required>
            <?php
            $estados = ['activo', 'libre', 'egresado', 'abandono', 'pase'];
            $estActual = $valor('estado') ?: 'activo';
            foreach ($estados as $e) :
            ?>
                <option value="<?= esc($e) ?>" <?= $estActual === $e ? 'selected' : '' ?>>
                    <?= esc($e) ?>
                </option>
            <?php endforeach; ?>
        </select>
    </div>

    <div class="campo ancho-completo">
        <label for="observaciones">Observaciones</label>
        <textarea id="observaciones" name="observaciones"><?= esc($valor('observaciones')) ?></textarea>
    </div>

    <div class="acciones-form" style="width:100%;">
        <button type="submit" class="btn btn-primario">
            <?= $esEdicion ? 'Guardar cambios' : 'Crear expediente' ?>
        </button>
        <a href="<?= site_url('estudiantes') ?>" class="btn btn-secundario">Cancelar</a>
    </div>
</form>