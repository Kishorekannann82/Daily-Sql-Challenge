/*
📌 Challenge 2.0 — Day 8: "Employee Manager Hierarchy Depth"

Scenario:
You're a Data Analyst at a large corporation with a multi-level reporting structure. HR wants to know how many levels deep each employee sits in the org chart (CEO = level 0, their direct reports = level 1, and so on), and also wants to flag anyone stuck in a reporting loop (a data quality bug where someone ends up reporting to themselves indirectly).

Table: employees

Column	Type
employee_id	INT
name	VARCHAR
manager_id	INT (nullable, FK to employee_id)

Task: Output employee_id, name, level for every employee, where CEO(s) (manager_id IS NULL) = level 0. If a cycle is detected during traversal, stop expanding that path instead of infinite-looping.
*/
WITH RECURSIVE org_chart AS (
    -- Anchor: top of hierarchy
    SELECT 
        employee_id,
        name,
        manager_id,
        0 AS level,
        CAST(employee_id AS VARCHAR(1000)) AS path
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive step: find direct reports of everyone in current level
    SELECT 
        e.employee_id,
        e.name,
        e.manager_id,
        oc.level + 1,
        oc.path || ',' || CAST(e.employee_id AS VARCHAR)
    FROM employees e
    JOIN org_chart oc 
        ON e.manager_id = oc.employee_id
    WHERE oc.path NOT LIKE '%' || CAST(e.employee_id AS VARCHAR) || '%'  -- cycle guard
)
SELECT 
    employee_id,
    name,
    level
FROM org_chart
ORDER BY level, employee_id;
