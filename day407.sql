/*
Day 13: "Year-over-Year Growth with Missing Months"

Scenario:
You're a Data Analyst at a subscription box company. Leadership wants month-over-month revenue growth %, but the data has a catch — some months have zero orders (not even a row exists for that month), which would silently break a naive LAG() calculation by comparing against the wrong "previous" month.

Table: orders

Column	Type
order_id	INT
order_date	DATE
revenue	DECIMAL

Task: Generate a complete month series (fill gaps with 0 revenue), then calculate revenue, prev_month_revenue, and mom_growth_pct for each month, correctly reflecting real calendar-adjacent months — not just "the previous row that happened to have data."
*/
WITH RECURSIVE month_series AS (
    SELECT DATE_TRUNC('month', MIN(order_date)) AS month_start
    FROM orders

    UNION ALL

    SELECT month_start + INTERVAL '1 month'
    FROM month_series
    WHERE month_start + INTERVAL '1 month' <= (SELECT DATE_TRUNC('month', MAX(order_date)) FROM orders)
),
monthly_revenue AS (
    SELECT 
        ms.month_start,
        COALESCE(SUM(o.revenue), 0) AS revenue
    FROM month_series ms
    LEFT JOIN orders o 
        ON DATE_TRUNC('month', o.order_date) = ms.month_start
    GROUP BY ms.month_start
),
with_growth AS (
    SELECT 
        month_start,
        revenue,
        LAG(revenue) OVER (ORDER BY month_start) AS prev_month_revenue
    FROM monthly_revenue
)
SELECT 
    month_start,
    revenue,
    prev_month_revenue,
    CASE 
        WHEN prev_month_revenue IS NULL THEN NULL
        WHEN prev_month_revenue = 0 THEN NULL  -- avoid divide-by-zero
        ELSE ROUND((revenue - prev_month_revenue) * 100.0 / prev_month_revenue, 2)
    END AS mom_growth_pct
FROM with_growth
ORDER BY month_start;
