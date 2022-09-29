$( document ).ready(function() {
    $('.linea').click(function() {
        $('#home').html('<embed src="./files/'+this.id+'_4b/'+this.id+'_ejemplo.pdf" type="application/pdf" width="100%" height="400px" class="margenfilemodal" />');
        //alert(this);
        let elementos = this.getElementsByTagName("td")


        let url = './listaMediciones.html?'

        let usuario = '&usuario='+ elementos[0].innerHTML
        let lote = '&lote='+ elementos[1].innerHTML
        location.replace(url+usuario+lote);
    });
});

function add(){
    location.replace('./UsersXprop.html');
}
function ret(){
  location.replace('./AdminOptions.html');
}
function cerrar(){
  location.replace('./index.html');
}
