/*
Типы данных

ПРОСТЫЕ

- числовые
integer (int4, int), smallint (int2), biging(int8)
serial, smallserial, bigserial 
numeric(precision, scale), decimal, real
- символьные (строчные)
char(n), varchar(n), text // character(n), character varing(n)
- логические boolean (TRUE, FALSE, 't', 'f', '1', '0', 'yes', 'no', 'y', 'n', 'on', 'off')
- бинарные bytea
- дата и время
date, time, interval, timestamp
- ip - cidr, inet, macaddr, uuid (32 байта)
- line, point, box,.... path
- xml, json, jsonb

СОСТАВНЫЕ

1 массивы

CREATE TABLE Users(
    id serial primary key,
    fullName varchar(128) not null,
    ...
    langs varchar(10)[],
);

INSERT INTO Users(fullname, langs) VALUES
('Daniel Smith', '{"ua", "eng", "sp"}'),
('Megan Miller', '{"eng", "fra"}');

SELECT langs FROM Users;

SELECT langs[0:2] FROM Users;

UPDATE Users 
SET langs = '{}'
WHERE id=100;

UPDATE Users 
SET langs = '{"eng", "sp", "fra"}'
WHERE id=100;

UPDATE Users 
SET langs[2] = "spa"
WHERE id=100;

2 перечисление ENUM
CREATE TYPE

CREATE TYPE user_sys_roles AS ENUM ('admin', 'moderator', 'user', 'guest');

CREATE TYPE request_status AS ENUM ('created', 'approved', 'finished');

*/
CREATE TYPE user_sys_roles AS ENUM ('admin', 'moderator', 'user', 'guest');

CREATE TABLE Users(
    id serial primary key,
    login varchar(64) NOT NULL,
    passwordHash text NOT NULL,
    sys_role user_sys_roles
);

INSERT INTO Users(login, passwordHash, sys_role) VALUES
('jacob', 'qwerty', 'moderator'),
('grace', 'qwerty', 'user'),
('emma', 'qwerty', 'user'),
('david', 'qwerty', 'user'),
('john', 'qwerty', 'moderator');

SELECT * FROM Users;

UPDATE Users 
SET sys_role = 'admin'
WHERE id = 5;

ALTER TYPE user_sys_roles 
ADD VALUE 'anon';

