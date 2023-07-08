const {Router} = require("express");
const usersRouter = require("./routes");
const tasksRouter = require("./routes");
const appRouter = Router();

appRouter.use("/users", usersRouter); // http://127.0.0.1/api/users
appRouter.use("/tasks", tasksRouter); // http://127.0.0.1/api/tasks

module.exports = appRouter;