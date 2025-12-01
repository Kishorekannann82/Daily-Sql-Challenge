/*
Build Monthly Retention Cohorts
Scenario

You track user signups and monthly activity:

users

user_id	signup_date
1	2024-01-10
2	2024-01-20
3	2024-02-05
4	2024-02-12
5	2024-03-01

activity

user_id	activity_date
1	2024-01-15
1	2024-02-10
1	2024-03-09
2	2024-01-25
2	2024-03-12
3	2024-02-18
3	2024-03-20
4	2024-02-16
5	2024-03-10
Goal

Build a cohort table showing:

Cohort month = signup month

For each activity month, count retained users

Define retention age:

retention_month = months between activity_date & signup_date

Final Output Example
cohort_month	retention_month	retained_users
2024-01	0	2
2024-01	1	1
2024-01	2	1
2024-02	0	2
2024-02	1	2
2024-03	0	1
✅ Expected SQL Solution
*/

(Works on MySQL 8+, Postgres, SQL Server)

WITH signup AS (
    SELECT
        user_id,
        DATE_FORMAT(signup_date, '%Y-%m') AS cohort_month
    FROM users
),
user_activity AS (
    SELECT
        a.user_id,
        DATE_FORMAT(a.activity_date, '%Y-%m') AS activity_month,
        DATE_FORMAT(u.signup_date, '%Y-%m') AS cohort_month,
        TIMESTAMPDIFF(
            MONTH,
            DATE_FORMAT(u.signup_date, '%Y-%m-01'),
            DATE_FORMAT(a.activity_date, '%Y-%m-01')
        ) AS retention_month
    FROM activity a
    JOIN users u ON a.user_id = u.user_id
)
SELECT
    cohort_month,
    retention_month,
    COUNT(DISTINCT user_id) AS retained_users
FROM user_activity
GROUP BY cohort_month, retention_month
ORDER BY cohort_month, retention_month;