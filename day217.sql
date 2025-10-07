/*
🧠 Challenge: Find Employees with the Highest Salary in Each Department
🗃️ Table:
Employees (
  emp_id INT,
  emp_name VARCHAR(50),
  dept_id INT,
  salary DECIMAL(10,2)
)

Departments (
  dept_id INT,
  dept_name VARCHAR(50)
)

🎯 Task:

For each department, find the employee(s) who earn the highest salary.

✅ Example Data:

Employees

emp_id	emp_name	dept_id	salary
1	Alice	10	9000.00
2	Bob	10	12000.00
3	Charlie	20	8000.00
4	Diana	20	8000.00
5	Evan	30	7000.00

Departments

dept_id	dept_name
10	Sales
20	IT
30	HR
✅ Expected Output:
dept_name	emp_name	salary
Sales	Bob	12000.00
IT	Charlie	8000.00
IT	Diana	8000.00
HR	Evan	7000.00
✅ MySQL Answer:
*/

WITH DeptSalary AS (
    SELECT 
        e.emp_id,
        e.emp_name,
        e.dept_id,
        e.salary,
        RANK() OVER (PARTITION BY e.dept_id ORDER BY e.salary DESC) AS rnk
    FROM Employees e
)
SELECT 
    d.dept_name,
    ds.emp_name,
    ds.salary
FROM DeptSalary ds
JOIN Departments d ON ds.dept_id = d.dept_id
WHERE ds.rnk = 1;
