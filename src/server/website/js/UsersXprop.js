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
      document.getElementById('nombre').value = usuario;
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
    var usuario = (new URL(location.href)).searchParams.get('usuario')
    var lote = (new URL(location.href)).searchParams.get('lote')
    //document.getElementById('usuario').value =usuario;
    //document.getElementById('lote').value =lote;
  }
})

async function add() {
  var url = "http://localhost:8000/CreateUsuarioXPropiedad"
  var user = $("#nombre").val()
  var lote = $("#lote").val();
  const body={
    user: user,
    lote:lote
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

function ret() {
  var user = ''// (new URL(location.href)).searchParams.get('user')
  location.replace(' ./listaUsersXprop.html?user='+user);
}
function cerrar(){
  location.replace('./index.html');
}
