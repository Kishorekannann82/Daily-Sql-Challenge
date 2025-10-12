-- Question: Find the top 3 departments with the highest average salary, 
-- but only include departments where more than 5 employees work.
-- Assume you have a table 'employees' with columns: id, name, salary, department_id
-- and a table 'departments' with columns: id, department_name

SELECT d.department_name, AVG(e.salary) AS avg_salary, COUNT(e.id) AS employee_count
FROM employees e
JOIN departments d ON e.department_id = d.id
GROUP BY d.department_name
HAVING COUNT(e.id) > 5
ORDER BY avg_salary DESC
LIMIT 3;

-- Answer: This query will return the department names, their average salary, and employee count
-- for the top 3 departments (with more than 5 employees) ranked by average salary.