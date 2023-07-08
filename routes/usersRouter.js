const {Router} = require("express");
const {usersController} = require('../controllers');

const usersRouter = Router();
usersRouter.get("/", usersController.getUsers);
usersRouter.get("/:id", usersController.getUser);
usersRouter.post("/", usersController.createNewUser);
usersRouter.patch("/:id", usersController.updateUser);
usersRouter.delete("/:id", usersController.deleteUser);

module.exports = usersRouter;