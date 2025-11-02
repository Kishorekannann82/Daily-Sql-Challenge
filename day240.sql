/*
Detect Sudden Sales Spikes (Day-over-Day Growth)

Scenario:
You have a daily sales summary table:

daily_sales

sale_date	total_sales
2024-01-01	1000
2024-01-02	1100
2024-01-03	1200
2024-01-04	3500
2024-01-05	1250
2024-01-06	1300
2024-01-07	3000
❓Question:

Write a SQL query to:

Calculate day-over-day percentage growth in total sales.

Identify days where sales spiked by more than 100% compared to the previous day.

Return:

sale_date

total_sales

previous_day_sales

pct_change

spike_flag ('YES' if >100% growth, else 'NO')

✅ Expected Answer (SQL Solution)
*/
WITH sales_trends AS (
    SELECT
        sale_date,
        total_sales,
        LAG(total_sales) OVER (ORDER BY sale_date) AS previous_day_sales
    FROM daily_sales
)
SELECT
    sale_date,
    total_sales,
    previous_day_sales,
    ROUND(
        ( (total_sales - previous_day_sales) / previous_day_sales ) * 100, 2
    ) AS pct_change,
    CASE 
        WHEN previous_day_sales IS NULL THEN 'NO'
        WHEN ( (total_sales - previous_day_sales) / previous_day_sales ) > 1 THEN 'YES'
        ELSE 'NO'
    END AS spike_flag
FROM sales_trends
ORDER BY sale_date;