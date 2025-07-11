/*
🧠 Challenge: User Retention Analysis
🗃️ Table: UserLogins
*/
UserLogins (
    user_id INT,
    login_date DATE
)
/*
🎯 Your Task:
For each user’s first login month, find:

The month they first logged in.

How many distinct months they returned afterward (including their first month).

Report for each user:

user_id

first_login_month (in 'YYYY-MM' format)

retention_months → how many distinct months they logged in starting from their first month.
*/
WITH FirstLogin AS (
  SELECT 
    user_id,
    MIN(DATE_FORMAT(login_date, '%Y-%m')) AS first_login_month
  FROM UserLogins
  GROUP BY user_id
)
SELECT 
    u.user_id,
    f.first_login_month,
    COUNT(DISTINCT DATE_FORMAT(u.login_date, '%Y-%m')) AS retention_months
FROM UserLogins u
JOIN FirstLogin f 
  ON u.user_id = f.user_id
WHERE DATE_FORMAT(u.login_date, '%Y-%m') >= f.first_login_month
GROUP BY u.user_id, f.first_login_month;