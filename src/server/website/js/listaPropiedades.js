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
