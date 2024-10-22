/*
 
 Задание №1: 

Реализуем пример запроса VALUE_COUNTS, который возвращает количество для
каждого элемента. Давайте посмотрим сколько среди наших клиентов мужчин
и женщин. А затем посмотрим как люди разбиты по образованию.
Не забываем, что в таком запросе нам важно получить отсортированный список,
чтобы сверху были самые популярные экземпляры.
*/

SELECT sex
, COUNT(*) AS CountSex
FROM Clusters c 
GROUP BY sex 
ORDER BY CountSex DESC 

SELECT education
, COUNT(*) AS CountEdu
FROM Clusters c 
GROUP BY education 
ORDER BY CountEdu DESC 

----------------------------------------------------------------------------

/*
	Задание №2:

Теперь необходимо сравнить распределение по полу
и образованию (отдельно) для клиентов и не клиентов банка.
Продумать, какая сортировка будет оптимальной.
*/

SELECT is_client, sex
, COUNT(*) AS CountSex
FROM Clusters c 
GROUP BY sex, is_client 
ORDER BY is_client DESC , CountSex DESC 


SELECT is_client, education 
, COUNT(*) AS CountEdu
FROM Clusters c 
GROUP BY education, is_client 
ORDER BY is_client, CountEdu DESC 

----------------------------------------------------------------------------

/*
	Задание №3:

Давайте посмотрим образование клиентов с разбивкой по
полу и определим, какое образование самое непопулярное
у них (меньше всего ).
То есть отфильтруем по количеству меньше 40
*/

SELECT sex, education, COUNT(*) AS CountEdu 
FROM Clusters
GROUP BY sex,education 
HAVING CountEdu < 40
ORDER BY sex, CountEdu

----------------------------------------------------------------------------

/*
	Задание №4:

Давайте посмотрим тоже самое, но только среди
клиентов банка.
*/

SELECT sex, education, COUNT(*) AS CountEdu 
FROM Clusters
WHERE is_client = 1
GROUP BY sex,education 
HAVING CountEdu < 40
ORDER BY sex, CountEdu

----------------------------------------------------------------------------

/*
	Задание №5:

Получить среднюю величину запрашиваемого кредита
и дохода клиентов для клиентов банка в разрезе
образования и пола клиентов
*/

SELECT sex , education , 1.0*SUM(credit_amount)/COUNT(*) AS avrCredit,  1.0*SUM(income)/COUNT(*) AS AvrIncome
FROM Clusters
WHERE is_client = 1
GROUP BY education , sex 
ORDER BY sex , education 

SELECT sex , education , AVG(credit_amount) AS avrCredit,  AVG(income) AS AvrIncome
FROM Clusters
WHERE is_client = 1
GROUP BY education , sex 
ORDER BY sex , education 

----------------------------------------------------------------------------

/*
	Задание №6:

Получить максимальную и минимальную сумму
кредита в разрезе пола и Хороших клиентов для
клиентов с высшим/неполным высшим образованием.
В чем особенность плохих и хороших клиентов?
*/

SELECT sex , bad_client_target , MAX(credit_amount) AS maxCredit, MIN(credit_amount) AS minCredit 
FROM Clusters
WHERE education LIKE "%high%"
GROUP BY sex , bad_client_target 
ORDER BY sex ,bad_client_target 

----------------------------------------------------------------------------

/*
	Задание №7:

Получить распределение (min, max, avg) возрастов
клиентов в зависимости от пола и оператора связи.
Есть ли какие-нибудь здесь инсайды.
*/

SELECT sex , phone_operator , MIN(age) AS minAge, MAX(age) as maxAge, AVG(age) AS avrAge 
FROM Clusters 
GROUP BY sex , phone_operator 
ORDER BY phone_operator , sex

----------------------------------------------------------------------------

/*
	Задание №8:

Давайте поработаем с колонкой cluster. Для начала
посмотрим сколько кластеров у нас есть и сколько
людей попало в каждый кластер
*/

SELECT cluster , COUNT(*) as countClient
FROM Clusters
GROUP BY cluster 
ORDER BY countClient DESC


----------------------------------------------------------------------------

/*
	Задание №9:

Видим, что есть большие кластеры 0, 4, 3. Остальные маленькие.
Давайте маленькие кластеры объединим в большой и посмотрим
средний возраст, доход, кредит и пол в больших кластерах
(с помощью функции CASE). 
*/

SELECT CASE WHEN cluster IN (1,5,6,2) THEN 10 else cluster END AS Clst
, COUNT(*) as countClient
, AVG(age) AS avrAge
, AVG(income) AS avrIncome 
, AVG(credit_amount) AS avrCredit 
, sex 
FROM Clusters
GROUP BY Clst , sex 
ORDER BY Clst , sex 

----------------------------------------------------------------------------

/*
	Задание №10:

Давайте сейчас проверим гипотезу, что доход
клиентов связан с регионом проживания.
*/

SELECT region 
, AVG(income) AS avrIncome
, MIN(income) AS minIncome
, MAX(income) AS maxIncome
FROM Clusters
GROUP BY region 
ORDER BY avrIncome

----------------------------------------------------------------------------

/*
	Задание №11:

С помощью подзапроса получите заказы товаров
из 4 и 6 категории (подзапрос в подзапросе).
Таблицы OrderDetails, Products
*/

SELECT * 
FROM Orders 
WHERE OrderID in (
	SELECT OrderID 
	FROM OrderDetails 
	WHERE ProductID in (
		SELECT ProductID 
		FROM Products
		WHERE CategoryID in (4, 6)
	)
)

----------------------------------------------------------------------------

/*
	Задание №12:

В какие страны доставляет товары
компания Speedy_Express
*/

SELECT DISTINCT Country 
FROM Customers
WHERE CustomerID in (
	SELECT CustomerID 
	FROM Orders
	WHERE ShipperID in (
		SELECT ShipperID
		FROM Shippers
		WHERE ShipperName = 'Speedy_Express'
	)
)


----------------------------------------------------------------------------

/*
	Задание №13:

Получите 3 страны, где больше всего
клиентов (таблица Customers).
*/

SELECT Country 
, COUNT(*) AS CountClient
FROM Customers
GROUP BY Country 
ORDER BY CountClient DESC 
LIMIT 3

----------------------------------------------------------------------------

/*
	Задание №14:

Назовите три самых популярных города и название
страны среди трех популярных стран (где больше
всего клиентов)
*/

SELECT Country 
, City 
, COUNT(*) AS CountClientC
FROM Customers
WHERE Country IN (
	SELECT Country 
	FROM Customers
	GROUP BY Country 
	ORDER BY COUNT(*) DESC 
	LIMIT 3
)
GROUP BY City
ORDER BY CountClientC DESC 
LIMIT 3





