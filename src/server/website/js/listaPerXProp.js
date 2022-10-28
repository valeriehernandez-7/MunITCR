$(document).ready(function(){
  console.log('cargando')
  
  var valor = (new URL(location.href)).searchParams.get('opcion')
  if(valor==null){
    valor=1;
  }
  var opcion = document.getElementById("vistarelacionpxp");
  opcion.value= valor  
  var url = "http://localhost:8000/ReadPersonaXPropiedad"+"?opcion="+valor
  const options = {
  method: "get",
  headers: {"Content-Type": "application/json"},
  };
  fetch(url, options).then(response => response.json())
  .then(response => {
    $("#tableBody > tbody").empty();
    for (var i = 0; i < response.length; i++) {
      console.log(response[i])
      var perXprop = response [i];      
      var Propietario = perXprop.Propietario;
      var Propiedad = perXprop.Propiedad;
      var FechaAsociación = perXprop.FechadeRegistro;
      FechaAsociación=FechaAsociación.substring(0,10);
      var FechaDesasociación = perXprop.FechaDesasociación;
      var tabla = "<tr><td> ";
      tabla += Propietario + "</td><td>" + Propiedad + "</td><td>" + FechaAsociación + "</td>"
      //if(FechaDesasociación==undefined){
      //  tabla += Propietario + "</td><td>" + Propiedad + "</td><td>" + FechaAsociación + "</td><td>" + "</td>"
      //}else{
      //  FechaDesasociación = FechaDesasociación.substring(0,10)
      //  tabla += Propietario + "</td><td>" + Propiedad + "</td><td>" + FechaAsociación + "</td><td>" + FechaDesasociación + "</td>"
      //} 
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

function update(){
  var opcion = document.getElementById("vistarelacionpxp");
  var value = opcion.value;
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip')
  location.replace('./listaPerXProp.html?uss='+uss+"&ip="+ip+"&opcion="+value);
  
}

function edit(nombre,lote,fechaI,fechaF){
  let url = './PerXPropEdit.html?add=0'
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip')
  url+='&uss='+uss
  url+='&ip='+ip
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
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip')
  location.replace('./PerXProp.html?uss='+uss+"&ip="+ip);
}
function ret(){
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip') 
  location.replace('./AdminOptions.html?uss='+uss+"&ip="+ip);
}
function cerrar(){
  location.replace('./index.html');
}
