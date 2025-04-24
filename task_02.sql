-- Assign Database
USE task_02;


-- sleep_efficiency dataset

-- Find out the average sleep duration of top 15 male candidates who's sleep duration are equal to 7.5 or greater than 7.5.
SELECT AVG(`Sleep duration`) FROM sleep_efficiency
WHERE `Sleep duration` >= 7.5 AND Gender = 'Male'
ORDER BY `Sleep duration` DESC LIMIT 15;


-- Show avg deep sleep time for both gender. Round result at 2 decimal places.

SELECT t.Gender,
ROUND(AVG(t.`Deep sleep time`),2) AS 'Average Deep Sleep Time'
FROM (SELECT Gender,
((`Sleep duration`*`Deep sleep percentage`)/100) AS 'Deep sleep time'
FROM sleep_efficiency) t
GROUP BY Gender;


-- Find out the lowest 10th to 30th light sleep percentage records where deep sleep percentage values are between 25 to 45.
-- Display age, light sleep percentage and deep sleep percentage columns only.

SELECT Age, `Light sleep percentage`, `Deep sleep percentage`
FROM sleep_efficiency
WHERE `Deep sleep percentage` BETWEEN 25 AND 45
ORDER BY `Light sleep percentage` LIMIT 9,21;


-- Group by on exercise frequency and smoking status and show average deep sleep time, average light sleep time and avg rem sleep time.
-- Note the differences in deep sleep time for smoking and non smoking status

SELECT t.`Smoking status`, t.`Exercise frequency`,
AVG(t.`Deep sleep time`) AS AvgDeepSleepTime,
AVG(t.`Light sleep time`) AS AvgLightSleepTime,
AVG(t.`REM sleep time`) AS AvgREMSleepTime
FROM (SELECT `Smoking status`, `Exercise frequency`,
((`Sleep duration`*`Deep sleep percentage`)/100) AS 'Deep sleep time',
((`Sleep duration`*`Light sleep percentage`)/100) AS 'Light sleep time',
((`Sleep duration`*`REM sleep percentage`)/100) AS 'REM sleep time'
FROM sleep_efficiency) t
GROUP BY t.`Smoking status`, t.`Exercise frequency`
ORDER BY
t.`Smoking status` DESC,
t.`Exercise frequency`;


-- Group By on Awekning and show AVG Caffeine consumption, AVG Deep sleep time and AVG Alcohol consumption only for people who do exercise atleast 3 days a week. Show result in descending order awekenings

SELECT t.Awakenings,
AVG(t.`Caffeine consumption`),
AVG(t.`Deep sleep time`),
AVG(t.`Alcohol consumption`)
FROM (SELECT *,
((`Sleep duration`*`Deep sleep percentage`)/100) AS 'Deep sleep time'
FROM sleep_efficiency) t
WHERE t.`Exercise frequency` >= 3
GROUP BY t.Awakenings
ORDER BY t.Awakenings DESC;





-- powergeneration dataset

-- Display those power stations which have average 'Monitored Cap.(MW)' (display the values) between 1000 and 2000 and the number of occurance of the power stations (also display these values) are greater than 200. Also sort the result in ascending order.

SELECT * FROM
(SELECT `Power Station`, AVG(`Monitored Cap.(MW)`) AS 'avg_mw',
COUNT(*) AS 'noo_ps' FROM powergeneration
GROUP BY `Power Station`) t
WHERE t.avg_mw BETWEEN 1000 AND 2000 AND noo_ps > 200
ORDER BY t.`Power Station`;




-- nces dataset

-- Display top 10 lowest "value" State names of which the Year either belong to 2013 or 2017 or 2021 and type is 'Public In-State'. Also the number of occurance should be between 6 to 10. Display the average value upto 2 decimal places, state names and the occurance of the states.

SELECT `State`,                                
ROUND(AVG(`Value`), 2) AS AverageValue, 
COUNT(*) AS OccurrenceCount         
FROM nces
WHERE `Year` IN ('2013', '2017', '2021')      
AND `Type` = 'Public In-State'          
GROUP BY `State`                                 
HAVING COUNT(*) BETWEEN 6 AND 10               
ORDER BY AverageValue ASC LIMIT 10;


-- Best state in terms of low education cost (Tution Fees) in 'Public' type university.

SELECT State, AVG(`Value`) FROM nces
WHERE Expense = 'Fees/Tuition' AND
Type IN ('Public In-State', 'Public Out-of-State')
GROUP BY State
ORDER BY AVG(`Value`) ASC;


-- 2nd Costliest state for Private education in year 2021. Consider, Tution and Room fee both.

SELECT State, SUM(`Value`) AS 'Total_Cost' FROM nces
WHERE `Year` = 2021 AND `Type` = 'Private'
GROUP BY State
ORDER BY Total_Cost DESC
LIMIT 1,1;




-- shipping_ecommerce dataset

-- Display total and average values of Discount_offered for all the combinations of 'Mode_of_Shipment' (display this feature) and 'Warehouse_block' (display this feature also) for all male ('M') and 'High' Product_importance. Also sort the values in descending order of Mode_of_Shipment and ascending order of Warehouse_block.

SELECT Mode_of_Shipment, Warehouse_block,
SUM(Discount_offered) AS 'Total_Discount',
AVG(Discount_offered) AS 'Average_Discount'
FROM shipping_ecommerce
WHERE Gender = 'M' AND Product_importance = 'high'
GROUP BY Mode_of_Shipment, Warehouse_block
ORDER BY Mode_of_Shipment DESC,
Warehouse_block ASC



