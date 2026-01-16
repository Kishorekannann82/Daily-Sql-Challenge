/*
Detect Drawdown Periods and Maximum Drawdown
Scenario

You track a portfolio’s daily value.
A drawdown is a period where the portfolio falls from a previous peak and hasn’t yet recovered to that peak.

portfolio_values

trade_date	portfolio_value
2024-01-01	1000
2024-01-02	1050
2024-01-03	1020
2024-01-04	980
2024-01-05	990
2024-01-06	1100
2024-01-07	1080
2024-01-08	1030
2024-01-09	1010
2024-01-10	1150
📌 Definitions

Peak: Highest value seen so far

Drawdown: portfolio_value < running_peak

Drawdown depth: (running_peak - portfolio_value)

Drawdown period: from peak until recovery back to peak

❓ Goal

1️⃣ Identify drawdown periods
2️⃣ Compute max drawdown depth per period
3️⃣ Show start date, end date, and max drawdown

✅ Expected SQL Answer

(Works in PostgreSQL / MySQL 8+ / SQL Server)
*/
WITH running_peak AS (
    SELECT
        trade_date,
        portfolio_value,
        MAX(portfolio_value) OVER (
            ORDER BY trade_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS peak_value
    FROM portfolio_values
),
drawdown_flag AS (
    SELECT
        trade_date,
        portfolio_value,
        peak_value,
        peak_value - portfolio_value AS drawdown_amount,
        CASE
            WHEN portfolio_value < peak_value THEN 1
            ELSE 0
        END AS in_drawdown
    FROM running_peak
),
groups AS (
    SELECT
        *,
        SUM(
            CASE
                WHEN in_drawdown = 0 THEN 1
                ELSE 0
            END
        ) OVER (
            ORDER BY trade_date
        ) AS drawdown_group
    FROM drawdown_flag
),
summary AS (
    SELECT
        drawdown_group,
        MIN(trade_date) AS drawdown_start,
        MAX(trade_date) AS drawdown_end,
        MAX(drawdown_amount) AS max_drawdown
    FROM groups
    WHERE in_drawdown = 1
    GROUP BY drawdown_group
)
SELECT *
FROM summary
ORDER BY drawdown_start;