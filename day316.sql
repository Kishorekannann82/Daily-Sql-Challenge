/*
Employees Earning More Than Their Manager
📊 Scenario

You have an employee table where each employee may have a manager.

employees
emp_id	emp_name	salary	manager_id
1	Alice	50000	NULL
2	Bob	40000	1
3	Charlie	60000	1
4	David	45000	2
5	Eva	55000	2

manager_id refers to another employee's emp_id.

🎯 Goal

Find employees whose salary is greater than their manager's salary.

Return:

employee_name

employee_salary

manager_name

manager_salary

🧠 Expected Output
employee_name	employee_salary	manager_name	manager_salary
Charlie	60000	Alice	50000
Eva	55000	Bob	40000
*/
select e.emp_name as employee_name, e.salary as employee_salary, m.emp_name as manager_name, m.salary as manager_salary
from employees e    
join employees m on e.manager_id = m.emp_id
where e.salary > m.salary;
