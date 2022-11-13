$( document ).ready(function() {
    var lote = (new URL(location.href)).searchParams.get('lote')
    console.log(lote)
    const $select = $("#cantFact")
    
    const options = {
      method: "get",
      headers: {"Content-Type": "application/json"},
    };
    console.log(options)
    var url = "http://localhost:8000/ReadFacturaPendientePropiedadIn?lote="+lote+"&cant=0"
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
        tabla += fecha + "</td><td>" + fechaV + "</td><td>" + sub + "</td><td>" + moro + "</td><td>" + total + "</td></tr>"; 
       
        $("#tablaItems ").append(tabla);
      }}).catch(e => {
        console.log(e);
      });
    
    const $select2 = $("#metodoPago")  
    const options2 = {
      method: "get",
      headers: {"Content-Type": "application/json"},
    };
    console.log(options2)
    var url = "http://localhost:8000/ReadMedioPago"
    fetch(url, options2).then(response => response.json())
    .then(response => {
      for (var i = 0; i < response.length; i++) {
        $select2.append($("<option>", {
          value: response[i].nombre,
          text: response[i].Nombre
        }))
        
      }}).catch(e => {
        console.log(e);
      });
  });
function add(){
    var uss = (new URL(location.href)).searchParams.get('uss')
    var ip = (new URL(location.href)).searchParams.get('ip') 
    location.replace('./UsersXprop.html?uss='+uss+"&ip="+ip);
}


function pagar(){
  var texto="Seguro que desea pagar las facturas:\n";
  var cant = document.getElementById("cantFact").value;
  var lote = (new URL(location.href)).searchParams.get('lote')
  console.log("cant ", cant)
  if (cant == 0){
    return
  }
  const options2 = {
    method: "get",
    headers: {"Content-Type": "application/json"},
  };
  
  var url = "http://localhost:8000/ReadFacturaPendientePropiedadIn?lote="+lote+"&cant="+cant
  fetch(url, options2).then(response => response.json())
  .then(response => { 
    for (var i = 0; i < response.length; i++) {
      
      var factura = response [i];      
      var fecha = factura.Fecha.substring(0,10);
      var fechaV = factura.FechaVencimiento.substring(0,10);
      var total = factura.Total
      texto += "Del "+fecha+" que vence el "+fechaV+" con por un valor de: " +total+"\n";           
      }
      if (confirm(texto) == true) {
        var url = "http://localhost:8000/Pago"
        var cant = document.getElementById("cantFact").value;
        if (cant == 0){
          alert("Debe pagar al menos 1 factura")
          return
        }
        var medio = document.getElementById("metodoPago").value;
        var lote = (new URL(location.href)).searchParams.get('lote')
        const body={
          lote:lote.toString(),
          cant : cant,
          medio : medio
        }
        const options = {
        method: "post",
        body: JSON.stringify(body),
        headers: {"Content-Type": "application/json"},
        };
        fetch(url, options).then(response => response.json())
        .then(response => {    
          console.log(response)
          if(response == 5200){
            window.alert("Se pagaron: "+cant+" facturas")
            var uss = (new URL(location.href)).searchParams.get('uss')
            var ip = (new URL(location.href)).searchParams.get('ip')
            var lote = (new URL(location.href)).searchParams.get('lote')
            location.replace('./pagar_facturas_propiedad_NoAdmin.html?uss='+uss+"&ip="+ip+"&lote="+lote);
            return
          }else {
            window.alert("Ocurrio un error al pagar las facturas");
          }
          
          }
        ).catch(e => {
            console.log(e);
          });
      }

    }).catch(e => {
      console.log(e);
    });
  
  
  
}
function ret(){
    var uss = (new URL(location.href)).searchParams.get('uss')
    var ip = (new URL(location.href)).searchParams.get('ip') 
    location.replace('./propiedades_usuarioNoAdmin.html?uss='+uss+"&ip="+ip);
}
function cerrar(){
    location.replace('./index.html');
}
  