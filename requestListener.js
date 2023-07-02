// request - запрос. запрос от клиента, что он хочет
// response - ответ. отклик сервера на запрос клиента

const fs = require("fs");
const path = require("path");
const util = require("util");

const readFile = util.promisify(fs.readFile);

module.exports = function requestListener(req, res) {
  const { url, method } = req;
  console.log("client request: ", url, method);

  if (method == "GET") {
    const page = url == "/" ? "index.html" : url;
    const regHTMLPage = /^.*\.html$/;
    if (regHTMLPage.test(page)) {
      const pagePath = path.join(__dirname, "/pages/", page);
      console.log(pagePath);
      if (fs.existsSync(pagePath, { encoding: "utf-8" })) {
        readFile(pagePath)
          .then((data) => {
            res.statusCode = 200;
            res.setHeader("Content-Type", "text/html");
            res.end(data);
          })
          .catch((error) => {
            res.statusCode = 500;
            res.end("Server data error!");
          });
      } else {
        readFile(path.join(__dirname, "/pages/", "404.html"))
          .then((data) => {
            res.statusCode = 404;
            res.setHeader("Content-Type", "text/html");
            res.end(data);
          })
          .catch((error) => {
            res.statusCode = 500;
            res.end("Server data error!");
          });
      }
    }
  } else {
    res.statusCode = 400;
    res.end("Bad server request");
  }
};
