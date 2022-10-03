$(document).ready(function(){
  console.log('cargando')
  var url = "http://localhost:8000/ReadPersonaXPropiedad"
  const options = {
  method: "get",
  headers: {"Content-Type": "application/json"},
  };
  fetch(url, options).then(response => response.json())
  .then(response => {
    $("#tableBody > tbody").empty();
    for (var i = 0; i < response.length; i++) {
      var perXprop = response [i];      
      var Propietario = perXprop.Propietario;
      var Propiedad = perXprop.Propiedad;
      var FechaAsociación = perXprop.FechadeAsociación ;
      FechaAsociación=FechaAsociación.substring(0,10);
      var FechaDesasociación = perXprop.FechaDesasociación;
      var tabla = "<tr><td> ";
      if(FechaDesasociación==undefined){
        tabla += Propietario + "</td><td>" + Propiedad + "</td><td>" + FechaAsociación + "</td><td>" + "</td>"
      }else{
        FechaDesasociación = FechaDesasociación.substring(0,10)
        tabla += Propietario + "</td><td>" + Propiedad + "</td><td>" + FechaAsociación + "</td><td>" + FechaDesasociación + "</td>"
      } 
      var boton = " <input class=\"buttons\" type=\"submit\" id=\"addBtn\" value=\" Editar \" onclick=\"edit("+ Propietario +"," + Propiedad +",\'"+ FechaAsociación + "\',\'" + FechaDesasociación +"\');\" >"
      var boton2 = " <input class=\"buttons\" type=\"submit\" id=\"addBtn\" value=\" Eliminar \" onclick=\"edit("+ Propietario +"," + Propiedad +",\'"+ FechaAsociación + "\',\'" + FechaDesasociación +"\');\" >"
      //se debe cambiar el otro boton
      tabla+= "<td>"+ boton + boton2 + "</td></tr>"
      $("#tablaItems ").append(tabla);
    }

  }).catch(e => {
      console.log(e);
  });

})

function edit(nombre,lote,fechaI,fechaF){
  let url = './PerXPropEdit.html?add=0'
  url+='&nombre='+nombre
  url+='&lote='+lote
  url+='&fechaI='+fechaI
  if(fechaF==undefined){
    url+='&fechaF='+'null'
  }else{
    url+='&fechaF='+fechaF
  }  
  location.replace(url);
}
function add(){
    location.replace('./PerXProp.html');
}
function ret(){
  location.replace('./AdminOptions.html');
}
function cerrar(){
  location.replace('./index.html');
}
