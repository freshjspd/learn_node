--Запросы

--Вывести полную информацию о конкретном поставщике
--Вывести список поставщиков с контактными данными

SELECT *
FROM Providers 
WHERE id = 3;

SELECT name, tel, email FROM Providers;

--Вывести общую информацию о закупке
SELECT S.id, S.date, S.total_sum, P.name as "provider", concat(E.name,' ',E.surname) as "employee"
FROM Supplies AS S
JOIN Employees AS E ON E.id = S.id_employee
JOIN Providers AS P ON P.id = S.id_provider
WHERE S.id = 1;

--Вывести состав закупки
SELECT C.id_supply, Products.name, C.counts, C.supply_price 
FROM Contents AS C
INNER JOIN Products ON Products.id = C.id_product
WHERE C.id_supply = 1;

--Вывести информацию о товаре включая закупочную цену и цену реалзации
SELECT P.name, C.name, P.sale_price, CO.supply_price
FROM Products AS P
JOIN Categories AS C ON C.id = P.id_category
JOIN Contents AS CO ON P.id = CO.id_product;

SELECT P.name, C.name, P.sale_price, CO.supply_price
FROM Products AS P
JOIN Categories AS C ON C.id = P.id_category
JOIN Contents AS CO ON P.id = CO.id_product
WHERE P.id = 1;

--вывести список товаров определенной категории и упорядочить по цене
SELECT P.name, C.name, P.sale_price
FROM Products AS P
JOIN Categories AS C ON C.id = P.id_category
WHERE C.name = 'category #1'
ORDER BY P.sale_price;

--Вывести список сотрудников с указанием должности
SELECT concat(E.surname,' ',E.name), P.name, E.staff_id, P.salary FROM Employees AS E
INNER JOIN Positions AS P ON P.id = E.id_position
--вывести список операторов
SELECT concat(E.surname,' ',E.name) as "fullname", P.name, E.staff_id, P.salary 
FROM Employees AS E
JOIN Positions AS P ON P.id = E.id_position
WHERE P.name = 'operator';

--вычислить цену реализации товара Products.sale_price
UPDATE Products
SET sale_price = 
    (SELECT max(supply_price)
    FROM Contents
    GROUP BY id_product
    HAVING id_product = 3) 
    * Products.markup / 10
WHERE id = 3;

UPDATE Products AS P
SET sale_price = Res.sp
FROM Products,
  (SELECT P.id,(C.supply_price * P.markup * 0.1) as sp 
  FROM Products AS P
  INNER JOIN Contents AS C ON C.id_product = P.id
  GROUP BY P.id, C.supply_price, P.markup) AS Res
WHERE Res.id = P.id


CREATE FUNCTION calcSalePrice(integer)
RETURNS void
AS 'UPDATE Products
SET sale_price = 
    (SELECT max(supply_price)
    FROM Contents
    GROUP BY id_product
    HAVING id_product = $1) 
    * Products.markup * 0.1
WHERE id = $1'
LANGUAGE SQL;

--обнуление цены 11 товара
UPDATE products
SET sale_price = 0
WHERE id = 11;

-- вызов функции для 11 товара
SELECT * FROM calcSalePrice(11);

SELECT P.name, C.name, P.sale_price, CO.supply_price
FROM Products AS P
JOIN Categories AS C ON C.id = P.id_category
JOIN Contents AS CO ON P.id = CO.id_product;

-- сколько поставок сделал каждый поставщик
SELECT providers.name, count(supplies.id)
FROM providers
JOIN supplies ON providers.id = supplies.id_provider
GROUP BY providers.name;

-- сколько поставок сделал каждый поставщик за текущий месяц
SELECT providers.name, count(supplies.id)
FROM providers
JOIN supplies ON providers.id = supplies.id_provider
WHERE EXTRACT(MONTH FROM date) = EXTRACT(MONTH FROM now())
GROUP BY providers.name;

-- сколько поставок сделал каждый поставщик за этот год
SELECT providers.name, count(supplies.id)
FROM providers
JOIN supplies ON providers.id = supplies.id_provider
WHERE EXTRACT(YEAR FROM date) = EXTRACT(YEAR FROM now())
GROUP BY providers.name;

-- сколько товаров в каждой категории
SELECT categories.name, count(products.id)
FROM categories
JOIN products ON categories.id = products.id_category
GROUP BY categories.name;

-- сколько сотрудников по каждой должности
SELECT positions.name, count(employees.id)
FROM positions
JOIN employees ON positions.id = employees.id_position
GROUP BY positions.name;

--кто сделал больше всего поставок
SELECT providers.name, count(supplies.id) as "sp"
FROM providers
JOIN supplies ON providers.id = supplies.id_provider
WHERE EXTRACT(YEAR FROM date) = EXTRACT(YEAR FROM now())
GROUP BY providers.name
ORDER BY "sp"
LIMIT 1;

--------------------------

--добавляем клиента и заказы

DROP TABLE Stores;

CREATE TABLE Clients(
    id serial PRIMARY KEY NOT NULL,
    login varchar(64) NOT NULL,
    passwordHash text NOT NULL,
    fullName varchar(128)
);

CREATE TABLE Orders(
    id serial PRIMARY KEY NOT NULL,
    date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    id_client integer REFERENCES Clients(id) ON DELETE SET NULL ON UPDATE CASCADE,
    id_employee integer REFERENCES Employees(id) ON DELETE SET NULL ON UPDATE CASCADE,
    total_sum money CHECK(total_sum >= money(0))
);

CREATE TABLE Checks(
    id serial PRIMARY KEY NOT NULL,
    id_order integer REFERENCES Orders(id) ON DELETE SET NULL ON UPDATE CASCADE,
    id_product integer REFERENCES Products(id) ON DELETE SET NULL ON UPDATE CASCADE,
    count_product integer DEFAULT 1,
    sum money DEFAULT 0::money
);

CREATE TABLE Stores(
    id serial PRIMARY KEY NOT NULL,
    name varchar(64),
    address text,
    id_employee integer REFERENCES Employees(id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE StoreToProducts(
    id serial NOT NULL,
    id_store integer REFERENCES Stores(id) ON DELETE SET NULL ON UPDATE CASCADE,
    id_product integer REFERENCES Products(id) ON DELETE SET NULL ON UPDATE CASCADE,
    count_product integer CHECK (count_product >= 0)
);

INSERT INTO Stores(name, address, id_employee) VALUES
('store #1', 'address', 4),
('store #2', 'address', 4);

-- закупка -> перенос товара на склад
-- клиент делает заказ -> списать товар со склад

--15 добавляем новую поставку
INSERT INTO supplies(id_provider, id_employee) VALUES
(1,1);

INSERT INTO Contents(id_supply, id_product, counts, supply_price) VALUES
(15, 1, 10, 122),
(15, 5, 10, 210);

--считаем сумму всей поставки №15
UPDATE Contents
SET supply_sum = counts * supply_price
WHERE id_supply = 15;

UPDATE Supplies AS S
SET total_sum = Res.total
FROM Supplies,
  (SELECT C.id_supply, sum(C.supply_sum) AS total
  FROM Contents AS C
  WHERE C.id_supply = 15
  GROUP BY C.id_supply) AS Res
WHERE Res.id_supply = S.id AND S.id = 15;

--обновляем цены для 1 и 5 товара так как закупочная изменилась
SELECT * FROM calcSalePrice(1);
SELECT * FROM calcSalePrice(5);

--списать товары на склад
/*
INSERT INTO StoreToProducts(id_store, id_product, count_product) VALUES
(1,1,0), (1,5,0);
*/

UPDATE StoreToProducts AS SP
SET count_product = SP.count_product + 
(SELECT counts FROM Contents WHERE id_supply = 15 AND id_product = 1)
WHERE SP.id_store = 1 AND SP.id_product = 1;

UPDATE StoreToProducts AS SP
SET count_product = SP.count_product + 
(SELECT counts FROM Contents WHERE id_supply = 15 AND id_product = 5)
WHERE SP.id_store = 1 AND SP.id_product = 5;

SELECT * FROM StoreToProducts;

-- оформляем покупку и списать товары со склада

--новый клиент
INSERT INTO Clients(login, passwordHash, fullName) VALUES
('tom123', 'd033e22ae348aeb5660fc2140aec35850c4da997', 'Tom Tomson');

--новый заказ №1
INSERT INTO Orders(id_client, id_employee) VALUES
((SELECT id FROM Clients WHERE login='tom123'),
(SELECT id FROM Employees WHERE staff_id='3522'));

--заполняем состав заказа
INSERT INTO Checks(id_order, id_product, count_product) VALUES
(1, 1, 3), (1, 5, 2);

--суммы по чеку
UPDATE Checks as C
SET sum = Res.sumP
FROM Checks ,
    (SELECT C.id, C.id_order, (C.count_product * P.sale_price) as sumP
    FROM Checks as C
    JOIN Products as P ON P.id = C.id_product
    GROUP BY C.id, C.id_order, C.count_product, P.sale_price) as Res
WHERE Res.id_order = C.id_order and C.id = Res.id and C.id_order = 1;

--общая стоимость заказа
UPDATE Orders AS O
SET total_sum = Res.total
FROM Orders,
  (SELECT C.id_order, sum(C.sum) AS total
  FROM Checks AS C
  WHERE C.id_order = 1
  GROUP BY C.id_order) AS Res
WHERE Res.id_order = O.id AND O.id = 1;

SELECT * FROM Orders;

--списываем со склада
UPDATE  StoreToProducts as S
SET count_product = S.count_product - Res.buy_count
FROM StoreToProducts,
    (SELECT C.id, C.id_order, C.id_product, C.count_product as buy_count
    FROM Checks as C
    GROUP BY C.id, C.id_order, C.id_product, C.count_product) as Res
WHERE Res.id_product = S.id_product and Res.id_order = 1;


--проверка

--смотрим заказ
SELECT C.id_order, P.name, P.sale_price, C.count_product, C.sum
FROM Checks AS C
JOIN Products AS P ON P.id = C.id_product
WHERE C.id_order = 1;

SELECT O.id, O.date, C.fullname as "client", concat(E.name,' ',E.surname) AS "operator", O.total_sum
FROM Orders AS O
JOIN Clients AS C ON C.id = O.id_client
JOIN Employees AS E ON E.id = O.id_employee
WHERE O.id = 1;

--смотрим склады
SELECT S.id, S.name, P.name as "product", SP.count_product as "counts", S.address, concat(E.name,' ',E.surname) AS "operator", E.staff_id
FROM StoreToProducts AS SP
JOIN Stores AS S ON S.id = SP.id_store 
JOIN Employees AS E ON E.id = S.id_employee
JOIN Products AS P ON P.id = SP.id_product;

