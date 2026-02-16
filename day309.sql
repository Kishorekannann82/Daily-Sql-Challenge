/*
📊 Scenario

You track API response times.

api_metrics
log_time	response_ms
2024-01-01 10:00	100
2024-01-01 10:05	120
2024-01-01 10:10	200
2024-01-01 10:15	150
2024-01-01 10:20	300
2024-01-01 10:25	400
2024-01-01 10:30	110
🎯 Goal

For each timestamp compute rolling percentiles over the last 30 minutes:

P10

P50 (median)

P90

Return:

log_time

p10

p50

p90

✅ Expected SQL Answer

(PostgreSQL / SQL Server style using PERCENTILE_CONT)
*/
SELECT
    log_time,
    PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY response_ms)
        OVER (
            ORDER BY log_time
            RANGE BETWEEN INTERVAL '30 minutes' PRECEDING AND CURRENT ROW
        ) AS p10,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY response_ms)
        OVER (
            ORDER BY log_time
            RANGE BETWEEN INTERVAL '30 minutes' PRECEDING AND CURRENT ROW
        ) AS p50,
    PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY response_ms)
        OVER (
            ORDER BY log_time
            RANGE BETWEEN INTERVAL '30 minutes' PRECEDING AND CURRENT ROW
        ) AS p90
FROM api_metrics
ORDER BY log_time;