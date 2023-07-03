const express = require('express');

const app = express();
app.use(express.json());


app.get('/', (req, res) => {
    //console.log('user request: ', req);
    res.status(200).end();
});

app.post('/users', (req, res) => {
    const {body} = req;
    console.log(body);
    res.status(201).send(body);
});

/*
// получить всех пользователей
app.get('/users/', (req, res) => {});
// получить одного пользователя по id
app.get('/users/id', (req, res) => {});
// создание нового юзера и добавление его в базу
app.post('/users/', (req, res) => {
    const {body} = req;
    res.status(201).send(body);
    console.log(body);
});
// обновление инфы юзера
app.patch('/users/id', (req, res) => {});
// удаление юзера
app.delete('/users/id', (req, res) => {});


// tasks
app.get('/tasks/', (req, res) => {});
app.get('/tasks/id', (req, res) => {});
app.post('/tasks/', (req, res) => {});
app.patch('/tasks/id', (req, res) => {});
app.delete('/tasks/id', (req, res) => {});
*/


module.exports = app;
