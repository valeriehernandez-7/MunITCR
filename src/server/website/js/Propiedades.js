
$(document).ready(function(){
    var add = (new URL(location.href)).searchParams.get('add')
    if(add== "0"){
      var uso = (new URL(location.href)).searchParams.get('uso')
      var zona = (new URL(location.href)).searchParams.get('zona')
      var user = (new URL(location.href)).searchParams.get('user')
      var lote = (new URL(location.href)).searchParams.get('lote')
      var m2 = (new URL(location.href)).searchParams.get('m2')
      var valorFiscal = (new URL(location.href)).searchParams.get('valorFiscal')
      var registro = (new URL(location.href)).searchParams.get('registro')
      var activo = (new URL(location.href)).searchParams.get('activo')
      document.getElementById('idUser').value =user;
      document.getElementById('idType').value =uso;
      document.getElementById('idZone').value =zona;
      document.getElementById('lote').value =lote;
      document.getElementById('squareM').value =m2;
      document.getElementById('price').value =valorFiscal;
      document.getElementById('date').value =registro;
    }
})


function ret() {
  var user = ''// (new URL(location.href)).searchParams.get('user')
  location.replace(' ./listaPropiedades.html?user='+user);
}
function cerrar(){
  location.replace('./index.html');
}
