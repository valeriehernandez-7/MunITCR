function propPropi() {
  var user = ""// (new URL(location.href)).searchParams.get('user')
  location.replace(' ./propPropi.html?user='+user);
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
function ret() {
  location.replace(' ./AdminOptions.html');
}
function cerrar(){
  location.replace('./index.html');
}
