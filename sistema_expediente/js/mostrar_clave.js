
document.addEventListener('DOMContentLoaded', function () {
    const campo = document.getElementById('clave');
    const boton = document.getElementById('boton-ver-clave');
    const ojoAbierto = document.getElementById('ojo-abierto');
    const ojoCerrado = document.getElementById('ojo-cerrado');

    if (!campo || !boton || !ojoAbierto || !ojoCerrado) {
        return;
    }

    boton.addEventListener('click', function () {
        const mostrar = campo.type === 'password';

        campo.type = mostrar ? 'text' : 'password';

        ojoAbierto.hidden = mostrar;
        ojoCerrado.hidden = !mostrar;

        boton.setAttribute(
            'aria-label',
            mostrar ? 'Ocultar contraseña' : 'Mostrar contraseña'
        );

        boton.setAttribute('aria-pressed', String(mostrar));
    });
});
