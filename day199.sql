/*
🧠 Challenge: Nth Highest Salary Per Department
🗃️ Table:
Employees (
  emp_id INT,
  emp_name VARCHAR(50),
  department VARCHAR(50),
  salary DECIMAL(10,2)
)

🎯 Task:

For each department, find the 2nd highest salary (you can change N to 3, 4, etc. depending on requirement).

✅ Example Data:
emp_id	emp_name	department	salary
1	Alice	HR	8000.00
2	Bob	IT	6000.00
3	Charlie	IT	9000.00
4	David	Finance	7000.00
5	Eva	HR	8500.00
6	Frank	IT	7500.00
✅ Expected Output (2nd highest salary per department):
department	emp_name	salary
HR	Alice	8000.00
IT	Frank	7500.00
Finance	NULL	NULL
✅ MySQL Answer (Using DENSE_RANK()):
*/

WITH Ranked AS (
    SELECT 
        department,
        emp_name,
        salary,
        DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
    FROM Employees
)
SELECT department, emp_name, salary
FROM Ranked
WHERE rnk = 2;