/*
Создать таблицы, реализовать связи. Добавить данные тестовые

Запросы:
1 получить список студентов
2 получить список курсов
3 список студентов , которые учатся на конкретном курсе
4 вывести журнал оценок в виде fullName + mark
5 список курсов который изучает конкретный студент
6 список курсов которые идут более 40 часов
7 средний бал студента по вмем предметам
8 какой предмет студент сдал лучше остальных
9 какой предмет студент сдал хуже остальных
10 сколько человек сдали(изучают) каждый курс
11* средний бал по группе студентов по каждому курсу
12* кто учится лучше из студентов по конкретному курсу 
*/

CREATE TABLE Courses(
  id serial PRIMARY KEY,
  title varchar(255) NOT NULL,
  discription text,
  hours integer NOT NULL CHECK(hours >= 10)
);

CREATE TABLE Students(
  id serial PRIMARY KEY,
  name varchar(255) NOT NULL,
  surname varchar(255) NOT NULL
);

CREATE TABLE Exams(
  id_stud integer REFERENCES Students(id) ON DELETE SET NULL ON UPDATE CASCADE,
  id_course integer REFERENCES Courses(id) ON DELETE SET NULL ON UPDATE CASCADE,
  mark integer NOT NULL CHECK(mark > 0)
);

INSERT INTO Courses(title, hours) VALUES
('course1' , 40), ('course2' , 20), ('course3' , 60), ('course4' , 65);

INSERT INTO Students(name, surname) VALUES
('name1', 'surname1'), ('name2', 'surname2'), ('name3', 'surname3'), ('name4', 'surname4'),
('name5', 'surname5'), ('name6', 'surname6'), ('name7', 'surname7'), ('name8', 'surname8'),
('name9', 'surname9'), ('name10', 'surname10');

INSERT INTO Exams VALUES
(1,1,3), (1,2,4), (1,3,4), (1,4,4),
(2,1,4), (2,4,3),
(3,2,3), (3,3,3), (3,4,3),
(4, 1, 4), (4,2,3),
(5,2,4), (5,3,4), (5,4,3),
(6,1,5), (6,2,5), (6,3,5), (6,4,5),
(7,1,5), (7,2,4), (7,3,4), (5,4,5),
(8,1,4), (8,4,3),
(9,2,3), (9,3,3), (9,4,3),
(10, 1, 4), (10,2,3), (10, 3,4), (10,4,4);

/*1*/
SELECT * FROM Students;
/*2*/
SELECT * FROM Courses;
/*------*/
SELECT * FROM Exams;

/*5*/
SELECT id_course 
FROM Exams
WHERE id_stud = 2;

SELECT Courses.title
FROM Exams 
JOIN Courses ON Exams.id_course = Courses.id
JOIN Students ON Students.id = Exams.id_stud
WHERE Students.name = 'name1' AND Students.surname = 'surname1';

/*4* журнал оценок по конкретному предмету */
SELECT concat(S.name, S.surname) as "fullName", C.title, E.mark
FROM Exams as E 
JOIN Courses as C ON C.id = E.id_course
JOIN  Students as S ON S.id = E.id_stud
WHERE C.title = 'course1';

/*3*/
SELECT concat(S.name, S.surname) as "fullName"
FROM Exams 
JOIN Courses as C ON Exams.id_course = C.id
JOIN Students as S ON S.id = Exams.id_stud
WHERE C.title = 'course1';

/*6*/
SELECT title 
FROM Courses
WHERE hours >= 40;

/*------------------*/
/*
agregation FUNCTIONS
min, max, sum, count, avg
*/

/*10*/
/*--- работаем с одной табличкой ---*/
SELECT id_course, COUNT(id_stud) as "count studs"
FROM Exams
GROUP BY id_course;
/*--- работаем с двумя табличками ---*/
SELECT Courses.title, COUNT(Exams.id_stud) as "count studs"
FROM Exams
JOIN Courses ON Courses.id = Exams.id_course
GROUP BY Courses.title;

/*-----
пример, получить количество студентов (у которых оценка 4 и выше)
по каждому курсу
----*/

/*--- работаем с одной табличкой ---*/
SELECT id_course, COUNT(id_stud) as "count studs"
FROM Exams
WHERE mark >= 4
GROUP BY id_course;
/*--- работаем с двумя табличками ---*/
SELECT Courses.title, COUNT(Exams.id_stud) as "count studs"
FROM Exams
JOIN Courses ON Courses.id = Exams.id_course
WHERE Exams.mark >= 4
GROUP BY Courses.title;
/*--- тот же запрос но для людей с оценкой 3 ---*/
SELECT Courses.title, COUNT(Exams.id_stud) as "count studs"
FROM Exams
JOIN Courses ON Courses.id = Exams.id_course
WHERE Exams.mark = 3
GROUP BY Courses.title
ORDER BY "count studs";

/*7*/
/*--какой средний бал у каждого студента-*/
SELECT id_stud, round(AVG(mark),2) as "avgMark"
FROM Exams
GROUP BY id_stud;

/*--какой средний бал у конкретного студента-*/
SELECT id_stud, round(AVG(mark),2) as "avgMark"
FROM Exams
GROUP BY id_stud
HAVING id_stud = 1;

SELECT id_stud, round(AVG(mark),2) as "avgMark"
FROM Exams
WHERE id_stud = 1
GROUP BY id_stud;

SELECT concat(S.name, ' ', S.surname) as "fullName", round(AVG(E.mark),2) as "avgMark"
FROM Exams as E
JOIN Students as S ON S.id = E.id_stud
WHERE S.name = 'name1' AND S.surname = 'surname1'
GROUP BY "fullName";

SELECT concat(S.name, ' ', S.surname) as "fullName", round(AVG(E.mark),2) as "avgMark"
FROM Exams as E
JOIN Students as S ON S.id = E.id_stud
GROUP BY "fullName"
ORDER BY "avgMark" DESC;

/*8*/
SELECT concat(S.name, ' ', S.surname) as fullName, max(E.mark) as "best mark"
FROM Exams as E
JOIN Courses as C ON E.id_course = C.id
JOIN Students as S ON S.id = E.id_stud
GROUP BY fullName;

/*9*/
SELECT concat(S.name, ' ', S.surname) as "fullName", min(E.mark) as "best mark"
FROM Exams as E
JOIN Courses as C ON E.id_course = C.id
JOIN Students as S ON S.id = E.id_stud
GROUP BY "fullName";

