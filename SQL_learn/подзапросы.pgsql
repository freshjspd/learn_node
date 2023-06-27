/*
Подзапросы subquery
- запросы , которые встроены (включены) в другие запросы, в основной запрос.

table Orders : id, idCustomers, (data, time) createdAt, idProduct, countProduct, sumProduct
table Products: id, name, description, price

INSERT INTO Orders(createdAt, idProduct, countProduct) VALUES
(now(), 2, 5), (now(), 15, 2), (now(), 22, 3),  (now(), 50, 1);

=>  ????

INSERT INTO Orders(createdAt, idProduct, countProduct) VALUES
(now(), (SELECT id FROM Products WHERE name = "HP 505"), 5);

INSERT INTO Orders(createdAt, idProduct, countProduct) VALUES
(now(), (SELECT id FROM Products WHERE productUI = "1234-xc12-fg50009900"), 5);

INSERT INTO Orders(createdAt, idProduct, countProduct, idCustomers) VALUES
(
    now(), 
    (SELECT id FROM Products WHERE productUI = "1234-xc12-fg50009900"),
    5,
    (SELECT id FROM Customers WHERE card = "CU12345")
);

Ищем товары которые имеют минимальную цену

SELECT *
FROM Products
WHERE price = (SELECT MIN(price) FROM Products);

для максимальной цены
SELECT *
FROM Products
WHERE price = (SELECT MAX(price) FROM Products);

для товаров дешевле средней цены
SELECT *
FROM Products
WHERE price <= (SELECT AVG(price) FROM Products);

для товаров выше средней цены
SELECT *
FROM Products
WHERE price >= (SELECT AVG(price) FROM Products);

для товаров в диапазоне 5% средней цены
SELECT *
FROM Products
WHERE price BETWEEN (SELECT AVG(price) FROM Products)*0.95 AND (SELECT AVG(price) FROM Products)*1.05;

---------------
Correlated subquery

SELECT createdAt,  
       countProduct,
       (SELECT name FROM Products WHERE Products.id = Orders.idProduct) as "product"
FROM Orders; 

---
SELECT name, 
       price, 
       (SELECT AVG(price) FROM Products AS subProducts
       WHERE subProducts.name = Products.name) AS Res
FROM Products
WHERE price <= (SELECT AVG(price) FROM Products AS subProducts) 

*/

CREATE TABLE Positions(
    id serial PRIMARY KEY,
    name varchar(64) NOT NULL,
    description text
);

CREATE TABLE Employees(
    id serial PRIMARY KEY,
    fullName varchar(64) NOT NULL,
    birthday date,
    isMale boolean,
    hiredate date NOT NULL DEFAULT now(),
    email varchar(128),
    salary money CHECK(money > 0),
    id_position integer REFERENCES Positions(id)
);

INSERT Employees(fullName, salary, id_position) VALUES
('Ryan Clark', 1000, (SELECT id FROM Positions WHERE name='developer')), 
('John Harris', 700, (SELECT id FROM Positions WHERE name='manager')), 
('Olivia Jones', 700, (SELECT id FROM Positions WHERE name='developer'));

SELECT E.fullName, E.hiredate, E.salary, P.name
FROM Employees as E
JOIN Positions as P ON P.id = E.id_position;


SELECT E.fullName, 
       E.hiredate, 
       E.salary, 
       (SELECT name FROM Positions WHERE P.id = E.id_position)
FROM Employees as E;


/*db posts*/

CREATE TABLE Users(
    id serial PRIMARY KEY,
    login varchar(64) NOT NULL,
    passwordHash text not null    
);

CREATE TABLE Posts(
    id serial PRIMARY KEY,
    author integer REFERENCING Users(id),
    head varchar(128) not null,
    body text
);

CREATE TABLE PostsLikes(
    id_user integer REFERENCING Users(id),
    id_post integer REFERENCING Posts(id),
);

INSERT INTO Users(login, passwordHash) VALUES
('william', 'qwerty'), ('john', 'qwerty'), ('david', 'qwerty'),
('olivia', 'qwerty'), ('megan', 'qwerty'), ('alex', 'qwerty');

INSERT INTO Posts(author, head) VALUES
((SELECT id FROM Users WHERE login = "william"), 'header1'),
((SELECT id FROM Users WHERE login = "david"), 'header2'),
((SELECT id FROM Users WHERE login = "william"), 'header3'),
((SELECT id FROM Users WHERE login = "alex"), 'header4'),
((SELECT id FROM Users WHERE login = "olivia"), 'header5'),
((SELECT id FROM Users WHERE login = "megan"), 'header6');

/*информация о посте и о количестве лайков*/

SELECT Posts.*, 
(SELECT count(*) FROM PostsLikes WHERE Posts.id = PostsLikes.id_post) as "count likes"
FROM Posts
ORDER BY "count likes" DESC, Posts.id;

/*выделим посты которые лайкнули больше 5 раз*/
SELECT Posts.id, Posts.head, Posts.body, count(PostsLikes.id_post) as "count likes"
FROM Posts
JOIN PostsLikes ON Posts.id = PostsLikes.id_post
GROUP BY Posts.id, Posts.head, Posts.body
HAVING count(PostsLikes) >= 5
ORDER BY "count likes" DESC, Posts.id;

/*UNION + EXCEPT*/

DROP TABLE Users;

CREATE TABLE Users(
    id serial PRIMARY KEY,
    login varchar(64) NOT NULL,
    passwordHash text not null,
    fullName varchar(128),
    email varchar(128) UNIQUE  
);

CREATE TABLE Employees(
    id serial PRIMARY KEY,
    fullName varchar(128),
    email varchar(128) UNIQUE  
);

INSERT INTO Users(login, passwordHash, fullName, email) VALUES
('login1', 'qwerty', 'william smith', NULL), 
('login2', 'qwerty', 'john jones', 'john@mail.com'), 
('login3', 'qwerty', 'david brown', 'davidbr1@mail.com'),
('login4', 'qwerty', 'olivia miller', NULL), 
('login5', 'qwerty','megan lee', 'megan@mail.com');

INSERT INTO Employees(fullName, email) VALUES
('william smith', NULL), 
('john jones', 'john@mail.com'), 
('david brown', 'superbrown12345@mail.com'),
('olivia miller', NULL), 
('test', 'test@mail.com');

SELECT fullName, email FROM Users;

SELECT fullName, email FROM Employees;


SELECT fullName, email FROM Users
UNION
SELECT fullName, email FROM Employees;

SELECT fullName, email FROM Users
EXCEPT
SELECT fullName, email FROM Employees;

SELECT fullName, email FROM Employees
EXCEPT
SELECT fullName, email FROM Users;