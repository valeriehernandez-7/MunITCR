$( document ).ready(function() {
    $('.linea').click(function() {
        $('#home').html('<embed src="./files/'+this.id+'_4b/'+this.id+'_ejemplo.pdf" type="application/pdf" width="100%" height="400px" class="margenfilemodal" />');
        //alert(this);
        let elementos = this.getElementsByTagName("td")


        let url = './PerXProp.html?add=0'

        let idPer = '&idPer='+ elementos[0].innerHTML
        let idProp = '&idProb='+ elementos[1].innerHTML
        let fechaI = '&fechaI='+ elementos[2].innerHTML
        let fechaF = '&fechaF='+ elementos[3].innerHTML
        location.replace(url+idPer+idProp+fechaI+fechaF);
    });
});

function add(){
    location.replace('./PerXProp.html');
}
function ret(){
  location.replace('./AdminOptions.html');
}
function cerrar(){
  location.replace('./index.html');
}
