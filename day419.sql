/*
📌 Challenge 2.0 — Day 25: "Employee Attrition — Tenure Bucket Analysis"

Scenario:
You're a Data Analyst at a corporate HR team. Leadership wants to understand when employees are most likely to leave — specifically, a breakdown of attrition by tenure bucket (0-6 months, 6-12 months, 1-2 years, 2-5 years, 5+ years) to spot if there's a dangerous early-exit pattern or a mid-career cliff.

Table: employees

Column	Type
employee_id	INT
hire_date	DATE
exit_date	DATE (NULL if still employed)

Task: For employees who have left, bucket their tenure (time between hire_date and exit_date) into the ranges above. Output tenure_bucket, employees_left, pct_of_total_attrition — ordered logically by bucket, not alphabetically.
*/
WITH departed AS (
    SELECT 
        employee_id,
        hire_date,
        exit_date,
        (EXTRACT(YEAR FROM exit_date) - EXTRACT(YEAR FROM hire_date)) * 12 
            + (EXTRACT(MONTH FROM exit_date) - EXTRACT(MONTH FROM hire_date)) AS tenure_months
    FROM employees
    WHERE exit_date IS NOT NULL
),
bucketed AS (
    SELECT 
        employee_id,
        CASE 
            WHEN tenure_months < 6 THEN '0-6 months'
            WHEN tenure_months < 12 THEN '6-12 months'
            WHEN tenure_months < 24 THEN '1-2 years'
            WHEN tenure_months < 60 THEN '2-5 years'
            ELSE '5+ years'
        END AS tenure_bucket,
        CASE 
            WHEN tenure_months < 6 THEN 1
            WHEN tenure_months < 12 THEN 2
            WHEN tenure_months < 24 THEN 3
            WHEN tenure_months < 60 THEN 4
            ELSE 5
        END AS bucket_order
    FROM departed
),
total AS (
    SELECT COUNT(*) AS total_attrition FROM departed
)
SELECT 
    b.tenure_bucket,
    COUNT(*) AS employees_left,
    ROUND(COUNT(*) * 100.0 / t.total_attrition, 2) AS pct_of_total_attrition
FROM bucketed b
CROSS JOIN total t
GROUP BY b.tenure_bucket, b.bucket_order, t.total_attrition
ORDER BY b.bucket_order;
