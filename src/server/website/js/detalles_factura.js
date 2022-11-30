$( document ).ready(function() {
    var lote = (new URL(location.href)).searchParams.get('lote')   
    
    const options = {
      method: "get",
      headers: {"Content-Type": "application/json"},
    };
    console.log(options)
    var url = "http://localhost:8000/ReadFacturaPendientePlanArregloPagoPropiedadIn?lote="+lote
    fetch(url, options).then(response => response.json())
    .then(response => {
      $("#tableBody > tbody").empty();
      for (var i = 0; i < response[1].length; i++) {
        var detalle = response[1][i];      
        console.log(detalle)
        
        var ConceptoCobro = detalle.ConceptoCobro
        var Asociacion = detalle.Asociacion.substring(0,10);
        var Desasociacion = detalle.Desasociacion;        
        var PeriodoMontoCC = detalle.PeriodoMontoCC;
        var TipoMontoCC = detalle.TipoMontoCC ;
        var TipoConceptoCobro = detalle.TipoConceptoCobro ;
        var MontoConceptoCobro = detalle.MontoConceptoCobro ;
        var tabla = "<tr><td> ";
        var idFact = detalle.IDFactura;
        var boton = "<button type='button' class='btn btn-primary' onclick='detalles("+ lote + "," + idFact +")'>Ver</button>";
        tabla +=  FechadeFactura + "</td><td>" + FechaVencimientoFactura + "</td><td>" + Subtotal + "</td><td>" + Morosidades + "</td><td>" + Total +"</td><td>" + boton + "</td></tr>"; 
        $("#tablaItems ").append(tabla);
      }}).catch(e => {
        console.log(e);
      });
  });


function ret() {
    var uss = (new URL(location.href)).searchParams.get('uss')
    var ip = (new URL(location.href)).searchParams.get('ip')
    var lote = (new URL(location.href)).searchParams.get('lote')
    var opcion = parseInt((new URL(location.href)).searchParams.get('opcion'))
    
    if(opcion == 0){
        location.replace('./pagar_facturas_propiedad_NoAdmin.html?uss='+uss+"&ip="+ip + "&lote="+lote);
    }
    if(opcion == 1){
        location.replace('./facturas_propiedad_NoAdmin.html?uss='+uss+"&ip="+ip + "&lote="+lote);
    }
    if(opcion == 2){
        location.replace('./facturas_pendiente_AP.html?uss='+uss+"&ip="+ip + "&lote="+lote);
    }
    if(opcion == 3){
        location.replace('./acturas_pagadas_AP.html?uss='+uss+"&ip="+ip + "&lote="+lote);
    }    
  }