$( document ).ready(function() {
    $('.linea').click(function() {
        $('#home').html('<embed src="./files/'+this.id+'_4b/'+this.id+'_ejemplo.pdf" type="application/pdf" width="100%" height="400px" class="margenfilemodal" />');
        //alert(this);
        let elementos = this.getElementsByTagName("td")


        let url = './Propiedades.html?add=0'

        let uso = '&uso='+ elementos[0].innerHTML
        let zona = '&zona='+ elementos[1].innerHTML
        let user = '&user='+ elementos[2].innerHTML
        let lote = '&lote='+ elementos[3].innerHTML
        let m2 = '&m2='+ elementos[4].innerHTML
        let valorFiscal = '&valorFiscal='+ elementos[5].innerHTML
        let registro = '&registro='+ elementos[6].innerHTML
        let activo = '&activo='+ elementos[7].innerHTML
        location.replace(url+uso+zona+user+lote+m2+valorFiscal+registro+activo);
    });
});

function add(){
    location.replace('./Propiedades.html');
}
function ret(){
  location.replace('./AdminOptions.html');
}
function cerrar(){
  location.replace('./index.html');
}
