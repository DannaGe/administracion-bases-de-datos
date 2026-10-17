import express from 'express'
import { createPool } from 'mysql2/promise'
import { config } from 'dotenv'
config()

// Crear la aplicacion
const app = express()

//Verificar que funcione
const mi_json ={
    "Host": process.env.MYSQL_HOST,
    "Puerto": process.env.MYSQL_PORT
}
console.log(mi_json)

// Crear Pool de conexiones
const pool = createPool({
    host: process.env.MYSQL_HOST,
    user: process.env.MYSQL_USER,
    password: process.env.MYSQL_PASSWORD,
    port: process.env.MYSQL_DOCKER_PORT,
    database: process.env.MYSQL_DATABASE
})

// Crear la ruta principal
app.get('/', (req,res) => { 
    res.send("<center><h2></h2>Bienvenidos al Backend de Danna</center></h2><hr color='blue'>")
})

// Vamos a crear la ruta a productos
app.get('/productos', async (req,res) => {
    const respuesta = await pool.query("SELECT * FROM productos")
    res.json(respuesta[0])
})

//Puertopor donde se ecuchara el servidor express
app.listen(process.env.NODE_DOCKER_PORT)
console.log('Server de Backend funcionando en el puerto:', process.env.NODE_DOCKER_PORT)