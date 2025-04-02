--Write a query to calculate the sum of salaries of employees grouped by department
--Medium Level Question
--Query
select department_id,
sum(salary) as total_salaries 
from employees 
group by department_id
