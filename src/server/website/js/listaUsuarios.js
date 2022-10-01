//$( document ).ready(function() {
//    $('.linea').click(function() {
//        $('#home').html('<embed src="./files/'+this.id+'_4b/'+this.id+'_ejemplo.pdf" type="application/pdf" width="100%" height="400px" class="margenfilemodal" />');
//        //alert(this);
//        let url = './Usuarios.html?add=0'
//
//        let elementos = this.getElementsByTagName("td")
//        let idPersona = '&idPersona='+ elementos[0].innerHTML
//        let user = '&user='+ elementos[1].innerHTML
//        let pass = '&pass='+ elementos[2].innerHTML
//        let admin = '&admin='+ elementos[3].innerHTML
//        let activo = '&activo='+ elementos[4].innerHTML
//        location.replace(url+idPersona+user+pass+admin+activo);
//    });
//});
function add(){
    location.replace('./Usuarios.html');
}
function edit(nombre,user,pass,admin){
  let url = './UsuarioEdit.html?add=0'
  url+='&nombre='+nombre
  url+='&user='+user
  url+='&password='+pass
  url+='&admin='+admin
  location.replace(url);
}
function ret(){
  location.replace('./AdminOptions.html');
}
function cerrar(){
  location.replace('./index.html');
}
