/*
Feature Engineering for Customer Purchase Behavior
Scenario

You have a transaction table:

orders

order_id	customer_id	order_date	amount
1	101	2024-01-01	120
2	101	2024-01-15	300
3	101	2024-02-10	150
4	102	2024-01-05	50
5	102	2024-01-20	60
6	103	2024-01-02	500
7	103	2024-03-01	1000
❓Goal: Build ML features per customer

Compute:

1️⃣ Total Revenue
2️⃣ Average Order Value
3️⃣ Order Frequency (orders per month)
4️⃣ Recency Score

Days since last order from today '2024-04-01'
5️⃣ Normalized Revenue Z-Score across all customers

Final Columns

customer_id

total_revenue

avg_order_value

order_frequency

recency_days

revenue_z_score

✅ Expected SQL Answer

(Postgres / MySQL 8 / SQL Server compatible)
*/

WITH base AS (
    SELECT
        customer_id,
        SUM(amount) AS total_revenue,
        AVG(amount) AS avg_order_value,
        COUNT(*) AS total_orders,
        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order
    FROM orders
    GROUP BY customer_id
),
freq AS (
    SELECT
        customer_id,
        total_revenue,
        avg_order_value,
        total_orders,
        last_order,
        -- orders per month
        total_orders * 1.0 /
        (TIMESTAMPDIFF(MONTH, first_order, '2024-04-01') + 1) AS order_frequency,
        DATEDIFF('2024-04-01', last_order) AS recency_days
    FROM base
),
stats AS (
    SELECT
        AVG(total_revenue) AS mean_rev,
        STDDEV_POP(total_revenue) AS std_rev
    FROM freq
)
SELECT
    f.customer_id,
    f.total_revenue,
    ROUND(f.avg_order_value, 2) AS avg_order_value,
    ROUND(f.order_frequency, 2) AS order_frequency,
    f.recency_days,
    ROUND((f.total_revenue - s.mean_rev) / s.std_rev, 2) AS revenue_z_score
FROM freq f CROSS JOIN stats s
ORDER BY f.customer_id;
