const express = require('express');
const app = express();
const bcryptjs = require('bcryptjs');
const cors = require('cors');
const morgan = require('morgan');
const jwt = require('jsonwebtoken');
const dotenv = require('dotenv');
const session = require('express-session');
const connection = require('./database'); // Asegúrate de que el archivo de la base de datos se llame 'database.js'
const logMiddleware = require('./logMiddleware');

dotenv.config({ path: './env/.env' });

app.use(express.urlencoded({ extended: false }));
app.use(express.json());
app.use(morgan('dev'));
app.use(logMiddleware);

app.use(session({
  secret: 'secret',
  resave: true,
  saveUninitialized: true
}));

app.use(cors());
app.use(morgan('dev'));

// Middleware para verificar el token JWT
const validarJWT = (req, res, next) => {
  const token = req.headers.authorization && req.headers.authorization.split(' ')[1];
  if (!token) {
    return res.status(401).json({ mensaje: 'Token no proporcionado' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.userId = decoded.userId;
    next();
  } catch (err) {
    return res.status(401).json({ mensaje: 'Token no válido' });
  }
};

// Endpoint para obtener el nombre de usuario
app.get('/username', validarJWT, (req, res) => {
  const idUsuario = req.userId;

  const query = 'SELECT NombreUsuario FROM usuarios WHERE IdUsuario = ?';

  connection.query(query, [idUsuario], (err, resultados) => {
    if (err) {
      console.error('Error al ejecutar la consulta: ', err);
      return res.status(500).json({ mensaje: 'Error al obtener el nombre de usuario' });
    }

    if (resultados.length > 0) {
      const nombreUsuario = resultados[0].NombreUsuario;
      return res.json({ username: nombreUsuario });
    } else {
      return res.status(404).json({ mensaje: 'Usuario no encontrado' });
    }
  });
});

// Endpoint para obtener solicitudes del usuario
app.get('/historialsolicitudesAppMovil', validarJWT, (req, res) => {
  const idUsuario = req.userId;

  console.log(`Obteniendo historial de solicitudes para IdUsuario: ${idUsuario}`);

  const query = `
    SELECT 
      s.FolioSolicitud AS FolioSolicitud, 
      s.Fecha AS Fecha, 
      s.Equipo AS Equipo, 
      s.Estado AS Estado,
      s.Descripcion AS Descripcion  
    FROM solicitudes s 
    WHERE s.IdUsuario = ? 
    ORDER BY FolioSolicitud DESC;
  `;

  connection.query(query, [idUsuario], (err, resultados) => {
    if (err) {
      console.error('Error al ejecutar la consulta: ', err);
      res.status(500).json({ mensaje: 'Error al obtener el historial de solicitudes' });
      return;
    }
    res.json(resultados);
  });
});


// Endpoint para crear una solicitud
app.post('/solicitudesAppMovil', validarJWT, (req, res) => {
  const { description, type } = req.body;

  if (!description || !type) {
    return res.status(400).json({ mensaje: 'Faltan campos requeridos' });
  }

  const idUsuario = req.userId;
  const fecha = obtenerFechaActualMovil();
  const hora = obtenerHoraActual();
  const telefono = req.body.telefono || '1234567890';
  const idEdificio = req.body.idEdificio || 1;
  const ubicacionFisica = req.body.ubicacionFisica || 'Ubicación';
  const equipo = req.body.equipo || 'Equipo';
  const estado = 'Abierto';
  const idAsignacion = 1;

  const query = `
    INSERT INTO solicitudes (Descripcion, IdUsuario, Fecha, Hora, Telefono, IdEdificio, UbicacionFisica, Equipo, Estado, IdAsignacion)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `;

  connection.query(query, [description, idUsuario, fecha, hora, telefono, idEdificio, ubicacionFisica, equipo, estado, idAsignacion], (err, resultados) => {
    if (err) {
      console.error('Error al insertar la solicitud: ', err);
      res.status(500).json({ mensaje: 'Error al insertar la solicitud' });
      return;
    }
    res.status(201).json({ mensaje: 'Solicitud creada correctamente' });
  });
});

// Endpoint para realizar el login
app.post('/loginMovil', (req, res) => {
  const { username, password } = req.body;

  connection.query('SELECT * FROM usuarios WHERE NombreUsuario = ?', [username], async (error, resultados) => {
    if (error) {
      console.error('Error en la consulta a la base de datos:', error);
      res.status(500).json({ mensaje: 'Error en el servidor' });
      return;
    }

    if (resultados.length === 0 || !(await bcryptjs.compare(password, resultados[0].Contrasena))) {
      res.status(401).json({ mensaje: 'Credenciales incorrectas' });
    } else if (resultados[0].Rol !== 'Usuario') {
      res.status(403).json({ mensaje: 'Acceso no autorizado' });
    } else {
      const token = jwt.sign({ userId: resultados[0].IdUsuario }, process.env.JWT_SECRET, { expiresIn: '12h' });
      req.session.userId = resultados[0].IdUsuario;
      req.session.userName = resultados[0].NombreUsuario;

      console.log(`Sesión iniciada para usuario: ${resultados[0].NombreUsuario}, IdUsuario: ${resultados[0].IdUsuario}`);

      res.status(200).json({ mensaje: 'Inicio de sesión exitoso', token: token });
    }
  });
});

// Endpoint para verificar el funcionamiento de la API
app.get('/', (req, res) => {
  res.send('Bienvenido a la API de Solicitudes');
});

// Iniciar el servidor
const PORT = process.env.PORT || 3004;
app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});

// Función para obtener la fecha actual en formato MySQL
function obtenerFechaActualMovil() {
  const fecha = new Date();
  const año = fecha.getFullYear();
  const mes = String(fecha.getMonth() + 1).padStart(2, '0');
  const dia = String(fecha.getDate()).padStart(2, '0');
  return `${año}-${mes}-${dia}`;
}

// Función para obtener la hora actual en formato MySQL
function obtenerHoraActual() {
  const fecha = new Date();
  const horas = String(fecha.getHours()).padStart(2, '0');
  const minutos = String(fecha.getMinutes()).padStart(2, '0');
  const segundos = String(fecha.getSeconds()).padStart(2, '0');
  return `${horas}:${minutos}:${segundos}`;
}

module.exports = app;
