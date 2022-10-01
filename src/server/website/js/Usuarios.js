$(document).ready(function(){
    var add = (new URL(location.href)).searchParams.get('add')
    if(add== "0"){
      console.log('a')
      var nombre = (new URL(location.href)).searchParams.get('nombre')
      var user = (new URL(location.href)).searchParams.get('user')
      var pass = (new URL(location.href)).searchParams.get('password')
      if ((new URL(location.href)).searchParams.get('admin') == 'Regular'){
          var admin = 1
      }

      document.getElementById('nombre').value =nombre;
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
