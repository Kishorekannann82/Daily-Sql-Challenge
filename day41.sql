/*
🧗 Challenge: Find Management Chain (Org Hierarchy)
Scenario:
You're given a table of employees, and each employee reports to a manager. Your goal is to build the reporting chain (who reports to whom, all the way up to the CEO).
Tables:
Employees (
    emp_id INT,
    emp_name VARCHAR(100),
    manager_id INT  -- references emp_id of their manager
)

🎯 Task:
Write a query that, for each employee, returns:
emp_id
emp_name
manager_id
full_chain → a string showing their chain of managers, like:
"CEO > VP > Director > emp_name"
*/
--Query
with recursive EmployeeHierachy as(
    select emp_id,emp_name,manager_id,
    Cast(emp_name as varchar) as full_chain
    from employees
    where manager_id is null 

    union all
    select e.emp_id,e.emp_name,e,manager_id,
    concat(h.full_chain ,'>',e.emp_name) as full_chain
    FROM Employees e
    JOIN EmployeeHierarchy h ON e.manager_id = h.emp_id
)
SELECT 
    emp_id,
    emp_name,
    manager_id,
    full_chain
FROM EmployeeHierarchy
ORDER BY full_chain;
