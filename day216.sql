/*
🧠 Challenge: Employees Who Earn More Than Their Manager
🗃️ Table:
Employees (
  emp_id INT,
  emp_name VARCHAR(50),
  manager_id INT,
  salary DECIMAL(10,2)
)

🎯 Task:

Find all employees whose salary is greater than their manager’s salary.

✅ Example Data:
emp_id	emp_name	manager_id	salary
1	Alice	NULL	10000.00
2	Bob	1	9000.00
3	Charlie	1	12000.00
4	Diana	2	8500.00
5	Evan	2	9500.00
✅ Expected Output:
emp_name	manager_name	emp_salary	manager_salary
Charlie	Alice	12000.00	10000.00
Evan	Bob	9500.00	9000.00
✅ MySQL Answer:
*/
SELECT 
    e.emp_name AS employee,
    m.emp_name AS manager,
    e.salary AS emp_salary,
    m.salary AS manager_salary
FROM Employees e
JOIN Employees m 
    ON e.manager_id = m.emp_id
WHERE e.salary > m.salary;