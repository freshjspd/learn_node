const { Router } = require("express");
const { productsController } = require("../controllers");

const productsRouter = Router();

/*
productsRouter.get("/", productsController.getProducts);
productsRouter.get("/:id", productsController.getProduct);
productsRouter.post("/", productsController.createNewProduct);
productsRouter.patch("/:id", productsController.updateProduct);
productsRouter.delete("/:id", productsController.deleteProduct);
*/

productsRouter
  .route("/")
  .get(productsController.getProducts)
  .post(productsController.createNewProduct);

productsRouter
  .route("/:id")
  .get(productsController.getProduct)
  .patch(productsController.updateProduct)
  .delete(productsController.deleteProduct);

module.exports = productsRouter;
