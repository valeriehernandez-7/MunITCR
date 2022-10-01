$(document).ready(function(){
    var add = (new URL(location.href)).searchParams.get('add')
    if(add== "0"){
      var idPersona = (new URL(location.href)).searchParams.get('idUser')
      var user = (new URL(location.href)).searchParams.get('user')
      var pass = (new URL(location.href)).searchParams.get('password')
      if ((new URL(location.href)).searchParams.get('admin') == 'Regular'){
          var admin = 1
      }else{
        admin=0
      }

      document.getElementById('idUser').value =idPersona;
      document.getElementById('user').value =user;
      document.getElementById('password').value =pass;
      if(admin==1){
          document.getElementById('Admin').checked=true
      }

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
