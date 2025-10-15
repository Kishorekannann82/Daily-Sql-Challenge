/*
Monthly Sales Growth Rate per Product

Scenario:
You have the following table:

sales

product_id	sale_date	amount
101	2024-01-10	500
101	2024-02-12	800
101	2024-03-05	1000
102	2024-01-15	400
102	2024-03-20	900
103	2024-01-18	300
103	2024-02-25	450
❓Question:

Write a SQL query to find the month-over-month (MoM) sales growth percentage for each product.

Return:

product_id

month (YYYY-MM)

total_sales

previous_month_sales

growth_rate (%)

(growth_rate = ((current - previous) / previous) * 100)

✅ Expected Answer (SQL Solution)
*/
WITH monthly_sales AS (
    SELECT
        product_id,
        DATE_FORMAT(sale_date, '%Y-%m') AS month,
        SUM(amount) AS total_sales
    FROM sales
    GROUP BY product_id, DATE_FORMAT(sale_date, '%Y-%m')
),
growth_calc AS (
    SELECT
        product_id,
        month,
        total_sales,
        LAG(total_sales) OVER (PARTITION BY product_id ORDER BY month) AS previous_month_sales
    FROM monthly_sales
)
SELECT
    product_id,
    month,
    total_sales,
    previous_month_sales,
    ROUND(
        CASE 
            WHEN previous_month_sales IS NULL THEN NULL
            ELSE ((total_sales - previous_month_sales) / previous_month_sales) * 100
        END, 2
    ) AS growth_rate
FROM growth_calc
ORDER BY product_id, month;
