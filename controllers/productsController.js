const {Product} = require('./../models');

module.exports.getProducts = (req, res) => {
    const data = Product.getAllProducts();
    res.status(200).send(data);
}

module.exports.getProduct = (req, res) => {
    const foundProduct = Product.getProductById(req.params.id);
    if(foundProduct){
        res.status(201).send(foundProduct);
        return;
    }
    res.status(404).send(`User # ${req.params.id} not found`);
}

module.exports.createNewProduct = (req, res) => {
    const newProduct = Product.createProduct(req.body);
    res.status(200).send(newProduct);
}

module.exports.updateProduct = (req, res) => {
    const foundProduct = Product.updateProductById(req.params.id, req.body);
    if(foundProduct){
        res.status(201).send(foundProduct);
        return;
    }
    res.status(404).send(`User # ${req.params.id} not found`);
}

module.exports.deleteProduct = (req, res) => {
    const foundProduct = Product.deleteProductById(req.params.id);
    if(foundProduct){
        res.status(201).send(foundProduct);
        return;
    }
    res.status(404).send(`User # ${req.params.id} not found`);
}