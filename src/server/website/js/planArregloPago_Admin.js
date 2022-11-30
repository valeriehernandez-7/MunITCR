function cant(){
  lote = document.getElementById("propiedLote").value;
  if(lote==""){
    window.alert("Debe ingresar un lote");
    return
  }
  var url = "http://localhost:8000/ArregloPagoSolicitud?lote="+lote
  const options = {
    method: "get",
    headers: {"Content-Type": "application/json"}
  };
  fetch(url, options).then(response => response.json())
  .then(response => {
    console.log(response)
    table = $("#tablePlans ")
    $("tablePlansBody").remove()
    for (var i = 0; i < response.length; i++) {
      var TI = response [i];
      var plazo = TI.PlazoMeses;
      var tasa = TI.TasaInteresAnual;
      var cuota = TI.Cuota;
        
      if (cuota == null){
        window.alert("No hay planes de pago disponibles para esta propiedad");
        return
      }
      var total = TI.Saldo;
      var intereses = TI.Intereses;
      var amortizacion = TI.Amortizacion;
      var fecha = TI.FechaFormalizacion.substring(0,10);
      var fin = TI.FechaVencimiento.substring(0,10);


      var tabla = "<tr><td> ";
      tabla += plazo + "</td><td>" + tasa + "</td><td>" + cuota + "</td>" 
      var boton = " <input class=\"buttons\" type=\"submit\" id=\"addBtn\" value=\" Solicar \" onclick=\"solicitar("+ plazo +"," + tasa +","+ cuota + ","+ lote +","+ total +","+ intereses +","+ amortizacion +",\'"+ fecha + "\',\'" + fin+"\');\" >"
      
      tabla+= "<td>"+ boton + "</td></tr>"
      table.append(tabla);
    }
    }
    ).catch(e => {
      console.log(e);
    });
    url = "http://localhost:8000/ArregloPagoSolicitudFacturas?lote="+lote
    const options2 = {
      method: "get",
      headers: {"Content-Type": "application/json"}
    }
    fetch(url, options2).then(response => response.json())
    .then(response => {
      if(response.length == 0){
        alert("No se pueden aplicar arreglos de pago a esta propiedad")
        return
      }
      table = $("#tableBills ")
      $("tableBillsBody").remove()
      for (var i = 0; i < response.length; i++) {
        var facturas = response [i];      
        var Fecha = facturas.Fecha.substring(0,10);
        var Subtotal = facturas.Subtotal;
        var Morosidades = facturas.Morosidades;
        var saldo = facturas.Total;

        var fin = facturas.FechaVencimiento.substring(0,10);
        
        var tabla = "<tr><td> ";
        tabla += Fecha + "</td><td>" + fin + "</td><td>" + Subtotal + "</td><td>" + Morosidades + "</td><td>"+ saldo +"</td>" 
        tabla+= "</tr>"
        table.append(tabla);
      }}
      ).catch(e => {
        alert("No se pueden aplicar arreglos de pago a esta propiedad")
        console.log(e);
        return       
      });
}

function solicitar(plazo,tasa,cuota,lote,total,intereses,amortizacion,fecha,fin){
  console.log(plazo,tasa,cuota,fecha,fin,total)
  uss = (new URL(location.href)).searchParams.get('uss')
  ip = (new URL(location.href)).searchParams.get('ip')
  url="./planArregloPagoFormalizar_Admin.html?uss="+uss+"&ip="+ip+"&plazo="+plazo+"&tasa="+tasa+"&cuota="+cuota+"&fecha="+fecha+"&fin="+fin+"&saldo="+total+"&lote="+lote+"&intereses="+intereses+"&amortizacion="+amortizacion
  location.replace(url)
  
}
function ret(){
    var uss = (new URL(location.href)).searchParams.get('uss')
    var ip = (new URL(location.href)).searchParams.get('ip') 
    location.replace('./Consulta.html?uss='+uss+"&ip="+ip);
  }
function cerrar(){
    location.replace('./index.html');
}