/*
Longest Streak of Increasing Values"

Scenario:
You're a Data Analyst at a fitness app. The gamification team wants to reward users who show consistent daily improvement — specifically, they want to find each user's longest streak of consecutive days where step count strictly increased day-over-day.

Table: daily_steps

Column	Type
user_id	INT
activity_date	DATE
step_count	INT

(Assume one row per user per day — no gaps in dates for simplicity, but don't hardcode that assumption if you can avoid it.)

Task: Output user_id, streak_start, streak_end, streak_length — the single longest increasing streak per user (ties broken by earliest streak).
*/
WITH ordered AS (
    SELECT 
        user_id,
        activity_date,
        step_count,
        LAG(step_count) OVER (
            PARTITION BY user_id ORDER BY activity_date
        ) AS prev_steps,
        LAG(activity_date) OVER (
            PARTITION BY user_id ORDER BY activity_date
        ) AS prev_date
    FROM daily_steps
),
flagged AS (
    SELECT 
        user_id,
        activity_date,
        step_count,
        CASE 
            WHEN prev_steps IS NOT NULL 
                 AND step_count > prev_steps 
                 AND activity_date = prev_date + INTERVAL '1 day'
            THEN 0  -- continues the streak
            ELSE 1  -- breaks / starts a new streak
        END AS is_break
    FROM ordered
),
grouped AS (
    SELECT 
        user_id,
        activity_date,
        SUM(is_break) OVER (
            PARTITION BY user_id ORDER BY activity_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS streak_group
    FROM flagged
),
streaks AS (
    SELECT 
        user_id,
        streak_group,
        MIN(activity_date) AS streak_start,
        MAX(activity_date) AS streak_end,
        COUNT(*) AS streak_length
    FROM grouped
    GROUP BY user_id, streak_group
),
ranked AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY user_id 
            ORDER BY streak_length DESC, streak_start ASC
        ) AS rn
    FROM streaks
)
SELECT 
    user_id,
    streak_start,
    streak_end,
    streak_length
FROM ranked
WHERE rn = 1
ORDER BY user_id;
