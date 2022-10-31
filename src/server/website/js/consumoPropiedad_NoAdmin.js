$( document ).ready(function() {
    var lote = (new URL(location.href)).searchParams.get('lote')
    console.log(lote)
    const $select = $("#cantFact")
    
    const options = {
      method: "get",
      headers: {"Content-Type": "application/json"},
    };
    console.log(options)
    var url = "http://localhost:8000/ReadMovimientoConsumoAgua?lote="+lote
    fetch(url, options).then(response => response.json())
    .then(response => {
      $("#tableBody > tbody").empty();
      for (var i = 0; i < response.length; i++) {
        var consumo = response [i];      
        var fecha = consumo.Fecha.substring(0,10);
        var tipo = consumo.Tipo;
        var saldo = consumo.Saldo
        var cons = consumo.Consumo;        
        var tabla = "<tr><td> ";
        tabla += fecha + "</td><td>" + tipo + "</td><td>" + cons + "</td><td>" + saldo  + "</td></tr>"; 
       
        $("#tablaItems ").append(tabla);
      }}).catch(e => {
        console.log(e);
      });
  });

function ret(){
    var uss = (new URL(location.href)).searchParams.get('uss')
    var ip = (new URL(location.href)).searchParams.get('ip') 
    location.replace('./propiedades_usuarioNoAdmin.html?uss='+uss+"&ip="+ip);
}
function cerrar(){
    location.replace('./index.html');
}