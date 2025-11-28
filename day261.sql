/*
Detect Outliers in Sales Using Z-Scores
Scenario

You have a table with daily sales for multiple stores:

daily_sales

store_id	sale_date	sales
1	2024-01-01	1000
1	2024-01-02	1050
1	2024-01-03	3000
1	2024-01-04	1100
2	2024-01-01	800
2	2024-01-02	820
2	2024-01-03	830
2	2024-01-04	850
Goal

For each store:

Compute mean and standard deviation of sales

Compute Z-Score per day

Flag rows where |z_score| > 2.0 as anomalies

Columns to return

store_id

sale_date

sales

z_score

anomaly_flag

✅ Expected SQL Answer (ANSI / Postgres / MySQL 8+)
*/
WITH stats AS (
    SELECT
        store_id,
        AVG(sales) AS mean_sales,
        STDDEV_POP(sales) AS std_sales
    FROM daily_sales
    GROUP BY store_id
),
scored AS (
    SELECT
        d.store_id,
        d.sale_date,
        d.sales,
        (d.sales - s.mean_sales) / s.std_sales AS z_score
    FROM daily_sales d
    JOIN stats s
    ON d.store_id = s.store_id
)
SELECT
    store_id,
    sale_date,
    sales,
    ROUND(z_score, 2) AS z_score,
    CASE WHEN ABS(z_score) > 2.0 THEN 'YES' ELSE 'NO' END AS anomaly_flag
FROM scored
ORDER BY store_id, sale_date;