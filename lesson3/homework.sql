/*
1. Посчитать средний чек одного заказа.
*/

SELECT 
	AVG(od.Quantity * p.Price)
FROM Orders o 
JOIN OrderDetails od ON o.OrderID = od.OrderID 
JOIN Products p ON od.ProductID = p.ProductID 

-- Средний чек составляет: 745.992722007722

---------------------------------------------

/*
2. Посчитать сколько заказов доставляет в месяц
каждая служба доставки.
Определите, сколько заказов доставила United
Package в декабре 2023 года
*/

SELECT 
	s.ShipperName 
	, strftime('%m', o.OrderDate) AS month
	, COUNT (*)
FROM Shippers s 
JOIN Orders o ON s.ShipperID = o.ShipperID 
GROUP BY s.ShipperName , month

--United Package в декабре 2023 года доставила: 8 заказов

---------------------------------------------

/*
3. Определить средний LTV покупателя (сколько
денег покупатели в среднем тратят в магазине
за весь период)
*/

WITH expenses AS
(
SELECT 
c.CustomerID 
, SUM(od.Quantity * p.Price) AS exp
FROM Orders o 
JOIN OrderDetails od ON o.OrderID = od.OrderID 
JOIN Products p ON od.ProductID = p.ProductID 
JOIN Customers c ON c.CustomerID = o.CustomerID 
GROUP BY c.CustomerID 
)
SELECT 
	AVG(expenses.exp)
FROM expenses

-- LTV = 5221.949054054054

---------------------------------------------





