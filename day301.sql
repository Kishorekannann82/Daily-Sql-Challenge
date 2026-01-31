/* 301.
Detect SLA Breach Windows and Recovery Time
Scenario

You monitor system latency.
An SLA breach occurs when latency > 500 ms.
A breach window starts when latency first exceeds SLA and ends when latency returns to normal.

latency_logs

log_time	latency_ms
2024-01-01 10:00	120
2024-01-01 10:05	600
2024-01-01 10:10	650
2024-01-01 10:15	480
2024-01-01 10:20	700
2024-01-01 10:25	750
2024-01-01 10:30	400
📌 Definitions

Breach start → first latency_ms > 500 after being normal

Recovery → first latency_ms ≤ 500 after a breach

A single window may contain multiple consecutive breaches

❓ Goal

Return each breach window with:

breach_start_time

recovery_time

breach_duration_minutes

✅ Expected SQL Answer

(Works in MySQL 8+, Postgres, SQL Server)
*/
WITH flagged AS (
    SELECT
        log_time,
        latency_ms,
        CASE
            WHEN latency_ms > 500 THEN 1
            ELSE 0
        END AS is_breach
    FROM latency_logs
),
ordered AS (
    SELECT
        log_time,
        is_breach,
        LAG(is_breach) OVER (ORDER BY log_time) AS prev_breach
    FROM flagged
),
groups AS (
    SELECT
        log_time,
        is_breach,
        SUM(
            CASE
                WHEN is_breach = 1 AND (prev_breach = 0 OR prev_breach IS NULL)
                    THEN 1
                ELSE 0
            END
        ) OVER (ORDER BY log_time) AS breach_group
    FROM ordered
),
windows AS (
    SELECT
        breach_group,
        MIN(log_time) AS breach_start_time,
        MAX(log_time) AS last_breach_time
    FROM groups
    WHERE is_breach = 1
    GROUP BY breach_group
),
recoveries AS (
    SELECT
        w.breach_group,
        w.breach_start_time,
        MIN(l.log_time) AS recovery_time
    FROM windows w
    JOIN latency_logs l
      ON l.log_time > w.last_breach_time
     AND l.latency_ms <= 500
    GROUP BY w.breach_group, w.breach_start_time
)
SELECT
    breach_start_time,
    recovery_time,
    TIMESTAMPDIFF(MINUTE, breach_start_time, recovery_time) AS breach_duration_minutes
FROM recoveries
ORDER BY breach_start_time;
