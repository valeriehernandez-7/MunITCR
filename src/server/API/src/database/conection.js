import sql, { pool } from 'mssql'
import {config} from 'dotenv'
config() 

const dbsettings = {
    user : process.env.USER,
    password: process.env.PASSWORD,
    server : process.env.SERVER,
    database : process.env.DATABASE,
    options: {
        encrypt: true,
        trustServerCertificate: true
    }
} 
export async function getConection(){
    try{
        const pool = await sql.connect(dbsettings)
        return pool;
    }catch(err){
        console.log(err)
    }
}



//const result = await pool.request().query("Select * from item")
//console.log(result)