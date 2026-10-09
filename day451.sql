/*
📌 Challenge 2.0 — Day 56: “Order Fulfillment Bottleneck: Time Spent in Each Stage”

Scenario:
You’re a Data Analyst at an e-commerce company. Every order moves through stages: placed → packed → shipped → delivered, and each transition is logged as an event. Ops wants to find the bottleneck stage: the average time orders spend in each stage, plus the 90th percentile (since averages hide the slow tail).

Table: order_events

Column	Type
event_id	INT
order_id	INT
stage	VARCHAR
event_time	TIMESTAMP

(Each order has one row per stage it has reached. Orders still in progress won’t have later stages.)

Task: For each stage, calculate the time spent in that stage (from entering it until entering the next one). Output stage, orders_measured, avg_hours, p90_hours, max_hours. Exclude the final delivered stage, since there’s no next stage to measure against.
*/
WITH stage_durations AS (
    SELECT 
        order_id,
        stage,
        EXTRACT(EPOCH FROM (
            LEAD(event_time) OVER (PARTITION BY order_id ORDER BY event_time) - event_time
        )) / 3600.0 AS hours_in_stage
    FROM order_events
)
SELECT 
    stage,
    COUNT(hours_in_stage) AS orders_measured,
    ROUND(AVG(hours_in_stage), 2) AS avg_hours,
    ROUND(
        PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY hours_in_stage)::numeric, 2
    ) AS p90_hours,
    ROUND(MAX(hours_in_stage), 2) AS max_hours
FROM stage_durations
WHERE hours_in_stage IS NOT NULL      -- drops each order's last logged stage (no next event)
  AND stage <> 'delivered'
GROUP BY stage
ORDER BY avg_hours DESC;
