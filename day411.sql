/*
Day 17: "Inventory Reorder Point with Rolling Average Demand"

Scenario:
You're a Data Analyst at a warehouse ops team. To avoid stockouts, they want to flag products that need reordering today — defined as: current stock is less than 7 days' worth of demand, where "daily demand" is the rolling 14-day average of units sold (not just yesterday's number, which is too noisy).

Table: daily_sales

Column	Type
product_id	INT
sale_date	DATE
units_sold	INT

Table: inventory

Column	Type
product_id	INT
current_stock	INT
as_of_date	DATE

Task: For each product, compute the rolling 14-day average demand as of the most recent sale date, then flag it if current_stock < avg_daily_demand * 7. Output product_id, avg_daily_demand, current_stock, days_of_stock_left, needs_reorder.
*/
WITH ranked_sales AS (
    SELECT 
        product_id,
        sale_date,
        units_sold,
        ROW_NUMBER() OVER (
            PARTITION BY product_id 
            ORDER BY sale_date DESC
        ) AS rn
    FROM daily_sales
),
rolling_avg AS (
    SELECT 
        product_id,
        AVG(units_sold) AS avg_daily_demand
    FROM ranked_sales
    WHERE rn <= 14
    GROUP BY product_id
)
SELECT 
    ra.product_id,
    ROUND(ra.avg_daily_demand, 2) AS avg_daily_demand,
    i.current_stock,
    ROUND(i.current_stock / NULLIF(ra.avg_daily_demand, 0), 2) AS days_of_stock_left,
    CASE 
        WHEN i.current_stock < ra.avg_daily_demand * 7 THEN 'YES'
        ELSE 'NO'
    END AS needs_reorder
FROM rolling_avg ra
JOIN inventory i 
    ON ra.product_id = i.product_id
ORDER BY days_of_stock_left ASC;
