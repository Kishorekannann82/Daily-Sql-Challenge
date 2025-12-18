/*Forecast Trend Using Moving Averages (7-day vs 30-day)
Scenario

You track daily sales for a product:

daily_sales

sale_date	sales
2024-01-01	100
2024-01-02	105
2024-01-03	110
2024-01-04	120
2024-01-05	130
2024-01-06	140
2024-01-07	150
2024-01-08	155
2024-01-09	160
2024-01-10	170
❓ Goal

For each day:

Compute 7-day moving average

Compute 30-day moving average

Detect trend direction:

UPTREND if 7-day MA > 30-day MA

DOWNTREND if 7-day MA < 30-day MA

FLAT otherwise

Return:

sale_date

sales

ma_7

ma_30

trend

✅ Expected SQL Answer

(Works in Postgres / MySQL 8+ / SQL Server)
*/

SELECT
    sale_date,
    sales,
    ROUND(
        AVG(sales) OVER (
            ORDER BY sale_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ), 2
    ) AS ma_7,
    ROUND(
        AVG(sales) OVER (
            ORDER BY sale_date
            ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
        ), 2
    ) AS ma_30,
    CASE
        WHEN
            AVG(sales) OVER (
                ORDER BY sale_date
                ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
            )
            >
            AVG(sales) OVER (
                ORDER BY sale_date
                ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
            )
        THEN 'UPTREND'
        WHEN
            AVG(sales) OVER (
                ORDER BY sale_date
                ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
            )
            <
            AVG(sales) OVER (
                ORDER BY sale_date
                ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
            )
        THEN 'DOWNTREND'
        ELSE 'FLAT'
    END AS trend
FROM daily_sales
ORDER BY sale_date;