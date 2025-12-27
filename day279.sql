/*
Find the Best Performing Product per Month (with Tie-Break Rules)
Scenario

You have monthly product sales data:

product_sales

product_id	month	revenue	units_sold
101	2024-01	5000	50
102	2024-01	5000	45
103	2024-01	4500	60
101	2024-02	6000	55
102	2024-02	6000	65
103	2024-02	6000	60
101	2024-03	7000	70
102	2024-03	6500	75
103	2024-03	7000	65
📌 Ranking Rules

For each month, rank products by:

1️⃣ Higher revenue
2️⃣ If revenue ties → higher units_sold
3️⃣ If still tied → lowest product_id wins

❓ Goal

Return only the best product per month with:

month

product_id

revenue

units_sold

✅ Expected SQL Answer

(Works in MySQL 8+, Postgres, SQL Server)
*/

WITH ranked AS (
    SELECT
        month,
        product_id,
        revenue,
        units_sold,
        ROW_NUMBER() OVER (
            PARTITION BY month
            ORDER BY 
                revenue DESC,
                units_sold DESC,
                product_id ASC
        ) AS rn
    FROM product_sales
)
SELECT
    month,
    product_id,
    revenue,
    units_sold