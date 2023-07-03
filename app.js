const path = require("path");
const express = require("express");

const {userController} = require('./controllers');

const app = express();

app.use(express.json());
app.use("/", express.static("public"));

// get all users
app.get("/users", userController.getAllUsers);
// get user by id
app.get("/users/:id", userController.getUser);
// create new user
app.post("/users", userController.createUser);
// update user by id
app.patch("/users/:id", userController.updateUser);
// delete user by id
app.delete("/users/:id", userController.deleteUser);

module.exports = app;
