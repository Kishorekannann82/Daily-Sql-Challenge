/*
🧠 Challenge: Users With Consecutive Logins
🗃️ Table: UserLogins
*/
UserLogins (
    user_id INT,
    login_date DATE
)
/*
🎯 Your Task:
Find all users who logged in for at least 3 consecutive days.
*/
with rankedLogin as (
    SELECT user_id,
    login_date,
    row_number() over(PARTITION by user_id order by login_date) as rn 
    from UserLogins
),
LoginGroups AS (
  SELECT 
    user_id,
    login_date,
    DATE_SUB(login_date, INTERVAL rn DAY) AS grp
  FROM RankedLogins
),
GroupedConsecutive AS (
  SELECT 
    user_id,
    MIN(login_date) AS start_date,
    MAX(login_date) AS end_date,
    COUNT(*) AS days_logged_in
  FROM LoginGroups
  GROUP BY user_id, grp
)
SELECT 
  user_id,
  start_date,
  end_date,
  days_logged_in
FROM GroupedConsecutive
WHERE days_logged_in >= 3
ORDER BY user_id, start_date;