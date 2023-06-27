// req - request запрос
// res - response ответ (отклик)

module.exports = function requestListener(req, res){
    const {url, method} = req;
    console.log('url = ', url);
    console.log('method = ', method);
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/html');
    res.end(`<!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
    </head>
    <body>
    <h1>Home page</h1>
    <p>About documentation
    There are several types of documentation available on this website:
    
    API reference documentation
    ES6 features
    Guides
    API reference documentation
    The API reference documentation provides detailed information about a function or object in Node.js. This documentation indicates what arguments a method accepts, the return value of that method, and what errors may be related to that method. It also indicates which methods are available for different versions of Node.js.
    
    This documentation describes the built-in modules provided by Node.js. It does not document modules provided by the community.
    
    </p>    
    </body>
    </html>`);
}