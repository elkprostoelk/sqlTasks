-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Время создания: Апр 07 2021 г., 18:01
-- Версия сервера: 10.4.17-MariaDB
-- Версия PHP: 8.0.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `shop`
--

DELIMITER $$
--
-- Процедуры
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetBookInfo` ()  BEGIN
	SELECT book_title, price, publishernames.publisher_name, bookformats.format_name FROM maininfo JOIN publishernames
  ON maininfo.publisher = publishernames.pub_id JOIN bookformats ON bookformats.format_id = maininfo.b_format;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetBookInfo_10` (`min_pages` INT)  BEGIN
  SELECT * FROM publishernames WHERE (SELECT MIN(pages) FROM maininfo WHERE maininfo.publisher = publishernames.pub_id) > min_pages;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetBookInfo_11` (`min_books_count` INT)  BEGIN
  SELECT * FROM categories WHERE (SELECT COUNT(*) FROM maininfo WHERE maininfo.category = categories.category_id) > min_books_count;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetBookInfo_12` (`pub_name` VARCHAR(255))  BEGIN
  SELECT * FROM maininfo WHERE EXISTS (SELECT * FROM publishernames WHERE publishernames.publisher_name = pub_name AND publishernames.pub_id = maininfo.publisher);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetBookInfo_13` (`pub_name` VARCHAR(255))  BEGIN
  SELECT * FROM maininfo WHERE NOT EXISTS (SELECT * FROM publishernames WHERE publishernames.publisher_name = pub_name AND publishernames.pub_id = maininfo.publisher)
    AND publisher = (SELECT publishernames.pub_id FROM publishernames WHERE publishernames.publisher_name = pub_name);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetBookInfo_14` ()  BEGIN
  ((SELECT * FROM topics) UNION (SELECT * FROM categories)) ORDER BY topic_name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetBookInfo_15` ()  BEGIN
  SELECT DISTINCT name FROM ((SELECT REGEXP_SUBSTR(TRIM(book_title), '^[^\\s]+') as name FROM maininfo)
    UNION ALL(SELECT REGEXP_SUBSTR(TRIM(category_name), '^[^\\s]+') as name FROM categories)) names
  ORDER BY name DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetBookInfo_2` ()  BEGIN
	SELECT book_title, price, publishernames.publisher_name, topics.topic_name, categories.category_name FROM maininfo JOIN publishernames
    ON maininfo.publisher = publishernames.pub_id JOIN topics ON maininfo.topic = topics.topic_id JOIN categories ON categories.category_id = maininfo.category;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetBookInfo_3` (`p_id` INT, `y_num` INT)  BEGIN
  SELECT * FROM maininfo WHERE publisher = p_id AND YEAR(pub_date) > y_num;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetBookInfo_4` ()  BEGIN
  SELECT categories.category_name, SUM(pages) FROM maininfo JOIN categories ON maininfo.category = categories.category_id GROUP BY category ORDER BY pages;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetBookInfo_5` (`topic_id` INT, `category_id` INT, OUT `count` INT)  BEGIN
  SELECT AVG(price) INTO count FROM maininfo WHERE maininfo.topic = topic_id AND maininfo.category = category_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetBookInfo_6` ()  BEGIN
  SELECT maininfo.*, publishernames.publisher_name, categories.category_name, bookformats.format_name, topics.topic_name FROM maininfo
  LEFT JOIN publishernames ON publishernames.pub_id = maininfo.publisher LEFT JOIN categories ON categories.category_id = maininfo.category
  LEFT JOIN topics ON topics.topic_id = maininfo.topic LEFT JOIN bookformats ON bookformats.format_id = maininfo.b_format;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetBookInfo_7` ()  BEGIN
  SELECT DISTINCT m.book_title as 1_book_title, m2.book_title 2_book_title FROM maininfo m
  JOIN maininfo m2
    ON m.pages = m2.pages AND m.N != m2.N;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetBookInfo_8` ()  BEGIN
  SELECT DISTINCT m.book_title as 1_book_title, m2.book_title 2_book_title, m3.book_title 3_book_title FROM maininfo m
  JOIN maininfo m2 ON m.price = m2.price AND m.N != m2.N
  JOIN maininfo m3 ON m.price = m3.price AND m.N != m3.N;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetBookInfo_9` (`c_name` VARCHAR(256))  BEGIN
  SELECT * from maininfo WHERE category = (SELECT category_id from categories WHERE categories.category_name = c_name);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `bookformats`
--

CREATE TABLE `bookformats` (
  `format_id` smallint(2) NOT NULL,
  `format_name` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `bookformats`
--

INSERT INTO `bookformats` (`format_id`, `format_name`) VALUES
(4, '60х88/16'),
(2, '70х100/16'),
(3, '84х108/16'),
(1, 'n/a');

-- --------------------------------------------------------

--
-- Структура таблицы `categories`
--

CREATE TABLE `categories` (
  `category_id` smallint(3) NOT NULL,
  `category_name` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `categories`
--

INSERT INTO `categories` (`category_id`, `category_name`) VALUES
(10, 'C&C++'),
(7, 'Linux'),
(1, 'n/a'),
(8, 'Unix'),
(6, 'Windows 2000'),
(5, 'Інші книги'),
(9, 'Інші операційні системи'),
(3, 'Апаратні засоби ПК'),
(4, 'Захист і безпека ПК'),
(2, 'Підручники'),
(11, 'Фентезі');

-- --------------------------------------------------------

--
-- Структура таблицы `maininfo`
--

CREATE TABLE `maininfo` (
  `N` smallint(3) NOT NULL,
  `val_code` int(4) NOT NULL DEFAULT 0,
  `isNew` varchar(3) NOT NULL DEFAULT 'No',
  `book_title` varchar(70) NOT NULL DEFAULT '',
  `price` float(5,2) NOT NULL CHECK (`price` > 0),
  `pages` int(11) DEFAULT NULL,
  `b_format` smallint(2) DEFAULT 0,
  `pub_date` date DEFAULT curdate(),
  `tirage` int(11) DEFAULT NULL,
  `topic` smallint(3) DEFAULT 0,
  `category` smallint(3) DEFAULT 0,
  `publisher` smallint(2) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `maininfo`
--

INSERT INTO `maininfo` (`N`, `val_code`, `isNew`, `book_title`, `price`, `pages`, `b_format`, `pub_date`, `tirage`, `topic`, `category`, `publisher`) VALUES
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

--
-- Триггеры `maininfo`
--
DELIMITER $$
CREATE TRIGGER `tr10` BEFORE INSERT ON `maininfo` FOR EACH ROW BEGIN
    IF (NEW.publisher <=> 2 AND NEW.b_format <=> 4) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Видавництво не видає книги у форматі 60х88 / 16';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr2` BEFORE INSERT ON `maininfo` FOR EACH ROW IF (NEW.isNew <=> 'Yes' && YEAR(NEW.pub_date) <> YEAR(NOW()))
THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Книга, видана не в поточному році, новинкою бути не може!';
END IF
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr3` BEFORE INSERT ON `maininfo` FOR EACH ROW IF ((NEW.price > 10 AND NEW.pages < 100) OR (NEW.price > 20 AND NEW.pages < 200) OR (NEW.price > 30 AND NEW.pages < 300))
THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ціна та кількість сторінок не відповідають одні одним';
END IF
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr4` BEFORE INSERT ON `maininfo` FOR EACH ROW IF ((NEW.publisher <=> 2 AND NEW.tirage < 5000) OR (NEW.publisher <=> 6 AND NEW.tirage < 1000))
THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Тираж для вказаного видавництва замалий';
END IF
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr5` BEFORE INSERT ON `maininfo` FOR EACH ROW BEGIN
    SET @records_count = 0;
    SELECT COUNT(*) INTO @records_count FROM maininfo
    WHERE val_code = NEW.val_code AND (
        isNew <> NEW.isNew OR
        book_title <> NEW.book_title OR
        price <> NEW.price OR
        publisher <> NEW.publisher OR
        pages <> NEW.pages OR
        b_format <> NEW.b_format OR
        pub_date <> NEW.pub_date OR
        tirage <> NEW.tirage OR
        topic <> NEW.topic OR
        category <> NEW.category
    );
    IF (@records_count <> 0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Книги з однаковим кодом потрібні бути з однаковими даними';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr6` BEFORE DELETE ON `maininfo` FOR EACH ROW BEGIN
    IF (REGEXP_SUBSTR(TRIM(CURRENT_USER()), '^[^@]+') <> 'root')
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Лише користувач dbo може видаляти книги';
    ELSE SET @columnscnt = 0;
    SELECT COUNT(*) INTO @columnscnt FROM information_schema.`schema1`
        WHERE table_name = 'maininfo' AND TABLE_SCHEMA = 'shop';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr7` BEFORE UPDATE ON `maininfo` FOR EACH ROW BEGIN
    IF (REGEXP_SUBSTR(TRIM(CURRENT_USER()), '^[^@]+') <=> 'root' AND NEW.price != OLD.price) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Поточний користувач не має права змінити ціну книги';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr8` BEFORE INSERT ON `maininfo` FOR EACH ROW BEGIN
    IF ((NEW.publisher IN (7, 9)) AND NEW.category <=> 2) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ці видавництва не видають підручники';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr9` BEFORE INSERT ON `maininfo` FOR EACH ROW BEGIN
    SET @publisher_newbooks_count = 0;
    SELECT COUNT(*) INTO @publisher_newbooks_count FROM maininfo
    WHERE maininfo.publisher = NEW.publisher AND maininfo.isNew='Yes' AND YEAR(NOW()) = YEAR(maininfo.pub_date) AND MONTH(NOW()) = MONTH(maininfo.pub_date);
    IF (NEW.isNew<=>'Yes' AND @publisher_newbooks_count IS NOT NULL AND @publisher_newbooks_count > 10) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Видавництво не може видавати більше за 10 новинок на місяць';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `publishernames`
--

CREATE TABLE `publishernames` (
  `pub_id` smallint(2) NOT NULL,
  `publisher_name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `publishernames`
--

INSERT INTO `publishernames` (`pub_id`, `publisher_name`) VALUES
(2, 'BHV С.-Петербург'),
(11, 'Bloomsbury'),
(6, 'DiaSoft'),
(1, 'n/a'),
(3, 'Вильямс'),
(7, 'ДМК'),
(5, 'МикроАрт'),
(4, 'Питер'),
(10, 'Русская редакция'),
(8, 'Триумф'),
(9, 'Эком');

-- --------------------------------------------------------

--
-- Структура таблицы `topics`
--

CREATE TABLE `topics` (
  `topic_id` smallint(3) NOT NULL,
  `topic_name` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `topics`
--

INSERT INTO `topics` (`topic_id`, `topic_name`) VALUES
(1, 'n/a'),
(2, 'Використання ПК в цілому'),
(5, 'Магічний світ'),
(3, 'Операційні системи'),
(4, 'Програмування');

--
-- Триггеры `topics`
--
DELIMITER $$
CREATE TRIGGER `tr1` BEFORE INSERT ON `topics` FOR EACH ROW IF (SELECT COUNT(*) FROM topics) > 10
THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Кількість тем більша за 10';
ELSEIF (SELECT COUNT(*) FROM topics) < 5
THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Кількість тем менша за 5';
END IF
$$
DELIMITER ;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `bookformats`
--
ALTER TABLE `bookformats`
  ADD PRIMARY KEY (`format_id`),
  ADD UNIQUE KEY `format_name` (`format_name`);

--
-- Индексы таблицы `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`),
  ADD UNIQUE KEY `category_name` (`category_name`);

--
-- Индексы таблицы `maininfo`
--
ALTER TABLE `maininfo`
  ADD PRIMARY KEY (`N`),
  ADD KEY `publisher` (`publisher`),
  ADD KEY `b_format` (`b_format`),
  ADD KEY `topic` (`topic`),
  ADD KEY `category` (`category`),
  ADD KEY `idx_title` (`book_title`);

--
-- Индексы таблицы `publishernames`
--
ALTER TABLE `publishernames`
  ADD PRIMARY KEY (`pub_id`),
  ADD UNIQUE KEY `publisher_name` (`publisher_name`);

--
-- Индексы таблицы `topics`
--
ALTER TABLE `topics`
  ADD PRIMARY KEY (`topic_id`),
  ADD UNIQUE KEY `topic_name` (`topic_name`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `bookformats`
--
ALTER TABLE `bookformats`
  MODIFY `format_id` smallint(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` smallint(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT для таблицы `publishernames`
--
ALTER TABLE `publishernames`
  MODIFY `pub_id` smallint(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT для таблицы `topics`
--
ALTER TABLE `topics`
  MODIFY `topic_id` smallint(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `maininfo`
--
ALTER TABLE `maininfo`
  ADD CONSTRAINT `maininfo_ibfk_1` FOREIGN KEY (`publisher`) REFERENCES `publishernames` (`pub_id`),
  ADD CONSTRAINT `maininfo_ibfk_2` FOREIGN KEY (`b_format`) REFERENCES `bookformats` (`format_id`),
  ADD CONSTRAINT `maininfo_ibfk_3` FOREIGN KEY (`topic`) REFERENCES `topics` (`topic_id`),
  ADD CONSTRAINT `maininfo_ibfk_4` FOREIGN KEY (`category`) REFERENCES `categories` (`category_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
