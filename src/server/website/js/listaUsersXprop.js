//$( document ).ready(function() {
//    $('.linea').click(function() {
//        $('#home').html('<embed src="./files/'+this.id+'_4b/'+this.id+'_ejemplo.pdf" type="application/pdf" width="100%" height="400px" class="margenfilemodal" />');
//        //alert(this);
//        let elementos = this.getElementsByTagName("td")
//
//
//        let url = './UsersXprop.html?add=0'
//
//        let usuario = '&usuario='+ elementos[0].innerHTML
//        let lote = '&lote='+ elementos[1].innerHTML
//        location.replace(url+usuario+lote);
//    });
//});
function edit(usuario,lote){
  let url = './UserXpropEdit.html?add=0'
  url+='&usuario='+usuario
  url+='&lote='+lote
  location.replace(url);
}
function add(){
    location.replace('./UsersXprop.html');
}
function ret(){
  location.replace('./AdminOptions.html');
}
function cerrar(){
  location.replace('./index.html');
}
