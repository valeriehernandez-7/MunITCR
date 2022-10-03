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
    const pool= await getConection()
    const result= await pool.request().
                    output('outResultCode', sql.Int).
                    execute('[SP_ReadPersonaXPropiedad]');
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


export const ReadUsuarioXPropiedadIn=  async (req, res) => {
    const pool= await getConection()
    var lote = req.query.lote;
    const result= await pool.request()
                    .input('inPropiedad', sql.Int,lote).
                    output('outResultCode', sql.Int).
                    execute('SP_ReadUsuarioXPropiedadIn');
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

export const ReadPropiedadXUsuarioIn=  async (req, res) => {
    const pool= await getConection()
    var user = req.query.user;
    const result= await pool.request()
                    .input('inUsuario', sql.VARCHAR(16),user).
                    output('outResultCode', sql.Int).
                    execute('SP_ReadPropiedadXUsuarioIn');
        res.json(result.recordset);    
}

export const CreatePersona=  async (req, res) => {
    const pool= await getConection()
    const {nombre,tipoID,Ident,tel1,tel2,email} = req.body;
    const result= await pool.request()
                .input('inNombre', sql.VARCHAR(128),nombre)
                .input('inTipoIdentificacion', sql.VARCHAR(128),tipoID)
                .input('inIdentificacion', sql.VARCHAR(64),Ident)
                .input('inTelefono1', sql.CHAR(16),tel1)
                .input('inTelefono2', sql.CHAR(16),tel2)
                .input('inEmail', sql.VARCHAR(256),email)
                .output('outResultCode', sql.Int)
                .execute('SP_CreatePersona');
        res.json(result.output.outResultCode);    
    }