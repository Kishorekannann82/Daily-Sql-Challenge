/*
📌 Challenge 2.0 — Day 45: "Load Balancer Analysis — Server Request Distribution Fairness"

Scenario:
You're a Data Analyst at an infra team. Requests are routed across servers by a load balancer. Ops suspects the balancer is not distributing traffic fairly — some servers are getting hammered while others sit idle. They want a per-minute breakdown showing the coefficient of variation (stddev/mean) of request counts across servers, flagging minutes where distribution was significantly unbalanced.

Table: requests

Column	Type
request_id	INT
server_id	INT
request_time	TIMESTAMP

Task: For each 1-minute window, calculate the request count per server, then the coefficient of variation (CV = stddev / mean) across all servers active in that minute. Flag minutes as 'Imbalanced' where CV > 0.5. Output minute_bucket, active_servers, avg_requests_per_server, stddev_requests, cv, flag.
*/
WITH minute_buckets AS (
    SELECT 
        server_id,
        DATE_TRUNC('minute', request_time) AS minute_bucket,
        COUNT(*) AS requests_this_minute
    FROM requests
    GROUP BY server_id, DATE_TRUNC('minute', request_time)
),
minute_stats AS (
    SELECT 
        minute_bucket,
        COUNT(DISTINCT server_id) AS active_servers,
        AVG(requests_this_minute) AS avg_requests_per_server,
        STDDEV(requests_this_minute) AS stddev_requests
    FROM minute_buckets
    GROUP BY minute_bucket
)
SELECT 
    minute_bucket,
    active_servers,
    ROUND(avg_requests_per_server, 2) AS avg_requests_per_server,
    ROUND(stddev_requests, 2) AS stddev_requests,
    ROUND(stddev_requests / NULLIF(avg_requests_per_server, 0), 3) AS cv,
    CASE 
        WHEN active_servers >= 2 
             AND (stddev_requests / NULLIF(avg_requests_per_server, 0)) > 0.5 
        THEN 'Imbalanced'
        ELSE 'Balanced'
    END AS flag
FROM minute_stats
ORDER BY minute_bucket;
