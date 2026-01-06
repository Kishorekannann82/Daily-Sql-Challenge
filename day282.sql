Rolling Top-2 Products by Revenue (Last 3 Months)
Scenario

You track monthly revenue per product.

monthly_sales

month	product_id	revenue
2024-01	101	500
2024-01	102	700
2024-01	103	600
2024-02	101	800
2024-02	102	400
2024-02	103	900
2024-03	101	1000
2024-03	102	600
2024-03	103	500
2024-04	101	900
2024-04	102	1100
2024-04	103	700
📌 Rules

For each month:
1️⃣ Look at the current month + previous 2 months
2️⃣ Compute total revenue per product in that window
3️⃣ Rank products by window revenue
4️⃣ Return Top-2 products per month

❓ Goal

Return:

month

product_id

rolling_3_month_revenue

rank

✅ Expected SQL Answer

(Works in Postgres / MySQL 8+ / SQL Server)

WITH expanded AS (
    SELECT
        m1.month AS report_month,
        m2.product_id,
        SUM(m2.revenue) AS rolling_3_month_revenue
    FROM monthly_sales m1
    JOIN monthly_sales m2
      ON m2.month BETWEEN 
         DATE_FORMAT(DATE_SUB(CONCAT(m1.month, '-01'), INTERVAL 2 MONTH), '%Y-%m')
         AND m1.month
    GROUP BY m1.month, m2.product_id
),
ranked AS (
    SELECT
        report_month AS month,
        product_id,
        rolling_3_month_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY report_month
            ORDER BY rolling_3_month_revenue DESC
        ) AS rnk
    FROM expanded
)
SELECT
    month,
    product_id,
    rolling_3_month_revenue,
    rnk AS rank
FROM ranked
WHERE rnk <= 2
ORDER BY month, rank;
