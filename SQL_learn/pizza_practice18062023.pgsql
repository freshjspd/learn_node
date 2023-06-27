/*
ЗАДАНИЕ 
база данных Пиццерия

создается приложение для пицерии 

много пицерий и много видов пиц. 
ваше приложение должно получать процент от продаж gain (от каждой продажи)
заказ (состав) - pizza, additives (добавки)

пицце - название, цену, пиццерия, выход по массе, состав, добавки

----------------------
type product_type - pizza, additive

Таблица

Products - id, type, name, description
Clients - id, name, tel
Orders - id, id_manufacturer, id_client, total_sum, date
Manufacturers - id , name, gain
Products_to_orders - id_order, id_product, count
Products_to_manufacturers - id_product, id_manufacturer, weight, price

*/

CREATE TYPE product_type AS ENUM ('pizza', 'additive');

CREATE TABLE Products(
    id serial PRIMARY KEY,
    type product_type NOT NULL,
    name varchar(128) NOT NULL,
    description text
);

CREATE TABLE Manufacturers(
    id serial PRIMARY KEY,
    name varchar(128) UNIQUE NOT NULL,
    gain numeric(5,2) NOT NULL CHECK (gain<=100 and gain>=0)
);

CREATE TABLE Clients(
    id serial PRIMARY KEY,
    name varchar(128) UNIQUE NOT NULL,
    tel char(16) NOT NULL,
    email varchar(128),
    discount integer CHECK (discount<=100 and  discount>=0)
);

CREATE TABLE Orders(
    id serial PRIMARY KEY,
    id_manufacturer integer REFERENCES Manufacturers(id) ON DELETE SET NULL ON UPDATE CASCADE,
    id_client integer REFERENCES Clients(id) ON DELETE SET NULL ON UPDATE CASCADE,
    total_sum money CHECK(total_sum >= money(0)) DEFAULT 0,
    date date DEFAULT now()
);

CREATE TABLE Products_to_orders(
    id_order integer REFERENCES Orders(id) ON DELETE SET NULL ON UPDATE CASCADE,
    id_product integer REFERENCES Products(id) ON DELETE SET NULL ON UPDATE CASCADE,
    count integer DEFAULT 1 CHECK(count > 0) NOT NULL
);

CREATE TABLE Products_to_manufacturers(
    id_manufacturer integer REFERENCES Manufacturers(id) ON DELETE SET NULL ON UPDATE CASCADE,
    id_product integer REFERENCES Products(id) ON DELETE SET NULL ON UPDATE CASCADE,
    weight integer NOT NULL CHECK (weight > 0),
    price money NOT NULL CHECK (price > money(0))
);

/*
A - B
1 A - M B , 1B - 1A     1-M
1 A - M B, 1B - M A     M-M
1A - 1B 1-1

*/

/*add data*/

INSERT INTO Products(type, name, description) VALUES
('pizza', 'pizza name#1', 'pizza description'),
('pizza', 'pizza name#2', 'pizza description'),
('pizza', 'pizza name#3', 'pizza description'),
('pizza', 'pizza name#4', 'pizza description'),
('pizza', 'pizza name#5', 'pizza description'),
('pizza', 'pizza name#6', 'pizza description'),
('additive', 'additive name#1', 'additive description'),
('additive', 'additive name#2', 'additive description'),
('additive', 'additive name#3', 'additive description'),
('additive', 'additive name#4', 'additive description');

INSERT INTO Manufacturers(name, gain) VALUES
('Pizzeria #1', 5.5),
('Pizzeria #2', 7),
('Pizzeria #3', 2.5),
('Pizzeria #4', 6.5);

INSERT INTO Clients(name, tel) VALUES
('client1 surname', '0991234567'),
('client2 surname', '0951230067'),
('client3 surname', '0991937465'),
('client4 surname', '0951230000'),
('client5 surname', '0990000001');

/*
INSERT INTO Orders(id_manufacturer, id_client) VALUES
(1,1), (1,5), (1,4),
(2,1), (2,3),
(3,2), (3,4), (3,5),
(4,3), (4,4);
*/

INSERT INTO Orders(id_manufacturer, id_client) VALUES
(
    (SELECT id FROM Manufacturers WHERE name='Pizzeria #1'),
    (SELECT id FROM Clients WHERE tel='0991234567')
),
((SELECT id FROM Manufacturers WHERE name='Pizzeria #1'),(SELECT id FROM Clients WHERE tel='0990000001')),
((SELECT id FROM Manufacturers WHERE name='Pizzeria #1'),(SELECT id FROM Clients WHERE tel='0951230000')),
((SELECT id FROM Manufacturers WHERE name='Pizzeria #2'),(SELECT id FROM Clients WHERE tel='0991234567')),
((SELECT id FROM Manufacturers WHERE name='Pizzeria #2'),(SELECT id FROM Clients WHERE tel='0991937465')),
((SELECT id FROM Manufacturers WHERE name='Pizzeria #3'),(SELECT id FROM Clients WHERE tel='0951230067')),
((SELECT id FROM Manufacturers WHERE name='Pizzeria #3'),(SELECT id FROM Clients WHERE tel='0951230000')),
((SELECT id FROM Manufacturers WHERE name='Pizzeria #3'),(SELECT id FROM Clients WHERE tel='0990000001')),
((SELECT id FROM Manufacturers WHERE name='Pizzeria #4'),(SELECT id FROM Clients WHERE tel='0991937465')),
((SELECT id FROM Manufacturers WHERE name='Pizzeria #4'),(SELECT id FROM Clients WHERE tel='0951230000'));


SELECT * FROM Products_to_orders;
SELECT * FROM Orders;
SELECT * FROM Products;

INSERT INTO Products_to_orders(id_order, id_product, count) VALUES
--order1
(1,14,6), (1,13,2), (1,18, 6), (1, 19, 2),
--order2
(2,11,2),
--order3
(3,12,2), (3,15,2), (3,19,6), (3,17,2),
--order4
(4,13,2),
--order5
(5,15,2),
--order6
(6,13,2), (6,19,2),
--order7
(7,11,3),
--order8
(8,12,3), (8,15,2), (8,20, 1),
--order9
(9,11,5),
--order10
(10,11,2);

/*
--best!
INSERT INTO Products_to_orders(id_order, id_product, count) VALUES
--order6
(6,(SELECT id FROM Products WHERE name='pizza name#3'),2), 
(6,(SELECT id FROM Products WHERE name='additive name#3'),2),
--order9
(9,(SELECT id FROM Products WHERE name='pizza name#1'),5),
--order10
(10,(SELECT id FROM Products WHERE name='pizza name#1'),2);
*/

INSERT INTO Products_to_manufacturers(id_product, id_manufacturer, weight, price) VALUES
--pizza1
(11,1, 800, 300),
(11,2, 750, 250),
(11,3, 1000, 400),
(11,4, 900, 360),
--pizza2
(12,1, 500, 200),
(12,2, 550, 250),
(12,3, 600, 300),
(12,4, 700, 400),
--pizza3
(13,1, 800, 300),
(13,2, 750, 250),
(13,3, 1000, 400),
(13,4, 900, 360),
----pizza4
(14,1, 800, 300),
(14,2, 750, 250),
(14,3, 1000, 400),
(14,4, 900, 360),
--pizza5
(15,1, 800, 300),
(15,2, 750, 250),
(15,3, 1000, 400),
(15,4, 900, 360),
--pizza6
(16,1, 800, 300),
(16,2, 750, 250),
(16,3, 1000, 400),
(16,4, 900, 360),

--additive1
(17,1, 100, 60),
(17,2, 150, 85),
(17,3, 80, 50),
(17,4, 120, 75),
--additive2
(18,1, 100, 60),
(18,2, 150, 85),
(18,3, 80, 50),
(18,4, 120, 75),
--additive3
(19,1, 100, 60),
(19,2, 150, 85),
(19,3, 80, 50),
(19,4, 120, 75),
--additive4
(20,1, 100, 60),
(20,2, 150, 85),
(20,3, 80, 50),
(20,4, 120, 75);

/*
ИНФОРМАРМАЦИЯ
*/

SELECT * FROM Products;

SELECT * 
FROM Products
WHERE name LIKE 'pizza%';

SELECT * 
FROM Products
WHERE name LIKE 'additive%';


SELECT * FROM Clients;

SELECT * FROM Manufacturers;

--инфа о всех заказах

SELECT O.id_manufacturer, O.id_client, O.total_sum, O.date
FROM Orders AS O;

SELECT M.name, C.name, C.tel, C.email, O.total_sum, O.date
FROM Orders AS O
JOIN Clients AS C ON C.id = O.id_client
JOIN Manufacturers AS M ON M.id = O.id_manufacturer;

--смотрим заказ1
SELECT M.name, C.name, C.tel, C.email, O.total_sum, O.date
FROM Orders AS O
JOIN Clients AS C ON C.id = O.id_client
JOIN Manufacturers AS M ON M.id = O.id_manufacturer
WHERE O.id = 1;

--смотрим полную инфу о составе заказа1

/*
INSERT INTO Products_to_orders(id_order, id_product, count) VALUES
--order1
(1,14,6), (1,13,2), (1,18, 6), (1, 19, 2),
*/

SELECT PO.id_order, PO.id_product, PO.count
FROM Products_to_orders AS PO
WHERE PO.id_order = 1;

SELECT P.type, P.name, PO.count
FROM Products_to_orders AS PO
JOIN Products AS P ON P.id = PO.id_product
WHERE PO.id_order = 1;


/*
ЗАПРОСЫ
заказ клиента №1
инфа о заказе№2 пицерии№1 (о последнем заказе)
список заказов клиента №1
список заказов пицерии №1
список заказов пицерии №1 за сегодня
список заказов пицерии №1 за неделю
список заказов пицерии №1 за текущий месяц
---
количество заказов по каждому клиенту
количество заказов по каждому клиенту за текущий месяц
количество заказов по каждой пицерии
количество заказов по каждой пицерии за текущий месяц
---
количество заказов по клиенту №1
количество заказов по клиенту №1 за текущий месяц
количество заказов по пицерии №1
количество заказов по пицерии №1 за текущий месяц
----
в каких заказах заказывали пицку №1
в каких заказах заказывали пицку №1 за текущий месяц
----
----
подсчитать общий вес заказа №1
подсчитать по каждому продукту промежуточную стоимость для заказа №1
подсчитать общую стоимость заказа №1
*/

--заказ клиента №1
SELECT O.id, M.name AS "pizzeria", C.name AS "client", C.tel, O.total_sum, O.date
FROM Orders AS O
JOIN Manufacturers AS M ON M.id = O.id_manufacturer
JOIN Clients AS C ON C.id = O.id_client
WHERE C.tel = '0991234567' AND O.id = 1;

--инфа о заказе№3 пицерии№1 
SELECT O.id, M.name AS "pizzeria", C.name AS "client", C.tel, O.total_sum, O.date
FROM Orders AS O
JOIN Manufacturers AS M ON M.id = O.id_manufacturer
JOIN Clients AS C ON C.id = O.id_client
WHERE M.name = 'Pizzeria #1' AND O.id = 3;

--заказ клиента №1 (последний заказ)
SELECT O.id, M.name AS "pizzeria", C.name AS "client", C.tel, O.total_sum, O.date
FROM Orders AS O
JOIN Manufacturers AS M ON M.id = O.id_manufacturer
JOIN Clients AS C ON C.id = O.id_client
WHERE C.tel = '0991234567'
ORDER BY O.date DESC
LIMIT 1;

--инфа о заказе№3 пицерии№1 (последний заказ)
SELECT O.id, M.name AS "pizzeria", C.name AS "client", C.tel, O.total_sum, O.date
FROM Orders AS O
JOIN Manufacturers AS M ON M.id = O.id_manufacturer
JOIN Clients AS C ON C.id = O.id_client
WHERE M.name = 'Pizzeria #1'
ORDER BY O.date DESC
LIMIT 1;

--список заказов клиента №4
SELECT O.id, M.name AS "pizzeria", 
O.total_sum, O.date
FROM Orders AS O
JOIN Manufacturers AS M 
    ON M.id = O.id_manufacturer
JOIN Clients AS C 
    ON C.id = O.id_client
WHERE C.tel = '0951230000';

--список заказов пицерии №3
SELECT O.id, C.name AS "client", C.tel, 
O.total_sum, O.date
FROM Orders AS O
JOIN Manufacturers AS M 
    ON M.id = O.id_manufacturer
JOIN Clients AS C 
    ON C.id = O.id_client
WHERE M.name = 'Pizzeria #3';

--список заказов пицерии №3 на сегодня
SELECT O.id, M.name AS pizzeria, C.name AS client, C.tel, O.total_sum, O.date
FROM Orders AS O
INNER JOIN Manufacturers AS M ON M.id = O.id_manufacturer
INNER JOIN Clients AS C ON C.id = O.id_client
WHERE O.date = now() AND M.name = 'Pizzeria #3' 
ORDER BY O.date, O.id;

--список заказов пицерии №3 за неделю
SELECT O.id, M.name AS pizzeria, C.name AS client, C.tel, O.total_sum, O.date
FROM Orders AS O
INNER JOIN Manufacturers AS M ON M.id = O.id_manufacturer
INNER JOIN Clients AS C ON C.id = O.id_client
WHERE EXTRACT(DAY FROM O.date) BETWEEN EXTRACT(DAY FROM now())-7 AND EXTRACT(DAY FROM now())
AND M.name = 'Pizzeria #3' 
ORDER BY O.date, O.id;

--список заказов пицерии №3 за текущий месяц
SELECT O.id, M.name AS pizzeria, C.name AS client, C.tel, O.total_sum, O.date
FROM Orders AS O
INNER JOIN Manufacturers AS M ON M.id = O.id_manufacturer
INNER JOIN Clients AS C ON C.id = O.id_client
WHERE EXTRACT(MONTH FROM O.date) = EXTRACT(MONTH FROM now()) AND M.name = 'Pizzeria #3' 
ORDER BY O.date, O.id;

--количество заказов по каждому клиенту
SELECT O.id_client, count(O.id)
FROM Orders AS O
GROUP BY O.id_client

SELECT C.name, C.tel, count(O.id)
FROM Orders AS O
JOIN Clients AS C ON C.id = O.id_client
GROUP BY C.name, C.tel

--количество заказов по каждому клиенту за текущий месяц
SELECT C.name, C.tel, count(O.id) as "orders"
FROM Orders AS O
JOIN Clients AS C ON C.id = O.id_client
WHERE EXTRACT(MONTH FROM O.date) = EXTRACT(MONTH FROM now())
GROUP BY C.name, C.tel
ORDER BY "orders" DESC, C.name;

--количество заказов по каждой пицерии
SELECT M.name, count(O.id) as "orders"
FROM Orders AS O
JOIN Manufacturers AS M ON M.id = O.id_manufacturer
GROUP BY M.name
ORDER BY "orders" DESC, M.name;

--количество заказов по каждой пицерии за текущий месяц
SELECT M.name, count(O.id) as "orders"
FROM Orders AS O
JOIN Manufacturers AS M ON M.id = O.id_manufacturer
WHERE EXTRACT(MONTH FROM O.date) = EXTRACT(MONTH FROM now())
GROUP BY M.name
ORDER BY "orders" DESC, M.name;

--количество заказов по клиенту №4
SELECT C.name, C.tel, count(O.id) as "orders"
FROM Orders AS O
JOIN Clients AS C ON C.id = O.id_client
WHERE C.tel = '0951230000' 
GROUP BY C.name, C.tel
ORDER BY "orders" DESC, C.name;

--количество заказов по клиенту №4 за текущий месяц
SELECT C.name, C.tel, count(O.id) as "orders"
FROM Orders AS O
JOIN Clients AS C ON C.id = O.id_client
WHERE C.tel = '0951230000' AND EXTRACT(MONTH FROM O.date) = EXTRACT(MONTH FROM now())
GROUP BY C.name, C.tel
ORDER BY "orders" DESC, C.name;

--количество заказов по пицерии №3
SELECT M.name, count(O.id) as "orders"
FROM Orders AS O
JOIN Manufacturers AS M ON M.id = O.id_manufacturer
WHERE M.name = 'Pizzeria #3' 
GROUP BY M.name
ORDER BY "orders" DESC, M.name;

--количество заказов по пицерии №3 за текущий месяц
SELECT M.name, count(O.id) as "orders"
FROM Orders AS O
JOIN Manufacturers AS M ON M.id = O.id_manufacturer
WHERE M.name = 'Pizzeria #3'  AND EXTRACT(MONTH FROM O.date) = EXTRACT(MONTH FROM now())
GROUP BY M.name
ORDER BY "orders" DESC, M.name;

--в каких заказах заказывали пиццу №1
SELECT P.name, PO.count, PO.id_order, O.date
FROM Products_to_orders AS PO
JOIN Products AS P ON P.id = PO.id_product
JOIN Orders AS O ON O.id = PO.id_order
WHERE P.name = 'pizza name#1';

--в каких заказах заказывали пиццу №1 за текущий месяц
SELECT P.name, PO.count, PO.id_order, O.date
FROM Products_to_orders AS PO
JOIN Products AS P ON P.id = PO.id_product
JOIN Orders AS O ON O.id = PO.id_order
WHERE P.name = 'pizza name#1' AND EXTRACT(MONTH FROM O.date) = EXTRACT(MONTH FROM now());

-------------

--подсчитать общий вес заказа №1
SELECT O.id, concat(sum(PM.weight), ' gram') FROM Orders AS O
INNER JOIN products_to_manufacturers AS PM ON O.id_manufacturer = PM.id_manufacturer
WHERE O.id = 1
GROUP BY O.id;

/*
SELECT PO.* 
FROM Products AS P
JOIN Products_to_orders AS PO ON P.id = PO.id_product
JOIN Products_to_Manufacturers AS PM ON P.id = PM.id_product
WHERE PO.id_order = 1;
*/

--подсчитать по каждому продукту промежуточную стоимость для заказа №1 (чек)
SELECT P.type, P.name, PM.price, PO.count, sum(PO.count * PM.price)
FROM Orders AS O
JOIN Products_to_orders AS PO ON O.id = PO.id_order
JOIN Products_to_Manufacturers AS PM ON O.id_manufacturer = PM.id_manufacturer AND
PM.id_product = PO.id_product
JOIN Products AS P ON P.id = PO.id_product
WHERE O.id = 1
GROUP BY P.type, P.name, PM.price, PO.count;

--подсчитать общую стоимость заказа №1 и обновить total_sum Orders
SELECT sum(PO.count * PM.price)
FROM Orders AS O
JOIN Products_to_orders AS PO ON O.id = PO.id_order
JOIN Products_to_Manufacturers AS PM ON O.id_manufacturer = PM.id_manufacturer AND
PM.id_product = PO.id_product
WHERE O.id = 1;
