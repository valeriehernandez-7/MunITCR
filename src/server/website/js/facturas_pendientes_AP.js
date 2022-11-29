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
      for (var i = 0; i < response.length; i++) {
        var factura = response [i];      
        console.log(factura)
        
        var FechadeFactura = factura.Fecha.substring(0,10);
        var FechaVencimientoFactura = factura.FechaVencimiento.substring(0,10);
        var Subtotal = factura.Subtotal;
        var Morosidades = factura.Morosidades;
        var Total = factura.Total;
        var tabla = "<tr><td> ";
        tabla +=  FechadeFactura + "</td><td>" + FechaVencimientoFactura + "</td><td>" + Subtotal + "</td><td>" + Morosidades + "</td><td>" + Total + "</td></tr>"; 
        $("#tablaItems ").append(tabla);
      }}).catch(e => {
        console.log(e);
      });
  });
function add(){
    var uss = (new URL(location.href)).searchParams.get('uss')
    var ip = (new URL(location.href)).searchParams.get('ip') 
    location.replace('./UsersXprop.html?uss='+uss+"&ip="+ip);
  }
function ret(){
    var uss = (new URL(location.href)).searchParams.get('uss')
    var ip = (new URL(location.href)).searchParams.get('ip')     
    var lote = (new URL(location.href)).searchParams.get('lote')
    location.replace('./planArregloPago_NoAdmin.html?uss='+uss+"&ip="+ip+"&lote="+lote);
}
function cerrar(){
    location.replace('./index.html');
}
  