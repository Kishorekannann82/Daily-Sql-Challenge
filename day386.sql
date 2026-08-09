/*
"Consecutive Login Streaks"

Scenario:
You work at a fitness app company (like Strava). The product team wants to reward users who log in for at least 3 consecutive days. They need a query to detect these streaks for a gamification badge system.

Table: logins

Column	Type
login_id	INT
user_id	INT
login_date	DATE

(Assume one row per user per day they logged in — no duplicates on the same day.)

Task: Find all users who have a streak of 3 or more consecutive days logged in. Output user_id, streak_start, streak_end, streak_length — for every qualifying streak (a user could have multiple streaks).

✅ Solution
sql
*/
WITH numbered_logins AS (
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
    FROM numbered_logins
),
streaks AS (
    SELECT 
        user_id,
        grp,
        MIN(login_date) AS streak_start,
        MAX(login_date) AS streak_end,
        COUNT(*) AS streak_length
    FROM grouped
    GROUP BY user_id, grp
)
SELECT 
    user_id,
    streak_start,
    streak_end,
    streak_length
FROM streaks
WHERE streak_length >= 3
ORDER BY user_id, streak_start;
