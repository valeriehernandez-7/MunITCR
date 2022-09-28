function finca(){
  var finca = $("#finca").val();
  console.log(finca)
}

function ret() {
  var user = ''// (new URL(location.href)).searchParams.get('user')
  location.replace(' ./Consulta.html?user='+user);
}
function cerrar(){
  location.replace('./index.html');
}
