/*
🧠 Challenge: Find the Second Highest Salary per Department
🗃️ Tables:
*/
--Employees
Employees (
    emp_id INT,
    emp_name VARCHAR(100),
    salary DECIMAL(10,2),
    dept_id INT
)
--Departments
Departments 
(
    dept_id INT,
    dept_name VARCHAR(100)
)

/*
🎯 Your Task:
For each department, find the second highest salary among its employees.

Return:

dept_name

second_highest_salary
*/
with RankedSalaries as (
    d.dept_name as dept_name,
    e.salary,
    dense_rank() over(partition by e.dept_id order by e.salary desc) as salary_rank
    from Employees e 
    join Departments d 
    on e.emp_id = d.dept_id
)
select  dept_name ,salary
from RankedSalaries
where salary_rank=2;