/*
Типы связей
    1-1 (one-to-one)
к 1 экземпляру соответствует только один экземпляр из 2-й таблицы
    Пр. табл Сотрудник - табл Личные данные
Сотрудник(id primary key, name, ....) - ЛД(id, .....) -Медкарта


    1-М (one-to-many)
к 1 экземпляру в 1-й таблицы соответствует много экземпляров из 2-й таблицы

Пр. табл Пользователи - табл Задачи
Пр. табл Роли - табл Пользователи

Users(id primary key, ...) - Tasks(id pk, ....,idUser foreign key)

    M-M(many-to-many)
к 1 экземпляру в 1-й таблицы соответствует много экземпляров из 2-й таблицы а также к 1 экземпляру в 2-й таблицы соответствует много экземпляров из 1-й таблицы
    реализация через две связи 1-М

Покупка - Товар (М-М)
Покупка №12345 - товар№1 2, товар№2 5, .... 1-М
Товар№199 - п1, п2, .... 1-М

Sale
- id primary key, client, data, totalSum
Order (чек)
- idSale FK, idProduct FK, countProduct, sumProduct
Product
- id primary key, name, price
*/


CREATE TABLE Users(
    id serial PRIMARY KEY,
    login varchar(64) UNIQUE NOT NULL,
    passwordHash text NOT NULL
);

CREATE TABLE Tasks(
    id serial PRIMARY KEY,
    name varchar(100) NOT NULL,
    date date DEFAULT now(),
    idUser INTEGER REFERENCES Users(id) ON DELETE SET NULL ON UPDATE CASCADE
);

INSERT INTO Users (login, passwordHash) VALUES
('john', 'qwerty'),('tom', 'qwerty'),('nike', 'qwerty'),('ann', 'qwerty');

INSERT INTO Tasks (name, idUser) VALUES
('task1', 1), ('task2', 3), ('task3', 4), ('task4', 4);

/*неявное соединение таблиц*/
SELECT Tasks.name, Tasks.date, Users.login
FROM Users, Tasks
WHERE Users.id = Tasks.idUser;

SELECT T.name, T.date as deadline, U.login
FROM Users as U, Tasks as T
WHERE U.id = T.idUser;

/*внутреннее соединение JOIN , INNER JOIN*/
SELECT Tasks.name, Tasks.date, Users.login
FROM Users INNER JOIN Tasks ON Users.id = Tasks.idUser;

/*
SELECT *[columns]
FROM Table1 
JOIN  Table2 ON Table1.id = Table2.idTable1
JOIN  Table3 ON Table1.id = Table3.idTable1

SELECT Users.login, Roles.name, Tasks.name, Tasks.date, 
FROM Users 
INNER JOIN Tasks ON Users.id = Tasks.idUser
INNER JOIN Roles ON Users.idRole = Roles.id;
*/

/*внешнее соединение OUTER JOIN*/
/*
- LEFT  результат содержит все строки из 1 (левой) таблицы
-RIGHT результат содержит все строки из 2 (правой) таблицы
-FULL результат содержит все строки обеих таблиц
*/

INSERT INTO Users (login, passwordHash) VALUES ('vasya', 'qwerty');

INSERT INTO Tasks (name, idUser) VALUES
('task5', null), ('task6', null);

SELECT Tasks.name, Tasks.date, Users.login
FROM Users INNER JOIN Tasks ON Users.id = Tasks.idUser;

SELECT Tasks.name, Tasks.date, Users.login
FROM Users LEFT OUTER JOIN Tasks ON Users.id = Tasks.idUser;

SELECT Tasks.name, Tasks.date, Users.login
FROM Users RIGHT OUTER JOIN Tasks ON Users.id = Tasks.idUser;

SELECT Tasks.name, Tasks.date, Users.login
FROM Users FULL OUTER JOIN Tasks ON Users.id = Tasks.idUser;

/*------------------------------------------------------*/
/*------------------------------------------------------*/
/* db Orders */
/*
М-М
Товар - Покупка М-М  => Товар (idProduct, price) - Чек (idProduct FK, count, sum, idSale FK) - Покупка (idSale, totalSum, sale)
Поставщик - Поставка
Поставка - Товар
*/

CREATE TABLE Products(
    id serial PRIMARY KEY,
    name varchar(64) NOT NULL,
    description text,
    price money CHECK(price >= money(0)) NOT NULL
);

CREATE TABLE Orders(
    id serial PRIMARY KEY,
    dateSale DATE DEFAULT now() NOT NULL,
    totalSum money DEFAULT money(0) NOT NULL,
    sale integer DEFAULT 0
);

CREATE TABLE CashVoucher(
    id serial PRIMARY KEY,
    idOrder integer REFERENCES Orders(id) ON DELETE SET NULL ON UPDATE CASCADE,
    idProduct integer REFERENCES Products(id) ON DELETE SET NULL ON UPDATE CASCADE,
    countProduct integer DEFAULT 1,
    sumProduct money DEFAULT money(0)
);

INSERT INTO Products (name, price) VALUES
('product1', 100), ('product2', 120), ('product3', 200), ('product4', 180), ('product5', 90), ('product6', 165);

INSERT INTO Orders (dateSale) VALUES
('01.06.2023'),('01.06.2023'),('01.06.2023'),('01.06.2023'),
('02.06.2023'),('02.06.2023'),('03.06.2023'),('04.06.2023'),
('04.06.2023'),('04.06.2023'),('05.06.2023'),('05.06.2023'),
('05.06.2023'),('05.06.2023'),('06.06.2023'),('06.06.2023'),
('06.06.2023'),('06.06.2023'),('06.06.2023'),('06.06.2023');

INSERT INTO Orders (dateSale) VALUES (now());

INSERT INTO CashVoucher(idOrder, idProduct, countProduct) VALUES
(1, 1, 5), (1, 2, 1), (1, 5, 1), (1, 6, 1);

INSERT INTO CashVoucher(idOrder, idProduct, countProduct) VALUES
(2, 1, 10), (2, 3, 6);

INSERT INTO CashVoucher(idOrder, idProduct, countProduct) VALUES
(3, 1, 1), (3, 2, 1), (3, 4, 2), (3, 5, 1), (3, 6, 2);

SELECT * FROM Orders;

SELECT * FROM CashVoucher;

UPDATE CashVoucher
SET sumProduct = CV.countProduct * Products.price
FROM CashVoucher as CV JOIN Products ON CV.idProduct = Products.id
WHERE CV.idOrder = 1;

/*сколько наименований продуктов было куплено в кажном заказе*/
SELECT CV.idOrder, count(CV.countProduct)
FROM CashVoucher as CV
GROUP BY CV.idOrder;

/*всего товаров / полное количество было куплено в кажном заказе*/
SELECT CV.idOrder, sum(CV.countProduct)
FROM CashVoucher as CV
GROUP BY CV.idOrder;

SELECT CV.idOrder, max(CV.countProduct)
FROM CashVoucher as CV
GROUP BY CV.idOrder;

SELECT idOrder, sum(sumProduct) as total
FROM CashVoucher
GROUP BY idOrder;

SELECT idOrder, avg(countProduct) as total
FROM CashVoucher
GROUP BY idOrder;

SELECT idOrder, min(countProduct), max(countProduct), count(countProduct) as "наим. шт", sum(countProduct) as "total sum грн"
FROM CashVoucher
GROUP BY idOrder;

/*
SELECT *[columns]
FROM table1
JOIN table2 ON table1.id1 = table2.id2
WHERE условие отбора
GROUP BY column1, column2, ....
HAVING условие для фильтрации груп
ORDER BY column;
*/

CREATE TABLE Goods(
    id serial PRIMARY KEY,
    name varchar(100) NOT NULL,
    category varchar(64) NOT NULL,
    price money CHECK(price >= money(0)) NOT NULL,
    count integer DEFAULT 1 NOT NULL
);

INSERT INTO Goods(name, category, price, count) VALUES
('product1', 'category1', 100, 20),
('product2', 'category1', 80, 25),
('product3', 'category2', 90, 22),
('product4', 'category2', 105, 10),
('product5', 'category2', 140, 8),
('product6', 'category3', 160, 12),
('product7', 'category3', 110, 15),
('product8', 'category4', 90, 21),
('product9', 'category4', 92, 27),
('product10', 'category5', 85, 25),
('product11', 'category5', 70, 24),
('product12', 'category5', 100, 10),
('product13', 'category6', 110, 15),
('product14', 'category7', 120, 18);


SELECT category, count(name)
FROM Goods 
GROUP BY ROLLUP(category);

SELECT category, sum(Goods.count)
FROM Goods 
GROUP BY category;

SELECT category, sum(Goods.count) as "totalCount"
FROM Goods 
WHERE price >= money(100)
GROUP BY category
HAVING sum(Goods.count) >= 18
ORDER BY "totalCount", category;

/*
CREATE TABLE Tasks(
    id serial PRIMARY KEY,
    name varchar(100) NOT NULL,
    date date DEFAULT now(),
    idUser INTEGER REFERENCES Users(id) ON DELETE SET NULL ON UPDATE CASCADE
);
*/

INSERT INTO Tasks (name, idUser, date) VALUES
('task7', 1, '06.06.2023'), ('task8', 2, '06.06.2023'), 
('task9', 2, '07.06.2023'), ('task10', 4, '08.06.2023');


SELECT Tasks.date, count(Tasks.id)
FROM Tasks
GROUP BY Tasks.date
HAVING count(Tasks.id) > 1;


