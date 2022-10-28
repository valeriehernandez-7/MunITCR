$(document).ready(function(){
  var url = "http://localhost:8000/ReadPersonaIdentificacion"
  const $select = $("#ident")
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
      if(add==0)
        document.getElementById('ident').value = ident;
    }
    
    
  }).catch(e => {
      console.log(e);
    }); 
    var add = (new URL(location.href)).searchParams.get('add')
    if(add== "0"){
      var ident = (new URL(location.href)).searchParams.get('nombre')
      var user = (new URL(location.href)).searchParams.get('user')
      var pass = (new URL(location.href)).searchParams.get('password')
      if ((new URL(location.href)).searchParams.get('admin') == 'Administrador'){
          var admin = 1
      }      
      document.getElementById('user').value =user;
      document.getElementById('password').value =pass;
      if(admin==1){
          document.getElementById('Admin').checked=true
      }
    }
    

})
function showPass() {
  var showPass = document.getElementById("password");
  if (showPass.type === "password") {
      showPass.type = "text";
    } else {
      showPass.type = "password";
    }
}

async function add() {
  var url = "http://localhost:8000/CreateUsuario"
  var ident = $("#ident").val()
  var user = $("#user").val();
  var pass = $("#password").val();
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip')
  var admin 
  const cb = document.querySelector('#Admin');
  if(cb.checked==true){
    admin = 'Administrador'
  }else{
    admin = 'Propietario'
  }
  const body={
    ident: ident,
    user: user,
    password: pass,
    admin: admin,
    uss: uss,
    ip: ip
  }
  const options = {
  method: "post",
  body: JSON.stringify(body),
  headers: {"Content-Type": "application/json"},
  };
  //Petición HTTP
  console.log(options.body)
  fetch(url, options).then(response => response.json())
  .then(response => {
      if(response == 5404){
        window.alert("El tipo de Identificación no existe");
        return
      }
      if(response == 5406){
        window.alert("La persona ya tiene un usuario");
        return
      }
      if(response == 5407){
        window.alert("El usuario ya existe");
        return
      }
      if(response == 5404){
        window.alert("La identificación no es válida");
        return
      }
      if(response == 5200){
        window.alert("Usuario ingresado con exito");
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
  var url = "http://localhost:8000/UpdateUsuario"
  var oldID =  (new URL(location.href)).searchParams.get('user')
  var ident = $("#ident").val()
  var user = $("#user").val();
  var pass = $("#password").val();  
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip')
  var admin 
  const cb = document.querySelector('#Admin');
  if(cb.checked==true){
    admin = 'Administrador'
  }else{
    admin = 'Propietario'
  }
  const body={
    oldID : oldID,
    ident: ident,
    user: user,
    password: pass,
    admin: admin,
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
        window.alert("La identifacion ingresada no existe");
        return
      }
      if(response == 5400){
        window.alert("Los parametros no deben ser null");
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
  location.replace('./listaUsuarios.html?uss='+uss+"&ip="+ip);  
}
function cerrar(){
  location.replace('./index.html');
}
