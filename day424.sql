/*
📌 Challenge 2.0 — Day 30: "Inventory Turnover with Multiple Warehouses"

Scenario:
You're a Data Analyst at a retail chain with multiple warehouses. Supply chain wants to identify products that are slow-moving in one warehouse but fast-moving in another — a strong signal to rebalance stock between locations instead of reordering blindly.

Table: warehouse_stock

Column	Type
warehouse_id	INT
product_id	INT
current_stock	INT

Table: warehouse_sales

Column	Type
warehouse_id	INT
product_id	INT
sale_date	DATE
units_sold	INT

Task: For each product, calculate 30-day units sold and days-of-stock-remaining (current_stock / (30day_units_sold / 30.0)) per warehouse. Flag products where the max days-of-stock across warehouses is more than 3x the min days-of-stock across warehouses for that product (a clear imbalance). Output product_id, warehouse_id, current_stock, units_sold_30d, days_of_stock, imbalance_flag.
*/
WITH recent_sales AS (
    SELECT 
        warehouse_id,
        product_id,
        SUM(units_sold) AS units_sold_30d
    FROM warehouse_sales
    WHERE sale_date >= CURRENT_DATE - INTERVAL '30 days'
    GROUP BY warehouse_id, product_id
),
combined AS (
    SELECT 
        ws.warehouse_id,
        ws.product_id,
        ws.current_stock,
        COALESCE(rs.units_sold_30d, 0) AS units_sold_30d,
        CASE 
            WHEN COALESCE(rs.units_sold_30d, 0) = 0 THEN NULL  -- no sales = can't estimate turnover
            ELSE ws.current_stock / (rs.units_sold_30d / 30.0)
        END AS days_of_stock
    FROM warehouse_stock ws
    LEFT JOIN recent_sales rs 
        ON ws.warehouse_id = rs.warehouse_id
        AND ws.product_id = rs.product_id
),
product_range AS (
    SELECT 
        product_id,
        MAX(days_of_stock) AS max_days,
        MIN(days_of_stock) AS min_days
    FROM combined
    WHERE days_of_stock IS NOT NULL
    GROUP BY product_id
    HAVING COUNT(*) > 1   -- only makes sense to compare across 2+ warehouses
)
SELECT 
    c.product_id,
    c.warehouse_id,
    c.current_stock,
    c.units_sold_30d,
    ROUND(c.days_of_stock, 1) AS days_of_stock,
    CASE 
        WHEN pr.min_days > 0 AND pr.max_days > pr.min_days * 3 THEN 'YES'
        ELSE 'NO'
    END AS imbalance_flag
FROM combined c
JOIN product_range pr 
    ON c.product_id = pr.product_id
ORDER BY c.product_id, c.warehouse_id;
