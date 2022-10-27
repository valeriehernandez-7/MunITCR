$(document).ready(function(){
  var url = "http://localhost:8000/ReadPersonaIdentificacion"
  const $select = $("#nombre")
  const options = {
    method: "get",
    headers: {"Content-Type": "application/json"},
    };
  fetch(url, options).then(response => response.json())
  .then(response => {
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
      var registro = (new URL(location.href)).searchParams.get('fechaI')
      document.getElementById('lote').value = idProp;
      document.getElementById('date').value =registro;
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
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip')
  const body={
    iden: iden,
    lote:lote,
    fecha: fecha,
    uss: uss,
    ip: ip
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

async function update() {
  var url = "http://localhost:8000/UpdatePersonaXPropiedad"
  var oldid = (new URL(location.href)).searchParams.get('nombre')
  var oldLote = (new URL(location.href)).searchParams.get('lote')
  var fechaAsoc = $("#date").val()
  var fechaDesasoc = (new URL(location.href)).searchParams.get('fechaF')
  var id = $("#nombre").val()
  var lote = $("#lote").val();
  const body={
    oldId:oldid,
    oldLote: oldLote,
    id: id,
    lote:lote,
    fechaAsoc: fechaAsoc,
    fechaDesasoc: null
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
        window.alert("El tipo de propiedad no existe");
        return
      }      
      if(response == 5400){
        window.alert("Error al actualizar la propiedad");
        return
      }
      if(response == 5200){
        window.alert("Propiedad actualizada con exito");
        return
      }else {
        window.alert("Ocurrio un error al actualizar los daots");
      }
    }
    ).catch(e => {
      console.log(e);
    });
}

function ret() {
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip') 
  location.replace(' ./listaPerXProp.html?uss='+uss+"&ip="+ip)
}
function cerrar(){
  location.replace('./index.html');
}
