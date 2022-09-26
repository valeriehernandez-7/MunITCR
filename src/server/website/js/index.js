function login() {
  var user = ""// (new URL(location.href)).searchParams.get('user')
  location.replace(' ./listaUsuarios.html?user='+user);
}
function loginAdmin() {
  var user = ""// (new URL(location.href)).searchParams.get('user')
  location.replace(' ./AdminOptions.html?user='+user);
}
