$(document).ready(function(){
    var add = (new URL(location.href)).searchParams.get('add')
    if(add== "0"){
      var idPer = (new URL(location.href)).searchParams.get('nombre')
      var idProp = (new URL(location.href)).searchParams.get('lote')
      var fechaI = (new URL(location.href)).searchParams.get('fechaI')
      var fechaF = (new URL(location.href)).searchParams.get('fechaF')
      document.getElementById('nombre').value =idPer;
      document.getElementById('lote').value =idProp;
      document.getElementById('fechaI').value =fechaI;
      document.getElementById('fechaF').value =fechaF;
    }
})

function ret() {
  var user = ''// (new URL(location.href)).searchParams.get('user')
  location.replace(' ./listaPerXProp.html?user='+user);
}
function cerrar(){
  location.replace('./index.html');
}
