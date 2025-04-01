--Write a SQL query to find the employees wo have been with the company the longest
--Medium Level Question
--Query
select employee_id,first_name,last_name,hire_date
from employees
where hire_date=(select min(hire_date) from employees)