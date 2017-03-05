
---------------------------------------------------------------------
-- MySQL - Predicates, Three-Valued-Logic and Search Arguments
---------------------------------------------------------------------

USE TSQL2012;

-- content of Employees table
SELECT empid, firstname, lastname, country, region, city
	FROM HR.Employees;

-- employees from the United States
SELECT empid, firstname, lastname, country, region, city
	FROM HR.Employees
	WHERE country = 'USA';

-- employees from Washington State
SELECT empid, firstname, lastname, country, region, city
	FROM HR.Employees
	WHERE region = 'WA';

-- employees that are not from Washington State
SELECT empid, firstname, lastname, country, region, city
	FROM HR.Employees
	WHERE region <> 'WA';

-- employees that are not from Washington State, resolving the NULL problem
SELECT empid, firstname, lastname, country, region, city
	FROM HR.Employees
	WHERE region <> 'WA' OR region IS NULL;

SET @dt = '20070212';

-- incorrect treatment of NULLs
SELECT orderid, orderdate, empid
	FROM Sales.Orders
	WHERE shippeddate = @dt;

-- correct treatment but not SARG
SELECT orderid, orderdate, empid
	FROM Sales.Orders
	WHERE COALESCE(shippeddate, '19000101') = COALESCE(@dt, '19000101');

-- correct treatment and also a SARG
SELECT orderid, orderdate, empid
	FROM Sales.Orders
	WHERE shippeddate = @dt
   OR (shippeddate IS NULL AND @dt IS NULL);

---------------------------------------------------------------------
-- Filtering Character Data
---------------------------------------------------------------------

-- regular character string
SELECT empid, firstname, lastname
	FROM HR.Employees
	WHERE lastname = 'Davis';

-- Unicode character string
SELECT empid, firstname, lastname
	FROM HR.Employees
	WHERE lastname = N'Davis';

-- employees whose last name starts with the letter D.
SELECT empid, firstname, lastname
	FROM HR.Employees
	WHERE lastname LIKE N'D%';

---------------------------------------------------------------------
-- Filtering Date and Time Data
---------------------------------------------------------------------

-- language-dependent literal
SELECT orderid, orderdate, empid, custid
	FROM Sales.Orders
	WHERE orderdate = '02/12/07';

-- language-neutral literal
SELECT orderid, orderdate, empid, custid
	FROM Sales.Orders
	WHERE orderdate = '20070212';

-- not SARG
SELECT orderid, orderdate, empid, custid
	FROM Sales.Orders
	WHERE YEAR(orderdate) = 2007 AND MONTH(orderdate) = 2; -- Nice trick

-- NICE FILTERING FEATURE
SELECT orderid, orderdate, empid, custid
	FROM Sales.Orders
	WHERE YEAR(orderdate) = 2007 AND MONTH(orderdate) = 2 AND DAY(orderdate) > 5; -- AWESOME DATE FILTER
-- SARG
SELECT orderid, orderdate, empid, custid
	FROM Sales.Orders
	WHERE orderdate >= '20070201' AND orderdate < '20070301';

---------------------------------------------------------------------
-- Sorting Data
---------------------------------------------------------------------

-- query with no ORDER BY doesn't guarantee presentation ordering
SELECT empid, firstname, lastname, city, MONTH(birthdate) AS birthmonth
	FROM HR.Employees
	WHERE country = N'USA' AND region = N'WA';

-- Simple ORDER BY example
SELECT empid, firstname, lastname, city, MONTH(birthdate) AS birthmonth
	FROM HR.Employees
	WHERE country = N'USA' AND region = N'WA'
	ORDER BY city;

-- use descending order
SELECT empid, firstname, lastname, city, MONTH(birthdate) AS birthmonth
	FROM HR.Employees
	WHERE country = N'USA' AND region = N'WA'
	ORDER BY city DESC;

-- order by multiple columns
SELECT empid, firstname, lastname, city, MONTH(birthdate) AS birthmonth
	FROM HR.Employees
	WHERE country = N'USA' AND region = N'WA'
	ORDER BY city, empid;

-- order by ordinals (bad practice)
SELECT empid, firstname, lastname, city, MONTH(birthdate) AS birthmonth
	FROM HR.Employees
	WHERE country = N'USA' AND region = N'WA'
	ORDER BY 4, 1;

-- change SELECT list but forget to change ordinals in ORDER BY
SELECT title, titleofcourtesy, birthdate, hiredate, address, YEAR(birthdate) AS birthmonth
	FROM HR.Employees
	WHERE country = N'USA' AND region = N'WA'
	ORDER BY 4, 1;

-- IMPORTANT!!!!
-- order by elements not in SELECT
SELECT empid, city
	FROM HR.Employees
	WHERE country = N'USA' AND region = N'WA'
	ORDER BY birthdate;
    
-- NOTE: when DISTINCT specified, can only order by elements in SELECT

-- DISTINCT importance
-- following fails
SELECT DISTINCT city
FROM HR.Employees
WHERE country = N'USA' AND region = N'WA'
ORDER BY birthdate;

-- following succeeds
SELECT DISTINCT city
FROM HR.Employees
WHERE country = N'USA' AND region = N'WA'
ORDER BY city;

-- can refer to column aliases asigned in SELECT
SELECT empid, firstname, lastname, city, MONTH(birthdate) AS birthmonth
	FROM HR.Employees
	WHERE country = N'USA' AND region = N'WA'
	ORDER BY birthmonth; -- ORDER BY is the last logic processing. It comes after SELECT(before the last) has been processed;
]
-- IMPORTANT (NULLs sort first)
SELECT orderid, shippeddate
	FROM Sales.Orders
	WHERE custid = 20
	ORDER BY shippeddate;
    
---------------------------------------------------------------------
-- Filtering Data with LIMIT
---------------------------------------------------------------------

SELECT orderid, orderdate, custid, empid
	FROM Sales.Orders
	ORDER BY orderdate DESC
    LIMIT 3;

SELECT CONCAT(orderid * 100, '%') AS percentorderid, orderdate, custid, empid
	FROM Sales.Orders
	ORDER BY orderdate DESC
    LIMIT 1;

-- can use expression, like parameter or variable, as input
--  DECLARE @n AS BIGINT = 5;

-- I still have not figured out how to easily declare variables
-- HUGE HEADACHE TO DECLARE A VARIABLE in MySQL
DELIMITER //
	CREATE FUNCTION lol (n BIGINT)
	RETURNS BIGINT
	BEGIN
		RETURN n;
	END; //

DELIMITER ;

SELECT lol(5) AS worked;

-- Shows how to identify the type of a variable
CREATE TEMPORARY TABLE typeof AS SELECT lol(5) AS col;
DESCRIBE typeof;

-- GOOD TRY. BUT IT DOES NOT WORK IN MySQL!!!
SET @n = 5;

SELECT orderid, orderdate, custid, empid
	FROM Sales.Orders
	ORDER BY orderdate DESC
    LIMIT n; -- Declarations cannot be done in MySQL without creating a Function or Prospect

-- no ORDER BY, ordering is arbitrary
SELECT orderid, orderdate, custid, empid
	FROM Sales.Orders
    LIMIT 3;

-- be explicit about arbitrary ordering
SELECT orderid, orderdate, custid, empid
	FROM Sales.Orders
    ORDER BY (SELECT NULL);

-- non-deterministic ordering even with ORDER BY since ordering isn't unique
SELECT orderid, orderdate, custid, empid
	FROM Sales.Orders
	ORDER BY orderdate DESC
    LIMIT 3;

-- return all ties *** WITH and Ties do not work in MySQL. Use LIMIT instead
SELECT TOP (3) WITH TIES orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC;

-- break ties
SELECT orderid, orderdate, custid, empid
	FROM Sales.Orders
	ORDER BY orderdate DESC, orderid DESC
	LIMIT 3;

---------------------------------------------------------------------
-- Filtering Data with OFFSET-FETCH
---------------------------------------------------------------------

-- skip 50 rows, fetch next 25 rows
SELECT orderid, orderdate, custid, empid
	FROM Sales.Orders
    ORDER BY orderdate DESC, orderid DESC
    LIMIT 25
    OFFSET 50;

-- skip 20 rows, fetch next 10 rows
SELECT orderid, orderdate, custid, empid
	FROM Sales.Orders
    ORDER BY orderdate ASC, orderid ASC
    LIMIT 10
    OFFSET 20;

-- skip 20 rows, fetch next 10 rows
SELECT orderid, orderdate, custid, empid
	FROM Sales.Orders
    ORDER BY orderdate ASC, orderid ASC
    LIMIT 20, 10;

SELECT orderid, orderdate, custid, empid
	FROM Sales.Orders
    ORDER BY orderdate ASC, orderid ASC
    LIMIT 10;

-- fetch first 25 rows
SELECT orderid, orderdate, custid, empid
	FROM Sales.Orders
    ORDER BY orderdate DESC, orderid DESC
    LIMIT 25;

-- skip 50 rows, return all the rest
SELECT orderid, orderdate, custid, empid
	FROM Sales.Orders
    ORDER BY orderdate DESC, orderid DESC
    LIMIT 1000 -- You have to know the limit or either add LIMIT 18446744073709551610 which is the largest BIGINT value
    OFFSET 50;

SELECT orderid, orderdate, custid, empid
	FROM Sales.Orders
    ORDER BY orderdate DESC, orderid DESC
    LIMIT 50, 1000; -- You have to know the limit or either add LIMIT 18446744073709551610 which is the largest BIGINT value

-- ORDER BY is mandatory; return some 3 random rows
SELECT orderid, orderdate, custid, empid
	FROM Sales.Orders
	ORDER BY RAND()
	LIMIT 3;

-- can use expressions as input
SET @startit = 10.00, @endit = 25.00;

SELECT orderid, productid, unitprice, qty
	FROM Sales.OrderDetails
    WHERE unitprice BETWEEN @startit AND @endit
    ORDER BY orderid ASC, unitprice ASC
    LIMIT 25;
