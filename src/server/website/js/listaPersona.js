$(document).ready(function(){
  console.log('cargando')
  var url = "http://localhost:8000/ReadPersona"
  const options = {
  method: "get",
  headers: {"Content-Type": "application/json"},
  };
  fetch(url, options).then(response => response.json())
  .then(response => {
    $("#tableBody > tbody").empty();
    for (var i = 0; i < response.length; i++) {
      var persona = response [i];      
      var nombre = persona.Nombre;
      var IDKind = persona.TipodeIdentificación;
      var ID = persona.Identificación ;
      var tel1 = persona.Teléfono1;
      var tel2 = persona.Teléfono2;
      var email = persona.CorreoElectrónico;
      var tabla = "<tr><td> ";
      tabla += nombre + "</td><td>" + ID + "</td><td>" + IDKind + "</td><td>" + tel1 + "</td><td>" + tel2 + "</td><td>" + email + "</td>"
      var boton = " <input class=\"buttons\" type=\"submit\" id=\"addBtn\" value=\" Editar \" onclick=\"edit(\'"+nombre+"\'," + ID +",\'"+IDKind + "\'," + tel1+ ","+ tel2+ ",\'" +email+"\');\" >"
      //se debe cambiar el otro boton
      tabla+= "<td>"+ boton + boton + "</td></tr>"
      $("#tablaItems ").append(tabla);
    }

  }).catch(e => {
      console.log(e);
  });

})

function add(){
    location.replace('./Persona.html');
}
function edit(nombre,id,tipo,tel,tel2,email){
  let url = './PersonaEdit.html?add=0'
  url+='&nombre='+nombre
  url+='&id='+id
  url+='&tipo='+tipo
  url+='&tel='+tel
  url+='&tel2='+tel2
  url+='&email='+email
  location.replace(url);
}
function ret(){
  location.replace('./AdminOptions.html');
}
function cerrar(){
  location.replace('./index.html');
}
