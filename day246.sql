/*
Calculate Active, Inactive & New Customers by Month

Scenario:
You have a table orders that logs each customer’s purchase dates:

customer_id	order_date
1	2024-01-05
1	2024-02-10
1	2024-03-15
2	2024-01-12
2	2024-03-20
3	2024-02-01
4	2024-03-05
5	2024-03-22
Definitions:

For each month:

New Customer: First purchase in that month

Active Customer: Made a purchase in that month and prior months

Inactive Customer: Purchased before, but not in the current month

❓Question:

Write a SQL query showing for each month:

month

new_customers

active_customers

inactive_customers

✅ Expected Answer (SQL Solution)
*/
WITH customer_months AS (
    SELECT
        customer_id,
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        MIN(DATE_FORMAT(order_date, '%Y-%m')) OVER (PARTITION BY customer_id) AS first_month
    FROM orders
    GROUP BY customer_id, DATE_FORMAT(order_date, '%Y-%m')
),
all_months AS (
    SELECT DISTINCT month FROM customer_months
)
SELECT
    m.month,
    COUNT(CASE WHEN cm.month = cm.first_month THEN cm.customer_id END) AS new_customers,
    COUNT(CASE WHEN cm.month > cm.first_month THEN cm.customer_id END) AS active_customers,
    (
        SELECT COUNT(DISTINCT customer_id)
        FROM customer_months cm2
        WHERE cm2.month < m.month
          AND cm2.customer_id NOT IN (
              SELECT customer_id FROM customer_months WHERE month = m.month
          )
    ) AS inactive_customers
FROM all_months m
LEFT JOIN customer_months cm ON cm.month = m.month
GROUP BY m.month
ORDER BY m.month;
