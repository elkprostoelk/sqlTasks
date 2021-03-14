-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Время создания: Мар 07 2021 г., 13:44
-- Версия сервера: 10.4.17-MariaDB
-- Версия PHP: 8.0.2

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

-- --------------------------------------------------------

--
-- Структура таблицы `book_accountance`
--

CREATE TABLE `book_accountance` (
  `N` smallint(3) NOT NULL,
  `val_code` int(4) NOT NULL DEFAULT 0,
  `isNew` varchar(3) NOT NULL DEFAULT 'No',
  `book_title` varchar(70) NOT NULL DEFAULT '',
  `price` float(5,2) NOT NULL CHECK (`price` > 0),
  `publisher` varchar(20) NOT NULL,
  `pages` int(11) DEFAULT NULL,
  `b_format` varchar(12) DEFAULT NULL,
  `pub_date` date DEFAULT NULL,
  `tirage` int(11) DEFAULT NULL,
  `topic` varchar(25) DEFAULT NULL,
  `category` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `book_accountance`
--

INSERT INTO `book_accountance` (`N`, `val_code`, `isNew`, `book_title`, `price`, `publisher`, `pages`, `b_format`, `pub_date`, `tirage`, `topic`, `category`) VALUES
(2, 5110, 'No', 'Аппаратные средства мультимедия. Видеосистема РС', 15.51, 'BHV С.-Петербург', 400, '70x100/16', '2000-07-24', 5000, 'Використання ПК в цілому', 'Підручники'),
(8, 4985, 'No', 'Освой самостоятельно модернизацию и ремонт ПК за 24 часа, 2-е изд.', 18.90, 'Вильямс', 288, '70x100/16', '2000-07-07', 5000, 'Використання ПК в цілому', 'Підручники'),
(9, 5141, 'No', 'Структуры данных и алгоритмы.', 37.80, 'Вильямс', 384, '70x100/16', '2000-09-29', 5000, 'Використання ПК в цілому', 'Підручники'),
(20, 5127, 'Yes', 'Автоматизация инженерно-графических работ', 11.58, 'Питер', 256, '70x100/16', '2000-06-15', 5000, 'Використання ПК в цілому', 'Підручники'),
(31, 5110, 'No', 'Аппаратные средства мультимедиа. Видеосистема PC', 15.51, 'BNV С.-Петербург', 400, '70x100/16', '2000-07-24', 5000, 'Використання ПК в цілому', 'Апаратні засоби ПК'),
(46, 5199, 'No', 'Железо IBM 2001.', 30.07, 'МикроАрт', 368, '70x100/16', '2000-02-12', 5000, 'Використання ПК в цілому', 'Апаратні засоби ПК'),
(50, 3851, 'Yes', 'Защита информации и безопасность компьютерных систем', 26.00, 'DiaSoft', 480, '84x108/16', '1999-02-04', 5000, 'Використання ПК в цілому', 'Захист і безпека ПК'),
(58, 3932, 'No', 'Как превратить персональный компьютер в измерительный комплекс', 7.65, 'ДМК', 144, '60x88/16', '1999-06-09', 5000, 'Використання ПК в цілому', 'Інші книги'),
(59, 4713, 'No', 'Plug- ins. Встраиваемые приложения для музыкальных программ', 11.41, 'ДМК', 144, '70x100/16', '2000-02-22', 5000, 'Використання ПК в цілому', 'Інші книги'),
(175, 5217, 'No', 'Windows ME. Новейшие версии программ', 16.57, 'Триумф', 320, '70x100/16', '2000-08-25', 5000, 'Операційні системи', 'Windows 2000'),
(176, 4829, 'No', 'Windows 2000 Professional шаг за шагом с СD', 27.25, 'Эком', 320, '70x100/16', '2000-04-28', 5000, 'Операційні системи', 'Windows 2000'),
(188, 5170, 'No', 'Linux Русские версии', 24.43, 'ДМК', 346, '70x100/16', '2000-09-29', 5000, 'Операційні системи', 'Linux'),
(191, 860, 'No', 'Операционная система UNIX', 3.50, 'BHV С.-Петербург', 395, '84x100/16', '1997-05-05', 5000, 'Операційні системи', 'Unix'),
(203, 44, 'No', 'Ответы на актуальные вопросы по OS/2 Warp', 5.00, 'DiaSoft', 352, '60x84/16', '1996-03-20', 5000, 'Операційні системи', 'Інші операційні системи'),
(206, 5176, 'No', 'Windows Me. Спутник пользователя', 12.79, 'Русская редакция', 306, NULL, '2000-10-10', 5000, 'Операційні системи', 'Інші операційні системи'),
(209, 5462, 'No', 'Язык программирования С++. Лекции и упражнения', 29.00, 'DiaSoft', 656, '84x108/16', '2000-12-12', 5000, 'Програмування', 'С&C++'),
(210, 4982, 'No', 'Язык программирования С. Лекции и упражнения', 29.00, 'DiaSoft', 432, '84x108/16', '2000-07-12', 5000, 'Програмування', 'С&C++'),
(220, 4687, 'No', 'Эффективное использование C++ .50 рекомендаций по улучшению ваших прог', 17.60, 'ДМК', 240, '70x100/16', '2000-02-03', 5000, 'Програмування', 'С&C++'),
(228, 1337, 'No', 'Harry Potter and the Sorcerer`s Stone', 7.84, 'Bloomsbury', 223, NULL, '1997-06-26', 10000, 'Магічний світ', 'Фентезі'),
(230, 1400, 'No', 'Harry Potter and the Chamber of Secrets', 8.01, 'Bloomsbury', NULL, NULL, NULL, NULL, NULL, NULL);

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `book_accountance`
--
ALTER TABLE `book_accountance`
  ADD PRIMARY KEY (`N`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;