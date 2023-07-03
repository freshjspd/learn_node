const path = require('path');
const express = require('express');

const app = express();
app.use(express.json());
app.use('/', express.static("public"));

app.use('*', (req, res) => {
    res.status(404).sendFile(path.resolve(__dirname, '404.html'));
})


module.exports = app;