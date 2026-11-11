(function () {
  'use strict';

  document.addEventListener('click', function (event) {
    var botonImprimir = event.target.closest('[data-imprimir]');

    if (botonImprimir) {
      event.preventDefault();
      window.print();
      return;
    }

    var botonTodos = event.target.closest('[data-seleccionar-todos]');

    if (botonTodos) {
      event.preventDefault();

      var formulario = botonTodos.closest('form');
      if (!formulario) {
        return;
      }

      var casillas = formulario.querySelectorAll('input[type="checkbox"][name="ids[]"]');
      var marcar = botonTodos.getAttribute('data-estado') !== 'todos';

      for (var i = 0; i < casillas.length; i++) {
        casillas[i].checked = marcar;
      }

      botonTodos.setAttribute('data-estado', marcar ? 'todos' : 'ninguno');
      botonTodos.textContent = marcar ? 'Quitar selección' : 'Seleccionar todos';
    }
  });

  // Permite abrir la vista previa y lanzar el diálogo de impresión con ?auto=1
  if (new URLSearchParams(window.location.search).get('auto') === '1') {
    window.addEventListener('load', function () {
      window.print();
    });
  }
})();
