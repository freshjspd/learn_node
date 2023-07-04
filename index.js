/*
const http = require('http');

const app = require('./app.js');

const server = http.createServer(app);

const PORT = process.env.PORT || 5000;
const HOST = process.env.HOST || '127.0.0.1';

server.listen(PORT, HOST, () => {
  console.log(`Server is listening ${HOST} 
  on ${PORT} port!`);
});
*/

const {User} = require("./models");

/*
User.create({
  firstName: "John",
  lastName: "Adson",
  email: "john.adson@mail.com"
}).then(console.log);
*/

/*
User.findByPk(1).then(console.log);
*/

/*
User.create({
  firstName: "Kate",
  lastName: "Smith",
  email: "kate123@mail.com"
}).then(console.log);
*/


//User.findAll().then(console.log);

User.findAll({attributes: {exclude: ["createdAt", "updatedAt"]}}).then(console.log);