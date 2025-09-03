/*
🧠 Challenge: Highest Spending Customer
🗃️ Tables:
*/
Customers (
  customer_id INT,
  customer_name VARCHAR(50)
)

Orders (
  order_id INT,
  customer_id INT,
  total_amount DECIMAL(10,2),
  order_date DATE
)
/*
🎯 Task:

Find the customer who spent the most in total (sum of all their orders).
*/
SELECT 
    c.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o 
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC
LIMIT 1;
