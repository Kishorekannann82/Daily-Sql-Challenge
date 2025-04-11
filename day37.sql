--Write a sql query to find records in Table A that are not in Table B without using NOT In Operator
--Trick Interviw Question
--Query
select * from Table A 
minus 
select * from Table B

--Write a sql queryy to find the employees that have same name and email
--Trick Interviw Question
--Query
select name,email,Count(*)
from employees
group  by name,email
having count(*)>1;

--How Can you findd 10 employees with odd number as Employee ID?
--Trick Interviw Question
--Query
select id from employees where id%2=1 amd row_num<11;

--Write a sql query to get the quarter from date
--Trick Interviw Question
--Query
select to_char(To_Date('11/4/25','MM/DD/YYYY'),Q)
As quarter
from Dual;