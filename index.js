const http = require('http');
const requestListener = require('./requestListener');
const server = http.createServer(requestListener);
const PORT = process.env.PORT || 3000;
const HOST = process.env.HOST || '127.0.0.1';
server.listen(PORT, HOST, () => {
  console.log(`Server is listening ${HOST} 
  on ${PORT} port!`);
});

