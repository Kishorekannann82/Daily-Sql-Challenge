/*
📌 Challenge 2.0 — Day 55: "Rolling Retention — Users Active in Consecutive Weeks"

Scenario:
You're a Data Analyst at a productivity app. Growth tracks week-over-week retention: of the users active in a given week, what % were also active in the very next week? Unlike cohort retention (Day 6), this looks at all active users each week, not a signup cohort. It's the "stickiness" metric leadership watches on a dashboard.

Table: activity

Column	Type
user_id	INT
activity_date	DATE

(Multiple rows per user per day are possible.)

Task: For each week, output week_start, active_users, retained_next_week, retention_rate, where retained_next_week = users active that week who were also active the following week.
*/
WITH weekly_active AS (
    SELECT DISTINCT
        user_id,
        DATE_TRUNC('week', activity_date) AS week_start
    FROM activity
),
with_next AS (
    SELECT 
        w1.week_start,
        w1.user_id,
        CASE WHEN w2.user_id IS NOT NULL THEN 1 ELSE 0 END AS retained
    FROM weekly_active w1
    LEFT JOIN weekly_active w2 
        ON w1.user_id = w2.user_id
        AND w2.week_start = w1.week_start + INTERVAL '7 days'
)
SELECT 
    week_start,
    COUNT(*) AS active_users,
    SUM(retained) AS retained_next_week,
    ROUND(SUM(retained) * 100.0 / COUNT(*), 2) AS retention_rate
FROM with_next
GROUP BY week_start
ORDER BY week_start;
