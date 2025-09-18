/*
🧠 Challenge: Employees With the Highest Salary Per Department
🗃️ Table:
Employees (
  emp_id INT,
  emp_name VARCHAR(50),
  department VARCHAR(50),
  salary DECIMAL(10,2)
)

🎯 Task:

Find the employee(s) with the highest salary in each department.

✅ Example Data:
emp_id	emp_name	department	salary
1	Alice	HR	8000.00
2	Bob	IT	6000.00
3	Charlie	IT	9000.00
4	David	Finance	7000.00
5	Eva	HR	8500.00
✅ Expected Output:
department	emp_name	salary
HR	Eva	8500.00
IT	Charlie	9000.00
Finance	David	7000.00
✅ MySQL Answer (Using Window Function):
*/
WITH Ranked AS (
    SELECT 
        department,
        emp_name,
        salary,
        RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
    FROM Employees
)
SELECT department, emp_name, salary
FROM Ranked
WHERE rnk = 1;