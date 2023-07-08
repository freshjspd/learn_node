const productsDB = require("./data/db_products.json");

class Product {
  constructor(data) {
    this.products = [...data];
    this.k = data.length; // for id
  }
  getAllProducts() {
    return [...this.products];
  }
  getProductById(id) {
    const foundIndex = this.products.findIndex((p) => p.id == id);
    return foundIndex == -1 ? null : this.products[foundIndex];
  }
  createProduct(info) {
    k++;
    const newProduct = this.products.push({ ...info, id: k });
    return newProduct;
    // return this.products.push({...info, id: ++k});
  }
  updateProductById(id, info) {
    const foundIndex = this.products.findIndex((p) => p.id == id);
    return foundIndex == -1 
        ? null 
        : (this.products[foundIndex] = {...this.products[foundIndex], ...info});
  }
  deleteProductById(id) {
    const foundIndex = this.products.findIndex((p) => p.id == id);
    return foundIndex == -1 ? null : this.products.splice(foundIndex, 1);
  }
}

const productsModel = new Product(productsDB);

module.exports = productsModel;
