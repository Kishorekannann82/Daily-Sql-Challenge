/*
🧠 Challenge: Department-Wise Highest Salary
🗃️ Table:
*/

Employees (
  emp_id INT,
  emp_name VARCHAR(50),
  salary DECIMAL(10,2),
  department VARCHAR(50)
)

/*
🎯 Task:

For each department, find the employee(s) with the highest salary.

✅ Example Data:
emp_id	emp_name	salary	department
1	Alice	8000.00	HR
2	Bob	6000.00	IT
3	Charlie	9000.00	IT
4	David	7000.00	Finance
5	Eva	5000.00	HR
✅ Expected Output:
department	emp_name	salary
HR	Alice	8000.00
IT	Charlie	9000.00
Finance	David	7000.00
*/
--✅ MySQL Answer (using RANK()):
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

--✅ MySQL Answer (using subquery):
SELECT e.department, e.emp_name, e.salary
FROM Employees e
WHERE e.salary = (
    SELECT MAX(salary)
    FROM Employees
    WHERE department = e.department
);