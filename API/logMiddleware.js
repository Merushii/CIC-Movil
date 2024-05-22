// logMiddleware.js

// Middleware para registrar los encabezados de la solicitud en la consola
const logMiddleware = (req, res, next) => {
    // Registra los encabezados de la solicitud en la consola
    console.log('Headers:', req.headers);
    
    // Llama a la siguiente función de middleware en la cadena
    next();
  };
  
  // Exporta el middleware para su uso en otros archivos
  module.exports = logMiddleware;
  