/*
📌 Challenge 2.0 — Day 53: "Employee Overtime Compliance — Weekly Hour Aggregation Across Shifts"

Scenario:
You're a Data Analyst at a manufacturing plant. Labor law requires overtime pay for any hours beyond 40 in a calendar week (Mon–Sun). Payroll wants a report of total hours worked per employee per week, with overtime hours broken out separately, handling shifts that span midnight (a night-shift worker clocking in at 10 PM and out at 6 AM counts hours toward the day they clocked in, per company policy).

Table: shifts

Column	Type
shift_id	INT
employee_id	INT
clock_in	TIMESTAMP
clock_out	TIMESTAMP

Task: For each employee and week, calculate total_hours, regular_hours (capped at 40), and overtime_hours (anything beyond 40). Output employee_id, week_start, total_hours, regular_hours, overtime_hours.
*/
WITH shift_hours AS (
    SELECT 
        employee_id,
        clock_in,
        clock_out,
        EXTRACT(EPOCH FROM (clock_out - clock_in)) / 3600.0 AS hours_worked,
        -- Week assigned based on the clock_in date, per company policy for midnight-spanning shifts
        DATE_TRUNC('week', clock_in) AS week_start
    FROM shifts
),
weekly_totals AS (
    SELECT 
        employee_id,
        week_start,
        SUM(hours_worked) AS total_hours
    FROM shift_hours
    GROUP BY employee_id, week_start
)
SELECT 
    employee_id,
    week_start,
    ROUND(total_hours, 2) AS total_hours,
    ROUND(LEAST(total_hours, 40), 2) AS regular_hours,
    ROUND(GREATEST(total_hours - 40, 0), 2) AS overtime_hours
FROM weekly_totals
ORDER BY employee_id, week_start;
