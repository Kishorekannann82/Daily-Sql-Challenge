/*
🧠 Challenge: First and Last Order Per Customer
🗃️ Tables:
*/
Orders (
  order_id INT,
  customer_id INT,
  order_date DATE,
  total_amount DECIMAL(10,2)
)
/*
Orders (
  order_id INT,
  customer_id INT,
  order_date DATE,
  total_amount DECIMAL(10,2)
)

*/
SELECT 
    customer_id,
    MIN(order_date) AS first_order,
    MAX(order_date) AS last_order
FROM Orders
GROUP BY customer_id;
-- End of code