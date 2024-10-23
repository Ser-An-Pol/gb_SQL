/*
1. Вам необходимо проверить влияние семейного
положения (family_status) на средний	доход
клиентов (income) и запрашиваемый кредит
(credit_amount) .
*/

SELECT family_status 
, AVG(income) AS avrIncome
, AVG(credit_amount) AS avrCredit
FROM Clusters
GROUP BY family_status 
ORDER BY avrIncome

---------------------------------------------------

/*
2. Сколько товаров в категории Meat/Poultry.
*/

SELECT COUNT(*)
FROM Products
WHERE CategoryID IN (
	SELECT CategoryID 
	FROM Categories
	WHERE CategoryName = 'Meat/Poultry'
)

-- В этой категории 6 товаров

---------------------------------------------------

/*
3. Какой товар (название) заказывали в сумме в
самом большом количестве (sum(Quantity) в
таблице OrderDetails)
*/

SELECT ProductName 
FROM Products
WHERE ProductID IN (
	SELECT ProductID
	FROM OrderDetails
	GROUP BY ProductID 
	ORDER BY SUM(Quantity) DESC 
	LIMIT 1
)

-- В наибольшем количестве заказывали: Gorgonzola Telino

---------------------------------------------------





