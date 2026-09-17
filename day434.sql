/*
📌 Challenge 2.0 — Day 40: "Warehouse Slotting — Products Never Sold Together vs Always Sold Together"

Scenario:
You're a Data Analyst at a fulfillment center. Warehouse ops wants to optimize shelf placement: products that are frequently ordered together should be placed near each other (reduces picker walk time), while products that are never ordered together can safely share the same slot in different bins without picking conflicts.

Table: order_items

Column	Type
order_id	INT
product_id	INT

Task: For a given pair of products (say product A and product B), calculate the Jaccard similarity of their order sets: (orders containing BOTH A and B) / (orders containing A OR B). Do this for all pairs of products that have appeared in at least one order together. Output product_1, product_2, orders_with_both, orders_with_either, jaccard_similarity — sorted by similarity descending.
*/
WITH product_orders AS (
    SELECT DISTINCT product_id, order_id
    FROM order_items
),
pairs_together AS (
    SELECT 
        po1.product_id AS product_1,
        po2.product_id AS product_2,
        COUNT(DISTINCT po1.order_id) AS orders_with_both
    FROM product_orders po1
    JOIN product_orders po2 
        ON po1.order_id = po2.order_id
        AND po1.product_id < po2.product_id   -- avoid duplicate pairs + self-pairing
    GROUP BY po1.product_id, po2.product_id
),
product_order_counts AS (
    SELECT 
        product_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM product_orders
    GROUP BY product_id
)
SELECT 
    pt.product_1,
    pt.product_2,
    pt.orders_with_both,
    (poc1.total_orders + poc2.total_orders - pt.orders_with_both) AS orders_with_either,
    ROUND(
        pt.orders_with_both * 1.0 
        / (poc1.total_orders + poc2.total_orders - pt.orders_with_both), 
        4
    ) AS jaccard_similarity
FROM pairs_together pt
JOIN product_order_counts poc1 ON pt.product_1 = poc1.product_id
JOIN product_order_counts poc2 ON pt.product_2 = poc2.product_id
ORDER BY jaccard_similarity DESC;
