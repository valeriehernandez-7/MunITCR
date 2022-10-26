
$(document).ready(function(){
  var url = "http://localhost:8000/ReadTipoUsoPropiedad"
  const $select = $("#idType")
  const options = {
    method: "get",
    headers: {"Content-Type": "application/json"},
    };
  fetch(url, options).then(response => response.json())
  .then(response => {
    console.log(response);
    for (var i = 0; i < response.length; i++) {
      valor=response[i].Nombre;
      $select.append($("<option>", {
        value: valor,
        text: valor
      }));
    }
    if(add== "0")
      document.getElementById('idType').value = uso;
    }).catch(e => {
      console.log(e);
    });
    //segundo select
    var url = "http://localhost:8000/ReadTipoZonaPropiedad"
    const $select2 = $("#idZone")
    fetch(url, options).then(response => response.json())
  .then(response => {
    console.log(response);
    for (var i = 0; i < response.length; i++) {
      valor=response[i].Nombre;
      $select2.append($("<option>", {
        value: valor,
        text: valor
      }));
    }
    if(add== "0")
      document.getElementById('idZone').value =zona;
    }).catch(e => {
      console.log(e);
    });
    

    var add = (new URL(location.href)).searchParams.get('add')
    if(add== "0"){
      var uso = (new URL(location.href)).searchParams.get('uso')
      var zona = (new URL(location.href)).searchParams.get('zona')
      var lote = (new URL(location.href)).searchParams.get('lote')
      var m2 = (new URL(location.href)).searchParams.get('m2')
      var valorFiscal = (new URL(location.href)).searchParams.get('valorFiscal')
      var registro = (new URL(location.href)).searchParams.get('registro')
      var activo = (new URL(location.href)).searchParams.get('activo')
      document.getElementById('lote').value =lote;
      document.getElementById('squareM').value =m2;
      document.getElementById('price').value =valorFiscal;
      document.getElementById('date').value =registro;
    }
})

async function add() {
  var url = "http://localhost:8000/CreatePropiedad"
  var uso = $("#idType").val()
  var zona = $("#idZone").val();
  var lote = $("#lote").val();
  var m2 = $("#squareM").val();
  var valorFiscal = $("#price").val();
  var registro = $("#date").val();
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip')
  const body={
    uso: uso,
    zona: zona,
    lote:lote,
    m2: m2,
    valorFiscal: valorFiscal,
    registro: registro,
    uss: uss,
    ip: ip
  }
  const options = {
  method: "post",
  body: JSON.stringify(body),
  headers: {"Content-Type": "application/json"},
  };
  //Petición HTTP
  console.log(body)
  fetch(url, options).then(response => response.json())
  .then(response => {
      console.log(response);
      if(response == 5404){
        window.alert("El tipo de Identificación no existe");
        return
      }
      if(response == 5406){
        window.alert("Ya existe este lote");
        return
      }
      if(response == 5404){
        window.alert("Tipo de uso de propiedad no registrado");
        return
      }
      if(response == 5400){
        window.alert("Los parametros no deben ser null");
        return
      }
      if(response == 5200){
        window.alert("Propiedad ingresada con exito");
        return
      }else {
        window.alert("Ocurrio un error al ingresar el dato");
      }
    }
    ).catch(e => {
      console.log(e);
    });
}

async function update() {
  var url = "http://localhost:8000/UpdatePropiedad"
  var lote = (new URL(location.href)).searchParams.get('lote')
  var uso = $("#idType").val()
  var zona = $("#idZone").val();
  var lote = $("#lote").val();
  var m2 = $("#squareM").val();
  var valorFiscal = $("#price").val();
  var registro = $("#date").val();
  const body={
    oldLote:lote,
    uso: uso,
    zona: zona,
    lote:lote,
    m2: m2,
    valorFiscal: valorFiscal,
    registro: registro
  }
  const options = {
  method: "post",
  body: JSON.stringify(body),
  headers: {"Content-Type": "application/json"},
  };
  //Petición HTTP
  console.log(body)
  fetch(url, options).then(response => response.json())
  .then(response => {
      console.log(response);
      if(response == 5404){
        window.alert("El tipo de propiedad no existe");
        return
      }      
      if(response == 5400){
        window.alert("Error al actualizar la propiedad");
        return
      }
      if(response == 5200){
        window.alert("Propiedad actualizada con exito");
        return
      }else {
        window.alert("Ocurrio un error al actualizar los daots");
      }
    }
    ).catch(e => {
      console.log(e);
    });
}

function ret() {
  var uss = (new URL(location.href)).searchParams.get('uss')
  var ip = (new URL(location.href)).searchParams.get('ip') 
  location.replace(' ./listaPropiedades.html?uss='+uss+"&ip="+ip);
}
function cerrar(){
  location.replace('./index.html');
}
