/*
Find Users with Invalid Event Order
Scenario

Users are supposed to follow this strict event order:

CREATED → VERIFIED → ACTIVATED


But due to bugs or bad data, events can arrive out of order.

user_events

user_id	event_name	event_time
101	CREATED	2024-01-01 09:00
101	VERIFIED	2024-01-01 09:10
101	ACTIVATED	2024-01-01 09:20
102	CREATED	2024-01-02 10:00
102	ACTIVATED	2024-01-02 10:05
103	VERIFIED	2024-01-03 11:00
103	CREATED	2024-01-03 11:05
104	CREATED	2024-01-04 12:00
104	VERIFIED	2024-01-04 12:10
104	ACTIVATED	2024-01-04 11:50
📌 Rules

An event is invalid if:

It occurs before a required earlier step

Or a required step is missing entirely

❓ Goal

Detect invalid events and explain why.

Return:

user_id

event_name

event_time

violation_reason

✅ Expected SQL Answer

(Works in MySQL 8+, Postgres, SQL Server)
*/
WITH pivoted AS (
    SELECT
        user_id,
        MIN(CASE WHEN event_name = 'CREATED' THEN event_time END) AS created_time,
        MIN(CASE WHEN event_name = 'VERIFIED' THEN event_time END) AS verified_time,
        MIN(CASE WHEN event_name = 'ACTIVATED' THEN event_time END) AS activated_time
    FROM user_events
    GROUP BY user_id
),
violations AS (
    SELECT
        u.user_id,
        u.event_name,
        u.event_time,
        CASE
            WHEN u.event_name = 'VERIFIED'
                 AND p.created_time IS NULL
                THEN 'VERIFIED before CREATED'
            WHEN u.event_name = 'ACTIVATED'
                 AND p.verified_time IS NULL
                THEN 'ACTIVATED before VERIFIED'
            WHEN u.event_name = 'ACTIVATED'
                 AND u.event_time < p.verified_time
                THEN 'ACTIVATED before VERIFIED time'
            WHEN u.event_name = 'VERIFIED'
                 AND u.event_time < p.created_time
                THEN 'VERIFIED before CREATED time'
            ELSE NULL
        END AS violation_reason
    FROM user_events u
    JOIN pivoted p ON u.user_id = p.user_id
)
SELECT *
FROM violations
WHERE violation_reason IS NOT NULL
ORDER BY user_id, event_time;