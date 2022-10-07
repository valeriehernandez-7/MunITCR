$(document).ready(function(){
  var url = "http://localhost:8000/ReadPropiedad"
  const options = {
  method: "get",
  headers: {"Content-Type": "application/json"},
  };
  fetch(url, options).then(response => response.json())
  .then(response => {
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
      tabla += uso + "</td><td>" + zona + "</td><td>" + lote + "</td><td>" + area + "</td><td>" + valorFiscal + "</td><td>" + fechaRegistro + "</td>"
      var boton = " <input class=\"buttons\" type=\"submit\" id=\"addBtn\" value=\" Editar \" onclick=\"edit(\'"+ uso +"\',\'" + zona +"\',"+ lote + "," + area + ","+ valorFiscal + ",\'" + fechaRegistro+"\');\" >"
      var boton2 = " <input class=\"buttons\" type=\"submit\" id=\"addBtn\" value=\" Eliminar \" onclick=\"edit(\'"+ uso +"\',\'" + zona +"\',"+ lote + "," + area + ","+ valorFiscal + ",\'" + fechaRegistro+"\');\" >"
      //se debe cambiar el otro boton
      tabla+= "<td>"+ boton + boton2 + "</td></tr>"
      $("#tablaItems ").append(tabla);
    }

  }).catch(e => {
      console.log(e);
  });

})

function edit(uso,zona,lote,m2,valorFiscal,registro){
  let url = './PropiedadesEdit.html?add=0'
  url+='&uso='+uso
  url+='&zona='+zona
  url+='&lote='+lote
  url+='&m2='+m2
  url+='&valorFiscal='+valorFiscal
  url+='&registro='+registro
  location.replace(url);
}
function add(){
    location.replace('./Propiedades.html');
}
function ret(){
  location.replace('./AdminOptions.html');
}
function cerrar(){
  location.replace('./index.html');
}
