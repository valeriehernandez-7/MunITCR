function nomb(){
   var nombre = $("#desc").val();
   console.log(nombre)


   
}

function ident(){
  var ident = $("#cant").val();
  const body={
    ident: ident
  }
  console.log(body)
  const options = {
    method: "post",
    body: JSON.stringify(body),
    headers: {"Content-Type": "application/json"},
    };
  console.log(ident)
  var url = "http://localhost:8000/ReadPropiedadPersonaIn"
  fetch(url, options).then(response => response.json())
  .then(response => {
    console.log(response)
    $("#tableBody > tbody").empty();
    for (var i = 0; i < response.length; i++) {
      var propiedad = response [i];      
      var lote = propiedad.Propiedad;
      var uso = propiedad.UsodePropiedad;
      var zona = propiedad.ZonadePropiedad ;
      var area = propiedad.Territorio;
      var valorFiscal = propiedad.ValorFiscal;
      var fechaRegistro = propiedad.FechadeRegistro;
      fechaRegistro = fechaRegistro.substring(0,10);
      var tabla = "<tr><td> ";
      tabla += uso + "</td><td>" + zona + "</td><td>" + lote + "</td><td>" + area + "</td><td>" + valorFiscal + "</td><td>" + fechaRegistro + "</td>"
      
      tabla+=  "</td></tr>"
      $("#tablaItems ").append(tabla);
    }


    }
    ).catch(e => {
      console.log(e);
    });
}
function ret() {
  var user = ''// (new URL(location.href)).searchParams.get('user')
  location.replace(' ./Consulta.html?user='+user);
}
function cerrar(){
  location.replace('./index.html');
}
