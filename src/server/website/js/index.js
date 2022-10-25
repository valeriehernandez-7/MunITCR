
async function login(bit) {  
  var user = $("#usuario").val();
  var pass = $("#contrasena").val();
  const response = await axios.get('https://api.ipify.org?format=json');
  const ip = response.data.ip
  if (user == "" || pass==""){
      window.alert("Debe ingresar un usuario y contraseña");
      return;
    }
  if(user.includes(";") || pass.includes(";")){
    window.alert("No debe incluir ; en el usuario o la conreaseña");
    return;
    }
  var url = "http://localhost:8000/login?"+ new URLSearchParams({
    usuario:user,
    pass:pass,
    bit:bit
  })
  var datos={
    "username":user,
    "password": pass,
    "bit":bit
  }
  const options = {
    method: "get",
    headers: {"Content-Type": "application/json"},
  };
  
  fetch(url, options).then(response => response.json())
    .then(response => {
      
      if (response == 5200){
        if (bit==0){
          location.replace(' ./propiedades_usuarioNoAdmin.html?uss='+user+"&ip="+ip );
          return
        }
        if (bit ==1 ){
          location.replace(' ./AdminOptions.html?uss='+user+"&ip="+ip );
          return
        }        
    }
    if (response == 5403){
      window.alert("Su usuario no esta autorizado");
      return 
    }else{
      window.alert("Usuario o contraseña invalidos");
      return
    }
  }).catch(e => {
      console.log(e);
  });
  
}
async function loginAdmin() {
  var user = $("#usuario").val();
  var pass = $("#contrasena").val();
  const ip = await axios.get('https://api.ipify.org?format=json');
  if (user == "" || pass==""){
      window.alert("Debe ingresar un usuario y contraseña");
      return;
    }
  if(user.includes(";") || pass.includes(";")){
    window.alert("No debe incluir ; en el usuario o la conreaseña");
    return;
    }
  location.replace(' ./AdminOptions.html?uss='+user+"&ip="+ip);
}
