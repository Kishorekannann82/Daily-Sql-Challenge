/*
another one with ans

📌 Challenge 2.0 — Day 42: "Customer Reactivation — Win-Back Campaign Targeting"
Scenario:
You're a Data Analyst at a subscription box company. Marketing wants to target a win-back campaign at customers who were previously active, went quiet, and haven't been re-engaged yet — specifically: customers who had at least 3 orders in any prior 90-day period, then had zero orders in the most recent 90 days. This "high-value churned" segment gets priority over casual one-time buyers who churned.

Table: orders

Column	Type
order_id	INT
customer_id	INT
order_date	DATE
Task: Identify customers matching this exact pattern as of CURRENT_DATE. Output customer_id, best_90day_order_count, last_order_date, days_since_last_order.
*/
WITH customer_orders AS (
    SELECT 
        customer_id,
        order_date
    FROM orders
),
rolling_counts AS (
    -- For every order, count how many orders that same customer placed 
    -- in the 90 days ENDING on this order's date (a rolling trailing window)
    SELECT 
        co1.customer_id,
        co1.order_date AS window_end,
        COUNT(co2.order_date) AS orders_in_window
    FROM customer_orders co1
    JOIN customer_orders co2 
        ON co1.customer_id = co2.customer_id
        AND co2.order_date <= co1.order_date
        AND co2.order_date > co1.order_date - INTERVAL '90 days'
    GROUP BY co1.customer_id, co1.order_date
),
best_window AS (
    SELECT 
        customer_id,
        MAX(orders_in_window) AS best_90day_order_count
    FROM rolling_counts
    GROUP BY customer_id
),
recency AS (
    SELECT 
        customer_id,
        MAX(order_date) AS last_order_date,
        CURRENT_DATE - MAX(order_date) AS days_since_last_order
    FROM customer_orders
    GROUP BY customer_id
)
SELECT 
    bw.customer_id,
    bw.best_90day_order_count,
    r.last_order_date,
    r.days_since_last_order
FROM best_window bw
JOIN recency r 
    ON bw.customer_id = r.customer_id
WHERE bw.best_90day_order_count >= 3
  AND r.days_since_last_order > 90
ORDER BY bw.best_90day_order_count DESC, r.days_since_last_order DESC;
