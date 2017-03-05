---------------------------------------------------------------------
-- MySQL Basics
---------------------------------------------------------------------

USE TSQL2012;

SELECT * FROM hr.employees;

SELECT employees.country FROM hr.employees;

SELECT DISTINCT employees.country FROM hr.employees;

SELECT employees.empid, employees.lastname FROM hr.employees;

SELECT employees.empid, employees.lastname FROM hr.employees ORDER BY empid;

-- Learned how to "choose order by index"
SELECT employees.empid, employees.lastname FROM hr.employees ORDER BY 1; -- Index also work: 1 is empid and 2 is lastname

-- Learned how to "concatenate using SELECT"
SELECT employees.empid, CONCAT(employees.firstname, ' ', employees.lastname) FROM hr.employees;
-- Learned how to "rename" the SELECT concatenation
SELECT employees.empid, CONCAT(employees.firstname, ' ', employees.lastname) AS fullname FROM hr.employees;

-- Learned how to "Combine different tables' columns with SELECT"
SELECT employees.empid, suppliers.supplierid, categories.categoryid, products.productid
	FROM hr.employees, production.suppliers, production.categories, production.products;
    
SELECT empid, lastname, supplierid, companyname, categoryid, categoryname, productid, productname
	FROM hr.employees, production.suppliers, production.categories, production.products;

---------------------------------------------------------------------
-- MySQL - Logical Query Processing
---------------------------------------------------------------------

SELECT shipperid, phone, companyname FROM sales.shippers;

---------------------------------------------------------------------
-- MySQL - Logical Query Processing Phases
---------------------------------------------------------------------

SELECT country, YEAR(hiredate) AS yearhired, COUNT(*) FROM hr.employees GROUP BY country, yearhired;

-- COMPLETE QUERY
SELECT country, YEAR(hiredate) AS yearhired, COUNT(*) AS numemployees
FROM hr.employees
WHERE hiredate >= '2003-01-01'
GROUP BY country, YEAR(hiredate) -- "yearhired" works as well
HAVING COUNT(*) > 1
ORDER BY country, yearhired DESC;

-- fails
SELECT country, YEAR(hiredate) AS yearhired
FROM hr.employees
WHERE YEAR(hiredate) >= '2003-01-01'; -- yearhired >= '2003-01-01'; -- It has to be the original name hiredate. YEAR(hiredate) works as well
-- Learned that the WHERE clauses occur before the SELECT clauses

-- MySQL - LOGICAL QUERY PROCESS ORDER
	-- FROM
    -- WHERE
    -- GROUP BY
    -- HAVING
    -- SELECT
    -- ORDER BY

-- fails
SELECT empid, country, YEAR(hiredate) AS yearhired, yearhired - 1 AS prevyear
FROM hr.employees;

SELECT country, empid, YEAR(hiredate) AS yearhired FROM hr.employees GROUP BY country, YEAR(hiredate);