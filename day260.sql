
*/
Sessionize User Activity With Gap & Reset Logic
Scenario

You have user activity logs:

user_events

user_id	event_time
101	2024-01-01 10:00:00
101	2024-01-01 10:15:00
101	2024-01-01 11:00:00
101	2024-01-01 14:00:00
102	2024-01-03 13:00:00
102	2024-01-03 13:40:00
102	2024-01-03 15:10:00
103	2024-01-04 09:00:00

📌 Rule:

Events belong to the same session if gap < 30 minutes

Otherwise, start a new session

❓Question:

Create sessions per user and return:

user_id

session_id

session_start

session_end

event_count

session_duration_minutes

✅ Expected SQL Answer
*/

(Works in MySQL 8+, Postgres, SQL Server)

WITH ordered_events AS (
    SELECT
        user_id,
        event_time,
        LAG(event_time) OVER (
            PARTITION BY user_id
            ORDER BY event_time
        ) AS prev_event_time
    FROM user_events
),
session_flags AS (
    SELECT
        user_id,
        event_time,
        CASE
            WHEN prev_event_time IS NULL THEN 1
            WHEN TIMESTAMPDIFF(MINUTE, prev_event_time, event_time) > 30 THEN 1
            ELSE 0
        END AS new_session_flag
    FROM ordered_events
),
session_groups AS (
    SELECT
        user_id,
        event_time,
        SUM(new_session_flag) OVER (
            PARTITION BY user_id ORDER BY event_time
        ) AS session_id
    FROM session_flags
),
session_info AS (
    SELECT
        user_id,
        session_id,
        MIN(event_time) AS session_start,
        MAX(event_time) AS session_end,
        COUNT(*) AS event_count,
        TIMESTAMPDIFF(MINUTE, MIN(event_time), MAX(event_time)) AS session_duration_minutes
    FROM session_groups
    GROUP BY user_id, session_id
)
SELECT *
FROM session_info
ORDER BY user_id, session_id;