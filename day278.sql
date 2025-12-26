/*
Retention & Reactivation Analysis
Scenario

You track user activity by month.

user_activity

user_id	activity_date
101	2024-01-05
101	2024-02-10
101	2024-04-01
102	2024-01-15
102	2024-01-28
102	2024-03-05
103	2024-02-20
103	2024-02-25
104	2024-01-10
104	2024-04-12
📌 Definitions

For each user-month:

New → first month of activity

Retained → active in both current and previous month

Churned → active in previous month but not current month

Reactivated → active this month, inactive in previous month, but active before

❓ Goal

Classify each user’s activity per month into:

NEW

RETAINED

REACTIVATED

Return:

user_id

month (YYYY-MM)

user_status

✅ Expected SQL Answer

(Works in MySQL 8+, Postgres, SQL Server)
*/

WITH monthly_activity AS (
    SELECT DISTINCT
        user_id,
        DATE_FORMAT(activity_date, '%Y-%m') AS month
    FROM user_activity
),
ordered AS (
    SELECT
        user_id,
        month,
        LAG(month) OVER (
            PARTITION BY user_id
            ORDER BY month
        ) AS prev_month
    FROM monthly_activity
),
classified AS (
    SELECT
        user_id,
        month,
        CASE
            WHEN prev_month IS NULL THEN 'NEW'
            WHEN TIMESTAMPDIFF(
                    MONTH,
                    STR_TO_DATE(CONCAT(prev_month, '-01'), '%Y-%m-%d'),
                    STR_TO_DATE(CONCAT(month, '-01'), '%Y-%m-%d')
                 ) = 1
                 THEN 'RETAINED'
            ELSE 'REACTIVATED'
        END AS user_status
    FROM ordered
)
SELECT *
FROM classified
ORDER BY user_id, month;