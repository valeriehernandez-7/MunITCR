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
  url+='&usuario='+usuario
  url+='&lote='+lote
  location.replace(url);
}
function add(){
    location.replace('./UsersXprop.html');
}
function ret(){
  location.replace('./AdminOptions.html');
}
function cerrar(){
  location.replace('./index.html');
}
