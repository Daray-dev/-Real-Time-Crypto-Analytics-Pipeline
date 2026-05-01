SELECT *
FROM sales.Customers

SELECT 
CustomerID,
CONCAT(FirstName,' ', LastName) FullName,
Country, 
ISNULL(Score, 0) + 10 AS NewScore
FROM sales.Customers