
$(document).ready(function(){
    var add = (new URL(location.href)).searchParams.get('add')
    if(add== "0"){
      var nombre = (new URL(location.href)).searchParams.get('nombre')
      var id = (new URL(location.href)).searchParams.get('id')
      var tipo = (new URL(location.href)).searchParams.get('tipo')
      var tel = (new URL(location.href)).searchParams.get('tel')
      var tel2 = (new URL(location.href)).searchParams.get('tel2')
      var email = (new URL(location.href)).searchParams.get('email')
      console.log(nombre)
      document.getElementById('name').value =nombre;
      document.getElementById('idNumber').value =id;
      //document.getElementById('TipoID').value =tipo;
      document.getElementById('phone1').value =tel;
      document.getElementById('phone2').value =tel2;
      document.getElementById('email').value =email;
    }

})


function ret() {
  var user = ''// (new URL(location.href)).searchParams.get('user')
  location.replace(' ./listaPersona.html?user='+user);
}
function cerrar(){
  location.replace('./index.html');
}
