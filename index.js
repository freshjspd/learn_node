const http = require('http');
const bcrypt = require('bcrypt');
const requestListener = require('./requestListener.js');
const PORT = 3000;

const password = 'admin';
const passwordHash = bcrypt.hashSync(password, 10);
console.log('password hash is ', passwordHash);

const server = http.createServer(requestListener);
server.listen(PORT);


