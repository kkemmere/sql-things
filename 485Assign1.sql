/* 
CS485(Advanced Database) Assignment 1 
Kevin Kemmerer
*/

use classicmodels;

/* 1)	Create a query which returns all the customer’s business names in alphabetical order. */
select customerName from customers order by customerName;

/* 2)	Write a query to determine who is the vice president of sales (VP Sales) and return that person’s name and email address. */
select firstName, jobTitle, email from employees where jobTitle like "VP Sales";

/* 3)	Create a query of customer names including “Inc”  - as in incorporated – at the end of their name.  Display that customer’s business name, along with the customers contact name  – first followed by last name – as a single column titled Contact. */
select customerName, CONCAT(contactFirstName,', ', contactLastName) as Contact
from customers 
where customerName like "%Inc%";

/* 4)	Create a query to show customers in France or Germany which have customer name with suffix ‘Co.’ or ‘Co’. */
select customerName, country
from customers
where country = "France" and customerName like "%Co%" or "%Co.%" 
union select customerName, country 
from customers
where country = "Germany" and customerName like "%Co%" or "%Co.%";

/* 5)	For all customers in the ‘USA’, display the company name, both address line 1 and 2, city, state, and postal code.  If address line 2 is not known, display it as a blank.  Columns will be titled as follows: */
select customerName as Customer_Name, addressLine1 as Address, IFNULL(addressLine2, '') as Suite, city as City, state as State, postalCode as ZIP_Code
from customers;

/* 6)	Write a single query to determine the most expensive product, returning the product name, the quantity in stock, and its buy price.  (Hint: You will need a subquery.) */
select productName, quantityInStock, buyPrice
from products
where buyPrice >= (select max(buyPrice) from products);


/* 7)	Into the customers table insert a new record representing you and your company.  (Extra credit for automatically advancing customerNumber by one to a new value in the same operation.) */
insert into customers (customerNumber, customerName, contactLastName, contactFirstName, phone, addressLine1, addressLine2, city, state, postalCode, country) 
Values ("497", "Kevin", "Kemmerer", "Kevin", "651-142-9999", "1425 Spooky Street South", "Apt 2", "Halloween Town", "Minnesota", "55555", "United States");
/*test*/
-- select *
-- from customers
-- where customerNumber = "497";

/* 8)	Update your credit limit for your newly created company.  (You might need to use Preferences allow Updates and Deletes.) */
update customers set creditLimit = "2000" where customerNumber = 497;
/*test*/
-- select *
-- from customers
-- where customerNumber = "497";

/* 9)	Delete yourself as a customer. */
delete from customers where customerNumber = "497";
/*test*/
-- select *
-- from customers;


/* 10)	Display, using a single query, the name and email address of all employees with offices in New York City. */
select firstName, email
from employees where (select officeCode from offices where city = "NYC") = officeCode;


/* 11)	Update the previous query to display, using a single query, the name and email address of all employees with offices in Sydney, Paris, or London. */
select firstName, email
from employees as e1
where officeCode in (select officeCode from offices where city = "Sydney") 
or (select officeCode from offices where city = "Paris") 
or (select officeCode from offices where city = "London") = e1.officeCode;

/* 12)	How many customers have not made any orders? */
select count(C.customerNumber)
from customers as C
where not exists (select * from orders as O 
where C.customerNumber = O.customerNumber);

/* 13)	Display the name and telephone extension of employees representing customers having orders with status of ‘In Process’. */
/* Probably doesn't work correctly */
select e.firstName, e.employeeNumber, e.extension
from employees as e, orders as o, customers as c
where o.customerNumber = c.customerNumber;


/* 14)	For all customers, display the customer business name and their total dollar amount of orders for each, ordered by each customer’s order number.  Columns will be titled Customer and Total_Orders.
(Hint: Start by, instead of displaying customer name, temporarily display customer number.) */
select c.customerName as Customer, c.customerNumber, o.orderNumber, p.amount as Total_Orders
from customers as c, payments as p, orders as o
where c.customerNumber = p.customerNumber and o.customerNumber = c.customerNumber
order by o.orderNumber;

/* 15)	In the table orderdetails you will see that some orders have multiple products being ordered.  Using a query over that table, determine which orders have 18 different products.  Have the query display the order number (orderNumber) as a column titled Order_Num, and additionally order their display by this order number.  (Hint: This will require a single query consisting of two SELECTs, one being a subquery.) */
select orderNumber as Order_Num, count(productCode) as Num_Orders
from orderdetails
group by orderNumber
order by count(productCode) DESC;

/* 16)	Given those order numbers (from query 15), display - along with those order numbers - the product codes associated with each.  Multiple queries using temporary tables is acceptable.   { Extra points for doing this in a single query (consisting of three SELECTs) }. */
select orderNumber as Order_Num, count(productCode) as Num_Orders
from orderdetails
group by orderNumber;







