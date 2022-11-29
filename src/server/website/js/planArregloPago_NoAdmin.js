$( document ).ready(function() {  
    var user = (new URL(location.href)).searchParams.get('uss')
    var lote = (new URL(location.href)).searchParams.get('lote') 
    console.log(user)
    const body={
      lote: lote
    }
    console.log(body)
    const options = {
      method: "post",
      body: JSON.stringify(body),
      headers: {"Content-Type": "application/json"},
    };
    console.log(options)
    var url = "http://localhost:8000/ReadPropiedadXCCArregloPagoPropiedadIn"
    fetch(url, options).then(response => response.json())
    .then(response => {
      console.log(response)
      $("#tableBody > tbody").empty();
      for (var i = 0; i < response.length; i++) {
        var ap = response [i];      
        var FormalizacionContrato = ap.FormalizacionContrato;
        var VencimientoContrato = ap.VencimientoContrato;
        var PlazoMeses = ap.PlazoMeses ;
        var TasaInteresAnual = ap.TasaInteresAnual ;
        var MontoDeuda = ap.MontoDeuda;
        var MontoAmortizacion = ap.MontoAmortizacion;
        var MontoCancelado = ap.MontoCancelado;
        var Saldo = ap.Saldo;
        
        var tabla = "<tr><td> ";
        tabla += FormalizacionContrato + "</td><td>" + VencimientoContrato + "</td><td>" + PlazoMeses + "</td><td>" + TasaInteresAnual + "</td><td>" + MontoDeuda + "</td><td>" + MontoAmortizacion + "</td><td>" + MontoCancelado + "</td><td>" + Saldo 
        
        tabla+=  "</td></tr>"
        $("#tablaItems ").append(tabla);
      }}).catch(e => {
        console.log(e);
      });
  });

function ret(){
    var uss = (new URL(location.href)).searchParams.get('uss')
    var ip = (new URL(location.href)).searchParams.get('ip')
    location.replace('./propiedades_usuarioNoAdmin.html?uss='+uss+"&ip="+ip+"&lote="+lote);
}
function cerrar(){
    location.replace('./index.html');
}