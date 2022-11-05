use university;

UNLOCK TABLES;

LOCK TABLES classroom WRITE;

LOCK TABLES department WRITE;

SET FOREIGN_KEY_CHECKS=0;

LOCK TABLES section WRITE;
DELETE FROM section WHERE course_id = "CS-001";

INSERT INTO section (course_id, sec_id, semester, year) Values ("CS-001", "1", "Autumn", "2009");

LOCK TABLES course WRITE;
DELETE FROM course WHERE course_id = "CS-001";

INSERT INTO course (course_id, title, dept_name, credits) Values ("CS-001", "Weekly Seminar", "Comp. Sci.", "0.0");

select *
from course;

LOCK TABLES section WRITE;

select *
from section;

LOCK TABLES student WRITE, section WRITE, takes WRITE, teaches WRITE, course WRITE;
INSERT INTO takes (ID, course_id, sec_id, semester, year)
select student.ID, section.course_id, section.sec_id, teaches.semester, teaches.year from student, section, teaches
where dept_name = "Comp. Sci.";

SET FOREIGN_KEY_CHECKS=1;

SET SQL_SAFE_UPDATES = 0;
DELETE FROM takes
where takes.ID in (select student.ID from student where student.name = "Chavez");

DELETE FROM section
where course_id = "CS-001";

DELETE FROM course
where course_id = "CS-001"; 
/* If this delete statement is ran without first deleting offerings(sections) of the course it will give an error
saying that the foreign key must be deleted first */

DELETE from takes
where takes.course_id in (select course_id from course where title = "%database%");

select student.ID, student.name, Count(semester)
from student, takes;

select * from student,takes;







