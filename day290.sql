/*
Calculate Customer Lifetime Value (CLV)
Scenario

You track customer purchases over time.

orders

order_id	customer_id	order_date	amount
1	101	2024-01-01	100
2	101	2024-01-20	150
3	101	2024-02-15	200
4	102	2024-01-10	80
5	102	2024-03-05	120
6	103	2024-02-01	300
7	103	2024-02-18	250
8	103	2024-03-20	400

📌 Business Assumptions

Observation window ends on 2024-04-01

CLV approximation formula:

CLV = Average Order Value
    × Purchase Frequency (orders per month)
    × Customer Lifespan (months active)


Where:

Customer lifespan = months between first & last order

Purchase frequency = total_orders / lifespan_months

❓ Goal

Compute CLV per customer.

Return:

customer_id

total_revenue

avg_order_value

lifespan_months

purchase_frequency

clv

✅ Expected SQL Answer

(Works in MySQL 8+, Postgres, SQL Server)
*/
WITH base AS (
    SELECT
        customer_id,
        COUNT(*) AS total_orders,
        SUM(amount) AS total_revenue,
        AVG(amount) AS avg_order_value,
        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order
    FROM orders
    GROUP BY customer_id
),
metrics AS (
    SELECT
        customer_id,
        total_revenue,
        avg_order_value,
        TIMESTAMPDIFF(
            MONTH,
            first_order,
            last_order
        ) + 1 AS lifespan_months,
        total_orders * 1.0 /
        (TIMESTAMPDIFF(MONTH, first_order, last_order) + 1)
        AS purchase_frequency
    FROM base
)
SELECT
    customer_id,
    total_revenue,
    ROUND(avg_order_value, 2) AS avg_order_value,
    lifespan_months,
    ROUND(purchase_frequency, 2) AS purchase_frequency,
    ROUND(avg_order_value * purchase_frequency * lifespan_months, 2) AS clv
FROM metrics
ORDER BY clv DESC;