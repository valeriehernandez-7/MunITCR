$( document ).ready(function() {
    var lote = (new URL(location.href)).searchParams.get('lote')   
    
    const options = {
      method: "get",
      headers: {"Content-Type": "application/json"},
    };
    console.log(options)
    var url = "http://localhost:8000/ReadFacturaPagadaPropiedadIn?lote="+lote
    fetch(url, options).then(response => response.json())
    .then(response => {
      $("#tableBody > tbody").empty();
      for (var i = 0; i < response.length; i++) {
        var factura = response [i];      
        var fecha = factura.FechadePago.substring(0,10);
        var comprobante = factura.Comprobante;
        if (comprobante == null){
          comprobante = "No disponible"
        }
        var MediodePago = factura.MediodePago;
        var FechadeFactura = factura.FechadeFactura.substring(0,10);
        var FechaVencimientoFactura = factura.FechaVencimientoFactura.substring(0,10);
        var Subtotal = factura.Subtotal;
        var Morosidades = factura.Morosidades;
        var Total = factura.Total;
        var idFact = factura.IDFactura;
        var boton = "<button type='button' class='btn btn-primary' onclick='detalles("+ lote + "," + idFact +")'>Ver</button>";

        var tabla = "<tr><td> ";
        tabla += fecha + "</td><td>" + comprobante + "</td><td>" + MediodePago + "</td><td>" + FechadeFactura + "</td><td>" + FechaVencimientoFactura + "</td><td>" + Subtotal + "</td><td>" + Morosidades + "</td><td>" + Total + "</td><td>" +boton+ "</td></tr>"; 
        $("#tablaItems ").append(tabla);
      }}).catch(e => {
        console.log(e);
      });
  });

function detalles(lote,idFact){
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip') 
  location.replace('./detalles_factura.html?uss='+uss+"&ip="+ip+"&lote="+lote+"&idFact="+idFact+"&opcion=1");  
}



function add(){
    var uss = (new URL(location.href)).searchParams.get('uss')
    var ip = (new URL(location.href)).searchParams.get('ip') 
    location.replace('./UsersXprop.html?uss='+uss+"&ip="+ip);
  }
function ret(){
    var uss = (new URL(location.href)).searchParams.get('uss')
    var ip = (new URL(location.href)).searchParams.get('ip') 
    location.replace('./propiedades_usuarioNoAdmin.html?uss='+uss+"&ip="+ip);
}
function cerrar(){
    location.replace('./index.html');
}
  