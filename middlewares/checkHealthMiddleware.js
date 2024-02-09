const checkHealthMiddleware = (req, res, next) => {
  if (req.method !== 'GET') {
    console.error('Method Not Allowed: ', req.method);
    return res.status(405).header('Cache-Control', 'no-cache').send(); // Method Not Allowed
  }
  if (Object.keys(req.body).length > 0||Object.keys(req.query).length > 0) {
    console.error('Bad Request: Request contains body or parameters');
    return res.status(400).header('Cache-Control', 'no-cache').send(); // Bad Request
  }
  next();
};
  
module.exports = checkHealthMiddleware;
  
