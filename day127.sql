/*
🧠 Challenge: Consecutive Login Streaks
🗃️ Table: UserLogins
*/
UserLogins (
    user_id INT,
    login_date DATE
)

/*
🎯 Your Task:
For each user, find the longest streak of consecutive daily logins.

✅ Expected Output Example:
user_id	longest_streak
1	5
2	3
*/
with rankedLogin as (
    select user_id,
    login_date,
    row_number() over(partition by user_id order by login_date) as rn 
    from UserLogins
),

LoginGroups AS (
  SELECT 
    user_id,
    DATE_SUB(login_date, INTERVAL rn DAY) AS group_date
  FROM RankedLogins
)
SELECT 
  user_id,
  MAX(streak_length) AS longest_streak
FROM (
  SELECT 
    user_id,
    COUNT(*) AS streak_length
  FROM LoginGroups
  GROUP BY user_id, group_date
) AS Streaks
GROUP BY user_id;
