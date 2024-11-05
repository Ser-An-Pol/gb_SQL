/*
 	Задание №1
 	
Создайте таблицу с именем «OrderStatus». со
столбцами OrderStatusID, OrderID (INT), Status
(VARCHAR)
*/


CREATE TABLE OrderStatus (
	OrderStatusID SMALLINT NOT NULL AUTO_INCREMENT
	, OrderID INT
	, Status VARCHAR(50)
	, PRIMARY KEY (OrderStatusID)
);

DROP TABLE OrderStatus

------------------------------------------------------

/*
 	Задание №2
 	
Вставьте образец данных в поле «OrderStatus».
Поле для OrderID 101 со статусом 'Shipped'.
*/

INSERT INTO OrderStatus
(OrderID, Status)
VALUES(101, 'Shipped');


-------------------------------------------------------

SELECT * FROM OrderStatus os 

DELETE FROM OrderStatus WHERE OrderID = 101

------------------------------------------------------

/*
 	Задание №3
 	
Обновите параметр OrderStatus'
идентификатора заказа 101 на 'Delivered'.
*/

UPDATE OrderStatus
	SET Status = 'Delivered'
WHERE OrderID = 10248

------------------------------------------------------

/*
 	Задание №4
 	
Создайте представление с именем
«DeliveredOrders». которое отображает OrderID
и OrderDate для заказов со статусом 'Delivered'
*/

CREATE VIEW DeliveredOrders AS
SELECT
	o.OrderID 
	, o.OrderDate 
FROM OrderStatus os 
JOIN Orders o ON o.OrderID = os.OrderID 
WHERE os.Status = 'Delivered'

SELECT * FROM DeliveredOrders

------------------------------------------------------

/*
 	Задание №5
 	
Создайте процедуру с именем
«UpdateOrderStatus». который принимает
OrderID и Status в качестве параметров
и обновляет статус в 'OrderStatus'.
*/

DELIMITER $$
$$
CREATE PROCEDURE GeekBrains.UpdateOrderStatus(_OrderID SMALLINT, _Status VARCHAR(50))
BEGIN
	UPDATE OrderStatus
		SET Status = _Status
	WHERE OrderID = _OrderID;
END$$
DELIMITER ;

CALL UpdateOrderStatus(101, 'Delivered');



------------------------------------------------------

/*
 	Задание №6
 	
Создайте таблицу с именем «EmployeeRoles».
со столбцами EmployeeRoleID, EmployeeID
(INT), Role (VARCHAR).
*/


CREATE TABLE EmployeeRoles
(
	EmployeeRoleID INT NOT NULL AUTO_INCREMENT PRIMARY KEY
	, EmployeeID INT
	, Role VARCHAR(50)
)

------------------------------------------------------

/*
 	Задание №7
 	
Вставьте образец данных в поле
'EmployeeRoles' таблица для идентификатора
сотрудника 1 с должностью 'Manager'.
*/

INSERT INTO EmployeeRoles 
(EmployeeID, `Role`) 
VALUES(1, 'Manager');

------------------------------------------------------

/*
 	Задание №8
 	
Создайте представление с именем
«EmployeeRolesView». который отображает
идентификатор сотрудника, фамилию и роль
для сотрудников с должностью.
*/

CREATE VIEW EmployeeRolesView AS
SELECT 
	e.EmployeeID 
	, e.LastName 
	, er.`Role` 
FROM EmployeeRoles er 
JOIN Employees e ON e.EmployeeID = er.EmployeeID 

------------------------------------------------------

/*
 	Задание №9
 	
Создайте процедуру с именем
«AssignEmployeeRole». который принимает
идентификатор сотрудника и роль в качестве
параметров и вставляет новую должность
в 'EmployeeRoles'.
*/

CREATE PROCEDURE GeekBrains.AssignEmployeeRole(_EmployeeID INT, _Role VARCHAR(50))
BEGIN
	INSERT INTO EmployeeRoles
	(EmployeeID, `Role`) 
	VALUES
	(_EmployeeID, _Role);
END


CALL AssignEmployeeRole(2, 'Worker');

------------------------------------------------------

/*
 	Задание №10
 	
Создайте представление с именем
«HighValueOrdersView». который отображает
OrderID, CustomerID и OrderDate для заказов, общая
стоимость которых превышает 500 долларов США.
*/

CREATE VIEW HighValueOrdersView AS
SELECT 
	o.OrderID 
	, o.CustomerID 
	, o.OrderDate 
	#, od.Quantity*p.Price AS purch
FROM Orders o 
JOIN OrderDetails od ON od.OrderID = o.OrderID 
JOIN Products p ON od.ProductID = p.ProductID 
WHERE (od.Quantity*p.Price) > 500;

SELECT * FROM highvalueordersview h ;














