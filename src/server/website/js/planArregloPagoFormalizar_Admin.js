$(document).ready(function(){

    plazo = (new URL(location.href)).searchParams.get('plazo')
    cuota = (new URL(location.href)).searchParams.get('cuota')
    tasa = (new URL(location.href)).searchParams.get('tasa')
    fecha = (new URL(location.href)).searchParams.get('fecha')
    fin = (new URL(location.href)).searchParams.get('fin')
    total = (new URL(location.href)).searchParams.get('total')
    lote = (new URL(location.href)).searchParams.get('lote')
    table2 = $("#tablePlans ")
    var tabla = "<tr><td> ";
        tabla += fecha + "</td><td>" + fin + "</td><td>" + plazo + "</td><td>" + tasa + "</td><td>"+ total +"</td>" 
        tabla+= "</tr>"
        table2.append(tabla);
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
        var Fecha = facturas.Fecha.substring(0,10); ;
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

  
  })