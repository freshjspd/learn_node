const {User} = require("./db/models");

// создать нового юзера 1
/*
User.create({
    firstName: "John",
    lastName: "Smith",
    email: "john.smith@mail.com",
    login: "john_superman",
    passwordHash: "qwerty-123-zx-rt6-asdkjjqwe2312-fsd",
    age: 20
}).then(console.log);
*/

// создать нового юзера 2
/*
User.create({
    firstName: "Ann",
    lastName: "Smith",
    email: "ann.smith@mail.com",
    login: "ann7",
    passwordHash: "qwerty-123-zx-rt6-asdkjjqwe2312-fsd",
}).then(console.log);
*/

// отобразить всех юзеров
//User.findAll().then(console.log);

/*
User.findAll(
    {attributes:
        {exclude: ["createdAt", "updatedAt", "passwordHash", "id"]}
    }
).then(console.log);
*/

// найти 2 юзера
User.findByPk(2).then(console.log);
