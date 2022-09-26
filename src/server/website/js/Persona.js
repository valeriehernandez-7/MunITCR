
$(document).ready(function(){
    var add = (new URL(location.href)).searchParams.get('add')
    if(add== "0"){
      document.getElementById('addBtn').disabled = true;
    }else{
      document.getElementById('delBtn').disabled = true;
      document.getElementById('upBtn').disabled = true;
    }
    var nombre = (new URL(location.href)).searchParams.get('nombre')
    var id = (new URL(location.href)).searchParams.get('id')
    var tipo = (new URL(location.href)).searchParams.get('tipo')
    var tel = (new URL(location.href)).searchParams.get('tel')
    var tel2 = (new URL(location.href)).searchParams.get('tel2')
    var email = (new URL(location.href)).searchParams.get('email')
    var activo = (new URL(location.href)).searchParams.get('activo')
    console.log(nombre)
    document.getElementById('name').value =nombre;
    document.getElementById('idNumber').value =id;
    document.getElementById('idType').value =tipo;
    document.getElementById('phone1').value =tel;
    document.getElementById('phone2').value =tel2;
    document.getElementById('email').value =email;
    if(activo=='si'){
        document.getElementById('active').checked=true
    }
})


function ret() {
  var user = ''// (new URL(location.href)).searchParams.get('user')
  location.replace(' ./listaPersona.html?user='+user);
}
function cerrar(){
  location.replace('./index.html');
}
