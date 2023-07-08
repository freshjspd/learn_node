const {Router} = require("express");
const {productsController} = require('../controllers');

const productsRouter = Router();
productsRouter.get("/", productsController.getProducts);
productsRouter.get("/:id", productsController.getProduct);
productsRouter.post("/", productsController.createNewProduct);
productsRouter.patch("/:id", productsController.updateProduct);
productsRouter.delete("/:id", productsController.deleteProduct);

module.exports = productsRouter;

