-- Display PostgreSQL version
SELECT version();

-- Display current date
SELECT current_date;

-- Add 2 and 2
SELECT 2 + 2;

-- Create CITIES table
CREATE TABLE cities (
  city      varchar(80) primary key,
  location  point
);

-- Create WEATHER table
CREATE TABLE weather (
  city    varchar(80) references cities(city),
  temp_lo int,                                  -- low temperature
  temp_hi int,                                  -- high temperature
  prcp    real,                                 -- precipitation
  date    date
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

-- Define a view
CREATE VIEW myview AS
SELECT city, temp_lo, temp_hi, prcp, date, location
FROM weather, cities
WHERE city = name;

-- Display the view
SELECT * FROM myview;

-- Add constraints to city and weather tables (You can also use updated definitions above)
ALTER TABLE cities ADD PRIMARY KEY(name);
ALTER TABLE weather ADD FOREIGN KEY(city) REFERENCES cities(name);
ALTER TABLE cities RENAME COLUMN name TO city;

-- Try to insert an invalid record
INSERT INTO weather VALUES ('Berkeley', 45, 53, 0.0, '1994-11-28');

-- Create BRANCHES and ACCOUNTS tables to illustrate transactions usage
CREATE TABLE branches (
  name    varchar(80) primary key,
  balance real
);
CREATE TABLE accounts (
  name        varchar(80),
  branch_name varchar(80) references branches(name),
  balance     real
);

-- Insert records into BRANCHES table
INSERT INTO branches (name, balance)
VALUES ('alice_branch', 300.00);
INSERT INTO branches (name, balance)
VALUES ('bob_branch', 300.00);
INSERT INTO branches (name, balance)
VALUES ('wally_branch', 300.00);

-- Insert records into ACCOUNTS table
INSERT INTO accounts (name, branch_name, balance)
VALUES ('Alice', 'alice_branch', 300.00);
INSERT INTO accounts (name, branch_name, balance)
VALUES ('Bob', 'bob_branch', 300.00);
INSERT INTO accounts (name, branch_name, balance)
VALUES ('Wally', 'wally_branch', 300.00);

-- Check ACCOUNTS and BRANCHES tables content
SELECT * FROM accounts;
SELECT * FROM branches;

-- Begin transaction from Alice's account to Bob's account
BEGIN;
UPDATE accounts SET balance = balance - 100.00
WHERE name = 'Alice';

-- Check that in the middle of the transaction Alice's account has been debited while Bob's account still have to be credited
SELECT * FROM accounts;

-- Abort the transaction using ROLLBACK command
ROLLBACK;

-- Check that we are in the state prior to the "failed" transaction
SELECT * FROM accounts;
SELECT * FROM branches;

-- Proceed the whole transaction
BEGIN;
UPDATE accounts SET balance = balance - 100.00
WHERE name = 'Alice';
UPDATE branches SET balance = balance - 100.00
WHERE name = (SELECT branch_name FROM accounts WHERE name = 'Alice');
UPDATE accounts SET balance = balance + 100.00
WHERE name = 'Bob';
UPDATE branches SET balance = balance + 100.00
WHERE name = (SELECT branch_name FROM accounts WHERE name = 'Bob');
COMMIT;

-- Check that the transaction completed successfully
SELECT * FROM accounts;
SELECT * FROM branches;

-- Check ACCOUNTS table content
SELECT * FROM accounts;

-- Begin transaction from Alice's account to Bob's account
BEGIN;
UPDATE accounts SET balance = balance - 100.00 WHERE name = 'Alice';
SAVEPOINT my_savepoint;
UPDATE accounts SET balance = balance + 100.00 WHERE name = 'Bob';

-- Check ACCOUNTS table content
SELECT * FROM accounts;

-- Cancel transfer to Bob's account
ROLLBACK TO my_savepoint;

-- Check that Alice's account is still being debited while Bob's account is no longer credited
SELECT * FROM accounts;

-- Send the money to Wally instead
UPDATE accounts SET balance = balance + 100.00 WHERE name = 'Wally';
COMMIT;

-- Check the transaction results
SELECT * FROM accounts;

-- Create EMPSALARY table to follow Window Functions section
CREATE TABLE empsalary (
  depname     varchar(80),
  empno       int,
  salary      int,
  enroll_date date
);

-- Insert records into EMPSALARY table
INSERT INTO empsalary (depname, empno, salary, enroll_date) VALUES
('develop', 11, 5200, 'now'),
('develop', 7, 4200, 'now'),
('develop', 9, 4500, 'now'),
('develop', 8, 6000, 'now'),
('develop', 10, 5200, 'now'),
('personnel', 5, 3500, 'now'),
('personnel', 2, 3900, 'now'),
('sales', 3, 4800, 'now'),
('sales', 1, 5000, 'now'),
('sales', 4, 4800, 'now');

-- Compare each employee's salary with the average salary in his or her department
SELECT depname, empno, salary, avg(salary) OVER (PARTITION BY depname) FROM empsalary;

-- Rank employees by salary in their department, in descending order
SELECT depname, empno, salary, rank() OVER (
  PARTITION BY depname ORDER BY salary DESC
)
FROM empsalary;

-- Use OVER clause with no window frame (ORDER BY clause omitted) and for all rows (PARTITION BY clause not used) from EMPSALARY table
SELECT salary, sum(salary) OVER () FROM empsalary;

-- Define the window frame using SALARY column
SELECT salary, sum(salary) OVER (ORDER BY salary) FROM empsalary;

-- Use a subquery to apply a WHERE clause on window functions results
SELECT depname, empno, salary, enroll_date
FROM (
  SELECT depname, empno, salary, enroll_date, rank() OVER (
    PARTITION BY depname ORDER BY salary DESC, empno
  ) AS pos
  FROM empsalary
) AS ss
WHERE pos < 3;

-- Name window functions to avoid duplication
SELECT sum(salary) OVER w, avg(salary) OVER w
FROM empsalary
WINDOW w AS (PARTITION BY depname ORDER BY salary DESC);

-- Create CITIES table
CREATE TABLE cities (
  name        text,
  population  real,
  altitude    int   -- (in ft)
);

-- Create CAPITALS table which extends CITIES table
CREATE TABLE capitals (
  state char(2)
) INHERITS (cities);

-- Insert records into CITIES table
INSERT INTO cities (name, population, altitude) VALUES
-- Population from New Oxford American Dictionary's estimations (2008)
('Las Vegas', 558383, 2174),
('Mariposa', NULL, 1953);

-- Insert records into CAPITALS table
INSERT INTO capitals (name, population, altitude, state)
VALUES ('Madison', 231916, 845, 'WI');

-- Return cities located at an altitude over 500 feet
SELECT name, altitude
FROM cities
WHERE altitude > 500;

-- Return cities (excluding capitals) located at an altitude over 500 feet
SELECT name, altitude
FROM ONLY cities
WHERE altitude > 500;

