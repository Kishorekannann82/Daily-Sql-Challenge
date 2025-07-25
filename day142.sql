/*
🧠 Challenge: Most Active Users by Day
🗃️ Table: Logins
*/
Logins (
  login_id INT,
  user_id INT,
  login_time DATETIME
)

/*
🎯 Task:
For each day, find the user who had the most logins.
If there’s a tie, return any one of the top users.
*/
WITH DailyLogins AS (
  SELECT 
    user_id,
    DATE(login_time) AS login_date,
    COUNT(*) AS login_count
  FROM Logins
  GROUP BY user_id, login_date
),
RankedLogins AS (
  SELECT *,
         RANK() OVER (PARTITION BY login_date ORDER BY login_count DESC) AS rk
  FROM DailyLogins
)
SELECT login_date, user_id, login_count
FROM RankedLogins
WHERE rk = 1;
