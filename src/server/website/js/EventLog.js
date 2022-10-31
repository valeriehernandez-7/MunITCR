$(document).ready(function(){
    console.log('cargando')
    
    var url = "http://localhost:8000/ReadEventLog"
    const options = {
      method: "get",
      headers: {"Content-Type": "application/json"},
    };
    fetch(url, options).then(response => response.json())
    .then(response => {
      $("#tableBody > tbody").empty();
      for (var i = 0; i < response.length; i++) {
        console.log(response[i])
        var resp = response [i];      
        var tipo = resp.TipodeEvento;
        var Entidad = resp.Entidad;
        var IDEntidad = resp.IDEntidad;
        var Historial = resp.Historial
        var Actualizacion = resp.Actualizacion 
        var Autor = resp.Autor;
        var IP = resp.IP;
        var Fecha = resp.Fecha.substring(0,10);
        var tabla = "<tr><td> ";
        tabla += tipo + "</td><td>" + Entidad + "</td><td>" + IDEntidad + "</td><td width=\"30%\">" + Historial + "</td><td width=\"30%\">" + Actualizacion + "</td><td>" + Autor + "</td><td>" + IP + "</td><td>" + Fecha+ "</td>"
         //se debe cambiar el otro boton       
        $("#tablaItems ").append(tabla);
      }
  
    }).catch(e => {
        console.log(e);
    });
  
  })

function ret(){
    var uss = (new URL(location.href)).searchParams.get('uss')
    var ip = (new URL(location.href)).searchParams.get('ip')
    location.replace('./AdminOptions.html?uss='+uss+"&ip="+ip);
  }
  function cerrar(){
    location.replace('./index.html');
  }