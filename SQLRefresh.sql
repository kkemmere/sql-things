/*
SQL refresh
CRUD= CREATE, READ, UPDATE, DELETE
*/
SELECT * FROM university.student WHERE student.ID=00128;

SELECT "Hello, World" as "Result";

USE classicmodels;

SELECT customerNumber, customerName AS "Name" FROM customers ORDER BY Name LIMIT 5;
SELECT customerNumber, customerName AS "Name" FROM customers ORDER BY Name LIMIT 5 OFFSET 5;
SELECT customerNumber, customerName AS "Name" FROM customers WHERE customerName = "La Rochelle Gifts";

SELECT (SELECT COUNT(*) FROM customers) as C, (SELECT COUNT(*) FROM employees) as E;

-- CREATE TABLE test (
--  a INTEGER NOT NULL,
--  b TEXT NOT NULL
--  );
--  
--  INSERT INTO test VALUES (1,'a');
--  INSERT INTO test VALUES (2,'b');
--  INSERT INTO test VALUES (3,'c');
--  SELECT * FROM test;
--  
--  DROP TABLE IF EXISTS test;


-- 0, NULL, "" are much different and must be distinct. NULL in SQL = LACK OF VALUE
-- When creating a table if you use the constraint "NOT NULL" after defining a column. It will only allow
-- inserts that are infact NOT NULL
-- Other constraints you can use are "DEFAULT x, UNIQUE depending on your DBMS(Database Management System)

SELECT * FROM customers WHERE customerNumber IS NULL;

CREATE TABLE test (
 id INTEGER AUTO_INCREMENT, PRIMARY KEY (id),
 a INTEGER NOT NULL,
 b TEXT NOT NULL
 );
 
INSERT INTO test (a,b) VALUES (1, "thisOne");
SELECT * FROM test;

-- ALTER TABLE test ADD d TEXT;
-- ALTER TABLE test ADD e TEXT DEFAULT 'def';
-- SELECT * FROM test;

 DROP TABLE IF EXISTS test;

-- Select customers with less than 10,000 credit limit or no value(NULL) 
SELECT * FROM customers WHERE creditLimit < 10000 OR creditLimit IS NULL ORDER BY creditLimit DESC;

SELECT * FROM customers WHERE creditLimit < 10000 AND country = "USA" ORDER BY creditLimit DESC;

-- All customers in a city which contain 'New"
SELECT * FROM customers WHERE city LIKE '%New%' ORDER BY customerName;
-- All customers in a city which contains 'a' as a second letter
SELECT * FROM customers WHERE city LIKE '_a%' ORDER BY customerName;

-- All customers where country is USA or Sain
SELECT * FROM customers WHERE country IN ('Spain', 'USA') ORDER BY customerName;

-- Select all unique customers
-- DISTINCT = ONLY UNIQUE RESULTS
SELECT DISTINCT customerName  AS 'Names' FROM customers;
SELECT DISTINCT country AS '#ofcountries' FROM customers;

SELECT customerNumber, customerName, phone FROM customers ORDER BY customerName ASC, customerNumber, phone;

-- JOINS -- INNER JOIN (DEFAULT) = ROWS FROM BOTH TABLES WHERE CONDITION IS MET(INTERSECTION) LEFT OUTER JOIN IS INTERSECTION+LEFT. RIGHT OUTER JOIN IS INTERSECTION+RIGHT. FULL OUTER JOIN IS 

CREATE TABLE left1 ( id INTEGER, descrip TEXT);
CREATE TABLE right1 (id INTEGER, descrip TEXT);

INSERT INTO left1 VALUES (1,'left 01');
INSERT INTO left1 VALUES (2,'left 02');
INSERT INTO left1 VALUES (3,'left 03');
INSERT INTO left1 VALUES (4,'left 04');
INSERT INTO left1 VALUES (5,'left 05');
INSERT INTO left1 VALUES (6,'left 06');
INSERT INTO left1 VALUES (7,'left 07');
INSERT INTO left1 VALUES (8,'left 08');

INSERT INTO right1 VALUES (6,'right 06');
INSERT INTO right1 VALUES (7,'right 07');
INSERT INTO right1 VALUES (8,'right 08');
INSERT INTO right1 VALUES (9,'right 09');
INSERT INTO right1 VALUES (10,'right 10');
INSERT INTO right1 VALUES (11,'right 11');
INSERT INTO right1 VALUES (12,'right 12');
INSERT INTO right1 VALUES (13,'right 13');

SELECT * FROM left1;
SELECT * FROM right1;

-- Default JOIN = INNER JOIN only where condition is met
SELECT l.descrip AS 'left', r.descrip AS 'right' FROM left1 AS l JOIN right1 AS r ON l.id = r.id;
-- LEFT OUTER JOIN CONTAINS LEFT TABLE + where condition is met
SELECT l.descrip AS 'left', r.descrip AS 'right' FROM left1 AS l LEFT OUTER JOIN right1 AS r ON l.id = r.id;

DROP TABLE IF EXISTS right1;
DROP TABLE IF EXISTS left1;

-- INNER JOIN ON ORDERS + CUSTOMERS: GET ALL ORDERS WHO ORDERED THEM AND AT WHAT DATE + STATUS
SELECT o.orderNumber AS 'order', c.customerName AS 'Name', o.orderDate, o.status FROM orders AS o JOIN customers AS c ON o.customerNumber=c.customerNumber;

-- ORDERS IS USED AS A JUNCTION TABLE HERE JOINING ORDERDETAILS TO THEIR RESPECTIVE CUSTOMERS
-- SAME ORDER CAN HAVE MULTIPLE PRODUCTS 
SELECT o.orderNumber AS 'order', c.customerNumber AS 'Custom#', c.customerName AS 'Name', o.orderDate, o.status, od.priceEach AS 'Price'
FROM orders AS o 
JOIN customers AS c ON o.customerNumber=c.customerNumber
JOIN orderdetails AS od ON o.orderNumber=od.orderNumber;

-- SUBSELECT
SELECT (SELECT COUNT(*) FROM orders) AS 'ordered', (SELECT COUNT(*) FROM orderdetails) AS '#ofproducts';

-- STRINGS (PLATFORM SPECIFIC) --
-- LITER STRING: SELECT 'a string here';
-- STANDARD SQL CAN USE || for concatination but not MySQL
-- SUBSTR(), LENGTH(), TRIM(), UPPER(), LOWER()

-- LENGTH OF STRING
SELECT customerName, LENGTH(customerName) AS Length FROM customers ORDER BY Length ASC;

-- SUBSTRING 
SELECT customerName, SUBSTR(customerName, 6, 5) FROM customers;
-- BREAK UP A DATE BY MONTH/YEAR/DAY USED TO PARSE THROUGH "PACKED DATA" 
SELECT orderDate, SUBSTR(orderDate, 6,2) AS MONTH, SUBSTR(orderDate,1,4) AS YEAR, SUBSTR(orderDate,9) AS DAY  FROM orders;

-- REMOVE SPACES(TRIM)
SELECT TRIM(' MYSQL IS SO COOL       ');
SELECT LTRIM(' MYSQL IS SO COOL       ');
SELECT RTRIM(' MYSQL IS SO COOL       ');

-- UPPER/LOWER
SELECT UPPER(customerName) FROM customers;
SELECT LOWER(customerName) FROM customers;
SELECT UPPER('StrKG') = UPPER('StrKG');

-- NUMERIC TYPES
SELECT TYPEOF(1+1); -- Doesn't work in MySQL
SELECT 1.0/2;
SELECT CAST(1 AS REAL)/2;
SELECT ROUND(2.5555555);
SELECT ROUND(2.5555555,3);

-- DATE/TIME (DEPENDS ON DB MANAGEMENT SYSTEM) CONSULT DOCUMENTATION
SELECT DATE('now', '+1 day'); -- Doesn't work in MySQL
SELECT DAYOFWEEK();
SELECT orderDate FROM orders;

-- AGGREGATES --
SELECT COUNT(customerNumber) FROM customers;
-- NUM of customers based on country
SELECT country, COUNT(customerNumber) AS Count FROM customers GROUP BY country ORDER BY Count ASC;
-- NUM of orders based on country where orders >= 10
SELECT c.country AS Country, COUNT(o.orderNumber) AS NumOrders
FROM customers as c 
JOIN orders AS o ON c.customerNumber = o.customerNumber
GROUP BY Country 
HAVING NumOrders >= 10
ORDER BY NumOrders DESC;
-- AVG
SELECT AVG(priceEach) FROM orderdetails;
-- MIN/MAX
SELECT MAX(priceEach) FROM orderdetails;
SELECT MIN(priceEach) FROM orderdetails;
-- DISTINCT AGG
SELECT country, COUNT(DISTINCT customerNumber) AS Count FROM customers GROUP BY country ORDER BY Count ASC;

-- TRANSACTIONS (GROUP OF INSERTS/QUERYS.. ETC) CONSULT DOCUMENTATION FOR SYNTAX ON TRANSACTIONS
CREATE TABLE test (
 id INTEGER AUTO_INCREMENT, PRIMARY KEY (id),
 a INTEGER NOT NULL,
 b TEXT NOT NULL
 );
 
START TRANSACTION;
INSERT INTO test (a,b) VALUES (1, "thisOne");
-- USUALLY UPDATE HERE
-- CAN USE ROLLBACK HERE TO STOP FROM COMPLETING THE TRANSACTION
COMMIT;

SELECT * FROM test;

-- TRIGGERS -- (ALL TRIGGERS ARE DIFFERENT FROM DB MANAGEMENT SYSTEM TO ANOTHER SO CONSULT DOCUMENTATION) THIS BELOW DOESNT WORK IN MYSQL
-- TRIGGERS CAN ALSO BE USED TO STOP ANY CHANGE TO A TABLE THAT MAY NOT BE USED FOR VARIOUS REASONS
-- CREATE TRIGGER x BEFORE UPDATE ON y as an example. UNABLE TO DO THIS IN MYSQL
-- TRIGGERS ARE USUALLY STORED WITH THE TABLE BUT MAY NOT BE TRUE IN OTHER DBMS
-- INSERT INTO customers (customerName) VALUES ('Bob');
-- CREATE TRIGGER newCustomer AFTER INSERT ON customers
-- 	BEGIN
-- 		UPDATE customers SET customerNumber=NEW.customerNumber WHERE customers.customerNumber = NEW.customerNumber;
-- 	END;

-- EXAMPLE BELOW OF COMPLEX TRIGGER SQLite ( WILL LOOK DIFFERENT IN MYSQL)
-- CREATE TRIGGER stampSale AFTER INSERT ON widgetSale
-- 		BEGIN
--         UPDATE widgetSale SET stamp = DATETIME('now') WHERE id = NEW.id;
--         UPDATE widgetCustomer SET last_order_id = NEW.id, stamp = DATETIME('now')
--   			WHERE widgetCustomer.id = NEW.customer_id;
-- 		   INSERT INTO widgetLog (stamp, event, username, tablenma,e table_id) VALUES (DATETIME('now'), 'INSERT', 'TRIGGER', 'widgetSale', NEW.id);
--      END; 


-- VIEWS -- (BASICALLY TEMPORARY TABLES THAT CAN BE USED IN OTHER QUERIES WHERE YOU WOULD USE A TABLE)
CREATE VIEW countryOrders AS
SELECT c.country AS Country, COUNT(o.orderNumber) AS NumOrders
FROM customers as c 
JOIN orders AS o ON c.customerNumber = o.customerNumber
GROUP BY Country 
HAVING NumOrders >= 10
ORDER BY NumOrders DESC;

DROP VIEW IF EXISTS countryOrders;