/*
Scenario:
You have an employee hierarchy table called employees:

emp_id	emp_name	manager_id
1	Alice	NULL
2	Bob	1
3	Charlie	1
4	David	2
5	Eva	2
6	Frank	4
❓Question:

Write a SQL query to find:

each employee’s level in the organization (CEO = level 1, their direct reports = level 2, and so on),

and the maximum depth of the hierarchy in the company.

Return:

emp_id

emp_name

manager_id

level

And also show the maximum level (hierarchy depth).
/*

✅ Expected Answer (SQL Solution)
WITH RECURSIVE hierarchy AS (
    -- Base level: CEO(s)
    SELECT 
        emp_id,
        emp_name,
        manager_id,
        1 AS level
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive step: find direct reports
    SELECT 
        e.emp_id,
        e.emp_name,
        e.manager_id,
        h.level + 1 AS level
    FROM employees e
    INNER JOIN hierarchy h ON e.manager_id = h.emp_id
)
SELECT 
    emp_id,
    emp_name,
    manager_id,
    level
FROM hierarchy
ORDER BY level, emp_id;

-- To find overall hierarchy depth:
SELECT MAX(level) AS max_depth FROM hierarchy;