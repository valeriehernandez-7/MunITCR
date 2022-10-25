$(document).ready(function(){
  var url = "http://localhost:8000/ReadPropiedadXUsuario"
  const options = {
  method: "get",
  headers: {"Content-Type": "application/json"},
  };
  fetch(url, options).then(response => response.json())
  .then(response => {
    $("#tableBody > tbody").empty();
    for (var i = 0; i < response.length; i++) {
      var propiedad = response [i];      
      var lote = propiedad.Propiedad;
      var user = propiedad.Usuario;    
      var tabla = "<tr><td> ";
      tabla += user + "</td><td>" + lote + "</td>"
      var boton = " <input class=\"buttons\" type=\"submit\" id=\"addBtn\" value=\" Editar \" onclick=\"edit(\'"+ user +"\',"+ lote +");\" >"
      var boton2 = " <input class=\"buttons\" type=\"submit\" id=\"addBtn\" value=\" Eliminar \" onclick=\"edit(\'"+ user +"\',"+ lote +");\" >"
      //se debe cambiar el otro boton
      tabla+= "<td>"+ boton + boton2 + "</td></tr>"
      $("#tablaItems ").append(tabla);
    }

  }).catch(e => {
      console.log(e);
  });

})
function edit(usuario,lote){
  let url = './UserXpropEdit.html?add=0'
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip') 
  url+='&uss='+uss
  url+='&ip='+ip
  url+='&usuario='+usuario
  url+='&lote='+lote
  location.replace(url);
}
function add(){
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip') 
  location.replace('./UsersXprop.html?uss='+uss+"&ip="+ip);
}
function ret(){
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip') 
  location.replace('./AdminOptions.html?uss='+uss+"&ip="+ip);
}
function cerrar(){
  location.replace('./index.html');
}
