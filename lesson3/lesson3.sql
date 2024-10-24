/*
		Задание №1
	
	Приджойним к данным о заказах данные о
покупателях. Данные, которые нас интересуют —
имя заказчика и страна, из которой совершается
покупка.
*/

SELECT *
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID 

----------------------------------------------------

/*
		Задание №2
	
	Давайте проверим, Customer пришедшие из какой
страны совершили наибольшее число Orders.
Используем сортировку по убыванию по полю
числа заказов.
И выведем сверху в результирующей таблице
название лидирующей страны.
*/

SELECT c.Country 
, COUNT(o.OrderID) AS countCust
FROM Customers c 
JOIN Orders o ON c.CustomerID = o.CustomerID 
GROUP BY c.Country 
ORDER BY countCust DESC 

----------------------------------------------------

/*
		Задание №3
	
	А теперь напишем запрос, который обеспечит
целостное представление деталей заказа,
включая информацию как о клиентах,
так и о сотрудниках.
Будем использовать JOIN для соединения
информации из таблиц Orders, Customers
и Employees.
*/

SELECT *
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID 
JOIN Employees e ON o.EmployeeID = e.EmployeeID 

----------------------------------------------------

/*
		Задание №4
	
	Наша следующая задача — проанализировать
данные заказа, рассчитать ключевые показатели,
связанные с выручкой, и соотнести результаты
с ценовой информацией из таблицы Products.
Давайте посмотрим на общую выручку, а также
минимальный, максимальный чек в разбивке
по странам
*/



SELECT 
 Country
 , SUM(p.Price * od.Quantity) AS generalRevenue
 , MAX(p.Price * od.Quantity) AS maxCheck
 , MIN(p.Price * od.Quantity) AS minCheck
FROM Orders o 
JOIN OrderDetails od ON o.OrderID = od.OrderID 
JOIN Customers c ON o.CustomerID = c.CustomerID 
JOIN Products p ON od.ProductID = p.ProductID 
GROUP BY Country
ORDER BY generalRevenue DESC

----------------------------------------------------

/*
		Задание №5
	
	Выведем имена покупателей, которые совершили
как минимум одну покупку 12 декабря
*/

SELECT 
DISTINCT c.CustomerName 
FROM Customers c 
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate LIKE '____-12-12'

----------------------------------------------------

/*
		Задание №6
	
	Напишем SQL-запрос для создания отчета
об исследовании продукта, показывающего
потенциальный интерес к каждому продукту
в разных странах. Используем CROSS JOIN
операцию для создания комбинаций стран и
продуктов.
Это PotentialInterest должно представлять собой
гипотетическую оценку, основанную на общем
количестве клиентов из этой страны, которые могут
быть заинтересованы в конкретном продукте.
CROSS JOIN создаёт все возможные комбинации
стран и названий продуктов.
*/

WITH Client_Count AS
(
	SELECT 
	c.Country
	, COUNT(*) AS Cnt
	FROM Customers c 
	GROUP BY c.Country
)
SELECT 
	Client_Count.Country
	, p.ProductName
	, Client_Count.Cnt
FROM Client_Count CROSS JOIN Products p 
ORDER BY Client_Count.Country
	, p.ProductName

----------------------------------------------------

/*
		Задание №7 
	
	Давайте проанализируем разнообразие
поставщиков в категориях продуктов.
Напишем SQL-запрос для определения
поставщиков, предлагающих широкий
ассортимент продукции в разных категориях.
*/

SELECT 
s.SupplierName
, s.Country 
, COUNT (DISTINCT p.CategoryID) AS countCat
FROM Suppliers s 
JOIN Products p ON s.SupplierID = p.SupplierID 
GROUP BY s.SupplierID 
ORDER BY countCat DESC

----------------------------------------------------

/*
		Задание №8 
	
	Ваша компания заинтересована в том, чтобы
понять, в каких странах появились новые
клиенты, которые еще не разместили заказы.
Напишем SQL-запрос, позволяющий
идентифицировать страны, в которых клиенты
зарегистрировались, но не сделали заказов.
*/

SELECT 
DISTINCT c.Country 
FROM Customers c 
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID 
WHERE o.OrderID IS NULL 
ORDER BY c.Country 


SELECT 
c.Country 
, COUNT (*)
FROM Customers c 
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID 
WHERE o.OrderID IS NULL 
GROUP BY c.Country 
ORDER BY c.Country 

----------------------------------------------------

/*
		Задание №9 
	
	Представим, что Ваша компания хочет выявить
клиентов, которые приобрели товары как
стоимостью менее 30, так и стоимостью более
150 долларов США.
Напишите запрос SQL, INTERSECT чтобы найти
клиентов, которые делали покупки в обоих этих
ценовых диапазонах.
*/

WITH purchPrice AS (
SELECT 
c.CustomerID 
, c.CustomerName 
, p.Price 
FROM Customers c 
JOIN Orders o ON c.CustomerID = o.CustomerID 
JOIN OrderDetails od ON o.OrderID = od.OrderID 
JOIN Products p ON od.ProductID = p.ProductID
)
SELECT 
CustomerID
, CustomerName
FROM purchPrice
WHERE purchPrice.Price < 30
INTERSECT 
SELECT 
CustomerID
, CustomerName
FROM purchPrice
WHERE purchPrice.Price > 150

----------------------------------------------------

/*
		Задание №10
	
	Следующим запросом давайте создадим набор
результатов, который включает уникальные
записи о клиентах как для США, так и для
Канады.
В данном случае оператор UNION объединяет
результаты двух отдельных запросов,
представляя единый список клиентов из обеих
стран, удаляя при этом любые дубликаты.
*/

SELECT 
CustomerID 
, Country 
, CustomerName 
FROM Customers 
WHERE Country ='USA'
UNION
SELECT 
CustomerID 
, Country 
, CustomerName 
FROM Customers 
WHERE Country ='Canada'
ORDER BY Country 


----------------------------------------------------































