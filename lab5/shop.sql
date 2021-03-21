DROP DATABASE IF EXISTS shop;
CREATE DATABASE IF NOT EXISTS shop;
CREATE TABLE MainInfo(
    N SMALLINT(3) NOT NULL PRIMARY KEY,
    val_code INT(4) NOT NULL DEFAULT 0,
    isNew varchar(3) NOT NULL DEFAULT 'No',
    book_title VARCHAR(70) NOT NULL DEFAULT '',
    price FLOAT(5, 2) NOT NULL CHECK (price > 0),
    pages INT(11) DEFAULT NULL,
    b_format SMALLINT(2) DEFAULT 0,
    pub_date DATE DEFAULT CURRENT_DATE(),
    tirage INT(11) DEFAULT NULL,
    topic SMALLINT(3) DEFAULT 0,
    category SMALLINT(3) DEFAULT 0,
    publisher SMALLINT(2) NOT NULL DEFAULT 0
);
CREATE TABLE PublisherNames(
    pub_id SMALLINT(2) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    publisher_name VARCHAR(20) UNIQUE NOT NULL
);
CREATE TABLE BookFormats(
    format_id SMALLINT(2) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    format_name VARCHAR(12) UNIQUE NOT NULL
);
CREATE TABLE Topics(
    topic_id SMALLINT(3) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    topic_name VARCHAR(25) UNIQUE NOT NULL
);
CREATE TABLE Categories(
    category_id SMALLINT(3) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(25) UNIQUE NOT NULL
);
ALTER TABLE maininfo ADD FOREIGN KEY (publisher) REFERENCES PublisherNames(pub_id);
ALTER TABLE maininfo ADD FOREIGN KEY (b_format) REFERENCES BookFormats(format_id);
ALTER TABLE maininfo ADD FOREIGN KEY (topic) REFERENCES Topics(topic_id);
ALTER TABLE maininfo ADD FOREIGN KEY (category) REFERENCES Categories(category_id);
CREATE INDEX idx_title ON
    shop.MainInfo(book_title);
INSERT INTO BookFormats(format_name) VALUES ('n/a'), ('70х100/16'), ('84х108/16'), ('60х88/16');
INSERT INTO PublisherNames(publisher_name) VALUES 
  ('n/a'),
  ('BHV С.-Петербург'),
  ('Вильямс'),
  ('Питер'),
  ('МикроАрт'),
  ('DiaSoft'),
  ('ДМК'),
  ('Триумф'),
  ('Эком'),
  ('Русская редакция'),
  ('Bloomsbury');
INSERT INTO Categories(category_name) VALUES 
  ('n/a'),
  ('Підручники'),
  ('Апаратні засоби ПК'),
  ('Захист і безпека ПК'),
  ('Інші книги'),
  ('Windows 2000'),
  ('Linux'),
  ('Unix'),
  ('Інші операційні системи'),
  ('C&C++'),
  ('Фентезі');
INSERT INTO Topics(topic_name) VALUES 
  ('n/a'),
  ('Використання ПК в цілому'),
  ('Операційні системи'),
  ('Програмування'),
  ('Магічний світ');
INSERT INTO MainInfo (N, val_code, isNew, book_title, price, pages, b_format, pub_date, tirage, topic, category, publisher) VALUES
(2, 5110, 'No', 'Аппаратные средства мультимедия. Видеосистема РС', 15.51, 400, 2, '2000-07-24', 5000, 2, 2, 2),
(8, 4985, 'No', 'Освой самостоятельно модернизацию и ремонт ПК за 24 часа, 2-е изд.', 18.90, 288, 2, '2000-07-07', 5000, 2, 2, 3),
(9, 5141, 'No', 'Структуры данных и алгоритмы.', 37.80, 384, 2, '2000-09-29', 5000, 2, 2, 3),
(20, 5127, 'Yes', 'Автоматизация инженерно-графических работ', 11.58, 256, 2, '2000-06-15', 5000, 2, 2, 4),
(31, 5110, 'No', 'Аппаратные средства мультимедиа. Видеосистема PC', 15.51, 400, 2, '2000-07-24', 5000, 2, 3, 2),
(46, 5199, 'No', 'Железо IBM 2001.', 30.07, 368, 2, '2000-02-12', 5000, 2, 3, 5),
(50, 3851, 'Yes', 'Защита информации и безопасность компьютерных систем', 26.00, 480, 3, '1999-02-04', 5000, 2, 4, 6),
(58, 3932, 'No', 'Как превратить персональный компьютер в измерительный комплекс', 7.65, 144, 4, '1999-06-09', 5000, 2, 5, 7),
(59, 4713, 'No', 'Plug- ins. Встраиваемые приложения для музыкальных программ', 11.41, 144, 2, '2000-02-22', 5000, 2, 5, 7),
(175, 5217, 'No', 'Windows ME. Новейшие версии программ', 16.57, 320, 2, '2000-08-25', 5000, 3, 6, 8),
(176, 4829, 'No', 'Windows 2000 Professional шаг за шагом с СD', 27.25, 320, 2, '2000-04-28', 5000, 3, 6, 9),
(188, 5170, 'No', 'Linux Русские версии', 24.43, 346, 2, '2000-09-29', 5000, 3, 7, 7),
(191, 860, 'No', 'Операционная система UNIX', 3.50, 395, 3, '1997-05-05', 5000, 3, 8, 2),
(203, 44, 'No', 'Ответы на актуальные вопросы по OS/2 Warp', 5.00, 352, 4, '1996-03-20', 5000, 3, 9, 6),
(206, 5176, 'No', 'Windows Me. Спутник пользователя', 12.79, 306, 1, '2000-10-10', 5000, 3, 9, 10),
(209, 5462, 'No', 'Язык программирования С++. Лекции и упражнения', 29.00, 656, 3, '2000-12-12', 5000, 4, 10, 6),
(210, 4982, 'No', 'Язык программирования С. Лекции и упражнения', 29.00, 432, 3, '2000-07-12', 5000, 4, 10, 6),
(220, 4687, 'No', 'Эффективное использование C++ .50 рекомендаций по улучшению ваших прог', 17.60, 240, 2, '2000-02-03', 5000, 4, 10, 7),
(228, 1337, 'No', 'Harry Potter and the Sorcerer`s Stone', 7.84, 223, 1, '1997-06-26', 10000, 4, 11, 10),
(230, 1400, 'No', 'Harry Potter and the Chamber of Secrets', 8.01, NULL, 1, NULL, NULL, 1, 1, 11);