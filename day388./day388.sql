/*
📌 Challenge 2.0 — Day 5: "Product Return Rate Analysis"

Scenario:
You're a Data Analyst at an e-commerce company. The ops team wants to identify products with an unusually high return rate — specifically, products where returns make up more than 15% of total orders, but only consider products with a meaningful order volume (at least 20 orders) to avoid noise from low-sample products.

Table: orders

Column	Type
order_id	INT
product_id	INT
order_date	DATE
quantity	INT

Table: returns

Column	Type
return_id	INT
order_id	INT
return_date	DATE

Task: Output product_id, total_orders, total_returns, return_rate (as a percentage, rounded to 2 decimals) for products meeting both conditions above, sorted by return_rate descending.
*/
WITH order_counts AS (
    SELECT 
        product_id,
        COUNT(*) AS total_orders
    FROM orders
    GROUP BY product_id
),
return_counts AS (
    SELECT 
        o.product_id,
        COUNT(DISTINCT r.return_id) AS total_returns
    FROM orders o
    JOIN returns r 
        ON o.order_id = r.order_id
    GROUP BY o.product_id
)
SELECT 
    oc.product_id,
    oc.total_orders,
    COALESCE(rc.total_returns, 0) AS total_returns,
    ROUND(COALESCE(rc.total_returns, 0) * 100.0 / oc.total_orders, 2) AS return_rate
FROM order_counts oc
LEFT JOIN return_counts rc 
    ON oc.product_id = rc.product_id
WHERE oc.total_orders >= 20
  AND (COALESCE(rc.total_returns, 0) * 100.0 / oc.total_orders) > 15
ORDER BY return_rate DESC;
