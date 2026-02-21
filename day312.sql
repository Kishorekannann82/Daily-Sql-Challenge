/*
Find Consecutive Login Streaks (At Least 3 Days)
📊 Scenario

You track user logins.

logins
user_id	login_date
101	2024-01-01
101	2024-01-02
101	2024-01-03
101	2024-01-05
102	2024-01-01
102	2024-01-03
102	2024-01-04
102	2024-01-05
103	2024-01-10
🎯 Goal

Find users who logged in for at least 3 consecutive days.

Return:

user_id

🧠 Expected Result
user_id
101
102

✔ 101 → Jan 1,2,3 (3 consecutive days)
✔ 102 → Jan 3,4,5 (3 consecutive days)
❌ 103 → only one login

✅ Expected SQL Answer (Gaps & Islands – Medium Version)
*/

WITH ordered AS (
    SELECT
        user_id,
        login_date,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY login_date
        ) AS rn
    FROM logins
),
grouped AS (
    SELECT
        user_id,
        login_date,
        DATE_SUB(login_date, INTERVAL rn DAY) AS grp
    FROM ordered
),
streaks AS (
    SELECT
        user_id,
        COUNT(*) AS streak_length
    FROM grouped
    GROUP BY user_id, grp
)
SELECT DISTINCT user_id
FROM streaks
WHERE streak_length >= 3;