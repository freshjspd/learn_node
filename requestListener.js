// request - запрос. запрос от клиента, что он хочет
// response - ответ. отклик сервера на запрос клиента

const fs = require('fs');
const path = require('path');
const util = require('util');

//const readFile = util.promisify(fs.readFile);

module.exports = 
function requestListener(req, res){
    const {url, method} = req;
    console.log('client request: ', url, method);

    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/html');
    const file = fs.readFileSync('./pages/about.html', {
        encoding: 'utf8',
    });
    res.end(file);
}