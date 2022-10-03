function nomb(){
   var nombre = $("#desc").val();
   console.log(nombre)
}

function ident(){
  var ident = $("#cant").val();
  const body={
    ident: ident
  }
  const options = {
    method: "post",
    body: JSON.stringify(body),
    headers: {"Content-Type": "application/json"},
    };
  console.log(ident)
  var url = "http://localhost:8000/ReadPersonaInXPropiedad"
  fetch(url, options).then(response => response.json())
  .then(response => {
      console.log(response);
      if(response == 5404){
        window.alert("El tipo de Identificación no existe");
        return
      }
      if(response == 5406){
        window.alert("Ya existe este lote");
        return
      }
      if(response == 5404){
        window.alert("Tipo de uso de propiedad no registrado");
        return
      }
      if(response == 5400){
        window.alert("Los parametros no deben ser null");
        return
      }
      if(response == 5200){
        window.alert("Propiedad ingresada con exito");
        return
      }else {
        window.alert("Ocurrio un error al ingresar el dato");
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
