
/*
📌 Challenge 2.0 — Day 59: “Salary Raise Fairness: Gender Pay Gap by Role and Level”

Scenario:
You’re a Data Analyst on an HR analytics team. Leadership wants a pay equity audit: for every job_title and level combination, compare the average salary of different genders and flag combinations where the gap exceeds 5%. Small groups are too noisy to judge, so each gender group needs at least 3 employees in that role/level.

Table: employees

Column	Type
employee_id	INT
job_title	VARCHAR
level	INT
gender	VARCHAR
salary	DECIMAL

Task: For each job_title + level, output job_title, level, avg_salary_f, avg_salary_m, headcount_f, headcount_m, gap_pct (how much lower the lower-paid group’s average is relative to the higher-paid group’s), and flag_gap ('YES' if the gap exceeds 5%). Only include combinations where both groups have at least 3 employees.
*/
WITH group_stats AS (
    SELECT 
        job_title,
        level,
        AVG(CASE WHEN gender = 'F' THEN salary END) AS avg_salary_f,
        AVG(CASE WHEN gender = 'M' THEN salary END) AS avg_salary_m,
        COUNT(CASE WHEN gender = 'F' THEN 1 END)    AS headcount_f,
        COUNT(CASE WHEN gender = 'M' THEN 1 END)    AS headcount_m
    FROM employees
    GROUP BY job_title, level
)
SELECT 
    job_title,
    level,
    ROUND(avg_salary_f, 2) AS avg_salary_f,
    ROUND(avg_salary_m, 2) AS avg_salary_m,
    headcount_f,
    headcount_m,
    ROUND(
        ABS(avg_salary_f - avg_salary_m) * 100.0 
            / GREATEST(avg_salary_f, avg_salary_m), 
        2
    ) AS gap_pct,
    CASE 
        WHEN ABS(avg_salary_f - avg_salary_m) * 100.0 
                 / GREATEST(avg_salary_f, avg_salary_m) > 5 
        THEN 'YES' ELSE 'NO'
    END AS flag_gap
FROM group_stats
WHERE headcount_f >= 3
  AND headcount_m >= 3
ORDER BY gap_pct DESC;
