/*
1. В каких странах проживают наши клиенты (таблица Customers)?
Сколько уникальных стран вы получили в ответе?
*/

SELECT DISTINCT Country
FROM Customers

SELECT COUNT(DISTINCT Country)
FROM Customers

-- Всего 21 страна

--------------------------------------------------------------------

/*
 2. Сколько клиентов проживает в Argentina?
*/

SELECT COUNT(*)
FROM Customers
WHERE Country = 'Argentina'

-- Всего 3 клиента

--------------------------------------------------------------------

/*
3. Посчитайте среднюю цену и количество товаров в 8 категории (таблица Products ).
Найдите количество товаров в 8 категории
*/

SELECT SUM(Price)/COUNT(Price) AS 'Average Price'
FROM Products
WHERE CategoryID = 8

-- Средняя цена: 20.6825

--------------------------------------------------------------------

/*
4. Посчитайте средний возраст работников (таблица Employees)
*/

SELECT 1.0*SUM(DATE() - DATE(BirthDate))/COUNT(BirthDate) 
FROM Employees

-- Средняя возраст: 66.6

--------------------------------------------------------------------

/*
5. Вам необходимо получить заказы, которые сделаны в течении 35 дней до даты 2023-10-10 (то есть с 5
сентября до 10 октября включительно). Использовать функцию DATEDIFF, определить переменные для
даты и диапазона. 

Определите CustomerID, который оказался в первой строке запроса.
*/

DECLARE
@finish date = '2023-10-10'
, @gap tinyint = 35 

SELECT *
FROM Orders
WHERE DATEDIFF(day, orderdate, @finish) BETWEEN 0 AND @gap

-- Объявление переменных и DATEDIFF нет в SQLite (задание сделал на https://sqliteonline.com)

--Решение в SQLite:

SELECT *
FROM Orders
WHERE JULIANDAY('2023-10-10') - JULIANDAY(OrderDate) BETWEEN 0 AND 35

-- CustomerID, который оказался в первой строке запроса: 37

--------------------------------------------------------------------

/*
 6. Вам необходимо получить количество заказов за сентябрь месяц (тремя способами, через LIKE, с
помощью YEAR и MONTH и сравнение начальной и конечной даты).
 */

SELECT COUNT(*) 
FROM Orders
WHERE OrderDate LIKE '2023-09-__'

SELECT COUNT(*) 
FROM Orders
WHERE OrderDate BETWEEN '2023-09-01' AND '2023-09-30'

--YEAR и MONTH в MSSQL:

SELECT COUNT(*) 
FROM Orders
WHERE YEAR(orderdate) = 2023 AND MONTH(orderdate) = 9

-- Количество заказов за сентябрь месяц: 23

--------------------------------------------------------------------




