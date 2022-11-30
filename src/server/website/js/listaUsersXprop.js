$(document).ready(function(){
  var valor = (new URL(location.href)).searchParams.get('opcion')
  if(valor==null){
    valor=1;
  }
  var opcion = document.getElementById("vistarelacionpxp");
  opcion.value= valor  
  var url = "http://localhost:8000/ReadPropiedadXUsuario"+"?opcion="+valor
  const options = {
    method: "get",
    headers: {"Content-Type": "application/json"},
  };
  fetch(url, options).then(response => response.json())
  .then(response => {
    $("#tableBody > tbody").empty();
    for (var i = 0; i < response.length; i++) {
      var perXprop = response [i];    
      var Propietario = perXprop.Usuario;
      var Propiedad = perXprop.Propiedad;
      var FechaAsociación = perXprop.FechadeRegistro;
      FechaAsociación=FechaAsociación.substring(0,10);
      var FechaDesasociación = perXprop.FechaDesasociación;
      var tabla = "<tr><td> ";
      tabla += Propietario + "</td><td>" + Propiedad + "</td><td>" + FechaAsociación + "</td>"
      var boton = " <input class=\"buttons\" type=\"submit\" id=\"addBtn\" value=\" Editar \" onclick=\"edit(\'"+ Propietario +"\'," + Propiedad +",\'"+ FechaAsociación + "\',\'" + FechaDesasociación +"\');\" >"
      var boton2 = " <input class=\"buttons\" type=\"submit\" id=\"addBtn\" value=\" Desasociar \" onclick=\"desasoc(\'"+ Propietario +"\'," + Propiedad +",\'"+ FechaAsociación + "\',\'" + FechaDesasociación +"\');\" >"
      //se debe cambiar el otro boton
      if (valor==1)
        tabla+= "<td>"+ boton + boton2 + "</td></tr>"
      else
        boton2 = " <input class=\"buttons\" type=\"submit\" id=\"addBtn\" value=\" Eliminar \" onclick=\"del(\'"+ Propietario +"\'," + Propiedad +"\');\" >"
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
  location.replace('./listaUsersXProp.html?uss='+uss+"&ip="+ip+"&opcion="+value);
  
}

function edit(nombre,lote,fechaI,fechaF){
  let url = './UserXpropEdit.html?add=0'
  var opcion = (new URL(location.href)).searchParams.get('opcion')
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip')
  url+='&uss='+uss
  url+='&ip='+ip
  url+='&nombre='+nombre
  url+='&lote='+lote
  url+='&fechaI='+fechaI
  url+='&opcion='+opcion
  if(fechaF==undefined){
    url+='&fechaF='+'null'
  }else{
    url+='&fechaF='+fechaF
  }  
  location.replace(url);
}

function del(nombre,lote){  
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip')
  var url = "http://localhost:8000/DeleteUsuarioXPropiedad"
  body = {
    "user": nombre,
    "lote": lote,
    "uss": uss,
    "ip": ip
  }
  const options = {
    method: "post",
    headers: {"Content-Type": "application/json"},
    body: JSON.stringify(body)
  };
  fetch(url, options).then(response => response.json())
  .then(response => {
    if(response == 5200){
      alert("Se eliminó la relación")
      location.replace('./listaUsersXProp.html?uss='+uss+"&ip="+ip);
    }else{
      alert("No se pudo eliminar la relación")
    }
  }).catch(e => {
      console.log(e);
  });
}
  



function desasoc (id,lote){
  var url = "http://localhost:8000/UpdateUsuarioXPropiedad"
  var d = new Date();

  var month = d.getMonth()+1;
  var day = d.getDate();

  var fecha = d.getFullYear() + '-' +
      (month<10 ? '0' : '') + month + '-' +
      (day<10 ? '0' : '') + day;  
  var uss = (new URL(location.href)).searchParams.get('ip')
  var ip = (new URL(location.href)).searchParams.get('ip')
  const body={
    oldusr:id,
    oldlote: lote.toString(),
    iden: id,
    lote:lote.toString(),
    fecha: fecha,
    asoc:0,
    uss: uss,
    ip: ip,
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
        window.alert("El tipo de propiedad no existe");
        return
      }      
      if(response == 5400){
        window.alert("Error al actualizar la propiedad");
        return
      }
      if(response == 5200){
        window.alert("Propiedad actualizada con exito");
        return
      }else {
        window.alert("Ocurrio un error al actualizar los datos");
      }
    }
    ).catch(e => {
      console.log(e);
    });
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
