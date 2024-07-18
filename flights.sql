-- Flights Case Study 

USE datetimecasestudy;
SELECT * FROM flights;

-- 1. Find the month with most number of flights

SELECT MONTHNAME(Date_of_Journey) as 'Month' , COUNT(*) AS 'Num_of_flights' FROM flights
GROUP BY `Month` ORDER BY Num_of_flights DESC LIMIT 1;

-- 2. Which week day has most costly flights

SELECT  DAYNAME(Date_of_Journey) AS 'DayName', AVG(Price) AS 'Cost' FROM flights 
GROUP BY `DayName` ORDER BY Cost DESC LIMIT 1;

-- 3. Find number of indigo flights every month
SELECT MONTHNAME(Date_of_Journey) as 'Month' , COUNT(*) AS 'Num_of_flights' FROM flights
WHERE Airline = 'IndiGo'
GROUP BY `Month` ORDER BY Num_of_flights;

-- 4. Find list of all flights that depart between 10AM and 2PM from Delhi to Banglore

SELECT * FROM flights
WHERE Source = 'Banglore' AND Destination = ('New Delhi' OR 'Delhi') AND Dep_Time BETWEEN '10:00:00' AND '14:00:00';

-- 5. Find the number of flights departing on weekends from Bangalore

SELECT  COUNT(*) AS 'Flights from Bangalore'  FROM flights
WHERE Source = 'Banglore' AND DAYNAME(Date_of_Journey) IN ('Saturday','Sunday');

-- 6. Calculate the arrival time for all flights by adding the duration to the departure time.

ALTER TABLE flights ADD COLUMN departure DATETIME;

UPDATE flights
SET departure = STR_TO_DATE(CONCAT(date_of_journey, ' ', Dep_Time), '%Y-%m-%d %H:%i') ;

ALTER TABLE flights
ADD COLUMN duration_mins INTEGER,
ADD COLUMN arrival DATETIME;

SELECT Duration, 
REPLACE(SUBSTRING_INDEX(Duration, ' ', 1), 'h', '')* 60,
CASE 
	WHEN SUBSTRING_INDEX(Duration, ' ', -1) = SUBSTRING_INDEX(Duration, ' ', 1) THEN 0
    ELSE REPLACE(SUBSTRING_INDEX(Duration, ' ', -1), 'm', '')
    END AS 'mins'
FROM flights;

UPDATE flights
SET duration_mins = REPLACE(SUBSTRING_INDEX(duration, ' ', 1), 'h', '')* 60 +
CASE
	WHEN SUBSTRING_INDEX(duration, ' ',-1) =SUBSTRING_INDEX(duration, ' ', 1) THEN 0
    ELSE REPLACE(SUBSTRING_INDEX(duration, ' ', -1), 'm', '')
END;

-- 7. Calculate the arrival date for all the flights



-- 8. Find the number of flights which travel on multiple dates.


-- 9. Calculate the average duration of flights between all city pairs. The answer should In xh ym format




-- 10. Find all flights which departed before midnight but arrived at their destination after midnight having only 0 stops.


-- 11. Find quarter wise number of flights for each airline

SELECT Airline,QUARTER(departure),COUNT(*) AS 'no_of_flights'
FROM flights
GROUP BY airline,QUARTER(departure);

-- 12. Find the longest flight distance(between cities in terms of time) in India





-- 13. Average time duration for flights that have 1 stop vs more than 1 stops


-- 14. Find all Air India flights in a given date range originating from Delhi

SELECT * FROM flights
WHERE Airline = 'Air India' AND Source = 'Delhi' AND
DATE(departure) BETWEEN '2019-03-01' AND '2019-03-10';

-- 15. Find the longest flight of each airline


-- 16. Find all the pair of cities having average time duration > 3 hours


-- 17. Make a weekday vs time grid showing frequency of flights from Banglore and Delhi

SELECT DAYNAME(departure) AS 'DAY',
SUM(CASE WHEN HOUR(departure) BETWEEN 0 AND 5 THEN 1 ELSE 0 END) AS '12AM - 6AM',
SUM(CASE WHEN HOUR(departure) BETWEEN 6 AND 11 THEN 1 ELSE 0 END) AS '6AM - 12PM',
SUM(CASE WHEN HOUR(departure) BETWEEN 12 AND 17 THEN 1 ELSE 0 END) AS '12PM - 6PM',
SUM(CASE WHEN HOUR(departure) BETWEEN 18 AND 23 THEN 1 ELSE 0 END) AS '6PM - 12AM'
FROM flights
WHERE Source = 'Banglore' AND Destination = 'Delhi'
GROUP BY `DAY`;

-- 18. Make a weekday vs time grid showing avg flight price from Banglore and Delhi

SELECT DAYNAME(departure) AS 'DAY',
AVG(CASE WHEN HOUR(departure) BETWEEN 0 AND 5 THEN Price ELSE Null END) AS '12AM - 6AM',
AVG(CASE WHEN HOUR(departure) BETWEEN 6 AND 11 THEN Price ELSE NULL END) AS '6AM - 12PM',
AVG(CASE WHEN HOUR(departure) BETWEEN 12 AND 17 THEN Price ELSE NULL END) AS '12PM - 6PM',
AVG(CASE WHEN HOUR(departure) BETWEEN 18 AND 23 THEN Price ELSE NULL END) AS '6PM - 12AM'
FROM flights
WHERE Source = 'Banglore' AND Destination = 'Delhi'
GROUP BY `DAY`;