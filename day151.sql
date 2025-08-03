/*
🧠 Challenge: User Retention - Day 1 Retention
🗃️ Table:
*/
UserLogins (
  user_id INT,
  login_date DATE
)
/*
🎯 Task:
Find Day 1 Retention Rate:
For users who logged in for the first time on a given day, check if they returned the next day.

✅ Return:

signup_date

new_users (number of users who signed up that day)

retained_users (those who came back the next day)

retention_rate (as a decimal or percent)
*/
WITH FirstLogins AS (
  SELECT
    user_id,
    MIN(login_date) AS signup_date
  FROM UserLogins
  GROUP BY user_id
),
NextDayLogins AS (
  SELECT
    f.signup_date,
    COUNT(DISTINCT f.user_id) AS new_users,
    COUNT(DISTINCT l.user_id) AS retained_users
  FROM FirstLogins f
  LEFT JOIN UserLogins l 
    ON f.user_id = l.user_id
    AND l.login_date = DATE_ADD(f.signup_date, INTERVAL 1 DAY)
  GROUP BY f.signup_date
)
SELECT 
  signup_date,
  new_users,
  retained_users,
  ROUND(retained_users / new_users, 2) AS retention_rate
FROM NextDayLogins
ORDER BY signup_date;
