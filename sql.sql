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

