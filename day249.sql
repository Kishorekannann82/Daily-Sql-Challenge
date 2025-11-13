/*
Detect Circular Manager Relationships (Cycle Detection)

Scenario:
You have an employee hierarchy table:

employees

emp_id	emp_name	manager_id
1	Alice	2
2	Bob	3
3	Carol	4
4	David	NULL
5	Eva	6
6	Frank	5

👉 Notice: employees 5 ↔ 6 form a circular reporting relationship (Eva ↔ Frank).

❓Question:

Write a SQL query to detect cycles (where an employee indirectly manages themselves).

Return:

starting_emp_id

cycle_path

✅ Expected Answer (SQL Solution)
*/

WITH RECURSIVE hierarchy_path AS (
    -- Base: start from every employee
    SELECT
        emp_id AS starting_emp_id,
        emp_id,
        manager_id,
        CAST(emp_id AS CHAR(1000)) AS path
    FROM employees

    UNION ALL

    -- Recursive: follow manager chain
    SELECT
        h.starting_emp_id,
        e.emp_id,
        e.manager_id,
        CONCAT(h.path, ' -> ', e.emp_id) AS path
    FROM employees e
    INNER JOIN hierarchy_path h ON e.emp_id = h.manager_id
    WHERE h.path NOT LIKE CONCAT('%', e.emp_id, '%')  -- prevent infinite loop
)
SELECT 
    starting_emp_id,
    path AS cycle_path
FROM hierarchy_path
WHERE manager_id = starting_emp_id
ORDER BY starting_emp_id;