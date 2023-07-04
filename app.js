const express = require("express");
const app = express();
app.use(express.json());
app.use("/", express.static("public"));

app.get("/", (req, res) => {});

module.exports = app;
