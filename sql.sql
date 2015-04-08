-- Display PostgreSQL version
SELECT version();

-- Display current date
SELECT current_date;

-- Add 2 and 2
SELECT 2 + 2;

-- Create WEATHER table
CREATE TABLE weather (
  city    varchar(80),
  temp_lo int,          -- low temperature
  temp_hi int,          -- high temperature
  prcp    real,         -- precipitation
  date    date
);

-- Create CITIES table
CREATE TABLE cities (
  name      varchar(80),
  location  point
);

-- List tables (among other things) with \d

-- Remove CITIES table
DROP TABLE cities;

-- List tables again

-- Re-create CITIES table
CREATE TABLE cities (
  name      varchar(80),
  location  point
);

-- Populate WEATHER table
INSERT INTO weather VALUES ('San Francisco', 46, 50, 0.25, '1994-11-27');

-- Populate CITIES table
INSERT INTO cities VALUES ('San Francisco', '(-194.0, 53.0)');

-- Populate WEATHER table with columns list
INSERT INTO weather(city, temp_lo, temp_hi, prcp, date)
VALUES ('San Francisco', 43, 57, 0.0, '1994-11-29');

-- Populate WEATHER table with partial unordered columns list
INSERT INTO weather (date, city, temp_hi, temp_lo)
VALUES ('1994-11-29', 'Hayward', 54, 37);

-- Retrieve all rows from WEATHER table with *
SELECT * FROM weather;

-- Retrieve all rows from WEATHER table without *
SELECT city, temp_lo, temp_hi, prcp, date
FROM weather;

-- Retrieve average temperature from WEATHER table using expressionss
SELECT city, (temp_hi + temp_lo) / 2 AS temp_avg, date
FROM weather;

-- Retrieve rows where it was raining in San Francisco
SELECT *
FROM weather
WHERE city = 'San Francisco' AND prcp > 0.0;

-- Retrieve all rows from WEATHER table ordered by city
SELECT *
FROM weather
ORDER BY city;

-- Retrieve all rows from WEATHER table ordered by city, then lowest temperature
SELECT *
FROM weather
ORDER BY city, temp_lo;

-- Retrieve all cities from WEATHER table, each only once
SELECT DISTINCT city
FROM weather;

-- Retrieve all cities from WEATHER table, each only once, ordered by city
SELECT DISTINCT city
FROM weather
ORDER BY city;

-- List all weather records along with associated city location
SELECT *
FROM weather, cities
WHERE city = name;

-- Display city's name only once
SELECT city, temp_lo, temp_hi, prcp, date, location
FROM weather, cities
WHERE city = name;

-- Question: Attempt to determine the semantics of the query when the WHERE clause is omitted.
INSERT INTO cities VALUES ('Test', '(42, 69)'); -- Add another city to get a better idea of what is happening
SELECT * FROM weather, cities; -- Check the result
-- Answer: We obtain the product of each row from WEATHER table with each rows from CITIES table.

-- Qualify column names
SELECT weather.city, weather.temp_lo, weather.temp_hi, weather.prcp, weather.date, cities.location
FROM weather, cities
WHERE cities.name = weather.city;

-- Make an INNER JOIN
SELECT *
FROM weather INNER JOIN cities ON (weather.city = cities.name);

-- Make a LEFT OUTER JOIN
SELECT *
FROM weather LEFT OUTER JOIN cities ON (weather.city = cities.name);

-- Question: There are also right outer joins and full outer joins. Try to find out what those do.
SELECT * FROM weather RIGHT OUTER JOIN cities ON (weather.city = cities.name);
SELECT * FROM weather FULL OUTER JOIN cities ON (weather.city = cities.name);
-- Answers:
-- Right outer join does the same as left outer join, but with the table mentioned on the right of the join operator.
-- Full outer join does both at the same time, replacing unmatched rows from both tables by blank ones.

-- Self join on WEATHER table
SELECT W1.city, W1.temp_lo AS low, W1.temp_hi AS high, W2.city, W2.temp_lo AS low, W2.temp_hi AS high
FROM weather W1, weather W2
WHERE W1.temp_lo < W2.temp_lo AND W1.temp_hi > W2.temp_hi;

-- List all weather records along with associated city location, using short aliases
SELECT *
FROM weather w, cities c
WHERE w.city = c.name;

-- Select the highest low-temperature from WEATHER table
SELECT max(temp_lo) FROM weather;

-- (Try to) Select the highest low-temperature from WEATHER table along with the corresponding cities, misplacing the aggregate function
SELECT city FROM weather WHERE temp_lo = max(temp_lo);

-- Select the highest low-temperature from WEATHER table along with the corresponding cities, the right way: using a subquery
SELECT city FROM weather
WHERE temp_lo = (SELECT max(temp_lo) FROM weather);

-- Select the highest low-temperature observed in each city
SELECT city, max(temp_lo)
FROM weather
GROUP BY city;

-- Filter results using HAVING clause
SELECT city, max(temp_lo)
FROM weather
GROUP BY city
HAVING max(temp_lo) < 40;

-- Add a where clause to filter by city name
SELECT city, max(temp_lo)
FROM weather
WHERE city LIKE 'S%'
GROUP BY city
HAVING max(temp_lo) < 40;

-- Subtract 2 degrees from temperatures after November 28
UPDATE weather
SET temp_hi = temp_hi - 2, temp_lo = temp_lo - 2
WHERE date > '1994-11-28';

-- Look at the new state of the data
SELECT * FROM weather;

-- Delete Hayward city records
DELETE FROM weather WHERE city = 'Hayward';

-- Look at the new state of the data
SELECT * FROM weather;

-- Delete all rows from WEATHER table
DELETE FROM weather;

-- Check the data again
SELECT * FROM weather;

-- Populate it back for coming exercises
INSERT INTO weather VALUES ('San Francisco', 46, 50, 0.25, '1994-11-27');
INSERT INTO weather(city, temp_lo, temp_hi, prcp, date)
VALUES ('San Francisco', 43, 57, 0.0, '1994-11-29');
INSERT INTO weather (date, city, temp_hi, temp_lo)
VALUES ('1994-11-29', 'Hayward', 54, 37);

-- Define a view
CREATE VIEW myview AS
SELECT city, temp_lo, temp_hi, prcp, date, location
FROM weather, cities
WHERE city = name;

-- Display the view
SELECT * FROM myview;

