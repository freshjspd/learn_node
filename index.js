const http = require('http');

const app = require('./app.js');

const server = http.createServer(app);

const PORT = process.env.PORT || 5000;
const HOST = process.env.HOST || '127.0.0.1';

server.listen(PORT, HOST, () => {
  console.log(`Server is listening ${HOST} 
  on ${PORT} port!`);
});

