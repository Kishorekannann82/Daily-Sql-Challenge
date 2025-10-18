/*
🧩 Challenge #4: Employee Hierarchy – Find All Subordinates

Scenario:
You have a table called employees that defines reporting relationships.

emp_id	emp_name	manager_id
1	Alice	NULL
2	Bob	1
3	Carol	1
4	David	2
5	Eva	2
6	Frank	3
7	Grace	4
❓Question:

Write a SQL query to list each manager along with all their direct and indirect subordinates.
Return:

manager_id

subordinate_id

💡 Hint: Use a recursive CTE to traverse the hierarchy tree.

✅ Expected Answer (SQL Solution)
*/

WITH RECURSIVE hierarchy AS (
    -- Base case: direct manager-subordinate relationships
    SELECT 
        manager_id,
        emp_id AS subordinate_id
    FROM employees
    WHERE manager_id IS NOT NULL

    UNION ALL

    -- Recursive step: find indirect subordinates
    SELECT 
        h.manager_id,
        e.emp_id AS subordinate_id
    FROM employees e
    INNER JOIN hierarchy h 
        ON e.manager_id = h.subordinate_id
)
SELECT 
    manager_id,
    subordinate_id
FROM hierarchy
ORDER BY manager_id, subordinate_id;