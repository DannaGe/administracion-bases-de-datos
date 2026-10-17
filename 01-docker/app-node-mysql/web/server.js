import express from 'express';
import axios from 'axios';

const app = express();

// Configurar EJS como motor de vistas
app.set('view engine', 'ejs');
app.set('views', './views');

// Ruta principal que obtiene los productos desde el backend
app.get('/', async (req, res) => {
    try {
        const response = await axios.get('http://backend:3000/productos');
        res.render('index', { productos: response.data });
    } catch (error) {
        console.error("Error obteniendo los productos:", error);
        res.status(500).send("Error obteniendo los productos.");
    }
});

// Puerto de escucha
app.listen(5000, () => {
    console.log("Servidor web corriendo en el puerto 5000");
});
