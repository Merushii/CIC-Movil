const mysql = require('mysql2');
const dotenv = require('dotenv');

dotenv.config({ path: './env/.env' });

const connection = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_DATABASE
});

connection.connect((err) => {
  if (err) {
    console.error('El error de conexion es: ' + err.stack);
    return;
  }
  console.log('Conectado a la base de datos');
});

module.exports = connection;
