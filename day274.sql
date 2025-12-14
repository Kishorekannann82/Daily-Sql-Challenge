/*
Detect Daily Sales Anomalies vs Seasonal Baseline
Scenario

You track daily sales across multiple weeks.
A day is considered an anomaly if its sales deviate significantly from the historical average for the same weekday.

daily_sales

sale_date	sales
2024-01-01	1000
2024-01-08	980
2024-01-15	1020
2024-01-22	3000
2024-01-02	900
2024-01-09	920
2024-01-16	910
2024-01-23	880
2024-01-03	950
2024-01-10	970
2024-01-17	960
2024-01-24	940
❓Goal

For each date:

Compute the average sales for that weekday (Mon vs Tue vs Wed, etc.)

Compute percentage deviation from that weekday’s average

Flag anomalies where |deviation| > 50%

Return

sale_date

weekday

sales

weekday_avg

pct_deviation

anomaly_flag

✅ Expected SQL Answer

(PostgreSQL / MySQL 8+ compatible)
*/


WITH enriched AS (
    SELECT
        sale_date,
        sales,
        DAYOFWEEK(sale_date) AS weekday
    FROM daily_sales
),
weekday_stats AS (
    SELECT
        weekday,
        AVG(sales) AS weekday_avg
    FROM enriched
    GROUP BY weekday
)
SELECT
    e.sale_date,
    e.weekday,
    e.sales,
    ROUND(w.weekday_avg, 2) AS weekday_avg,
    ROUND((e.sales - w.weekday_avg) * 100.0 / w.weekday_avg, 2) AS pct_deviation,
    CASE
        WHEN ABS((e.sales - w.weekday_avg) / w.weekday_avg) > 0.50
            THEN 'YES'
        ELSE 'NO'
    END AS anomaly_flag
FROM enriched e
JOIN weekday_stats w
  ON e.weekday = w.weekday
ORDER BY e.sale_date;