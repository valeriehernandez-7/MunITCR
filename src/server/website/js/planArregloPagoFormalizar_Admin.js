$(document).ready(function(){

  lote  = (new URL(location.href)).searchParams.get('lote')
  plazo = (new URL(location.href)).searchParams.get('plazo')
  cuota = (new URL(location.href)).searchParams.get('cuota')
  saldo = (new URL(location.href)).searchParams.get('saldo')
  interes = (new URL(location.href)).searchParams.get('intereses')
  tasa = (new URL(location.href)).searchParams.get('tasa')
  amortizacion = (new URL(location.href)).searchParams.get('amortizacion')
  fecha = (new URL(location.href)).searchParams.get('fecha')
  fin = (new URL(location.href)).searchParams.get('fin')
  table2 = $("#tablePlans ")
  var tabla = "<tr><td> ";
      tabla += fecha + "</td><td>" + fin + "</td><td>" + plazo + "</td><td>" + tasa + "</td><td>"+ saldo +"</td>" 
      tabla+= "</tr>"
      table2.append(tabla);
  url = "http://localhost:8000/ArregloPagoSolicitudFacturas?lote="+lote
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

function formalizar(){
  lote  = (new URL(location.href)).searchParams.get('lote')
  plazo = (new URL(location.href)).searchParams.get('plazo')
  cuota = (new URL(location.href)).searchParams.get('cuota')
  saldo = (new URL(location.href)).searchParams.get('saldo')
  interes = (new URL(location.href)).searchParams.get('intereses')
  amortizacion = (new URL(location.href)).searchParams.get('amortizacion')
  fecha = (new URL(location.href)).searchParams.get('fecha')
  fin = (new URL(location.href)).searchParams.get('fin')
  const body = {
    "lote": lote,
    "plazo": plazo,
    "cuota": cuota,
    "saldo": saldo,
    "interes": interes,
    "amortizacion": amortizacion,
    "fechaForm": fecha,
    "FechaFin": fin
  }
  url = "http://localhost:8000/ArregloPagoFormalizacion"
  
  const options2 = {
    method: "post",
    headers: {"Content-Type": "application/json"},
    body: JSON.stringify(body)
  };
  fetch(url, options2).then(response => response.json())
  .then(response => {
    console.log(response)
    if (response == 5200){
      alert("Se ha formalizado el plan de arreglo de pago")
      ret()     
    }
    else{
      alert("No se ha podido formalizar el plan de arreglo de pago")
    }

    
    }).catch(e => {
      console.log(e);
    });  
}
function ret(){
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip') 
  var url = "./planArregloPago_admin.html?uss="+uss+"&ip="+ip
  location.replace(url);
}
function cerrar(){
  location.replace('./index.html');
}