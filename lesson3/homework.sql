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

/*
Задание: Определите общую прибыль для каждой категории продуктов,
используя таблицы OrderDetails, Orders и Products. Для расчета прибыли
умножьте цену продукта на количество, а затем суммируйте результаты по
категориям.
*/

SELECT 
c.CategoryID 
, c.CategoryName 
, SUM(od.Quantity * p.Price) AS profit
FROM Products p 
JOIN OrderDetails od ON od.ProductID = p.ProductID 
JOIN Orders o ON o.OrderID = od.OrderID 
JOIN Categories c ON c.CategoryID = p.CategoryID 
GROUP BY c.CategoryID 


---------------------------------------------

/*
Задание: Определите количество заказов, размещенных клиентами из различных стран, за
каждый месяц.
*/

SELECT 
c.Country 
, strftime('%Y-%m', o.OrderDate) AS month_
, SUM(o.OrderID) AS countOfOrders
FROM Customers c 
JOIN Orders o ON c.CustomerID = o.CustomerID 
GROUP BY month_, c.Country 


---------------------------------------------

/*
Задание: Рассчитайте среднюю продолжительность кредитного срока для
клиентов по категориям образования.
*/

SELECT 
education 
, AVG(c.credit_term) AS avrCreditTerm
FROM Clusters c 
GROUP BY education 



























