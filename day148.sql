/*
🧠 Challenge: Most Active Users in a Given Week
🗃️ Table: UserActivity
*/
UserActivity (
  activity_id INT,
  user_id INT,
  activity_date DATE
)
/*
🎯 Task:
Find the top 3 most active users (by number of activities) in each week.

Return:

week_start_date (start of the week, assume weeks start on Monday)

user_id

activity_count
*/
WITH WeeklyActivity AS (
  SELECT 
    user_id,
    DATE_SUB(activity_date, INTERVAL WEEKDAY(activity_date) DAY) AS week_start_date,
    COUNT(*) AS activity_count
  FROM UserActivity
  GROUP BY user_id, week_start_date
),
RankedActivity AS (
  SELECT *,
    ROW_NUMBER() OVER (
      PARTITION BY week_start_date 
      ORDER BY activity_count DESC
    ) AS rank
  FROM WeeklyActivity
)
SELECT 
  week_start_date,
  user_id,
  activity_count
FROM RankedActivity
WHERE rank <= 3;
