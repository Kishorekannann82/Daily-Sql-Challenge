--  Find employee who have never been a manager and have worked in more than one department ..
--Table(employees (employee_id,name,manager_id,department_id)
with non_manager as(
    select employee_id,name
    from employee
    where employee_id not in(select distinct(manager_id) from employee where manager_id is not null)
),
Employee_Count as(
    select employee_id,count(distinct department_id) as dept_count
    from employee
    group by employee_id
)
Select nm.employee_id,nm,name 
from non_manager nm
join Employee_Count Ec on nm.employee_id=ec.employee_id
where ec.dept_count>1;
