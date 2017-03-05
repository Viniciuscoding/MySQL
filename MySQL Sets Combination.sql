---------------------------------------------------------------------
-- MySQL - Combining Sets
---------------------------------------------------------------------

-- add row to Production.Suppliers
USE TSQL2012;

INSERT INTO Production.Suppliers(companyname, contactname, contacttitle, address, city, postalcode, country, phone)
  VALUES(N'Supplier XYZ', N'Jiru', N'Head of Security', N'42 Sekimai Musashino-shi', N'Tokyo', N'01759', N'Japan', N'(02) 4311-2609');

---------------------------------------------------------------------
-- MySQL - Joins
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Cross Joins
---------------------------------------------------------------------

-- THE ABOVE EXAMPLE IS MUCH MORE COMPLEX TO UNDERSTAND
SELECT Products.*, Orderdetails.*
FROM Sales.OrderDetails
	CROSS JOIN Production.Products
WHERE products.productid = Orderdetails.productid AND qty >= 120
ORDER BY products.productid;

---------------------------------------------------------------------
-- Inner Joins
---------------------------------------------------------------------

-- INNER JOIN of Sales and Production
SELECT Products.*, Orderdetails.*
FROM Sales.OrderDetails
	INNER JOIN Production.Products
		ON Products.Productid = OrderDetails.productid
WHERE qty >= 120;
        

-- same meaning
SELECT Products.*, Orderdetails.*
FROM Sales.OrderDetails
	INNER JOIN Production.Products
		ON Products.Productid = OrderDetails.productid
		AND qty >= 120;

---------------------------------------------------------------------
-- OUTER JOINS or FULL JOINS
---------------------------------------------------------------------
SELECT Products.*, OrderDetails.*
FROM Sales.OrderDetails
	RIGHT JOIN Production.Products
	ON Products.Productid = OrderDetails.Productid

UNION ALL

SELECT Products.*, OrderDetails.*
FROM Sales.OrderDetails
	LEFT JOIN Production.Products
	ON Products.Productid = OrderDetails.Productid
ORDER BY qty;

---------------------------------------------------------------------
-- RIGHT OUTER JOINS or RIGHT JOINS
---------------------------------------------------------------------

SELECT Products.*, OrderDetails.*
FROM Sales.OrderDetails
	RIGHT JOIN Production.Products
	ON Products.Productid = OrderDetails.Productid
ORDER BY OrderDetails.productid;

---------------------------------------------------------------------
-- LEFT OUTER JOINS or LEFT JOINS
---------------------------------------------------------------------

SELECT Products.*, OrderDetails.*
FROM Sales.OrderDetails
	LEFT JOIN Production.Products
	ON Products.Productid = OrderDetails.Productid
ORDER BY OrderDetails.productid;	


---------------------------------------------------------------------
-- MySQL - Subqueries
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Self-Contained Subqueries
---------------------------------------------------------------------

-- SCALAR SUBQUERIES
-- products with minimum price
SELECT productid, productname, unitprice FROM Production.Products
	WHERE unitprice = (SELECT MIN(unitprice) FROM Production.Products);

SELECT * FROM Sales.OrderDetails
	WHERE unitprice = (SELECT MAX(unitprice) FROM Sales.OrderDetails);


-- multi-valued subqieries
-- products supplied by suppliers from Japan
SELECT * FROM Production.Products
   WHERE supplierid IN
	(SELECT supplierid
     FROM Production.Suppliers
     WHERE country = 'Japan');

---------------------------------------------------------------------
-- Correlated Subqueries
---------------------------------------------------------------------

-- products with minimum unitprice per category
SELECT categoryid, productid, productname, unitprice
FROM Production.Products AS P1
WHERE unitprice =
  (SELECT MIN(unitprice)
   FROM Production.Products AS P2
   WHERE P2.categoryid = P1.categoryid);

-- customers who placed an order on February 12, 2007
SELECT custid, companyname
FROM Sales.Customers AS C
WHERE EXISTS
  (SELECT *
   FROM Sales.Orders AS O
   WHERE O.custid = C.custid
     AND O.orderdate = '20070212');

-- customers who did not place an order on February 12, 2007
SELECT custid, companyname
FROM Sales.Customers AS C
WHERE NOT EXISTS
  (SELECT *
   FROM Sales.Orders AS O
   WHERE O.custid = C.custid
     AND O.orderdate = '20070212');

---------------------------------------------------------------------
-- Views
---------------------------------------------------------------------

CREATE OR REPLACE VIEW Sales.RankedProducts AS
SELECT categoryid, productid, productname, unitprice
FROM Production.Products
ORDER BY unitprice, productid;


SELECT categoryid, productid, productname, unitprice
FROM Sales.RankedProducts
WHERE rownum <= 2;

---------------------------------------------------------------------
-- APPLY
---------------------------------------------------------------------

SELECT productid, productname, unitprice
FROM Production.Products
WHERE supplierid = 1
ORDER BY unitprice, productid
LIMIT 0, 2;

---------------------------------------------------------------------
-- MySQL - UNION and UNION ALL
---------------------------------------------------------------------

-- locations that are employee locations or customer locations or both
SELECT country, region, city
FROM HR.Employees

UNION

SELECT country, region, city
FROM Sales.Customers;

-- with UNION ALL duplicates are not discarded
SELECT country, region, city
FROM HR.Employees

UNION ALL

SELECT country, region, city
FROM Sales.Customers;