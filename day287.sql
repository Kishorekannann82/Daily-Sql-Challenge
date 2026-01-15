/*
Detect SLA Breaches Using Rolling Time Windows
Scenario

You monitor API response times.
An SLA breach occurs if more than 3 slow requests (>500 ms) happen within any rolling 10-minute window per service.

api_logs

service	request_time	response_ms
auth	2024-01-01 10:00:00	120
auth	2024-01-01 10:02:00	650
auth	2024-01-01 10:04:00	700
auth	2024-01-01 10:06:00	800
auth	2024-01-01 10:08:00	300
auth	2024-01-01 10:09:00	900
billing	2024-01-01 11:00:00	200
billing	2024-01-01 11:03:00	550
billing	2024-01-01 11:06:00	600
billing	2024-01-01 11:20:00	700
📌 Rules

Slow request: response_ms > 500

Rolling window: last 10 minutes, inclusive

Breach condition: slow_requests_in_window > 3

❓ Goal

Detect each timestamp where an SLA breach is active.

Return:

service

request_time

slow_requests_last_10_min

sla_breach_flag

✅ Expected SQL Answer

(Works in PostgreSQL / MySQL 8+ / SQL Server)
*/
WITH flagged AS (
    SELECT
        service,
        request_time,
        CASE WHEN response_ms > 500 THEN 1 ELSE 0 END AS is_slow
    FROM api_logs
),
rolling AS (
    SELECT
        f.service,
        f.request_time,
        (
            SELECT SUM(f2.is_slow)
            FROM flagged f2
            WHERE f2.service = f.service
              AND f2.request_time BETWEEN
                  f.request_time - INTERVAL 10 MINUTE
                  AND f.request_time
        ) AS slow_requests_last_10_min
    FROM flagged f
)
SELECT
    service,
    request_time,
    slow_requests_last_10_min,
    CASE
        WHEN slow_requests_last_10_min > 3 THEN 'YES'
        ELSE 'NO'
    END AS sla_breach_flag
FROM rolling
ORDER BY service, request_time;
