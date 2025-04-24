-- Assign Database

USE task_06;


-- nw_employees, nw_order_details, nw_orders, nw_products, nw_suppliers Dataset

-- Rank Employee in terms of revenue generation. Show employee id, first name, revenue, and rank

WITH employee_total AS (
	SELECT t1.EmployeeID, FirstName, 
    SUM(t2.UnitPrice*t2.Quantity) AS 'revenue'
    FROM nw_orders t1
    JOIN nw_order_details t2
    ON t1.OrderID = t2.OrderID
    JOIN nw_employees t3
    ON t1.EmployeeID = t3.EmployeeID
    GROUP BY EmployeeID, FirstName
)

SELECT *, RANK() OVER(ORDER BY revenue DESC) FROM employee_total;


-- Show All products cumulative sum of units sold each month.

WITH product_month AS(
SELECT t2.ProductID,t2.ProductName,
MONTH(OrderDate) AS 'OrderMonth',
SUM(t1.Quantity) AS 'MonthlyUnitSold'
FROM nw_order_details t1
JOIN nw_products t2
ON t1.ProductID = t2.ProductID
JOIN nw_orders t3
ON t1.OrderID = t3.OrderID
GROUP BY OrderMonth, t1.ProductID)

SELECT *,
SUM(MonthlyUnitSold) OVER(PARTITION BY ProductID ORDER BY OrderMonth
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS 'CumulativeSum'
FROM product_month;


-- Show Percentage of total revenue by each suppliers

WITH Company_wise_revenue AS (SELECT t2.SupplierID, t3.CompanyName,
SUM(t1.UnitPrice*t1.Quantity) AS 'revenue'
FROM nw_order_details t1
JOIN nw_products t2
ON t1.ProductID = t2.ProductID
JOIN nw_suppliers t3
ON t2.SupplierID = t3.SupplierID
GROUP BY t2.SupplierID, t3.CompanyName)

SELECT *, revenue/(SUM(revenue) OVER())*100 AS 'Percentage'
FROM Company_wise_revenue
ORDER BY SupplierID;


-- Show Percentage of total orders by each suppliers

WITH Company_wise_order_no AS (SELECT t2.SupplierID, t3.CompanyName, COUNT(*) AS 'Number_of_order'
FROM nw_order_details t1
JOIN nw_products t2
ON t1.ProductID = t2.ProductID
JOIN nw_suppliers t3
ON t2.SupplierID = t3.SupplierID
GROUP BY t2.SupplierID, t3.CompanyName)

SELECT *, Number_of_order/(SUM(Number_of_order) OVER())*100 AS 'Percentage'
FROM Company_wise_order_no
ORDER BY SupplierID;


-- Show All Products Year Wise report of totalQuantity sold, percentage change from last year.

WITH year_wise_sold AS (SELECT
t1.ProductID, t3.ProductName, YEAR(t2.OrderDate) AS `year_sold`,
SUM(t1.Quantity) AS 'unit_sold'
FROM nw_order_details t1
JOIN nw_orders t2
ON t1.OrderID = t2.OrderID
JOIN nw_products t3
ON t1.ProductID = t3.ProductID
GROUP BY t1.ProductID, t3.ProductName, YEAR(t2.OrderDate))

SELECT *, ((unit_sold - LAG(unit_sold) OVER(PARTITION BY ProductName ORDER BY year_sold))
/LAG(unit_sold) OVER(PARTITION BY ProductName ORDER BY year_sold))*100 AS 'percentage growth'
FROM year_wise_sold;






