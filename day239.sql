/*
Calculate Customer Lifetime Value (CLV)

Scenario:
You have two tables:

customers

customer_id	customer_name	signup_date
1	Alice	2024-01-01
2	Bob	2024-02-10
3	Carol	2024-02-15
4	David	2024-03-05

orders

order_id	customer_id	order_date	amount
101	1	2024-01-15	200
102	1	2024-02-20	300
103	1	2024-03-18	250
104	2	2024-02-20	400
105	2	2024-03-01	200
106	3	2024-03-10	100
107	4	2024-03-25	150
❓Question:

Write a SQL query to calculate each customer’s:

Total lifetime revenue (sum of all orders)

First and last order date

Lifetime duration (days between first and last order)

Return:

customer_id

customer_name

total_revenue

first_order_date

last_order_date

lifetime_days

✅ Expected Answer (SQL Solution)
*/
WITH customer_orders AS (
    SELECT
        c.customer_id,
        c.customer_name,
        MIN(o.order_date) AS first_order_date,
        MAX(o.order_date) AS last_order_date,
        SUM(o.amount) AS total_revenue
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_id,
    customer_name,
    total_revenue,
    first_order_date,
    last_order_date,
    DATEDIFF(last_order_date, first_order_date) AS lifetime_days
FROM customer_orders
ORDER BY total_revenue DESC;