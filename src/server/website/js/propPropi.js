function nomb(){
   var nombre = $("#desc").val();
   console.log(nombre)
}

function ident(){
  var ident = $("#cant").val();
  console.log(ident)
}
function ret() {
  var user = ''// (new URL(location.href)).searchParams.get('user')
  location.replace(' ./Consulta.html?user='+user);
}
function cerrar(){
  location.replace('./index.html');
}
