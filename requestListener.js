const url = require('url');

module.exports = function requestListener(req, res) {
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.write('Hello Client!');
    const data = url.parse(req.url, true).query;
    console.dir(data);
    res.write(`url: ${req.url}`);
    res.end();
};
