$(document).ready(function(){
    var url = "http://localhost:8000/ReadPersonaIdentificacion"
  const $select = $("#nombre")
  const options = {
    method: "get",
    headers: {"Content-Type": "application/json"},
    };
  fetch(url, options).then(response => response.json())
  .then(response => {
    console.log(response);
    for (var i = 0; i < response.length; i++) {
      valor=response[i].Persona;
      $select.append($("<option>", {
        value: valor,
        text: valor
      }));
    }
    if(add== "0")
      document.getElementById('nombre').value = idPer;
    }).catch(e => {
      console.log(e);
    });
    //segundo select
    var url = "http://localhost:8000/ReadPropiedadLoteAdmin"
    const $select2 = $("#lote")
    fetch(url, options).then(response => response.json())
    .then(response => {
    console.log(response);
    for (var i = 0; i < response.length; i++) {
      valor=response[i].Propiedad;
      $select2.append($("<option>", {
        value: valor,
        text: valor
      }));
    }})

    var add = (new URL(location.href)).searchParams.get('add')
    if(add== "0"){
      var idPer = (new URL(location.href)).searchParams.get('nombre')
      var idProp = (new URL(location.href)).searchParams.get('lote')
      nombre = document.getElementById('nombre')
      nombre.value = idPer
      lote = document.getElementById('lote')
      lote.value =idProp
    }
})

function ret() {
  var user = ''// (new URL(location.href)).searchParams.get('user')
  location.replace(' ./listaPerXProp.html?user='+user)
}
function cerrar(){
  location.replace('./index.html');
}
