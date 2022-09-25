$( document ).ready(function() {
    $('.linea').click(function() {
        $('#home').html('<embed src="./files/'+this.id+'_4b/'+this.id+'_ejemplo.pdf" type="application/pdf" width="100%" height="400px" class="margenfilemodal" />');
        //alert(this);
        let url = './Persona.html?add=0'
        let elementos = this.getElementsByTagName("td")
        let nombre ='&nombre='+elementos[0].innerHTML
        let id = '&id='+ elementos[1].innerHTML
        let tipo = '&tipo='+ elementos[2].innerHTML
        let tel = '&tel='+ elementos[3].innerHTML
        let tel2 = '&tel2='+ elementos[4].innerHTML
        let email = '&email='+ elementos[5].innerHTML
        let activo = '&activo='+ elementos[6].innerHTML
        location.replace(url+nombre+id+tipo+tel+tel2+email+activo);

    });
});

function add(){
    location.replace('./Persona.html');
}
function ret(){
  location.replace('./AdminOptions.html');
}
function cerrar(){
  location.replace('./index.html');
}
