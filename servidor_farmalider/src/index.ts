import express from 'express';
import bodyParser from 'body-parser';
import cors from 'cors';
import ProductRoutes from './routes/ProductRoutes';

// Crear una instancia de la aplicación
const app = express();
const port = 3000;

// Configurar CORS para permitir solicitudes desde cualquier dominio
app.use(cors());

// Configurar body-parser para que pueda recibir JSON
app.use(bodyParser.json({ limit: '30mb' }));
app.use(bodyParser.urlencoded({ limit: '30mb', extended: true }));

// Rutas para los productos
app.use('/farmalider', ProductRoutes);

// Middleware para manejar errores
app.use((err: any, req: express.Request, res: express.Response, next: express.NextFunction) => {
  console.error(err.stack);  // Muestra el stack trace del error en la consola
  res.status(500).json({ message: 'Algo salió mal, por favor intente más tarde.' });
});

// Iniciar el servidor
app.listen(3000, '0.0.0.0', () => {
  console.log('Servidor corriendo en http://192.168.20.71:3000');
});
