/*
Top Customers by Category Spending

Scenario:
You have the following tables:

orders

order_id	customer_id	order_date
101	1	2024-03-15
102	2	2024-03-18
103	1	2024-03-19
104	3	2024-03-20

order_items

order_id	product_id	quantity	price
101	501	2	25.00
101	502	1	30.00
102	501	3	25.00
103	503	1	50.00
104	504	2	40.00

products

product_id	category
501	Electronics
502	Electronics
503	Furniture
504	Furniture
❓Question:

Write a SQL query to find the top spending customer in each product category based on total purchase amount (quantity × price).

Return:

category

customer_id

total_spent

If there’s a tie, include all customers with the same top spending.

✅ Expected Answer (SQL Solution)
*/

WITH customer_spending AS (
    SELECT 
        p.category,
        o.customer_id,
        SUM(oi.quantity * oi.price) AS total_spent
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.category, o.customer_id
),
ranked AS (
    SELECT 
        category,
        customer_id,
        total_spent,
        RANK() OVER (PARTITION BY category ORDER BY total_spent DESC) AS rnk
    FROM customer_spending
)
SELECT 
    category,
    customer_id,
    total_spent
FROM ranked
WHERE rnk = 1
ORDER BY category, customer_id;