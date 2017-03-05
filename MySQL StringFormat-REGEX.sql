---------------------------------------------------------------------
-- CONCATENATION
---------------------------------------------------------------------

SELECT empid, country, region, city,
  CONCAT(country, ', ', region, ', ', city) AS location
  FROM HR.Employees;

SELECT empid, country, region, city,
  CONCAT(country, ', ', COALESCE(region, ''), ', ', city) AS location
  FROM HR.Employees;

---------------------------------------------------------------------
-- Substring Extraction and Position
---------------------------------------------------------------------

SELECT SUBSTRING('abcde', 1, 3); -- 'abc'

SELECT LEFT('abcde', 3); -- 'abc'

SELECT RIGHT('abcde', 3); -- 'cde'

SELECT LOCATE(' ', 'Vinny Granja'); -- 6
SELECT LOCATE('a', 'Ala an apple'); -- 1
SELECT LOCATE('a', 'Ala an apple', 2); -- 3
SELECT LOCATE('a', 'Ala an apple', 4); -- 5
SELECT LOCATE('a', 'Ala an apple', 6); -- 8

SELECT INSTR('Ala an apple', 'a'); -- 1

SELECT PATINDEX('%[0-9]%', 'abcd123efgh'); -- 5

---------------------------------------------------------------------
-- Regular Expressions
---------------------------------------------------------------------

-- REGEXP
SELECT 'abcd123efgh' REGEXP '[0-9]+'; -- TRUE - Check if numbers exist or not (+) once or more instances in the string
SELECT '1123451a354' REGEXP '[aeiou]'; -- TRUE - Check if vowels exist or not in the string
SELECT '1123451y354' REGEXP '[aeiou]'; -- FALSE - Check if vowels exist or not in the string
SELECT 'aeiouYouiea' REGEXP '[^aeiou]'; -- TRUE - Check if any substring besides vowels exists in the string
SELECT 'aeioaYoueea' REGEXP '^[^aeiou]'; -- FALSE - Check if first substring begins with vowels in the string
SELECT 'eea' REGEXP '^[aeiou]'; -- TRUE - Check if substring begins with vowels

-- OR REGEXP 
SELECT '1123451y354' REGEXP '[aeiou]|9|6'; -- FALSE - The three OR Patterns (aeiou, 9, 6) does not exist in the string
SELECT '1123451y354' REGEXP '[aeiou]|9|6|54$'; -- TRUE - The last OR Pattern (54) at the end of the string exists
SELECT '1123451y354' REGEXP '[aeiou]|[ab]|[cde]'; -- FALSE - Check if vowels exist or not in the string

-- AND REGEXP
SELECT '1123451y354' REGEXP '[^aeiou].*[0-9]'; -- TRUE - Check if there is no vowels AND there is numeric numbers
SELECT '1123451y354' REGEXP '[aeiou].*9.*6'; -- FALSE - The three AND Patterns (aeiou, 9, 6) does not exist in the string
SELECT '1123451y354' REGEXP '[^aeiou].*1.*54$'; -- TRUE - The three AND Patterns (^aeiou, 1, 54$) does exist in the string
SELECT '1123451y354' REGEXP '[^aeiou].*1.*11$'; -- FALSE - The first two AND Patterns (^aeiou, 1) does exist but the last one (11$) does not

-- Find all cells from column "unitprice" that has the number 1 in it;
SELECT unitprice FROM Production.Products WHERE unitprice REGEXP '1';
SELECT unitprice FROM Production.Products WHERE unitprice REGEXP '5';

---------------------------------------------------------------------
-- String Length
---------------------------------------------------------------------

SELECT LENGTH(N'xyz'); -- 3

---------------------------------------------------------------------
-- String Alteration
---------------------------------------------------------------------

SELECT REPLACE('.1.2.3.', '.', '/'); -- '/1/2/3/'

SELECT INSERT(',x,y,z', 1, 1, ''); -- 'x,y,z' INSERT(str, pos(position), len, newstr)
SELECT INSERT(',x,y,z', 3, 1, ''); -- ',xy,z' 

---------------------------------------------------------------------
-- String Formating
---------------------------------------------------------------------

SELECT UPPER('aBcD'); -- 'ABCD'

SELECT LOWER('aBcD'); -- 'abcd'

SELECT RTRIM(LTRIM('   xyz   ')); -- 'xyz'

SELECT FORMAT(1759, 9); -- 1,759.000000000
SELECT FORMAT(1759, 9, 'de_DE'); -- 1.759,000 
SELECT FORMAT(1759, 3, 'en_US'); -- 1,759.000

---------------------------------------------------------------------
-- CASE Expression and Related Functions
---------------------------------------------------------------------

-- simple CASE expression
SELECT productid, productname, unitprice, discontinued,
  CASE discontinued
    WHEN 0 THEN 'No'
    WHEN 1 THEN 'Yes'
    ELSE 'Unknown'
  END AS discontinued_desc
FROM Production.Products;

-- searched CASE expression
SELECT productid, productname, unitprice,
  CASE
    WHEN unitprice < 20.00 THEN 'Low'
    WHEN unitprice < 40.00 THEN 'Medium'
    WHEN unitprice >= 40.00 THEN 'High'
    ELSE 'Unknown'
  END AS pricerange
FROM Production.Products;