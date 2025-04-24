-- Assign Database

USE task_03;


-- country_ab, country_cd, country_cl, country_efg Datasets

-- Find out top 10 countries' which have maximum A and D values.

SELECT t1.Country, SUM(A), SUM(D)
FROM country_ab t1
JOIN country_cd t2
ON t1.Country = t2.Country
GROUP BY t1.Country
ORDER BY SUM(A) DESC, SUM(D) DESC
LIMIT 10;


-- Find out highest CL value for 2020 for every region. Also sort the result in descending order. Also display the CL values in descending order.

SELECT t2.Region,
MAX(CL) FROM country_cl t1
JOIN country_ab t2
ON t1.Country = t2.Country
WHERE t1.Edition = 2020
GROUP BY t2.Region
ORDER BY MAX(CL) DESC;



-- customers, employees, products, sales1 Datasets

-- Find top-5 most sold products.

SELECT `Name`, COUNT(*) FROM sales1 t1
JOIN products t2
ON t1.ProductID = t2.ProductID
GROUP BY t2.`Name`
ORDER BY COUNT(*) DESC LIMIT 5;


-- Find sales man who sold most no of products.

SELECT
CONCAT(t2.FirstName, ' ', MiddleInitial, ' ', LastName) AS 'Full Name',
COUNT(*) AS 'Number_of_sales'
FROM sales1 t1
JOIN employees t2
ON t1.SalesPersonID = t2.EmployeeID
GROUP BY t1.SalesPersonID
ORDER BY Number_of_sales DESC LIMIT 1;


-- Sales man name who has most no of unique customer.

SELECT
CONCAT(t2.FirstName, ' ', MiddleInitial, ' ', LastName) AS 'Full Name',
COUNT(DISTINCT CustomerID) AS 'Unique_Customer'
FROM sales1 t1
JOIN employees t2
ON t1.SalesPersonID = t2.EmployeeID
GROUP BY t1.SalesPersonID
ORDER BY Unique_Customer DESC LIMIT 1;



-- Sales man who has generated most revenue. Show top 5.

SELECT
CONCAT(t2.FirstName, ' ', MiddleInitial, ' ', LastName) AS 'Full Name',
SUM(Quantity * t3.Price) AS 'Total_Sales_Amount'
FROM sales1 t1
JOIN employees t2
ON t1.SalesPersonID = t2.EmployeeID
JOIN products t3
ON t3.ProductID = t1.ProductID
GROUP BY t1.SalesPersonID
ORDER BY Total_Sales_Amount DESC LIMIT 5;


-- List all customers who have made more than 10 purchases.

SELECT
CONCAT(t2.FirstName, ' ', MiddleInitial, ' ', LastName) AS 'Customers Full Name',
COUNT(*) AS 'Number_of_Purchase'
FROM sales1 t1
JOIN customers t2
ON t1.CustomerID = t2.CustomerID
GROUP BY t1.CustomerID
HAVING COUNT(*) > 10;


-- List all salespeople who have made sales to more than 5 customers.

SELECT * FROM 
(SELECT
CONCAT(t2.FirstName, ' ', MiddleInitial, ' ', LastName) AS 'Full Name',
COUNT(DISTINCT CustomerID) AS 'Unique_Customer'
FROM sales1 t1
JOIN employees t2
ON t1.SalesPersonID = t2.EmployeeID
GROUP BY t1.SalesPersonID
ORDER BY Unique_Customer DESC) t
WHERE Unique_Customer > 5;


-- List all pairs of customers who have made purchases with the same salesperson.

SELECT `Customers Full Name`,
`Employees Full Name`
FROM sales1 t1
JOIN (SELECT *, 
CONCAT(FirstName, ' ', MiddleInitial, ' ', LastName) AS 'Customers Full Name'
FROM customers) t2
ON t1.CustomerID = t2.CustomerID
JOIN (SELECT *,
CONCAT(FirstName, ' ', MiddleInitial, ' ', LastName) AS 'Employees Full Name'
FROM employees) t3
ON t1.SalesPersonID = t3.EmployeeID
GROUP BY t1.CustomerID, SalesPersonID;






