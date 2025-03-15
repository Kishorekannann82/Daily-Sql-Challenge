--list employee who earn more than their department average
--Tables(employee_id,depatment_id,salary)
--Amazon Interview question
--Query
with department_avg as(
    select department_id,avg(salary) as avg_salary
    from employee
    group by department_id;
)
select e.employee_id,e.salary 
from employee e 
join department_avg da 
on e.department_id=da.department_id 
where e.salary>da.salary;