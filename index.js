const http = require('http');
const requestListener = require('./requestListener.js');
const PORT = 3000;

const server = http.createServer(requestListener);
server.listen(PORT);


