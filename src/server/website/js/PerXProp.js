$(document).ready(function(){
    var add = (new URL(location.href)).searchParams.get('add')
    if(add== "0"){
      var idPer = (new URL(location.href)).searchParams.get('nombre')
      var idProp = (new URL(location.href)).searchParams.get('lote')
      nombre = document.getElementById('nombre')
      nombre.value = idPer
      lote = document.getElementById('lote')
      lote.value =idProp
    }
})

function ret() {
  var user = ''// (new URL(location.href)).searchParams.get('user')
  location.replace(' ./listaPerXProp.html?user='+user)
}
function cerrar(){
  location.replace('./index.html');
}
