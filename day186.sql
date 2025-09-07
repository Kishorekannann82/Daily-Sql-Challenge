/*
🧠 Challenge: Customers with Consecutive Orders Within 7 Days
🗃️ Table:
*/
Orders (
  order_id INT,
  customer_id INT,
  order_date DATE,
  total_amount DECIMAL(10,2)
)
/*
🎯 Task:

Find all customers who placed two or more consecutive orders within 7 days of each other.
*/
SELECT 
    customer_id,
    order_id,
    order_date,
    LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order_date
FROM Orders
QUALIFY DATEDIFF(order_date, LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date)) <= 7;
