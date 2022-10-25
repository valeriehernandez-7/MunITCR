function finca(){
  var finca = $("#finca").val();
  const body={
    lote: finca
  }
  console.log(body)
  const options = {
    method: "post",
    body: JSON.stringify(body),
    headers: {"Content-Type": "application/json"},
  };
  console.log(options)
  var url = "http://localhost:8000/ReadPropiedadInPersona"
  fetch(url, options).then(response => response.json())
  .then(response => {
    console.log(response)
    $("#tableBody > tbody").empty();
    for (var i = 0; i < response.length; i++) {
      var persona = response [i];      
    var nombre = persona.Nombre;
    var IDKind = persona.TipodeIdentificación;
    var ID = persona.Identificación ;
    var tel1 = persona.Teléfono1;
    var tel2 = persona.Teléfono2;
    var email = persona.CorreoElectrónico;
    var tabla = "<tr><td> ";
    tabla += nombre + "</td><td>" + ID + "</td><td>" + IDKind + "</td><td>" + tel1 + "</td><td>" + tel2 + "</td><td>" + email + "</td>"
    tabla+=  "</td></tr>"
    $("#tablaItems ").append(tabla);
    }}).catch(e => {
      console. log(e);
    });

}

function ret() {
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip') 
  location.replace(' ./Consulta.html?uss='+uss+"&ip="+ip);
}
function cerrar(){
  location.replace('./index.html');
}
