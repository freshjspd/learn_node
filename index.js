const http = require('http');

const server = http.createServer(requestListener);
server.listen(3000);

let count = 0;

function requestListener(request, response){
    ++count;
    console.log(`It is request listener function. count = ${count}`);
    response.end(`Hello, client! msg # ${count}`);
}

