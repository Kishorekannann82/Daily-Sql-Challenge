/*
🧠 Challenge: Top 3 Most Recent Orders per Customer
🗃️ Table: Orders
*/
Orders (
  order_id INT,
  customer_id INT,
  order_date DATE,
  total_amount DECIMAL(10, 2)
)
/*
🎯 Task:
For each customer, return their top 3 most recent orders (based on order_date).
If a customer has fewer than 3 orders, return all of them.
*/
SELECT customer_id, order_id, order_date, total_amount
FROM (
    SELECT 
        customer_id,
        order_id,
        order_date,
        total_amount,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS rn
    FROM Orders
) ranked
WHERE rn <= 3
ORDER BY customer_id, rn;