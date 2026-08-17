/*
📌 Challenge 2.0 — Day 10: "Top N Products per Category with Ties"

Scenario:
You're a Data Analyst at an online marketplace. The merchandising team wants a "Top 3 Best-Selling Products per Category" report for the homepage — but if there's a tie in units sold for the 3rd spot, they want all tied products included (not arbitrarily cut off).

Table: products

Column	Type
product_id	INT
product_name	VARCHAR
category	VARCHAR

Table: order_items

Column	Type
order_item_id	INT
product_id	INT
units_sold	INT

Task: Output category, product_name, total_units_sold, rank for the top 3 (or more, if tied) products per category by total units sold.
*/
WITH product_sales AS (
    SELECT 
        p.category,
        p.product_name,
        SUM(oi.units_sold) AS total_units_sold
    FROM products p
    JOIN order_items oi 
        ON p.product_id = oi.product_id
    GROUP BY p.category, p.product_name
),
ranked AS (
    SELECT 
        category,
        product_name,
        total_units_sold,
        RANK() OVER (
            PARTITION BY category 
            ORDER BY total_units_sold DESC
        ) AS rank
    FROM product_sales
)
SELECT 
    category,
    product_name,
    total_units_sold,
    rank
FROM ranked
WHERE rank <= 3
ORDER BY category, rank, product_name;
