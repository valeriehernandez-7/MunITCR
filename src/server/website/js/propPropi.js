function nomb(){
   var nombre = $("#desc").val();
   console.log(nombre)
}

function ident(){
  var nombre = $("#desc").val();
  console.log(nombre)
}
function ret() {
  var user = ''// (new URL(location.href)).searchParams.get('user')
  location.replace(' ./listaPerXProp.html?user='+user);
}
function cerrar(){
  location.replace('./index.html');
}
