--Write a SQL query to return all employees who are in any department.
--Medium Level Interview
--Query
select employee_id,
f_name,
l_name 
from employees 
where employee_id in(
    select manager_id 
    from departments 
    where manager_id is not null
);