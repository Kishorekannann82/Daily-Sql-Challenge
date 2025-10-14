/*
🧩 Challenge #2: Finding Consecutive Attendance Streaks

Scenario:
You manage an employee attendance tracking system.
You have the table attendance:

emp_id	attend_date
1	2024-03-01
1	2024-03-02
1	2024-03-03
1	2024-03-05
2	2024-03-01
2	2024-03-03
2	2024-03-04
2	2024-03-05
3	2024-03-02
3	2024-03-03
❓Question:

Write a SQL query to find each employee’s longest streak of consecutive attendance days.

Return:

emp_id

longest_streak

✅ Expected Answer (SQL Solution)
*/
WITH ordered_attendance AS (
    SELECT 
        emp_id,
        attend_date,
        attend_date - INTERVAL (ROW_NUMBER() OVER (PARTITION BY emp_id ORDER BY attend_date)) DAY AS grp
    FROM attendance
),
grouped AS (
    SELECT 
        emp_id,
        COUNT(*) AS streak_length,
        MIN(attend_date) AS streak_start,
        MAX(attend_date) AS streak_end
    FROM ordered_attendance
    GROUP BY emp_id, grp
)
SELECT 
    emp_id,
    MAX(streak_length) AS longest_streak
FROM grouped
GROUP BY emp_id
ORDER BY emp_id;