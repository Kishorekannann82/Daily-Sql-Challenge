/*
📌 Challenge 2.0 — Day 38: "Weighted Inventory Aging (FIFO Cost Estimation)"

Scenario:
You're a Data Analyst at a warehouse/distribution company. Finance wants to estimate the cost of goods sold (COGS) using FIFO (First In, First Out) — meaning when units are sold, they're assumed to come from the oldest purchase batches first. This matters because purchase costs fluctuate over time.

Table: purchases

Column	Type
purchase_id	INT
product_id	INT
purchase_date	DATE
units_purchased	INT
unit_cost	DECIMAL

Table: sales

Column	Type
sale_id	INT
product_id	INT
sale_date	DATE
units_sold	INT

Task: For each sale, determine the FIFO cost — i.e., "consume" units from the oldest available purchase batches first (a sale can span multiple batches if one batch doesn't have enough units left). Output sale_id, product_id, units_sold, fifo_cost (total cost of goods for that sale).
*/
WITH purchase_running AS (
    SELECT 
        product_id,
        purchase_id,
        purchase_date,
        unit_cost,
        units_purchased,
        SUM(units_purchased) OVER (
            PARTITION BY product_id ORDER BY purchase_date, purchase_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS running_units_in,
        SUM(units_purchased) OVER (
            PARTITION BY product_id ORDER BY purchase_date, purchase_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ) AS running_units_before
    FROM purchases
),
sales_running AS (
    SELECT 
        sale_id,
        product_id,
        sale_date,
        units_sold,
        SUM(units_sold) OVER (
            PARTITION BY product_id ORDER BY sale_date, sale_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS running_units_sold_end,
        SUM(units_sold) OVER (
            PARTITION BY product_id ORDER BY sale_date, sale_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ) AS running_units_sold_start
    FROM sales
),
matched AS (
    -- Overlap each sale's [start,end) consumption range with each batch's [start,end) supply range
    SELECT 
        sr.sale_id,
        sr.product_id,
        sr.units_sold,
        pr.purchase_id,
        pr.unit_cost,
        LEAST(sr.running_units_sold_end, pr.running_units_in) 
            - GREATEST(COALESCE(sr.running_units_sold_start, 0), COALESCE(pr.running_units_before, 0)) AS units_from_this_batch
    FROM sales_running sr
    JOIN purchase_running pr 
        ON sr.product_id = pr.product_id
    WHERE pr.running_units_in > COALESCE(sr.running_units_sold_start, 0)
      AND COALESCE(pr.running_units_before, 0) < sr.running_units_sold_end
)
SELECT 
    sale_id,
    product_id,
    MAX(units_sold) AS units_sold,
    SUM(units_from_this_batch * unit_cost) AS fifo_cost
FROM matched
WHERE units_from_this_batch > 0
GROUP BY sale_id, product_id
ORDER BY sale_id;
