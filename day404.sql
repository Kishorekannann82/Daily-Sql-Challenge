/*
Day 11: "Median Order Value per Region"

Scenario:
You're a Data Analyst at an e-commerce company. Finance doesn't trust averages anymore because a few huge B2B orders skew the numbers — they want the median order value per region instead, since it's resistant to outliers.

Table: orders

Column	Type
order_id	INT
region	VARCHAR
order_value	DECIMAL

Task: Calculate the median order_value for each region. Handle both even and odd counts of orders correctly (median of an even-count set = average of the two middle values). Output region, median_order_value.
*/
WITH ranked AS (
    SELECT 
        region,
        order_value,
        ROW_NUMBER() OVER (PARTITION BY region ORDER BY order_value) AS rn_asc,
        COUNT(*) OVER (PARTITION BY region) AS total_count
    FROM orders
)
SELECT 
    region,
    ROUND(AVG(order_value), 2) AS median_order_value
FROM ranked
WHERE rn_asc IN (
    FLOOR((total_count + 1) / 2.0),
    CEIL((total_count + 1) / 2.0)
)
GROUP BY region
ORDER BY region;
