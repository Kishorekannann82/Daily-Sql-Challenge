/*
🧠 Challenge: Second Highest Salary per Department
🗃️ Table: Employees
*/
Employees (
  emp_id INT,
  emp_name VARCHAR(50),
  department_id INT,
  salary DECIMAL(10, 2)
)
/*
🎯 Task:
For each department, find the second highest salary and the employee(s) who earn it.
*/
SELECT department_id, emp_name, salary
FROM (
    SELECT 
        department_id,
        emp_name,
        salary,
        DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rnk
    FROM Employees
) ranked
WHERE rnk = 2;
