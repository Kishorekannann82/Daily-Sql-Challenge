/*
Detect Missing Dates (Gaps) in Time-Series Data
Scenario

You store daily login data for users, but some days are missing.

user_logins

user_id	login_date
101	2024-01-01
101	2024-01-02
101	2024-01-05
101	2024-01-06
102	2024-01-01
102	2024-01-04
102	2024-01-05
❓ Goal

For each user, find gaps in login activity where one or more days are missing.

Return:

user_id

gap_start_date

gap_end_date

missing_days_count

✅ Expected SQL Answer

(Works in MySQL 8+, Postgres, SQL Server)

*/
WITH ordered AS (
    SELECT
        user_id,
        login_date,
        LAG(login_date) OVER (
            PARTITION BY user_id
            ORDER BY login_date
        ) AS prev_login
    FROM user_logins
),
gaps AS (
    SELECT
        user_id,
        DATE_ADD(prev_login, INTERVAL 1 DAY) AS gap_start_date,
        DATE_SUB(login_date, INTERVAL 1 DAY) AS gap_end_date,
        DATEDIFF(login_date, prev_login) - 1 AS missing_days_count
    FROM ordered
    WHERE prev_login IS NOT NULL
      AND DATEDIFF(login_date, prev_login) > 1
)
SELECT *
FROM gaps
ORDER BY user_id, gap_start_date;