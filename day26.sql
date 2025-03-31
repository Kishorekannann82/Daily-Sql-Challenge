--write a query to fetch employees who joined between two specific dates
--Medium Level Question
--Query
select employee_id,employee_name,join_date
from employees
where join_date between '2024-01-01' and '2024-12-31';