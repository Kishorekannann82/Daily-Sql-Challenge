/*
🧠 Challenge: Employees Who Earn More Than Their Manager
🗃️ Table:
*/

Employees (
  emp_id INT,
  emp_name VARCHAR(50),
  salary DECIMAL(10,2),
  manager_id INT
)
/*
🎯 Task:

Find all employees whose salary is greater than their manager’s salary.

✅ Example Data:
emp_id	emp_name	salary	manager_id
1	Alice	8000.00	NULL
2	Bob	6000.00	1
3	Charlie	9000.00	1
4	David	7000.00	2
5	Eva	5000.00	2
✅ Expected Output:
emp_id	emp_name	salary	manager_id
3	Charlie	9000.00	1
4	David	7000.00	2
✅ MySQL Answer:
*/

SELECT 
    e.emp_id,
    e.emp_name,
    e.salary,
    e.manager_id
FROM Employees e
JOIN Employees m 
    ON e.manager_id = m.emp_id
WHERE e.salary > m.salary;