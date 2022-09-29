
function login() {
  var user = $("#usuario").val();
  var pass = $("#contrasena").val();
  if (user == "" || pass==""){
      window.alert("Debe ingresar un usuario y contraseña");
      return;
    }
  if(user.includes(";") || pass.includes(";")){
    window.alert("No debe incluir ; en el usuario o la conreaseña");
    return;
    }
  location.replace(' ./propiedades_usuarioNoAdmin.html?usuario='+user);
}
function loginAdmin() {
  var user = $("#usuario").val();
  var pass = $("#contrasena").val();
  if (user == "" || pass==""){
      window.alert("Debe ingresar un usuario y contraseña");
      return;
    }
  if(user.includes(";") || pass.includes(";")){
    window.alert("No debe incluir ; en el usuario o la conreaseña");
    return;
    }
  location.replace(' ./AdminOptions.html?');
}
