---------------------------------------------------------------------
-- MySQL FROM Clause
---------------------------------------------------------------------

-- Returns the name of the current database
SELECT DATABASE();

SHOW DATABASES;

USE TSQL2012;

-- basic example
SELECT empid, firstname, lastname FROM HR.Employees;

-- IMPORTANT assigning a table alias
SELECT E.empid, firstname, lastname FROM HR.Employees AS E;

---------------------------------------------------------------------
-- MySQL SELECT Clause
---------------------------------------------------------------------

-- projection of a subset of the source attributes
SELECT empid, firstname, lastname FROM HR.Employees;

-- bug due to missing comma
SELECT empid, firstname lastname FROM HR.Employees;

-- aliasing for renaming
SELECT empid AS employeeid, firstname, lastname FROM HR.Employees;

SELECT empid, CONCAT(firstname , ' ', lastname) FROM HR.Employees;

SELECT empid, CONCAT(firstname , ' ', lastname) AS fullname FROM HR.Employees;

-- With duplicates
SELECT country, region, city FROM HR.Employees;

-- removing duplicates with DISTINCT
SELECT DISTINCT country, region, city FROM HR.Employees;

-- SELECT without FROM
SELECT 10 AS col1, 'ABC' AS col2;

-- Specific search using SELECT
SELECT 'Seattle' AS 'city', 'WA' AS 'region', 'UK' AS 'country';

---------------------------------------------------------------------
-- MySQL Workbench
---------------------------------------------------------------------
DELIMITER //

CREATE FUNCTION f_try (try VARCHAR(20))
BEGIN
	SELECT CAST(try AS DECIMAL(28,14)) AS VALUE;
    SET try = '29545428.022495';
    RETURN f_try;
END//

DELIMETER ;

---------------------------------------------------------------------
-- MySQL Workbench PROCEDURE
---------------------------------------------------------------------

DELIMITER //

CREATE PROCEDURE f_test (var VARCHAR(20))
BEGIN
    SELECT CAST(var AS DECIMAL(28,14)) AS value;
END;
//

DELIMITER ;

CALL f_test ('29545428.022495');

---------------------------------------------------------------------
-- MySQL END of PROCEDURE
---------------------------------------------------------------------

SELECT CAST('29545428.022495' AS DECIMAL(14, 6));

SELECT CAST('29545428.022495' AS SIGNED);

-- Nice usage of CAST to change formats within tables
SELECT CAST(unitprice AS DECIMAL(5, 2)) AS FlotUnitPrice FROM Sales.OrderDetails;

---------------------------------------------------------------------
-- MySQL Workbench END
---------------------------------------------------------------------
  
SELECT CURDATE() AS GETDATE;
SELECT CURRENT_TIMESTAMP() AS TIME_NOW;
SELECT UNIX_TIMESTAMP() AS GETUTCDATE;
SELECT UTC_DATE() AS UTCDATE;
SELECT SYSDATE() AS THE_DATETIME;
SELECT UTC_TIMESTAMP() AS UTCDATETIME;
  
---------------------------------------------------------------------
-- MySQL Date and Time Parts
---------------------------------------------------------------------

SELECT MONTH('20120212') AS month;

-- DAY, MONTH, YEAR
SELECT
  DAY('20120212') AS theday,
  MONTH('20120212') AS themonth,
  YEAR('20120212') AS theyear;

SELECT DAYNAME('20090212') AS weekname;
SELECT MONTHNAME('20090212') AS monthname;

-- fromparts
SELECT
  DATEFROMPARTS(2012, 02, 12),
  DATETIME2FROMPARTS(2012, 02, 12, 13, 30, 5, 1, 7),
  DATETIMEFROMPARTS(2012, 02, 12, 13, 30, 5, 997),
  DATETIMEOFFSETFROMPARTS(2012, 02, 12, 13, 30, 5, 1, -8, 0, 7),
  SMALLDATETIMEFROMPARTS(2012, 02, 12, 13, 30),
  TIMEFROMPARTS(13, 30, 5, 1, 7);

SELECT EOMONTH(SYSDATETIME());

---------------------------------------------------------------------
-- Add and Diff Functions
---------------------------------------------------------------------

SELECT DATE_ADD('20120212', INTERVAL 1 YEAR);

SELECT DATEDIFF('20110212', '20120212'); -- Difference in DAYS
SELECT PERIOD_DIFF('201102', '201202'); -- Difference in WEEKS 
SELECT TIMEDIFF('2011-02-12 08:25:00.002', '2011-02-12 16:45:00.020'); -- Difference in HOURS:MINUTES:SECONDS.MILLISECONS

SELECT TIMESTAMPDIFF(DAY, '2011-06-12 ', '2012-02-24'); -- Return DAYS diff only
SELECT TIMESTAMPDIFF(MONTH, '2011-06-12', '2012-02-24'); -- Return MONTHS diff only
SELECT TIMESTAMPDIFF(YEAR, '2011-02-24', '2013-02-24'); -- Return YEARS diff only
SELECT TIMESTAMPDIFF(HOUR, '2011-02-24 08:25:00.002', '2012-02-24 16:45:02.020'); -- Return total time diff in HOURS
SELECT TIMESTAMPDIFF(MINUTE, '2011-02-24 08:25:00.002', '2012-02-24 16:45:02.020'); -- Return total time diff in MINUTES
SELECT TIMESTAMPDIFF(SECOND, '2011-02-24 08:25:00.002', '2012-02-24 16:45:02.020'); -- Return total time diff in SECONDS
SELECT TIMESTAMPDIFF(MICROSECOND, '2011-02-24 08:25:00.002', '2012-02-24 16:45:02.020'); -- Return total time diff in MICROSECONDS