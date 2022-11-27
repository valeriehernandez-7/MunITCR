function cant(){
  lote = document.getElementById("propiedLote").value;
  if(lote==""){
    window.alert("Debe ingresar un lote");
    return
  }
  var url = "http://localhost:8000/ReadTasasInteresSolictudAPIn?lote="+lote
  const options = {
    method: "get",
    headers: {"Content-Type": "application/json"},
  };
  fetch(url, options).then(response => response.json())
  .then(response => {
    console.log(response)
    table = $("#tablePlans ")
    $("tablePlansBody").remove()
    for (var i = 0; i < response.length; i++) {
      var TI = response [i];      
      var plazo = TI.Plazo ;
      var tasa = TI.Tasa;
      var cuota = TI.Cuota ;    
      if (cuota == null){
        window.alert("No hay planes de pago disponibles para este lote");
        return
      }  
      var fin = TI.FechaFin.substring(0,10);
      
      var tabla = "<tr><td> ";
      tabla += plazo + "</td><td>" + tasa + "</td><td>" + cuota + "</td>" 
      var boton = " <input class=\"buttons\" type=\"submit\" id=\"addBtn\" value=\" Solicar \" onclick=\"solicitar("+ plazo +"," + tasa +","+ cuota + ",\'" + fin+"\');\" >"
      
      tabla+= "<td>"+ boton + "</td></tr>"
      table.append(tabla);
    }
    }
    ).catch(e => {
      console.log(e);
    });
    url = "http://localhost:8000/ReadFacturasParaAPIn?lote="+lote
    const options2 = {
      method: "get",
      headers: {"Content-Type": "application/json"},
    };
    fetch(url, options2).then(response => response.json())
    .then(response => {
      console.log(response)
      table = $("#tableBills ")
      $("tableBillsBody").remove()
      for (var i = 0; i < response.length; i++) {
        var facturas = response [i];      
        var Fecha = facturas.Fecha ;
        var Subtotal = facturas.Subtotal;
        var Morosidades = facturas.Morosidades;
        var Total = facturas.Total;

        var fin = facturas.FechaVencimiento.substring(0,10);
        
        var tabla = "<tr><td> ";
        tabla += Fecha + "</td><td>" + fin + "</td><td>" + Subtotal + "</td><td>" + Morosidades + "</td><td>"+ Total +"</td>" 
        tabla+= "</tr>"
        table.append(tabla);
      }}
      ).catch(e => {
        console.log(e);
      });
}

function solicitar(plazo,tasa,cuota,fin){
  total = cuota*plazo;
  console.log(plazo,tasa,cuota,fin,total)
  
}
function ret(){
    var uss = (new URL(location.href)).searchParams.get('uss')
    var ip = (new URL(location.href)).searchParams.get('ip') 
    location.replace('./Consulta.html?uss='+uss+"&ip="+ip);
  }
function cerrar(){
    location.replace('./index.html');
}