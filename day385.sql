/*
Second Highest Salary per Department"

Scenario:
You're working for an HR analytics team. They want to identify the second-highest paid employee in each department — useful for compensation benchmarking and promotion planning.

Table: employees

Column	Type
employee_id	INT
name	VARCHAR
department	VARCHAR
salary	DECIMAL

Task: Output department, name, salary for the employee with the 2nd highest salary in each department. If there's a tie for highest, handle it sensibly (don't just skip duplicates blindly).

✅ Solution
sql
*/
WITH ranked_employees AS (
    SELECT 
        department,
        name,
        salary,
        DENSE_RANK() OVER (
            PARTITION BY department 
            ORDER BY salary DESC
        ) AS salary_rank
    FROM employees
)
SELECT 
    department,
    name,
    salary
FROM ranked_employees
WHERE salary_rank = 2
ORDER BY department;
