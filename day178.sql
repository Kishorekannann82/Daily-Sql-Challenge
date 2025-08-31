/*
🧠 Challenge: Second Highest Salary
🗃️ Table:
*/
Employees (
  emp_id INT,
  emp_name VARCHAR(50),
  salary DECIMAL(10,2)
)
/*
🎯 Task:

Find the second highest salary in the company.
If no second highest exists, return NULL.
*/
SELECT 
    MAX(salary) AS second_highest_salary
FROM Employees
WHERE salary < (SELECT MAX(salary) FROM Employees);
