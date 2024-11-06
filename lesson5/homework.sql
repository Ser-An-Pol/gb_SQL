/*
1. Создайте хранимую процедуру с именем «GetEmployeeOrders».
который принимает идентификатор сотрудника в качестве
параметра и возвращает все заказы, обработанные этим
сотрудником.
Пропишите запрос, который создаст требуемую процедуру.
*/


DROP PROCEDURE IF EXISTS GeekBrains.GetEmployeeOrders;

DELIMITER $$
$$
CREATE PROCEDURE GeekBrains.GetEmployeeOrders(pEmployeeID smallint)
BEGIN
	SELECT 
		o.OrderID 
	FROM Orders o 
	WHERE o.EmployeeID = pEmployeeID;
END$$
DELIMITER ;

CALL GetEmployeeOrders(3);

##########################################################################

/*
2. Создайте таблицу EmployeeRoles, как на уроке и удалите ее.
Напишите запрос, который удалит нужную таблицу.
*/

CREATE TABLE EmployeeRoles
(
	EmployeeRoleID INT NOT NULL AUTO_INCREMENT PRIMARY KEY
	, EmployeeID INT
	, Role VARCHAR(50)
)

DROP TABLE IF EXISTS EmployeeRoles

##########################################################################

/*
3. Удалите все заказы со статусом 'Delivered' из таблицы OrderStatus,
которую создавали на семинаре
Напишите запрос, который удалит нужные строки в таблице.
*/

DELETE FROM OrderStatus WHERE Status = 'Delivered';

##########################################################################

/*
Задание 1: Создание таблицы и изменение данных

Задание: Создайте таблицу EmployeeDetails для хранения информации о
сотрудниках. Таблица должна содержать следующие столбцы:
● EmployeeID (INTEGER, PRIMARY KEY)
● EmployeeName (TEXT)
● Position (TEXT)
● HireDate (DATE)
● Salary (NUMERIC)
После создания таблицы добавьте в неё три записи с произвольными данными о
сотрудниках.
*/

CREATE TABLE EmployeeDetails
(
	EmployeeID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY
	, EmployeeName TEXT
	, Position TEXT
	, HireDate DATE
	, Salary NUMERIC
)

INSERT INTO EmployeeDetails 
(EmployeeName, `Position`, HireDate, Salary) 
VALUES
('Peterson', 'Manager', '2023-11-23', 1200),
('Nickolson', 'Manager', '2020-10-03', 1500),
('Perry', 'Manager', '2024-04-15', 1700);

##########################################################################

/*
Задание 2: Создание представления

Задание: Создайте представление HighValueOrders для отображения всех заказов,
сумма которых превышает 10000. В представлении должны быть следующие столбцы:
● OrderID (идентификатор заказа),
● OrderDate (дата заказа),
● TotalAmount (общая сумма заказа, вычисленная как сумма всех Quantity *
Price).
Используйте таблицы Orders, OrderDetails и Products.
*/

CREATE VIEW HighValueOrders
AS
SELECT 
	o.OrderID 
	, o.OrderDate 
	, SUM(p.Price * od.Quantity) AS TotalAmount
FROM GeekBrains.Orders o 
JOIN GeekBrains.OrderDetails od ON o.OrderID = od.OrderID 
JOIN GeekBrains.Products p ON p.ProductID = od.ProductID 
GROUP BY o.OrderID, o.OrderDate 
HAVING SUM(p.Price * od.Quantity) > 10000;

SELECT * FROM HighValueOrders;	

##########################################################################

/*
Задание 3: Удаление данных и таблиц

Задание: Удалите все записи из таблицы EmployeeDetails, где Salary меньше
50000. Затем удалите таблицу EmployeeDetails из базы данных.
*/

DELETE FROM EmployeeDetails WHERE Salary < 50000;

DROP TABLE IF EXISTS EmployeeDetails;

##########################################################################

/*
Задание 4: Создание хранимой процедуры

Задание: Создайте хранимую процедуру GetProductSales с одним параметром
ProductID. Эта процедура должна возвращать список всех заказов, в которых
участвует продукт с заданным ProductID, включая следующие столбцы:
● OrderID (идентификатор заказа),
● OrderDate (дата заказа),
● CustomerID (идентификатор клиента).
*/

DROP PROCEDURE IF EXISTS GeekBrains.GetProductSales;

DELIMITER $$
$$
CREATE PROCEDURE GeekBrains.GetProductSales(pProductID smallint)
BEGIN
	SELECT 
		o.OrderID 
		, o.OrderDate 
		, o.CustomerID 
	FROM GeekBrains.Orders o 
	JOIN GeekBrains.OrderDetails od ON o.OrderID = od.OrderID 
	WHERE od.ProductID = pProductID;
END$$
DELIMITER ;

CALL GetProductSales(7);






