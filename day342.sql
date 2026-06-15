/*
Find each user's longest daily login streak
You work at an OTT platform like Hotstar. The engagement team wants to find the longest consecutive daily login streak for each user — to award streak badges (3-day 🔥, 7-day 💎, 30-day 🏆). Return user_id and longest_streak.
Table: logins
login_id	user_id	login_date
1	U01	2024-01-01
2	U01	2024-01-02
3	U01	2024-01-03
4	U01	2024-01-05
5	U01	2024-01-06
6	U01	2024-01-07
7	U01	2024-01-08
8	U02	2024-01-01
9	U02	2024-01-02
10	U02	2024-01-04
11	U02	2024-01-05
12	U02	2024-01-06
13	U03	2024-01-01
14	U03	2024-01-02
15	U03	2024-01-03
16	U03	2024-01-04
17	U03	2024-01-05
Expected output
user_id	longest_streak
U01	4
U02	3
U03	5
U01 → Jan1,2,3 (streak=3) gap on Jan4 → Jan5,6,7,8 (streak=4) → longest = 4 🔥
U02 → Jan1,2 (streak=2) gap on Jan3 → Jan4,5,6 (streak=3) → longest = 3 🔥
U03 → Jan1,2,3,4,5 no gaps → streak = 5 💎
*/
WITH deduped AS (
  -- Remove duplicate logins on same day (user might log in twice)
  SELECT DISTINCT
    user_id,
    login_date
  FROM logins
),
grouped AS (
  SELECT
    user_id,
    login_date,
    login_date - CAST(
      ROW_NUMBER() OVER (
        PARTITION BY user_id
        ORDER BY login_date
      ) AS INT
    ) AS grp
  FROM deduped
),
streak_lengths AS (
  SELECT
    user_id,
    grp,
    COUNT(*) AS streak_len
  FROM grouped
  GROUP BY user_id, grp
)
SELECT
  user_id,
  MAX(streak_len) AS longest_streak
FROM streak_lengths
GROUP BY user_id
ORDER BY user_id;
