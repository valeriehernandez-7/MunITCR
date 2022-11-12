$(document).ready(function(){
  var url = "http://localhost:8000/ReadUsuario"
  const $select = $("#nombre")
  const options = {
    method: "get",
    headers: {"Content-Type": "application/json"},
    };
  fetch(url, options).then(response => response.json())
  .then(response => {
    console.log(response);
    for (var i = 0; i < response.length; i++) {
      valor=response[i].Usuario;
      $select.append($("<option>", {
        value: valor,
        text: valor
      }));
    }
    if(add== "0")
      var idPer = (new URL(location.href)).searchParams.get('nombre')
      var idProp = (new URL(location.href)).searchParams.get('lote')
      nombre = document.getElementById('nombre')
      nombre.value = idPer
      lote = document.getElementById('lote')
      lote.value =idProp
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
      document.getElementById('lote').value = lote;
    }).catch(e => {
      console.log(e);
    });
  
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
  var url = "http://localhost:8000/CreateUsuarioXPropiedad"
  var user = $("#nombre").val()
  var lote = $("#lote").val();
  var fecha = $("#date").val();
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip')
  const body={
    iden: user,
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
      if(response == 5407){
        window.alert("El usuario y la propiedad ya estan asociadas");
        return
      }
      if(response == 5406){
        window.alert("La propiedad ya tiene un usuario asociado");
        return
      }
      if(response == 5404){
        window.alert("La propiedad o el usuario no existen");
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
  var url = "http://localhost:8000/UpdateUsuarioXPropiedad"
  var oldid = (new URL(location.href)).searchParams.get('nombre')
  var oldLote = (new URL(location.href)).searchParams.get('lote')
  var fechaAsoc = $("#date").val()
  var fechaDesasoc = (new URL(location.href)).searchParams.get('fechaF')
  var id = $("#nombre").val()
  var lote = $("#lote").val();
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip')
  var opcion = (new URL(location.href)).searchParams.get('opcion')
  const body={
    oldusr:oldid,
    oldlote: oldLote,
    iden: id,
    lote:lote,
    fecha: fechaAsoc,
    asoc:1,
    uss: uss,
    ip: ip,
    opcion: opcion
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
  location.replace('./listaUsersXprop.html?uss='+uss+"&ip="+ip); 
}
function cerrar(){
  location.replace('./index.html');
}
