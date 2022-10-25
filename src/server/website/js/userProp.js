function users(){
  var lote = $("#user").val();
  console.log(user)
  const body={
    lote: lote
  }
  const options = {
    method: "post",
    body: JSON.stringify(body),
    headers: {"Content-Type": "application/json"},
  };
  console.log(options)
  var url = "http://localhost:8000/ReadUsuarioXPropiedadIn"
  fetch(url, options).then(response => response.json())
  .then(response => {
    console.log(response)
    $("#tableBody > tbody").empty();
    for (var i = 0; i < response.length; i++) {
      var persona = response [i];      
      var identificacion = persona.Persona ;
      var usuario = persona.Usuario;
      var pass = persona.Contraseña ;      
      var tipoUser = persona.TipodeUsuario;
      if (tipoUser== true ){
        tipoUser = 'Administrador' 
      }else{
        tipoUser =  'Regular'
      }
      var tabla = "<tr><td> ";
      tabla += identificacion + "</td><td>" + usuario + "</td><td>" + pass + "</td><td>" + tipoUser 
      
      tabla+= "</td></tr>"
      $("#tablaItems ").append(tabla);
    }}).catch(e => {
      console.log(e);
    });
}

function ret() {
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip')
  location.replace('./Consulta.html?uss='+uss+"&ip="+ip);
}
function cerrar(){
  location.replace('./index.html');
}
