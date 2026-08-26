/*
Multi-Step Funnel Conversion Analysis"

Scenario:
You're a Data Analyst at a SaaS company. Product wants to understand the signup funnel drop-off: users go through signup → email_verified → onboarding_complete → first_project_created. Leadership wants conversion rate at each step, both from the previous step and from the overall starting point.

Table: user_events

Column	Type
user_id	INT
event_name	VARCHAR
event_time	TIMESTAMP

(Assume each user has at most one row per event_name.)

Task: Output step_name, step_order, users_reached, pct_of_previous_step, pct_of_total, respecting that a user must complete steps in order (e.g., someone with onboarding_complete but no email_verified shouldn't count as having passed step 2).
*/
WITH step_order AS (
    SELECT 'signup' AS event_name, 1 AS step_order
    UNION ALL SELECT 'email_verified', 2
    UNION ALL SELECT 'onboarding_complete', 3
    UNION ALL SELECT 'first_project_created', 4
),
user_max_step AS (
    -- For each user, find the highest step they reached CONTIGUOUSLY from step 1
    SELECT 
        ue.user_id,
        MAX(so.step_order) AS max_contiguous_step
    FROM user_events ue
    JOIN step_order so 
        ON ue.event_name = so.event_name
    WHERE NOT EXISTS (
        -- exclude users who skipped an earlier step
        SELECT 1 
        FROM step_order so2
        WHERE so2.step_order < so.step_order
          AND NOT EXISTS (
              SELECT 1 FROM user_events ue2 
              WHERE ue2.user_id = ue.user_id 
                AND ue2.event_name = so2.event_name
          )
    )
    GROUP BY ue.user_id
),
step_counts AS (
    SELECT 
        so.event_name AS step_name,
        so.step_order,
        COUNT(ums.user_id) AS users_reached
    FROM step_order so
    LEFT JOIN user_max_step ums 
        ON ums.max_contiguous_step >= so.step_order
    GROUP BY so.event_name, so.step_order
)
SELECT 
    step_name,
    step_order,
    users_reached,
    ROUND(
        users_reached * 100.0 / NULLIF(LAG(users_reached) OVER (ORDER BY step_order), 0), 
        2
    ) AS pct_of_previous_step,
    ROUND(
        users_reached * 100.0 / NULLIF(FIRST_VALUE(users_reached) OVER (ORDER BY step_order), 0), 
        2
    ) AS pct_of_total
FROM step_counts
ORDER BY step_order;
