$( document ).ready(function() {
  //$('.linea').click(function() {
  //    $('#home').html('<embed src="./files/'+this.id+'_4b/'+this.id+'_ejemplo.pdf" type="application/pdf" width="100%" height="400px" class="margenfilemodal" />');
  //    //alert(this);
  //    let elementos = this.getElementsByTagName("td")
  //
  //
  //    let url = './listaMediciones.html?'
  //
  //    let usuario = '&usuario='+ elementos[0].innerHTML
  //    let lote = '&lote='+ elementos[1].innerHTML
  //    location.replace(url+usuario+lote);
  //});
  var user = (new URL(location.href)).searchParams.get('uss')
  console.log(user)
  const body={
    user: user
  }
  console.log(body)
  const options = {
    method: "post",
    body: JSON.stringify(body),
    headers: {"Content-Type": "application/json"},
  };
  console.log(options)
  var url = "http://localhost:8000/ReadUsuarioInXPropiedad"
  fetch(url, options).then(response => response.json())
  .then(response => {
    console.log(response)
    $("#tableBody > tbody").empty();
    for (var i = 0; i < response.length; i++) {
      var propiedad = response [i];      
      var lote = propiedad.Propiedad;
      var uso = propiedad.UsodePropiedad;
      var zona = propiedad.ZonadePropiedad ;
      var area = propiedad.Territorio;
      var valorFiscal = propiedad.ValorFiscal;
      var fechaRegistro = propiedad.FechadeRegistro;
      fechaRegistro = fechaRegistro.substring(0,10);
      var tabla = "<tr><td> ";
      tabla += uso + "</td><td>" + zona + "</td><td>" + lote + "</td><td>" + area + "</td><td>" + valorFiscal + "</td><td>" + fechaRegistro 
      var boton = " <input class=\"buttons\" type=\"submit\" id=\"addBtn\" value=\" Lecturas \" onclick=\"lecturas("+ propiedad +"," + lote +",\'"+ uso + "\',\'" + zona + "\',\'"+area+ "\',\'"+valorFiscal+ "\',\'"+fechaRegistro+"\');\" >"
      tabla+= "<td>"+ boton + "</td></tr>"
      $("#tablaItems ").append(tabla);
    }}).catch(e => {
      console.log(e);
    });
});

function ret(){
  location.replace('./index.html');
}
function cerrar(){
  location.replace('./index.html');
}
