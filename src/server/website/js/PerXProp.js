$(document).ready(function(){
    var add = (new URL(location.href)).searchParams.get('add')
    if(add== "0"){
      document.getElementById('addBtn').disabled = true;
    }else{
      document.getElementById('delBtn').disabled = true;
      document.getElementById('upBtn').disabled = true;
    }
    var idPer = (new URL(location.href)).searchParams.get('idPer')
    var idProp = (new URL(location.href)).searchParams.get('idProb')
    var fechaI = (new URL(location.href)).searchParams.get('fechaI')
    var fechaF = (new URL(location.href)).searchParams.get('fechaF')
    document.getElementById('idPer').value =idPer;
    document.getElementById('idProp').value =idProp;
    document.getElementById('fechaI').value =fechaI;
    document.getElementById('fechaF').value =fechaF;

})

function ret() {
  var user = ''// (new URL(location.href)).searchParams.get('user')
  location.replace(' ./listaPerXProp.html?user='+user);
}
function cerrar(){
  location.replace('./index.html');
}
