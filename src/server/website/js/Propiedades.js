
$(document).ready(function(){
  var url = "http://localhost:8000/ReadTipoUsoPropiedad"
  const $select = $("#idType")
  const options = {
    method: "get",
    headers: {"Content-Type": "application/json"},
    };
  fetch(url, options).then(response => response.json())
  .then(response => {
    console.log(response);
    for (var i = 0; i < response.length; i++) {
      valor=response[i].Nombre;
      $select.append($("<option>", {
        value: valor,
        text: valor
      }));
    }
    if(add== "0")
      document.getElementById('idType').value = uso;
    }).catch(e => {
      console.log(e);
    });
    //segundo select
    var url = "http://localhost:8000/ReadTipoZonaPropiedad"
    const $select2 = $("#idZone")
    fetch(url, options).then(response => response.json())
  .then(response => {
    console.log(response);
    for (var i = 0; i < response.length; i++) {
      valor=response[i].Nombre;
      $select2.append($("<option>", {
        value: valor,
        text: valor
      }));
    }
    if(add== "0")
      document.getElementById('idZone').value =zona;
    }).catch(e => {
      console.log(e);
    });
    var add = (new URL(location.href)).searchParams.get('add')
    if(add== "0"){
      var uso = (new URL(location.href)).searchParams.get('uso')
      var zona = (new URL(location.href)).searchParams.get('zona')
      var lote = (new URL(location.href)).searchParams.get('lote')
      var m2 = (new URL(location.href)).searchParams.get('m2')
      var valorFiscal = (new URL(location.href)).searchParams.get('valorFiscal')
      var registro = (new URL(location.href)).searchParams.get('registro')
      var activo = (new URL(location.href)).searchParams.get('activo')
      document.getElementById('lote').value =lote;
      document.getElementById('squareM').value =m2;
      document.getElementById('price').value =valorFiscal;
      document.getElementById('date').value =registro;
    }
})


function ret() {
  var user = ''// (new URL(location.href)).searchParams.get('user')
  location.replace(' ./listaPropiedades.html?user='+user);
}
function cerrar(){
  location.replace('./index.html');
}
