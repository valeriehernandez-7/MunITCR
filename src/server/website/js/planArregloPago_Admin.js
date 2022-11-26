function cant(){
  lote = document.getElementById("propiedLote").value;
  if(lote==""){
    window.alert("Debe ingresar un lote");
    return
  }
  var url = "http://localhost:8000/ReadTasasInteresSolictudAPIn?lote="+lote
  const options = {
    method: "get",
    headers: {"Content-Type": "application/json"},
  };
  fetch(url, options).then(response => response.json())
  .then(response => {
    console.log(response)
    table = $("#tablePlans ")
    $("tablePlansBody").remove()
    for (var i = 0; i < response.length; i++) {
      var TI = response [i];      
      var plazo = TI.Plazo ;
      var tasa = TI.Tasa;
      var cuota = TI.Cuota ; ;      
      var fin = TI.FechaFin.substring(0,10);
      
      var tabla = "<tr><td> ";
      tabla += plazo + "</td><td>" + tasa + "</td><td>" + cuota + "</td>" 
      var boton = " <input class=\"buttons\" type=\"submit\" id=\"addBtn\" value=\" Editar \" onclick=\"solicitar("+ plazo +"," + tasa +","+ cuota + ",\'" + fin+"\');\" >"
      //se debe cambiar el otro boton
      tabla+= "<td>"+ boton + "</td></tr>"
      table.append(tabla);
    }


    }
  ).catch(e => {
      console.log(e);
    });
}

function solicitar(plazo,tasa,cuota,fin){
  console.log(plazo,tasa,cuota,fin)
}
function ret(){
    var uss = (new URL(location.href)).searchParams.get('uss')
    var ip = (new URL(location.href)).searchParams.get('ip') 
    location.replace('./Consulta.html?uss='+uss+"&ip="+ip);
  }
function cerrar(){
    location.replace('./index.html');
}