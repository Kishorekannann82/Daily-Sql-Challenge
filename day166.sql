/*
🧠 Challenge: Second Highest Salary per Department
🗃️ Table: Employees
*/
Employees (
  emp_id INT,
  emp_name VARCHAR(100),
  department_id INT,
  salary DECIMAL(10,2)
);
/*
🎯 Task:

Find the second highest salary in each department.
If a department has fewer than 2 employees, ignore it.
*/
SELECT department_id, salary AS second_highest_salary
FROM (
    SELECT department_id,
           salary,
           DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rnk
    FROM Employees
) t
WHERE rnk = 2;
