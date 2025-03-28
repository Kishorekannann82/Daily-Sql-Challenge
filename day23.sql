--Write a sql query to find the total number of employees in each department sorted by department name
--Medium level Question
--Query
select department_names,count(employee_id) as total_employees 
from employees e
join departments d on e.department_id=m.department_id
group by department_names
order by department_names;