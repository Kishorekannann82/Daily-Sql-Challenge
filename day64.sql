/*
🧠 Challenge: Find Longest Consecutive Login Streak Per User
🗃️ Table: Logins
*/
Logins (
    user_id INT,
    login_date DATE
)

/*
🎯 Your Task:
For each user, find the longest streak of consecutive daily logins.
Return:

user_id

streak_start_date

streak_end_date

streak_length
*/
with SortedLogin as(
    select user_id,
    login_date,
    ROW_NUMBER() over(partition by user_id order by login_date) as rn 
    from Logins 

),
GroupedStreaks as(
    select user_id,login_date,
    datesub(login_date,interval rn day) as streak_group 
    from SortedLogin
),
Streaks AS (
    SELECT
        user_id,
        MIN(login_date) AS streak_start_date,
        MAX(login_date) AS streak_end_date,
        COUNT(*) AS streak_length
    FROM GroupedStreaks
    GROUP BY user_id, streak_group
),
LongestStreak AS (
    SELECT
        user_id,
        streak_start_date,
        streak_end_date,
        streak_length,
        RANK() OVER (PARTITION BY user_id ORDER BY streak_length DESC) AS rnk
    FROM Streaks
)
SELECT
    user_id,
    streak_start_date,
    streak_end_date,
    streak_length
FROM LongestStreak
WHERE rnk = 1;