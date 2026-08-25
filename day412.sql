/*
📌 Challenge 2.0 — Day 18: "Rank-Based Salary Band Assignment with Percentiles"

Scenario:
You're a Data Analyst at an HR consulting firm. The comp team wants to assign every employee to a salary band (Bottom 25%, Mid-Low 25-50%, Mid-High 50-75%, Top 25%) within their own department — this is used to flag employees for raise reviews if they're in the bottom band despite being top performers.

Table: employees

Column	Type
employee_id	INT
name	VARCHAR
department	VARCHAR
salary	DECIMAL

Task: Assign each employee to a quartile-based salary_band within their department, using percentile rank logic (not simple row-count buckets, since departments have different headcounts). Output employee_id, name, department, salary, percentile_rank, salary_band.
*/
WITH ranked AS (
    SELECT 
        employee_id,
        name,
        department,
        salary,
        PERCENT_RANK() OVER (
            PARTITION BY department 
            ORDER BY salary
        ) AS percentile_rank
    FROM employees
)
SELECT 
    employee_id,
    name,
    department,
    salary,
    ROUND(percentile_rank * 100, 1) AS percentile_rank,
    CASE 
        WHEN percentile_rank < 0.25 THEN 'Bottom 25%'
        WHEN percentile_rank < 0.50 THEN 'Mid-Low 25-50%'
        WHEN percentile_rank < 0.75 THEN 'Mid-High 50-75%'
        ELSE 'Top 25%'
    END AS salary_band
FROM ranked
ORDER BY department, salary DESC;
