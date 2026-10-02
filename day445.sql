/*
📌 Challenge 2.0 — Day 50: "Service Level Agreement (SLA) Compliance with Business Hours"

Scenario:
You're a Data Analyst at a support software company. SLA compliance requires tickets to get a first response within 4 business hours (9 AM–6 PM, Mon–Fri, excluding weekends — ignore holidays for simplicity). A naive timestamp subtraction wrongly penalizes tickets submitted Friday evening that get a prompt Monday morning response.

Table: tickets

Column	Type
ticket_id	INT
created_at	TIMESTAMP
first_response_at	TIMESTAMP (NULL if no response yet)

Task: Calculate the business-hours elapsed between created_at and first_response_at for each ticket (counting only 9 AM–6 PM, Mon–Fri), and flag sla_breached if that exceeds 4 hours. Output ticket_id, created_at, first_response_at, business_hours_elapsed, sla_breached.
*/
WITH RECURSIVE business_days AS (
    -- Generate one row per calendar day between created_at and first_response_at
    SELECT 
        t.ticket_id,
        t.created_at,
        t.first_response_at,
        DATE_TRUNC('day', t.created_at) AS day
    FROM tickets t
    WHERE t.first_response_at IS NOT NULL

    UNION ALL

    SELECT 
        ticket_id,
        created_at,
        first_response_at,
        day + INTERVAL '1 day'
    FROM business_days
    WHERE day + INTERVAL '1 day' <= DATE_TRUNC('day', first_response_at)
),
daily_business_window AS (
    -- For each day touched by the ticket, compute that day's effective 9-6 window,
    -- clipped by the ticket's actual created_at/first_response_at boundaries
    SELECT 
        ticket_id,
        created_at,
        first_response_at,
        day,
        GREATEST(day + INTERVAL '9 hours', created_at) AS window_start,
        LEAST(day + INTERVAL '18 hours', first_response_at) AS window_end
    FROM business_days
    WHERE EXTRACT(ISODOW FROM day) BETWEEN 1 AND 5   -- Mon(1)-Fri(5) only
),
daily_hours AS (
    SELECT 
        ticket_id,
        created_at,
        first_response_at,
        GREATEST(
            EXTRACT(EPOCH FROM (window_end - window_start)) / 3600.0, 
            0
        ) AS hours_this_day
    FROM daily_business_window
    WHERE window_end > window_start   -- skip days with no actual overlap (e.g., ticket created after 6PM)
)
SELECT 
    ticket_id,
    MAX(created_at) AS created_at,
    MAX(first_response_at) AS first_response_at,
    ROUND(SUM(hours_this_day), 2) AS business_hours_elapsed,
    CASE 
        WHEN SUM(hours_this_day) > 4 THEN 'YES'
        ELSE 'NO'
    END AS sla_breached
FROM daily_hours
GROUP BY ticket_id
ORDER BY ticket_id;
