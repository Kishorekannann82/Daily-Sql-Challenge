/*
"Sessionization Without Explicit Session IDs"

Scenario:
You're a Data Analyst at a news website. Raw pageview logs have no session ID — just timestamps per user. Product wants sessions defined by the industry-standard rule: a new session starts whenever a user is inactive for 30+ minutes. They need session-level metrics for engagement reporting.

Table: pageviews

Column	Type
pageview_id	INT
user_id	INT
page_url	VARCHAR
view_time	TIMESTAMP

Task: Assign a session_id to every pageview (unique per user per session), then output user_id, session_id, session_start, session_end, pageview_count, session_duration_minutes.
*/
WITH ordered_views AS (
    SELECT 
        user_id,
        page_url,
        view_time,
        LAG(view_time) OVER (
            PARTITION BY user_id 
            ORDER BY view_time
        ) AS prev_view_time
    FROM pageviews
),
session_breaks AS (
    SELECT 
        user_id,
        page_url,
        view_time,
        CASE 
            WHEN prev_view_time IS NULL THEN 1
            WHEN view_time > prev_view_time + INTERVAL '30 minutes' THEN 1
            ELSE 0
        END AS is_new_session
    FROM ordered_views
),
sessionized AS (
    SELECT 
        user_id,
        page_url,
        view_time,
        SUM(is_new_session) OVER (
            PARTITION BY user_id 
            ORDER BY view_time
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS session_id
    FROM session_breaks
)
SELECT 
    user_id,
    session_id,
    MIN(view_time) AS session_start,
    MAX(view_time) AS session_end,
    COUNT(*) AS pageview_count,
    ROUND(EXTRACT(EPOCH FROM (MAX(view_time) - MIN(view_time))) / 60.0, 2) AS session_duration_minutes
FROM sessionized
GROUP BY user_id, session_id
ORDER BY user_id, session_id;
