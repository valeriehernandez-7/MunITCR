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
      var boton2 = " <input class=\"buttons\" type=\"submit\" id=\"addBtn\" value=\" Eliminar \" onclick=\"delet(\'"+nombre+"\'," + ID +",\'"+IDKind + "\'," + tel1+ ","+ tel2+ ",\'" +email+"\');\" >"
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
    location.replace('./Persona.html?uss='+uss+"&ip="+ip);
}
function edit(nombre,id,tipo,tel,tel2,email){
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip')
  let url = './PersonaEdit.html?add=0'
  url+="&uss="+uss
  url+="&ip="+ip
  url+='&nombre='+nombre
  url+='&id='+id
  url+='&tipo='+tipo
  url+='&tel='+tel
  url+='&tel2='+tel2
  url+='&email='+email
  location.replace(url);
}

function delet(nombre,id,tipo,tel,tel2,email){
  var url = "http://localhost:8000/DeletePersona"
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip')
  
  const body={
    id: id.toString(),
    uss : uss,
    ip : ip
  }
  const options = {
  method: "post",
  body: JSON.stringify(body),
  headers: {"Content-Type": "application/json"},
  };
  fetch(url, options).then(response => response.json())
  .then(response => {
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
      window.alert("Persona eliminada con exito");
      var uss = (new URL(location.href)).searchParams.get('uss')
      var ip = (new URL(location.href)).searchParams.get('ip')
      location.replace('./listaPersona.html?uss='+uss+"&ip="+ip);
      return
    }else {
      window.alert("Ocurrio un error al borrar la persona");
    }
    
    }
  ).catch(e => {
      console.log(e);
    });
}
function ret(){
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip')
  location.replace('./AdminOptions.html?uss='+uss+"&ip="+ip);
}
function cerrar(){
  location.replace('./index.html');
}
