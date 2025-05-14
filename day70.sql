/*
🧠 Challenge: Find Users Who Logged In 3 Days in a Row
🗃️ Table: UserLogins
*/
UserLogins (
    user_id INT,
    login_date DATE
)
/*
🎯 Your Task:
Find all user_ids who logged in at least 3 consecutive days.

✅ Expected Output:
user_id
101
205
311
*/
WITH ConsecutiveLogins AS (
    SELECT
        user_id,
        login_date,
        LAG(login_date, 1, login_date - INTERVAL '1 day') OVER (PARTITION BY user_id ORDER BY login_date) AS prev_date,
        LAG(login_date, 2, login_date - INTERVAL '2 days') OVER (PARTITION BY user_id ORDER BY login_date) AS prev_prev_date
    FROM
        UserLogins
),
LoginStreaks AS (
    SELECT
        user_id,
        login_date,
        CASE
            WHEN login_date = prev_date + INTERVAL '1 day' AND login_date = prev_prev_date + INTERVAL '2 days' THEN 1
            ELSE 0
        END AS is_consecutive
    FROM
        ConsecutiveLogins
)
SELECT DISTINCT user_id
FROM LoginStreaks
WHERE is_consecutive = 1;