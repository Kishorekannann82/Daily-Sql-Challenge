/*
🧠 Challenge: Find Duplicate Records
🗃️ Table:
Employees (
  emp_id INT,
  emp_name VARCHAR(50),
  department VARCHAR(50),
  salary DECIMAL(10,2)
)

🎯 Task:

Find duplicate employee records based on name + department.

✅ Example Data:
emp_id	emp_name	department	salary
1	Alice	HR	8000.00
2	Bob	IT	6000.00
3	Alice	HR	7500.00
4	Charlie	IT	9000.00
5	Alice	Finance	7000.00
✅ Expected Output:
emp_name	department	duplicate_count
Alice	HR	2
✅ MySQL Answer:
*/

SELECT 
    emp_name,
    department,
    COUNT(*) AS duplicate_count
FROM Employees
GROUP BY emp_name, department
HAVING COUNT(*) > 1;