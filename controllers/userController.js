const {Users} = require('./../models');

//CRUD for user

module.exports.getAllUsers = (req, res) => {
      const data = Users.getAllUsers();
      res.status(200).send(data);
};

module.exports.getUser = (req, res) => {
      const {id} = req.params;
      const foundUser = Users.getUserById(id);
      if(foundUser){
            res.status(200).send(foundUser);
            return;
      } else{
            res.status(404).send(`User # ${id} not found in database.`)
      }
};

module.exports.createUser = (req, res) => {
      const {body} = req;
      const newUser = Users.createUser(body);
      if(newUser){
            res.status(201).send(newUser);
            return;
      } else{
            res.status(400).send('Bad request. New user is not created')
      }
};

module.exports.updateUser = (req, res) => {
      const {id} = req.params;
      const {body} = req;
      const foundUser = Users.updateUser(id, body);
      if(foundUser){
            res.status(200).send(foundUser);
            return;
      } else{
            res.status(404).send(`User # ${id} not found in database.`)
      }
};
  
module.exports.deleteUser = (req, res) => {
    const {id} = req.params;
    const foundUser = Users.deleteUser(id);
    if(foundUser){
      res.status(200).send(foundUser);
      return;
} else{
      res.status(404).send(`User # ${id} not found in database.`)
}
};