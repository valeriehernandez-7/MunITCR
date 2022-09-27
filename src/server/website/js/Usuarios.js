$(document).ready(function(){
    var add = (new URL(location.href)).searchParams.get('add')
    if(add== "0"){
      document.getElementById('addBtn').disabled = true;
    }else{
      document.getElementById('delBtn').disabled = true;
      document.getElementById('upBtn').disabled = true;
    }
    var idPersona = (new URL(location.href)).searchParams.get('idPersona')
    var user = (new URL(location.href)).searchParams.get('user')
    var pass = (new URL(location.href)).searchParams.get('pass')
    var admin = (new URL(location.href)).searchParams.get('admin')
    var activo = (new URL(location.href)).searchParams.get('activo')
    document.getElementById('idUser').value =idPersona;
    document.getElementById('user').value =user;
    document.getElementById('password').value =pass;
    if(admin=='si'){
        document.getElementById('Admin').checked=true
    }
    if(activo=='si'){
        document.getElementById('active').checked=true
    }
})
function showPass() {
  var showPass = document.getElementById("password");
  if (showPass.type === "password") {
      showPass.type = "text";
    } else {
      showPass.type = "password";
    }
}
function ret() {
  var user = ''// (new URL(location.href)).searchParams.get('user')
  location.replace(' ./listaUsuarios.html?user='+user);
}
function cerrar(){
  location.replace('./index.html');
}
