CREATE DATABASE shop;
USE shop;
GO
CREATE TABLE bookformats (
  format_id smallint NOT NULL PRIMARY KEY IDENTITY(0,1),
  format_name nvarchar(12) NOT NULL UNIQUE
)

INSERT INTO bookformats (format_name) VALUES
('n/a'),
('70х100/16'),
('84х108/16'),
('60х88/16');

CREATE TABLE categories (
  category_id smallint NOT NULL PRIMARY KEY IDENTITY(0,1),
  category_name nvarchar(25) NOT NULL UNIQUE
)

INSERT INTO categories (category_name) VALUES
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

CREATE TABLE publishernames (
  pub_id smallint NOT NULL PRIMARY KEY IDENTITY(0,1),
  publisher_name nvarchar(20) NOT NULL UNIQUE
)

INSERT INTO publishernames (publisher_name) VALUES
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

CREATE TABLE topics (
  topic_id smallint NOT NULL PRIMARY KEY IDENTITY(0,1),
  topic_name nvarchar(25) NOT NULL UNIQUE
)

INSERT INTO topics (topic_name) VALUES
('n/a'),
('Використання ПК в цілому'),
('Операційні системи'),
('Програмування'),
('Магічний світ');

CREATE TABLE maininfo (
  N smallint NOT NULL PRIMARY KEY,
  val_code int NOT NULL DEFAULT 0,
  isNew nvarchar(3) NOT NULL DEFAULT 'No',
  book_title nvarchar(70) NOT NULL DEFAULT '',
  price decimal(5,2) NOT NULL CHECK (price > 0),
  pages int DEFAULT NULL,
  b_format smallint DEFAULT 0,
  pub_date date DEFAULT GETDATE(),
  tirage int DEFAULT NULL,
  topic smallint DEFAULT 0,
  category smallint DEFAULT 0,
  publisher smallint NOT NULL DEFAULT 0
)

ALTER TABLE maininfo
  ADD FOREIGN KEY (publisher) REFERENCES publishernames (pub_id),
  FOREIGN KEY (b_format) REFERENCES bookformats (format_id),
  FOREIGN KEY (topic) REFERENCES topics (topic_id),
  FOREIGN KEY (category) REFERENCES categories (category_id);

INSERT INTO maininfo (N, val_code, isNew, book_title, price, pages, b_format, pub_date, tirage, topic, category, publisher) VALUES
(2, 5110, 'No', 'Аппаратные средства мультимедия. Видеосистема РС', 15.51, 400, 1, '2000-07-24', 5000, 1, 1, 1),
(8, 4985, 'No', 'Освой самостоятельно модернизацию и ремонт ПК за 24 часа, 2-е изд.', 18.90, 288, 1, '2000-07-07', 5000, 1, 1, 2),
(9, 5141, 'No', 'Структуры данных и алгоритмы.', 37.80, 384, 1, '2000-09-29', 5000, 1, 1, 2),
(20, 5127, 'Yes', 'Автоматизация инженерно-графических работ', 11.58, 256, 1, '2000-06-15', 5000, 1, 1, 3),
(31, 5110, 'No', 'Аппаратные средства мультимедиа. Видеосистема PC', 15.51, 400, 1, '2000-07-24', 5000, 1, 2, 1),
(46, 5199, 'No', 'Железо IBM 2001.', 30.07, 368, 1, '2000-02-12', 5000, 1, 2, 4),
(50, 3851, 'Yes', 'Защита информации и безопасность компьютерных систем', 26.00, 480, 2, '1999-02-04', 5000, 1, 3, 5),
(58, 3932, 'No', 'Как превратить персональный компьютер в измерительный комплекс', 7.65, 144, 3, '1999-06-09', 5000, 1, 4, 6),
(59, 4713, 'No', 'Plug- ins. Встраиваемые приложения для музыкальных программ', 11.41, 144, 1, '2000-02-22', 5000, 1, 4, 6),
(175, 5217, 'No', 'Windows ME. Новейшие версии программ', 16.57, 320, 1, '2000-08-25', 5000, 2, 5, 7),
(176, 4829, 'No', 'Windows 2000 Professional шаг за шагом с СD', 27.25, 320, 1, '2000-04-28', 5000, 2, 5, 8),
(188, 5170, 'No', 'Linux Русские версии', 24.43, 346, 1, '2000-09-29', 5000, 2, 6, 6),
(191, 860, 'No', 'Операционная система UNIX', 3.50, 395, 2, '1997-05-05', 5000, 2, 7, 1),
(203, 44, 'No', 'Ответы на актуальные вопросы по OS/2 Warp', 5.00, 352, 3, '1996-03-20', 5000, 2, 8, 5),
(206, 5176, 'No', 'Windows Me. Спутник пользователя', 12.79, 306, 0, '2000-10-10', 5000, 2, 8, 9),
(209, 5462, 'No', 'Язык программирования С++. Лекции и упражнения', 29.00, 656, 2, '2000-12-12', 5000, 3, 9, 5),
(210, 4982, 'No', 'Язык программирования С. Лекции и упражнения', 29.00, 432, 2, '2000-07-12', 5000, 3, 9, 5),
(220, 4687, 'No', 'Эффективное использование C++ .50 рекомендаций по улучшению ваших прог', 17.60, 240, 1, '2000-02-03', 5000, 3, 9, 6),
(228, 1337, 'No', 'Harry Potter and the Sorcerer`s Stone', 7.84, 223, 0, '1997-06-26', 10000, 4, 10, 9),
(230, 1400, 'No', 'Harry Potter and the Chamber of Secrets', 8.01, NULL, 0, NULL, NULL, 0, 0, 10);
USE shop;
GO

CREATE PROCEDURE GetBookInfo AS
BEGIN
	SELECT book_title, price, publishernames.publisher_name, bookformats.format_name FROM maininfo JOIN publishernames
  ON maininfo.publisher = publishernames.pub_id JOIN bookformats ON bookformats.format_id = maininfo.b_format
END;

USE shop;
GO

CREATE PROCEDURE GetBookInfo10 @min_pages INT AS
BEGIN
  SELECT * FROM publishernames WHERE (SELECT MIN(pages) FROM maininfo WHERE maininfo.publisher = publishernames.pub_id) > @min_pages;
END;

USE shop;
GO

CREATE PROCEDURE GetBookInfo11 @min_books_count INT AS BEGIN
  SELECT * FROM categories WHERE (SELECT COUNT(*) FROM maininfo WHERE maininfo.category = categories.category_id) > @min_books_count;
END;

USE shop;
GO

CREATE PROCEDURE GetBookInfo12 @pub_name NVARCHAR(255) AS BEGIN
  SELECT * FROM maininfo WHERE EXISTS (SELECT * FROM publishernames WHERE publishernames.publisher_name = @pub_name AND publishernames.pub_id = maininfo.publisher);
END;

USE shop;
GO

CREATE PROCEDURE GetBookInfo13 @pub_name NVARCHAR(255) AS BEGIN
  SELECT * FROM maininfo WHERE NOT EXISTS (SELECT * FROM publishernames WHERE publishernames.publisher_name = @pub_name AND publishernames.pub_id = maininfo.publisher)
    AND publisher = (SELECT publishernames.pub_id FROM publishernames WHERE publishernames.publisher_name = @pub_name);
END;

USE shop;
GO

CREATE PROCEDURE GetBookInfo14 AS BEGIN
  ((SELECT * FROM topics) UNION (SELECT * FROM categories)) ORDER BY topic_name;
END;

USE shop;
GO

CREATE PROCEDURE GetBookInfo15 AS BEGIN
  SELECT DISTINCT [name] FROM ((SELECT SUBSTRING(book_title,1,(CHARINDEX(' ',book_title + ' ')-1)) as [name] FROM maininfo)
    UNION ALL(SELECT SUBSTRING(category_name,1,(CHARINDEX(' ',category_name + ' ')-1)) as [name] FROM categories)) AS [names]
  ORDER BY [name] DESC;
END;

USE shop;
GO

CREATE PROCEDURE GetBookInfo2 AS BEGIN
	SELECT book_title, price, publishernames.publisher_name, topics.topic_name, categories.category_name FROM maininfo JOIN publishernames
    ON maininfo.publisher = publishernames.pub_id JOIN topics ON maininfo.topic = topics.topic_id JOIN categories ON categories.category_id = maininfo.category;
END;

USE shop;
GO

CREATE PROCEDURE GetBookInfo3 @p_id INT, @y_num INT AS BEGIN
  SELECT * FROM maininfo WHERE publisher = @p_id AND YEAR(pub_date) > @y_num;
END;

USE shop;
GO

CREATE PROCEDURE GetBookInfo4 AS BEGIN
  SELECT categories.category_name, SUM(pages) FROM maininfo JOIN categories ON maininfo.category = categories.category_id GROUP BY category_name ORDER BY SUM(pages);
END;

USE shop;
GO

CREATE PROCEDURE GetBookInfo5 @topic_id INT, @category_id INT, @count INT OUTPUT AS BEGIN
  SELECT @count=AVG(price) FROM maininfo WHERE maininfo.topic = @topic_id AND maininfo.category = @category_id;
END;

USE shop;
GO

CREATE PROCEDURE GetBookInfo6 AS BEGIN
  SELECT maininfo.*, publishernames.publisher_name, categories.category_name, bookformats.format_name, topics.topic_name FROM maininfo
  LEFT JOIN publishernames ON publishernames.pub_id = maininfo.publisher LEFT JOIN categories ON categories.category_id = maininfo.category
  LEFT JOIN topics ON topics.topic_id = maininfo.topic LEFT JOIN bookformats ON bookformats.format_id = maininfo.b_format;
END;

USE shop;
GO

CREATE PROCEDURE GetBookInfo7 AS BEGIN
  SELECT DISTINCT m.book_title as fst_book_title, m2.book_title snd_book_title FROM maininfo m
  JOIN maininfo m2
    ON m.pages = m2.pages AND m.N != m2.N;
END;

USE shop;
GO

CREATE PROCEDURE GetBookInfo8 AS BEGIN
  SELECT DISTINCT m.book_title as fst_book_title, m2.book_title snd_book_title, m3.book_title trd_book_title FROM maininfo m
  JOIN maininfo m2 ON m.price = m2.price AND m.N != m2.N
  JOIN maininfo m3 ON m.price = m3.price AND m.N != m3.N;
END;

USE shop;
GO

CREATE PROCEDURE GetBookInfo9 @c_name NVARCHAR(256) AS BEGIN
  SELECT * from maininfo WHERE category = (SELECT category_id from categories WHERE categories.category_name = @c_name);
END;

USE shop;
GO

CREATE TRIGGER tr1ins ON topics AFTER INSERT AS
BEGIN
IF (SELECT COUNT(topic_id) FROM topics) NOT BETWEEN 5 AND 10
BEGIN
	PRINT 'Кількість тем має бути від 5 до 10';
	ROLLBACK TRANSACTION;
END;
END;

CREATE TRIGGER tr1del ON topics AFTER DELETE AS
BEGIN
IF (SELECT COUNT(topic_id) FROM topics) NOT BETWEEN 5 AND 10
BEGIN
	PRINT 'Кількість тем має бути від 5 до 10';
	ROLLBACK TRANSACTION;
END;
END;

CREATE TRIGGER tr2 ON maininfo AFTER INSERT,UPDATE AS
BEGIN
DECLARE @new NVARCHAR(MAX), @pubdate DATE;
SELECT @new = isNew FROM INSERTED;
SELECT @pubdate = pub_date FROM INSERTED;
IF (@new = 'Yes' AND YEAR(@pubdate) <> YEAR(GETDATE()))
BEGIN
	PRINT 'Книга, видана не в поточному році, новинкою бути не може!';
	ROLLBACK TRANSACTION;
END;
END;

CREATE TRIGGER tr3 ON maininfo FOR INSERT,UPDATE AS
BEGIN
DECLARE @prices FLOAT, @pagescount INT;
SELECT @prices=price FROM inserted;
SELECT @pagescount=pages FROM inserted;
IF ((@prices > 10 AND @pagescount < 100) OR (@prices > 20 AND @pagescount < 200) OR (@prices > 30 AND @pagescount < 300))
BEGIN
	PRINT 'Ціна та кількість сторінок не відповідають одні одним';
	ROLLBACK TRANSACTION;
END;
END;

CREATE TRIGGER tr4 ON maininfo FOR INSERT,UPDATE AS
BEGIN
DECLARE @publishers INT, @tirages INT;
SELECT @publishers = publisher FROM inserted;
SELECT @tirages = tirage FROM inserted;
IF ((@publishers = 2 AND @tirages < 5000) OR (@publishers = 6 AND @tirages < 1000))
BEGIN	
	PRINT 'Тираж для вказаного видавництва замалий';
	ROLLBACK TRANSACTION;
END;
END;

CREATE TRIGGER tr5 ON maininfo FOR INSERT,UPDATE AS
BEGIN
	DECLARE @records_count INT,
	@valcode INT,
	@isnew nvarchar,
	@booktitle nvarchar,
	@prices float,
	@publishers int,
	@pagescnt int,
	@bformat int,
	@pubdate DATE,
	@tirages int,
	@topicsval int,
	@categrs int;
    SET @records_count = 0;
	SELECT @valcode = val_code FROM inserted;
	SELECT @isnew = isNew from inserted;
	SELECT @booktitle = book_title from inserted;
	SELECT @prices = price from inserted;
	SELECT @publishers = publisher from inserted;
	SELECT @pagescnt = pages from inserted;
	SELECT @bformat = b_format from inserted;
	SELECT @pubdate = pub_date from inserted;
	SELECT @tirages = tirage from inserted;
	SELECT @topicsval = topic from inserted;
	SELECT @categrs = category from inserted;
    SELECT @records_count = COUNT(*) FROM maininfo
    WHERE val_code = @valcode AND (
        isNew <> @isnew OR
        book_title <> @booktitle OR
        price <> @prices OR
        publisher <> @publishers OR
        pages <> @pagescnt OR
        b_format <> @bformat OR
        pub_date <> @pubdate OR
        tirage <> @tirages OR
        topic <> @topicsval OR
        category <> @categrs
    );
    IF (@records_count <> 0) PRINT 'Книги з однаковим кодом потрібні містити однакові дані';
END;

CREATE TRIGGER tr6 ON maininfo FOR DELETE AS
BEGIN
    IF (CURRENT_USER<>'dbo')
	BEGIN
		PRINT 'Лише користувач dbo може видаляти книги';
		ROLLBACK TRANSACTION;
	END;
    ELSE
	BEGIN
	DECLARE @del INT;
	SELECT @del = COUNT(*) FROM deleted;
	PRINT CAST(@del AS nvarchar) + ' рядків видалено';
    END;
END;

CREATE TRIGGER tr7 ON maininfo FOR UPDATE AS
BEGIN
	DECLARE @newpr FLOAT, @oldpr FLOAT;
	SELECT @newpr = price FROM inserted;
	SELECT @oldpr = price FROM deleted;
    IF (CURRENT_USER = 'dbo' AND @newpr <> @oldpr)
	BEGIN
        PRINT 'Поточний користувач не має права змінити ціну книги';
    END;
END

CREATE TRIGGER tr8 ON maininfo FOR INSERT, UPDATE AS
BEGIN
	DECLARE @newpub INT, @newcat INT;
	SELECT @newpub = publisher FROM inserted;
	SELECT @newcat = category FROM inserted;
    IF ((@newpub IN (7, 9)) AND @newcat = 2)
	BEGIN
        PRINT 'Ці видавництва не видають підручники';
		ROLLBACK TRANSACTION;
    END;
END

CREATE TRIGGER tr9 ON maininfo FOR INSERT,UPDATE AS
BEGIN
    DECLARE @publisher_newbooks_count INT,
	@publishers INT,
	@isnew nvarchar;
	SELECT @publishers = publisher FROM inserted;
	SELECT @isnew = isNew FROM inserted;
    SELECT @publisher_newbooks_count = COUNT(*)  FROM maininfo
    WHERE maininfo.publisher = @publishers AND maininfo.isNew='Yes' AND YEAR(GETDATE()) = YEAR(maininfo.pub_date) AND MONTH(GETDATE()) = MONTH(maininfo.pub_date);
    IF (@isnew='Yes' AND @publisher_newbooks_count IS NOT NULL AND @publisher_newbooks_count > 10)
	BEGIN
        PRINT 'Видавництво не може публікувати більше за 10 новинок на місяць';
		ROLLBACK TRANSACTION;
    END;
END

CREATE TRIGGER tr10 ON maininfo FOR INSERT, UPDATE AS
BEGIN
	DECLARE @publishers INT,
	@bformat INT;
	SELECT @publishers = publisher FROM inserted;
	SELECT @bformat = b_format FROM inserted;
    IF (@publishers = 2 AND @bformat = 4)
	BEGIN
        PRINT 'Видавництво не видає книги у форматі 60х88 / 16';
		ROLLBACK TRANSACTION;
    END;
END