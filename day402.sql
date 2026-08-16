/*
📌 Challenge 2.0 — Day 9: "Session Duration from Event Logs"

Scenario:
You're a Data Analyst at a mobile gaming company. Raw event logs capture every app_open and app_close action per user, but logging is imperfect — sometimes a close event is missing (app crashed, user force-closed, etc). The product team wants session durations computed cleanly, treating any session missing a close event as ending at its app_open time + 0 minutes (don't let it bleed into the next session).

Table: events

Column	Type
event_id	INT
user_id	INT
event_type	VARCHAR
event_time	TIMESTAMP

Task: Pair up each app_open with its correct next app_close (if one exists before the next app_open), and compute session duration in minutes. Output user_id, session_start, session_end, duration_minutes.
*/
WITH ordered_events AS (
    SELECT 
        user_id,
        event_type,
        event_time,
        ROW_NUMBER() OVER (
            PARTITION BY user_id 
            ORDER BY event_time
        ) AS rn
    FROM events
),
opens AS (
    SELECT 
        user_id,
        event_time AS session_start,
        rn
    FROM ordered_events
    WHERE event_type = 'app_open'
),
closes AS (
    SELECT 
        user_id,
        event_time AS session_end,
        rn
    FROM ordered_events
    WHERE event_type = 'app_close'
),
paired AS (
    SELECT 
        o.user_id,
        o.session_start,
        c.session_end,
        ROW_NUMBER() OVER (
            PARTITION BY o.user_id, o.session_start 
            ORDER BY c.session_end
        ) AS pair_rank
    FROM opens o
    LEFT JOIN closes c
        ON o.user_id = c.user_id
        AND c.session_end > o.session_start
        AND c.rn = (
            SELECT MIN(rn) FROM ordered_events oe2 
            WHERE oe2.user_id = o.user_id 
              AND oe2.event_type = 'app_close' 
              AND oe2.rn > o.rn
        )
)
SELECT 
    user_id,
    session_start,
    session_end,
    COALESCE(
        ROUND(EXTRACT(EPOCH FROM (session_end - session_start)) / 60.0, 2),
        0
    ) AS duration_minutes
FROM paired
WHERE pair_rank = 1
ORDER BY user_id, session_start;
