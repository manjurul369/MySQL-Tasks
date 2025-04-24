-- Assign Database

USE task_05;


-- What are the top 5 patients who claimed the highest insurance amounts?

SELECT *, RANK() OVER(ORDER BY claim DESC) AS 'rank'
FROM insurance_data
ORDER BY `rank` LIMIT 5;


-- What is the average insurance claimed by patients based on the number of children they have?

SELECT *,
AVG(claim) OVER(PARTITION BY children)
FROM insurance_data;


-- What is the highest and lowest claimed amount by patients in each region?

SELECT *,
MAX(claim) OVER(PARTITION BY region),
MIN(claim) OVER(PARTITION BY region)
FROM insurance_data;


-- What is the percentage of smokers in each age group?

SELECT *,
((SUM(CASE WHEN smoker = 'Yes' THEN 1 ELSE 0 END) OVER(PARTITION BY age))/
(COUNT(*) OVER(PARTITION BY age)))*100 AS 'Percentage_of_smoker'
FROM insurance_data;


-- What is the difference between the claimed amount of each patient and the first claimed amount of that patient?

SELECT *,
claim - FIRST_VALUE(claim) OVER(PARTITION BY PatientID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM insurance_data;


-- For each patient, calculate the difference between their claimed amount and the average claimed amount of patients with the same number of children.

SELECT *,
claim - AVG(claim) OVER(PARTITION BY children ORDER BY claim ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM insurance_data;


-- Show the patient with the highest BMI in each region and their respective rank.

SELECT *,
RANK() OVER(PARTITION BY region ORDER BY bmi DESC) AS 'bmi_rank'
FROM insurance_data;


-- Calculate the difference between the claimed amount of each patient and the claimed amount of the patient who has the highest BMI in their region.

SELECT *,
claim - FIRST_VALUE(claim) OVER(PARTITION BY region ORDER BY bmi DESC)
FROM insurance_data;


-- For each patient, calculate the difference in claim amount between the patient and the patient with the highest claim amount among patients with the same bmi and smoker status, within the same region. Return the result in descending order difference.

SELECT t.* FROM (SELECT *,
claim - FIRST_VALUE(claim) OVER(PARTITION BY region, bmi, smoker ORDER BY claim DESC) AS 'difference'
FROM insurance_data) t
ORDER BY t.difference DESC;


-- For each patient, find the maximum BMI value among their next three records (ordered by age)

SELECT *,
MAX(bmi) OVER(PARTITION BY PatientID ORDER BY age ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING)
FROM insurance_data
ORDER BY age;


-- For each patient, find the rolling average of the last 2 claims.

SELECT *,
AVG(claim) OVER(ORDER BY PatientID ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
FROM insurance_data;


-- Find the first claimed insurance value for male and female patients, within each region order the data by patient age in ascending order, and only include patients who are non-diabetic and have a bmi value between 25 and 30.

SELECT t.*,
FIRST_VALUE(claim) OVER(PARTITION BY gender, region ORDER BY age ASC)
FROM(SELECT * FROM insurance_data
WHERE diabetic = 'No' AND bmi BETWEEN 25 AND 30) t;



