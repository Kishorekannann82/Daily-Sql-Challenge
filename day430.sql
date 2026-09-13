/*
📌 Challenge 2.0 — Day 36: "Detecting Price Changes and Impact on Sales Velocity"

Scenario:
You're a Data Analyst at a retail company. Pricing wants to know: every time a product's price changed, did sales velocity go up or down in the following week compared to the week before? This feeds a "price elasticity" report.

Table: price_history

Column	Type
product_id	INT
price	DECIMAL
effective_date	DATE

Table: daily_sales

Column	Type
product_id	INT
sale_date	DATE
units_sold	INT

Task: For every price change (a row in price_history where the price differs from the previous price for that product), compute total units_sold in the 7 days before and 7 days after the effective_date. Output product_id, effective_date, old_price, new_price, units_before, units_after, velocity_change_pct.
*/
WITH price_changes AS (
    SELECT 
        product_id,
        price AS new_price,
        LAG(price) OVER (
            PARTITION BY product_id ORDER BY effective_date
        ) AS old_price,
        effective_date
    FROM price_history
),
real_changes AS (
    SELECT *
    FROM price_changes
    WHERE old_price IS NOT NULL 
      AND new_price != old_price   -- skip rows where price was re-entered but unchanged
),
sales_before AS (
    SELECT 
        rc.product_id,
        rc.effective_date,
        SUM(ds.units_sold) AS units_before
    FROM real_changes rc
    JOIN daily_sales ds 
        ON rc.product_id = ds.product_id
        AND ds.sale_date >= rc.effective_date - INTERVAL '7 days'
        AND ds.sale_date < rc.effective_date
    GROUP BY rc.product_id, rc.effective_date
),
sales_after AS (
    SELECT 
        rc.product_id,
        rc.effective_date,
        SUM(ds.units_sold) AS units_after
    FROM real_changes rc
    JOIN daily_sales ds 
        ON rc.product_id = ds.product_id
        AND ds.sale_date >= rc.effective_date
        AND ds.sale_date < rc.effective_date + INTERVAL '7 days'
    GROUP BY rc.product_id, rc.effective_date
)
SELECT 
    rc.product_id,
    rc.effective_date,
    rc.old_price,
    rc.new_price,
    COALESCE(sb.units_before, 0) AS units_before,
    COALESCE(sa.units_after, 0) AS units_after,
    ROUND(
        (COALESCE(sa.units_after, 0) - COALESCE(sb.units_before, 0)) * 100.0 
            / NULLIF(sb.units_before, 0), 
        2
    ) AS velocity_change_pct
FROM real_changes rc
LEFT JOIN sales_before sb 
    ON rc.product_id = sb.product_id AND rc.effective_date = sb.effective_date
LEFT JOIN sales_after sa 
    ON rc.product_id = sa.product_id AND rc.effective_date = sa.effective_date
ORDER BY rc.product_id, rc.effective_date;
