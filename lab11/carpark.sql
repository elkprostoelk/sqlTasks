--создание базы
CREATE DATABASE carpark;

--таблица учета автомобилей
CREATE TABLE cars (
    car_id INT PRIMARY KEY IDENTITY(1,1),
    manufacturer INT NOT NULL DEFAULT 0,
    model NVARCHAR(50) NOT NULL DEFAULT '',
    plate_number NVARCHAR(8) NOT NULL DEFAULT '',
    car_type INT NOT NULL,
    driver INT UNIQUE
)

--таблица-список производителей авто
CREATE TABLE manufacturers(
    manufacturer_id INT PRIMARY KEY IDENTITY(0,1),
    manufacturer_name NVARCHAR(20) NOT NULL UNIQUE DEFAULT ''
)

--таблица-список типов автомобилей
CREATE TABLE car_types(
    cartype_id INT PRIMARY KEY IDENTITY(0,1),
    cartype_name NVARCHAR(20) NOT NULL UNIQUE DEFAULT ''
)

--таблица учета поездок
CREATE TABLE trips (
    trip_id INT PRIMARY KEY IDENTITY(1,1),
    starting_point NVARCHAR(50) NOT NULL DEFAULT '',
    finishing_point NVARCHAR(50) NOT NULL DEFAULT '',
    car INT NOT NULL,
    trip_description NVARCHAR(150),
    is_done BIT DEFAULT 0
)

--таблица учета водителей
CREATE TABLE drivers (
    driver_id INT PRIMARY KEY IDENTITY(1,1),
    driver_name NVARCHAR(50) NOT NULL DEFAULT '',
    gender NVARCHAR(1) NOT NULL DEFAULT 'М',
    passport_code NVARCHAR(20) NOT NULL DEFAULT '' UNIQUE,
    license_code NVARCHAR(20) DEFAULT '' UNIQUE
)

--добавление внешних ключей
ALTER TABLE cars ADD FOREIGN KEY (manufacturer) REFERENCES manufacturers(manufacturer_id);
ALTER TABLE cars ADD FOREIGN KEY (car_type) REFERENCES car_types(cartype_id);
ALTER TABLE cars ADD FOREIGN KEY (driver) REFERENCES drivers(driver_id);

--заполнение таблиц данными
INSERT INTO drivers (driver_name, gender, passport_code, license_code) VALUES
    ('Журавлев Филипп Артёмович', 'М', '10395005', 'AF5462808'),
    ('Герасимов Владимир Тимофеевич', 'М', '35254434', 'NB7955275'),
    ('Марков Матвей Александрович', 'М', '69060201', 'CO3145795'),
    ('Чернова Амина Ильинична', 'Ж', '44457743', 'GP7743773'),
    ('Пастухов Захар Вячеславович', 'М', '34389990', 'UO2456654'),
    ('Федорова София Тимофеевна', 'Ж', '46364741', 'RM8540787'),
    ('Козлов Андрей Ильич', 'М', '68392355', 'YY4258039'),
    ('Архипова Алёна Максимовна', 'Ж', '68986731', 'FQ4141975'),
    ('Михайлова Каролина Алексеевна', 'Ж', '70770175', 'ON7613172'),
    ('Ермаков Филипп Егорович', 'М', '75714480', 'TL2977507')

INSERT INTO car_types(cartype_name) VALUES
    ('n/a'),
    ('Седан'),
    ('Хэтчбэк'),
    ('Универсал'),
    ('Кроссовер'),
    ('Минивэн'),
    ('Пикап')

INSERT INTO manufacturers (manufacturer_name) VALUES
    ('n/a'),
    ('Mercedes-Benz'),
    ('Audi'),
    ('Volkswagen'),
    ('Ford'),
    ('Nissan'),
    ('VAZ')

INSERT INTO cars (manufacturer, model, plate_number, car_type, driver) VALUES
    (1, 'Sprinter', 'ЯБ3895ЖЩ', 5, 1),
    (4, 'Raptor', 'ПЯ4259БЮ', 6, 2),
    (2, 'A7', 'ХЯ2922ОТ', 1, 4),
    (1, 'ML 350', 'ЫХ6041ВО', 4, 9),
    (4, 'Transit', 'АЛ8571ХЪ', 5, 5),
    (5, 'Navara', 'ЦШ4708ММ', 6, 7),
    (6, '2114', 'ЬЦ7796ТЖ', 2, 8),
    (3, 'Passat Variant', 'БЦ5989ЙЫ', 3, 3),
    (5, 'Skyline R32', 'ЖУ4064ШД', 1, 10)

INSERT INTO trips (starting_point, finishing_point, car, trip_description, is_done) VALUES
    ('Херсон', 'Николаев', 1, 'Пассажирская перевозка', 1),
    ('Херсон', 'Киев', 5, 'Meest Express доставка товаров', 0),
    ('Одесса', 'Львов', 2, 'Прокат', 1),
    ('Киев', 'Херсон', 6, 'Перевозка бытовой техники', 1),
    ('Харьков', 'Сумы', 3, 'Перевозка дипломатии', 1),
    ('Чернигов', 'Ужгород', 8, 'Транспортировка людей до границы', 0),
    ('Полтава', 'Скадовск', 1, 'Перевозка до базы отдыха', 0)

--триггеры
CREATE TRIGGER check_passport_drv_license ON drivers FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @pass NVARCHAR(MAX), @lic NVARCHAR(MAX);
	SELECT @pass = passport_code FROM inserted;
	SELECT @lic = license_code FROM inserted;
    IF (LEN(@pass) <> 8 OR LEN(@lic) <> 9 OR ISNUMERIC(LEFT(@lic, 2))=1)
	BEGIN
		PRINT('Неверный формат паспорта и/или лицензии!');
		ROLLBACK TRANSACTION;
	END;
END;

CREATE TRIGGER start_and_finish_not_equal ON trips FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @start NVARCHAR(MAX), @finish NVARCHAR(MAX);
	SELECT @start = starting_point FROM inserted;
	SELECT @finish = finishing_point FROM inserted;
	IF(@start=@finish)
	BEGIN
		PRINT('Пункт отправки совпадает с пунктом прибытия! Если поездка в пределах одного города, уточните место отправки и прибытия!');
		ROLLBACK TRANSACTION;
	END;
END;

CREATE TRIGGER check_plate_number ON cars FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @number NVARCHAR(MAX)
	SELECT @number = plate_number FROM inserted;
	IF(ISNUMERIC(LEFT(@number, 2))=1 OR ISNUMERIC(RIGHT(@number, 2))=1 OR LEN(@number)<>8)
	BEGIN
		PRINT('Неверный формат номерного знака! Правильный формат: XX0000XX, X-буква, 0-цифра');
		ROLLBACK TRANSACTION;
	END;
END;

CREATE TRIGGER one_trip_is_not_done ON trips FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @car INT, @isdone BIT;
	SELECT @car = car FROM inserted;
	SELECT @isdone = is_done FROM inserted;
	IF(@isdone=0 AND (SELECT COUNT(car) FROM trips WHERE car=@car AND is_done=0)=1)
	BEGIN
		PRINT('Незавершенной может быть только одна поездка!');
		ROLLBACK TRANSACTION;
	END;
END;

--процедуры
CREATE PROCEDURE get_all_cars_with_drivers AS
BEGIN
	SELECT manufacturers.manufacturer_name, cars.model, cars.plate_number, car_types.cartype_name, drivers.* FROM cars JOIN drivers ON cars.driver=drivers.driver_id JOIN car_types ON cars.car_type=car_types.cartype_id JOIN manufacturers ON manufacturers.manufacturer_id=cars.manufacturer;
END;

CREATE PROCEDURE finish_the_trip @tripid INT AS
BEGIN
	UPDATE trips SET is_done=1 WHERE trip_id=@tripid;
END;

--функции
CREATE FUNCTION dbo.printDriversCountByGender (@genderFind NVARCHAR(1))
RETURNS INT
AS
BEGIN
	DECLARE @countg INT;
	SELECT @countg = COUNT(driver_id) FROM drivers WHERE gender=@genderFind;
	RETURN @countg;
END;
