const http = require('http');
const requestListener = require('./requestListener.js');
const PORT = 3000;
const HOST = '127.0.0.1' // 'localhost'

const server = http.createServer(requestListener);
server.listen(PORT, HOST, () => {
    console.log(`Server is listening ${HOST} on ${PORT} port`);
});


