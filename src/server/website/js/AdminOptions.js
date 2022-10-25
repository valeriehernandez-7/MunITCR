function usr() {
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip')
  location.replace(' ./listaUsuarios.html?uss='+uss+"&ip="+ip);
}
function people() {
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip')
  location.replace(' ./listaPersona.html?uss='+uss+"&ip="+ip);
}
function property() {
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip')
  location.replace(' ./listaPropiedades.html?uss='+uss+"&ip="+ip);
}
function personXproperty() {
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip')
  location.replace(' ./listaPerXProp.html?uss='+uss+"&ip="+ip);
}
function userXproperty() {
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip')
  location.replace(' ./listaUsersXprop.html?uss='+uss+"&ip="+ip);
}
function consult(){
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip')
  location.replace(' ./Consulta.html?uss='+uss+"&ip="+ip);
}
function ret() {
  location.replace(' ./index.html');
}
function cerrar(){
  location.replace('./index.html');
}
