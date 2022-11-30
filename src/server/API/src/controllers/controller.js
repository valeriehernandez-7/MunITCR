//import  sql from 'mssql'
const sql = require('mssql')
import {getConection} from '../database/conection';

export const ReadPersona=  async (req, res) => {
    const pool= await getConection()
    const result= await pool.request().
                    output('outResultCode', sql.Int).
                    execute('SP_ReadPersona');
        res.json(result.recordset);     
}

export const ReadTipoDocID = async (req, res) => {
    const pool= await getConection()
    const result= await pool.request().
                    output('outResultCode', sql.Int).
                    execute('SP_ReadTipoDocIdentidad');
        res.json(result.recordset); 
}

export const ReadPropiedad = async (req, res) => {
    const pool= await getConection()
    const result= await pool.request().
                    output('outResultCode', sql.Int).
                    execute('SP_ReadPropiedad');
        res.json(result.recordset); 
}

export const ReadTipoUsoPropiedad = async (req, res) => {
    const pool= await getConection()
    const result= await pool.request().
                    output('outResultCode', sql.Int).
                    execute('SP_ReadTipoUsoPropiedad');
        res.json(result.recordset); 
}

export const ReadTipoZonaPropiedad = async (req, res) => {
    const pool= await getConection()
    const result= await pool.request().
                    output('outResultCode', sql.Int).
                    execute('SP_ReadTipoZonaPropiedad');
        res.json(result.recordset); 
}

export const ReadUsuario = async (req, res) => {
    const pool= await getConection()
    const result= await pool.request().
                    output('outResultCode', sql.Int).
                    execute('SP_ReadUsuario');
        res.json(result.recordset); 
}


export const ReadPersonaXPropiedad = async (req, res) => {
    var opcion =req.query.opcion
    console.log(opcion)
    const pool= await getConection()
    const result= await pool.request().
                    input('inEsAsociacion', sql.Bit, parseInt(opcion)).
                    output('outResultCode', sql.Int).
                    execute('SP_ReadPersonaXPropiedadAsocDesasoc');                 
        res.json(result.recordset);  
}

export const ReadPersonaIdentificacion = async (req, res) => {
    const pool= await getConection()
    const result= await pool.request().
                    output('outResultCode', sql.Int).
                    execute('[SP_ReadPersonaIdentificacion]');
        res.json(result.recordset); 
}

export const ReadPropiedadLoteAdmin = async (req, res) => {
    const pool= await getConection()
    const result= await pool.request().
                    output('outResultCode', sql.Int).
                    execute('SP_ReadPropiedadLote');
        res.json(result.recordset); 
}

export const ReadConceptoCobro = async (req, res) => {
    const pool= await getConection()
    const result= await pool.request().
                    output('outResultCode', sql.Int).
                    execute('SP_ReadConceptoCobro');
        res.json(result.recordset); 
}

export const ReadMedioDePago = async (req, res) => {
    const pool= await getConection()
    const result= await pool.request().
                    output('outResultCode', sql.Int).
                    execute('SP_ReadMedioDePago');
        res.json(result.recordset); 
}

export const ReadTipoMovimientoConsumoAgua = async (req, res) => {
    const pool= await getConection()
    const result= await pool.request().
                    output('outResultCode', sql.Int).
                    execute('SP_ReadTipoMovimientoConsumoAgua');
        res.json(result.recordset); 
}

export const ReadTipoMontoCC = async (req, res) => {
    const pool= await getConection()
    const result= await pool.request().
                    output('outResultCode', sql.Int).
                    execute('SP_ReadTipoMontoCC');
        res.json(result.recordset); 
}




export const ReadPropiedadLote=  async (req, res) => {
    const pool= await getConection() 
    var user = req.query.user;
    const result= await pool.request()
                    .input('inUsuario', sql.VARCHAR(16),user).
                    output('outResultCode', sql.Int).
                    execute('SP_ReadPropiedadLoteUsuario');
        res.json(result.recordset);    
}

export const ReadPropiedadXUsuario=  async (req, res) => {
    const pool= await getConection() 
    var opcion =req.query.opcion
    console.log(opcion)
    const result= await pool.request()
                    .input('inEsAsociacion', sql.Bit, parseInt(opcion))
                    .output('outResultCode', sql.Int)
                    .execute('SP_ReadUsuarioXPropiedadAsocDesasoc');
    res.json(result.recordset);   
}

export const ReadFacturaPagadaPropiedadIn=  async (req, res) => {
    const pool= await getConection() 
    var lote = req.query.lote;
    const result= await pool.request().
                    input('inPropiedadLote', sql.VARCHAR(32), lote).
                    output('outResultCode', sql.Int).
                    execute('SP_ReadFacturaPagadaPropiedadIn');
                    console.log(result)
        res.json(result.recordset);   
} 

export const ReadFacturaPagadaPlanArregloPagoPropiedadIn=  async (req, res) => {
    const pool= await getConection() 
    var lote = req.query.lote;
    const result= await pool.request().
                    input('inPropiedadLote', sql.VARCHAR(32), lote).
                    output('outResultCode', sql.Int).
                    execute('SP_ReadFacturaPagadaPlanArregloPagoPropiedadIn');
                    console.log(result)
        res.json(result.recordset);   
}

export const ReadFacturaPendientePlanArregloPagoPropiedadIn=  async (req, res) => {
    const pool= await getConection() 
    var lote = req.query.lote;
    const result= await pool.request().
                    input('inPropiedadLote', sql.VARCHAR(32), lote).
                    output('outResultCode', sql.Int).
                    execute('SP_ReadFacturaPendientePlanArregloPagoPropiedadIn');
                    console.log(result)
        res.json(result.recordset);   
}

export const ArregloPagoFormalizacion=  async (req, res) => {
    const pool= await getConection() 
    const {lote,plazo,cuota,saldo,interes,amortizacion,fechaForm,FechaFin} = req.body;
    console.log(lote,plazo,cuota,saldo,interes,amortizacion,fechaForm,FechaFin)
    const result= await pool.request()
                    .input('inPropiedadLote', sql.VARCHAR(32), lote)
                    .input('inPlazoMeses', sql.INT, plazo)
                    .input('inCuota', sql.Money, cuota)
                    .input('inSaldo', sql.Money, saldo)
                    .input('inIntereses', sql.Money, interes)
                    .input('inAmortizacion', sql.Money, amortizacion)
                    .input('inFechaFormalizacion', sql.Date, fechaForm)
                    .input('inFechaVencimiento', sql.Date, FechaFin)
                    .input('inFechaOperacion', sql.Date, null)
                    .output('outResultCode', sql.Int)
                    .execute('SP_ArregloPagoFormalizacion');  
        console.log(result.output.outResultCode)                  
        res.json(result.output.outResultCode);   
} 

export const error=  async (req, res) => {
    const pool= await getConection()
    const {tipo,entidad,fechaI,fechaF} = req.body;
    console.log(tipo,entidad,fechaI,fechaF)
    console.log(typeof fechaF)
    const result= await pool.request()
                .input('inEventType', sql.VARCHAR(8),tipo)
                .input('inEntityType', sql.VARCHAR(128),entidad)
                .input('inFechaInicial', sql.Date,fechaI)
                .input('inFechaFinal', sql.Date,fechaF)
                .output('outResultCode', sql.Int)
                .execute('SP_ArregloPagoFormalizacion');
        console.log(result)
        res.json(result.recordset);    
}

export const ReadMovimientoConsumoAgua=  async (req, res) => {
    const pool= await getConection() 
    var lote = req.query.lote;
    const result= await pool.request().
                    input('inPropiedadLote', sql.VARCHAR(32), lote).
                    output('outResultCode', sql.Int).
                    execute('SP_ReadMovimientoConsumoAgua');
                    console.log(result)
        res.json(result.recordset);   
} 

export const ReadFacturaPendientePropiedadIn=  async (req, res) => {
    const pool= await getConection() 
    var lote = req.query.lote;
    var cant = req.query.cant;
    if (cant == 0)
    {
        cant = null
    }
    console.log(cant,lote)
    const result= await pool.request().
                    input('inPropiedadLote', sql.VARCHAR(32), lote).
                    input('inFacturas', sql.Int, cant).
                    output('outResultCode', sql.Int).
                    execute('SP_ReadFacturaPendientePropiedadIn');        
        res.json(result.recordset);   
} 

export const ReadPropiedadXUsuarioIn=  async (req, res) => {
    const pool= await getConection()
    var user = req.query.user;
    const result= await pool.request()
                    .input('inUsuario', sql.VARCHAR(16),user).
                    output('outResultCode', sql.Int).
                    execute('SP_ReadPropiedadXUsuarioIn');
        res.json(result.recordset);    
}

export const ReadEventType=  async (req, res) => {
    const pool= await getConection()
    var user = req.query.user;
    const result= await pool.request()
                    .output('outResultCode', sql.Int).
                    execute('SP_ReadEventType');
        res.json(result.recordset);    
}

export const ReadEntityType=  async (req, res) => {
    const pool= await getConection()
    var user = req.query.user;
    const result= await pool.request()
                    .output('outResultCode', sql.Int).
                    execute('SP_ReadEntityType');
        res.json(result.recordset);    
}


export const ReadEventLogEventInEntityInFechaIn=  async (req, res) => {
    const pool= await getConection()
    const {tipo,entidad,fechaI,fechaF} = req.body;
    console.log(tipo,entidad,fechaI,fechaF)
    console.log(typeof fechaF)
    const result= await pool.request()
                .input('inEventType', sql.VARCHAR(8),tipo)
                .input('inEntityType', sql.VARCHAR(128),entidad)
                .input('inFechaInicial', sql.Date,fechaI)
                .input('inFechaFinal', sql.Date,fechaF)
                .output('outResultCode', sql.Int)
                .execute('SP_ReadEventLogEventInEntityInFechaIn');
        console.log(result)
        res.json(result.recordset);    
}

export const ReadEventLog=  async (req, res) => {
    const pool= await getConection()
    const result= await pool.request().
                    output('outResultCode', sql.Int).
                    execute('SP_ReadEventLog');
        res.json(result.recordset);    
}

export const ReadMedioPago=  async (req, res) => {
    const pool= await getConection()
    const result= await pool.request().
                    output('outResultCode', sql.Int).
                    execute('SP_ReadMedioPago');
        res.json(result.recordset);    
}

export const ArregloPagoSolicitud =  async (req, res) => {
    const pool= await getConection()
    var lote = req.query.lote;
    const result= await pool.request()
                    .input('inPropiedadLote', sql.VARCHAR(32),lote)
                    .input('inFechaOperacion', sql.DATE,null)
                    .output('outResultCode', sql.Int).
                    execute('SP_ArregloPagoSolicitud');
        res.json(result.recordset);    
}

export const ArregloPagoSolicitudFacturas =  async (req, res) => {
    const pool= await getConection()
    var lote = req.query.lote;
    const result= await pool.request()
                    .input('inPropiedadLote', sql.VARCHAR(32),lote)
                    .input('inFechaOperacion', sql.DATE,null)
                    .output('outResultCode', sql.Int).
                    execute('SP_ArregloPagoSolicitudFacturas');
        res.json(result.recordset);    
}

export const CreatePersona=  async (req, res) => {
    const pool= await getConection()
    const {nombre,tipoID,Ident,tel1,tel2,email,uss,ip} = req.body;
    const result= await pool.request()
                .input('inNombre', sql.VARCHAR(128),nombre)
                .input('inTipoIdentificacion', sql.VARCHAR(128),tipoID)
                .input('inIdentificacion', sql.VARCHAR(64),Ident)
                .input('inTelefono1', sql.VARCHAR(16),tel1)
                .input('inTelefono2', sql.VARCHAR(16),tel2)
                .input('inEmail', sql.VARCHAR(256),email)
                .input('inEventUser', sql.VARCHAR(16),uss)
                .input('inEventIP', sql.VARCHAR(64),ip)
                .output('outResultCode', sql.Int)
                .execute('SP_CreatePersona');
        res.json(result.output.outResultCode);    
    }

export const Pago=  async (req, res) => {
    const pool= await getConection()
    const {lote,cant,medio} = req.body;
    console.log(lote,cant,medio)
    const result= await pool.request()
                .input('inPropiedadLote', sql.VARCHAR(32),lote)
                .input('inFacturas', sql.Int,cant)
                .input('inReferencia', sql.BigInt,null)
                .input('inMedioPago', sql.VARCHAR(128),medio)
                .input('inFecha', sql.Date,null)
                .output('outResultCode', sql.Int)
                .execute('SP_Pago');
        res.json(result.output.outResultCode);    
    }

export const CreateUsuario =  async (req, res) => {
    const pool= await getConection()
    const {ident,user,password,admin,uss,ip} = req.body;
    const result= await pool.request()
                .input('inIdentificacionPersona', sql.VARCHAR(64),ident)
                .input('inUsername', sql.VARCHAR(16),user)
                .input('inPassword', sql.VARCHAR(16),password)
                .input('inTipoUsuario', sql.VARCHAR(16),admin)
                .input('inEventUser', sql.VARCHAR(16),uss)
                .input('inEventIP', sql.VARCHAR(64),ip)
                .output('outResultCode', sql.Int)
                .execute('SP_CreateUsuario');
        res.json(result.output.outResultCode);    
    }

export const CreatePropiedad =  async (req, res) => {
    const pool= await getConection()
    const {uso,zona,lote,medidor,m2,valorFiscal,registro,uss,ip} = req.body;
    const result= await pool.request() 
                .input('inUsoPropiedad', sql.VARCHAR(128),uso)
                .input('inZonaPropiedad', sql.VARCHAR(128),zona)
                .input('inLote', sql.VARCHAR(32),lote)
                .input('inMedidor', sql.VARCHAR(16),medidor)
                .input('inMetrosCuadrados', sql.BIGINT,m2)
                .input('inValorFiscal', sql.MONEY,valorFiscal)
                .input('inFechaRegistro', sql.DATE,registro)
                .output('outResultCode', sql.Int)
                .execute('SP_CreatePropiedad');
        res.json(result.output.outResultCode);    
    }

export const CreatePersonaXPropiedad =  async (req, res) => {
    const pool= await getConection()
    const {iden,lote,fecha,uss,ip} = req.body;
    const result= await pool.request() 
                .input('inPersonaIdentificacion', sql.VARCHAR(64),iden)
                .input('inPropiedadLote', sql.VARCHAR(32),lote)
                .input('inFechaAsociacionPxP', sql.DATE,fecha)
                .input('inEventUser', sql.VARCHAR(16),uss)
                .input('inEventIP', sql.VARCHAR(64),ip)
                .output('outResultCode', sql.Int)
                .execute('SP_CreatePersonaXPropiedad');
        res.json(result.output.outResultCode);    
    }

export const CreateUsuarioXPropiedad =  async (req, res) => {
    const pool= await getConection()
    const {iden,lote,fecha,uss,ip} = req.body;
    console.log(iden,lote,fecha,uss,ip)
    const result= await pool.request() 
                .input('inUsuarioUsername', sql.VARCHAR(16),iden)
                .input('inPropiedadLote', sql.VARCHAR(32),lote)
                .input('inFechaAsociacionUxP', sql.DATE,fecha)
                .input('inEventUser', sql.VARCHAR(16),uss)
                .input('inEventIP', sql.VARCHAR(64),ip)
                .output('outResultCode', sql.Int)
                .execute('SP_CreateUsuarioXPropiedad');
        res.json(result.output.outResultCode);    
    } 

export const UpdateUsuarioXPropiedad =  async (req, res) => {
    const pool= await getConection()
    const {oldusr,oldlote,iden,lote,fecha,asoc,uss,ip} = req.body;
    console.log(oldusr,oldlote,iden,lote,fecha,asoc,uss,ip)
    const result= await pool.request() 
                .input('inOldUsuarioUsername', sql.VARCHAR(16),oldusr)
                .input('inOldPropiedadLote', sql.VARCHAR(16),oldlote)
                .input('inUsuarioUsername', sql.VARCHAR(16),iden)
                .input('inPropiedadLote', sql.VARCHAR(32),lote)
                .input('inFechaRelacionUXP', sql.DATE,fecha)
                .input('inEsAsociacion', sql.Bit,asoc)
                .input('inEventUser', sql.VARCHAR(16),uss)
                .input('inEventIP', sql.VARCHAR(64),ip)
                .output('outResultCode', sql.Int)
                .execute('SP_UpdateUsuarioXPropiedad');
        res.json(result.output.outResultCode);    
    } 

export const UpdatePersona =  async (req, res) => { 
    const pool= await getConection()
    const {oldId,nombre,tipoID,Ident,tel1,tel2,email,uss,ip} = req.body;
    const result= await pool.request() 
                .input('inOldIdentificacion', sql.VARCHAR(64),oldId)
                .input('inNombre', sql.VARCHAR(128),nombre)
                .input('inTipoIdentificacion', sql.VARCHAR(128),tipoID)
                .input('inIdentificacion', sql.VARCHAR(64),Ident)
                .input('inTelefono1', sql.VARCHAR(16),tel1)
                .input('inTelefono2', sql.VARCHAR(16),tel2)
                .input('inEmail', sql.VARCHAR(256),email)
                .input('inEventUser', sql.VARCHAR(16),uss)
                .input('inEventIP', sql.VARCHAR(64),ip)                
                .output('outResultCode', sql.Int)
                .execute('SP_UpdatePersona');
        res.json(result.output.outResultCode);    
    }



export const ReadPropiedadPersonaIn =  async (req, res) => {
    const pool= await getConection()
    const ident = req.body.ident;
    const result= await pool.request() 
                .input('inPersonaIdentificacion', sql.VARCHAR(64),ident)
                .output('outResultCode', sql.Int)
                .execute('SP_ReadPersonaXPropiedadPropiedades');
        res.json(result.recordset);    
    }

export const ReadPropiedadInPersona =  async (req, res) => {
    const pool= await getConection()
    const lote = req.body.lote;
    const result= await pool.request() 
                .input('inPropiedadLote', sql.VARCHAR(32),lote)
                .output('outResultCode', sql.Int)
                .execute('SP_ReadPersonaXPropiedadPropietarios');
        res.json(result.recordset);    
    }

export const ReadPropiedadXCCArregloPagoPropiedadIn =  async (req, res) => {
    const pool= await getConection()
    const lote = req.body.lote;
    console.log(lote)
    const result= await pool.request() 
                .input('inPropiedadLote', sql.VARCHAR(32),lote)
                .output('outResultCode', sql.Int)
                .execute('SP_ReadPropiedadXCCArregloPagoPropiedadIn');
        res.json(result.recordset);    
    }

export const ReadDetalleCCXFacturaIn =  async (req, res) => {
    const pool= await getConection()
    const idFact = req.body.idFact;
    console.log(idFact)
    const result= await pool.request() 
                .input('inIDFactura', sql.Int,idFact)
                .output('outResultCode', sql.Int)
                .execute('SP_ReadDetalleCCXFacturaIn');
        res.json(result.recordsets);    
    }

export const ReadUsuarioInXPropiedad =  async (req, res) => {
    const pool= await getConection()
    const user = req.body.user;
    const result= await pool.request() 
                .input('inUsuarioUsername', sql.VARCHAR(16),user)
                .output('outResultCode', sql.Int)
                .execute('SP_ReadUsuarioXPropiedadPropiedades');
        res.json(result.recordset);     
    }

export const ReadUsuarioXPropiedadIn =  async (req, res) => {
    const pool= await getConection()
    const lote = req.body.lote;
    const result= await pool.request() 
                .input('inPropiedadLote', sql.VARCHAR(32),lote)
                .output('outResultCode', sql.Int)
                .execute('SP_ReadUsuarioXPropiedadUsuarios');
        res.json(result.recordset);    
    }

export const UpdateUsuario =  async (req, res) => {
    const pool= await getConection()
    const {oldID,ident,user,password,admin,uss,ip} = req.body;
    const result= await pool.request()
                .input('inOldUsername', sql.VARCHAR(64),oldID)
                .input('inIdentificacionPersona', sql.VARCHAR(64),ident)
                .input('inUsername', sql.VARCHAR(16),user)
                .input('inPassword', sql.VARCHAR(16),password)
                .input('inTipoUsuario', sql.VARCHAR(16),admin)
                .input('inEventUser', sql.VARCHAR(16),uss)
                .input('inEventIP', sql.VARCHAR(64),ip)
                .output('outResultCode', sql.Int)
                .execute('SP_UpdateUsuario');
        res.json(result.output.outResultCode);    
    }

export const UpdatePropiedad =  async (req, res) => {
    const pool= await getConection()
    const {oldLote,uso,zona,lote,m2,valorFiscal,registro,uss,ip} = req.body;
    const result= await pool.request()
                .input('inOldLote', sql.VARCHAR(32),oldLote)
                .input('inUsoPropiedad', sql.VARCHAR(128),uso)
                .input('inZonaPropiedad', sql.VARCHAR(128),zona)
                .input('inLote', sql.VARCHAR(32),lote)
                .input('inMetrosCuadrados', sql.BIGINT,m2)
                .input('inValorFiscal', sql.MONEY,valorFiscal)
                .input('inFechaRegistro', sql.DATE,registro)
                .output('outResultCode', sql.Int)
                .input('inEventUser', sql.VARCHAR(16),uss)
                .input('inEventIP', sql.VARCHAR(64),ip)
                .execute('SP_UpdatePropiedad');
        res.json(result.output.outResultCode);    
    }

export const UpdatePersonaXPropiedad =  async (req, res) => {
    const pool= await getConection()
    const {oldId,oldLote,id,lote,fechaAsoc,fechaDesasoc,uss,ip,opcion} = req.body;
    console.log(typeof(oldId),oldLote,id,lote,fechaAsoc,fechaDesasoc) 
    const result= await pool.request()
                .input('inOldPersonaIdentificacion', sql.VARCHAR(64),oldId)
                .input('inOldPropiedadLote', sql.VARCHAR(32),oldLote)
                .input('inPersonaIdentificacion', sql.VARCHAR(64),id)
                .input('inPropiedadLote', sql.VARCHAR(32),lote)
                .input('inFechaRelacionPxP', sql.Date,fechaAsoc)
                .input('inEsAsociacion', sql.Bit,opcion)
                .input('inEventUser', sql.VARCHAR(16),uss)
                .input('inEventIP', sql.VARCHAR(64),ip)
                .output('outResultCode', sql.Int)
                .execute('SP_UpdatePersonaXPropiedad');
                console.log(result.output.outResultCode)
        res.json(result.output.outResultCode); 
    } 

export const UpdatePersonaXPropiedadDesasociacion =  async (req, res) => {
    const pool= await getConection()
    const {id,lote,inFechaRelacionPxP,fechaDesasoc,uss,ip} = req.body;
    console.log(id,lote,inFechaRelacionPxP,fechaDesasoc) 
    const result= await pool.request()
                .input('inPersonaIdentificacion', sql.VARCHAR(64),id)
                .input('inPropiedadLote', sql.VARCHAR(32),lote)
                .input('inFechaDesasociacionPXP', sql.Date,inFechaRelacionPxP)
                .input('inEventUser', sql.VARCHAR(16),uss)
                .input('inEventIP', sql.VARCHAR(64),ip)
                .output('outResultCode', sql.Int)
                .execute('SP_UpdatePersonaXPropiedadDesasociacion');
                console.log(result.output.outResultCode)
        res.json(result.output.outResultCode); 
    } 

export const DeletePersona =  async (req, res) => {
    const pool= await getConection()
    const {id,uss,ip} = req.body;
    console.log(id)
    const result= await pool.request()
                .input('inIdentificacion', sql.VARCHAR(64),id)
                .input('inEventUser', sql.VARCHAR(16),uss)
                .input('inEventIP', sql.VARCHAR(64),ip)
                .output('outResultCode', sql.Int)
                .execute('SP_DeletePersona');
                console.log(result.output.outResultCode)
        res.json(result.output.outResultCode); 
    } 

export const DeleteUsuario =  async (req, res) => {
    const pool= await getConection()
    const {user,uss,ip} = req.body;
    console.log(user,uss,ip)
    const result= await pool.request()
                .input('inUsername', sql.VARCHAR(16),user)
                .input('inEventUser', sql.VARCHAR(16),uss)
                .input('inEventIP', sql.VARCHAR(64),ip)
                .output('outResultCode', sql.Int)
                .execute('SP_DeleteUsuario');
                console.log(result.output.outResultCode)
        res.json(result.output.outResultCode); 
    } 

export const DeletePropiedad =  async (req, res) => {
    const pool= await getConection()
    const {lote,uss,ip} = req.body;
    console.log(lote,uss,ip)
    const result= await pool.request()
                .input('inPropiedadLote', sql.VARCHAR(32),lote.toString())
                .input('inEventUser', sql.VARCHAR(16),uss)
                .input('inEventIP', sql.VARCHAR(64),ip)
                .output('outResultCode', sql.Int)
                .execute('SP_DeletePropiedad');
        res.json(result.output.outResultCode); 
    } 

export const DeletePersonaXPropiedad =  async (req, res) => {
    const pool= await getConection()
    const {id,lote,uss,ip} = req.body;
    const result= await pool.request()
                .input('inPersonaIdentificacion', sql.VARCHAR(64),id.toString())
                .input('inPropiedadLote', sql.VARCHAR(32),lote)
                .input('inEventUser', sql.VARCHAR(16),uss)
                .input('inEventIP', sql.VARCHAR(64),ip)
                .output('outResultCode', sql.Int)
                .execute('SP_DeletePersonaXPropiedad');
        res.json(result.output.outResultCode); 
    } 

export const DeleteUsuarioXPropiedad =  async (req, res) => {
    const pool= await getConection()
    const {user,lote,uss,ip} = req.body;
    const result= await pool.request()
            .input('inUsuarioUsername', sql.VARCHAR(16),user)
            .input('inPropiedadLote', sql.VARCHAR(32),lote)
            .input('inEventUser', sql.VARCHAR(16),uss)
            .input('inEventIP', sql.VARCHAR(64),ip)
            .output('outResultCode', sql.Int)
            .execute('SP_DeleteUsuarioXPropiedad');
    res.json(result.output.outResultCode); 
} 



