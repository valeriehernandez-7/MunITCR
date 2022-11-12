$(document).ready(function(){
    console.log('cargando')

  var url2 = "http://localhost:8000/ReadEntityType"
  const $select2 = $("#entityType")
  const options2 = {
    method: "get",
    headers: {"Content-Type": "application/json"},
    };
    fetch(url2, options2).then(response => response.json())
    .then(response => {
      console.log(response);
      for (var i = 0; i < response.length; i++) {
        valor=response[i].Name;
        $select2.append($("<option>", {
          value: valor,
          text: valor
        }));
      }}).catch(e => {
        console.log(e);
      });

      var url2 = "http://localhost:8000/ReadEventType"
  const $select = $("#eventType")
  const options3 = {
    method: "get",
    headers: {"Content-Type": "application/json"},
    };
    fetch(url2, options3).then(response => response.json())
    .then(response => {
      console.log(response);
      for (var i = 0; i < response.length; i++) {
        valor=response[i].Name;
        $select.append($("<option>", {
          value: valor,
          text: valor
        }));
      }}).catch(e => {
        console.log(e);
      });
      
    

  var filter = (new URL(location.href)).searchParams.get('filter')
  if(filter != "1"){
    var url = "http://localhost:8000/ReadEventLog"
    const options = {
      method: "get",
      headers: {"Content-Type": "application/json"}
    };
    fetch(url, options).then(response => response.json())
    .then(response => {
      $("#tableBody > tbody").empty();
      //console.log(historyJson.IDPropiedad);
      for (var i = 0; i < response.length; i++) {
        var resp = response [i];      
        var tipo = resp.TipodeEvento;
        var Entidad = resp.Entidad;
        var IDEntidad = resp.IDEntidad;
        //texto bonito de la bitacora
        var Hist = resp.Historial
        Historial = ""
        if(Hist != null){       
          Hist = Hist.substring(1,Hist.length-1)
          historyJson = JSON.parse(Hist)
          var keys = Object.keys(historyJson);
          Historial += "<p>"
          keys.forEach(element => Historial += element+": " + historyJson[element]+ "  <br>");
          Historial += "</p>"
        }
        var Act = resp.Actualizacion 
        Actualizacion = ""
        Act = Act.substring(1,Act.length-1)
        ActJson = JSON.parse(Act)
        var keys = Object.keys(ActJson);
        Actualizacion += "<p>"
        keys.forEach(element => Actualizacion += element+": " + ActJson[element]+ "  <br>");
        Actualizacion += "</p>"



        var Autor = resp.Autor;
        var IP = resp.IP;
        var Fecha = resp.Fecha.substring(0,10);        
                
        var tabla = "<tr id=\"row1\" ><td> ";
        tabla += tipo + "</td><td>" + Entidad + "</td><td>" + IDEntidad + "</td><td width=\"30%\">" + Historial + "</td><td width=\"30%\">" + Actualizacion + "</td><td>" + Autor + "</td><td>" + IP + "</td><td>" + Fecha+ "</td>"
         //se debe cambiar el otro boton       
        $("#tablaItems ").append(tabla);
      }
  
    }).catch(e => {
        console.log(e);
    });
  } else{
    var url = "http://localhost:8000/ReadEventLogEventInEntityInFechaIn"
    var tipo = (new URL(location.href)).searchParams.get('tipo')
    var entidad = (new URL(location.href)).searchParams.get('entidad')
    var fechai = (new URL(location.href)).searchParams.get('fechai')
    var fechaf = (new URL(location.href)).searchParams.get('fechaf')
    body = {
      "tipo": tipo,
      "entidad": entidad,
      "fechaI": fechai,
      "fechaF": fechaf
    }
    const options = { 
      method: "post",
      headers: {"Content-Type": "application/json"},
      body: JSON.stringify(body)
    };
    fetch(url, options).then(response => response.json())
    .then(response => {
      $("#tableBody > tbody").empty();
      //console.log(historyJson.IDPropiedad);
      for (var i = 0; i < response.length; i++) {
        var resp = response [i];      
        var tipo = resp.TipodeEvento;
        var Entidad = resp.Entidad;
        var IDEntidad = resp.IDEntidad;
        //texto bonito de la bitacora
        var Hist = resp.Historial
        Historial = ""
        if(Hist != null){       
          Hist = Hist.substring(1,Hist.length-1)
          historyJson = JSON.parse(Hist)
          var keys = Object.keys(historyJson);
          Historial += "<p>"
          keys.forEach(element => Historial += element+": " + historyJson[element]+ "  <br>");
          Historial += "</p>"
        }
        var Act = resp.Actualizacion 
        Actualizacion = ""
        Act = Act.substring(1,Act.length-1)
        ActJson = JSON.parse(Act)
        var keys = Object.keys(ActJson);
        Actualizacion += "<p>"
        keys.forEach(element => Actualizacion += element+": " + ActJson[element]+ "  <br>");
        Actualizacion += "</p>"



        var Autor = resp.Autor;
        var IP = resp.IP;
        var Fecha = resp.Fecha.substring(0,10);        
                
        var tabla = "<tr id=\"row1\" ><td> ";
        tabla += tipo + "</td><td>" + Entidad + "</td><td>" + IDEntidad + "</td><td width=\"30%\">" + Historial + "</td><td width=\"30%\">" + Actualizacion + "</td><td>" + Autor + "</td><td>" + IP + "</td><td>" + Fecha+ "</td>"
         //se debe cambiar el otro boton       
        $("#tablaItems ").append(tabla);
      }
  
    }).catch(e => {
        console.log(e);
    });
  }

  
  })
function filter(){
  console.log($("#tablaItems"));  
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip')
  var tipo = $("#eventType").val();
  var entidad = $("#entityType").val();
  var fechai = $("#date").val();
  var fechaf = $("#date2").val();
  location.replace('./EventLog.html?uss='+uss+"&ip="+ip+"&filter=1"+ "&tipo="+tipo+"&entidad="+entidad+"&fechai="+fechai+"&fechaf="+fechaf);
}
function noFilter(){
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip')
  location.replace('./EventLog.html?uss='+uss+"&ip="+ip);
}
function ret(){
    var uss = (new URL(location.href)).searchParams.get('uss')
    var ip = (new URL(location.href)).searchParams.get('ip')
    location.replace('./AdminOptions.html?uss='+uss+"&ip="+ip);
  }
  function cerrar(){
    location.replace('./index.html');
  }