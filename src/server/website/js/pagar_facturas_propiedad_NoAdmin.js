$( document ).ready(function() {
    var lote = (new URL(location.href)).searchParams.get('lote')
    console.log(lote)
    const $select = $("#cantFact")
    
    const options = {
      method: "get",
      headers: {"Content-Type": "application/json"},
    };
    console.log(options)
    var url = "http://localhost:8000/ReadFacturaPendientePropiedadIn?lote="+lote
    fetch(url, options).then(response => response.json())
    .then(response => {
      $("#tableBody > tbody").empty();
      for (var i = 0; i < response.length; i++) {
        $select.append($("<option>", {
          value: i+1,
          text: i+1
        }))
        var factura = response [i];      
        var fecha = factura.Fecha.substring(0,10);
        var fechaV = factura.FechaVencimiento.substring(0,10);
        var moro = factura.Morosidades;
        var sub = factura.Subtotal;
        var total = factura.Total
        var tabla = "<tr><td> ";
        tabla += fecha + "</td><td>" + fechaV + "</td><td>" + moro + "</td><td>" + sub + "</td><td>" + total + "</td></tr>"; 
       
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
    location.replace('./propiedades_usuarioNoAdmin.html?uss='+uss+"&ip="+ip);
}
function cerrar(){
    location.replace('./index.html');
}
  