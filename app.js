const express = require('express');
const Router = require('./router');
const app = express();

app.use(express.json());
app.use(express.static('public'));
app.use('/api', Router);

module.exports = app;