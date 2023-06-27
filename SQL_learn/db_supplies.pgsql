/*
БД Закупки
------------
Поставщики - Закупки 1-М
Закупки - Товары М-М
Должности - Сотрудники 1-М
Сотрудники - Закупки 1-М
------------------------

Поставщики - id, название, тел, email, дополнительно, расчетный счет

Закупки - id, дата, id_поставщика, id_сотрудника, общая стоимость закупки

Состав закупки - id_закупки, id_товара, количество, цена закупочная товара

Товары - id, название, id_категории, цена реализации

Категории товара - id, название, описание

Сотрудники - id, ФИО, ИНН, Дата найма, Контактная инфа, id_должности

Должности - id, название, оклад, процент от продаж

provider - supply
purchase price / saling price
bank account
salary , ИНН (TIN)
employee number / employee id, staff number / staff id
*/

CREATE TABLE Positions(
    id serial PRIMARY KEY,
    name varchar(64) NOT NULL,
    salary money CHECK (salary >= money(0)) NOT NULL,
    percent_of_seles integer DEFAULT 5
);

CREATE TABLE Employees(
    id serial PRIMARY KEY,
    name varchar(64) NOT NULL,
    surname varchar(64) NOT NULL,
    id_position integer REFERENCES Positions(id) ON DELETE SET NULL ON UPDATE CASCADE,
    staff_id varchar(30) UNIQUE NOT NULL,
    personal_info text
);

CREATE TABLE Providers(
    id serial PRIMARY KEY,
    name varchar(64) NOT NULL,
    tel char(16) NOT NULL,
    email varchar(64),
    bank_account char(20) CHECK(length(bank_account) = 20) UNIQUE NOT NULL,
    add_info text
);

CREATE TABLE Supplies(
    id serial PRIMARY KEY,
    date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    id_provider integer REFERENCES Providers(id) ON DELETE SET NULL ON UPDATE CASCADE,
    id_employee integer REFERENCES Employees(id) ON DELETE SET NULL ON UPDATE CASCADE,
    total_sum money CHECK(total_sum >= money(0))
);

CREATE TABLE Categories(
    id serial PRIMARY KEY,
    name varchar(64) NOT NULL,
    description text
);

CREATE TABLE Products(
    id serial PRIMARY KEY,
    name varchar(128) NOT NULL,
    id_category integer REFERENCES Categories(id) ON DELETE SET NULL ON UPDATE CASCADE,
    sale_price money CHECK (sale_price >= 0::money )
);

CREATE TABLE Contents(
    id_supply integer REFERENCES Supplies(id) ON DELETE SET NULL ON UPDATE CASCADE,
    id_product integer REFERENCES Products(id) ON DELETE SET NULL ON UPDATE CASCADE,
    counts integer CHECK (counts >= 0),
    supply_price money CHECK (supply_price >= money(0) )
);

ALTER TABLE Contents ADD COLUMN supply_sum money CHECK (supply_sum >= money(0));

--наценка - процент для продажи товара
ALTER TABLE Products ADD COLUMN markup integer;




-- insert data

INSERT INTO Positions(name, salary) VALUES
('operator', 8000), ('manager', 12000);

INSERT INTO Employees(name, surname, id_position, staff_id) VALUES
('Name1', 'Surname1', 1, '3500'),
('Name2', 'Surname2', 1, '3520'),
('Name3', 'Surname3', 1, '3522'),
('Name4', 'Surname4', 2, '3525'),
('Name5', 'Surname5', 1, '3526');

INSERT INTO Providers(name, tel, bank_account) VALUES
('provider1', '0991234567', '12345678912345678901'),
('provider2', '0990045615', '12345678912345678902'),
('provider3', '0951038414', '12345678912345678903');

INSERT INTO Categories(name) VALUES
('category #1'),('category #2'),('category #3'),('category #4'), ('category #5');

INSERT INTO Products(name, id_category, markup) VALUES
('product #1', 1, 12), ('product #2', 1, 10), ('product #3', 11),
('product #4', 7), ('product #5', 12),
('product #6', 10), ('product #7', 11),
('product #8', 12), ('product #9', 10), ('product #10', 10),
('product #11', 12), ('product #12', 12);

/*
UPDATE Products
SET markup = 12;
*/

INSERT INTO Supplies(id_provider, id_employee) VALUES
(1,1), (2,1), (3,2),
(1,2), (2,2),
(3,1),
(1,3),
(2,4), (3,5),
(1,4), (2, 5), (3,5),
(1,1),
(2,1);

SELECT * FROM supplies;

INSERT INTO Contents(id_supply, id_product, counts, supply_price) VALUES
--1 day 1 provider (1,2,4,5 products)
(1, 1, 10, 120.50),
(1, 2, 20, 150.20),
(1, 4, 15, 140.10),
(1, 5, 20, 200.40),
--1day 2 provider (3,6 products)
(2, 3, 15, 125.00),
(2, 6, 10, 80.50),
--1day 3 provider (7,8 products)
(3, 7, 10, 90.30),
(3, 8, 10, 100.50),
-----------------------------
--2 day 1 provider (1,4 products)
(4, 1, 10, 120.50),
(4, 4, 10, 140.10),
--2 day 2 provider (3,6,9 products)
(2, 3, 10, 125.00),
(2, 6, 10, 80.50),
(2, 9, 10, 110.30);

--3 day supply#6 from 3 provider
INSERT INTO Contents(id_supply, id_product, counts, supply_price) VALUES
(3, 7, 10, 100.30),
(3, 8, 10, 110.50),
(3, 10, 10, 50.00),
(3, 11, 10, 65.00);


--смотрим конкретную поставку
SELECT * 
FROM Supplies
WHERE id = 1;

SELECT S.id, S.date, S.total_sum, 
    (SELECT name FROM Positions WHERE Positions.id = E.id_position), 
    concat(E.name, ' ', E.surname) as "employee", 
    P.name as "provider", P.tel
FROM supplies AS S
JOIN providers AS P ON P.id=S.id_provider
JOIN employees AS E ON E.id = S.id_employee
WHERE S.id = 1;

SELECT P.name, C.counts, C.supply_price
FROM Contents AS C
JOIN Products AS P ON P.id = C.id_product
WHERE id_supply = 1;












