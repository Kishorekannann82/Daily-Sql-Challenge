/*
🧠 Challenge: Find Consecutive Days of Activity
🗃️ Table:
*/
UserActivity (
  user_id INT,
  activity_date DATE
)
/*
🎯 Task:

Find all users who logged in for at least 3 consecutive days.
Return the user_id and the starting date of such a streak.
*/
WITH OrderedActivity AS (
    SELECT 
        user_id,
        activity_date,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY activity_date) AS rn
    FROM UserActivity
),
Grouped AS (
    SELECT 
        user_id,
        activity_date,
        DATE_SUB(activity_date, INTERVAL rn DAY) AS grp
    FROM OrderedActivity
)
SELECT 
    user_id,
    MIN(activity_date) AS streak_start
FROM Grouped
GROUP BY user_id, grp
HAVING COUNT(*) >= 3
ORDER BY user_id, streak_start;
