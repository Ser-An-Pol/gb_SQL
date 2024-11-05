/*
1.Ранжируйте продукты (по ProductRank) в каждой
категории на основе их общего объема продаж
(TotalSales).
*/

WITH tSale AS
(
	SELECT 
		p.CategoryID 
		, c.CategoryName 
		, p.ProductName 
		, SUM(p.Price * od.Quantity) AS TotalSales
	FROM Products p 
	JOIN OrderDetails od ON od.ProductID = p.ProductID 
	JOIN Categories c ON c.CategoryID = p.CategoryID 
	GROUP BY p.ProductID 
)
SELECT 
	CategoryID
	, CategoryName
	, ProductName
	, TotalSales
	, RANK() OVER (PARTITION BY CategoryID ORDER BY TotalSales DESC) AS ProductRank
FROM tSale


SELECT 
	p.CategoryID 
	, c.CategoryName 
	, p.ProductName 
	, SUM(p.Price * od.Quantity) AS TotalSales
	, RANK() OVER (PARTITION BY p.CategoryID ORDER BY SUM(p.Price * od.Quantity) DESC) AS ProductRank
FROM Products p 
JOIN OrderDetails od ON od.ProductID = p.ProductID 
JOIN Categories c ON c.CategoryID = p.CategoryID 
GROUP BY p.ProductID 

------------------------------------------------------------------------------------------------------

/*
2. Обратимся к таблице Clusters
Рассчитайте среднюю сумму кредита (AvgCreditAmount) для
каждого кластера и месяца, учитывая общую среднюю сумму
кредита за соответствующий месяц (OverallAvgCreditAmount).
Определите OverallAvgCreditAmount в первой строке
результатов запроса.
*/

SELECT 
	c.cluster 
	, c."month" 
	, AVG(c.credit_amount) AS AvgCreditAmount
	, SUM(AVG(c.credit_amount)) OVER (PARTITION BY c."month") AS OverallAvgCreditAmount
FROM Clusters c 
GROUP BY  c.cluster , c."month" 

------------------------------------------------------------------------------------------------------

/*
3.Сопоставьте совокупную сумму сумм кредита
(CumulativeSum) для каждого кластера, упорядоченную по
месяцам, и сумму кредита в порядке возрастания.
Определите CumulativeSum в первой строке результатов
запроса
*/


SELECT 
	c.cluster 
	, c."month" 
	, SUM(SUM (c.credit_amount)) OVER (PARTITION BY c.cluster ORDER BY c."month") AS CumulativeSum
FROM Clusters c 
GROUP BY c.cluster , c."month" 


--CumulativeSum сделал. С чем ее нужно сопоставить - непонятно
























