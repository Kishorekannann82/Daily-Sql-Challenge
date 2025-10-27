/*
3-Month Moving Average of Monthly Sales

Scenario:
You have a table sales that tracks total sales per month:

month	total_sales
2024-01	1000
2024-02	1200
2024-03	1500
2024-04	1300
2024-05	1600
2024-06	1700
❓Question:

Write a SQL query to calculate a 3-month moving average of sales.

For each month, show:

month

total_sales

moving_avg (average of current and previous 2 months’ sales)

✅ Expected Answer (SQL Solution)
*/

SELECT
    month,
    total_sales,
    ROUND(
        AVG(total_sales) OVER (
            ORDER BY month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ), 2
    ) AS moving_avg
FROM sales
ORDER BY month;