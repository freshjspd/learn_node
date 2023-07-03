const usersDB = require('./data/users.json');
 
  class Users{
    constructor(data){
        this.users = [...data];
        this.count = this.users.length;
    }
    createUser(user){
        this.count++;
        this.users.push({...user, id: this.count});
        return this.users[this.count - 1];
    }
    getUserById(id){
        const foundIndex = this.users.findIndex(u => u.id === Number(id));
        return foundIndex === -1 ? null : this.users[foundIndex];
    }
    getAllUsers(){
        return [...this.users];
    }
    updateUser(id, info){
        const foundIndex = this.users.findIndex(u => u.id === Number(id));
        this.users[foundIndex] = {
            ...this.users[foundIndex],
            ...info
        };
        return foundIndex === -1 ? null : this.users[foundIndex];
    }
    deleteUser(id){
      const foundIndex = this.users.findIndex(u => u.id === Number(id));
      //this.count--;
      return foundIndex === -1 ? null : this.users.splice(foundIndex, 1);
    }
}

const usersModel = new Users(usersDB);

module.exports = usersModel;