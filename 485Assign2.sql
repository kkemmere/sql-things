/* 
CS485(Advanced Database) Assignment 2 "Joins"
Kevin Kemmerer
*/

use classicmodels;

/* 1)	For all customers, create a query to display the following column titles:
•	Customer_Number
•	Business_Name
•	Customer_Contact_Name
•	Sales_Rep_Name
•	Sales_Rep_Email
•	Sales_Rep_Phone_Number

And order the results by increasing customer number.
*/
select c.customerNumber as Customer_Number, c.customerName as Business_Name, c.contactFirstName as Customer_Contact_Name, e.lastName as Sales_Rep_Name, e.email as Sales_Rep_Email, e.extension as Sales_Rep_Phone_Number
from customers as c
join employees as e on c.salesRepEmployeeNumber = e.employeeNumber
order by c.customerNumber;

/* 2)	Create an organization chart of the employees in Classic Models with the following columns:
•	Superior_Name
•	Superior_Title
•	Employee_Name
•	Employee_Title
An employee reports to a superior.
*/
select e1.firstName as Employee_Name, e1.jobTitle as Employee_Title, e2.firstName as Superior_Name, e2.jobTitle as Superior_Title
from employees as e2
join employees as e1 on e1.reportsTo = e2.employeeNumber;

/* 3)	For each employee display their name and full address.  Display column titles as follows:
•	Name
•	Address_1
•	Address_2
•	City
•	State
•	Country
If Address_2 or State are NULL, display same as a blank.
*/
select e.firstName as Name, o.addressLine1 as Address_1, COALESCE(o.addressLine2, '') as Address_2, o.city as City, COALESCE(o.state, '') as State, o.country as Country
from offices as o
join employees as e on e.officeCode = o.officeCode;

/* Get ID, Name, and Location of Employee */
select CONCAT('ID:',' ',e.employeeNumber) as ID, CONCAT('NAME:',' ',e.firstName,' ',e.lastName) as Name, CONCAT('LOCATION:',' ',o.city,' ',COALESCE(o.state, ''),' ',o.country) as Address
from offices as o
join employees as e on e.officeCode = o.officeCode;

/* 4)	For the company named Herkku Gifts, display with each order number the names of the products ordered, along with the quantity of each such ordered item. */
select o.orderNumber as Order_Num, p.productName, o.quantityOrdered
from products as p
join orderdetails as o on p.productCode = o.productCode
join orders as ors on o.orderNumber = ors.orderNumber 
join customers as c on ors.customerNumber = c.customerNumber
where c.customerName = "Herkku Gifts";

/* 5)	Again for the company named Herkku Gifts, display with each order number the total dollar amount of each order.  (Use only those tables necessary in this query.) */
select c.customerName as Name, o.orderNumber as Order_Num, sum(p.amount)
from payments as p
join customers as c on p.customerNumber = c.customerNumber
join orders as o on c.customerNumber = o.customerNumber
where c.customerName = "Herkku Gifts"
group by o.orderNumber;

/* 6)	Switching gears to the university schema, display for every student taking classes belonging to the ‘Comp. Sci.’ department that student’s name, the course taken (both the course ID and course title) and the grade received by that student for that course.  (It is possible that a student might have taken the same course multiple times.) */
use university;
select s.name as Student, c.title as Course_Name, t.grade as Grade
from student as s
join takes as t on s.ID = t.ID 
join course as c on t.course_ID = c.course_ID
where c.dept_name = "Comp. Sci.";

/* 7)	For each of the instructors associated with the ‘Comp. Sci.’ department, display their name and then both the course ID and the title of the classes that they have taught. */
select i.name, c.course_id, c.title
from instructor as i
join teaches as t on i.ID = t.ID 
join course as c on t.course_id = c.course_id
where i.dept_name = "Comp. Sci.";

/* 8)	For each student with an advisor in the ‘Comp. Sci’ department, display first the name of the student and then the name of the advisor. */
select s.name as Student_Name, i.name as Advisor_Name
from advisor as a 
join student as s on s.ID = a.s_ID 
join instructor i on a.i_ID = i.ID
where i.dept_name = "Comp. Sci.";

/* 9) In a single query, Identify the names, IDs, and department of any students who do not have an advisor. */
select S.name, S.ID, S.dept_name
from student as S
join advisor as A on S.ID != A.s_ID
where not exists (select s_ID from advisor as A where S.ID = A.s_ID)
group by S.ID;

/* 10)	How many customers have not made any orders? */
use classicmodels;
select count(*)
from customers as C
left outer join orders as O on C.customerNumber = O.customerNumber
where o.customerNumber IS NULL;






