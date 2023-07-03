const path = require("path");
const express = require("express");

const app = express();

app.use(express.json());
app.use("/", express.static("public"));

//db
const usersDB = [
  {
    id: 1,
    gender: "female",
    name: { title: "Ms", first: "Jennie", last: "Jennings" },
    location: {
      street: { number: 6022, name: "Fairview St" },
      city: "Sunshine Coast",
      state: "Tasmania",
      country: "Australia",
      postcode: 9273,
    },
    email: "jennie.jennings@example.com",
    login: {
      uuid: "77e894cb-0961-4eb3-a17b-0bf4a30b952d",
      username: "sadbird753",
      sha1: "9eacd9d26e36f270dc3bc82af0d3259648078c2d",
    },
    registered: { date: "2007-05-27T03:09:22.443Z", age: 16 },
    phone: "02-0763-1855"
  },
  {
    id: 2,
    gender: "female",
    name: { title: "Mrs", first: "Bernabé", last: "Villanueva" },
    location: {
      street: { number: 7178, name: "Peatonal Eslovenia" },
      city: "Ayutla",
      state: "Tamaulipas",
      country: "Mexico",
      postcode: 29483,
    },
    email: "bernabe.villanueva@example.com",
    login: {
      uuid: "2f63bb1d-385d-4d3f-95dd-cc1c479c9225",
      username: "tinyrabbit803",
      sha1: "ff6068af6b5f9d81f5feb07e1e6e34f64e417de1",
    },
    registered: { date: "2017-07-29T02:50:45.096Z", age: 5 },
    phone: "(645) 861 1319"
  },
  {
    id: 3,
    gender: "male",
    name: { title: "Mr", first: "Jack", last: "Gardner" },
    location: {
      street: { number: 9212, name: "Victoria Street" },
      city: "Edinburgh",
      state: "Gwent",
      country: "United Kingdom",
      postcode: "G3V 6AD",
    },
    email: "jack.gardner@example.com",
    login: {
      uuid: "64cef461-0f4a-4857-8ad8-cd4bfc5c12af",
      username: "ticklishleopard780",
      sha1: "8874e0fcbc36e3258c117c28e7d71a8d3b389a8e",
    },
    registered: { date: "2007-05-31T21:20:54.251Z", age: 16 },
    phone: "017684 68698"
  },
  {
    id: 4,
    gender: "female",
    name: { title: "Mademoiselle", first: "Yvonne", last: "Lemoine" },
    location: {
      street: { number: 3483, name: "Rue Barrier" },
      city: "Tschiertschen-Praden",
      state: "Zug",
      country: "Switzerland",
      postcode: 7975,
    },
    email: "yvonne.lemoine@example.com",
    login: {
      uuid: "f9c556ee-ad5b-49d6-a1e4-e56f34c63c67",
      username: "browntiger386",
      sha1: "4a27e117e4f0d515ab548627281c4bf32bc39938",
    },
    registered: { date: "2022-01-27T20:00:01.480Z", age: 1 },
    phone: "077 273 42 22"
  },
  {
    id: 5,
    gender: "male",
    name: { title: "Mr", first: "Nobre", last: "da Rocha" },
    location: {
      street: { number: 2541, name: "Rua Rui Barbosa " },
      city: "Santo André",
      state: "Tocantins",
      country: "Brazil",
      postcode: 41852,
    },
    email: "nobre.darocha@example.com",
    login: {
      uuid: "b5849cf5-de9f-44df-993f-a05b53eb2814",
      username: "brownzebra671",
      sha1: "342755a5363675279e7b3ed2547b2cdd0a90efd4",
    },
    registered: { date: "2009-05-06T20:41:56.135Z", age: 14 },
    phone: "(32) 8615-0218"
  },
  {
    id: 6,
    gender: "male",
    name: { title: "Mr", first: "Brennan", last: "Gibson" },
    location: {
      street: { number: 7240, name: "Thornridge Cir" },
      city: "Murrieta",
      state: "Montana",
      country: "United States",
      postcode: 50599,
    },
    email: "brennan.gibson@example.com",
    login: {
      uuid: "14ebd987-27fe-4a3b-b44f-1d524175ce2d",
      username: "crazyzebra175",
      sha1: "0ed48c804fbecec3cd1dc869a4aaafe3adb33a55",
    },
    registered: { date: "2009-09-09T17:48:22.183Z", age: 13 },
    phone: "(414) 479-1875"
  },
];

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
        return this.users[foundIndex];
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
        return this.users[foundIndex];
    }
    deleteUser(id){
      const foundIndex = this.users.findIndex(u => u.id === Number(id));
      //this.count--;
      return foundIndex === -1 ? null : this.users.splice(foundIndex, 1);
    }
}

const usersInstance = new Users(usersDB);

//CRUD for user
// controller for user

// get all users
app.get("/users", (req, res) => {
    const data = usersInstance.getAllUsers();
    res.status(200).send(data);
});
// get user by id
app.get("/users/:id", (req, res) => {
    const {id} = req.params;
    const foundUser = usersInstance.getUserById(id);
    res.status(200).send(foundUser);
});
// create new user
app.post("/users", (req, res) => {
    const {body} = req;
    const newUser = usersInstance.createUser(body);
    res.status(201).send(newUser);
});
// update user by id
app.patch("/users/:id", (req, res) => {
    const {id} = req.params;
    const {body} = req;
    const foundUser = usersInstance.updateUser(id, body);
    res.status(200).send(foundUser);
});
// delete user by id
app.delete("/users/:id", (req, res) => {
  const {id} = req.params;
  const foundUser = usersInstance.deleteUser(id);
  res.status(200).send(foundUser);
});

module.exports = app;
