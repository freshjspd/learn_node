const {Router} = require("express");
const usersRouter = require("./routes");
const productsRouter = require("./routes");
const appRouter = Router();

appRouter.use("/users", usersRouter); // http://127.0.0.1/api/users
appRouter.use("/products", productsRouter); // http://127.0.0.1/api/products

module.exports = appRouter;