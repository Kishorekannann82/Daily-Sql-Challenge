--write a query to list employee who have the same salary as their manager
--Medium level question
--Query
select e.employee_id,e.empname,e.salary
from employee eachjoin employee m 
on e.manager_id=m.manager_id 
where e.salary=m.salary;