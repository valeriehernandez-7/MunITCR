function add(){
    var uss = (new URL(location.href)).searchParams.get('uss')
    var ip = (new URL(location.href)).searchParams.get('ip') 
    location.replace('./UsersXprop.html?uss='+uss+"&ip="+ip);
}
function ret(){
var uss = (new URL(location.href)).searchParams.get('uss')
var ip = (new URL(location.href)).searchParams.get('ip') 
location.replace('./facturas_propiedad_NoAdmin.html?uss='+uss+"&ip="+ip);
}
function cerrar(){
location.replace('./index.html');
}
  