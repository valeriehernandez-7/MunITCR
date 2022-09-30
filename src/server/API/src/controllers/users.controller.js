const sql = require('mssql')
import {getConection} from '../database/conection';

export const login = async (req, res) => {
    const pool= await getConection()
    //const {username, password} = req.body; 
    var username = req.query.usuario;
    var password = req.query.pass;
    if (username==null || password==null){
        console.log("bad data")
    } 
    const result= await pool.request()
                    .input('inUsername', sql.NVARCHAR(64),username)
                    .input('inPassword', sql.NVARCHAR(64),password)                    
                    .output('outResultCode', sql.Int).
                    execute('SP_Login');
    console.log(result.output.outResultCode);
    res.json(result.output.outResultCode);
        
}