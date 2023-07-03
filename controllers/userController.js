const {Users} = require('./../models');

//CRUD for user

module.exports.getAllUsers = (req, res) => {
      const data = Users.getAllUsers();
      res.status(200).send(data);
};

module.exports.getUser = (req, res) => {
      const {id} = req.params;
      const foundUser = Users.getUserById(id);
      res.status(200).send(foundUser);
};

module.exports.createUser = (req, res) => {
      const {body} = req;
      const newUser = Users.createUser(body);
      res.status(201).send(newUser);
};

module.exports.updateUser = (req, res) => {
      const {id} = req.params;
      const {body} = req;
      const foundUser = Users.updateUser(id, body);
      res.status(200).send(foundUser);
};
  
module.exports.deleteUser = (req, res) => {
    const {id} = req.params;
    const foundUser = Users.deleteUser(id);
    res.status(200).send(foundUser);
};