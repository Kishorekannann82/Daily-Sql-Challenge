/*
📌 Challenge 2.0 — Day 34: "Basket Analysis — Frequently Bought Together"

Scenario:
You're a Data Analyst at an online grocery store. Merchandising wants a "customers who bought X also bought Y" feature for product pages — specifically, the top product pairs that appear together in the same order, ranked by how often they co-occur.

Table: order_items

Column	Type
order_id	INT
product_id	INT
product_name	VARCHAR

(One row per product per order — a customer buying 3 items in one order = 3 rows with the same order_id.)

Task: Find all product pairs that appear together in the same order, count how often each pair co-occurs, and output the top 20 pairs by co-occurrence count. Output product_1, product_2, co_occurrence_count — each pair listed once (not twice in both directions).

*/
WITH pairs AS (
    SELECT 
        oi1.order_id,
        oi1.product_name AS product_1,
        oi2.product_name AS product_2
    FROM order_items oi1
    JOIN order_items oi2 
        ON oi1.order_id = oi2.order_id
        AND oi1.product_id < oi2.product_id   -- avoid duplicate pairs + self-pairing
)
SELECT 
    product_1,
    product_2,
    COUNT(*) AS co_occurrence_count
FROM pairs
GROUP BY product_1, product_2
ORDER BY co_occurrence_count DESC
LIMIT 20;
