// request - запрос. запрос от клиента, что он хочет
// response - ответ. отклик сервера на запрос клиента

module.exports = 
function requestListener(req, res){
    const {url, method} = req;
    console.log('client request: ', url, method);

    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/html');
    res.end(`<!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Test page</title>
    </head>
    <body>
        <h1>Lorem ipsum dolor sit amet.</h1>
        <p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Laboriosam maiores eos, dolor tempora alias dolore, pariatur illum culpa explicabo earum porro minima deserunt suscipit aspernatur laudantium. Quo, nemo quibusdam. Quisquam laborum, nihil ipsa ad fugiat eveniet in dolorem recusandae animi porro, totam quibusdam distinctio omnis et iure? Earum assumenda maiores, dolore vitae, esse itaque delectus aliquid tenetur commodi architecto in cumque dignissimos. Itaque alias eveniet deleniti nobis dolores accusantium, quisquam obcaecati molestias autem aperiam dicta tempora? Exercitationem harum vitae minima numquam a inventore illo mollitia iure alias provident quas tempore, dolore culpa quia! Alias ipsam laborum dolorum consectetur et nesciunt.</p>
    </body>
    </html>`);
}