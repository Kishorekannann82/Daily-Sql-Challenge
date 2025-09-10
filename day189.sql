/*
🧠 Challenge: Nth Highest Salary (per company)
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

Find the 2nd highest salary in the company.
(You can generalize it to Nth highest as well).

✅ Example Data:
emp_id	emp_name	salary	department
1	Alice	8000.00	HR
2	Bob	6000.00	IT
3	Charlie	9000.00	IT
4	David	7000.00	Finance
5	Eva	5000.00	HR
✅ Expected Output (2nd highest salary):
salary
8000.00
*/

 -- ✅ MySQL Answer (using LIMIT + OFFSET):
SELECT DISTINCT salary
FROM Employees
ORDER BY salary DESC
LIMIT 1 OFFSET 1;