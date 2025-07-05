/*
🧠 Challenge: Longest Streak of Consecutive Days with Activity per User
🗃️ Table: UserActivity
*/
UserActivity (
    user_id INT,
    activity_date DATE
)
/*
🎯 Your Task:
For each user, find the longest streak of consecutive days where they had activity (i.e., logged in or performed an action).
*/
WITH NumberedActivity AS (
  SELECT 
    user_id,
    activity_date,
    ROW_NUMBER() OVER (
      PARTITION BY user_id 
      ORDER BY activity_date
    ) AS rn
  FROM UserActivity
),
StreakGroups AS (
  SELECT 
    user_id,
    activity_date,
    DATE_SUB(activity_date, INTERVAL rn DAY) AS streak_group
  FROM NumberedActivity
)
SELECT 
  user_id,
  MAX(streak_length) AS longest_streak
FROM (
  SELECT 
    user_id,
    COUNT(*) AS streak_length
  FROM StreakGroups
  GROUP BY user_id, streak_group
) AS StreakCounts
GROUP BY user_id;