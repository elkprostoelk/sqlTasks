--создание базы
CREATE DATABASE carpark;

--таблица учета автомобилей
CREATE TABLE cars (
    car_id INT PRIMARY KEY IDENTITY(1,1),
    manufacturer INT NOT NULL DEFAULT 0,
    model NVARCHAR(50) NOT NULL DEFAULT '',
    car_type INT NOT NULL,
    driver INT UNIQUE
)

--таблица-список производителей авто
CREATE TABLE manufacturers(
    manufacturer_id INT PRIMARY KEY IDENTITY(0,1),
    manufacturer_name NVARCHAR(20) NOT NULL UNIQUE DEFAULT '',
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
ALTER TABLE trips ADD FOREIGN KEY (car) REFERENCES cars(car_id);

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

--INSERT INTO cars (manufacturer, model, car_type, driver) VALUES
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

INSERT INTO cars (manufacturer, model, car_type, driver) VALUES
    (1, 'Sprinter', 5, 1),
    (4, 'Raptor', 6, 2),
    (2, 'A7', 1, 4),
    (1, 'ML 350', 4, 9)