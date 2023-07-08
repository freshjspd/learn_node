const {Product} = require('./../models');

module.exports.getProducts = (req, res, next) => {
    const data = Product.getAllProducts();
    res.status(200).send(data);
    next();
}

module.exports.getProduct = (req, res, next) => {
    const foundProduct = Product.getProductById(req.params.id);
    if(foundProduct){
        res.status(201).send(foundProduct);
        return;
    }
    res.status(404).send(`User # ${req.params.id} not found`);
    next();
}

module.exports.createNewProduct = (req, res, next) => {
    const newProduct = Product.createProduct(req.body);
    res.status(200).send(newProduct);
    next();
}

module.exports.updateProduct = (req, res, next) => {
    const foundProduct = Product.updateProductById(req.params.id, req.body);
    if(foundProduct){
        res.status(200).send(foundProduct);
        return;
    }
    res.status(404).send(`User # ${req.params.id} not found`);
    next();
}

module.exports.deleteProduct = (req, res, next) => {
    const foundProduct = Product.deleteProductById(req.params.id);
    if(foundProduct){
        res.status(200).send(foundProduct);
        return;
    }
    res.status(404).send(`User # ${req.params.id} not found`);
    next();
}