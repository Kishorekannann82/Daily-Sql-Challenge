/*
📌 Challenge 2.0 — Day 43: "Detecting Bot-Like Behavior — Uniform Time Intervals"

Scenario:
You're a Data Analyst at a ticketing platform. Security suspects bots are scraping/hammering the API — a hallmark sign is requests arriving at suspiciously uniform intervals (real humans have naturally variable click timing; scripts often fire at exact or near-exact fixed intervals). Flag any user whose request timing shows very low variance.

Table: api_requests

Column	Type
request_id	INT
user_id	INT
request_time	TIMESTAMP

Task: For each user with 10 or more requests in the data, calculate the time gaps between consecutive requests, then compute the standard deviation of those gaps (in seconds). Flag users as 'Suspected Bot' if their gap standard deviation is less than 2 seconds (very uniform = suspicious) AND they have at least 10 requests. Output user_id, request_count, avg_gap_seconds, stddev_gap_seconds, flag.
*/
WITH ordered_requests AS (
    SELECT 
        user_id,
        request_time,
        LAG(request_time) OVER (
            PARTITION BY user_id ORDER BY request_time
        ) AS prev_request_time
    FROM api_requests
),
gaps AS (
    SELECT 
        user_id,
        EXTRACT(EPOCH FROM (request_time - prev_request_time)) AS gap_seconds
    FROM ordered_requests
    WHERE prev_request_time IS NOT NULL   -- first request per user has no gap
),
user_stats AS (
    SELECT 
        user_id,
        COUNT(*) + 1 AS request_count,      -- +1 to account for the first request excluded from gaps
        AVG(gap_seconds) AS avg_gap_seconds,
        STDDEV(gap_seconds) AS stddev_gap_seconds
    FROM gaps
    GROUP BY user_id
)
SELECT 
    user_id,
    request_count,
    ROUND(avg_gap_seconds, 3) AS avg_gap_seconds,
    ROUND(stddev_gap_seconds, 3) AS stddev_gap_seconds,
    CASE 
        WHEN request_count >= 10 AND stddev_gap_seconds < 2 
        THEN 'Suspected Bot'
        ELSE 'Normal'
    END AS flag
FROM user_stats
ORDER BY stddev_gap_seconds ASC;
