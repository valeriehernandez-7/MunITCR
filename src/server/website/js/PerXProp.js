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
    for (var i = 0; i < response.length; i++) {
      valor=parseInt(response[i].Propiedad);
      $select2.append($("<option>", {
        value: valor,
        text: valor
      }));
    }
    if(add== "0")
      document.getElementById('lote').value = idProp;
    }).catch(e => {
      console.log(e);
  })

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

async function add() {
  var url = "http://localhost:8000/CreatePersonaXPropiedad"
  var iden = $("#nombre").val()
  var lote = $("#lote").val();
  var fecha = $("#date").val();
  const body={
    iden: iden,
    lote:lote,
    fecha: fecha
  }
  const options = {
  method: "post",
  body: JSON.stringify(body),
  headers: {"Content-Type": "application/json"},
  };
  //Petición HTTP
  console.log(body)
  fetch(url, options).then(response => response.json())
  .then(response => {
      console.log(response);
      if(response == 5404){
        window.alert("El tipo de Identificación no existe");
        return
      }
      if(response == 5406){
        window.alert("La persona ya está asociada con la propiedad");
        return
      }
      if(response == 5404){
        window.alert("No se puede asociar porque no existe la propiedad o la persona");
        return
      }
      if(response == 5400){
        window.alert("Los parametros no deben ser null");
        return
      }
      if(response == 5200){
        window.alert("La asociacion fue ingresada con exito");
        return
      }else {
        window.alert("Ocurrio un error al ingresar el dato");
      }
    }
    ).catch(e => {
      console.log(e);
    });
}               

function ret() {
  var user = ''// (new URL(location.href)).searchParams.get('user')
  location.replace(' ./listaPerXProp.html?user='+user)
}
function cerrar(){
  location.replace('./index.html');
}
