
$(document).ready(function(){
  var url = "http://localhost:8000/ReadTipoDocID"
  const $select = $("#TipoID")
  const options = {
    method: "get",
    headers: {"Content-Type": "application/json"},
    };
  fetch(url, options).then(response => response.json())
  .then(response => {
    for (var i = 0; i < response.length; i++) {
      valor=response[i].Nombre;
      $select.append($("<option>", {
        value: valor,
        text: valor
      }));
    }
    var add = (new URL(location.href)).searchParams.get('add')
    if(add== "0"){
      var nombre = (new URL(location.href)).searchParams.get('nombre')
      var id = (new URL(location.href)).searchParams.get('id')
      var tipo = (new URL(location.href)).searchParams.get('tipo')
      var tel = (new URL(location.href)).searchParams.get('tel')
      var tel2 = (new URL(location.href)).searchParams.get('tel2')
      var email = (new URL(location.href)).searchParams.get('email')
      document.getElementById('name').value =nombre;
      document.getElementById('idNumber').value =id;
      $("#TipoID").val(tipo);
      //document.getElementById('TipoID').value ="Cedula CR";
      document.getElementById('phone1').value =tel;
      document.getElementById('phone2').value =tel2;
      document.getElementById('email').value =email;
    }
  }).catch(e => {
      console.log(e);
    });
  

})

async function add() {
  var url = "http://localhost:8000/CreatePersona"
  var name = $("#name").val()
  var TipoID = $("#TipoID").val();
  var idNumber = $("#idNumber").val();
  var phone1 = $("#phone1").val();
  var phone2 = $("#phone2").val();
  var email = $("#email").val();
  const body={
    nombre: name,
    tipoID: TipoID,
    Ident:idNumber,
    tel1: phone1,
    tel2: phone2,
    email: email
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
        window.alert("La persona ya existe");
        return
      }
      if(response == 5400){
        window.alert("Los parametros no deben ser null");
        return
      }
      if(response == 5200){
        window.alert("Persona ingresada con exito");
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
  var url = "http://localhost:8000/UpdatePersona"
  var id = (new URL(location.href)).searchParams.get('id')
  var name = $("#name").val()
  var TipoID = $("#TipoID").val();
  var idNumber = $("#idNumber").val();
  var phone1 = $("#phone1").val();
  var phone2 = $("#phone2").val();
  var email = $("#email").val();
  const body={
    oldId:  id,
    nombre: name,
    tipoID: TipoID,
    Ident:  idNumber,
    tel1:   phone1,
    tel2:   phone2,
    email:  email
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
        window.alert("La identifacion ingresada no existe");
        return
      }
      if(response == 5400){
        window.alert("Error al actualizar la persona");
        return
      }
      if(response == 5200){
        window.alert("Persona actualizada con exito");
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
  location.replace(' ./listaPersona.html?uss='+uss+"&ip="+ip);
}
function cerrar(){
  location.replace('./index.html');
}
