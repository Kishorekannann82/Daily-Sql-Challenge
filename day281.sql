/*
Find Overlapping Sessions per User
Scenario

You track user sessions with start and end times.

sessions

user_id	session_id	start_time	end_time
101	A	2024-01-01 10:00	2024-01-01 11:00
101	B	2024-01-01 10:30	2024-01-01 11:30
101	C	2024-01-01 12:00	2024-01-01 13:00
102	D	2024-01-02 09:00	2024-01-02 10:00
102	E	2024-01-02 10:00	2024-01-02 11:00
103	F	2024-01-03 14:00	2024-01-03 15:00
103	G	2024-01-03 14:30	2024-01-03 14:45

📌 Definition
Two sessions overlap if:

start_time < previous_end_time


(Back-to-back sessions where end_time = start_time do NOT overlap.)

❓ Goal

Identify overlapping session pairs for each user.

Return:

user_id

session_id

overlapping_with_session

overlap_start

overlap_end

✅ Expected SQL Answer

(Works in MySQL 8+, Postgres, SQL Server)
*/

WITH ordered AS (
    SELECT
        user_id,
        session_id,
        start_time,
        end_time,
        LAG(session_id) OVER (
            PARTITION BY user_id
            ORDER BY start_time
        ) AS prev_session_id,
        LAG(start_time) OVER (
            PARTITION BY user_id
            ORDER BY start_time
        ) AS prev_start,
        LAG(end_time) OVER (
            PARTITION BY user_id
            ORDER BY start_time
        ) AS prev_end
    FROM sessions
)
SELECT
    user_id,
    session_id,
    prev_session_id AS overlapping_with_session,
    GREATEST(start_time, prev_start) AS overlap_start,
    LEAST(end_time, prev_end) AS overlap_end
FROM ordered
WHERE prev_end IS NOT NULL
  AND start_time < prev_end
ORDER BY user_id, overlap_start;