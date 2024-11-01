/*
		Задание №1
	Рассчитайте среднее количество товаров,
заказанных каждым покупателем (используя
оконную функцию).
*/

SELECT 
c.CustomerID 
, c.CustomerName 
, AVG(od.Quantity) OVER (PARTITION BY c.CustomerID)
FROM Customers c 
JOIN Orders o ON o.CustomerID = c.CustomerID 
JOIN OrderDetails od ON od.OrderID = o.OrderID 

------------------------------------------------------

/*
		Задание №2
	Определите первую и последнюю даты
заказа для каждого клиента
*/

SELECT 
c.CustomerID 
, c.CustomerName 
, first_value(o.OrderDate) OVER (PARTITION BY c.CustomerID ORDER BY o.OrderDate) AS firstPurchase
, first_value(o.OrderDate) OVER (PARTITION BY c.CustomerID ORDER BY o.OrderDate DESC) AS lastPurchase
FROM Customers c 
JOIN Orders o ON o.CustomerID = c.CustomerID 


SELECT
CustomerID,
OrderDate,
MIN(OrderDate) OVER (PARTITION BY CustomerID) AS MinOrderDate,
MAX(OrderDate) OVER (PARTITION BY CustomerID) AS MaxOrderDate
FROM Orders;

------------------------------------------------------

/*
		Задание №3
	Получите общее количество заказов для
каждого клиента, а также имя и город клиента.
*/

SELECT DISTINCT 
c.CustomerID 
, c.CustomerName 
, c.City 
, COUNT(o.OrderID) OVER (PARTITION BY c.CustomerID) AS totalOrders
FROM Customers c 
JOIN Orders o ON o.CustomerID = c.CustomerID 

------------------------------------------------------

/*
		Задание №4
	Ранжируйте сотрудников на основе общего
количества обработанных ими заказов.
*/

WITH cntOrders AS (
SELECT 
e.EmployeeID 
, e.FirstName || ' ' || e.LastName AS fullName
, COUNT(o.OrderID) OVER (PARTITION BY e.EmployeeID) AS countOrders
FROM Employees e 
JOIN Orders o ON o.EmployeeID = e.EmployeeID 
)
SELECT DISTINCT 
EmployeeID 
, fullName
, countOrders
, DENSE_RANK() OVER (ORDER BY countOrders DESC) AS rank
FROM cntOrders

SELECT
e.EmployeeID
, e.FirstName || ' ' || e.LastName AS fullName
, RANK() OVER (ORDER BY COUNT(OrderID) DESC) AS rank
FROM Employees e 
JOIN Orders o ON o.EmployeeID = e.EmployeeID 
GROUP BY e.EmployeeID

------------------------------------------------------

/*
		Задание №5
	Определите среднюю цену товаров внутри
каждой категории, рассматривая только
категории, в которых более трех товаров.
*/

WITH cntProd AS 
(
	SELECT
	p.CategoryID 
	, p.Price 
	, COUNT(p.ProductID) OVER (PARTITION BY p.CategoryID) AS cntP
	FROM Products p 
)
SELECT
	c.CategoryID 
	, c.CategoryName 
	, AVG(cntProd.Price) AS avrPrice
FROM cntProd
JOIN Categories c ON cntProd.CategoryID = c.CategoryID 
WHERE cntProd.cntP > 3
GROUP BY c.CategoryID 


with avg_prices as 
(
	SELECT DISTINCT 
	CategoryID,
	AVG(Price) OVER (PARTITION BY CategoryID) AS AvgPrice,
	COUNT(ProductID) OVER (PARTITION BY CategoryID) as cnt
	FROM Products
)
SELECT * from avg_prices
where cnt > 3

------------------------------------------------------

/*
		Задание №6
	Рассчитайте процент от общего объема (выручки)
продаж каждого продукта в своей категории.
*/


SELECT 
	p.CategoryID 
	, p.ProductName 
	, 100 * SUM(p.Price * od.Quantity) / SUM(SUM(p.Price * od.Quantity)) OVER (PARTITION BY p.CategoryID) AS percent
FROM Products p 
JOIN OrderDetails od ON od.ProductID = p.ProductID 
GROUP BY p.CategoryID , p.ProductName 
ORDER BY p.CategoryID, percent DESC

------------------------------------------------------

/*
		Задание №7
	Для каждого заказа сделайте новую колонку
в которой определите общий объем продаж
за каждый месяц, учитывая все годы.
*/

SELECT
STRFTIME('%Y-%m', o.OrderDate) AS Month
, SUM(od.Quantity * p.Price) OVER (PARTITION BY STRFTIME('%Y-%m', o.OrderDate)) AS TotalSales
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
ORDER BY Month

------------------------------------------------------

/*
		Задание №8
	Вам поручено анализировать совокупные продажи в
двух европейских городах (Лондоне и Мадриде) к
концу каждой недели с начала апреля 2023 года.
Используйте оконные функции SQL для расчета и
отслеживания совокупных продаж с течением
времени в этих двух городах.
*/

SELECT DISTINCT 
	c.City 
	, date(O.OrderDate , 'weekday 0') AS endOfWeek
	, SUM(p.Price * od.Quantity) OVER (PARTITION BY c.City 
										ORDER BY date(O.OrderDate , 'weekday 0')) AS CumSale
FROM Customers c 
JOIN Orders o ON o.CustomerID = c.CustomerID 
JOIN OrderDetails od  ON od.OrderID = o.OrderID 
JOIN Products p ON p.ProductID  = od.ProductID 
WHERE c.City IN ('London', 'Madrid') AND o.OrderDate >= '2023-04-01'
ORDER BY c.City, endOfWeek

------------------------------------------------------

/*
		Задание №9
	Рассчитайте промежуточную сумму заказанных
количеств для каждого продукта.
*/

SELECT 
	od.OrderID 
	, od.ProductID 
	, od.Quantity 
	, SUM(od.Quantity) OVER (PARTITION BY od.ProductID ORDER BY od.OrderID) AS totalQuantity
FROM OrderDetails od 


------------------------------------------------------

/*
		Задание №10
	Рассчитайте разницу в общем объеме продаж за
каждый день по сравнению с предыдущим днем.
*/

SELECT 
	o.OrderDate 
	, SUM(p.Price * od.Quantity) AS totalSales
	, SUM(p.Price * od.Quantity) - 
			lag(SUM(p.Price * od.Quantity)) OVER (ORDER BY o.OrderDate)
	AS diff
FROM OrderDetails od 
JOIN Orders o ON o.OrderID = od.OrderID 
JOIN Products p ON p.ProductID = od.ProductID 
GROUP BY o.OrderDate 


------------------------------------------------------

/*
		Задание №11
	Рассчитайте среднюю стоимость заказа для
каждого сотрудника, учитывая только заказы
после 01-01-2023.
*/

SELECT DISTINCT 
	e.EmployeeID 
	, e.FirstName || ' ' || e.LastName AS fullName
	, AVG(SUM(od.Quantity * p.Price)) OVER (PARTITION BY e.EmployeeID) AS avrOrder 
FROM Employees e 
JOIN Orders o ON o.EmployeeID = e.EmployeeID 
JOIN OrderDetails od ON od.OrderID  = o.OrderID 
JOIN Products p ON p.ProductID  = od.ProductID 
WHERE o.OrderDate >= '2023-01-01'
GROUP BY o.OrderID 














