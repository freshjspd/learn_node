CREATE TABLE Users(
    id serial PRIMARY KEY,
    name varchar(64) NOT NULL,
    surname varchar(64) NOT NULL,
    isMale boolean, 
    age integer CHECK(age > 0),
    tel char(15),
    email varchar(64) UNIQUE NOT NULL
);

CREATE TABLE Tasks(
    id serial PRIMARY KEY,
    name varchar(100) NOT NULL,
    description text,
    created date DEFAULT now() NOT NULL,
    deadline date DEFAULT now() NOT NULL CHECK(deadline >= created),
    salary money DEFAULT 0 NOT NULL CHECK(salary >= money(0)),
    userId integer REFERENCES Users(id)
);

INSERT INTO Users (name, surname, isMale, age, email) VALUES
('Name1', 'Surname1', true, 20, 'name1@mail.com'),
('Name2', 'Surname2', false, 22, 'name2@mail.com'),
('Name3', 'Surname3', true, 18, 'name3@mail.com'),
('Name4', 'Surname4', true, 20, 'name4@mail.com'),
('Name5', 'Surname5', true, 25, 'name5@mail.com'),
('Name6', 'Surname6', true, 28, 'name6@mail.com'),
('Name7', 'Surname7', false, 21, 'name7@mail.com');

INSERT INTO Tasks(name, deadline, salary, userId) VALUES
('task1', '2023-06-03', 1000, 1),
('task1', '2023-06-09', 1200, 3),
('task1', '2023-06-08', 1040, 4),
('task2', '2023-06-07', 1220, 1),
('task2', '2023-06-08', 2000, 7),
('task3', '2023-06-05', 1400, 2),
('task3', '2023-06-06', 2500, 7),
('task4', '2023-06-03', 2050, 6),
('task5', '2023-06-07', 2430, 7);

INSERT INTO Tasks(name, deadline, salary, userId) VALUES
('task6', now(), 1000, 7),
('task6', '11.06.2023', 1000, 6);

INSERT INTO Tasks(name, deadline, salary, userId) VALUES
('task7', '01.07.2023+3', 1000, 6);

SELECT name, surname, tel, email
FROM Users;

SELECT *
FROM Tasks;

/*вывести первую 3-ку юзеров*/
SELECT *
FROM Users 
LIMIT 3 OFFSET 0;


/*вывести список задач отсортированных по дедлайну*/
SELECT *
FROM Tasks 
ORDER BY deadline;

/*получить инфу о 1 задаче*/
SELECT name, deadline, userId
FROM Tasks 
WHERE name = 'task1';

SELECT Tasks.name, Tasks.deadline, concat(Users.name, ' ', Users.surname) as fullname, Users.email
FROM Tasks, Users
WHERE Tasks.userId = Users.id and Tasks.name = 'task1';

/*в каких задачах учавствует 1-й пользователь*/
SELECT *
FROM Tasks
WHERE userId = 1;

/*мужчин которые старше 20лет упорядочить*/
SELECT *
FROM Users
WHERE isMale = true and age >=20
ORDER BY age DESC;

/*женщин которые младше 25лет упорядочить*/
SELECT *
FROM Users
WHERE isMale = false and age <=25
ORDER BY age DESC;

/*список задач в которых учавствуют девушки и кто именно*/
SELECT Tasks.name, Tasks.deadline, Users.email, Users.name
FROM Tasks, Users
WHERE Tasks.userId = Users.id and Users.isMale = false; 

/*вывести юзеров у которых в фамилии приcутствует комбинация 'name'*/
SELECT name, surname, tel, email
FROM Users
WHERE surname LIKE '%name%';

/*обновить почту у юзера*/
UPDATE Users
SET email = 'useruser5@mail.com'
WHERE id = 5;

/*удалить юзера из базы*/
DELETE FROM Users
WHERE id=7;

/*вывести задачи в период '5 июня' по '8 июня'*/
SELECT Tasks.name, Tasks.deadline, Users.email
FROM Tasks, Users
WHERE Tasks.userId = Users.id and deadline BETWEEN '2023-06-05' and '2023-06-08';

/*найти задачи в период '5 июня' по '8 июня и увеличить дату дедлайна на пару дней' */
UPDATE Tasks
SET deadline = deadline + 1
WHERE deadline BETWEEN '2023-06-05' and '2023-06-08';

/* увеличить бюджет на 20% для определнной задачи*/
UPDATE Tasks
SET salary  = salary * 1.2
WHERE name = 'task1';

/*---------------------------------------------------*/
/* HOME */

CREATE TABLE Subjects(
    id serial PRIMARY KEY,
    name varchar(64) NOT NULL,
    description text,
    hours integer CHECK(hours > 0) NOT NULL
);

CREATE TABLE Exam(
    fullName varchar(64) NOT NULL,
    idSubject integer REFERENCES Subjects(id),
    mark integer CHECK (mark>0 and mark<=5) NOT NULL,
    pass date DEFAULT now() NOT NULL
);

INSERT INTO Subjects (name, hours) VALUES
('math', 60),
('data base', 80),
('pic', 30);

INSERT INTO Exam VALUES
('fullname1', 1, 4),
('fullname1', 2, 5),
('fullname2', 1, 4),
('fullname2', 2, 4),
('fullname2', 3, 3),
('fullname3', 1, 4),
('fullname3', 3, 3),
('fullname4', 2, 5),
('fullname5', 3, 4);

/*1*/
SELECT name, hours
FROM Subjects;

/*2*/
SELECT fullName
FROM Exam
WHERE idSubject = 2;

SELECT fullName
FROM Exam, Subjects
WHERE Exam.idSubject = Subjects.id and Subjects.name = 'data base';

/*3*/
SELECT fullName
FROM Exam, Subjects
WHERE Exam.idSubject = Subjects.id and Subjects.name = 'data base' and Exam.mark =5;

/*4*/
SELECT fullName
FROM Exam
WHERE fullName = 'fullname1';

/*5*/
SELECT name, hours
FROM Subjects
WHERE hours >= 40;

/*6*/
UPDATE Subjects 
SET hours = 65
WHERE name = 'math';

/*7*/
DELETE FROM Subjects
WHERE name = 'math';




