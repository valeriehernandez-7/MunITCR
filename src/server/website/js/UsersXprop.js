$(document).ready(function(){
    var add = (new URL(location.href)).searchParams.get('add')
    if(add== "0"){
      document.getElementById('addBtn').disabled = true;
    }else{
      document.getElementById('delBtn').disabled = true;
      document.getElementById('upBtn').disabled = true;
    }
    var usuario = (new URL(location.href)).searchParams.get('usuario')
    var lote = (new URL(location.href)).searchParams.get('lote')
    document.getElementById('idUser').value =usuario;
    document.getElementById('lote').value =lote;
})

function ret() {
  var user = ''// (new URL(location.href)).searchParams.get('user')
  location.replace(' ./listaUsersXprop.html?user='+user);
}
function cerrar(){
  location.replace('./index.html');
}
