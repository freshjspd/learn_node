const usersDB = require("./data/db_users.json");

class User{
    constructor(data){
        this.users = [...data];
    }
    getAllUsers(){}
    getUserById(id){}
    createUser(){}
    updateUserById(id){}
    deleteUserById(id){}
}

const usersModel = new User(usersDB);

module.exports = usersModel;