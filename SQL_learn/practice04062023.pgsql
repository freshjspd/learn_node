/*
0 Groups
- id
- name

1 table Roles 
- id 
- name 
- description
- idGroup

2 table Users
- id
- email 
- login  
- passwordHash
- fullName
- idRole
*/

CREATE TABLE Groups(
  id serial PRIMARY KEY,
  name varchar(100) NOT NULL
);

CREATE TABLE Roles(
  id serial PRIMARY KEY,
  name varchar(100) NOT NULL,
  description text,
  idGroup integer REFERENCES Groups(id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Users(
  id serial PRIMARY KEY,
  email varchar(255) NOT NULL UNIQUE,
  login varchar(255) NOT NULL UNIQUE,
  passwordHash text NOT NULL,
  fullName varchar(255) NOT NULL,
  idRole integer REFERENCES Roles(id) ON DELETE SET NULL ON UPDATE CASCADE
);

INSERT INTO Groups(name) VALUES
('users_dev'), ('users_home'), ('users_main'), ('moderator'), ('super');

/*
DELETE FROM Roles;
DELETE FROM Users;

SELECT * 
FROM Roles;
*/

INSERT INTO Roles (name, idGroup) VALUES
('starter', 1), ('begginer', 1), ('middle', 1), ('senior', 3),
('uknown', 2), ('guest', 2), ('moderator_db', 4), ('moderator_net', 4),
('moderator_pro', 4), ('admin_db', 5), ('admin_pro', 5);

INSERT INTO Users(email, login, passwordHash, fullName, idRole) VALUES
('man1@mail.com', 'man1', 'qwerty', 'man1 man1', 12),
('man2@mail.com', 'man2', 'qwerty', 'man2 man2', 21),
('man3@mail.com', 'man3', 'qwerty', 'man3 man3', 12),
('man4@mail.com', 'man4', 'qwerty', 'man4 man4', 13),
('man5@mail.com', 'man5', 'qwerty', 'man5 man5', 18),
('man6@mail.com', 'man6', 'qwerty', 'man6 man6', 18),
('man7@mail.com', 'man7', 'qwerty', 'man7 man7', 13),
('man8@mail.com', 'man8', 'qwerty', 'man8 man8', 20),
('man9@mail.com', 'man9', 'qwerty', 'man9 man9', 19),
('man10@mail.com', 'man10', 'qwerty', 'man10 man10', 22),
('man11@mail.com', 'man11', 'qwerty', 'man11 man11',14),
('man12@mail.com', 'man12', 'qwerty', 'man12 man12', 14),
('man13@mail.com', 'man13', 'qwerty', 'man13 man13', 15),
('man14@mail.com', 'man14', 'qwerty', 'man14 man14', 12),
('man15@mail.com', 'man15', 'qwerty', 'man15 man15', 15);

/* список ролей в группе 'users_dev'*/
SELECT Roles.name
FROM Roles 
WHERE idGroup = 1;

SELECT Roles.name
FROM Roles, Groups
WHERE Groups.name = 'users_dev' and Groups.id = Roles.idGroup;

/* список людей по роли 'starter'*/
SELECT login, fullName
FROM Users
WHERE idRole = 1;

SELECT Users.login, Users.fullName
FROM Users, Roles
WHERE Roles.name = 'starter' and Users.idRole = Roles.id;

/* список людей в группе 'users_dev'*/
SELECT Users.login, Users.fullName, Users.email, Roles.name
FROM Users, Roles
WHERE Roles.idGroup = 1 and Users.idRole = Roles.id;

SELECT Users.login, Users.fullName, Users.email, Roles.name, Groups.name
FROM Users, Roles, Groups
WHERE Groups.name = 'users_dev' and Users.idRole = Roles.id and Groups.id = Roles.idGroup;

/* вывести первых 5 юзеров отсортированных по ролям*/
SELECT Users.login, Users.email, Users.idRole
FROM Users 
ORDER BY Users.idRole
LIMIT 5;

SELECT Users.login, Users.email, Roles.name
FROM Users, Roles
WHERE Users.idRole = Roles.id
ORDER BY Roles.name
LIMIT 5;


/* вывести список ролей, 
отсортированных по названию группы*/
SELECT Roles.name, Groups.name
FROM Roles, Groups
WHERE Roles.idGroup = Groups.id
ORDER BY Groups.name;

/* вывести юзеров у которых в логине 
присутствует комбинация 'man1'*/

SELECT login, fullName, email 
FROM Users 
WHERE login LIKE '%man1%';

/* вывести первых 10 юзеров отсортированных по группе*/
SELECT Users.login, Users.passwordHash, Roles.name, Roles.idGroup
FROM Users, Roles
WHERE Users.idRole = Roles.id
ORDER BY Roles.idGroup
LIMIT 10;

/*по названию группы*/
SELECT Users.login, Users.passwordHash, Roles.name, Groups.name
FROM Users, Roles, Groups
WHERE Users.idRole = Roles.id and Groups.id = Roles.idGroup
ORDER BY Groups.name
LIMIT 10;

/*-----------------------------------------------------------*/
/*--- db Orders ---- */
/*
table Sales
id, dateSale, idProduct, countProduct, sumProduct

table Products
id, name, price
*/

CREATE TABLE Product(
    id serial PRIMARY KEY,
    name varchar(100) NOT NULL,
    price money CHECK(price >= money(0)) NOT NULL
);

CREATE TABLE Sales(
    id serial PRIMARY KEY,
    dateSale date DEFAULT now(),
    idProduct integer REFERENCES Product(id) ON DELETE SET NULL ON UPDATE CASCADE,
    countProduct integer DEFAULT 1 CHECK(countProduct >= 1) NOT NULL,
    sumProduct money DEFAULT (money(0)) CHECK(sumProduct >= money(0)) NOT NULL
);

INSERT INTO Product(name, price) VALUES
('хлеб белый', 20), ('хлеб чер', 22), ('молоко просто', 35), ('молоко сл', 32),
('шоколад чер1', 30), ('шоколад чер2', 40), ('шоколад мол', 32), ('сырок', 15);

INSERT INTO Sales (dateSale, idProduct, countProduct) VALUES
('2023-03-10', 1, 5),
('2023-03-10', 2, 2),
('2023-03-12', 4, 7),
('2023-04-05', 2, 2),
('2023-04-10', 3, 3),
('2023-04-10', 1, 2),
('2023-04-10', 5, 4),
('2023-05-07', 8, 8),
('2023-05-12', 7, 2),
('2023-05-22', 6, 5),
(now(), 1,1),
(now(), 3,3),
(now(), 2,4),
(now(), 8,8),
(now(), 6,3),
(now(), 7,6),
(now(), 5,7),
(now(), 5,5);

SELECT * FROM Sales;

/*обновляем поле сумма продажи товара для всей таблицЫ!!!*/
UPDATE Sales
SET sumProduct = Sales.countProduct * Product.price
FROM Product
WHERE Sales.idProduct = Product.id;

/*тотже на сегодня*/
UPDATE Sales
SET sumProduct = Sales.countProduct * Product.price
FROM Product
WHERE Sales.idProduct = Product.id and Sales.dateSale = now();

/*тотже для конкретной покупки (пример для 2-й)*/
UPDATE Sales
SET sumProduct = money(0)
WHERE Sales.id = 2;

SELECT * FROM Sales WHERE id=2;

UPDATE Sales
SET sumProduct = Sales.countProduct * Product.price
FROM Product
WHERE Sales.idProduct = Product.id and Sales.id = 2;








