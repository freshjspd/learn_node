/*
100 Сидоров А.А. ПС-100 Матем 1курс 1сем 5
100 Сидоров А.А. ПС-100 Матем 1курс 2сем 4
100 Сидоров А.А. ПС-100 Матем 2курс 1сем 5
100 Сидоров А.А. ПС-100 Матем 2курс 2сем 5
100 Сидоров А.А. ПС-100 Фикику 1курс 1сем 4
100 Сидоров А.А. ПС-100 Физика 1курс 2сем 4
100 Сидоров А.А. ПС-100 Физра 1курс 1сем 5
100 Сидоров А.А. ПС-100 Физра 1курс 2сем 5
100 Сидоров А.А. ПС-100 Физра 2курс 1сем 5
100 Сидоров А.А. ПС-100 Физра 2курс 2сем 5
100 Сидоров А.А. ПС-100 ЬД 3курс 1сем 5
100 Сидоров А.А. ПС-100 БД 3курс 2сем 5
100 Сидоров А.А. ПС-100 Дискретка 3курс 2сем 4
105 Иванов А.А. ПС-100 Матем 1курс 1сем 5
105 Иванов А.А. ПС-100 Матем 1курс 2сем 4
105 Иванов А.А. ПС-100 Матем 2курс 1сем 5
105 Иванов А.А. ПС-100 Матем 2курс 2сем 5
105 Иванов А.А. ПС-100 Фикику 1курс 1сем 4
105 Иванов А.А. ПС-100 Физика 1курс 2сем 4
105 Иванов А.А. ПС-100 Физра 1курс 1сем 5
105 Иванов А.А. ПС-100 Физра 1курс 2сем 5
105 Иванов А.А. ПС-100 Физра 2курс 1сем 5
105 Иванов А.А. ПС-100 Физра 2курс 2сем 5
105 Иванов А.А. ПС-100 ЬД 3курс 1сем 5
105 Иванов А.А. ПС-100 БД 3курс 2сем 5
105 Иванов А.А. ПС-100 Дискретка 3курс 2сем 4

Группа - id, название
Студенты - id, ФИО, др.данные, id_group, course, part
Дисциплина - id , название, кол-во часов, id_препода
Журнал - id_stud, mark, id_subject
*/

/* Чатбот*/
--Users
-- name, surname, login, passwordHash

--Messages
--text, author(user_id), chat_id, created, updated

--Chats
--name, created, owner (user_id)

--Users_to_chats
--chat_id, user_id


--Users 1 : M Messages (1 message - 1user) 1-M
--Users : Chats (1 user - M chats, 1chat - M chats) M-M
--Chats : Messages (1 chat - M messages, 1message - 1chat) 1-M

------------------
DROP DATABASE test4;

CREATE DATABASE test4;

CREATE TABLE Users(
    id serial PRIMARY KEY,
    name varchar(64),
    surname varchar(64),
    login varchar(16) NOT NULL UNIQUE CHECK(char_length(login) >= 6),
    passwordHash text NOT NULL
);


CREATE TABLE Chats(
    id serial PRIMARY KEY,
    name varchar(64),
    owner int REFERENCES Users(id) ON DELETE SET NULL ON UPDATE CASCADE,
    created timestamp DEFAULT now()
);

CREATE TABLE Users_to_chats(
    user_id int REFERENCES Users(id) ON DELETE SET NULL ON UPDATE CASCADE,
    chat_id int REFERENCES Chats(id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Messages(
    id serial PRIMARY KEY,
    value text NOT NULL,
    created timestamp DEFAULT now(),
    updated timestamp DEFAULT now(),
    author int REFERENCES Users(id) ON DELETE SET NULL ON UPDATE CASCADE,
    chat_id int REFERENCES Chats(id) ON DELETE SET NULL ON UPDATE CASCADE
);


INSERT INTO Users(name, surname, login, passwordHash) VALUES
('John', 'Smith', 'john123', 'qwerty'),
('Ann', 'Smith', 'annsunny', 'qwerty'),
('Tom', 'Tomson', 'tomtom', 'qwerty'),
('Jack', 'Nikeson', 'nikej10', 'qwerty'),
('Kate', 'Adson', 'kate_flower', 'qwerty');

INSERT INTO Chats(name, owner) VALUES
('Java Script', 1),
('Database sql', 3);

INSERT INTO Users_to_chats(user_id, chat_id) VALUES
(1,1), (2,1), (4,1), (5,1),
(3,2), (4,2), (5,2);

INSERT INTO Messages (author, chat_id, value) VALUES
(1, 1, 'hello'),
(2, 1, 'test2'),
(1, 1, 'test3'),
(4, 1, 'test4'),
(5, 1, 'test5'),
(5, 1, 'test6'),
(2, 1, 'test3'),
(3, 2, 'test1'),
(5, 2, 'test2'),
(5, 2, 'test3'),
(3, 2, 'test4'),
(4, 2, 'test5'),
(5, 2, 'test6'),
(3, 2, 'test3');

SELECT * FROM Users;

SELECT * FROM Chats;

SELECT * FROM Users_to_chats;

SELECT * FROM Messages;

/* измение таблиц (модификация)*/
--добавление столбца
--удаление столбца
--добавление ограничения
--удаление ограничения
--измение значения по-умолчанию
--изменение типа данных для столбца
--переименование столбца
--переименование таблицы

--ALTER TABLE

CREATE TABLE testTable(
    column1 integer,
    column2 varchar(50)
);

--добавление столбца
--ALTER TABLE table1 ADD COLUMN name1 type1;
ALTER TABLE testTable ADD COLUMN column3 varchar(30);
ALTER TABLE testTable ADD COLUMN column4 int CHECK(column4 > 0);

INSERT INTO testTable VALUES
(10, 'hello', 'vasya', 20),
(10, 'hi', 'tom', 22),
(10, 'good day', 'john', 20);

INSERT INTO testTable VALUES
(12, 'hello', 'ann', 20);

SELECT * FROM testTable;

ALTER TABLE testTable ADD COLUMN columnTel char(16);
ALTER TABLE testTable ADD COLUMN isMale bool DEFAULT true;

UPDATE testTable
SET isMale = FALSE
WHERE column3 = 'ann';

UPDATE testTable
SET isMale = true
WHERE column3 = 'nike';

UPDATE testTable
SET columnTel = '0991234567'
WHERE column3 = 'vasya';

UPDATE testTable
SET columnTel = '0990000567'
WHERE column3 = 'john';

--удаление столбца
--ALTER TABLE table1 DROP COLUMN column1;
--ALTER TABLE table1 DROP COLUMN column1 CASCADE;

SELECT * FROM testTable;

ALTER TABLE testTable DROP COLUMN column1;

--добавление ограничения
ALTER TABLE table1 ADD CHECK();
ALTER TABLE ADD CONSTRAINT name1;
ALTER TABLE table1 ADD FOREIGN KEY id_column REFERENCES table2;

--вопрос об обязательном поле
ALTER TABLE table1 ALTER COLUMN column1 SET NOT NULL;

ALTER TABLE testTable ADD CHECK (column4 <= 100);

ALTER TABLE testTable ADD CONSTRAINT columnTel UNIQUE (columnTel);

INSERT INTO testTable VALUES
('hello', 'nike', 25, '0951111111', false);

INSERT INTO testTable VALUES
('hello', 'eva', 22, '0951111123', false);

--удаление ограничения
--нужно знать его имя
--если не знаем имя psql \d name_table

--ALTER TABLE table1 DROP CONSTRAINT name_constraint;
--ALTER TABLE table1 DROP CONSTRAINT name_constraint CASCADE;

--not null !!!!!!
--ALTER TABLE table1 ALTER COLUMN column1 DROP NOT NULL;

ALTER TABLE testTable DROP CONSTRAINT columnTel;

INSERT INTO testTable VALUES
('hi', 'masha', 20, '0951111123', false);

--измение значения по-умолчанию
--ALTER TABLE table1 ALTER COLUMN column1 SET DEFAULT new_value;

ALTER TABLE testTable ALTER COLUMN isMale SET DEFAULT false;

ALTER TABLE testTable ALTER COLUMN column4 SET DEFAULT 20;

ALTER TABLE testTable ALTER COLUMN column2 SET DEFAULT 'hello!';

INSERT INTO testTable(column3, columnTel) VALUES
('eva', '0952851123');

DELETE FROM testTable
WHERE column3 = 'eva';

SELECT * FROM testTable;

-- удаление значения по-умолчанию
--ALTER TABLE table1 ALTER COLUMN column1 DROP DEFAULT;
ALTER TABLE testTable ALTER COLUMN column4 DROP DEFAULT;

--изменение типа данных для столбца
--ALTER TABLE table1 ALTER COLUMN column1 TYPE new_type

ALTER TABLE testTable ALTER COLUMN column2 TYPE text;

ALTER TABLE testTable ALTER COLUMN column4 TYPE numeric(10,2);

ALTER TABLE testTable ALTER COLUMN column4 TYPE int2;

--переименование столбца
--ALTER TABLE table1 RENAME COLUMN column1 TO column1_newname

ALTER TABLE testTable RENAME COLUMN column2 TO "greeting";
ALTER TABLE testTable RENAME COLUMN column3 TO "user name";
ALTER TABLE testTable RENAME COLUMN column4 TO age;
ALTER TABLE testTable RENAME COLUMN columnTel TO tel;
 
--переименование таблицы
--ALTER TABLE table1 RENAME TO table1_newname

ALTER TABLE testTable RENAME TO testUsers;

SELECT * FROM public.testUsers;

INSERT INTO testUsers ("user name", age, tel, isMale) VALUES
('oleg', 21, '0991845602', true);

/*Схемы*/

CREATE SCHEMA sandbox;

CREATE TABLE sandbox.testTable(
    column1 integer,
    column2 varchar(50)
);

INSERT INTO sandbox.testTable VALUES
(10, 'vasya'),
(11, 'tom'),
(12, 'john');

SELECT * FROM sandbox.testTable;

DROP SCHEMA sandbox CASCADE;

/*view*/

--CREATE VIEW view_name AS query;

CREATE VIEW owners_chats AS
SELECT C.id, C.name, 
        U.name || ' ' || U.surname as "owner",
        C.created
FROM Chats AS C
JOIN Users AS U ON U.id = C.owner;

SELECT * FROM owners_chats;

CREATE VIEW messages_view AS
SELECT M.value, M.created, M.chat_id, U.name || ' ' || U.surname as "owner"
FROM Messages AS M
JOIN Users AS U ON M.author = U.id;

SELECT * FROM messages_view;

SELECT value, owner
 FROM messages_view;

SELECT owner, count(value)
FROM messages_view
GROUP BY owner;

CREATE VIEW top3messages AS
SELECT *
FROM messages_view
LIMIT 3;

SELECT * FROM top3messages;

--------------------------
CREATE VIEW like_posts_view2 AS
SELECT P.id, P.user_id, U.login, P.title, P.body,
count(MP.post_id) AS "likes"
FROM Posts AS P
JOIN MarkPosts AS MP ON P.id = MP.post_id
JOIN Users AS U ON U.id = P.user_id
GROUP BY P.id, P.user_id, U.login, P.title, P.body;

SELECT *
FROM like_posts_view2;









