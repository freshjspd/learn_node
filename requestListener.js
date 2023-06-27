// req - request запрос
// res - response ответ (отклик)

module.exports = function requestListener(req, res){
    const {url, method} = req;
    res.end(`Hello, client! Yout method is ${method} in url ${url}`);
}