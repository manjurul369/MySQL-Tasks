-- Assign Database

USE task_04;



-- Display the names of athletes who won a gold medal in the 2008 Olympics and whose height is greater than the average height of all athletes in the 2008 Olympics.

SELECT `Name` FROM athlete_events
WHERE `Year` = 2008 AND Medal = 'Gold'
AND Height > (SELECT AVG(Height) FROM athlete_events WHERE `Year` = 2008);


-- Display the names of athletes who won a medal in the sport of basketball in the 2016 Olympics and whose weight is less than the average weight of all athletes who won a medal in the 2016 Olympics.

SELECT `Name` FROM athlete_events
WHERE Sport = 'Basketball' AND Medal != 'NA'
AND `Year` = 2016
AND Weight < (SELECT AVG(Weight) FROM athlete_events
WHERE Medal != 'NA' AND `Year` = 2016);



-- Display the names of all athletes who have won a medal in the sport of swimming in both the 2008 and 2016 Olympics.

SELECT `Name` FROM
(SELECT * FROM athlete_events
WHERE `Year` IN ('2008', '2016')) t
WHERE t.Medal != 'NA' AND Sport = 'Swimming'
GROUP BY `Name`
HAVING COUNT(DISTINCT `Year`) = 2;


-- Display the names of all countries that have won more than 50 medals in a single year.

SELECT NOC FROM (SELECT * FROM athlete_events
WHERE Medal != 'NA') t
GROUP BY `Year`, NOC
HAVING COUNT(*) > 50;


-- Display the names of all athletes who have won medals in more than one sport in the same year.

WITH AthletesMultipleSports AS (
    SELECT `Year`, `Name`
    FROM athlete_events
    WHERE Medal != 'NA'
    GROUP BY `Year`, `Name`
    HAVING COUNT(DISTINCT Sport) > 1
)

SELECT ae.`Year`, ae.`Name`, ae.Sport, ae.Medal
FROM athlete_events ae
JOIN AthletesMultipleSports ams
ON ae.`Year` = ams.`Year` AND ae.`Name` = ams.`Name`
WHERE ae.Medal != 'NA'
ORDER BY ae.`Year`;



-- What is the average weight difference between male and female athletes in the Olympics who have won a medal in the same event?

SELECT AVG(t.avg_male_weight - t.avg_female_weight) FROM (SELECT `Year`, `Event`,
AVG(
	CASE
		WHEN Sex = 'M' THEN Weight
	END
) AS avg_male_weight,
AVG(
	CASE
		WHEN Sex = 'F' THEN Weight
	END
) AS avg_female_weight
FROM athlete_events
WHERE Medal != 'NA' AND Sex IN ('F','M')
AND Weight IS NOT NULL
GROUP BY `Year`,`Event`
HAVING COUNT(DISTINCT Sex) = 2) t
WHERE avg_male_weight != 0 AND avg_female_weight != 0;




-- insurance_data Dataset

-- How many patients have claimed more than the average claim amount for patients who are smokers and have at least one child, and belong to the southeast region?

SELECT COUNT(*) FROM insurance_data
WHERE claim > (SELECT AVG(claim) FROM insurance_data
WHERE smoker = 'Yes' AND children >= 1 AND region = 'southeast');



-- How many patients have claimed more than the average claim amount for patients who are not smokers and have a BMI greater than the average BMI for patients who have at least one child?

SELECT COUNT(*) FROM insurance_data
WHERE claim > (SELECT AVG(claim) FROM insurance_data
WHERE smoker = 'No' AND bmi > (SELECT AVG(bmi) FROM insurance_data
WHERE children >= 1));


-- How many patients have claimed more than the average claim amount for patients who have a BMI greater than the average BMI for patients who are diabetic, have at least one child, and are from the southwest region?

SELECT COUNT(*) FROM insurance_data
WHERE claim > (SELECT AVG(claim) FROM insurance_data
WHERE bmi > (SELECT AVG(bmi) FROM insurance_data
WHERE children >= 1 AND diabetic = 'Yes' AND region = 'southwest'));


-- What is the difference in the average claim amount between patients who are smokers and patients who are non-smokers, and have the same BMI and number of children?

SELECT AVG(t.avg_claim_smoker - t.avg_claim_non_smoker) FROM
(SELECT bmi, children,
AVG(
	CASE
		WHEN smoker = 'Yes' THEN claim
	END
) AS 'avg_claim_smoker',
AVG(
	CASE
		WHEN smoker = 'No' THEN claim
	END
) AS 'avg_claim_non_smoker'
FROM insurance_data
GROUP BY children, bmi
HAVING COUNT(DISTINCT smoker) = 2) t


