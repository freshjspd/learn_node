const http = require("http");
const app = require("./app");

const PORT = process.env.PORT || 5000;
const HOST = process.env.HOST || "127.0.0.1";

const server = http.createServer(app);

server.listen(PORT, HOST, () => {
    console.log(`Server is working on ${PORT} port for ${HOST}`)
});