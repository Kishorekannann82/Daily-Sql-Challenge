/*
Event Funnel Analysis & Drop-Off Detection
Scenario

You track users moving through a product funnel:

1️⃣ VISIT
2️⃣ SIGNUP
3️⃣ ADD_TO_CART
4️⃣ PURCHASE

events

user_id	event_name	event_time
101	VISIT	2024-01-01 10:00
101	SIGNUP	2024-01-01 10:05
101	ADD_TO_CART	2024-01-01 10:20
101	PURCHASE	2024-01-01 10:30
102	VISIT	2024-01-01 11:00
102	SIGNUP	2024-01-01 11:10
103	VISIT	2024-01-01 12:00
103	SIGNUP	2024-01-01 12:05
103	ADD_TO_CART	2024-01-01 12:30
104	VISIT	2024-01-01 13:00

📌 Rules

Funnel must be followed in order

A user can drop off at any step

Count distinct users per step

Compute conversion rate from previous step

❓ Goal

Produce a funnel report with:

step_name

users_at_step

conversion_rate_from_previous

✅ Expected SQL Answer

(Works in Postgres / MySQL 8+ / SQL Server)
*/

WITH ordered AS (
    SELECT
        user_id,
        event_name,
        event_time,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY event_time
        ) AS step_order
    FROM events
),
funnel AS (
    SELECT DISTINCT user_id, event_name
    FROM ordered
),
step_counts AS (
    SELECT
        event_name AS step_name,
        COUNT(DISTINCT user_id) AS users_at_step
    FROM funnel
    GROUP BY event_name
),
ranked_steps AS (
    SELECT
        step_name,
        users_at_step,
        LAG(users_at_step) OVER (
            ORDER BY 
            CASE step_name
                WHEN 'VISIT' THEN 1
                WHEN 'SIGNUP' THEN 2
                WHEN 'ADD_TO_CART' THEN 3
                WHEN 'PURCHASE' THEN 4
            END
        ) AS prev_users
    FROM step_counts
)
SELECT
    step_name,
    users_at_step,
    CASE
        WHEN prev_users IS NULL THEN 1.00
        ELSE ROUND(users_at_step * 1.0 / prev_users, 2)
    END AS conversion_rate_from_previous
FROM ranked_steps
ORDER BY
    CASE step_name
        WHEN 'VISIT' THEN 1
        WHEN 'SIGNUP' THEN 2
        WHEN 'ADD_TO_CART' THEN 3
        WHEN 'PURCHASE' THEN 4
    END;

