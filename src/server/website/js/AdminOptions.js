function usr() {
  var user = ""// (new URL(location.href)).searchParams.get('user')
  location.replace(' ./listaUsuarios.html?user='+user);
}
function people() {
  var user = ""// (new URL(location.href)).searchParams.get('user')
  location.replace(' ./listaPersona.html?user='+user);
}
function property() {
  var user = ""// (new URL(location.href)).searchParams.get('user')
  location.replace(' ./listaPropiedades.html?user='+user);
}
function personXproperty() {
  var user = ""// (new URL(location.href)).searchParams.get('user')
  location.replace(' ./listaPerXProp.html?user='+user);
}
function userXproperty() {
  var user = ""// (new URL(location.href)).searchParams.get('user')
  location.replace(' ./listaUsersXprop.html?user='+user);
}
function consult(){
  var user = ""// (new URL(location.href)).searchParams.get('user')
  location.replace(' ./Consulta.html?user='+user);
}
function ret() {
  location.replace(' ./index.html');
}
function cerrar(){
  location.replace('./index.html');
}
