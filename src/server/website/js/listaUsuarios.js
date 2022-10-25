$(document).ready(function(){
  var url = "http://localhost:8000/ReadUsuario"
  const options = {
  method: "get",
  headers: {"Content-Type": "application/json"},
  };
  fetch(url, options).then(response => response.json())
  .then(response => {
    $("#tableBody > tbody").empty();
    console.log(response)
    for (var i = 0; i < response.length; i++) {
      var persona = response [i];      
      var identificacion = persona.Persona ;
      var usuario = persona.Usuario;
      var pass = persona.Contraseña ;      
      var tipoUser = persona.TipodeUsuario;
      if (tipoUser== true ){
        tipoUser = 'Administrador' 
      }else{
        tipoUser =  'Regular'
      }
      var tabla = "<tr><td> ";
      tabla += identificacion + "</td><td>" + usuario + "</td><td>" + pass + "</td><td>" + tipoUser + "</td>"
      var boton = " <input class=\"buttons\" type=\"submit\" id=\"addBtn\" value=\" Editar \" onclick=\"edit("+ identificacion +",\'" + usuario +"\',\'"+ pass + "\',\'" + tipoUser+"\');\" >"
      var boton2 = " <input class=\"buttons\" type=\"submit\" id=\"addBtn\" value=\" Eliminar \" onclick=\"edit("+ identificacion +",\'" + usuario +"\',\'"+ pass + "\',\'" + tipoUser+"\');\" >"
      //se debe cambiar el otro boton
      tabla+= "<td>"+ boton + boton2 + "</td></tr>"
      $("#tablaItems ").append(tabla);
    }

  }).catch(e => {
      console.log(e);
  });

})

function add(){
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip') 
  location.replace('./Usuarios.html?uss='+uss+"&ip="+ip);
}
function edit(nombre,user,pass,admin){
  let url = './UsuarioEdit.html?add=0'
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip') 
  url+='&uss='+uss
  url+='&ip='+ip
  url+='&nombre='+nombre
  url+='&user='+user
  url+='&password='+pass
  url+='&admin='+admin
  location.replace(url);
}
function ret(){
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip') 
  location.replace('./AdminOptions.html?uss='+uss+"&ip="+ip);
}
function cerrar(){
  location.replace('./index.html');
}
