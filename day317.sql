/*
Find the second highest salary per department
You have an employees table. For each department, find the employee with the second highest salary. If a department has fewer than 2 distinct salaries, exclude it from the result.
Table: employees
emp_id	name	department	salary
1	Alice	Engineering	95000
2	Bob	Engineering	88000
3	Carol	Engineering	88000
4	Dave	Marketing	72000
5	Eve	Marketing	65000
6	Frank	HR	60000
Expected output
department	name	salary
Engineering	Bob	88000
Engineering	Carol	88000
Marketing	Eve	65000
*/
select department,name,salary
from employees
group by department, name, salary
order by department, salary desc
limit 1 offset 1;