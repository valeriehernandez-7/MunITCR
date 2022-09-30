//import  sql from 'mssql'
const sql = require('mssql')
import { request } from 'express';
import {getConection} from '../database/conection';


//filtrar items por cantidad
export const itemAmount=  async (req, res) => {
    const pool= await getConection()
    var itemAmount = req.query.itemAmount;
    if (itemAmount==null){
        const result= await pool.request()
                    .input('inAmount', sql.Int,null).
                    output('outResultCode', sql.Int).
                    execute('SP_ItemAmountFilter');
        res.json(result.recordset);    
    }else{
        const result= await pool.request()
                        .input('inAmount', sql.Int,itemAmount).
                        output('outResultCode', sql.Int).
                        execute('SP_ItemAmountFilter');
        res.json(result.recordset);
    };    
}

//filtado de items por categoria 
export const itemsCategory = async (req, res) => {
    const pool= await getConection()
    var itemCategoryName = req.query.itemCategoryName;
    if (itemCategoryName==null){
        const result= await pool.request()
                    .input('inCategoryName', sql.NVARCHAR(64),null).
                    output('outResultCode', sql.Int).
                    execute('SP_ItemCategoryFilter');
        res.json(result.recordset);    
    }else{
        const result= await pool.request()
                        .input('inCategoryName', sql.NVARCHAR(64),itemCategoryName).
                        output('outResultCode', sql.Int).
                        execute('SP_ItemCategoryFilter');
        res.json(result.recordset);
    };    
}

//listado de categorias
export const itemsCat = async (req, res) =>{
    const pool= await getConection() 
    const result= await pool.request().
                    output('outResultCode', sql.int).
                    execute('SP_ItemCategoryNameFilter');
    res.json(result.recordset)
};

//filtrar items por descripcion
export const itemsDescription = async (req, res) => {
    const pool= await getConection()
    var itemDescription = req.query.itemDescription;
    if (itemDescription==null){
        const result= await pool.request()
                    .input('inDescription', sql.NVARCHAR(128),null).
                    output('outResultCode', sql.Int).
                    execute('[SP_ItemDescriptionFilter]');
        res.json(result.recordset);    
    }else{
        const result= await pool.request()
                        .input('inDescription', sql.NVARCHAR(128),itemDescription).
                        output('outResultCode', sql.Int).
                        execute('[SP_ItemDescriptionFilter]');
        res.json(result.recordset);
    };    
}


//insersion de items 
export const itemInsert = async (req,res) => {
    const pool= await getConection()
    //aconsole.log(req)
    const {category,description,price,ip,user}  = req.body;
    //console.log(category, description, price, ip,user);
    const result= await pool.request()
                    .input('inCategoryName', sql.NVARCHAR(64),category)
                    .input('inDescription', sql.NVARCHAR(128),description)
                    .input('inPrice', sql.Money,price).
                    input('inUsername', sql.NVARCHAR(32),user).
                    input('inUserIP', sql.NVARCHAR(64),ip).
                    output('outResultCode', sql.Int).
                    execute('SP_ItemInsert');
    res.json(result.output.outResultCode)
}