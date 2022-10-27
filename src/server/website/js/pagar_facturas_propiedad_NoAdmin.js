$( document ).ready(function() {
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
        var boton = " <input class=\"buttons\" type=\"submit\" id=\"addBtn\" value=\" VER \" onclick=\"lecturas("+ lote +");\" >"
        var boton2 = " <input class=\"buttons\" type=\"submit\" id=\"addBtn\" value=\" VER \" onclick=\"facturas("+ lote +");\" >"
        var boton3 = " <input class=\"buttons\" type=\"submit\" id=\"addBtn\" value=\" VER \" onclick=\"facturasPendientes("+ lote +");\" >"
        var boton4 = " <input class=\"buttons\" type=\"submit\" id=\"addBtn\" value=\" VER \" onclick=\"comprobante("+ lote +");\" >"
        tabla+= "<td>"+ boton + "</td>"
        tabla+= "<td>"+ boton2 + "</td>"
        tabla+= "<td>"+ boton3 + "</td>"
        tabla+= "<td>"+ boton4 + "</td></tr>"
        $("#tablaItems ").append(tabla);
      }}).catch(e => {
        console.log(e);
      });
  });
function add(){
    var uss = (new URL(location.href)).searchParams.get('uss')
    var ip = (new URL(location.href)).searchParams.get('ip') 
    location.replace('./UsersXprop.html?uss='+uss+"&ip="+ip);
}
function ret(){
    var uss = (new URL(location.href)).searchParams.get('uss')
    var ip = (new URL(location.href)).searchParams.get('ip') 
    location.replace('./propiedades_usuarioNoAdmin.html?uss='+uss+"&ip="+ip);
}
function cerrar(){
    location.replace('./index.html');
}
  