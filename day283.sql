/*
Find Peak Concurrent Sessions
Scenario

You log user sessions with login & logout times.

sessions

user_id	login_time	logout_time
101	2024-01-01 10:00	2024-01-01 11:00
102	2024-01-01 10:15	2024-01-01 10:45
103	2024-01-01 10:30	2024-01-01 12:00
104	2024-01-01 11:00	2024-01-01 12:30
105	2024-01-01 11:15	2024-01-01 11:45

📌 Definition

A user is considered online in [login_time, logout_time)

Logout time is exclusive

We want to find maximum concurrent users and when it happened

❓ Goal

Return:

peak_concurrent_users

peak_start_time

peak_end_time

✅ Expected SQL Answer

(Works in Postgres / MySQL 8+ / SQL Server)
*/

WITH events AS (
    SELECT login_time AS event_time, +1 AS delta FROM sessions
    UNION ALL
    SELECT logout_time AS event_time, -1 AS delta FROM sessions
),
running AS (
    SELECT
        event_time,
        SUM(delta) OVER (
            ORDER BY event_time
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS concurrent_users
    FROM events
),
with_next AS (
    SELECT
        event_time,
        concurrent_users,
        LEAD(event_time) OVER (ORDER BY event_time) AS next_event_time
    FROM running
)
SELECT
    MAX(concurrent_users) AS peak_concurrent_users,
    MIN(event_time) FILTER (
        WHERE concurrent_users = (
            SELECT MAX(concurrent_users) FROM running
        )
    ) AS peak_start_time,
    MAX(next_event_time) FILTER (
        WHERE concurrent_users = (
            SELECT MAX(concurrent_users) FROM running
        )
    ) AS peak_end_time
FROM with_next;