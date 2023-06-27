/*
table Groups: id, name
table Users : id, login, id_group
table ListUsers: id_chat, id_user
table Chats: id, name
table Messages: id, title, body, id_chat, id_user, data
*/

/*
table Users: id, login
table Posts: id, id_user (author), title, body
table markPosts: id_user, id_post
*/

CREATE TABLE Users(
    id serial PRIMARY KEY,
    login varchar(64) NOT NULL
);

CREATE TABLE Posts(
    id serial PRIMARY KEY,
    user_id integer REFERENCES Users(id) ON DELETE SET NULL ON UPDATE CASCADE,
    title varchar(128) NOT NULL,
    body text
);

CREATE TABLE markPosts(
    user_id integer REFERENCES Users(id) ON DELETE SET NULL ON UPDATE CASCADE,
    post_id integer REFERENCES Posts(id) ON DELETE SET NULL ON UPDATE CASCADE
);
INSERT INTO Users(login) VALUES
('alex7'), ('bob14'), ('ann'), ('alex111'),('johnn');

INSERT INTO Posts(user_id, title, body) VALUES
(1, 'post title from 1', 'some text'),
(1, 'post title from 1', 'some text'),
(2, 'post title from 2', 'some text'),
(3, 'post title from 3', 'some text'),
(3, 'post title from 3', 'some text'),
(3, 'post title from 3', 'some text'),
(2, 'post title from 2', 'some text'),
(5, 'post title from 5', 'some text');

INSERT INTO markPosts VALUES
(1,2), (1,3), (1,6), (1,7), (1,8),
(2,1), (2,4), (2,5),
(4,1), (4,2), (4,3), (4,4), (4,5), (4,6), (4,7), (4,8),
(5,1), (5,4), (5,7), (5,8);


INSERT INTO markPosts VALUES (1,4);

/*
запросы
1. полная информация о конкретном посте
2. количество лайков для каждого поста
3. количество лайков для определенного поста
4. информация о посте + количество лайков
5. список постов которые лайкнули более 2 раз
6. сколько постов написал каждый юзер
7. сколько постов написал конкретный юзер
8. какой пост был самым популярным 
*/

/*1*/
SELECT Posts.title, Posts.body, Users.login
FROM Posts 
JOIN Users ON Users.id = Posts.user_id; 
/*2*/
SELECT post_id, COUNT(user_id)
FROM markPosts
GROUP BY post_id;

SELECT P.title, COUNT(MP.user_id)
FROM markPosts as MP
JOIN Posts as P ON P.id = MP.post_id
GROUP BY P.title;

/*3*/
SELECT P.title, COUNT(MP.user_id)
FROM markPosts as MP
JOIN Posts as P ON P.id = MP.post_id
WHERE MP.post_id = 1
GROUP BY P.title;

SELECT P.title, MP.post_id, COUNT(MP.user_id)
FROM markPosts as MP
JOIN Posts as P ON P.id = MP.post_id
GROUP BY P.title, MP.post_id
HAVING MP.post_id = 1;

/*4*/
SELECT Posts.title, Posts.body, COUNT(MarkPosts.post_id) as likes 
FROM Posts 
JOIN MarkPosts ON Posts.id = MarkPosts.post_id
GROUP BY Posts.title, Posts.body
ORDER BY likes;

/*
SELECT title, body,
    (SELECT COUNT(*) as likes 
    FROM MarkPosts
    WHERE Posts.id = MarkPosts.post_id) AS "likesPosts"
FROM Posts
ORDER BY "likesPosts";
*/

/*5*/
SELECT post_id, COUNT(user_id) as likes
FROM markPosts
GROUP BY post_id
HAVING COUNT(user_id) >= 2;

/*6*/
SELECT user_id, COUNT(post_id)
FROM MarkPosts
GROUP BY user_id;

SELECT Users.login, COUNT(MarkPosts.post_id)
FROM MarkPosts
JOIN Users ON Users.id = MarkPosts.user_id
GROUP BY Users.login;
/*7*/
SELECT Users.login, COUNT(MarkPosts.post_id)
FROM MarkPosts
JOIN Users ON Users.id = MarkPosts.user_id
WHERE Users.login = 'johnn'
GROUP BY Users.login;

/*8*/
SELECT post_id, COUNT(user_id) as likes
FROM markPosts
GROUP BY post_id
ORDER BY likes DESC, post_id
LIMIT 3;