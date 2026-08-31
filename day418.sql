/*
"Anomaly Detection — Spend Spikes vs Rolling Baseline"

Scenario:
You're a Data Analyst at a fintech company. Risk wants to flag anomalous daily spend per user — a day is "anomalous" if that day's total spend is more than 3x the user's trailing 7-day average (excluding the day itself, so a spike doesn't inflate its own baseline).

Table: daily_spend

Column	Type
user_id	INT
spend_date	DATE
total_spend	DECIMAL

(One row per user per day; assume no gaps.)

Task: Output user_id, spend_date, total_spend, trailing_7day_avg, is_anomaly — flagging only days where a full 7-day trailing window actually exists (don't flag/evaluate the first 7 days of a user's history where the baseline would be incomplete).
*/
WITH windowed AS (
    SELECT 
        user_id,
        spend_date,
        total_spend,
        AVG(total_spend) OVER (
            PARTITION BY user_id 
            ORDER BY spend_date
            ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING
        ) AS trailing_7day_avg,
        COUNT(*) OVER (
            PARTITION BY user_id 
            ORDER BY spend_date
            ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING
        ) AS days_in_window
    FROM daily_spend
)
SELECT 
    user_id,
    spend_date,
    total_spend,
    ROUND(trailing_7day_avg, 2) AS trailing_7day_avg,
    CASE 
        WHEN total_spend > 3 * trailing_7day_avg THEN 'YES'
        ELSE 'NO'
    END AS is_anomaly
FROM windowed
WHERE days_in_window = 7   -- only evaluate once a full trailing window exists
ORDER BY user_id, spend_date;
