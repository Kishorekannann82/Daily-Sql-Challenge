/*
Find employees absent for 3 or more consecutive days
You work in HR analytics at a large company. The compliance team wants to flag employees who were absent for 3 or more consecutive working days — these need a manager follow-up. Return employee_name, absent_from, absent_to, and consecutive_days.
Table: attendance
att_id	employee_name	work_date	status
1	Kiran	2024-06-03	absent
2	Kiran	2024-06-04	absent
3	Kiran	2024-06-05	absent
4	Kiran	2024-06-06	present
5	Kiran	2024-06-07	absent
6	Meena	2024-06-03	absent
7	Meena	2024-06-04	present
8	Meena	2024-06-05	absent
9	Meena	2024-06-06	absent
10	Ravi	2024-06-03	absent
11	Ravi	2024-06-04	absent
12	Ravi	2024-06-05	absent
13	Ravi	2024-06-06	absent
14	Ravi	2024-06-07	present
Expected output
employee_name	absent_from	absent_to	consecutive_days
Kiran	2024-06-03	2024-06-05	3
Ravi	2024-06-03	2024-06-06	4
Kiran → absent Jun3,4,5 (3 days ✅) then present Jun6 breaks streak → Jun7 absent alone (1 day ❌)
Meena → Jun3 absent (1), Jun4 present breaks → Jun5,6 absent (2 days ❌ not enough)
Ravi → absent Jun3,4,5,6 (4 days ✅) then present Jun7 breaks streak
*/
WITH absent_only AS (
  SELECT
    employee_name,
    work_date,
    work_date - CAST(
      ROW_NUMBER() OVER (
        PARTITION BY employee_name
        ORDER BY work_date
      ) AS INT
    ) AS grp
  FROM attendance
  WHERE status = 'absent'
),
streaks AS (
  SELECT
    employee_name,
    MIN(work_date) AS absent_from,
    MAX(work_date) AS absent_to,
    COUNT(*)       AS consecutive_days
  FROM absent_only
  GROUP BY employee_name, grp
)
SELECT
  employee_name,
  absent_from,
  absent_to,
  consecutive_days
FROM streaks
WHERE consecutive_days >= 3
ORDER BY employee_name;
