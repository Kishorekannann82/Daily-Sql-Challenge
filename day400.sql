/*
Day 7: "ABC Inventory Classification"

Scenario:
You're a Data Analyst at a retail chain. The inventory team uses ABC analysis to prioritize stock management:

Class A = top products contributing to the first 70% of cumulative revenue
Class B = next products contributing up to 90% cumulative revenue
Class C = remaining products (last 10%)

Table: sales

Column	Type
sale_id	INT
product_id	INT
revenue	DECIMAL

Task: Classify every product into A, B, or C based on its contribution to cumulative revenue (products ranked highest revenue first). Output product_id, total_revenue, revenue_pct, cumulative_pct, class.

*/

WITH product_revenue AS (
    SELECT 
        product_id,
        SUM(revenue) AS total_revenue
    FROM sales
    GROUP BY product_id
),
total AS (
    SELECT SUM(total_revenue) AS grand_total
    FROM product_revenue
),
ranked AS (
    SELECT 
        pr.product_id,
        pr.total_revenue,
        ROUND(pr.total_revenue * 100.0 / t.grand_total, 2) AS revenue_pct,
        SUM(pr.total_revenue) OVER (
            ORDER BY pr.total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) * 100.0 / t.grand_total AS cumulative_pct
    FROM product_revenue pr
    CROSS JOIN total t
)
SELECT 
    product_id,
    total_revenue,
    revenue_pct,
    ROUND(cumulative_pct, 2) AS cumulative_pct,
    CASE 
        WHEN cumulative_pct <= 70 THEN 'A'
        WHEN cumulative_pct <= 90 THEN 'B'
        ELSE 'C'
    END AS class
FROM ranked
ORDER BY total_revenue DESC;
