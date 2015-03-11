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

